import 'package:flutter/material.dart';
import 'package:q_cut/modules/customer/features/home_features/home/views/widgets/how_many_consumer_bottom_sheet.dart';

void showHowManyConsumerBottomSheet(BuildContext context, {barber}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => HowManyConsumerBottomSheet(
      barber: barber,
    ),
  );
}
