import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../pages/alerts_page.dart';
import '../pages/my_reports_page.dart';
import '../pages/profile_page.dart';
import '../pages/report_incident_page.dart';
import '../pages/login_page.dart';

/// Menu lateral compartido para las rutas principales de la aplicacion.
///
/// Lee el estado de autenticacion para mostrar datos del perfil cuando existe
/// una sesion activa y para habilitar la opcion de cierre de sesion.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // El drawer tambien funciona para visitantes; por eso el perfil se
          // trata como opcional en todos los campos visibles.
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
              if (profile != null)
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Cerrar Sesión'),
                  onTap: () {
                    Navigator.pop(context);
                    // Borra la sesion antes de reiniciar la navegacion en login.
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
