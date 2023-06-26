

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';

final goRouterNotifierProvider = Provider((ref) {

  final authNotifier = ref.read( authProvider.notifier );
  return GoRouterNotifier( authNotifier );
});

// refreshListenerable read the changeNotifier
class GoRouterNotifier extends ChangeNotifier {

  final AuthNotifier _authNotifier;

  AuthStatus _authStatus = AuthStatus.checking;
  // subscribe to this gestor state
  GoRouterNotifier(this._authNotifier){
    _authNotifier.addListener((state) {
      authStatus = state.authStatus;   
    });
  }

  AuthStatus get authStatus => _authStatus;

  set authStatus( AuthStatus value ) {
    _authStatus = value;
    notifyListeners();
  }
}