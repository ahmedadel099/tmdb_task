import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/person.dart';
import '../../data/repositories/person_repository.dart';
import '../bloc/person/person_bloc.dart';
import '../bloc/person/person_event.dart';
import '../bloc/person/person_state.dart';
import '../widgets/bottom_loader.dart';
import '../widgets/person_list_item.dart';
import '../../core/di/injection_container.dart';
import '../../core/network/network_info.dart';

class PopularPeoplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PersonBloc(
        repository: getIt<PersonRepository>(),
        networkInfo: getIt<NetworkInfo>(),
      )..add(CheckConnectivity()),
      child: PopularPeopleView(),
    );
  }
}

class PopularPeopleView extends StatefulWidget {
  @override
  _PopularPeopleViewState createState() => _PopularPeopleViewState();
}

class _PopularPeopleViewState extends State<PopularPeopleView> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular People'),
      ),
      body: BlocBuilder<PersonBloc, PersonState>(
        builder: (context, state) {
          if (state is PersonInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PersonLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PersonLoaded) {
            return _buildPersonList(state.persons, state.hasReachedMax);
          } else if (state is PersonOffline) {
            return Column(
              children: [
                Container(
                  color: Colors.red,
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'You are offline. Showing cached data.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(child: _buildPersonList(state.cachedPersons, true)),
              ],
            );
          } else if (state is PersonError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildPersonList(List<Person> persons, bool hasReachedMax) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return index >= persons.length
            ? BottomLoader()
            : PersonListItem(person: persons[index]);
      },
      itemCount: hasReachedMax ? persons.length : persons.length + 1,
      controller: _scrollController,
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

