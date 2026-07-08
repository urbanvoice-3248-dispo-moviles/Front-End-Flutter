import 'package:get_it/get_it.dart';

import '../../data/datasources/alert_config_remote_datasource.dart';
import '../../data/datasources/alert_remote_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/category_remote_datasource.dart';
import '../../data/datasources/district_remote_datasource.dart';
import '../../data/datasources/location_remote_datasource.dart';
import '../../data/datasources/location_sharing_remote_datasource.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/datasources/report_remote_datasource.dart';
import '../../data/datasources/route_remote_datasource.dart';
import '../../data/datasources/statistics_remote_datasource.dart';
import '../../data/datasources/vote_remote_datasource.dart';
import '../../data/repositories/alert_config_repository_impl.dart';
import '../../data/repositories/alert_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/district_repository_impl.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../data/repositories/location_sharing_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../data/repositories/route_repository_impl.dart';
import '../../data/repositories/statistics_repository_impl.dart';
import '../../data/repositories/vote_repository_impl.dart';
import '../../domain/repositories/alert_config_repository.dart';
import '../../domain/repositories/alert_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/district_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/location_sharing_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/report_repository.dart';
import '../../domain/repositories/route_repository.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../../domain/repositories/vote_repository.dart';
import '../../domain/usecases/alert_config_usecases.dart';
import '../../domain/usecases/alert_usecases.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/category_usecases.dart';
import '../../domain/usecases/create_report.dart';
import '../../domain/usecases/district_usecases.dart';
import '../../domain/usecases/location_sharing_usecases.dart';
import '../../domain/usecases/location_usecases.dart';
import '../../domain/usecases/profile_usecases.dart';
import '../../domain/usecases/route_usecases.dart';
import '../../domain/usecases/statistics_usecases.dart';
import '../../domain/usecases/vote_usecases.dart';
import '../../presentation/bloc/alert/alert_bloc.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/category/category_bloc.dart';
import '../../presentation/bloc/forgot_password/forgot_password_bloc.dart';
import '../../presentation/bloc/location/location_bloc.dart';
import '../../presentation/bloc/location_sharing/location_sharing_bloc.dart';
import '../../presentation/bloc/profile/profile_bloc.dart';
import '../../presentation/bloc/report/report_bloc.dart';
import '../../presentation/bloc/route/route_bloc.dart';
import '../../presentation/bloc/statistics/statistics_bloc.dart';
import '../network/api_client.dart';
import '../network/fcm_service.dart';
import '../network/token_manager.dart';

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
  sl.registerLazySingleton<TokenManager>(() => TokenManager());
  sl.registerLazySingleton<FcmService>(() => FcmService());
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
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(sl()));
  sl.registerLazySingleton<DistrictRemoteDataSource>(
      () => DistrictRemoteDataSource(sl()));
  sl.registerLazySingleton<VoteRemoteDataSource>(
      () => VoteRemoteDataSource(sl()));
  sl.registerLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSource(sl()));
  sl.registerLazySingleton<AlertConfigRemoteDataSource>(
      () => AlertConfigRemoteDataSource(sl()));
  sl.registerLazySingleton<LocationSharingRemoteDataSource>(
      () => LocationSharingRemoteDataSource(sl()));
  sl.registerLazySingleton<RouteRemoteDataSource>(
      () => RouteRemoteDataSource(sl()));
  sl.registerLazySingleton<StatisticsRemoteDataSource>(
      () => StatisticsRemoteDataSource(sl()));
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
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<DistrictRepository>(
      () => DistrictRepositoryImpl(sl()));
  sl.registerLazySingleton<VoteRepository>(
      () => VoteRepositoryImpl(sl()));
  sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(sl()));
  sl.registerLazySingleton<AlertConfigRepository>(
      () => AlertConfigRepositoryImpl(sl()));
  sl.registerLazySingleton<LocationSharingRepository>(
      () => LocationSharingRepositoryImpl(sl()));
  sl.registerLazySingleton<RouteRepository>(
      () => RouteRepositoryImpl(sl()));
  sl.registerLazySingleton<StatisticsRepository>(
      () => StatisticsRepositoryImpl(sl()));
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
  sl.registerLazySingleton<ApproveReport>(() => ApproveReport(sl()));
  sl.registerLazySingleton<RejectReport>(() => RejectReport(sl()));
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
  sl.registerLazySingleton<LoginUser>(() => LoginUser(sl()));
  sl.registerLazySingleton<ForgotPassword>(() => ForgotPassword(sl()));
  sl.registerLazySingleton<ResetPassword>(() => ResetPassword(sl()));
  sl.registerLazySingleton<GetAllDistricts>(() => GetAllDistricts(sl()));
  sl.registerLazySingleton<GetDangerousDistricts>(
      () => GetDangerousDistricts(sl()));
  sl.registerLazySingleton<ToggleVote>(() => ToggleVote(sl()));
  sl.registerLazySingleton<GetVotes>(() => GetVotes(sl()));
  sl.registerLazySingleton<GetAllCategories>(() => GetAllCategories(sl()));
  sl.registerLazySingleton<CreateCategory>(() => CreateCategory(sl()));
  sl.registerLazySingleton<DeleteCategory>(() => DeleteCategory(sl()));
  sl.registerLazySingleton<GetAlertConfig>(() => GetAlertConfig(sl()));
  sl.registerLazySingleton<UpdateAlertConfig>(
      () => UpdateAlertConfig(sl()));
  sl.registerLazySingleton<PublishLocation>(
      () => PublishLocation(sl()));
  sl.registerLazySingleton<GetFriendsLocations>(
      () => GetFriendsLocations(sl()));
  sl.registerLazySingleton<StartSharing>(() => StartSharing(sl()));
  sl.registerLazySingleton<StopSharing>(() => StopSharing(sl()));
  sl.registerLazySingleton<GetMyShares>(() => GetMyShares(sl()));
  sl.registerLazySingleton<GetSharedWithMe>(
      () => GetSharedWithMe(sl()));
  sl.registerLazySingleton<AssessRoute>(() => AssessRoute(sl()));
  sl.registerLazySingleton<GetStatistics>(() => GetStatistics(sl()));
}

void _initBlocs() {
  sl.registerFactory<AuthBloc>(() => AuthBloc(
        loginUser: sl(),
        createProfile: sl(),
        getProfileByEmail: sl(),
        getProfileById: sl(),
        tokenManager: sl(),
        fcmService: sl(),
      ));
  sl.registerFactory<ReportBloc>(() => ReportBloc(
        createReport: sl(),
        getReportById: sl(),
        getReportsByUser: sl(),
        getNearbyReports: sl(),
        deleteReport: sl(),
        approveReport: sl(),
        rejectReport: sl(),
        toggleVote: sl(),
        getVotes: sl(),
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
        getAlertConfig: sl(),
        updateAlertConfig: sl(),
      ));
  sl.registerFactory<ForgotPasswordBloc>(() => ForgotPasswordBloc(
        forgotPassword: sl(),
        resetPassword: sl(),
      ));
  sl.registerFactory<CategoryBloc>(() => CategoryBloc(
        getAllCategories: sl(),
        createCategory: sl(),
        deleteCategory: sl(),
      ));
  sl.registerFactory<StatisticsBloc>(
      () => StatisticsBloc(getStatistics: sl()));
  sl.registerFactory<RouteBloc>(() => RouteBloc(
        assessRoute: sl(),
      ));
  sl.registerFactory<LocationSharingBloc>(() => LocationSharingBloc(
        publishLocation: sl(),
        getFriendsLocations: sl(),
        startSharing: sl(),
        stopSharing: sl(),
        getMyShares: sl(),
        getSharedWithMe: sl(),
        getProfileByEmail: sl(),
      ));
}
