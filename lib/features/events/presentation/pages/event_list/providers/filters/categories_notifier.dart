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
  FutureOr<List<CategoryEntity>> build() {
    final defaults = _defaultCategories;
    unawaited(_loadRemoteCategories(defaults));
    return defaults;
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    final result = await ref.read(getCategoriesUseCaseProvider)();

    state = switch (result) {
      Success(:final value) => AsyncData(value),
      Error(:final error) => AsyncError(error, StackTrace.current),
    };
  }

  List<CategoryEntity> get _defaultCategories {
    final categories = ref.read(appConfigProvider).defaults.categories;

    return List<CategoryEntity>.unmodifiable(
      categories.map(
        (category) => CategoryEntity(uid: category.uid, name: category.name),
      ),
    );
  }

  Future<void> _loadRemoteCategories(List<CategoryEntity> defaults) async {
    final result = await ref.read(getCategoriesUseCaseProvider)();

    switch (result) {
      case Success(:final value):
        state = AsyncData(value);
      case Error(:final error):
        if (defaults.isEmpty) {
          state = AsyncError(error, StackTrace.current);
        }
    }
  }
}
