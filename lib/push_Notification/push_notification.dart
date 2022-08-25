import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver/global/global.dart';
import 'package:driver/models/userRideRequestInformation.dart';
import 'package:driver/push_Notification/notification_dialog_box.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class PushNotifications{

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializedCloudMessaging(BuildContext context) async{
    //1 Terminate : When the device is locked or the application is not running. عندما يكون التطبيق مغلق

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage){
      if(remoteMessage !=null){
        //display the user  ride request information.
        readUserRideRequestInformation(remoteMessage.data["rideRequestId"], context);
      }

    });

    //2 Background : When the application is open, however in the background (minimised) عندما يكون التطبيق فعال ولكنه غير مفتوح اي موجود في الخلفية بمعنى بدون الشاشة
     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {

       readUserRideRequestInformation(remoteMessage!.data["rideRequestId"], context);


     });
    //3 Foreground : When the application is open, in view & in use.  عندما يكون التطبيق ومفتوح ويتم العمل عليه
     FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {

       readUserRideRequestInformation(remoteMessage!.data["rideRequestId"], context);


     });
  }

  readUserRideRequestInformation(String userRideRequestId , BuildContext context ){
    FirebaseDatabase.instance.ref().child("All Ride Request").child(userRideRequestId).once().then((snapData)
    {
      if(snapData.snapshot.value != null){

        audioPlayer.open(Audio("music/music_notification.mp3"));
        audioPlayer.play();

       double originLat = double.parse((snapData.snapshot.value as Map)["origin"]["latitude"]);
       double originLng = double.parse((snapData.snapshot.value as Map)["origin"]["longitude"]);
       String originAddress = (snapData.snapshot.value as Map)["originAddress"];
       double destinationLat = double.parse((snapData.snapshot.value! as Map)["destination"]["latitude"]);
       double destinationLng = double.parse((snapData.snapshot.value! as Map)["destination"]["longitude"]);
       String destinationAddress = (snapData.snapshot.value as Map)["destinationAddress"];
       String userName = (snapData.snapshot.value as Map)["userName"];
      // String userPhone = (snapData.snapshot.value as Map)["userPhone"];
       String? rideRequestId = snapData.snapshot.key;

       UserRideRequestInformation userRideRequestDetails = UserRideRequestInformation();
       userRideRequestDetails.originLatLng = LatLng(originLat, originLng);
       userRideRequestDetails.originAddress = originAddress;

       userRideRequestDetails.destinationLatLng = LatLng(destinationLat, destinationLng);
       userRideRequestDetails.destinationAddress = destinationAddress;

        userRideRequestDetails.userName = userName;
        //userRideRequestDetails.userPhone = userPhone;

        userRideRequestDetails.rideRequestId = rideRequestId;


        showDialog(context: context,
           builder: (BuildContext context ) => NotificationDialogBox(
             userRideRequestDetails: userRideRequestDetails,
           )
       );
      }
      else{
        Fluttertoast.showToast(msg: "This Ride Request Id Not Exist");
      }
    });

  }


  Future  generateToken()async{
    String? registrationToken = await messaging.getToken();
    print("FCM resigtration Token");
    print(registrationToken);
    FirebaseDatabase.instance.ref().child("driver").child(currentFirebaseUser!.uid).child("token").set(registrationToken );

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");

  }
}


