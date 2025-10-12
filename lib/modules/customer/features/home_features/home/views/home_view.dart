import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/services/notification/notfication.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/modules/customer/features/home/presentation/views/widgets/custom_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/customer/features/home_features/home/logic/home_controller.dart';
import 'package:q_cut/modules/customer/features/home_features/home/views/widgets/custom_home_app_bar.dart';
import 'package:q_cut/modules/customer/features/home_features/home/views/widgets/nearby_salons_section.dart';
import 'package:q_cut/modules/customer/features/home_features/profile_feature/logic/profile_controller.dart';
import 'package:q_cut/modules/customer/features/home_features/profile_feature/models/customer_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double latitude = 0.0;
  double longitude = 0.0;

  // Initialize HomeController when the view is built
  final homeController = Get.put(HomeController());
  final ProfileController profileController = Get.put(ProfileController());
  String city = '';
  bool isSearching = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await fetchProfileData();
    await _determinePosition(context).then((Position? position) {
      latitude = position!.latitude;
      longitude = position.longitude;
      loadSelectedCities();
      setState(() {});
      if (selectedCities.isNotEmpty) {
        homeController.getBarbersCity(city: selectedCities.join(', '));
      } else {
        homeController.getNearestBarbers(longitude, latitude);
      }
      // homeController.getNearestBarbers(longitude, latitude);
    }).catchError((e) {
      // Handle the error, e.g., show a snackbar or dialog
      print(e);
    });
    // await _notificationListener();
  }

  Future<void> _notificationListener() async {
    print("Notification Listener Initialized");
    print(
        "onNotificationClick Stream home: ${onNotificationClick?.stream.toString()}");
    onNotificationClick?.stream.listen((event) {
      if (event.isNotEmpty) {
        print("event11111111111111111111 $event");
        _onNotificationClick(event);
      }
    });
  }

  void _onNotificationClick(event) {
    // Handle navigation based on notification payload
    Get.toNamed(AppRouter.notificationPath);
    onNotificationClick?.add("");
  }

  Future<void> fetchProfileData() async {
    final NetworkAPICall apiCall = NetworkAPICall();

    try {
      final response = await apiCall.getData(Variables.GET_PROFILE);
      final responseBody = json.decode(response.body);
      print("Profile response: ${response.body}");
      if (response.statusCode == 200) {
        final profileResponse = CustomerProfileResponse.fromJson(responseBody);
        profileController.profileData.value = profileResponse.data;
        profileController.fullNameController.text =
            profileResponse.data.fullName ?? '';
        city = profileResponse.data.city ?? '';
      }
    } catch (e) {}
  }

  Future<Position?> _determinePosition(context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error(
          'Location services are disabled. Please enable them.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Navigator.pop(context);
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Navigator.pop(context);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
    return position;
  }

  // ✅ multi selection
  List<String> selectedCities = [];
  final String _selectedCitiesKey = "selectedCities"; // مفتاح التخزين

  // ✅ استرجاع المدن المختارة من التخزين المحلي
  Future<void> loadSelectedCities() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedNames = prefs.getStringList(_selectedCitiesKey) ?? [];
    if (!mounted) return;
    setState(() {
      selectedCities = savedNames;
    });
  }

  DateTime? selectedDateTime;

  void _clearSelection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedCitiesKey);
    setState(() {
      selectedCities.clear();
      selectedDateTime = null;
    });
  }

  // @override
  // void dispose() {
  //   _clearSelection();
  //   return super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    loadSelectedCities();
      _notificationListener();


    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          isSearching = false;
          selectedCities.clear();
          selectedDateTime = null;
          _clearSelection();
        });
        await fetchProfileData();
        await _determinePosition(context).then((Position? position) {
          latitude = position!.latitude;
          longitude = position.longitude;
          homeController.getNearestBarbers(longitude, latitude);
        }).catchError((e) {
          // Handle the error, e.g., show a snackbar or dialog
          print(e);
        });
      },
      child: SafeArea(
          child: Scaffold(
        drawer: CustomDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomHomeAppBar(
                      onSearchTap: (query) {
                        homeController.searchBarbers(query);
                        setState(() {
                          isSearching = query.isNotEmpty;
                        });
                      },
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AssetsData.mapPinIcon,
                          width: 24.w,
                          height: 24.h,
                        ),
                        SizedBox(width: 2.w),
                        Flexible(
                          child: Text(
                            profileController.profileData.value?.city ?? city,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Styles.textStyleS12W400(),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        SvgPicture.asset(
                          AssetsData.downArrowIcon,
                          width: 24.w,
                          height: 24.h,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'startStylishJourney'.tr,
                      style: Styles.textStyleS16W700(color: ColorsData.primary),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(AppRouter.citySelectionPath)
                                  ?.then((value) {
                                if (value != null &&
                                    value.toString().isNotEmpty) {
                                  homeController.getBarbersCity(city: value);
                                } else {
                                  homeController.getNearestBarbers(
                                      longitude, latitude);
                                }
                              });
                            },
                            child: Container(
                              height: 42.h,
                              decoration: BoxDecoration(
                                color: ColorsData.font,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Center(
                                child: Text(
                                  selectedCities.isNotEmpty
                                      ? selectedCities.map((e) => e).join(', ')
                                      : "where".tr,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: Styles.textStyleS14W400(
                                      color: ColorsData.cardStrock),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(AppRouter.searchForTheTimePath)
                                  ?.then((selectedDateTime) {
                                if (selectedDateTime != null &&
                                    selectedDateTime is DateTime) {
                                  setState(() {
                                    this.selectedDateTime = selectedDateTime;
                                  });
                                  homeController.getAvailableBarbers(
                                    city: selectedCities.isNotEmpty
                                        ? selectedCities.first
                                        : "",
                                    startDate:
                                        selectedDateTime.millisecondsSinceEpoch,
                                    endDate: selectedDateTime
                                        .add(const Duration(days: 180))
                                        .millisecondsSinceEpoch,
                                  );
                                }
                              });
                            },
                            child: Container(
                              height: 42.h,
                              // ✅ same as "where"
                              decoration: BoxDecoration(
                                color: ColorsData.font,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                selectedDateTime != null
                                    ? "${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year}"
                                    : "when".tr,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Styles.textStyleS14W400(
                                    color: ColorsData.cardStrock),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    NearbySalonsSection(
                      isSearching: isSearching,
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
