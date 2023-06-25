

import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
    )
  );

  @override
  Future<User> checkAuthStatus(String token) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) async {
    

    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password
      });

      final user = UserMapper.userJsonToEntity( response.data );

      return user;

    }  on DioException catch( e ) {

      if ( e.response?.statusCode == 401 ) { 
        throw CustomError( e.response?.data['message'] ?? 'Wrong credentials');
      }
      if ( e.type == DioExceptionType.connectionTimeout ) {
        throw CustomError('Check internet connection');
      }

      throw Exception();
    }catch ( error ) {
      throw Exception();
    }
    
  }

  @override
  Future<User> register(String email, String fullName, String password, ) async {
    

    try {
      final response = await dio.post('/auth/register', data: {
        'email': email,
        'fullName': fullName,
        'password': password
      });

      final user = UserMapper.userJsonToEntity( response.data );

      return user;

    } on DioException catch( e ) {

      if ( e.response?.statusCode == 400 ) { 
        throw CustomError( e.response?.data['message'] ?? 'Wrong credentials');
      }
      if ( e.type == DioExceptionType.connectionTimeout ) {
        throw CustomError('Check internet connection');
      }

      throw Exception();
    }catch ( error ) {
      throw Exception();
    }
  }


}