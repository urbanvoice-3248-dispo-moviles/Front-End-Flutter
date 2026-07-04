import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/di/injection.dart';
import '../../domain/usecases/profile_usecases.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/location_sharing/location_sharing_bloc.dart';

class LocationSharingPage extends StatefulWidget {
  const LocationSharingPage({super.key});

  @override
  State<LocationSharingPage> createState() => _LocationSharingPageState();
}

class _LocationSharingPageState extends State<LocationSharingPage> {
  Timer? _pollingTimer;
  Timer? _publishTimer;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context
          .read<LocationSharingBloc>()
          .add(LoadSharingDataEvent(userId: authState.profile.id));
      _startPolling(authState.profile.id);
    }
  }

  void _startPolling(int userId) {
    _publishTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        context.read<LocationSharingBloc>().add(
              PublishMyLocationEvent(
                latitude: position.latitude,
                longitude: position.longitude,
                userId: userId,
              ),
            );
      }
    });
    _pollingTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) {
        context
            .read<LocationSharingBloc>()
            .add(LoadFriendsLocationsEvent(userId: userId));
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _publishTimer?.cancel();
    super.dispose();
  }

  void _addContact() {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Agregar contacto'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Correo del contacto',
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _shareWithEmail(emailController.text.trim());
            },
            child: const Text('Compartir'),
          ),
        ],
      ),
    );
  }

  Future<void> _shareWithEmail(String email) async {
    if (email.isEmpty) return;
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;

    final bloc = context.read<LocationSharingBloc>();
    final profileResult =
        await sl<GetProfileByEmail>()(email);
    profileResult.fold(
      (_) {
        bloc.add(ClearAddContactErrorEvent());
        Future.microtask(() => _showError('Usuario no encontrado'));
      },
      (profile) {
        bloc.add(StartSharingEvent(
          targetUserId: profile.id,
          userId: authState.profile.id,
        ));
      },
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compartir Ubicación'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _addContact,
            tooltip: 'Agregar contacto',
          ),
        ],
      ),
      body: BlocConsumer<LocationSharingBloc, LocationSharingState>(
        listener: (context, state) {
          if (state.addContactError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.addContactError!),
                backgroundColor: Colors.red,
              ),
            );
            context
                .read<LocationSharingBloc>()
                .add(ClearAddContactErrorEvent());
          }
        },
        builder: (context, state) {
          _updateFriendMarkers(state);

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(-12.0464, -77.0428),
                  zoom: 12,
                ),
                    onMapCreated: (_) {},
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
              if (state.isLoading)
                const Center(child: CircularProgressIndicator()),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    if (state.trustedContacts.isNotEmpty)
                      _buildSectionCard(
                        'Compartiendo con:',
                        state.trustedContacts
                            .map((c) => ListTile(
                                  dense: true,
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                  title: Text(
                                      '${c.name} ${c.lastName}'.trim().isEmpty
                                          ? 'Usuario #${c.userId}'
                                          : '${c.name} ${c.lastName}'),
                                  subtitle: Text(c.email),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.red),
                                    onPressed: () {
                                      final authState = context
                                          .read<AuthBloc>()
                                          .state;
                                      if (authState is AuthAuthenticated) {
                                        context
                                            .read<LocationSharingBloc>()
                                            .add(StopSharingEvent(
                                              targetUserId: c.userId,
                                              userId:
                                                  authState.profile.id,
                                            ));
                                      }
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    if (state.sharedWithMe
                        .where((s) => s.active)
                        .isNotEmpty)
                      _buildSectionCard(
                        'Comparten conmigo:',
                        state.sharedWithMe
                            .where((s) => s.active)
                            .map((s) => ListTile(
                                  dense: true,
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.person_outline),
                                  ),
                                  title:
                                      Text('Usuario #${s.ownerUserId}'),
                                ))
                            .toList(),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          ...children,
        ],
      ),
    );
  }

  void _updateFriendMarkers(LocationSharingState state) {
    _markers.removeWhere((m) => m.markerId.value.startsWith('friend_'));
    for (final loc in state.friendsLocations) {
      _markers.add(
        Marker(
          markerId: MarkerId('friend_${loc.userId}'),
          position: LatLng(loc.latitude, loc.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange),
          infoWindow: InfoWindow(title: 'Amigo #${loc.userId}'),
        ),
      );
    }
  }
}
