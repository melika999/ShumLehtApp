import 'hotel.dart';

class Reservation {
  final Hotel hotel;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guestCount;
  final double totalPrice;
  final DateTime createdAt;

  const Reservation({
    required this.hotel,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guestCount,
    required this.totalPrice,
    required this.createdAt,
  });

  int get nights => checkOutDate.difference(checkInDate).inDays;
}

class ReservationStore {
  static final List<Reservation> reservations = [];

  static void addReservation(Reservation reservation) {
    reservations.insert(0, reservation);
  }
}
