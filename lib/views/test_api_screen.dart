import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digitaltwin/controllers/api_controller.dart';

class TestApiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ApiController apiController = Get.put(ApiController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Test API Service'),
      ),
      body: Obx(() {
        if (apiController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (apiController.errorMessage.value.isNotEmpty) {
          return Center(
              child: Text('Error: ${apiController.errorMessage.value}'));
        } else if (apiController.data.isNotEmpty) {
          return ListView(
            padding: EdgeInsets.all(16.0),
            children: apiController.data.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                subtitle: Text(entry.value),
              );
            }).toList(),
          );
        } else {
          return Center(child: Text('No data available.'));
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          apiController.fetchData("04-02-02-05-E3-03");
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
