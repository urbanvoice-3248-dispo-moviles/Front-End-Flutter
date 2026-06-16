import 'package:get_it/get_it.dart';

import '../../data/datasources/alert_remote_datasource.dart';
import '../../data/datasources/location_remote_datasource.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/datasources/report_remote_datasource.dart';
import '../../data/repositories/alert_repository_impl.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../domain/repositories/alert_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/report_repository.dart';
import '../../domain/usecases/alert_usecases.dart';
import '../../domain/usecases/create_report.dart';
import '../../domain/usecases/location_usecases.dart';
import '../../domain/usecases/profile_usecases.dart';
import '../../presentation/bloc/alert/alert_bloc.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/location/location_bloc.dart';
import '../../presentation/bloc/profile/profile_bloc.dart';
import '../../presentation/bloc/report/report_bloc.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  _initCore();
  _initDataSources();
  _initRepositories();
  _initUseCases();
  _initBlocs();
}

void _initCore() {
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
}

void _initDataSources() {
  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSource(sl()));
  sl.registerLazySingleton<ReportRemoteDataSource>(
      () => ReportRemoteDataSource(sl()));
  sl.registerLazySingleton<LocationRemoteDataSource>(
      () => LocationRemoteDataSource(sl()));
  sl.registerLazySingleton<AlertRemoteDataSource>(
      () => AlertRemoteDataSource(sl()));
}

void _initRepositories() {
  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl()));
  sl.registerLazySingleton<ReportRepository>(
      () => ReportRepositoryImpl(sl()));
  sl.registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(sl()));
  sl.registerLazySingleton<AlertRepository>(
      () => AlertRepositoryImpl(sl()));
}

void _initUseCases() {
  sl.registerLazySingleton<CreateProfile>(() => CreateProfile(sl()));
  sl.registerLazySingleton<GetProfileById>(() => GetProfileById(sl()));
  sl.registerLazySingleton<GetProfileByEmail>(
      () => GetProfileByEmail(sl()));
  sl.registerLazySingleton<UpdateProfile>(() => UpdateProfile(sl()));
  sl.registerLazySingleton<DeleteProfile>(() => DeleteProfile(sl()));
  sl.registerLazySingleton<CreateReport>(() => CreateReport(sl()));
  sl.registerLazySingleton<GetReportById>(() => GetReportById(sl()));
  sl.registerLazySingleton<GetReportsByUser>(
      () => GetReportsByUser(sl()));
  sl.registerLazySingleton<GetNearbyReports>(
      () => GetNearbyReports(sl()));
  sl.registerLazySingleton<DeleteReport>(() => DeleteReport(sl()));
  sl.registerLazySingleton<GetAllLocations>(
      () => GetAllLocations(sl()));
  sl.registerLazySingleton<GetNearbyLocations>(
      () => GetNearbyLocations(sl()));
  sl.registerLazySingleton<GetLocationsByDistrict>(
      () => GetLocationsByDistrict(sl()));
  sl.registerLazySingleton<GetDangerousLocations>(
      () => GetDangerousLocations(sl()));
  sl.registerLazySingleton<GetAllAlerts>(() => GetAllAlerts(sl()));
  sl.registerLazySingleton<GetAlertsByUser>(
      () => GetAlertsByUser(sl()));
}

void _initBlocs() {
  sl.registerFactory<AuthBloc>(() => AuthBloc(
        createProfile: sl(),
        getProfileByEmail: sl(),
        getProfileById: sl(),
      ));
  sl.registerFactory<ReportBloc>(() => ReportBloc(
        createReport: sl(),
        getReportById: sl(),
        getReportsByUser: sl(),
        getNearbyReports: sl(),
        deleteReport: sl(),
      ));
  sl.registerFactory<LocationBloc>(() => LocationBloc(
        getAllLocations: sl(),
        getNearbyLocations: sl(),
        getLocationsByDistrict: sl(),
        getDangerousLocations: sl(),
      ));
  sl.registerFactory<AlertBloc>(() => AlertBloc(
        getAllAlerts: sl(),
        getAlertsByUser: sl(),
      ));
  sl.registerFactory<ProfileBloc>(() => ProfileBloc(
        getProfileById: sl(),
        getProfileByEmail: sl(),
        updateProfile: sl(),
        deleteProfile: sl(),
      ));
}
