import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/config/app_config_extensions.dart';
import '../../../../constants/events_strings.dart';
import '../../providers/filters/event_filters_providers.dart';
import 'components/bottom_sheet_handle.dart';
import 'components/sheet_header.dart';
import 'filter_list.dart';

class EventFilterBottomSheet extends ConsumerWidget {
  const EventFilterBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      // Usar `ProviderScope` en el builder no es necesario porque
      // el sheet vive dentro del scope de la app.
      builder: (_) => const EventFilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: ref.uiConfig.filtersInitialSize,
      minChildSize: ref.uiConfig.filtersMinSize,
      maxChildSize: ref.uiConfig.filtersMaxSize,
      builder: (_, scrollController) {
        return _SheetContent(scrollController: scrollController);
      },
    );
  }
}

// ─── Sheet content ────────────────────────────────────────────────────────────

/// Contenido interno del sheet.
///
/// Separado de [EventFilterBottomSheet] para que [DraggableScrollableSheet]
/// reciba un builder limpio y el árbol de widgets quede plano.
class _SheetContent extends ConsumerWidget {
  const _SheetContent({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BottomSheetHandle(),
          AppSpacing.md.vGap,
          const SheetHeader(),
          AppSpacing.lg.vGap,
          Expanded(child: FilterList(scrollController: scrollController)),
          SizedBox(
            width: double.infinity,
            child: AppButton.primary(
              label: EventsStrings.applyFilters,
              onPressed: () {
                ref.read(draftEventFiltersProvider.notifier).commit();
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
