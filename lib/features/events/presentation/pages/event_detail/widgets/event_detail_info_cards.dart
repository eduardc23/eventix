import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/presentation/extensions/date_time_extensions.dart';
import '../../../constants/events_strings.dart';
import 'info_tile.dart';

class EventDetailInfoCards extends StatelessWidget {
  const EventDetailInfoCards({
    super.key,
    required this.date,
    required this.cityName,
  });

  final DateTime date;
  final String cityName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InfoTile(
          icon: Icons.calendar_today_outlined,
          title: date.toEventDatePart(),
          subtitle: date.toEventTimePart(),
          semanticLabel: date.toEventDateSemantic(),
        ),
        AppSpacing.md.hGap,
        InfoTile(
          icon: Icons.location_on_outlined,
          title: cityName,
          subtitle: EventsStrings.location,
          semanticLabel: EventsStrings.locationSemanticLabel(cityName),
        ),
      ],
    );
  }
}
