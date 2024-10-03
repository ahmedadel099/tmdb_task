import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/person_repository.dart';
import '../bloc/person_bloc.dart';
import '../../core/di/injection_container.dart';
import '../widgets/person_image_grid.dart';

class PersonDetailsPage extends StatelessWidget {
  final int personId;

  const PersonDetailsPage({Key? key, required this.personId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PersonBloc(repository: getIt<PersonRepository>(),  )
        ..add(FetchPersonDetails(personId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Person Details'),
        ),
        body: BlocBuilder<PersonBloc, PersonState>(
          builder: (context, state) {
            if (state is PersonDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PersonDetailsLoaded) {
              final person = state.personDetails;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (person.profilePath != null)
                      Image.network(
                        'https://image.tmdb.org/t/p/w500${person.profilePath}',
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(person.name,
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 8),
                          if (person.birthday != null)
                            Text('Birthday: ${person.birthday}'),
                          if (person.placeOfBirth != null)
                            Text('Place of Birth: ${person.placeOfBirth}'),
                          const SizedBox(height: 16),
                          if (person.biography != null)
                            Text(person.biography!,
                                style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 24),
                          Text('Images',
                              style: Theme.of(context).textTheme.headlineLarge),
                          const SizedBox(height: 8),
                          ImageGridView(images: state.images),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is PersonError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
