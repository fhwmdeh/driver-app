import 'package:driver/tabPages/homeTab.dart';
import 'package:driver/tabPages/profileTab.dart';
import 'package:driver/tabPages/ratingTab.dart';
import 'package:flutter/material.dart';
import '../tabPages/earningsTab.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({Key? key}) : super(key: key);
  static const String idScreen = "mainScreen";

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> with SingleTickerProviderStateMixin {

  TabController? _tabController;
  int selectedIndex = 0;

  OnItemClicked(int index){
    setState(() {
      selectedIndex = index;
      _tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(

      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const[
           HomeTabPage(),
          EarningsTabPage(),
          RatingsTabPage(),
          ProfileTabPage(),

        ],
      ),
      bottomNavigationBar:
      BottomNavigationBar(
        items :const [
          BottomNavigationBarItem(icon: Icon(Icons.home),
          label: "Home",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card),
            label: "Earinigs",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star),
            label: "Rating",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        unselectedItemColor:Colors.grey ,
        selectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: OnItemClicked,
      ),


    );
  }
}
