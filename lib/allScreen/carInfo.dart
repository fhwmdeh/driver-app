import 'package:driver/allScreen/splashScreen.dart';
import 'package:driver/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({Key? key}) : super(key: key);
  static const String idScreen = "CarInfoScreen";

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController = TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();


  List<String> carTypeList = ["Uber-X","Uber-go","Bike"];
  String ? selectedCarTypes;
  saveCarInfo() {
    Map drivercarInfoMap = {
      "car-Color": carColorTextEditingController.text.trim(),
      "car-Moder": carModelTextEditingController.text.trim(),
      "car-Number": carNumberTextEditingController.text.trim(),
      "type": selectedCarTypes,
    };
    DatabaseReference driverRef = FirebaseDatabase.instance.ref("driver");
    driverRef.child(currentFirebaseUser!.uid).child("car-details").set(drivercarInfoMap);
    Fluttertoast.showToast(msg: "Car Details Has Been Saved");
    Navigator.push(context, MaterialPageRoute(builder: (c) =>  mysplashscreen()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Padding(padding: const EdgeInsets.all(20.0)),
               Image.asset("images/car.jpg"),
               SizedBox(height: 20.0,),
               Text("Cars Details " ,style: TextStyle(fontWeight: FontWeight.bold , fontSize: 30.0),),
               SizedBox(height: 20.0,),
               TextField(
                 controller: carModelTextEditingController,
                 keyboardType: TextInputType.emailAddress,
                 autofocus: false,
                 decoration: InputDecoration(
                   hintText: 'Car Model',
                   contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                 ),
               ),
               SizedBox(height: 15.0,),
               TextField(
                 controller: carNumberTextEditingController,
                 keyboardType: TextInputType.number,
                 autofocus: false,
                 decoration: InputDecoration(
                   hintText: 'Car Number',
                   contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                 ),
               ),
               SizedBox(height: 15.0,),
               TextField(
                 controller: carColorTextEditingController,
                 keyboardType: TextInputType.text,
                 autofocus: false,
                 decoration: InputDecoration(
                   hintText: 'Car Color',
                   contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                 ),
               ),
               DropdownButton(
                 icon: Icon(Icons.dehaze_rounded),
                 hint: const Text("Please Choose Car Type",
                 style: TextStyle(
                   color: Colors.grey,
                   fontSize: 14.0,

                 ),
                 ),
                   value: selectedCarTypes,
                   items: carTypeList.map((car){
                     return DropdownMenuItem(
                         child: Text(car , style: TextStyle(color: Colors.black),),
                         value: car,
                     );
                   }).toList(),
                   onChanged:(newValue){
                   setState(() {
                     selectedCarTypes = newValue.toString();
                   });
                   }

               ),
               SizedBox(height: 20.0,),
               ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     primary: Colors.black,
                     padding: EdgeInsets.symmetric(horizontal: 50),
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(24)),

                   ),
                   onPressed: (){
                     if(carColorTextEditingController.text.isNotEmpty
                         && carModelTextEditingController.text.isNotEmpty
                     && carNumberTextEditingController.text.isNotEmpty && selectedCarTypes!=null){

                       saveCarInfo();

                     }

                   },
                   child: Text("Save Now" , style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold)) ),

         ]),
      ),
    );
  }
}
