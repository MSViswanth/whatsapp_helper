import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_helper/controllers/history_controller.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HistoryController historyProvider = Provider.of<HistoryController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        elevation: 0,
      ),
      body: Container(
        child: historyProvider.people.length == 0
            ? Center(
                child: Text('Nothing here'),
              )
            : ListView.builder(
                // reverse: true,
                itemBuilder: (context, index) {
                  return Dismissible(
                    background: Container(
                      color: Colors.red,
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    onDismissed: (direction) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Removed +' +
                                historyProvider.people[index].phoneNumber,
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      historyProvider
                          .removePerson(historyProvider.people[index]);
                    },
                    key: ValueKey(historyProvider.people[index].time),
                    child: ListTile(
                      // contentPadding: EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Icon(
                          Icons.person,
                          // color: Theme.of(context).accentColor,
                        ),
                      ),
                      title: Text(
                        '+' + historyProvider.people[index].phoneNumber,
                      ),
                      subtitle: Text(
                        DateFormat.yMMMd()
                            .add_jm()
                            .format(historyProvider.people[index].time),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // IconButton(
                          //   icon: Icon(
                          //     Icons.person_add,
                          //     color: Theme.of(context).accentColor,
                          //   ),
                          //   onPressed: () async {
                          //     if (Platform.isAndroid) {
                          //       AndroidIntent intent = AndroidIntent(
                          //         action: 'action_view',
                          //         data: 'https://api.whatsapp.com/send?phone=' +
                          //             historyProvider.people[index].phoneNumber,
                          //         arguments: {'message': 'Hello'},
                          //       );
                          //       try {
                          //         await intent.launch();
                          //       } catch (e) {
                          //         print(e);
                          //       }
                          //     }
                          //   },
                          // ),
                          IconButton(
                            icon: Icon(
                              Icons.sms,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () {
                              launch('sms:+' +
                                  historyProvider.people[index].phoneNumber);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.phone,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () {
                              launch('tel:+' +
                                  historyProvider.people[index].phoneNumber);
                            },
                          ),
                        ],
                      ),
                      onTap: () => launch('https://wa.me/' +
                          historyProvider.people[index].phoneNumber),
                    ),
                  );
                },
                itemCount: historyProvider.people.length,
              ),
      ),
    );
  }
}
