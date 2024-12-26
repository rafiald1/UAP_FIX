import 'package:geocoding/geocoding.dart'; // Tambahkan package geocoding
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationController extends GetxController {
  // State untuk lokasi saat ini
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var address = ''.obs;

  // Lokasi toko ditentukan manual
  final double storeLatitude = -7.629268;
  final double storeLongitude = 112.344529;
  var storeAddress = ''.obs;

  // State loading
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    getStoreAddress();
  }

  // Fungsi untuk mendapatkan lokasi saat ini
  Future<void> getCurrentLocation() async {
    isLoading(true);
    try {
      await _requestPermission();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );
      latitude(position.latitude);
      longitude(position.longitude);

      // Lakukan reverse geocoding untuk mendapatkan nama tempat
      List<Placemark> placemarks = await GeocodingPlatform.instance!
          .placemarkFromCoordinates(latitude.value, longitude.value);
      if (placemarks.isNotEmpty) {
        address.value =
            "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country}";
      }

      Get.snackbar(
        "Lokasi Diperbarui",
        "Lokasi saat ini: $address",
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mendapatkan lokasi: $e",
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading(false);
    }
  }

  // Fungsi untuk menghitung jarak antara dua koordinat
  double calculateDistance() {
    return Geolocator.distanceBetween(
          latitude.value,
          longitude.value,
          storeLatitude,
          storeLongitude,
        ) /
        1000;
  }

  // Fungsi untuk membuka Google Maps dan menampilkan rute
  Future<void> openGoogleMaps(BuildContext context) async {
    String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&origin=${latitude.value},${longitude.value}&destination=${storeLatitude},${storeLongitude}&travelmode=driving";
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);

      Navigator.pop(context);
    } else {
      Get.snackbar(
        "Error",
        "Tidak dapat membuka Google Maps",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Fungsi untuk meminta izin lokasi
  Future<void> _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isDenied) {
      throw "Izin lokasi ditolak";
    }
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  // Fungsi untuk mendapatkan alamat toko
  Future<void> getStoreAddress() async {
    try {
      List<Placemark> placemarks = await GeocodingPlatform.instance!
          .placemarkFromCoordinates(storeLatitude, storeLongitude);
      if (placemarks.isNotEmpty) {
        storeAddress.value =
            "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country}";
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mendapatkan alamat toko: $e",
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
