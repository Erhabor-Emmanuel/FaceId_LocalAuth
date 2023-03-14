import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_ios/types/auth_messages_ios.dart';
import 'package:local_auth_android/local_auth_android.dart';


class LocalAuthApi{
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> hasBiometrics()async{
    try{
      return await _auth.canCheckBiometrics;
    } on PlatformException catch(e){
      return false;
    }
  }

  Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    try{
      return  await _auth.authenticate(
          localizedReason: 'Scan Face to Authenticate',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: 'Oops! Biometric authentication required!',
              cancelButton: 'No thanks',
            ),
            IOSAuthMessages(
              cancelButton: 'No thanks',
            ),
          ]
      );
    } on PlatformException catch(e){
      return false;
    }
  }
}