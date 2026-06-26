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
        'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=900&q=80',
    amenities: ['Free Wi-Fi', 'Pool', 'Spa', 'Breakfast'],
  ),
  Hotel(
    name: 'Skyline Retreat',
    location: 'New York, NY',
    description: 'Stylish downtown hotel with fast service and city views.',
    pricePerNight: 229,
    rating: 4.6,
    imageUrl:
        'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=900&q=80',
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
        'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=900&q=80',
    amenities: ['Ski access', 'Hot tub', 'Gym', 'Pet friendly'],
  ),
];
