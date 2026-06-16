import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/location.dart';
import '../bloc/location/location_bloc.dart';
import '../bloc/report/report_bloc.dart';
import '../widgets/app_drawer.dart';
import 'alerts_page.dart';
import 'report_incident_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(GetAllLocationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UrbanVoice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_outlined),
            onPressed: () {
              context.read<ReportBloc>().add(const GetNearbyReportsEvent(
                    latitude: AppConstants.mapDefaultLatitude,
                    longitude: AppConstants.mapDefaultLongitude,
                  ));
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationsLoaded) {
            _updateMapMarkers(state.locations);
          }
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(
                    AppConstants.mapDefaultLatitude,
                    AppConstants.mapDefaultLongitude,
                  ),
                  zoom: 12,
                ),
                onMapCreated: (controller) {
                },
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
              ),
              if (state is LocationLoading)
                const Center(child: CircularProgressIndicator()),
              Positioned(
                bottom: 24,
                right: 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      heroTag: 'report',
                      backgroundColor: Colors.red,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReportIncidentPage(),
                          ),
                        );
                      },
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: 'alerts',
                      mini: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AlertsPage(),
                          ),
                        );
                      },
                      child: const Icon(Icons.notifications_outlined),
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

  void _updateMapMarkers(List<Location> locations) {
    _markers.clear();
    for (final loc in locations) {
      final marker = Marker(
        markerId: MarkerId(loc.id.toString()),
        position: LatLng(loc.latitude, loc.longitude),
        icon: _getRiskMarkerIcon(loc.riskLevel),
        infoWindow: InfoWindow(
          title: loc.district,
          snippet:
              'Riesgo: ${loc.riskCategory} - Incidentes: ${loc.incidentCount}',
        ),
      );
      _markers.add(marker);
    }
  }

  BitmapDescriptor _getRiskMarkerIcon(int riskLevel) {
    switch (riskLevel) {
      case 4:
      case 5:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 3:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case 2:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      default:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }
  }
}
