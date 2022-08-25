import 'package:flutter/cupertino.dart';

import '../models/directions.dart';
import '../models/trips_history_model.dart';

class AppInfo extends ChangeNotifier{
  Directions ?userPickupLocation , userDropoffLocation;
  int countTotalTrips = 0;
  String driverTotalEarnings = "0";
  String driverAverageRatings = "0";
  List<String> historyTripsKeysList = [];
  List<TripsHistoryModel> allTripsHistoryInformationList = [];

  void updatePickupLocationAddress(Directions userPickupAddress){
    userPickupLocation = userPickupAddress;
    notifyListeners();


  }
  void updateDropoffLocationAddress(Directions userDropoffAddress){
    userDropoffLocation = userDropoffAddress;
    notifyListeners();

  }
  updateOverAllTripsCounter(int overAllTripsCounter)
  {
    countTotalTrips = overAllTripsCounter;
    notifyListeners();
  }

  updateOverAllTripsKeys(List<String> tripsKeysList)
  {
    historyTripsKeysList = tripsKeysList;
    notifyListeners();
  }

  updateOverAllTripsHistoryInformation(TripsHistoryModel eachTripHistory)
  {
    allTripsHistoryInformationList.add(eachTripHistory);
    notifyListeners();
  }
  updateDriverTotalEarnings(driverEarnings){
    driverTotalEarnings = driverEarnings;
  }
  updateDriverAverageRatings(driverRatings){
    driverAverageRatings = driverRatings;
  }

}