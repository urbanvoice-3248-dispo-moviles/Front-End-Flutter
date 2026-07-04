import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/incident_report.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/report/report_bloc.dart';

class IncidentDetailPage extends StatefulWidget {
  final IncidentReport report;

  const IncidentDetailPage({super.key, required this.report});

  @override
  State<IncidentDetailPage> createState() => _IncidentDetailPageState();
}

class _IncidentDetailPageState extends State<IncidentDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReportBloc>().add(GetVotesEvent(widget.report.id));
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;
    final authState = context.watch<AuthBloc>().state;
    final isModerator =
        authState is AuthAuthenticated && authState.profile.isModerator;

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
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text(_translateType(report.incidentType)),
                        backgroundColor: Colors.red[100],
                      ),
                      Chip(
                        label: Text(_translateStatus(report.status)),
                        backgroundColor: _getStatusColor(report.status)
                            .withValues(alpha: 0.2),
                      ),
                      if (report.isAnonymous)
                        const Chip(
                          label: Text('Anónimo'),
                          backgroundColor: Colors.grey,
                        ),
                    ],
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
                        child:
                            Icon(Icons.image, size: 64, color: Colors.grey),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  BlocBuilder<ReportBloc, ReportState>(
                    builder: (context, state) {
                      int upvotes = 0;
                      int downvotes = 0;
                      if (state is ReportVoteLoaded) {
                        upvotes = state.vote.upvotes;
                        downvotes = state.vote.downvotes;
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildVoteButton(
                            context,
                            Icons.thumb_up,
                            'Útil ($upvotes)',
                            Colors.green,
                            () => _handleVote('UPVOTE'),
                          ),
                          _buildVoteButton(
                            context,
                            Icons.thumb_down,
                            'No útil ($downvotes)',
                            Colors.red,
                            () => _handleVote('DOWNVOTE'),
                          ),
                        ],
                      );
                    },
                  ),
                  if (isModerator && report.status == 'PENDING') ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _handleModerate('APPROVE'),
                            icon: const Icon(Icons.check),
                            label: const Text('Aprobar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _handleModerate('REJECT'),
                            icon: const Icon(Icons.close),
                            label: const Text('Rechazar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildVoteButton(BuildContext context, IconData icon, String label,
      Color color, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      label: Text(label, style: TextStyle(color: color)),
    );
  }

  void _handleVote(String voteType) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<ReportBloc>().add(ToggleVoteEvent(
            reportId: widget.report.id,
            voteType: voteType,
            userId: authState.profile.id,
          ));
    }
  }

  void _handleModerate(String action) {
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

  String _translateType(String type) {
    switch (type) {
      case 'ROBBERY':
        return 'Robo';
      case 'ASSAULT':
        return 'Asalto';
      case 'HARASSMENT':
        return 'Acoso';
      case 'VANDALISM':
        return 'Vandalismo';
      case 'ACCIDENT':
        return 'Accidente';
      default:
        return type;
    }
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'PENDING':
        return 'Pendiente';
      case 'APPROVED':
        return 'Aprobado';
      case 'REJECTED':
        return 'Rechazado';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
