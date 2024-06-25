import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:provider/provider.dart';

Widget buildSquare({
  required IconData icon,
  required String text,
  required Color color,
  VoidCallback? onTap,
}) {
  return Consumer<OrderProvider>(
    builder: (context, orderProvider, _) {
      return GestureDetector(
        onTap: () {
          if (!orderProvider.isLoading && onTap != null) {
            onTap();
          }
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    },
  );
}
