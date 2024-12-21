import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_assignment/Phoneauth.dart';
import 'package:flutter_app_assignment/details.dart';
import 'package:flutter_app_assignment/services_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  final String name;

  AdminPage({required this.name});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var image;
  String name="",email="",contactno="";
  loadvalues() async {
    var prefs = await SharedPreferences.getInstance();

    final imagePath = prefs.getString('profileImage');
    image=imagePath != null ? File(imagePath) : null;
    name = prefs.getString('role') ?? "";
    email = prefs.getString('email') ?? "";
    contactno = prefs.getString('phone') ?? "";
    setState(() {});
  }
  String service = "";
  final TextEditingController _serviceController = TextEditingController();
  logoutuser() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
  }

  updateservices() async {
    var prefs = await SharedPreferences.getInstance();
    String list = jsonEncode(
        Provider.of<ServicesModel>(context, listen: false).services);
    prefs.setString('services', list);
  }
  String _location = "Fetching location...";
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
  loadservices() async {
    var prefs = await SharedPreferences.getInstance();
    String? servicesString = prefs.getString('services');

    if (servicesString != null) {
      List<dynamic> servicesDynamic = jsonDecode(servicesString);
      List<String> services = servicesDynamic.cast<String>();
      Provider.of<ServicesModel>(context, listen: false).setServices(services);
    }
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
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white.withOpacity(0.9),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: (context),
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.grey,
                title: Center(
                  child: Text(
                    'Add new service',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.05,
                    ),
                  ),
                ),
                actions: [
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () {
                        if (_serviceController.text.isNotEmpty) {
                          Provider.of<ServicesModel>(context, listen: false)
                              .addService(_serviceController.text);
                          _serviceController.clear();
                        }
                        updateservices();

                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Text(
                        'ADD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.04,
                        ),
                      ),
                    ),
                  ),
                ],
                content: TextField(
                  controller: _serviceController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter Service name',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.04,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.05),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          size: width * 0.1,
        ),
        backgroundColor: Colors.white,
      ),
      appBar: AppBar(
        title: Text(
          'ADMIN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: width * 0.08,
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
            padding: EdgeInsets.all(width * 0.04),
            child: Text(
              'Welcome, ${widget.name}',
              style: TextStyle(
                color: Colors.white70,
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.04),
            child: Text(
              'Services:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.08,
              ),
            ),
          ),
          Expanded(
            child: Consumer<ServicesModel>(
              builder: (context, servicesModel, child) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount: servicesModel.services.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(width * 0.02),
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
                            child: Text(''),
                            footer: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: width * 0.1,
                              ),
                              onPressed: () {
                                service = Provider.of<ServicesModel>(
                                  context,
                                  listen: false,
                                ).services[index];
                                Provider.of<ServicesModel>(context,
                                    listen: false)
                                    .removeService(index);
                                updateservices();
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '$service removed successfully!!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width * 0.04,
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                            ),
                            header: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      servicesModel.services[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width * 0.05,
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward_ios,color: Colors.white70,),
                                  ],
                                ),
                              ),
                            ),

                          ),
                        ),
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

class servicedetails extends StatelessWidget {
  final String servicename;

  servicedetails({required this.servicename});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          servicename,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: width * 0.08,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Service details',
          style: TextStyle(
            fontSize: width * 0.05,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
