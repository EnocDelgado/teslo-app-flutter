
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final authRepoository = AuthRepositoryImpl();
  
  return AuthNotifier(
    authRepository: authRepoository
  );
});


class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository;

  AuthNotifier({ 
    required this.authRepository 
  }): super( AuthState() );

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

  void registerUser( String email, String password ) async {
    
  }

  void checkAuthStatus() async {
    
  }

  void _setLoggedUser( User user ) {

    //! todo save token on device
    
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
    );
  }

  Future<void> logout([ String? errorMessage ]) async {
    //! todo = clean token
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