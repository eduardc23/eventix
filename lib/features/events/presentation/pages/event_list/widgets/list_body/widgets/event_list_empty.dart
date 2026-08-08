import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../core/config/app_config_extensions.dart';
import '../../../../../constants/events_strings.dart';
import '../../../providers/filters/event_filters_providers.dart';

class EventListEmpty extends ConsumerWidget {
  const EventListEmpty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppEmptyState(
      icon: Icons.event_busy_outlined,
      title: ref.emptyMessages.events.title,
      description: ref.emptyMessages.events.description,
      actionLabel: EventsStrings.clearFiltersAction,
      onAction: () {
        ref.read(appliedEventFiltersProvider.notifier).clearAll();
      },
    );
  }
}
