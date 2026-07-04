import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../pages/alerts_page.dart';
import '../pages/category_management_page.dart';
import '../pages/location_sharing_page.dart';
import '../pages/my_reports_page.dart';
import '../pages/profile_page.dart';
import '../pages/report_incident_page.dart';
import '../pages/safe_route_page.dart';
import '../pages/statistics_page.dart';
import '../pages/login_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final profile =
              state is AuthAuthenticated ? state.profile : null;
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                accountName: Text(
                  profile != null
                      ? '${profile.name} ${profile.lastName}'
                      : 'Invitado',
                ),
                accountEmail: Text(profile?.email ?? 'Sin sesión'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    profile != null
                        ? '${profile.name[0]}${profile.lastName[0]}'
                        : '?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text('Mapa de Riesgo'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.add_circle, color: Colors.red),
                title: const Text('Reportar Incidente'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReportIncidentPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.list_alt),
                title: const Text('Mis Reportes'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyReportsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Alertas'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AlertsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_location),
                title: const Text('Compartir Ubicación'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LocationSharingPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.route),
                title: const Text('Ruta Segura'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SafeRoutePage(),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Mi Perfil'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfilePage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Categorías'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CategoryManagementPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text('Estadísticas'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StatisticsPage(),
                    ),
                  );
                },
              ),
              if (profile != null)
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Cerrar Sesión'),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<AuthBloc>().add(LogoutEvent());
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
