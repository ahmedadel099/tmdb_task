import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/person.dart';
import '../pages/person_details_page.dart';

class PersonListItem extends StatelessWidget {
  final Person person;

  const PersonListItem({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = person.profilePath != null
        ? 'https://image.tmdb.org/t/p/w200${person.profilePath}'
        : null;

    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
            : Icon(Icons.person, size: 30),
      ),
      title: Text(person.name),
      subtitle: Text(imageUrl ?? 'No image URL'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonDetailsPage(personId: person.id,),
          ),
        );
      },
    );
  }
}

