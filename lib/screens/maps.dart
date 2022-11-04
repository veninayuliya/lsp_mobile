import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({
    Key? key,
    required this.dataUser,
  }) : super(key: key);

  final dataUser;

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  double latitude = 0;
  double longitude = 0;
  String location = 'Belum Mendapatkan Lat dan long, Silahkan tekan button';
  String address = 'Mencari lokasi...';
  //getLongLAT
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //location service not enabled, don't continue
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    //Jika permission tidak diizinkan secara terus menerus
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permission denied forever, we cannot access',
      );
    }
    //continue accessing the position of device
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Get Adrress
  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    if (mounted) {
      setState(() {
        address =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      });
    }
  }

  setLocation() async {
    Position position = await _getGeoLocationPosition();
    if (mounted) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        location = '${position.latitude}, ${position.longitude}';
      });
    }
    getAddressFromLongLat(position);
  }

  @override
  Widget build(BuildContext context) {
    setLocation();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: ListView(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              // SvgPicture.asset(
              //   'assets/lokasi.svg',
              //   height: 200,
              //   width: 200,
              // ),
              Text(
                'Koordinat Point',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10.0,
              ),
              //menamilkan kordinat Lokasi
              Text(
                location,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                'Lokasi',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(
                height: 15.0,
              ),
              //menampilkan alamat
              Text(
                address,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(
                height: 25.0,
              ),
              ElevatedButton(
                onPressed: () {
                  MapsLauncher.launchCoordinates(latitude, longitude);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 15, 98, 167),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: const Text('Tampilkan Pada Map'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
