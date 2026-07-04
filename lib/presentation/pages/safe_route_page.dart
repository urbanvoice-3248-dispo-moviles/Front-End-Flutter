import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import '../bloc/route/route_bloc.dart';
import 'location_picker_page.dart';

class SafeRoutePage extends StatefulWidget {
  const SafeRoutePage({super.key});

  @override
  State<SafeRoutePage> createState() => _SafeRoutePageState();
}

class _SafeRoutePageState extends State<SafeRoutePage> {
  final _destLatController = TextEditingController();
  final _destLngController = TextEditingController();
  LatLng? _origin;
  LatLng? _destination;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _origin = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId('origin'),
          position: _origin!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Mi ubicación'),
        ),
      );
    });
  }

  Future<void> _pickOnMap() async {
    final result = await Navigator.push<Map<String, double>>(
      context,
      MaterialPageRoute(
        builder: (_) => const LocationPickerPage(),
      ),
    );
    if (result != null) {
      _destLatController.text = result['latitude']!.toStringAsFixed(6);
      _destLngController.text = result['longitude']!.toStringAsFixed(6);
      setState(() {
        _destination = LatLng(result['latitude']!, result['longitude']!);
        _markers.removeWhere((m) => m.markerId.value == 'destination');
        _markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: _destination!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: const InfoWindow(title: 'Destino'),
          ),
        );
      });
    }
  }

  void _assessRoute() {
    if (_origin == null || _destination == null) return;

    final waypoints = [
      {'lat': _origin!.latitude, 'lng': _origin!.longitude},
      {'lat': _destination!.latitude, 'lng': _destination!.longitude},
    ];

    context.read<RouteBloc>().add(
          AssessRouteEvent(
            waypoints: waypoints,
            origin: waypoints[0],
            destination: waypoints[1],
          ),
        );
  }

  @override
  void dispose() {
    _destLatController.dispose();
    _destLngController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruta Segura')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _destLatController,
                            decoration: const InputDecoration(
                              labelText: 'Latitud destino',
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _destLngController,
                            decoration: const InputDecoration(
                              labelText: 'Longitud destino',
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _pickOnMap,
                            icon: const Icon(Icons.map, size: 18),
                            label: const Text('Seleccionar en mapa'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: (_origin != null && _destination != null)
                              ? _assessRoute
                              : null,
                          child: const Text('Evaluar ruta'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<RouteBloc, RouteState>(
              builder: (context, state) {
                if (state is RouteLoaded) {
                  final score = state.assessment.overallSafetyScore;
                  final scoreColor = score <= 1.5
                      ? Colors.green
                      : score <= 3.0
                          ? Colors.orange
                          : Colors.red;

                  _updateRouteOnMap(state);

                  return Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _origin ?? const LatLng(-12.0464, -77.0428),
                          zoom: 13,
                        ),
                        onMapCreated: (_) {},
                        markers: _markers,
                        polylines: _polylines,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Card(
                          color: scoreColor.withValues(alpha: 0.1),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(Icons.shield,
                                    color: scoreColor, size: 32),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Puntaje de seguridad',
                                      style:
                                          Theme.of(context).textTheme.labelSmall,
                                    ),
                                    Text(
                                      score.toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: scoreColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(-12.0464, -77.0428),
                    zoom: 12,
                  ),
                  onMapCreated: (_) {},
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateRouteOnMap(RouteLoaded state) {
    _polylines.clear();
    if (_origin != null && _destination != null) {
      final score = state.assessment.overallSafetyScore;
      final color = score <= 1.5
          ? Colors.green
          : score <= 3.0
              ? Colors.orange
              : Colors.red;
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [_origin!, _destination!],
          color: color,
          width: 4,
        ),
      );
    }
  }
}
