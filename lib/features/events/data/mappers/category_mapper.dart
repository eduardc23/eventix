import '../../domain/entities/category_entity.dart';
import '../models/category_model.dart';

abstract interface class CategoryMapper {
  CategoryEntity toEntity(CategoryModel model);
  List<CategoryEntity> toEntityList(List<CategoryModel> models);
}

class CategoryMapperImpl implements CategoryMapper {
  const CategoryMapperImpl();

  @override
  CategoryEntity toEntity(CategoryModel model) => CategoryEntity(
        uid: model.uid,
        name: model.name,
      );

  @override
  List<CategoryEntity> toEntityList(List<CategoryModel> models) =>
      models.map(toEntity).toList();
}
