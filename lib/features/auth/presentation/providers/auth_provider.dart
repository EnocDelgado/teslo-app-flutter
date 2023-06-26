
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/shared/services/key_value_storage.dart';
import 'package:teslo_shop/features/shared/services/key_value_storage_impl.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final authRepoository = AuthRepositoryImpl();
  final keyValueStorage = KeyValueStorageServiceImpl();
  
  return AuthNotifier(
    authRepository: authRepoository,
    keyValueStorageService: keyValueStorage
  );
});


class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({ 
    required this.authRepository,
    required this.keyValueStorageService
  }): super( AuthState() ) {
    checkAuthStatus();
  }

  Future<void> loginUser( String email, String password ) async {

    await Future.delayed( const Duration( milliseconds: 500 ) );

    try {

      final user = await authRepository.login( email, password );

      _setLoggedUser( user );

    } on CustomError catch( error ) {

      logout( error.message );

    }  catch ( error )  {
      logout('Error not controlled');
    }

  }

  Future<void> registerUser( String email, String fullName, String password ) async {

    await Future.delayed( const Duration( milliseconds: 500 ) );

    try {

      final user = await authRepository.register( email, fullName, password );

      _setLoggedUser( user );

    } on CustomError catch( error ) {

      logout( error.message );

    }  catch ( error )  {
      logout('Error not controlled');
    }
    
  }

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');

    if ( token == null ) return logout();

    try {
      final user = await authRepository.checkAuthStatus( token );

      _setLoggedUser( user );

    } catch ( error ) {
      logout();
    }
  }

  void _setLoggedUser( User user ) async {
    // storage token onm device
    await keyValueStorageService.setKeyValue( 'token', user.token );
    
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: ''
    );
  }

  Future<void> logout([ String? errorMessage ]) async {
    // clear token
    await keyValueStorageService.removeKey( 'token' );

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage
    );
  }

}

enum AuthStatus { checking,  authenticated, notAuthenticated }

class AuthState {

  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking, 
    this.user, 
    this.errorMessage = ''
  });


  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this. user,
    errorMessage: errorMessage ?? this.errorMessage
  );

}