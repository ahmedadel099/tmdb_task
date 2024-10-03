import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../data/repositories/person_repository.dart';
import '../../presentation/bloc/person_image_bloc.dart';
import '../api/api_client.dart';
import '../../presentation/bloc/person_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Register Dio
  getIt.registerLazySingleton(() => Dio());

  // Register ApiClient
  getIt.registerLazySingleton(() => ApiClient(getIt<Dio>()));

  // Register PersonRepository
  getIt.registerLazySingleton(() => PersonRepository(getIt<ApiClient>()));

  // Register BLoCs
  getIt
      .registerFactory(() => PersonBloc(repository: getIt<PersonRepository>()));

  getIt.registerFactory(
      () => PersonImagesBloc(repository: getIt<PersonRepository>()));
}
