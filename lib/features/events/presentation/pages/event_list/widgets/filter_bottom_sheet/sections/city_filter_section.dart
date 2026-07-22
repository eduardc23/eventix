import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../constants/events_strings.dart';
import '../../../providers/filters/cities_notifier.dart';
import '../components/async_filter_section.dart';
import '../components/filter_chip_group.dart';

class CityFilterSection extends ConsumerWidget {
  const CityFilterSection({
    super.key,
    required this.selectedCityId,
    required this.onCitySelected,
  });

  final String? selectedCityId;
  final void Function(String id, String name) onCitySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(citiesProvider);

    return AsyncFilterSection(
      state: state,
      icon: Icons.location_off_outlined,
      errorTitle: EventsStrings.citiesLoadError,
      onRetry: () => ref.read(citiesProvider.notifier).reload(),
      builder: (cities) => FilterChipGroup(
        items: cities,
        itemBuilder: (city) => AppChip.filter(
          label: city.name,
          selected: selectedCityId == city.uid,
          onSelected: (_) => onCitySelected(city.uid, city.name),
        ),
      ),
    );
  }
}
