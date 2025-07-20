import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:q_cut/core/utils/widgets/custom_app_bar.dart';
import 'package:q_cut/modules/customer/features/home/presentation/views/widgets/search_for_the_time_view_body.dart';

class SearchForTheTimeView extends StatelessWidget {
  const SearchForTheTimeView({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: CustomAppBar(
        title: "Search for the time".tr,
      ),
      body: SearchForTheTimeViewBody(),
    );
  }
}
