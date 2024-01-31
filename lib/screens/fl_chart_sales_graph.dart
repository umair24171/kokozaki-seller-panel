import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// Define a class to store the order data
class Order {
  final String id;
  final double price;
  final int quantity;

  Order(this.id, this.price, this.quantity);
}

// Define a class to store the sales data
class Sales {
  final String year;
  final double total;

  Sales(this.year, this.total);
}

// Define a widget to display the sales graph
class SalesGraph extends StatefulWidget {
  const SalesGraph({Key? key}) : super(key: key);

  @override
  _SalesGraphState createState() => _SalesGraphState();
}

class _SalesGraphState extends State<SalesGraph> {
  // Create a list to store the sales data
  List<Sales> salesData = [];

  // Create a function to get the sales data from the orders collection
  Future<void> getSalesData() async {
    // Get the orders collection from Firebase
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('marketId',
            arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .get();

    // Get the documents from the orders collection

    // Loop through the documents and calculate the total sales for each year
    Map<String, double> salesMap = {};
    snapshot.docs.forEach((doc) {
      // Get the order data from the document
      Order order = Order(doc['orderId'], doc['totalPrice'], doc['quantity']);

      // Get the year from the document id
      String year = order.id.substring(0, 4);

      // Add the total price to the sales map for the corresponding year
      if (salesMap.containsKey(year)) {
        salesMap[year] = salesMap[year]! + order.price * order.quantity;
      } else {
        salesMap[year] = order.price * order.quantity;
      }
    });

    // Convert the sales map to a list of sales objects
    salesMap.forEach((key, value) {
      salesData.add(Sales(key, value));
    });

    // Sort the sales data by year
    salesData.sort((a, b) => a.year.compareTo(b.year));

    // Update the state of the widget
    setState(() {});
  }

  // Create a function to convert the sales data to a list of series for the chart
  List<charts.Series<Sales, String>> getSeriesData() {
    return [
      charts.Series(
        id: 'Sales',
        data: salesData,
        domainFn: (Sales sales, _) => sales.year,
        measureFn: (Sales sales, _) => sales.total,
        colorFn: (Sales sales, _) =>
            charts.ColorUtil.fromDartColor(Colors.blue),
      )
    ];
  }

  // Override the initState method to get the sales data when the widget is created
  @override
  void initState() {
    super.initState();
    getSalesData();
  }

  // Override the build method to display the sales graph
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Graph'),
      ),
      body: Center(
        child: salesData.isEmpty
            ? CircularProgressIndicator()
            : Container(
                height: 400,
                width: 600,
                child: charts.BarChart(
                  getSeriesData(),
                  animate: true,
                  barGroupingType: charts.BarGroupingType.grouped,
                  behaviors: [
                    charts.SeriesLegend(),
                    charts.ChartTitle('Year'),
                    charts.ChartTitle('Total Sales',
                        behaviorPosition: charts.BehaviorPosition.start),
                  ],
                ),
              ),
      ),
    );
  }
}
