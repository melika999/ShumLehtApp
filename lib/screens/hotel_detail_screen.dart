import 'package:flutter/material.dart';

import '../models/hotel.dart';
import 'reservation_screen.dart';

class HotelDetailScreen extends StatelessWidget {
  final Hotel hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel details'),
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              hotel.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.blue.shade50,
                  child: Icon(
                    Icons.hotel,
                    color: Colors.blue.shade700,
                    size: 72,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  hotel.location,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTag('${hotel.rating} ★', Icons.star),
                    _buildTag(
                      '\$${hotel.pricePerNight.toStringAsFixed(0)}/night',
                      Icons.monetization_on,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'About',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  hotel.description,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 24),
                Text(
                  'Amenities',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: hotel.amenities
                      .map(
                        (amenity) => Chip(
                          label: Text(amenity),
                          backgroundColor: Colors.blue.shade50,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReservationScreen(hotel: hotel),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Reserve room',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.blue.shade700),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: Colors.blue.shade50,
    );
  }
}
