import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/report/report_bloc.dart';
import 'incident_detail_page.dart';

class MyReportsPage extends StatefulWidget {
  const MyReportsPage({super.key});

  @override
  State<MyReportsPage> createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context
          .read<ReportBloc>()
          .add(GetReportsByUserEvent(authState.profile.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Reportes')),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ReportError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadReports,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          if (state is ReportsLoaded) {
            final reports = state.reports;
            if (reports.isEmpty) {
              return const Center(
                child: Text('No has realizado reportes aún'),
              );
            }
            return RefreshIndicator(
              onRefresh: () async => _loadReports(),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 8),
                    child: ListTile(
                      leading: Icon(
                        _getIncidentIcon(report.incidentType),
                        color: Colors.red,
                        size: 32,
                      ),
                      title: Text(
                        report.title,
                        style:
                            const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(report.description, maxLines: 2),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm')
                                .format(report.reportedAt),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: report.isAnonymous
                          ? const Chip(
                              label: Text('Anónimo',
                                  style: TextStyle(fontSize: 10)),
                              visualDensity: VisualDensity.compact,
                            )
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                IncidentDetailPage(report: report),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
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
