import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/core_di_providers.dart';
import '../data/datasources/events_datasource.dart';
import '../data/datasources/events_datasource_impl.dart';
import '../data/mappers/category_mapper.dart';
import '../data/mappers/city_mapper.dart';
import '../data/mappers/event_mapper.dart';
import '../data/repositories/events_repository_impl.dart';
import '../domain/repositories/events_repository.dart';
import '../domain/usecases/get_categories_usecase.dart';
import '../domain/usecases/get_cities_usecase.dart';
import '../domain/usecases/get_events_usecase.dart';

part 'events_di_providers.g.dart';

@riverpod
EventMapper eventMapper(Ref ref) => const EventMapperImpl();

@riverpod
CategoryMapper categoryMapper(Ref ref) => const CategoryMapperImpl();

@riverpod
CityMapper cityMapper(Ref ref) => const CityMapperImpl();

@riverpod
EventsDataSource eventsDataSource(Ref ref) {
  return EventsDatasourceImpl(
    firestore: ref.watch(firebaseFirestoreProvider),
    firebaseMapper: ref.watch(firebaseExceptionMapperProvider),
  );
}

@riverpod
EventsRepository eventsRepository(Ref ref) {
  return EventsRepositoryImpl(
    dataSource: ref.watch(eventsDataSourceProvider),
    eventMapper: ref.watch(eventMapperProvider),
    categoryMapper: ref.watch(categoryMapperProvider),
    cityMapper: ref.watch(cityMapperProvider),
    coreMapper: ref.watch(coreExceptionMapperProvider),
  );
}

@riverpod
GetEventsUseCase getEventsUseCase(Ref ref) {
  return GetEventsUseCase(ref.watch(eventsRepositoryProvider));
}

@riverpod
GetCategoriesUseCase getCategoriesUseCase(Ref ref) {
  return GetCategoriesUseCase(ref.watch(eventsRepositoryProvider));
}

@riverpod
GetCitiesUseCase getCitiesUseCase(Ref ref) {
  return GetCitiesUseCase(ref.watch(eventsRepositoryProvider));
}
