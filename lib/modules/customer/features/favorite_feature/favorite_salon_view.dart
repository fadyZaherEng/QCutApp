import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/modules/auth/views/widgets/custom_text_form.dart';
import 'package:q_cut/modules/customer/features/home_features/home/models/barber_model.dart';
import 'package:q_cut/modules/customer/features/home_features/home/views/custom_recommended_result_list_view_item.dart';
import 'dart:convert';

class FavoriteSalonView extends StatefulWidget {
  const FavoriteSalonView({super.key});

  @override
  State<FavoriteSalonView> createState() => _FavoriteSalonViewState();
}

class _FavoriteSalonViewState extends State<FavoriteSalonView> {
  final NetworkAPICall _apiCall = NetworkAPICall();
  List<Barber> favorites = [];
  List<Barber> filteredFavorites = [];
  bool isLoading = true;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchFavorites() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await _apiCall.getData("${Variables.baseUrl}favoriteForUser");
      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          favorites = (data['favorites'] as List)
              .map((item) => Barber.fromJson(item))
              .toList();
          _filterFavorites();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ShowToast.showError(message: 'failedToFetchFavorites'.tr);
      }
    } catch (e) {
      setState(() => isLoading = false);
      ShowToast.showError(
          message: '${'errorOccurredWhileFetchingFavorites'.tr}: $e');
    }
  }

  void _filterFavorites() {
    if (searchQuery.isEmpty) {
      filteredFavorites = List.from(favorites);
    } else {
      filteredFavorites = favorites.where((barber) {
        final nameMatch =
            barber.fullName.toLowerCase().contains(searchQuery.toLowerCase());
        final salonMatch = barber.barberShop
                ?.toLowerCase()
                .contains(searchQuery.toLowerCase()) ??
            false;
        return nameMatch || salonMatch;
      }).toList();
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      _filterFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchFavorites,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    controller: _searchController,
                    style: Styles.textStyleS14W400(color: ColorsData.dark),
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'searchBarbersNameSalon'.tr,
                    fillColor: ColorsData.font,
                    onChanged: _onSearchChanged,
                  ),
                  SizedBox(height: 12.h),
                  const Divider(color: ColorsData.cardStrock),
                  SizedBox(height: 12.h),
                  Text(
                    "selectFromRecommendedResults".tr,
                    style: Styles.textStyleS14W400(),
                  ),
                  SizedBox(height: 6.h),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredFavorites.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: filteredFavorites.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 6.h),
                          child: CustomBarberShopWideCard(
                            barber: filteredFavorites[index],
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 70.h,
            color: Colors.grey,
          ),
          SizedBox(height: 16.h),
          Text(
            searchQuery.isNotEmpty
                ? "noMatchesFound".tr
                : "noFavoriteSalonsYet".tr,
            style: Styles.textStyleS16W600(color: Colors.grey),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              searchQuery.isNotEmpty
                  ? "tryDifferentSearchTerm".tr
                  : "youHaventAddedAnySalons".tr,
              textAlign: TextAlign.center,
              style: Styles.textStyleS14W400(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
