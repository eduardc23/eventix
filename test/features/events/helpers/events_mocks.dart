// ignore_for_file: subtype_of_sealed_class
import 'package:eventix/features/events/data/datasources/events_datasource.dart';
import 'package:eventix/features/events/data/mappers/category_mapper.dart';
import 'package:eventix/features/events/data/mappers/city_mapper.dart';
import 'package:eventix/features/events/data/mappers/event_mapper.dart';
import 'package:eventix/features/events/domain/filters/event_filter.dart';
import 'package:eventix/features/events/domain/repositories/events_repository.dart';
import 'package:eventix/features/events/domain/usecases/get_categories_usecase.dart';
import 'package:eventix/features/events/domain/usecases/get_cities_usecase.dart';
import 'package:eventix/features/events/domain/usecases/get_events_usecase.dart';
import 'package:eventix/features/events/presentation/pages/event_list/providers/filters/event_filters_providers.dart';
import 'package:mocktail/mocktail.dart';

// --- Feature DataSources ---
class MockEventsDataSource extends Mock implements EventsDataSource {}

// --- Feature Repositories ---
class MockEventsRepository extends Mock implements EventsRepository {}

// --- Feature Use Cases ---
class MockGetEventsUseCase extends Mock implements GetEventsUseCase {}
class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}
class MockGetCitiesUseCase extends Mock implements GetCitiesUseCase {}

// --- Feature Mappers ---
class MockEventMapper extends Mock implements EventMapper {}
class MockCategoryMapper extends Mock implements CategoryMapper {}
class MockCityMapper extends Mock implements CityMapper {}

// --- Feature Providers ---
class MockDraftEventFilters extends DraftEventFilters with Mock {
  @override
  EventFilters build() => EventFilters.empty;
}

class MockAppliedEventFilters extends AppliedEventFilters with Mock {
  @override
  EventFilters build() => EventFilters.empty;
}
