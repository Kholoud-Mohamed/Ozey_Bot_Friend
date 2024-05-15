import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapfeature_project/Map_doctorsLocation/DoctorCard.dart';
import 'package:mapfeature_project/Map_doctorsLocation/DoctorLocationData.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  final String token;

  const MapScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? position;
  final Completer<GoogleMapController> _mapController = Completer();
  List<Marker> markers = [];
  List<Doctor> doctors = [];
  Set<Polyline> _polylines = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    _requestLocationPermission();
    await _getCurrentLocation(); // Wait for current location to be fetched
    await _loadMarkersAndDoctors();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _requestLocationPermission() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      // Permission granted, proceed to get current location
      _getCurrentLocation();
    } else {
      // Permission denied, show a message or handle it accordingly
      print('Location permission denied');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        position = currentPosition;
      });
    } catch (e) {
      setState(() {
        position = null;
      });
      print('Error getting current location: $e');
    }
  }

  Future<void> _loadMarkersAndDoctors() async {
    try {
      List<Doctor> fetchedDoctors =
          await LocationData.getDoctorsFromApi(widget.token);
      setState(() {
        doctors = fetchedDoctors;
        markers = fetchedDoctors.map((doctor) {
          return Marker(
            markerId: MarkerId(doctor.doctorId),
            position: LatLng(doctor.latitude, doctor.longitude),
            onTap: () {
              _showDoctorLocation(doctor);
            },
          );
        }).toList();
      });
    } catch (e) {
      print('Error loading markers and doctors: $e');
      // Handle error, show a message or retry loading
    }
  }

  void _showDoctorLocation(Doctor doctor) {
    setState(() {
      markers = [
        Marker(
          markerId: MarkerId(doctor.doctorId),
          position: LatLng(doctor.latitude, doctor.longitude),
          onTap: () {
            _showDoctorLocation(doctor);
          },
        ),
      ];
    });

    // Move the camera to the selected doctor's location
    _goToDoctorLocation(LatLng(doctor.latitude, doctor.longitude));
  }

  void _goToDoctorLocation(LatLng doctorLocation) async {
    final GoogleMapController controller = await _mapController.future;

    CameraPosition newPosition = CameraPosition(
      bearing: 0.0,
      target: doctorLocation,
      tilt: 0.0,
      zoom: 17,
    );

    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  Future<void> _showDoctorsList() async {
    // Load doctors again to ensure the list is updated
    await _loadMarkersAndDoctors();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Doctors List',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    return DoctorCard(
                      doctor: doctors[index],
                      onTap: (doctor) {
                        _showDoctorLocation(doctor);
                        Navigator.pop(
                            context); // Close the bottom sheet after selecting a doctor
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xff7db2be),
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  markers: Set<Marker>.of(markers),
                  polylines: _polylines,
                  initialCameraPosition: CameraPosition(
                    target: position != null
                        ? LatLng(position!.latitude, position!.longitude)
                        : LatLng(0, 0),
                    zoom: 17,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                  },
                ),
                Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: FloatingActionButton(
                    backgroundColor: Color(0xff7db2be),
                    onPressed: _showDoctorsList,
                    shape: CircleBorder(),
                    child: Icon(Icons.list, color: Colors.white),
                  ),
                ),
              ],
            ),
    );
  }
}
