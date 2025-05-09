import 'package:flutter/material.dart';

class GiftItemWidget extends StatelessWidget {
   GiftItemWidget(
      {super.key,
      required this.color,
      required this.name,
      required this.index,
      required this.imagePath,
      required this.points,
      required this.price,
      this.giftimage
      
      });

  final int index;
  final String name;
  final int points;
  final String price;
  final Color color;
  final String imagePath;
  final Widget  ?giftimage ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            "$index",
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold , ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: giftimage ,
            // Image.asset(imagePath),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
                Row(
                  children: [
                    //const Icon(Icons.favorite, color: Colors.red, size: 16),
                    const SizedBox(width: 4),
                    Text("$points",
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(width: 8),
                    const Icon(Icons.fingerprint, color: Colors.blue, size: 16),
                  ],
                )
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
