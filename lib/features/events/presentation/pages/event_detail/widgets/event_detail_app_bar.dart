import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/event_entity.dart';

class EventDetailAppBar extends StatelessWidget {
  final EventEntity event;

  const EventDetailAppBar({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        background: AppImage.network(event.imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}
