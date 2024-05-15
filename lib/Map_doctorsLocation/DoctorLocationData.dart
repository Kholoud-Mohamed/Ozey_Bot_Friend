import 'package:http/http.dart' as http;
import 'dart:convert';

class Doctor {
  final String doctorId;
  final double latitude;
  final double longitude;
  final String name;
  final double rate;
  final String phone;
  final String government;

  Doctor({
    required this.doctorId,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.phone,
    required this.government,
    required this.rate,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    String latString = json['lat'].toString();
    String langString = json['lang'].toString();

    // Extract numeric part of the string using a regular expression
    RegExp regex = RegExp(r"[-+]?([0-9]*\.[0-9]+|[0-9]+)");
    double latitude = double.parse(regex.stringMatch(latString) ?? '0.0');
    double longitude = double.parse(regex.stringMatch(langString) ?? '0.0');

    return Doctor(
      doctorId: json['id'].toString(),
      latitude: latitude,
      longitude: longitude,
      name: json['name'].toString(),
      phone: json['phone'].toString(),
      government: json['gover'].toString(),
      rate: double.tryParse(json['rate'].toString()) ?? 0.0,
    );
  }
}

class LocationData {
  static Future<List<Doctor>> getDoctorsFromApi(String token) async {
    List<Doctor> doctors = [];

    try {
      final response = await http.get(
        Uri.parse(
            'https://mental-health-ef371ab8b1fd.herokuapp.com/api/doctors'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', 
        },
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        doctors = data.map((doctorData) {
          return Doctor.fromJson(doctorData);
        }).toList();
      } else {
        print(
            'Error fetching doctor data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching doctor data: $e');
    }

    return doctors;
  }
}
