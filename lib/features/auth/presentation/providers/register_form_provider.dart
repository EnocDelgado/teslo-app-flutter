import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';

import '../../../shared/infrastructure/inputs/inputs.dart';

//! 3 - StateProviderNotifier

final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>( ( ref ) {

  final registerUserCallback = ref.watch( authProvider.notifier ).registerUser;

  return RegisterFormNotifier(
    registerUserCallback: registerUserCallback 
  );
});


//! 1 - Create State provider notifier
class RegisterFormState {

  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final FullName fullName;
  final Email email;
  final Password password;

  RegisterFormState({
    this.isPosting = false, 
    this.isFormPosted = false, 
    this.isValid = false,
    this.fullName = const FullName.pure(),
    this.email = const Email.pure(), 
    this.password = const Password.pure()
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    FullName? fullName,
    Email? email,
    Password? password
  }) => RegisterFormState(
    isPosting:  isPosting ?? this. isPosting,
    isFormPosted:  isFormPosted ?? this. isFormPosted,
    isValid:  isValid ?? this. isValid,
    fullName: fullName ?? this.fullName,
    email:  email ?? this. email,
    password:  password ?? this. password
  );


  @override
  String toString() {
    return '''
      RegisterFormState:
        isPosting: $isPosting
        isFormPosted: $isFormPosted
        isValid: $isValid
        fullName: $fullName
        email: $email
        password: $password
    ''';
  }
}

//! 2 - How to implemented
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  // refrence to register provider
  final Function( String, String, String ) registerUserCallback;

  RegisterFormNotifier({
     required this.registerUserCallback 
  }) : super( RegisterFormState() );

  onFullNameChange( String value ) {

    final newFullName = FullName.dirty( value );

    state = state.copyWith(
      fullName: newFullName,
      isValid: Formz.validate([ newFullName, state.email, state.password ])
    );
  }

  onEmailChange( String value ) {

    final newEmail = Email.dirty( value );

    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([ newEmail, state.password, state.fullName ])
    );
  }

  onPasswordChange( String value ) {

    final newPassword = Password.dirty( value );

    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([ newPassword, state.email, state.fullName ])
    );
  }

  onFormSubmit() async {
    _touchEveryField();

    if ( !state.isValid ) return;

    await registerUserCallback( state.fullName.value, state.email.value, state.password.value );

  }

  _touchEveryField() {

    final fullName = FullName.dirty( state.fullName.value );
    final email = Email.dirty( state.email.value );
    final passowrd = Password.dirty( state.password.value );

    state = state.copyWith(
      isFormPosted: true,
      fullName: fullName,
      email: email,
      password: passowrd,
      isValid: Formz.validate([ fullName, email, passowrd ])
    );
  }
}