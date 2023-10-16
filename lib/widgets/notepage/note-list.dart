import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:keepr/models/note_models.dart';

import '../../repository/note_repository.dart';

class NoteList extends StatelessWidget {
  final NoteRepository _noteRepository = NoteRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NoteModel>>(
      stream: _noteRepository.fetchSecureNotesStream(),
      builder: (BuildContext context, AsyncSnapshot<List<NoteModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No notes available.'));
        } else {
          final List<NoteModel> notes = snapshot.data!;

          return MasonryGridView.builder(
            itemCount: notes.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (BuildContext context, int index) {
              final note = notes[index];
              return NoteCard(
                title: note.noteTitle,
                content: note.noteBody,
                date: note.editedDate,
                color: note.color,
              );
            },
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          );
        }
      },
    );
  }
}

class NoteCard extends StatelessWidget {
  final String title;
  final String content;
  final DateTime date;
  final int color;

  NoteCard({required this.title, required this.content, required this.date, required this.color});

  @override
  Widget build(BuildContext context) {
    bool changeDateColor = false;
    if (color != Colors.white.value) {
      changeDateColor = true;
    }
    return InkWell(
      onTap: () {
        print(color);
      },
      child: Container(
        padding: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: Color(color),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date.toLocal().toString(),
              style: TextStyle(fontSize: 12.0, color: changeDateColor ? Colors.black : Colors.grey, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: changeDateColor ? Colors.white : Colors.black),
            ),
            SizedBox(height: 8.0),
            Text(
              content,
              style: TextStyle(fontSize: 14.0, color: changeDateColor ? Colors.white : Colors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
