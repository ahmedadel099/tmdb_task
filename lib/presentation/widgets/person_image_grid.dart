import 'package:flutter/material.dart';
import 'package:tmdb_task_app/data/models/person_image.dart';
import 'full_screen_image.dart';

class ImageGridView extends StatelessWidget {
  final List<PersonImage> images;

  const ImageGridView({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenImagePage(
                  imageUrl:
                      'https://image.tmdb.org/t/p/original${images[index].filePath}',
                ),
              ),
            );
          },
          child: Image.network(
            'https://image.tmdb.org/t/p/w200${images[index].filePath}',
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
