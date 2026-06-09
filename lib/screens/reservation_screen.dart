import 'package:flutter/material.dart';

import '../models/hotel.dart';
import '../widgets/reservation_tile.dart';

class ReservationScreen extends StatefulWidget {
  final Hotel hotel;

  const ReservationScreen({super.key, required this.hotel});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int guestCount = 1;

  Future<void> pickDate({required bool isCheckIn}) async {
    final today = DateTime.now();
    final initialDate = isCheckIn
        ? (checkInDate ?? today)
        : (checkOutDate ?? today.add(const Duration(days: 1)));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );

    if (picked == null) return;

    setState(() {
      if (isCheckIn) {
        checkInDate = picked;
        if (checkOutDate != null && !checkOutDate!.isAfter(picked)) {
          checkOutDate = picked.add(const Duration(days: 1));
        }
      } else {
        checkOutDate = picked;
      }
    });
  }

  String dateLabel(DateTime? date) {
    return date == null
        ? 'Select date'
        : '${date.month}/${date.day}/${date.year}';
  }

  void confirmBooking() {
    if (checkInDate == null || checkOutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick check-in and check-out dates.')),
      );
      return;
    }

    if (!checkOutDate!.isAfter(checkInDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check-out must be after check-in.')),
      );
      return;
    }

    final nights = checkOutDate!.difference(checkInDate!).inDays;
    final total = (widget.hotel.pricePerNight * nights) * guestCount;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reservation confirmed'),
          content: Text(
              'Your reservation for ${widget.hotel.name} is confirmed for $nights nights and \$${total.toStringAsFixed(0)} total.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserve'),
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reserve ${widget.hotel.name}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: ReservationTile(
                    label: 'Check-in',
                    value: dateLabel(checkInDate),
                    onTap: () => pickDate(isCheckIn: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ReservationTile(
                    label: 'Check-out',
                    value: dateLabel(checkOutDate),
                    onTap: () => pickDate(isCheckIn: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Guests',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900)),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: guestCount > 1
                      ? () => setState(() => guestCount--)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$guestCount',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () => setState(() => guestCount++),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Confirm reservation',
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
