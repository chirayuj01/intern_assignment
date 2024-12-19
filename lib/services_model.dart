import 'package:flutter/material.dart';

class ServicesModel extends ChangeNotifier {
  List<String> _services = ["Service A", "Service B", "Service C", "Service D", "Service E"];

  List<String> get services => _services;

  void addService(String service) {
    _services.add(service);
    notifyListeners();
  }

  void removeService(int index) {
    _services.removeAt(index);
    notifyListeners();
  }

  setServices(var newservices){
    _services=newservices;
    notifyListeners();
  }
}
