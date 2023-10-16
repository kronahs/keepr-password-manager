import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import 'note-list.dart';


class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main content of your page
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).hintColor

          ),
          width: MediaQuery.of(context).size.width,
          height: 60,
          // Add your main container content here
        ),
        // Search TextField positioned above the main container's bottom border
        Positioned(
          bottom: -30, // Adjust this value to fit your design
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Iconsax.search_normal, color: Theme.of(context).hintColor,),
                  SizedBox(width: 20,),
                  Expanded(
                    child: TextFormField(
                      // Use the controller for this field
                      decoration: InputDecoration(
                        labelText: 'Search Notes',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -80, // Adjust the bottom position based on your design
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              ],
            ),
          ),
        )
      ],
    );
  }
}
