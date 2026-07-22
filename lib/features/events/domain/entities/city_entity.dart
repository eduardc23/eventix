import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_entity.freezed.dart';

@freezed
abstract class CityEntity with _$CityEntity {
  const CityEntity._();

  const factory CityEntity({
    required String uid,
    required String name,
    required String department,
  }) = _CityEntity;
}
