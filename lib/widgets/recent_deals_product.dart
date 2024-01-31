import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokozaki_seller_panel/models/deal_model.dart';

class RecentDealsProduct extends StatelessWidget {
  RecentDealsProduct({super.key, required this.deal});
  Deal deal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  deal.imageUrl,
                  fit: BoxFit.cover,
                  height: 40,
                  width: 50,
                ),
              ),
            ),
          ),
          // const SizedBox(
          //   width: 10,
          // ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal.description,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                        color: Color(0xff092C4C),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Hind'),
                  ),
                  const Text(
                    'SKU 658260',
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                        // overflow: TextOverflow.visible,
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'Hind'),
                  )
                ],
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${deal.newPrice}',
                    style: const TextStyle(
                        // overflow: TextOverflow.visible,
                        color: Color(0xff092C4C),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Hind'),
                  ),
                  Text(
                    DateFormat('dd MMM, yyyy').format(deal.expireDate),
                    style: const TextStyle(
                        // overflow: TextOverflow.visible,
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'Hind'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
