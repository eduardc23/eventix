import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/presentation/extensions/date_time_extensions.dart';
import 'package:eventix/core/presentation/extensions/price_extensions.dart';

import '../../domain/entities/booking_entity.dart';
import 'booking_int_extensions.dart';

extension BookingEntityUIX on BookingEntity {
  /// Mapea una entidad de reserva al modelo de datos de la UI.
  BookingCardData get toCardData => BookingCardData(
    imageUrl: eventImageUrl,
    title: eventTitle,
    dateLabel: eventDate.toEventDate(),
    dateSemanticLabel: eventDate.toEventDateSemantic(),
    ticketsLabel: tickets.toTicketsLabel(),
    ticketsSemanticLabel: tickets.toTicketsSemanticLabel(),
    priceLabel: totalPrice.toFormattedPrice(),
    priceSemanticLabel: totalPrice.toSemanticPrice(),
  );
}
