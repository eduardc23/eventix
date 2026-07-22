import 'package:freezed_annotation/freezed_annotation.dart';
import '../constants/events_firestore_constants.dart';

part 'city_model.freezed.dart';
part 'city_model.g.dart';

@freezed
abstract class CityModel with _$CityModel {
  const CityModel._();

  const factory CityModel({
    String? uid,
    @JsonKey(name: EventsFirestoreConstants.nameField)
    required String name,
    @JsonKey(name: EventsFirestoreConstants.cityDepartmentField)
    required String department,
  }) = _CityModel;

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);
}
