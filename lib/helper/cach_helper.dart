import 'package:shared_preferences/shared_preferences.dart';

abstract class CachHelper {
  static late SharedPreferences sharedPreferences;
  CachHelper._();

  static const String _token = 'token';
  static const String _firstName = 'firstName';
  static const String _lastName = 'lastName';
  static const String _email = 'email';
  static const String _phone = 'phone';
  static const String _birthDate = 'birthDate';
  static const String _photo = 'photo';
  static const String _userId = 'userId'; //

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> setToken({required String userInfo}) {
    return sharedPreferences.setString(_token, userInfo);
  }

  static String getToken() {
    return sharedPreferences.getString(_token) ?? ' ';
  }

  static Future<void> clearToken() {
    return sharedPreferences.remove(_token);
  }

  //  userId
  static Future<void> setUserId({required String userInfo}) {
    return sharedPreferences.setString(_userId, userInfo);
  }

  static String getUserId() {
    return sharedPreferences.getString(_userId) ?? '';
  }

  static Future<void> clearUserId() {
    return sharedPreferences.remove(_userId);
  }

  static Future<void> setFirstName({required String userInfo}) {
    return sharedPreferences.setString(_firstName, userInfo);
  }

  static String getFirstName() {
    return sharedPreferences.getString(_firstName) ?? ' ';
  }

  static Future<void> clearFirstName() {
    return sharedPreferences.remove(_firstName);
  }

  static Future<void> setLastName({required String userInfo}) {
    return sharedPreferences.setString(_lastName, userInfo);
  }

  static String getLastName() {
    return sharedPreferences.getString(_lastName) ?? ' ';
  }

  static Future<void> clearLastName() {
    return sharedPreferences.remove(_lastName);
  }

  static Future<void> setEmail({required String userInfo}) {
    return sharedPreferences.setString(_email, userInfo);
  }

  static String getEmail() {
    return sharedPreferences.getString(_email) ?? ' ';
  }

  static Future<void> clearEmail() {
    return sharedPreferences.remove(_email);
  }

  static Future<void> setPhone({required String userInfo}) {
    return sharedPreferences.setString(_phone, userInfo);
  }

  static String getPhone() {
    return sharedPreferences.getString(_phone) ?? ' ';
  }

  static Future<void> clearPhone() {
    return sharedPreferences.remove(_phone);
  }

  static Future<void> setBirthDate({required String userInfo}) {
    return sharedPreferences.setString(_birthDate, userInfo);
  }

  static String getBirthDate() {
    return sharedPreferences.getString(_birthDate) ?? ' ';
  }

  static Future<void> clearBirthDate() {
    return sharedPreferences.remove(_birthDate);
  }

  static Future<void> setPhoto({required String userInfo}) {
    return sharedPreferences.setString(_photo, userInfo);
  }

  static String getPhoto() {
    return sharedPreferences.getString(_photo) ?? ' ';
  }

  static Future<void> clearPhoto() {
    return sharedPreferences.remove(_photo);
  }

  static Future<void> clearAll() {
    return sharedPreferences.clear();
  }
}
