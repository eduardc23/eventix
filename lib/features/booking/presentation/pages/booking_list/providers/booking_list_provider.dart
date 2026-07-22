import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/di/core_di_providers.dart';
import '../../../../../../core/domain/result/result.dart';
import '../../../../di/booking_di_providers.dart';
import '../../../../domain/entities/booking_entity.dart';
import '../../../../domain/use_cases/get_bookings_by_user_usecase.dart';

part 'booking_list_provider.g.dart';

@riverpod
class BookingList extends _$BookingList {
  @override
  Future<List<BookingEntity>> build() async {
    final userId = ref.watch(currentUserIdProvider);

    if (userId == null) return [];

    return _fetchBookings(userId);
  }

  Future<List<BookingEntity>> _fetchBookings(String userId) async {
    final result = await ref.read(getBookingsByUserUseCaseProvider)(
      GetBookingsByUserParams(userId: userId),
    );

    return switch (result) {
      Success(:final value) => value,
      Error(:final error) => throw error,
    };
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
List<BookingEntity> upcomingBookings(Ref ref) {
  final bookings = ref.watch(bookingListProvider).value ?? [];

  return bookings.where((b) => b.isFuture).toList()
    ..sort((a, b) => a.eventDate.compareTo(b.eventDate));
}

@riverpod
List<BookingEntity> pastBookings(Ref ref) {
  final bookings = ref.watch(bookingListProvider).value ?? [];

  return bookings.where((b) => b.isPast).toList()
    ..sort((a, b) => b.eventDate.compareTo(a.eventDate));
}
