import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/event_status_enum.dart';

part 'event_entity.freezed.dart';

@freezed
abstract class EventEntity with _$EventEntity {
  const EventEntity._();

  const factory EventEntity({
    required String uid,
    required String title,
    required String description,
    required String categoryId,
    required String categoryName,
    required String cityId,
    required String cityName,
    required DateTime date,
    required int price,
    required int totalCapacity,
    required int availableSpots,
    required String imageUrl,
    required EventStatus status,
    required DateTime createdAt,
  }) = _EventEntity;

  bool get isFree => price == 0;

  bool get hasSpots => availableSpots > 0;

  bool get isBookable => status == EventStatus.active && hasSpots;

  double get capacityPercentage => totalCapacity == 0
      ? 0.0
      : (totalCapacity - availableSpots) / totalCapacity;
}
