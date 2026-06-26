import 'package:flutter/material.dart';

import '../models/hotel.dart';
import '../models/reservation.dart';
import '../widgets/hotel_card.dart';
import 'hotel_detail_screen.dart';
import 'my_reservations_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = 'All';
  String searchQuery = '';
  final Set<String> favoriteHotelNames = {};

  List<Hotel> get filteredHotels {
    var list = hotels;
    if (selectedFilter == 'Popular') {
      list = list.where((hotel) => hotel.rating >= 4.6).toList();
    }
    if (selectedFilter == 'Luxury') {
      list = list.where((hotel) => hotel.pricePerNight >= 220).toList();
    }
    if (selectedFilter == 'Favorites') {
      list = list
          .where((hotel) => favoriteHotelNames.contains(hotel.name))
          .toList();
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

  void toggleFavorite(Hotel hotel) {
    setState(() {
      if (favoriteHotelNames.contains(hotel.name)) {
        favoriteHotelNames.remove(hotel.name);
      } else {
        favoriteHotelNames.add(hotel.name);
      }
    });
  }

  String get emptyMessage {
    if (selectedFilter == 'Favorites') {
      return 'No favorite hotels yet';
    }
    return 'No hotels found';
  }

  void openReservations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MyReservationsScreen()),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blue Hotel Booking'),
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Text('${favoriteHotelNames.length}'),
                  ],
                ),
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                tooltip: 'My reservations',
                icon: const Icon(Icons.event_note),
                onPressed: openReservations,
              ),
              if (ReservationStore.reservations.isNotEmpty)
                Positioned(
                  right: 7,
                  top: 9,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${ReservationStore.reservations.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
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
              children: ['All', 'Popular', 'Luxury', 'Favorites'].map((filter) {
                final isSelected = selectedFilter == filter;
                return ChoiceChip(
                  label: Text(filter),
                  avatar: filter == 'Favorites'
                      ? Icon(
                          Icons.favorite,
                          size: 16,
                          color: isSelected ? Colors.white : Colors.blue,
                        )
                      : null,
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
                  ? Center(
                      child:
                          Text(emptyMessage, style: const TextStyle(fontSize: 16)))
                  : ListView.builder(
                      itemCount: filteredHotels.length,
                      itemBuilder: (context, index) {
                        final hotel = filteredHotels[index];
                        return HotelCard(
                          hotel: hotel,
                          isFavorite: favoriteHotelNames.contains(hotel.name),
                          onFavoriteToggle: () => toggleFavorite(hotel),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HotelDetailScreen(hotel: hotel),
                              ),
                            ).then((_) => setState(() {}));
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
