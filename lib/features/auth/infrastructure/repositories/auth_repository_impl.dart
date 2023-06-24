
import 'package:teslo_shop/features/auth/domain/domain.dart';
import '../infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository {

  final AuthDataSource dataSource;

  AuthRepositoryImpl({
    AuthDataSource? dataSource
  }): dataSource = dataSource ?? AuthDataSourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus( token );
  }

  @override
  Future<User> login(String emial, String password) {
    return dataSource.login( emial, password );
  }

  @override
  Future<User> register(String emial, String password, String fullName ) {
    return dataSource.register( emial, password, fullName );
  }


}