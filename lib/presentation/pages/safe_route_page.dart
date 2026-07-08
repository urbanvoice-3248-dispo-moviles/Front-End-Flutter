import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/utils/polyline_utils.dart';
import '../bloc/route/route_bloc.dart';
import 'location_picker_page.dart';

class SafeRoutePage extends StatefulWidget {
  const SafeRoutePage({super.key});

  @override
  State<SafeRoutePage> createState() => _SafeRoutePageState();
}

class _SafeRoutePageState extends State<SafeRoutePage> {
  static const String _directionsApiKey = 'AIzaSyA0yqAT0ci7jH8Xa_tesd3X_TYY33XduN8';

  final _destLatController = TextEditingController();
  final _destLngController = TextEditingController();
  LatLng? _origin;
  LatLng? _destination;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool _isLoadingDirections = false;

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

  Future<void> _assessRoute() async {
    if (_origin == null || _destination == null) return;

    setState(() => _isLoadingDirections = true);

    try {
      final originStr =
          '${_origin!.latitude},${_origin!.longitude}';
      final destStr =
          '${_destination!.latitude},${_destination!.longitude}';
      final url =
          'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=$originStr&destination=$destStr'
          '&alternatives=true&mode=walking'
          '&key=$_directionsApiKey';

      final dio = Dio();
      final response = await dio.get(url);
      final data = response.data;

      if (data['status'] != 'OK' || data['routes'] == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se encontraron rutas: ${data['status']}')),
          );
        }
        return;
      }

      final routes = data['routes'] as List;
      if (routes.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se encontraron rutas')),
          );
        }
        return;
      }

      final bestRoute = routes.first;
      final encodedPolyline = bestRoute['overview_polyline']?['points'] as String?;
      if (encodedPolyline == null) return;

      final decoded = decodePolyline(encodedPolyline);
      final sampled = _samplePoints(decoded, 10);

      final waypoints = sampled
          .map((p) => {'lat': p[0], 'lng': p[1]})
          .toList();

      if (!mounted) return;
      context.read<RouteBloc>().add(
            AssessRouteEvent(
              waypoints: waypoints,
              origin: {
                'lat': _origin!.latitude,
                'lng': _origin!.longitude
              },
              destination: {
                'lat': _destination!.latitude,
                'lng': _destination!.longitude
              },
              decodedPath: decoded,
            ),
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener ruta: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingDirections = false);
    }
  }

  List<List<double>> _samplePoints(List<List<double>> points, int maxSamples) {
    if (points.length <= maxSamples) return points;
    final step = points.length ~/ maxSamples;
    return List.generate(maxSamples, (i) {
      final idx = (i * step).clamp(0, points.length - 1);
      return points[idx];
    });
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
                          onPressed:
                              (_origin != null && _destination != null && !_isLoadingDirections)
                                  ? _assessRoute
                                  : null,
                          child: _isLoadingDirections
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Evaluar ruta'),
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
                        child: _buildSafetyCard(state),
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

  Widget _buildSafetyCard(RouteLoaded state) {
    final score = state.assessment.overallSafetyScore;
    final scoreColor = score <= 1.5
        ? Colors.green
        : score <= 3.0
            ? Colors.orange
            : Colors.red;
    final segments = state.assessment.segments;

    return Card(
      color: scoreColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.shield, color: scoreColor, size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Puntaje de seguridad',
                      style: Theme.of(context).textTheme.labelSmall,
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
            if (segments.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Text(
                'Segmentos de ruta:',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              ...segments.map((seg) {
                final segColor = seg.riskLevel <= 1
                    ? Colors.green
                    : seg.riskLevel <= 3
                        ? Colors.orange
                        : Colors.red;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: segColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          seg.district,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Text(
                        '${seg.riskCategory} (${seg.riskLevel})',
                        style: TextStyle(
                          fontSize: 12,
                          color: segColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  void _updateRouteOnMap(RouteLoaded state) {
    _polylines.clear();
    final decodedPath = state.decodedPath;
    if (decodedPath.length >= 2) {
      final score = state.assessment.overallSafetyScore;
      final color = score <= 1.5
          ? Colors.green
          : score <= 3.0
              ? Colors.orange
              : Colors.red;
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: decodedPath.map((p) => LatLng(p[0], p[1])).toList(),
          color: color,
          width: 4,
        ),
      );
    }
  }
}
