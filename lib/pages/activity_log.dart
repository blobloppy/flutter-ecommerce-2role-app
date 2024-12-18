import 'package:flutter/material.dart';
import 'package:heavy_rental_app/services/firestore_services.dart';
import 'package:heavy_rental_app/services/product_model.dart'; // Assuming ActivityLog model is defined

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity Logs"),
      ),
      body: StreamBuilder<List<ActivityLog>>(
        stream: firestoreService.getActivityLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No activity found."));
          }

          final activityLogs = snapshot.data!;

          return ListView.builder(
            itemCount: activityLogs.length,
            itemBuilder: (context, index) {
              final log = activityLogs[index];
              return ListTile(
                title: Text(log.action),
                subtitle: Text(log.details),
                trailing: Text(log.timestamp.toLocal().toString()),
              );
            },
          );
        },
      ),
    );
  }
}
