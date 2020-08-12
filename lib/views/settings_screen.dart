import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_helper/controllers/history_controller.dart';
import 'package:whatsapp_helper/controllers/settings_controller.dart';
import 'package:whatsapp_helper/controllers/theme_controller.dart';
import 'package:whatsapp_helper/enums/theme.dart';
import 'package:whatsapp_helper/views/countries.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.palette,
              color: Theme.of(context).accentColor,
            ),
            title: Text('Theme'),
            subtitle: Text(Provider.of<ThemeController>(context).isDark
                ? 'Dark'
                : 'Light'),
            trailing: Switch(
              value: Provider.of<ThemeController>(context).isDark,
              onChanged: (value) {
                if (value) {
                  Provider.of<ThemeController>(context, listen: false)
                      .setTheme(AppTheme.Dark);
                } else {
                  Provider.of<ThemeController>(context, listen: false)
                      .setTheme(AppTheme.Light);
                }
              },
            ),
          ),
          ListTile(
            leading: Image.asset(
              'assets/flags/${Provider.of<SettingsController>(context).country.alpha2Code.toLowerCase()}.png',
              width: 24,
            ),
            title: Text('Default Country'),
            trailing: Text('+ ' +
                Provider.of<SettingsController>(context)
                    .country
                    .callingCodes
                    .first),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CountriesScreen(),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.history,
              color: Theme.of(context).accentColor,
            ),
            title: Text('Clear History'),
            onTap: () async {
              bool clearStatus = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Are you sure?'),
                  content:
                      Text('This will clear all the entries in History Tab.'),
                  actions: [
                    FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Provider.of<HistoryController>(context, listen: false)
                              .clearHistory();
                          Navigator.of(context).pop(true);
                        }),
                    FlatButton(
                      child: Text('No'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ],
                ),
              );
              if (clearStatus) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('History Cleared'),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
