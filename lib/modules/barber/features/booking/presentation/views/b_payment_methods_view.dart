import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/barber/features/booking/presentation/views/widgets/b_payment_methods_view_body.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/views/custom_b_drawer.dart';

class BPaymentMethodsView extends StatelessWidget {
  const BPaymentMethodsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomBDrawer(),
      appBar: AppBar(
        title: Text(
          'paymentMethods'.tr,
          style: Styles.textStyleS16W700(),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: SvgPicture.asset(AssetsData.menuIcon),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const BPaymentMethodsViewBody(),
    );
  }
}
