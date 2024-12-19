import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_assignment/SigninPage.dart';
import 'package:flutter_app_assignment/adminPage.dart';
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

  @override
  void initState() {
    super.initState();
    loadservices();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'USER',
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
                MaterialPageRoute(builder: (context) => SignInScreen()),
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
                return ListView.builder(
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
                          child: ListTile(
                            title: Text(
                              servicesModel.services[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.045, // Responsive font size
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios,color: Colors.white70,),
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
