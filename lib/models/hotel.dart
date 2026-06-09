class Hotel {
  final String name;
  final String location;
  final String description;
  final double pricePerNight;
  final double rating;
  final String imageUrl;
  final List<String> amenities;

  const Hotel({
    required this.name,
    required this.location,
    required this.description,
    required this.pricePerNight,
    required this.rating,
    required this.imageUrl,
    required this.amenities,
  });
}

const List<Hotel> hotels = [
  Hotel(
    name: 'Blue Horizon Resort',
    location: 'Miami Beach, FL',
    description: 'Modern rooms, ocean breezes, and a relaxing poolside lounge.',
    pricePerNight: 199,
    rating: 4.8,
    imageUrl:
        'https://images.unsplash.com/photo-1501117716987-c8e80f0f6cf0?auto=format&fit=crop&w=900&q=80',
    amenities: ['Free Wi-Fi', 'Pool', 'Spa', 'Breakfast'],
  ),
  Hotel(
    name: 'Skyline Retreat',
    location: 'New York, NY',
    description: 'Stylish downtown hotel with fast service and city views.',
    pricePerNight: 229,
    rating: 4.6,
    imageUrl:
        'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=900&q=80',
    amenities: ['Gym', 'Rooftop bar', 'Room service', 'Concierge'],
  ),
  Hotel(
    name: 'Mountain Blue Lodge',
    location: 'Aspen, CO',
    description:
        'Cozy alpine rooms with mountain access and fireplace seating.',
    pricePerNight: 259,
    rating: 4.7,
    imageUrl:
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80',
    amenities: ['Ski access', 'Hot tub', 'Gym', 'Pet friendly'],
  ),
];
