import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/error/server_exception.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;
  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, User>> logInWithEmailAndPassword(
      {required String email, required String password}) async {
    return await _authenticate(() => authRemoteDataSource
        .logInWithEmailAndPassword(email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _authenticate(() =>
        authRemoteDataSource.signUpWithEmailAndPassword(
            name: name, email: email, password: password));
  }

  Future<Either<Failure, User>> _authenticate(
      Future<User> Function() func) async {
    try {
      if (!(await connectionChecker.isConnected)) {
        return left(
            Failure(errorMessage: "You are not Connected to the internet"));
      }
      final user = await func();
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(errorMessage: e.message));
    } on ServerException catch (e) {
      return left(Failure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUserData() async {
    try {
      if (!(await connectionChecker.isConnected)) {
        final session = authRemoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failure(errorMessage: "User is not Logged in"));
        }

        return right(User(
            uid: session.user.id, name: "", email: session.user.email ?? ""));
      }

      final user = await authRemoteDataSource.getCurrentUserData();

      if (user == null) {
        return left(Failure(errorMessage: "User is not Logged in"));
      }

      return right(user);
    } on sb.PostgrestException catch (e) {
      return left(Failure(errorMessage: e.message));
    } catch (e) {
      return left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await authRemoteDataSource.signOut();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(errorMessage: e.toString()));
    }
  }
}
