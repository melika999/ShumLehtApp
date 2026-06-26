import 'package:flutter/material.dart';

import '../models/reservation.dart';

class MyReservationsScreen extends StatelessWidget {
  const MyReservationsScreen({super.key});

  String _dateLabel(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final reservations = ReservationStore.reservations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My reservations'),
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
      ),
      body: reservations.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 64,
                      color: Colors.blue.shade300,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No reservations yet',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your confirmed hotel bookings will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                reservation.hotel.imageUrl,
                                width: 82,
                                height: 82,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 82,
                                    height: 82,
                                    color: Colors.blue.shade50,
                                    child: Icon(
                                      Icons.hotel,
                                      color: Colors.blue.shade700,
                                      size: 34,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reservation.hotel.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    reservation.hotel.location,
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Confirmed',
                                      style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 14),
                        _infoRow(
                          Icons.calendar_month,
                          'Dates',
                          '${_dateLabel(reservation.checkInDate)} - ${_dateLabel(reservation.checkOutDate)}',
                        ),
                        const SizedBox(height: 10),
                        _infoRow(
                          Icons.bed,
                          'Stay',
                          '${reservation.nights} night${reservation.nights == 1 ? '' : 's'}',
                        ),
                        const SizedBox(height: 10),
                        _infoRow(
                          Icons.people,
                          'Guests',
                          '${reservation.guestCount} guest${reservation.guestCount == 1 ? '' : 's'}',
                        ),
                        const SizedBox(height: 10),
                        _infoRow(
                          Icons.payments,
                          'Total',
                          '\$${reservation.totalPrice.toStringAsFixed(0)}',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade700),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
