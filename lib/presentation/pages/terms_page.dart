import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import 'login_page.dart';
import 'home_page.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Términos y Condiciones')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _section('1. Aceptación',
                      'Al utilizar UrbanVoice aceptas los presentes términos y condiciones.'),
                  _section('2. Descripción',
                      'UrbanVoice es una plataforma de seguridad ciudadana que permite reportar incidentes y recibir alertas.'),
                  _section('3. Uso de datos',
                      'Los datos proporcionados serán utilizados para mejorar la seguridad de la comunidad y generar estadísticas.'),
                  _section('4. Reportes',
                      'Los reportes deben ser veraces y no deben contener información falsa o maliciosa.'),
                  _section('5. Anónimos',
                      'Los reportes anónimos no revelarán tu identidad, pero serán verificados antes de publicarse.'),
                  _section('6. Privacidad',
                      'Tus datos personales no serán compartidos con terceros sin tu consentimiento.'),
                  _section('7. Imágenes',
                      'Las imágenes adjuntas a los reportes deben ser relevantes y no violar derechos de terceros.'),
                  _section('8. Responsabilidad',
                      'UrbanVoice no se responsabiliza por el mal uso de la información proporcionada.'),
                  _section('9. Modificaciones',
                      'Nos reservamos el derecho de modificar estos términos en cualquier momento.'),
                  _section('10. Contacto',
                      'Para consultas, contáctanos a través de la aplicación.'),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3), blurRadius: 8),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showDeclineDialog(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Rechazar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(TermsAcceptedEvent());
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Aceptar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _showDeclineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rechazar términos'),
        content: const Text(
            'No podrás usar UrbanVoice si no aceptas los términos y condiciones.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(LogoutEvent());
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
  }
}
