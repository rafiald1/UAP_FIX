import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/location_controller.dart';

class LocationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LocationController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TOKO RESEP KAMI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.getCurrentLocation(),
            tooltip: 'Refresh Location',
            color: Colors.white,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Title and Subtitle
                const Text(
                  "Posisi anda Saat Ini",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Latitude: ${controller.latitude.value}, Longitude: ${controller.longitude.value}",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Lokasi Anda: ${controller.address.value}",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Tampilkan Lokasi Toko
                const Text(
                  "Lokasi Toko",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.greenAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Latitude: ${controller.storeLatitude}, Longitude: ${controller.storeLongitude}",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Alamat Toko: ${controller.storeAddress.value}",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Cari Lokasi Button
                ElevatedButton(
                  onPressed: () {
                    // Hitung jarak dan tampilkan snackbar
                    double distance = controller.calculateDistance();
                    Get.snackbar(
                      "Jarak",
                      "Jarak ke toko: ${distance.toStringAsFixed(2)} km",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.blueAccent,
                      colorText: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // background color
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.blueAccent.withOpacity(0.5),
                    elevation: 8,
                  ),
                  child: const Text(
                    "Hitung Jarak ke Toko",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),

                // Buka Google Maps Button
                ElevatedButton(
                  onPressed: () => controller.openGoogleMaps(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent, // background color
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.greenAccent.withOpacity(0.5),
                    elevation: 8,
                  ),
                  child: const Text(
                    "Buka Google Maps",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
