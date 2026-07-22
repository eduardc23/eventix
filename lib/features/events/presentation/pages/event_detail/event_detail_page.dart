import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../domain/entities/event_entity.dart';
import '../../extensions/event_ui_extensions.dart';
import 'widgets/event_detail_app_bar.dart';
import 'widgets/event_detail_bottom_bar.dart';
import 'widgets/event_detail_capacity_indicator.dart';
import 'widgets/event_detail_description.dart';
import 'widgets/event_detail_header.dart';
import 'widgets/event_detail_info_cards.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key, required this.event});

  final EventEntity event;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: true,
      safeAreaConfig: const AppScaffoldSafeArea(top: false),
      body: CustomScrollView(
        slivers: [
          EventDetailAppBar(event: event),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.md.all,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EventDetailHeader(
                    title: event.title,
                    categoryName: event.categoryName,
                  ),
                  AppSpacing.xl.vGap,
                  EventDetailInfoCards(
                    formattedDate: event.formattedDate,
                    formattedTime: event.formattedTime,
                    cityName: event.cityName,
                  ),
                  AppSpacing.xl.vGap,
                  EventDetailCapacityIndicator(
                    capacityPercentage: event.capacityPercentage,
                    availableSpots: event.availableSpots,
                  ),
                  AppSpacing.xl.vGap,
                  EventDetailDescription(description: event.description),
                  // Espacio extra para que el scroll no sea tapado por el bottom bar
                  AppSpacing.xl6.vGap,
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: EventDetailBottomBar(
        priceLabel: event.formattedPrice,
        action: event.bookingAction,
        onPressed: event.isBookable
            ? () {
                context.go(AppRoutes.eventBooking, extra: event);
              }
            : null,
      ),
    );
  }
}
