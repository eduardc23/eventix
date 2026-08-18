import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../constants/events_strings.dart';
import 'info_tile.dart';

class EventDetailInfoCards extends StatelessWidget {
  final String formattedDate;
  final String formattedTime;
  final String cityName;

  const EventDetailInfoCards({
    super.key,
    required this.formattedDate,
    required this.formattedTime,
    required this.cityName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InfoTile(
          icon: Icons.calendar_today_outlined,
          title: formattedDate,
          subtitle: formattedTime,
          semanticLabel: EventsStrings.dateTimeSemanticLabel(
            formattedDate,
            formattedTime,
          ),
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
