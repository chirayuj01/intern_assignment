import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_assignment/Phoneauth.dart';
import 'package:flutter_app_assignment/adminPage.dart';
import 'package:flutter_app_assignment/details.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services_model.dart';

class UserPage extends StatefulWidget {
  final String name;
  UserPage({required this.name});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  var image;
  String _location = "Fetching location...";
  String name = "", email = "", contactno = "";
  _getCurrentLocation()async{
    try {
      bool isserviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isserviceEnabled) {
        setState(() {
          _location = "Location services are disabled.";
        });
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission==LocationPermission.denied) {
          setState(() {
            _location="Location permission denied.";
          });
          return;
        }
      }

      if (permission==LocationPermission.deniedForever) {
        setState(() {
          _location="Location permissions are permanently denied.";
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _location =
          "${place.subLocality},${place.administrativeArea}, ${place.country}";
        });
      } else {
        setState(() {
          _location = "No address found.";
        });
      }
    } catch (e) {
      setState(() {
        _location = "Failed to get location";
      });
    }
  }
  logoutuser() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
  }
  loadservices() async {
    var prefs = await SharedPreferences.getInstance();
    String? servicesString = prefs.getString('services');

    if (servicesString != null) {
      List<dynamic> servicesDynamic = jsonDecode(servicesString);
      List<String> services = servicesDynamic.cast<String>();
      Provider.of<ServicesModel>(context, listen: false).setServices(services);
    }
  }
  loadvalues() async {
    var prefs = await SharedPreferences.getInstance();

    final imagePath = prefs.getString('profileImage');
    image = imagePath != null ? File(imagePath) : null;
    name = prefs.getString('role') ?? "";
    email = prefs.getString('email') ?? "";
    contactno = prefs.getString('phone') ?? "";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadservices();
    loadvalues();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white70.withOpacity(0.7),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 50, right: 50, top: 100.0, bottom: 30),
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: image == null
                          ? Center(
                              child: Icon(
                                Icons.account_circle,
                                size: 150,
                              ),
                            )
                          : Image.file(
                              image,
                              fit: BoxFit.cover,
                            )),
                ),
              ),
              Divider(
                indent: 5,
                endIndent: 5,
                thickness: 3,
                color: Colors.grey,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Name : $name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Divider(
                indent: 5,
                endIndent: 5,
                thickness: 3,
                color: Colors.grey,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Phone no.: $contactno',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Divider(
                indent: 5,
                endIndent: 5,
                thickness: 3,
                color: Colors.grey,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'email : $email',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Divider(
                indent: 5,
                endIndent: 5,
                thickness: 3,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'location : $_location',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Divider(
                indent: 5,
                endIndent: 5,
                thickness: 3,
                color: Colors.grey,
              ),
              SizedBox(height: 80,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          fixedSize: Size(200, 60)),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailsScreen(phone: contactno)));
                      },
                      child: Text(
                        'Update profile',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'USER ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.07, // Responsive font size
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              logoutuser();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PhoneAuthScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Text(
              'Welcome, ${widget.name}',
              style: TextStyle(
                color: Colors.white70,
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
            child: Text(
              'Services:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.08, // Responsive font size
              ),
            ),
          ),
          Expanded(
            child: Consumer<ServicesModel>(
              builder: (context, servicesModel, child) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: servicesModel.services.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03, // Responsive padding
                        vertical: screenHeight * 0.01,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => servicedetails(
                                servicename: Provider.of<ServicesModel>(
                                  context,
                                  listen: false,
                                ).services[index],
                              ),
                            ),
                          );
                        },
                        child: Card(
                            color: Colors.white.withOpacity(0.2),
                            child: GridTile(
                              child: ListTile(
                                title: Text(
                                  servicesModel.services[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.045,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white70,
                                ),
                              ),
                            )),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
