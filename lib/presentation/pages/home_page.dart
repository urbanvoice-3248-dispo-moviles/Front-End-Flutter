import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/incident_report.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/district.dart';
import '../../domain/usecases/district_usecases.dart';
import '../bloc/location/location_bloc.dart';
import '../bloc/report/report_bloc.dart';
import '../widgets/app_drawer.dart';
import 'alerts_page.dart';
import 'incident_detail_page.dart';
import 'report_incident_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<Marker> _markers = {};
  final Set<Polygon> _polygons = {};
  bool _showRiskMap = false;
  Set<String> _activeFilters = {};
  List<IncidentReport>? _lastReports;
  List<Location>? _lastLocations;

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(GetAllLocationsEvent());
    context.read<ReportBloc>().add(const GetNearbyReportsEvent(
          latitude: AppConstants.mapDefaultLatitude,
          longitude: AppConstants.mapDefaultLongitude,
        ));
    _loadDistricts();
  }

  Future<void> _loadDistricts() async {
    final useCase = GetIt.instance<GetAllDistricts>();
    final result = await useCase();
    result.fold(
      (failure) => null,
      (districts) {
        _buildDistrictPolygons(districts);
      },
    );
  }

  void _buildDistrictPolygons(List<District> districts) {
    _polygons.clear();
    for (final district in districts) {
      if (district.boundary.length < 3) continue;
      final points = district.boundary
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();
      final color = _getRiskPolygonColor(district.riskLevel);
      _polygons.add(Polygon(
        polygonId: PolygonId('district_${district.id}'),
        points: points,
        fillColor: color.withValues(alpha: 0.2),
        strokeColor: color,
        strokeWidth: 2,
        geodesic: false,
        visible: true,
      ));
    }
    setState(() {});
  }

  Color _getRiskPolygonColor(int riskLevel) {
    switch (riskLevel) {
      case 4:
      case 5:
        return Colors.red;
      case 3:
        return Colors.orange;
      case 2:
        return Colors.yellow;
      default:
        return Colors.green;
    }
  }

  void _rebuildMarkers() {
    _markers.clear();
    if (_lastLocations != null) {
      for (final loc in _lastLocations!) {
        _markers.add(Marker(
          markerId: MarkerId('loc_${loc.id}'),
          position: LatLng(loc.latitude, loc.longitude),
          icon: _getRiskMarkerIcon(loc.riskLevel),
          infoWindow: InfoWindow(
            title: loc.district,
            snippet:
                'Riesgo: ${loc.riskCategory} - Incidentes: ${loc.incidentCount}',
          ),
        ));
      }
    }
    if (_lastReports != null) {
      for (final r in _lastReports!) {
        if (_activeFilters.isNotEmpty &&
            !_activeFilters.contains(r.incidentType)) continue;
        _markers.add(Marker(
          markerId: MarkerId('rpt_${r.id}'),
          position: LatLng(r.latitude, r.longitude),
          icon: _getReportMarkerIcon(r.incidentType),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => IncidentDetailPage(report: r),
              ),
            );
          },
          infoWindow: InfoWindow(
            title: r.title,
            snippet: r.description,
          ),
        ));
      }
    }
  }

  static const Map<String, String> _typeLabels = {
    'ROBBERY': 'Robo',
    'ASSAULT': 'Asalto',
    'HARASSMENT': 'Acoso',
    'VANDALISM': 'Vandalismo',
    'ACCIDENT': 'Accidente',
    'OTHER': 'Otro',
  };

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filtrar por tipo de incidente',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._typeLabels.entries.map((e) {
                    final selected = _activeFilters.contains(e.key);
                    return CheckboxListTile(
                      value: selected,
                      title: Text(e.value),
                        onChanged: (_) {
                          if (selected) {
                            _activeFilters.remove(e.key);
                          } else {
                            _activeFilters.add(e.key);
                          }
                          _rebuildMarkers();
                          setState(() {});
                          setSheetState(() {});
                        },
                    );
                  }),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Aplicar'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UrbanVoice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrar incidentes',
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      drawer: AppDrawer(onToggleRiskMap: () {
        setState(() => _showRiskMap = !_showRiskMap);
        Navigator.pop(context);
      }),
      drawerEnableOpenDragGesture: false,
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locState) {
          if (locState is LocationsLoaded) {
            _lastLocations = locState.locations;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _rebuildMarkers();
            });
          }
          return BlocBuilder<ReportBloc, ReportState>(
            builder: (context, rptState) {
              if (rptState is ReportsLoaded) {
                _lastReports = rptState.reports;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _rebuildMarkers();
                });
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
                    markers: _markers,
                    polygons: _showRiskMap ? _polygons : {},
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                  ),
                  if (locState is LocationLoading ||
                      rptState is ReportLoading)
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
                                builder: (_) =>
                                    const ReportIncidentPage(),
                              ),
                            );
                          },
                          child: const Icon(Icons.add,
                              color: Colors.white),
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
                          child: const Icon(
                              Icons.notifications_outlined),
                        ),
                      ],
                    ),
                  ),
                  if (_showRiskMap)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _legendItem(
                                  Colors.red, 'Alto riesgo'),
                              _legendItem(Colors.orange,
                                  'Riesgo medio'),
                              _legendItem(Colors.yellow,
                                  'Riesgo bajo'),
                              _legendItem(
                                  Colors.green, 'Zona segura'),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.5),
              border: Border.all(color: color),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  BitmapDescriptor _getRiskMarkerIcon(int riskLevel) {
    switch (riskLevel) {
      case 4:
      case 5:
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed);
      case 3:
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange);
      case 2:
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow);
      default:
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen);
    }
  }

  BitmapDescriptor _getReportMarkerIcon(String type) {
    switch (type) {
      case 'ROBBERY':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet);
      case 'ASSAULT':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed);
      case 'HARASSMENT':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange);
      case 'VANDALISM':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueCyan);
      case 'ACCIDENT':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue);
      default:
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRose);
    }
  }
}
