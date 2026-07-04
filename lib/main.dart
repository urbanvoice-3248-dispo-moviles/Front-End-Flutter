import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'presentation/bloc/alert/alert_bloc.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/category/category_bloc.dart';
import 'presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'presentation/bloc/location/location_bloc.dart';
import 'presentation/bloc/location_sharing/location_sharing_bloc.dart';
import 'presentation/bloc/profile/profile_bloc.dart';
import 'presentation/bloc/report/report_bloc.dart';
import 'presentation/bloc/route/route_bloc.dart';
import 'presentation/bloc/statistics/statistics_bloc.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/terms_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const UrbanVoiceApp());
}

class UrbanVoiceApp extends StatefulWidget {
  const UrbanVoiceApp({super.key});

  @override
  State<UrbanVoiceApp> createState() => _UrbanVoiceAppState();
}

class _UrbanVoiceAppState extends State<UrbanVoiceApp> {
  @override
  void initState() {
    super.initState();
    GetIt.instance<AuthBloc>().add(CheckSavedSessionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => GetIt.instance<AuthBloc>()),
        BlocProvider<ReportBloc>(
            create: (_) => GetIt.instance<ReportBloc>()),
        BlocProvider<LocationBloc>(
            create: (_) => GetIt.instance<LocationBloc>()),
        BlocProvider<AlertBloc>(
            create: (_) => GetIt.instance<AlertBloc>()),
        BlocProvider<ProfileBloc>(
            create: (_) => GetIt.instance<ProfileBloc>()),
        BlocProvider<ForgotPasswordBloc>(
            create: (_) => GetIt.instance<ForgotPasswordBloc>()),
        BlocProvider<CategoryBloc>(
            create: (_) => GetIt.instance<CategoryBloc>()),
        BlocProvider<StatisticsBloc>(
            create: (_) => GetIt.instance<StatisticsBloc>()),
        BlocProvider<RouteBloc>(
            create: (_) => GetIt.instance<RouteBloc>()),
        BlocProvider<LocationSharingBloc>(
            create: (_) => GetIt.instance<LocationSharingBloc>()),
      ],
      child: MaterialApp(
        title: 'UrbanVoice',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              if (state.needsTermsAcceptance) {
                return const TermsPage();
              }
              return const HomePage();
            }
            if (state is CheckingAuth) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
