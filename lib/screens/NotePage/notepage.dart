import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:keepr/widgets/drawerWidget.dart';
import 'package:keepr/widgets/notepage/note-list.dart';
import 'package:keepr/widgets/notepage/searchbar.dart';

class NotePage extends StatelessWidget {
  const NotePage({Key? key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
       backgroundColor: isDarkMode ? Theme.of(context).canvasColor  : Color(0xffe6e6e6),
      appBar: AppBar(
        title: Text('Notes'),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Theme.of(context).hintColor,

      ),

      drawer: DrawerWidget(),
      body: Column(
        children: [
          // Search bar at the top
          CustomSearchBar(),
          SizedBox(height: 80,),
          Expanded(
              child: NoteList()
          ),


        ],
      ),
      floatingActionButton: FloatingActionButton( // Show FAB only when keyboard is not visible
        onPressed: () {
          print('hi');
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
