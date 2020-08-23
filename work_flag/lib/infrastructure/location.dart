import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position position;

  getLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((value) => position = value);
  }

  Future<String> getAddressFromLatLgn() async {
    try {
      getLocation();
      var p = await geolocator.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      debugPrint("Second local - ${position?.latitude.toString()}");

      var place = p[0];

      return "${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      //debugPrint(e);
      return "";
    }
  }

  Future<bool> isSameLocation(String locationDb) async {
    if(locationDb == "")
      return true;

    var nowLocation = await getAddressFromLatLgn();

    return nowLocation == locationDb;
  }
}
