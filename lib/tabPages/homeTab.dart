import 'dart:async';

import 'package:driver/push_Notification/push_notification.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../assistants/assistants_method.dart';
import '../global/global.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {

  GoogleMapController? newGoogleMapController ;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.0,
  );

  var  geolocator = Geolocator();
  LocationPermission ? _locationPermission;





  checkIfPermissionAllowed()async{
    _locationPermission = await Geolocator.requestPermission();
    if(_locationPermission == LocationPermission.denied){
      _locationPermission = await Geolocator.requestPermission();

    }
  }
  locateDriverPosition() async{
    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition= currentPosition;
    LatLng newPositon =LatLng(31.389534, 35.065219);

    LatLng LatLngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: LatLngPosition , zoom: 14);
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanReadableAddress = await AssistantsMethods.searchAddressForGeographicCoOrdinate(driverCurrentPosition!,context);
    print("this is you address : " + humanReadableAddress);
    AssistantsMethods.readDriverRatings(context);
  }

  readCurrentDriverInformation()async{
    currentFirebaseUser = fAuth.currentUser;
    await FirebaseDatabase.instance.ref()
        .child("driver")
        .child(currentFirebaseUser!.uid)
        .once()
        .then((DatabaseEvent snap)
    {
      if(snap.snapshot.value != null)
      {
        onlineDriverData.id = (snap.snapshot.value as Map)["id"];
        onlineDriverData.name = (snap.snapshot.value as Map)["name"];
        onlineDriverData.email = (snap.snapshot.value as Map)["email"];
        onlineDriverData.phone = (snap.snapshot.value as Map)["phone"];
        onlineDriverData.car_Color = (snap.snapshot.value as Map)["car-details"]["car-Color"];
        onlineDriverData.car_Moder = (snap.snapshot.value as Map)["car-details"]["car-Moder"];
        onlineDriverData.car_Number = (snap.snapshot.value as Map)["car-details"]["car-Number"];
        driverVehicleType = (snap.snapshot.value as Map)["car-details"]["type"];

        print("Car Details :: ");
        print(onlineDriverData.car_Color);
        print(onlineDriverData.car_Moder);
        print(onlineDriverData.car_Number);
      }
    });

    PushNotifications pushNotifications = PushNotifications();
    pushNotifications.initializedCloudMessaging(context);
    pushNotifications.generateToken();
    AssistantsMethods.readDriverEarnings(context);
  }


  @override
  void initState() {
    super.initState();
    checkIfPermissionAllowed();
    readCurrentDriverInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        "Main Screen" ,
        style: TextStyle(color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true ,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController  = controller ;
            locateDriverPosition();
          },
        ),
          //ui online offline drivers
          statusText != "Now Online"
              ? Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: Colors.black87,
          )
              : Container(),
          //button for offline online driver
          Positioned(
            top: statusText != "Now Online"
                ? MediaQuery.of(context).size.height * 0.46
                : 25,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (){
                      if(isDriverActives != true) //offline
                      {
                        driverOnlineNow();
                        updateDriversLocationAtRealTime();
                        setState(() //online
                         {
                          statusText = "Now Online";
                          isDriverActives = true;
                          ButtonColor = Colors.transparent;
                        });
                        //display Toes
                        Fluttertoast.showToast(msg: "You Are Online Now");
                      }
                      else{
                        driverIsOfflineNow();
                        setState(() {
                          statusText = "Now Offline";
                          isDriverActives = false;
                          ButtonColor = Colors.grey;
                        });
                        Fluttertoast.showToast(msg: "You Are Offline Now");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                   primary: ButtonColor,
                   padding:const  EdgeInsets.symmetric(horizontal: 18),
                   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),)
                   ),
                    child: statusText !="Now Online"
                        ?Text(
                      statusText,
                      style: const TextStyle(
                          fontSize: 16 ,
                          fontWeight:
                          FontWeight.bold,
                          color: Colors.white),
                    )
                        :const Icon(
                      Icons.phonelink_ring,
                      color: Colors.white,
                      size: 25,

                    ),
                ),
              ],
            ),

               ),
        ],

      ),
    );
  }
  driverOnlineNow ()async{

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    driverCurrentPosition = pos ;

    Geofire.initialize("activeDrivers");
    Geofire.setLocation(
        currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude
    );

    DatabaseReference ref =
    FirebaseDatabase.instance.ref().child("driver").child(currentFirebaseUser!.uid).child("newRideStatus");
    ref.set("idle"); //searching for a new request
    ref.onValue.listen((event) { });
}

updateDriversLocationAtRealTime(){
streamSubscriptionPosition = Geolocator.getPositionStream()
    .listen((Position position) {
  driverCurrentPosition = position;
  if(isDriverActives == true){
    Geofire.setLocation(currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude);

  }
  LatLng latlng = LatLng(
    driverCurrentPosition!.latitude,
    driverCurrentPosition!.longitude,
  );

  newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latlng));

});
}

driverIsOfflineNow(){
    Geofire.removeLocation(currentFirebaseUser!.uid);
    DatabaseReference? ref =
    FirebaseDatabase.instance.ref().child("driver").child(currentFirebaseUser!.uid).child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;
    SystemNavigator.pop();
    
    Future.delayed(const Duration(milliseconds: 2000),(){
      SystemChannels.platform.invokeMethod("SystemNavigator.pop");

    });
}
}
