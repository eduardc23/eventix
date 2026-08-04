import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../../core/domain/result/result.dart';
import '../../../../../di/events_di_providers.dart';
import '../../../../../domain/entities/city_entity.dart';

part 'cities_notifier.g.dart';

@Riverpod(keepAlive: true)
class CitiesNotifier extends _$CitiesNotifier {
  @override
  Future<List<CityEntity>> build() async {
    final result = await ref.watch(getCitiesUseCaseProvider)();
    return switch (result) {
      Success(:final value) => value,
      Error(:final error) => throw error,
    };
  }

  Future<void> reload() async {
    ref.invalidateSelf();
    await future;
  }
}
