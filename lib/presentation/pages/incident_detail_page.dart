import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/incident_report.dart';

class IncidentDetailPage extends StatelessWidget {
  final IncidentReport report;

  const IncidentDetailPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Incidente')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 250,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(report.latitude, report.longitude),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('incident'),
                    position: LatLng(report.latitude, report.longitude),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed),
                  ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getIncidentIcon(report.incidentType),
                        color: Colors.red,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          report.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(report.incidentType),
                    backgroundColor: Colors.red[100],
                  ),
                  if (report.isAnonymous)
                    const Chip(
                      label: Text('Reporte Anónimo'),
                      backgroundColor: Colors.grey,
                    ),
                  const SizedBox(height: 16),
                  Text(
                    report.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          report.address ?? 'Sin dirección',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm')
                            .format(report.reportedAt),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  if (report.mediaUrl != null) ...[
                    const SizedBox(height: 16),
                    const Text('Evidencia adjunta:'),
                    const SizedBox(height: 8),
                    Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image, size: 64, color: Colors.grey),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIncidentIcon(String type) {
    switch (type) {
      case 'ROBBERY':
        return Icons.money_off;
      case 'ASSAULT':
        return Icons.person_off;
      case 'HARASSMENT':
        return Icons.warning_amber;
      case 'VANDALISM':
        return Icons.broken_image;
      case 'ACCIDENT':
        return Icons.car_crash;
      default:
        return Icons.report_problem;
    }
  }
}
