import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keepr/services/SecureStorageService.dart';
import 'package:local_auth/local_auth.dart';

import '../../services/local_authentication_services.dart';
import '../../widgets/drawerWidget.dart';
import '../../widgets/homepage/SocialMediaFormModal.dart';
import '../../widgets/homepage/accountTabBar.dart';
import '../../widgets/homepage/topboard.dart';
import 'accountlist.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTabIndex = 0;
  bool _isKeyboardVisible = false; // Track keyboard visibility

  late LocalAuthenticationHelper _localAuthHelper;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _keyboardVisibilityListener();
    });
    _localAuthHelper = LocalAuthenticationHelper();
    _localAuthHelper.authenticate();



  }

  void _keyboardVisibilityListener() {
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    print('Keyboard Visibility: $isKeyboardVisible'); // Debug print
    setState(() {
      _isKeyboardVisible = isKeyboardVisible;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawerWidget()
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,

        elevation: 0.0,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: Column(
        children: [
          TopBoard(),
          SizedBox(height: 5), // Add spacing between TopBoard and custom tab bar
          AccountTabBar(
            onTabSelected: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
          ),
          SizedBox(height: 5),
          if (_selectedTabIndex == 0)
            AllPasswordsContent()
          else if (_selectedTabIndex == 1)
            FrequentlyUsedContent()
          else if (_selectedTabIndex == 2)
              RecentlyAddedContent(),
          SizedBox(height: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton( // Show FAB only when keyboard is not visible
        onPressed: () {
          showSMBottomSheet(context);
        },
        backgroundColor: Theme.of(context).hintColor,
        child: FaIcon(FontAwesomeIcons.plus),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
      ),
    );
  }
}

