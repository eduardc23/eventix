import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../core/presentation/utils/async_value_extensions.dart';
import '../../providers/list/events_notifier.dart';
import 'widgets/event_list.dart';
import 'widgets/event_list_empty.dart';
import 'widgets/event_list_error.dart';

class EventListBody extends ConsumerWidget {
  const EventListBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eventsProvider);

    return state.when(
      loading: () => const Center(child: AppLoader.medium()),
      skipLoadingOnReload: false,
      data: (events) {
        if (events.isEmpty) {
          return const EventListEmpty();
        }
        return RefreshIndicator(
          onRefresh: () => ref.read(eventsProvider.notifier).refresh(),
          child: EventList(events: events),
        );
      },
      error: (error, stackTrace) {
        return EventListError(failure: error.asFailure);
      },
    );
  }
}
