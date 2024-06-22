import 'package:digitaltwin/widgets/Cards_Stats.dart';
import 'package:digitaltwin/widgets/app_bnb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:digitaltwin/controllers/api_controller.dart';
import 'package:digitaltwin/widgets/full_width_card.dart';
import 'package:iconly/iconly.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiController apiController = Get.put(ApiController());
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _startPeriodicFetch();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _fetchData() {
    apiController.fetchData("04-02-02-05-E3-03");
  }

  void _startPeriodicFetch() {
    _timer = Timer.periodic(Duration(seconds: 20), (timer) {
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'JStyle',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(IconlyBroken.notification, color: Colors.black),
            onPressed: () {
              // Handle notifications
            },
          ),
          SizedBox(width: 10), // To add some padding to the right
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FullWidthCard(
              title: "Hi Shankar",
              subtitle: "Your HRV is increased by 10% Compared to last week",
              value: "42",
              valueDescription: "HRV",
              color: Color(0xFFC0D6E8).withOpacity(0.4), // Color specified
            ),
            Obx(() {
              if (apiController.errorMessage.value.isNotEmpty) {
                return Center(
                    child: Text('Error: ${apiController.errorMessage.value}'));
              } else if (apiController.data.isNotEmpty) {
                final List<Map<String, dynamic>> cardData = [
                  {
                    'icon': 'assets/icons/heart-rate.svg',
                    'title': 'Heart Rate',
                    'units': 'bpm',
                    'value': '${apiController.data['heartRate']} ',
                    'color': Colors.white,
                  },
                  {
                    'icon': 'assets/icons/bloodcell.svg',
                    'title': 'SpO2',
                    'units': '%',
                    'value': '${apiController.data['bloodOxygen']}',
                    'color': Colors.white,
                  },
                  {
                    'icon': 'assets/icons/cal.svg',
                    'title': 'Stress',
                    'units': '',
                    'value': apiController.data['stress'] ?? 'N/A',
                    'color': Colors.white,
                  },
                  {
                    'icon': 'assets/icons/heart-rate.svg',
                    'title': 'HRV',
                    'units': 'ms',
                    'value': '${apiController.data['hrv']} ',
                    'color': Colors.white,
                  },
                  {
                    'icon': 'assets/icons/temp.svg',
                    'title': 'Body Temp',
                    'units': ' °F',
                    'value': '${apiController.data['bodyTemp']}',
                    'color': Colors.white,
                  },
                  {
                    'icon': 'assets/icons/heart-rate.svg',
                    'title': 'BP',
                    'units': '',
                    'value': apiController.data['bloodPressure'] ?? 'N/A',
                    'color': Colors.white,
                  },
                ];

                return GridView.builder(
                  physics:
                      NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 6.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.0, // Adjust the ratio as needed
                  ),
                  itemCount: cardData.length,
                  itemBuilder: (context, index) {
                    final item = cardData[index];
                    return CustomCard(
                      icon: item['icon'],
                      title: item['title'],
                      units: item['units'],
                      value: item['value'],
                      color: item['color'],
                    );
                  },
                );
              } else {
                return Center(child: Text('No data available.'));
              }
            }),
          ],
        ),
      ),
      bottomNavigationBar:
          CustomBottomNavBar(), // Add the bottom navigation bar here
    );
  }
}
