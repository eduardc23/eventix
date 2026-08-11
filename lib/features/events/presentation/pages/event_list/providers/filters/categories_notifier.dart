import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../../core/domain/result/result.dart';
import '../../../../../di/events_di_providers.dart';
import '../../../../../domain/entities/category_entity.dart';

part 'categories_notifier.g.dart';

@Riverpod(keepAlive: true)
class CategoriesNotifier extends _$CategoriesNotifier {
  @override
  Future<List<CategoryEntity>> build() async {
    final result = await ref.watch(getCategoriesUseCaseProvider)();
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
