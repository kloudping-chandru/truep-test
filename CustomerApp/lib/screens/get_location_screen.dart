import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodizm_subscription/colors.dart';
import 'package:foodizm_subscription/screens/search_location_on_map_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/common.dart';
import '../models/nearby_places.dart';
import '../utils/utils.dart';
import 'package:http/http.dart' as http;

class GetLocationScreen extends StatefulWidget {
  const GetLocationScreen({Key? key}) : super(key: key);

  @override
  State<GetLocationScreen> createState() => _GetLocationScreenState();
}

class _GetLocationScreenState extends State<GetLocationScreen> {
  Utils textUtils = Utils();
  Rx<NearByPlaces> nearByPlaces = NearByPlaces().obs;
  Completer<GoogleMapController> mapController = Completer();
  Set<Marker> markers = {};
  double? lat,lng;
  //double? lat1,lng1;

  //RxDouble? lng=0.0.obs;
  String? address, city;
  LatLng needlePosition = LatLng(0.0, 0.0); // Initial position for the "needle" marker.


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserCurrentLocation();
  }

  getUserCurrentLocation() async {
    var status = await Permission.location.request();

    var accuracy = await Geolocator.getLocationAccuracy();
    bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();


    if (status == PermissionStatus.granted) {
      if(isLocationServiceEnabled)
        {
          try {
            await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) async {
              final GoogleMapController controller = await mapController.future;

              setState(() {
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(value.latitude, value.longitude), zoom: 17)));
                markers.add(Marker(markerId: const MarkerId("newLocation"), position: LatLng(value.latitude, value.longitude)));
                lat = value.latitude;
                lng = value.longitude;

                 needlePosition = LatLng(lat!, lng!); // Initial position for the "needle" marker.



                print('latititue${lat}');
                print('longitude${lng}');
                getNearByLocations();
              });
            });
          } catch (e) {
            print(e.toString());
          }
        }
      else
        {
          Fluttertoast.showToast(msg: "You need to allow location Service");
        }

    } else {
      Fluttertoast.showToast(msg: "You need to allow location permission in order to continue");
    }
  }

  getNearByLocations() async {
    String url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng" + "&radius=100&key=${Common.apiKey}";
    print('url:$url');
    http.Response response = await http.get(Uri.parse(url));
    print(response.statusCode);
    if (response.statusCode == 200) {
      nearByPlaces.value = NearByPlaces.fromJson(jsonDecode(response.body));
    } else {
      Fluttertoast.showToast(msg: "Something Went wrong in Get near by function");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: ()
            {
              Get.back();
            },
            child: Icon(Icons.arrow_back,color: Colors.black,)),
        elevation: 0.0,
        title: Text("Get Current Location",style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            onPressed: selectLocationOnMap,
            icon: const Icon(Icons.search, color: Colors.black),
          ),
          IconButton(
            onPressed: () {
              getUserCurrentLocation();
              nearByPlaces.value = NearByPlaces();
            },
            icon: const Icon(Icons.refresh, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 300,
            width: Get.width,
            child: GoogleMap(
              compassEnabled: false,
              mapToolbarEnabled: false,
              /// If you comment this below line your
              onMapCreated: onMapCreated,
              initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0), zoom: 17),
              onTap: _handleMapTap, // Listen for map taps.

              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              /// if you uncomment below marker and comment the current markers then user cant be seelcted location on map
              //markers: markers,
              markers: <Marker>[
                Marker(
                  markerId: MarkerId('needleNew'),
                  position: needlePosition, // Use the updated position here.
                  icon: BitmapDescriptor.defaultMarker,
                ),
              ].toSet(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back(result: ['', lat.toString(), lng.toString()]);
                    },
                    child: Container(
                      height: 100,
                      width: Get.width,
                      color:Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child:
                       Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade200,width: 1),


                            ),
                               child: Icon(Icons.my_location, color: Colors.blue, size: 20),


                          ),
                          // FloatingActionButton(
                          //   backgroundColor: Colors.white,
                          //   onPressed: null,
                          //   child: Icon(Icons.my_location, color: Colors.blue, size: 20),
                          // ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Send your current location",
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: AppColors.whiteColor,
                    width: Get.width,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "NearBy Places",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                SizedBox(height: 20,),
                  Obx(() {
                    if (nearByPlaces.value.results != null) {
                      if (nearByPlaces.value.results!.isNotEmpty) {
                        return Column(
                          children: [
                            for (int i = 0; i < nearByPlaces.value.results!.length; i++)
                              Container(
                                color: AppColors.whiteColor,
                                child: InkWell(
                                  onTap: () {
                                    Get.back(result: [
                                      '',
                                      nearByPlaces.value.results![i].geometry!.location!.lat.toString(),
                                      nearByPlaces.value.results![i].geometry!.location!.lng.toString()
                                    ]);
                                  },
                                  child: ListTile(
                                    title: textUtils.poppinsMediumText(
                                        nearByPlaces.value.results![i].name, 16.0, Colors.black, TextAlign.start),
                                    subtitle: textUtils.poppinsMediumText(
                                        nearByPlaces.value.results![i].vicinity, 16.0, Colors.black, TextAlign.start),
                                    leading: ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                                      child:
                                      Container(
                                        height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            shape: BoxShape.circle
                                          ),
                                          child: Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Image.network(nearByPlaces.value.results![i].icon!, height: 25, width: 25))),

                                      // child: FloatingActionButton(
                                      //   backgroundColor: Colors.grey.shade200,
                                      //   onPressed: null,
                                      //   //elevation: 20,
                                      //
                                      //   child: Image.network(nearByPlaces.value.results![i].icon!, height: 25, width: 25),
                                      // ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      } else {
                        return SizedBox(
                          height: 150,
                          child: Center(child: textUtils.poppinsBoldText('No Places Found', 22.0, Colors.blue, TextAlign.center)),
                        );
                      }
                    } else {
                      return const SizedBox(
                        height: 150,
                        child: Center(
                          child: CircularProgressIndicator(backgroundColor: Colors.white, color: Colors.blue),
                        ),
                      );
                    }
                  })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  void _handleMapTap(LatLng tappedPoint) {
    setState(() {
      // Update the marker's position to the tapped point.
      lat = tappedPoint.latitude;
      lng=tappedPoint.longitude;
      needlePosition = tappedPoint;
      print('Lat:$lat');
      print('Lng:$lng');

    });
  }
  void selectLocationOnMap() async {
    var result = await Get.to(() => const SearchLocationOnMapScreen());
    if (result != null) {
      Get.back(result: ['', result[1], result[2]]);
      debugPrint("Selected " + result.toString());
    }
  }

  void onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController.complete(controller);
    });
  }
}
