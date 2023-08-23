import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/assignments/data/repositories/assignments_repository_impl.dart';
import '../features/assignments/data/repositories/documentation_repository_impl.dart';
import '../features/assignments/data/repositories/more_repository_impl.dart';
import '../features/assignments/data/sources/assignments_remote_data_source.dart';
import '../features/assignments/data/sources/documentation_remote_data_source.dart';
import '../features/assignments/data/sources/more_remote_data_source.dart';
import '../features/assignments/domain/repositories/assignments_repository.dart';
import '../features/assignments/domain/repositories/documentation_repository.dart';
import '../features/assignments/domain/repositories/more_repository.dart';
import '../features/assignments/domain/usecases/assignments/assignments_refiner.dart';
import '../features/assignments/domain/usecases/assignments/change_assignment_state.dart';
import '../features/assignments/domain/usecases/assignments/fetch_assignments.dart';
import '../features/assignments/domain/usecases/assignments/fetch_detailed_assignment.dart';
import '../features/assignments/domain/usecases/documentation/create_draft_documentation.dart';
import '../features/assignments/domain/usecases/documentation/create_image_documentation.dart';
import '../features/assignments/domain/usecases/documentation/create_note_documentation.dart';
import '../features/assignments/domain/usecases/documentation/create_signature_documentation.dart';
import '../features/assignments/domain/usecases/documentation/create_time_documentation.dart';
import '../features/assignments/domain/usecases/documentation/delete_documentation.dart';
import '../features/assignments/domain/usecases/documentation/edit_note_documentation.dart';
import '../features/assignments/domain/usecases/logout_user.dart';
import '../features/assignments/presentation/blocs/assignments/assignments_bloc.dart';
import '../features/assignments/presentation/blocs/bottom_bar/bottom_bar_bloc.dart';
import '../features/assignments/presentation/blocs/detailed_assignment/detailed_assignment_bloc.dart';
import '../features/assignments/presentation/blocs/logout/logout_bloc.dart';
import '../features/assignments/presentation/blocs/scroll/scroll_button_bloc.dart';
import '../features/assignments/presentation/blocs/slider/slider_bloc.dart';
import '../features/assignments/presentation/cubits/documentation/create_documentation_cubit.dart';
import '../features/assignments/presentation/cubits/time_picker/time_picker_cubit.dart';
import '../features/documents/data/repositories/file_repository_impl.dart';
import '../features/documents/data/sources/file_local_data_source.dart';
import '../features/documents/data/sources/file_remote_data_source.dart';
import '../features/documents/domain/repositories/file_repository.dart';
import '../features/documents/domain/usecases/get_file.dart';
import '../features/documents/presentation/cubits/file_management_cubit.dart';
import '../features/login/data/repositories/login_repository_impl.dart';
import '../features/login/data/sources/login_remote_data_source.dart';
import '../features/login/domain/repositories/login_repository.dart';
import '../features/login/domain/usecases/login_user.dart';
import '../features/login/domain/usecases/post_forgot_password.dart';
import '../features/login/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import '../features/login/presentation/blocs/login/login_bloc.dart';
import '../features/protocol/presentation/cubits/approval/approval_cubit.dart';
import '../features/protocol/presentation/cubits/camera/camera_cubit.dart';
import '../features/protocol/presentation/cubits/draft/draft_cubit.dart';
import '../features/protocol/presentation/cubits/note/note_cubit.dart';
import '../features/protocol/presentation/cubits/photo/photo_cubit.dart';
import '../features/protocol/presentation/cubits/signature/signature_cubit.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'network/network_info.dart';
import 'repositories/authentication_repository.dart';
import 'router/app_router.dart';
import 'shared_prefs.dart';
import 'sources/craftbox_multipart_request.dart';
import 'utils/dialog_provider.dart';
import 'utils/file_opener.dart';
import 'utils/form_validator.dart';
import 'utils/image_converter.dart';

final sl = GetIt.instance;

// ignore_for_file: cascade_invocations
Future<void> init() async {
  _initAuthenticationDependencies();
  _initDocumentsDependencies();
  _initProtocolDependencies();
  _initTimeRecorderDependencies();
  _initAppointmentsDependencies();
  _initLoginDependencies();
  _initCoreDependencies();
  await _initExternalDependencies();
}

void _initProtocolDependencies() {
  sl.registerFactory(() => ApprovalCubit(
        createSignatureDocumentation: sl(),
        authenticationRepository: sl(),
      ));
  sl.registerFactory(SignatureCubit.new);
  sl.registerFactory(() => NoteCubit(
        createNoteDocumentation: sl(),
        editNoteDocumentation: sl(),
        deleteDocumentation: sl(),
        authenticationRepository: sl(),
      ));
  sl.registerFactory(() => DraftCubit(
        createDraftDocumentation: sl(),
        authenticationRepository: sl(),
        deleteDocumentation: sl(),
      ));
  sl.registerFactory(() => PhotoCubit(
        sl(),
        sl(),
        sl(),
        sl(),
      ));
  sl.registerFactory(CameraCubit.new);

  sl.registerLazySingleton(() => CreateNoteDocumentation(sl()));
  sl.registerLazySingleton(() => EditNoteDocumentation(sl()));
  sl.registerLazySingleton(() => DeleteDocumentation(sl()));
  sl.registerLazySingleton(() => CreateSignatureDocumentation(sl()));
  sl.registerLazySingleton(() => CreateDraftDocumentation(sl()));
  sl.registerLazySingleton(() => CreateImageDocumentation(sl()));
  sl.registerLazySingleton(ImageConverter.new);
}

void _initAppointmentsDependencies() {
  sl.registerFactory(ScrollBloc.new);
  sl.registerFactory(BottomBarBloc.new);
  sl.registerFactory(SliderBloc.new);
  sl.registerFactory(() => LogoutBloc(
        logoutUser: sl(),
        authenticationRepository: sl(),
      ));
  sl.registerFactory(() => AssignmentsBloc(
        fetchAssignments: sl(),
        authenticationRepository: sl(),
      ));
  sl.registerFactory(
    () => DetailedAssignmentBloc(
      fetchDetailedAssignment: sl(),
      authenticationRepository: sl(),
      changeAssignmentState: sl(),
    ),
  );

  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => FetchAssignments(sl(), sl()));
  sl.registerLazySingleton(() => FetchDetailedAssignment(sl()));
  sl.registerLazySingleton(() => ChangeAssignmentState(sl()));

  sl.registerLazySingleton<MoreRepository>(() => MoreRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ));
  sl.registerLazySingleton<AssignmentsRepository>(
      () => AssignmentsRepositoryImpl(
            remoteDataSource: sl(),
            networkInfo: sl(),
          ));

  sl.registerLazySingleton<RemoteMoreDataSource>(
    () => RemoteMoreDataSourceImpl(
      client: sl(),
      sharedPrefs: sl(),
      packageInfo: sl(),
    ),
  );
  sl.registerLazySingleton<AssignmentsRemoteDataSource>(
    () => AssignmentsRemoteDataSourceImpl(
      client: sl(),
      sharedPrefs: sl(),
      packageInfo: sl(),
    ),
  );
}

void _initTimeRecorderDependencies() {
  sl.registerFactory(TimePickerCubit.new);
  sl.registerFactory(
      () => CreateDocumentationCubit(createTimeDocumentation: sl()));
  sl.registerLazySingleton(() => CreateTimeDocumentation(sl()));
  sl.registerLazySingleton<DocumentationRepository>(
      () => DocumentationRepositoryImpl(
            remoteDataSource: sl(),
            networkInfo: sl(),
          ));
  sl.registerLazySingleton<DocumentationRemoteDataSource>(
    () => DocumentationRemoteDataSourceImpl(
      client: sl(),
      sharedPrefs: sl(),
      packageInfo: sl(),
      multipartRequest: CraftboxMultipartRequest(),
    ),
  );
}

void _initAuthenticationDependencies() {
  sl.registerLazySingleton(() => AuthenticationRepository(sl()));
  sl.registerFactory(() => AuthenticationBloc(authenticationRepository: sl()));
}

void _initLoginDependencies() {
  // Bloc
  sl.registerFactory(() => LoginBloc(
        loginUser: sl(),
        formValidator: sl(),
        authenticationRepository: sl(),
      ));
  sl.registerFactory(
    () => ForgotPasswordBloc(postForgotPassword: sl(), formValidator: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => PostForgotPassword(sl()));

  // Repository
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ));

  // Data sources
  sl.registerLazySingleton<RemoteLoginDataSource>(
    () => RemoteLoginDataSourceImpl(
      client: sl(),
      sharedPrefs: sl(),
      packageInfo: sl(),
    ),
  );
}

void _initDocumentsDependencies() {
  // Bloc
  sl.registerFactory(
    () => FileManagementCubit(sl(), sl(), sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetFile(sl()));

  // Repository
  sl.registerLazySingleton<FileRepository>(() => FileRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ));

  // Data sources
  sl.registerLazySingleton<FileRemoteDataSource>(
    () => FileRemoteDataSourceImpl(
      client: sl(),
      sharedPrefs: sl(),
      packageInfo: sl(),
    ),
  );
  sl.registerLazySingleton<FileLocalDataSource>(FileLocalDataSourceImpl.new);

  // Utils
  sl.registerLazySingleton<FileOpener>(FileOpener.new);
}

void _initCoreDependencies() {
  sl.registerLazySingleton<DialogProvider>(DialogProvider.new);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<FormValidator>(FormValidator.new);
  sl.registerLazySingleton<AppRouter>(() => AppRouter(sl()));
  sl.registerLazySingleton(() => SharedPrefs(sl()));
}

Future<void> _initExternalDependencies() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  sl.registerLazySingleton(() => packageInfo);
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(http.Client.new);
  sl.registerLazySingleton(InternetConnectionChecker.new);
  sl.registerLazySingleton(AssignmentsRefiner.new);
}
