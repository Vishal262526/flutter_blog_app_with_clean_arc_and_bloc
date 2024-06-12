import 'package:blog_app/core/error/server_exception.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

abstract interface class AuthRemoteDataSource {
  sb.Session? get currentUserSession;

  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final sb.SupabaseClient supbase;

  AuthRemoteDataSourceImpl({required this.supbase});

  @override
  sb.Session? get currentUserSession => supbase.auth.currentSession;

  @override
  Future<UserModel> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final authRes = await supbase.auth
          .signInWithPassword(email: email, password: password);

      if (authRes.user == null) {
        throw ServerException(errorMessage: "User is Null");
      }

      return UserModel.fromJson(authRes.user!.toJson());
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final authRes = await supbase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      if (authRes.user == null) {
        throw ServerException(errorMessage: "User is Null");
      }

      return UserModel.fromJson(authRes.user!.toJson());
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  // Get current user data
  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supbase
            .from("users")
            .select()
            .eq("id", currentUserSession!.user.id);

        return UserModel.fromJson(userData.first);
      }
      return null;
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supbase.auth.signOut();
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }
}
