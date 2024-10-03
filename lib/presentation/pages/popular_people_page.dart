// lib/presentation/pages/popular_people_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/person_repository.dart';
import '../bloc/person_bloc.dart';
import '../../core/di/injection_container.dart';
import '../widgets/person_list_item.dart';

class PopularPeoplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular People'),
      ),
      body: BlocProvider(
        create: (_) => PersonBloc(repository: getIt<PersonRepository>())
          ..add(FetchPersons()),
        child: PopularPeopleList(),
      ),
    );
  }
}

class PopularPeopleList extends StatefulWidget {
  @override
  _PopularPeopleListState createState() => _PopularPeopleListState();
}

class _PopularPeopleListState extends State<PopularPeopleList> {
  final _scrollController = ScrollController();
  late PersonBloc _personBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _personBloc = BlocProvider.of<PersonBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonBloc, PersonState>(
      builder: (context, state) {
        if (state is PersonInitial) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PersonLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PersonLoaded) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.persons.length
                  ? BottomLoader()
                  : PersonListItem(person: state.persons[index]);
            },
            itemCount: state.hasReachedMax
                ? state.persons.length
                : state.persons.length + 1,
            controller: _scrollController,
          );
        } else if (state is PersonError) {
          return Center(child: Text('Failed to fetch persons'));
        }
        return Container();
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) _personBloc.add(FetchPersons());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(strokeWidth: 1.5),
        ),
      ),
    );
  }
}
