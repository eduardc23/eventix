import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../events/domain/entities/event_entity.dart';

part 'booking_checkout_providers.g.dart';

@riverpod
class BookingQuantity extends _$BookingQuantity {
  @override
  int build(EventEntity event) => 1;

  void updateQuantity(int value) {
    if (value >= 1 && value <= event.availableSpots) {
      state = value;
    }
  }
}

@riverpod
int bookingTotalPrice(Ref ref, EventEntity event) {
  final quantity = ref.watch(bookingQuantityProvider(event));
  return quantity * event.price;
}
