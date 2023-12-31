import 'package:formz/formz.dart';

// Define input validation errors
enum PasswordError { empty, length, format, equal }

// Extend FormzInput and provide the input type and error type.
class Password extends FormzInput<String, PasswordError> {


  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );

  // Call super.pure to represent an unmodified form input.
  const Password.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Password.dirty( String value ) : super.dirty(value);


  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == PasswordError.empty ) return 'This field required';
    if ( displayError == PasswordError.length ) return 'Minimum 6 characters';
    if ( displayError == PasswordError.format ) return 'Must have a capital letter, letters and a number.';
    if ( displayError == PasswordError.equal ) return 'Is not the same password';

    return null;
  }


  // Override validator to handle validating a given input value.
  @override
  PasswordError? validator(String value) {

    if ( value.isEmpty || value.trim().isEmpty ) return PasswordError.empty;
    if ( value.length < 6 ) return PasswordError.length;
    if ( !passwordRegExp.hasMatch(value) ) return PasswordError.format;
    if ( value != value ) return PasswordError.equal;

    return null;
  }
}