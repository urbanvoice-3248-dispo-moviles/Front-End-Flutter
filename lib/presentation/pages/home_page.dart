import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/incident_report.dart';
import '../../domain/entities/location.dart';
import '../bloc/location/location_bloc.dart';
import '../bloc/report/report_bloc.dart';
import '../widgets/app_drawer.dart';
import 'alerts_page.dart';
import 'incident_detail_page.dart';
import 'report_incident_page.dart';

/// Pantalla principal de UrbanVoice con el mapa de riesgo ciudadano.
///
/// Combina ubicaciones de riesgo e incidentes cercanos en una misma capa de
/// marcadores para que el usuario pueda explorar la situacion de su zona.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Marcadores activos del mapa.
  ///
  /// Se reutiliza el mismo conjunto para conservar las capas de ubicaciones e
  /// incidentes, actualizando solo el prefijo que corresponde a cada origen.
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Carga inicial del mapa: zonas registradas y reportes cercanos al centro
    // configurado para la ciudad.
    context.read<LocationBloc>().add(GetAllLocationsEvent());
    context.read<ReportBloc>().add(const GetNearbyReportsEvent(
          latitude: AppConstants.mapDefaultLatitude,
          longitude: AppConstants.mapDefaultLongitude,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UrbanVoice'),
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locState) {
          if (locState is LocationsLoaded) {
            _updateLocationMarkers(locState.locations);
          }
          return BlocBuilder<ReportBloc, ReportState>(
            builder: (context, rptState) {
              if (rptState is ReportsLoaded) {
                _updateReportMarkers(rptState.reports);
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
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                  ),
                  if (locState is LocationLoading || rptState is ReportLoading)
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
          );
        },
      ),
    );
  }

  /// Sincroniza los marcadores de zonas de riesgo sin tocar los reportes.
  void _updateLocationMarkers(List<Location> locations) {
    _markers.removeWhere((m) => m.markerId.value.startsWith('loc_'));
    for (final loc in locations) {
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

  /// Sincroniza los marcadores de reportes e incluye la navegacion al detalle.
  void _updateReportMarkers(List<IncidentReport> reports) {
    _markers.removeWhere((m) => m.markerId.value.startsWith('rpt_'));
    for (final r in reports) {
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

  /// Traduce el nivel de riesgo de una zona a un color de marcador.
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

  /// Asigna colores distintos por tipo de incidente para facilitar lectura.
  BitmapDescriptor _getReportMarkerIcon(String type) {
    switch (type) {
      case 'ROBBERY':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
      case 'ASSAULT':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'HARASSMENT':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case 'VANDALISM':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
      case 'ACCIDENT':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      default:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
    }
  }
}
