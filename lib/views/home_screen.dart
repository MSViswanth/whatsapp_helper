import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_helper/components/text_card.dart';
import 'package:whatsapp_helper/controllers/history_controller.dart';
import 'package:whatsapp_helper/controllers/settings_controller.dart';
import 'package:whatsapp_helper/models/person.dart';
import 'package:whatsapp_helper/views/countries.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _phone,
        _isocode =
            Provider.of<SettingsController>(context).country.callingCodes.first;
    String _text = '';
    _launchURL(String _isocode, String _phone, String _text) async {
      String url = 'https://wa.me/' + _isocode + _phone + '?text=' + _text;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('WhatsApp Helper'),
      ),
      body: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black87,
                          offset: Offset(1, 1),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: InkWell(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) =>
                              Dialog(child: CountriesScreen()),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/flags/${Provider.of<SettingsController>(context).country.alpha2Code.toLowerCase()}.png',
                              width: 24,
                            ),
                            SizedBox(width: 5),
                            Text(
                              Provider.of<SettingsController>(context)
                                  .country
                                  .alpha3Code,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                TextCard(
                  flex: 3,
                  autofocus: true,
                  hintText: 'Enter phone number...',
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    _phone = value;
                  },
                  onSubmitted: (value) {
                    _phone = value;
                    if (_text == '' && _phone != '') {
                      _launchURL(_isocode, _phone, _text);
                      Provider.of<HistoryController>(context, listen: false)
                          .addPerson(Person(_isocode + _phone, DateTime.now()));
                    } else if (_phone == '' || _phone == null) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Enter phone number'),
                      ));
                    }
                  },
                ),
              ],
            ),
            TextCard(
              hintText: 'Text Message',
              keyboardType: TextInputType.text,
              onChanged: (value) {
                _text = value;
              },
            ),
            InkWell(
              onTap: () {
                if (_phone == '' || _phone == null) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Enter phone number'),
                  ));
                } else {
                  Provider.of<HistoryController>(context, listen: false)
                      .addPerson(Person(_isocode + _phone, DateTime.now()));
                  _launchURL(_isocode, _phone, _text);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(16),
                width: double.infinity,
                child: Center(
                  child: Text('Send'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
