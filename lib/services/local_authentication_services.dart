import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthenticationHelper {
  late final LocalAuthentication _localAuth;
  bool _isDeviceSupported = false;

  LocalAuthenticationHelper() {
    _localAuth = LocalAuthentication();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    _isDeviceSupported = await _localAuth.isDeviceSupported();
  }

  Future<bool> get isDeviceSupported async {
    return _isDeviceSupported;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
    return availableBiometrics;
  }

  Future<void> authenticate() async {
    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Keepr Authentication',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );

      if (!authenticated) {
        // Authentication failed, close the app
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    } on PlatformException catch (e) {
      // Handle platform-specific exceptions
      print('Platform Exception: $e');
    } on Exception catch (e) {
      // Handle other general exceptions
      print('Error: $e');
    }
  }
}
