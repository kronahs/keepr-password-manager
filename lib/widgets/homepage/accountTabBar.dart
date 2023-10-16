import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'topboard.dart';

class AccountTabBar extends StatefulWidget {
  final ValueChanged<int> onTabSelected;

  const AccountTabBar({Key? key, required this.onTabSelected}) : super(key: key);

  @override
  State<AccountTabBar> createState() => _AccountTabBarState();
}

class _AccountTabBarState extends State<AccountTabBar> {
  int _selectedTabIndex = 0;
  final List<String> tabTitles = ['All Passwords', 'Frequently Used', 'Recently Added'];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 1,
          color: Colors.grey.shade400,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int index = 0; index < tabTitles.length; index++)
                GestureDetector(
                  onTap: () {
                    _selectedTabIndex = index;
                    widget.onTabSelected(index); // Call the callback function
                    setState(() {}); // Trigger a rebuild
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Text(
                      tabTitles[index],
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: _selectedTabIndex == index
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: (MediaQuery.of(context).size.width / tabTitles.length * _selectedTabIndex) + 16,
          child: Container(
            width: MediaQuery.of(context).size.width / tabTitles.length - 30,
            height: 2,
            color: Theme.of(context).primaryColor, // Use primary color for the underline
          ),
        ),
      ],
    );
  }
}
