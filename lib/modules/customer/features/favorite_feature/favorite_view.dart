import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/modules/customer/features/favorite_feature/favorite_view_body.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('favorite'.tr),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            indicatorColor: ColorsData.primary,
            labelColor: ColorsData.font,
            unselectedLabelColor: ColorsData.font,
            tabs: [
              Tab(text: 'salon'.tr),
              Tab(text: 'cuts'.tr),
            ],
          ),
        ),
        body: const FavoriteViewBody(),
      ),
    );
  }
}
