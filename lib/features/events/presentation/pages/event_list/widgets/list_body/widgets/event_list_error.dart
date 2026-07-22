import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../../core/domain/failures/app_failure.dart';
import '../../../../../constants/events_strings.dart';
import '../../../../../extensions/event_failure_message.dart';
import '../../../providers/list/events_notifier.dart';

class EventListError extends ConsumerWidget {
  const EventListError({super.key, required this.failure});

  final AppFailure failure;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppEmptyState(
      icon: Icons.wifi_off_outlined,
      title: EventsStrings.errorTitle,
      description: failure.toEventMessage,
      actionLabel: EventsStrings.retryAction,
      onAction: () {
        ref.invalidate(eventsProvider);
      },
    );
  }
}
