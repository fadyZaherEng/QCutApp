import 'package:flutter/material.dart';
import 'package:q_cut/modules/customer/features/favorite_feature/favorite_salon_view.dart';
import 'package:q_cut/modules/customer/features/favorite_feature/favorite_cuts_view.dart';

class FavoriteViewBody extends StatelessWidget {
  const FavoriteViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBarView(
      children: [
        FavoriteSalonView(),
        FavoriteCutsView(),
      ],
    );
  }
}
