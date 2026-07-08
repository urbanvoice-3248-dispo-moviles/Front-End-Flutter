import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'presentation/bloc/alert/alert_bloc.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/location/location_bloc.dart';
import 'presentation/bloc/profile/profile_bloc.dart';
import 'presentation/bloc/report/report_bloc.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/login_page.dart';

/// Punto de entrada de la aplicacion.
///
/// Inicializa Flutter y el contenedor de dependencias antes de montar el arbol
/// principal de widgets.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const UrbanVoiceApp());
}

/// Widget raiz encargado de registrar los BLoCs globales y resolver la primera
/// pantalla segun el estado de autenticacion.
class UrbanVoiceApp extends StatelessWidget {
  const UrbanVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => GetIt.instance<AuthBloc>()),
        BlocProvider<ReportBloc>(create: (_) => GetIt.instance<ReportBloc>()),
        BlocProvider<LocationBloc>(create: (_) => GetIt.instance<LocationBloc>()),
        BlocProvider<AlertBloc>(create: (_) => GetIt.instance<AlertBloc>()),
        BlocProvider<ProfileBloc>(create: (_) => GetIt.instance<ProfileBloc>()),
      ],
      child: MaterialApp(
        title: 'UrbanVoice',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const HomePage();
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
