import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/di/core_di_providers.dart';
import '../../../../../../core/domain/result/result.dart';
import '../../../../../events/domain/entities/event_entity.dart';
import '../../../../di/booking_di_providers.dart';
import '../../../../domain/entities/create_booking_params.dart';
import 'booking_checkout_providers.dart';
import 'create_booking_state.dart';

part 'create_booking_provider.g.dart';

@riverpod
class CreateBookingNotifier extends _$CreateBookingNotifier {
  @override
  CreateBookingState build() => const CreateBookingState.initial();

  Future<void> createBooking(EventEntity event) async {
    // 1. Validar la sesión del usuario
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      return;
    }

    // 2. Extraer el estado actual de la reserva
    final quantity = ref.read(bookingQuantityProvider(event));
    final totalPrice = ref.read(bookingTotalPriceProvider(event));

    // 3. Ensamblar los parámetros de Clean Architecture
    final params = CreateBookingParams(
      userId: userId,
      eventId: event.uid,
      eventTitle: event.title,
      eventImageUrl: event.imageUrl,
      eventDate: event.date,
      tickets: quantity,
      totalPrice: totalPrice.toDouble(),
    );
    // 4. Ejecutar el caso de uso
    state = const CreateBookingState.loading();
    final result = await ref.read(createBookingUseCaseProvider)(params);

    state = switch (result) {
      Success() => const CreateBookingState.success(),
      Error(error: final failure) => CreateBookingState.failure(
        failure: failure,
      ),
    };
  }
}