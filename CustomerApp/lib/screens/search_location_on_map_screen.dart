import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trupressed_subscription/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

import '../common/common.dart';
import '../utils/utils.dart';

class SearchLocationOnMapScreen extends StatefulWidget {
  const SearchLocationOnMapScreen({Key? key}) : super(key: key);

  @override
  State<SearchLocationOnMapScreen> createState() => _SearchLocationOnMapScreenState();
}

class _SearchLocationOnMapScreenState extends State<SearchLocationOnMapScreen> {

  Utils textUtils = Utils();
  Completer<GoogleMapController> mapController = Completer();
  Set<Marker> markers = {};
  double? lat, lng;
  String? address, city;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserCurrentLocation();
  }
  void getUserCurrentLocation() async {
    var status = await Permission.location.request();
    var accuracy = await Geolocator.getLocationAccuracy();
    bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();

    if (status == PermissionStatus.granted) {
      if(isLocationServiceEnabled)
        {
          await Geolocator.getCurrentPosition().then((value) async {
            final GoogleMapController controller = await mapController.future;
            setState(() {
              controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(value.latitude, value.longitude), zoom: 17)));
              markers.add(Marker(markerId: const MarkerId("newLocation"), position: LatLng(value.latitude, value.longitude)));
              lat = value.latitude;
              lng = value.longitude;
            });
          });
        }
      else
        {
          Fluttertoast.showToast(msg: "You need to allow location Service");
        }
    } else {
      Fluttertoast.showToast(msg: "You need to allow location permission in order to continue");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: textUtils.poppinsMediumText('Select Location',22.0, Colors.black, TextAlign.center),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.blue),
        ),
        key: homeScaffoldKey,
        body: Stack(
          children: [
            GoogleMap(
              compassEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: onMapCreated,
              initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0), zoom: 17),
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: markers,
              onTap: (LatLng pos) {
                setState(() {
                  lat = pos.latitude;
                  lng = pos.longitude;
                  markers.add(Marker(
                    markerId: const MarkerId("newLocation"),
                    position: pos,
                  ));
                });
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60,left: 8,right: 8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      textStyle: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      _handlePressButton();
                    },
                    child: const Text("Search"),
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 60,right: 10),
                child: SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.primaryColor,
                      textStyle: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      getUserCurrentLocation();
                    },
                    child: const Icon(Icons.my_location_rounded,color: Colors.white,),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.primaryColor,
                      textStyle: const TextStyle(color: AppColors.accentColor, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      getAddress();
                    },
                    child: const Text("Confirm"),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }

  void onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController.complete(controller);
    });
  }
  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Common.apiKey!,
      onError: onError,
      mode: Mode.overlay,
      language: "en-us",
      types: [""],
      strictbounds: false,
      decoration: InputDecoration(
        hintText: 'Search',

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      components: [Component(Component.country, "pk"), Component(Component.country, "in")],
    );
    displayPrediction(p!, homeScaffoldKey.currentState!);
  }

  Future<void> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: Common.apiKey!,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId.toString());
    lat = detail.result.geometry!.location.lat;
    lng = detail.result.geometry!.location.lng;
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat!, lng!), zoom: 17)));
    setState(() {
      markers.add(Marker(markerId: const MarkerId("newLocation"), position: LatLng(lat!, lng!)));
    });
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage.toString())),
    );
  }
  void getAddress() async {
    GeoData fetchGeocoder = await Geocoder2.getDataFromCoordinates(latitude: lat!, longitude: lng!, googleMapApiKey: Common.apiKey!);
    //var first = fetchGeocoder.first;
    Get.back(result: [fetchGeocoder.address, lat.toString(), lng.toString()]);
  }
}

