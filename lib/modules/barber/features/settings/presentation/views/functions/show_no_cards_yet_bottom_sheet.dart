import 'package:flutter/material.dart';
import 'package:q_cut/modules/customer/features/settings/presentation/views/widgets/no_cards_yet_bottom_sheet.dart';

void showNoCardsYetBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const NoCardsYetBottomSheet(),
  );
}
