import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/alert/alert_bloc.dart';
import '../bloc/auth/auth_bloc.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  void _loadAlerts() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context
          .read<AlertBloc>()
          .add(GetAlertsByUserEvent(authState.profile.id));
    } else {
      context.read<AlertBloc>().add(GetAllAlertsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alertas')),
      body: BlocBuilder<AlertBloc, AlertState>(
        builder: (context, state) {
          if (state is AlertLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AlertError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadAlerts,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          if (state is AlertsLoaded) {
            final alerts = state.alerts;
            if (alerts.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No tienes alertas',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async => _loadAlerts(),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 8),
                    child: ListTile(
                      leading: Icon(
                        _getAlertIcon(alert.type),
                        color: alert.isRead ? Colors.grey : Colors.red,
                      ),
                      title: Text(
                        alert.title,
                        style: TextStyle(
                          fontWeight: alert.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(alert.message, maxLines: 2),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm')
                                .format(alert.createdAt),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: alert.isRead
                          ? null
                          : Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
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

  IconData _getAlertIcon(String type) {
    switch (type) {
      case 'INCIDENT_NEARBY':
        return Icons.location_on;
      case 'HIGH_RISK_ZONE':
        return Icons.warning;
      case 'EMERGENCY':
        return Icons.emergency;
      default:
        return Icons.notifications;
    }
  }
}
