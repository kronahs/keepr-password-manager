import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:keepr/widgets/drawerWidget.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../services/local_authentication_services.dart';
import '../../services/theme_provider.dart';

enum ThemeModeType { light, dark, system }

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLocalAuthEnabled = false; // Initial value for local authentication switch
  ThemeModeType _selectedThemeMode = ThemeModeType.light; // Initial theme mode
  late final LocalAuthentication localAuth;
  bool _supportState = false;

  bool _isFingerprintEnabled = true; // Default value, you can set it based on user preferences from shared preferences or any other storage method.


  late String isSupported;
  @override
  void initState() {
    super.initState();
    localAuth = LocalAuthentication();
    localAuth.isDeviceSupported().then(
            (bool isSupported) => setState((){
          _supportState = isSupported;
        })
    );
  }
  @override
  Widget build(BuildContext context) {
    if(_supportState)
      isSupported = "This Device is supports fingerprint";
    else
      isSupported = 'This device doesnt not support fingerprint';

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Theme.of(context).hintColor,
      ),
      drawer: DrawerWidget(),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Local Authentication', style: Theme.of(context).textTheme.bodyLarge),
            tiles: [
              SettingsTile.navigation(
                title: Text('Fingerprint'),

                description: Text(isSupported),
              ),
              SettingsTile.navigation(
                title: Text('Fingerprint Authentication'),
                leading: FaIcon(FontAwesomeIcons.fingerprint),
                trailing: Switch(
                  value: _isLocalAuthEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isLocalAuthEnabled = value;
                      // Handle the logic when local authentication is enabled/disabled
                    });
                  },
                ),
              ),
              SettingsTile.navigation(
                title: Text('Master Password'),
                leading: Icon(IonIcons.lock_closed),
                description: Text('Change Master Pin'),
                onPressed: (context) async{
                   LocalAuthenticationHelper _localAuthHelper;
                   _localAuthHelper = LocalAuthenticationHelper();

                   await _localAuthHelper.authenticate() .then((value) => Navigator.pushReplacementNamed(context, '/master'));


                },
              ),

            ],
          ),
          SettingsSection(
            title: Text('Appearance', style: Theme.of(context).textTheme.bodyLarge),
            tiles: [
              SettingsTile.navigation(
                title: Text('Theme Mode'),
                leading: FaIcon(FontAwesomeIcons.palette),
                trailing: DropdownButton<ThemeModeType>(
                  value: _selectedThemeMode,
                  items: ThemeModeType.values.map((mode) {
                    return DropdownMenuItem<ThemeModeType>(
                      value: mode,
                      child: Text(_themeModeToString(mode)),
                    );
                  }).toList(),
                  onChanged: (mode) {
                    Provider.of<ThemeProvider>(context, listen: false).setThemeMode(_themeModeFromEnum(mode!));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _themeModeToString(ThemeModeType mode) {
    switch (mode) {
      case ThemeModeType.light:
        return 'Light';
      case ThemeModeType.dark:
        return 'Dark';
      case ThemeModeType.system:
        return 'System';
    }
  }
  ThemeMode _themeModeFromEnum(ThemeModeType mode) {
    switch (mode) {
      case ThemeModeType.light:
        return ThemeMode.light;
      case ThemeModeType.dark:
        return ThemeMode.dark;
      case ThemeModeType.system:
        return ThemeMode.system;
    }
  }
}
