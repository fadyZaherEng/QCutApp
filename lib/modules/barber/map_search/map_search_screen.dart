// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/modules/barber/map_search/widgets/header_widget.dart';

class MapSearchScreen extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  final Function(double latitude, double longitude, String address)
      onLocationSelected;

  const MapSearchScreen({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
    required this.onLocationSelected,
  });

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  LatLng? _currentPosition;
  late GoogleMapController _currentMapController;
  Set<Marker> markers = {};
  List<dynamic> _predictions = [];
  String address = '';
  bool _isSearch = true;

  @override
  void initState() {
    _mapPreProcessing();
    super.initState();
  }

  Future<List<dynamic>> _getPredictions(String input) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${"AIzaSyDIC2N5UajvIfWd0858c1Z0JDZ6R-78e2w"}',
    );
    final response = await http.get(url);
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      return data['predictions'];
    }
    return [];
  }

  Future<Map<String, dynamic>?> _getPlaceDetails(String placeId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=${"AIzaSyDIC2N5UajvIfWd0858c1Z0JDZ6R-78e2w"}',
    );
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    if (data['status'] == 'OK') {
      return data['result'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          _searchController.text.isNotEmpty ? false : true,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _currentPosition?.latitude ?? widget.initialLatitude,
                _currentPosition?.longitude ?? widget.initialLongitude,
              ),
              zoom: 13,
            ),
            onMapCreated: _onMapCreated,
            onTap: (argument) {
              debugPrint("Latitude: ${argument.latitude}");
              debugPrint("Longitude: ${argument.longitude}");
              markers.clear();
              markers.add(
                Marker(
                  markerId: const MarkerId("1"),
                  position: LatLng(argument.latitude, argument.longitude),
                ),
              );
              _changeLocation(
                  10, LatLng(argument.latitude, argument.longitude));

              setState(() {
                _setAddress(argument.latitude, argument.longitude);
              });
            },
            markers: markers,
          ),
          if (false)
            Positioned(
              top: 40,
              right: 10,
              left: 10,
              child: HeaderWidget(
                predictions: _predictions,
                searchController: _searchController,
                getPredictions: (value) async {
                  if (_isSearch) {
                    _isSearch = false;
                    _getPredictions(value).then((predictionsList) {
                      setState(() {
                        _predictions = predictionsList;
                      });
                    });
                    Future.delayed(const Duration(milliseconds: 1300))
                        .then((value) {
                      _isSearch = true;
                    });
                  }
                },
                clearSearch: () {
                  _searchController.clear();
                  setState(() {
                    _predictions.clear();
                  });
                },
              ),
            ),
          if (_predictions.isNotEmpty)
            Positioned(
              bottom: 125,
              right: 10,
              left: 10,
              child: Container(
                color: Colors.white,
                height: 150,
                child: ListView.builder(
                  itemCount: _predictions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        _predictions[index]['description'],
                        style: const TextStyle(color: Colors.black),
                      ),
                      onTap: () async {
                        final details = await _getPlaceDetails(
                          _predictions[index]['place_id'],
                        );
                        if (details != null) {
                          address = details['formatted_address'] ?? '';
                          final lat = details['geometry']['location']['lat'];
                          final lng = details['geometry']['location']['lng'];
                          _changeLocation(10, LatLng(lat, lng));
                          _predictions.clear();
                          setState(() {});
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.08,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsData.primary,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "confirmLocation".tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, address);
                      widget.onLocationSelected(_currentPosition!.latitude,
                          _currentPosition!.longitude, address);
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.25,
            right: 12,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsData.primary,
                shape: const CircleBorder(),
              ),
              onPressed: () {
                _determinePosition(context).then((value) {
                  if (value != null) {
                    _changeLocation(
                      13,
                      LatLng(value.latitude, value.longitude),
                    );
                  }
                });
              },
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
                size: 24,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    Completer<GoogleMapController> gmCompleter = Completer();
    gmCompleter.complete(controller);
    gmCompleter.future.then((gmController) {
      _currentMapController = gmController;
    });
  }

  void _setCurrentLocation(LatLng currentPosition) {
    _currentPosition = currentPosition;
    setState(() {});
  }

  void _addMarkerToMap(LatLng currentPosition) {
    markers.add(
      Marker(
        markerId: const MarkerId("1"),
        position: LatLng(currentPosition.latitude, currentPosition.longitude),
      ),
    );
  }

  void _mapPreProcessing() async {
    try {
      Position? currentPosition = await _determinePosition(context);
      if (currentPosition != null) {
        final latLng =
            LatLng(currentPosition.latitude, currentPosition.longitude);
        _setCurrentLocation(latLng);
        _addMarkerToMap(latLng);
        _changeLocation(15, latLng);
      }
    } catch (e) {
      // fallback لو حصل خطأ
      final fallback = LatLng(widget.initialLatitude, widget.initialLongitude);
      _setCurrentLocation(fallback);
      _addMarkerToMap(fallback);
      _changeLocation(13, fallback);
    }
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

    // تعيين العنوان من الموقع الحالي
    _setAddress(position.latitude, position.longitude);

    return position;
  }

  void _changeLocation(double zoom, LatLng latLng) {
    double newZoom = zoom > 13 ? zoom : 13;
    _currentPosition = latLng;
    setState(() {
      _currentMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: newZoom)));
      markers.clear();
      _currentPosition = latLng;
      markers.add(
        Marker(markerId: const MarkerId('1'), position: latLng),
      );
    });
  }

  void _setAddress(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String fullAddress = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.country,
      ].where((element) => element != null && element.isNotEmpty).join(', ');
      address = fullAddress;
      setState(() {});
    }
  }
}
