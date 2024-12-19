import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_assignment/SigninPage.dart';
import 'package:flutter_app_assignment/services_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  final String name;

  AdminPage({required this.name});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return Scaffold(
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
                return ListView.builder(
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
                          child: ListTile(
                            title: Text(
                              servicesModel.services[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width * 0.05,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: width * 0.07,
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
