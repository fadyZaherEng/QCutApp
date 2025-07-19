import 'package:flutter/material.dart';
import 'package:q_cut/modules/customer/features/settings/presentation/views/widgets/my_cards_bottom_sheet.dart';

void showMyCardsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => const MyCardsBottomSheet(),
  );
}
