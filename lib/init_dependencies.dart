import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_out.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supbase = await Supabase.initialize(
    url: AppSecrets.supbaseUrl,
    anonKey: AppSecrets.supbaseAnonKey,
  );

  sl.registerLazySingleton(
    () => supbase.client,
  );

  // core
  sl.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() async {
  // Remote Data Source
  sl
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(supbase: sl()))

    // Repository
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(authRemoteDataSource: sl()))

    // Usecase
    ..registerFactory(() => UserSignUp(repository: sl()))
    ..registerFactory(() => UserSignIn(repository: sl()))
    ..registerFactory(() => CurrentUser(repository: sl()))
    ..registerFactory(() => UserSignOut(repository: sl()))

    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: sl(),
        userSignIn: sl(),
        currentUser: sl(),
        appUserCubit: sl(),
        userSignOut: sl(),
      ),
    );
}
