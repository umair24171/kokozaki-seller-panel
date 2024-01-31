import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokozaki_seller_panel/helper/colors.dart';
import 'package:kokozaki_seller_panel/widgets/line_chart_graph.dart';

class AnalyticsScreen extends StatelessWidget {
  AnalyticsScreen({
    super.key,
    Color? line1Color1,
    Color? line1Color2,
    Color? line2Color1,
    Color? line2Color2,
  })  : line1Color1 = line1Color1 ?? Colors.orange,
        line1Color2 = line1Color2 ?? Colors.orange,
        line2Color1 = line2Color1 ?? Colors.black,
        line2Color2 = line2Color2 ?? Colors.black {
    minSpotX = spots.first.x;
    maxSpotX = spots.first.x;
    minSpotY = spots.first.y;
    maxSpotY = spots.first.y;

    for (final spot in spots) {
      if (spot.x > maxSpotX) {
        maxSpotX = spot.x;
      }

      if (spot.x < minSpotX) {
        minSpotX = spot.x;
      }

      if (spot.y > maxSpotY) {
        maxSpotY = spot.y;
      }

      if (spot.y < minSpotY) {
        minSpotY = spot.y;
      }
    }
  }

  final Color line1Color1;
  final Color line1Color2;
  final Color line2Color1;
  final Color line2Color2;

  final spots = const [
    FlSpot(0, 1),
    FlSpot(2, 5),
    FlSpot(4, 3),
    FlSpot(6, 5),
  ];

  final spots2 = const [
    FlSpot(0, 3),
    FlSpot(2, 1),
    FlSpot(4, 2),
    FlSpot(6, 1),
  ];

  late double minSpotX;
  late double maxSpotX;
  late double minSpotY;
  late double maxSpotY;

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: line1Color1,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );

    final intValue = reverseY(value, minSpotY, maxSpotY).toInt();

    if (intValue == (maxSpotY + minSpotY)) {
      return Text('', style: style);
    }

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Text(
        intValue.toString(),
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: line2Color2,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    final intValue = reverseY(value, minSpotY, maxSpotY).toInt();

    if (intValue == (maxSpotY + minSpotY)) {
      return Text('', style: style);
    }

    return Text(intValue.toString(), style: style, textAlign: TextAlign.right);
  }

  Widget topTitleWidgets(double value, TitleMeta meta) {
    if (value % 1 != 0) {
      return Container();
    }
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(value.toInt().toString(), style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    double initialRevenue = 0;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('marketId',
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                  child: Text(
                'No Orders Yet',
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ));
            }
            snapshot.data!.docs
                .map((e) => initialRevenue += e['totalPrice'])
                .toList();
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RevenueContainers(
                          text: 'Total Revenue',
                          subText: '\$$initialRevenue',
                          percentText: '12%',
                          icon: Icons.arrow_circle_up,
                          color: const Color(0xff263C81),
                          iconsColor: Colors.green,
                        ),
                        RevenueContainers(
                          text: 'Total Sales Registered',
                          subText:
                              '${snapshot.data!.docs.where((element) => element['quantity'] != null).toList().length}',
                          percentText: '56%',
                          icon: Icons.arrow_circle_down,
                          color: Colors.blue,
                          iconsColor: Colors.red,
                        ),
                        // RevenueContainers(
                        //   text: 'Total Sales',
                        //   subText: '\$4067',
                        //   percentText: '43%',
                        //   icon: Icons.arrow_circle_up,
                        //   color: primaryColor,
                        //   iconsColor: Colors.green,
                        // )
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 22, bottom: 20, top: 40),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.white)]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Users Sales and Visit Data ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 19,
                                                  fontFamily: 'Hind'),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 10,
                                                      width: 10,
                                                      decoration: BoxDecoration(
                                                          color: secondaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3)),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    const Text(
                                                      'Direct Link',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontFamily: 'Hind',
                                                          color: Color(
                                                              0xffA3A3A3)),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 10,
                                                      width: 10,
                                                      decoration: BoxDecoration(
                                                          color: primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3)),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    const Text(
                                                      'Direct Link',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontFamily: 'Hind',
                                                          color: Color(
                                                              0xffA3A3A3)),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const LineChartGraph(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 1,
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Recent Orders',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Hind'),
                                                ),
                                                Icon(Icons.more_vert)
                                              ],
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: snapshot.data!.docs
                                                            .length >=
                                                        2
                                                    ? 2
                                                    : snapshot
                                                        .data!.docs.length,
                                                itemBuilder: (context, index) {
                                                  final data = snapshot
                                                      .data!.docs[index]
                                                      .data();
                                                  return RecentOrderProduct(
                                                      data: data);
                                                })
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            AspectRatio(
                              aspectRatio: 3.5,
                              child: LineChart(
                                LineChartData(
                                  lineTouchData:
                                      const LineTouchData(enabled: false),
                                  lineBarsData: [
                                    // LineChartBarData(
                                    //   gradient: LinearGradient(
                                    //     colors: [
                                    //       line1Color1,
                                    //       line1Color2,
                                    //     ],
                                    //   ),
                                    //   spots: reverseSpots(spots, minSpotY, maxSpotY),
                                    //   isCurved: true,
                                    //   isStrokeCapRound: true,
                                    //   barWidth: 10,
                                    //   belowBarData: BarAreaData(
                                    //     show: false,
                                    //   ),
                                    //   dotData: FlDotData(
                                    //     show: true,
                                    //     getDotPainter: (spot, percent, barData, index) =>
                                    //         FlDotCirclePainter(
                                    //       radius: 12,
                                    //       color: Colors.transparent,
                                    //       strokeColor: Colors.black,
                                    //     ),
                                    //   ),
                                    // ),
                                    LineChartBarData(
                                      gradient: LinearGradient(
                                        colors: [
                                          line2Color1,
                                          line2Color2,
                                        ],
                                      ),
                                      spots: reverseSpots(
                                          spots2, minSpotY, maxSpotY),
                                      isCurved: true,
                                      isStrokeCapRound: true,
                                      barWidth: 10,
                                      belowBarData: BarAreaData(
                                        show: false,
                                      ),
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter:
                                            (spot, percent, barData, index) =>
                                                FlDotCirclePainter(
                                          radius: 12,
                                          color: Colors.transparent,
                                          strokeColor: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                  minY: 0,
                                  maxY: maxSpotY + minSpotY,
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: leftTitleWidgets,
                                        reservedSize: 38,
                                      ),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: rightTitleWidgets,
                                        reservedSize: 30,
                                      ),
                                    ),
                                    bottomTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 32,
                                        getTitlesWidget: topTitleWidgets,
                                      ),
                                    ),
                                  ),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: true,
                                    checkToShowHorizontalLine: (value) {
                                      final intValue =
                                          reverseY(value, minSpotY, maxSpotY)
                                              .toInt();

                                      if (intValue ==
                                          (maxSpotY + minSpotY).toInt()) {
                                        return false;
                                      }

                                      return true;
                                    },
                                  ),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: const Border(
                                      left: BorderSide(color: Colors.black),
                                      top: BorderSide(color: Colors.black),
                                      bottom:
                                          BorderSide(color: Colors.transparent),
                                      right:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  double reverseY(double y, double minX, double maxX) {
    return (maxX + minX) - y;
  }

  List<FlSpot> reverseSpots(List<FlSpot> inputSpots, double minY, double maxY) {
    return inputSpots.map((spot) {
      return spot.copyWith(y: (maxY + minY) - spot.y);
    }).toList();
  }
}

class RecentOrderProduct extends StatelessWidget {
  RecentOrderProduct({super.key, required this.data});
  Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('id', whereIn: data['productIds'])
            .where('sellerId',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Orders Yet'),
              );
            }
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                        children: List.generate(
                      snapshot.data!.docs.length,
                      (index) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          snapshot.data!.docs[index]['imageUrl'],
                          height: 50,
                          width: 50,
                        ),
                      ),
                    )),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                            snapshot.data!.docs.length,
                            (index) => Column(
                                  children: [
                                    Text(
                                      snapshot.data!.docs[index]['name'],
                                      maxLines: 1,

                                      // overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          overflow: TextOverflow.fade,
                                          fontFamily: 'Hind',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '\$${snapshot.data!.docs[index]['newPrice']}',
                                      style: const TextStyle(
                                          fontFamily: 'Hind',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ))),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy')
                              .format((data['orderDate'] as Timestamp).toDate())
                              .toString(),
                          style: const TextStyle(
                              fontFamily: 'Hind',
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: data['status'] == 0
                                  ? primaryColor
                                  : data['status'] == 1
                                      ? Colors.green
                                      : Colors.red,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: data['status'] == 0
                                    ? Text(
                                        'Pending',
                                        style: TextStyle(
                                            fontFamily: 'Hind',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: whiteColor),
                                      )
                                    : data['status'] == 1
                                        ? const Text(
                                            'Completed',
                                            style: TextStyle(
                                                fontFamily: 'Hind',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          )
                                        : const Text(
                                            'Cancelled',
                                            style: TextStyle(
                                                fontFamily: 'Hind',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          )))
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class RevenueContainers extends StatelessWidget {
  const RevenueContainers(
      {super.key,
      required this.text,
      required this.subText,
      required this.percentText,
      required this.icon,
      required this.iconsColor,
      required this.color});
  final String text;
  final String subText;
  final String percentText;
  final IconData icon;
  final Color color;
  final Color iconsColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 250,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                  fontFamily: 'Hind', fontSize: 14, color: whiteColor),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                subText,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: whiteColor,
                  fontFamily: 'Hind',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      percentText,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Hind'),
                    ),
                    const Text(
                      'Total Revenue this month',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    )
                  ],
                ),
                Icon(
                  icon,
                  color: iconsColor,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
