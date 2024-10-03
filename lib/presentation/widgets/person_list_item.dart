// lib/presentation/widgets/person_list_item.dart

import 'package:flutter/material.dart';
import '../../data/models/person.dart';

class PersonListItem extends StatelessWidget {
  final Person person;

  const PersonListItem({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: person.profilePath != null
            ? NetworkImage(
                'https://image.tmdb.org/t/p/w200${person.profilePath}')
            : null,
        child: person.profilePath == null ? Icon(Icons.person) : null,
      ),
      title: Text(person.name),
      onTap: () {
        // TODO: Navigate to person details
      },
    );
  }
}
