

import 'package:teslo_shop/features/auth/domain/domain.dart';

abstract class AuthDataSource {

  Future<User> login( String email, String password );
  Future<User> register( String email, String fullName, String password );

  // determine if user is authenticated
  Future<User> checkAuthStatus( String token );
}