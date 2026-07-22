import 'package:freezed_annotation/freezed_annotation.dart';
import '../constants/events_firestore_constants.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
abstract class CategoryModel with _$CategoryModel {
  const CategoryModel._();

  const factory CategoryModel({
    String? uid,
    @JsonKey(name: EventsFirestoreConstants.nameField)
    required String name,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
