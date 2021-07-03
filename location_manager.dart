import 'package:location/location.dart';

class LocationBloc {
  static final LocationBloc _singleton = LocationBloc._internal();

  factory LocationBloc() {
    return _singleton;
  }

  LocationBloc._internal();

  Location location = Location();

  LocationData lastLocation;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  Future<bool> requestPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<LocationData> getLocation() async {
    final LocationData _locationResult = await location.getLocation();
    lastLocation = _locationResult;
    return _locationResult;
  }

  void startUpdatingLocation() {
    location.onLocationChanged.listen((event) {
      lastLocation = event;
    });
  }
}
