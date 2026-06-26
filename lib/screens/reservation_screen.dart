import 'package:flutter/material.dart';

import '../models/hotel.dart';
import '../models/reservation.dart';
import '../widgets/reservation_tile.dart';
import 'my_reservations_screen.dart';

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

  int get selectedNights {
    if (checkInDate == null || checkOutDate == null) return 0;
    if (!checkOutDate!.isAfter(checkInDate!)) return 0;
    return checkOutDate!.difference(checkInDate!).inDays;
  }

  double get estimatedTotal {
    return widget.hotel.pricePerNight * selectedNights * guestCount;
  }

  Future<void> pickDate({required bool isCheckIn}) async {
    final today = DateTime.now();
    final firstAvailableDate = isCheckIn
        ? today
        : (checkInDate ?? today).add(const Duration(days: 1));
    final initialDate = isCheckIn
        ? (checkInDate ?? today)
        : (checkOutDate != null && checkOutDate!.isAfter(firstAvailableDate))
            ? checkOutDate!
            : firstAvailableDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstAvailableDate,
      lastDate: today.add(const Duration(days: 365)),
    );

    if (picked == null) return;

    setState(() {
      if (isCheckIn) {
        checkInDate = picked;
        if (checkOutDate == null || !checkOutDate!.isAfter(picked)) {
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

    final nights = selectedNights;
    final total = estimatedTotal;

    ReservationStore.addReservation(
      Reservation(
        hotel: widget.hotel,
        checkInDate: checkInDate!,
        checkOutDate: checkOutDate!,
        guestCount: guestCount,
        totalPrice: total,
        createdAt: DateTime.now(),
      ),
    );

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
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyReservationsScreen(),
                  ),
                );
              },
              child: const Text('View reservations'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriceSummary() {
    final hasDates = selectedNights > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              Icon(Icons.receipt_long, color: Colors.blue.shade700),
            ],
          ),
          const SizedBox(height: 12),
          _summaryRow(
            'Room price',
            '\$${widget.hotel.pricePerNight.toStringAsFixed(0)} / night',
          ),
          const SizedBox(height: 8),
          _summaryRow(
            'Stay',
            hasDates
                ? '$selectedNights night${selectedNights == 1 ? '' : 's'}'
                : 'Choose dates',
          ),
          const SizedBox(height: 8),
          _summaryRow('Guests', '$guestCount guest${guestCount == 1 ? '' : 's'}'),
          const Divider(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Estimated total',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                hasDates ? '\$${estimatedTotal.toStringAsFixed(0)}' : '--',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
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
            const SizedBox(height: 20),
            _buildPriceSummary(),
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
