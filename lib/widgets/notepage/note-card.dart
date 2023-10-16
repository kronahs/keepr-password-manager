import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Note Title',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Note Content goes here. You can add any text or additional information about your note.',
            style: TextStyle(fontSize: 14.0),
          ),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.star_border),
                onPressed: () {
                  // Handle favorite action
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Handle delete action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
