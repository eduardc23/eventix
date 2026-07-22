import '../../domain/entities/city_entity.dart';
import '../models/city_model.dart';

abstract interface class CityMapper {
  CityEntity toEntity(CityModel model);
  List<CityEntity> toEntityList(List<CityModel> models);
}

class CityMapperImpl implements CityMapper {
  const CityMapperImpl();

  @override
  CityEntity toEntity(CityModel model) => CityEntity(
        uid: model.uid ?? '',
        name: model.name,
        department: model.department,
      );

  @override
  List<CityEntity> toEntityList(List<CityModel> models) =>
      models.map(toEntity).toList();
}
