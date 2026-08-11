import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../../core/config/app_config_provider.dart';
import '../../../../../../../core/domain/result/result.dart';
import '../../../../../di/events_di_providers.dart';
import '../../../../../domain/entities/category_entity.dart';

part 'categories_notifier.g.dart';

@Riverpod(keepAlive: true)
class CategoriesNotifier extends _$CategoriesNotifier {
  @override
  FutureOr<List<CategoryEntity>> build() async {
    final categories = ref.watch(appConfigProvider).defaults.categories;

    final defaults = List<CategoryEntity>.unmodifiable(
      categories.map(
        (category) => CategoryEntity(uid: category.uid, name: category.name),
      ),
    );

    state = AsyncData(defaults);

    final result = await ref.watch(getCategoriesUseCaseProvider)();

    return switch (result) {
      Success(:final value) => value,
      Error(:final error) => defaults.isEmpty ? throw error : defaults,
    };
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    final result = await ref.read(getCategoriesUseCaseProvider)();

    state = switch (result) {
      Success(:final value) => AsyncData(value),
      Error(:final error) => AsyncError(error, StackTrace.current),
    };
  }
}
