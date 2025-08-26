import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:q_cut/core/utils/widgets/custom_app_bar.dart';
import 'package:q_cut/modules/barber/features/booking/presentation/views/pay_to_qcut_feature/view/b_pay_to_q_cut_view_body.dart';

class BPayToQCutView extends StatelessWidget {
  const BPayToQCutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Pay to QCUT".tr),
      body: BPayToQCutViewBody(),
    );
  }
}
