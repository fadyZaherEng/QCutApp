import 'package:flutter/material.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/barber/features/home_features/statistics_feature/views/widgets/b_statics_view_body.dart';

class BStaticsView extends StatelessWidget {
  const BStaticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsData.secondary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Statics', style: Styles.textStyleS16W700()),
      ),
      body: const BStaticsViewBody(),
    );
  }
}
