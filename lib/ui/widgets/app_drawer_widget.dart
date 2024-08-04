import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const AppDrawer({super.key, required this.onThemeChanged, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Filip Pražák',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: onThemeChanged,
            ),
          ),
          ListTile(
            title: const Text('Subscription'),
            onTap: () {
              // Navigate to subscription page
              Navigator.pop(context);
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionPage()));
            },
          ),
        ],
      ),
    );
  }
}
