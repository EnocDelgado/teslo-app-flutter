

import 'package:teslo_shop/features/auth/domain/domain.dart';

abstract class AuthDataSource {

  Future<User> login( String emial, String password );
  Future<User> register( String emial, String password, String fullName );

  // determine if user is authenticated
  Future<User> checkAuthStatus( String token );
}