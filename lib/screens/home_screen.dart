import 'package:flutter/material.dart';

import '../models/hotel.dart';
import '../widgets/hotel_card.dart';
import 'hotel_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = 'All';
  String searchQuery = '';

  List<Hotel> get filteredHotels {
    var list = hotels;
    if (selectedFilter == 'Popular') {
      list = list.where((hotel) => hotel.rating >= 4.6).toList();
    }
    if (selectedFilter == 'Luxury') {
      list = list.where((hotel) => hotel.pricePerNight >= 220).toList();
    }
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      list = list
          .where((hotel) =>
              hotel.name.toLowerCase().contains(query) ||
              hotel.location.toLowerCase().contains(query))
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blue Hotel Booking'),
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text('Good morning, traveler',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Choose your next stay with ease.',
                style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 18),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search hotels or location',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              children: ['All', 'Popular', 'Luxury'].map((filter) {
                final isSelected = selectedFilter == filter;
                return ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  selectedColor: Colors.blue.shade700,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                  onSelected: (_) => setState(() => selectedFilter = filter),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredHotels.isEmpty
                  ? const Center(
                      child: Text('No hotels found',
                          style: TextStyle(fontSize: 16)))
                  : ListView.builder(
                      itemCount: filteredHotels.length,
                      itemBuilder: (context, index) {
                        final hotel = filteredHotels[index];
                        return HotelCard(
                          hotel: hotel,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HotelDetailScreen(hotel: hotel),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
