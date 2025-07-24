import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import '../widgets/app_card.dart';
import '../services/secure_mode_manager.dart';

class AppListScreen extends StatefulWidget {
  final bool secureModeEnabled;

  AppListScreen({required this.secureModeEnabled});

  @override
  _AppListScreenState createState() => _AppListScreenState();
}

class _AppListScreenState extends State<AppListScreen> {
  List<Application> _apps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    List<Application> apps = await SecureModeManager.getInstalledApps();
    setState(() {
      _apps = apps;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.secureModeEnabled
              ? 'Approved Apps Only'
              : 'All Installed Apps',
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _apps.length,
              itemBuilder: (context, index) {
                return AppCard(
                  app: _apps[index],
                  secureMode: widget.secureModeEnabled,
                );
              },
            ),
    );
  }
}
