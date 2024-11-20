import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LDRRMC extends StatelessWidget {
  const LDRRMC({super.key});

  final String facebookUrl = 'https://www.facebook.com/Sta.BarbaraMdrrmo2419';

  Future<void> _launchFacebookPage() async {
    final Uri url = Uri.parse(facebookUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $facebookUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
        const Text('LDRRMC', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue[800], // AppBar color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.blue[100], // Background color of the page
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      'LDRRMC',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'LGU - Sta. Barbara',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please Like our Facebook Page:',
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: _launchFacebookPage,
                      child: const Text(
                        'StaBarbaraMdrrmo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Email address:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const Text(
                      'santabarbara_ldrrmc@yahoo.com.ph',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mga HOTLINE na dapat tandaan:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12),
                    HotlineRow(label: "Mayor's Office", number: "600-80-51 LOCAL888"),
                    HotlineRow(label: "ADMIN OFFICE", number: "600-80-51 LOCAL777"),
                    HotlineRow(label: "MDRRMO-RESCUE", number: "09309584095"),
                    HotlineRow(label: "MSWD", number: "633-33-50"),
                    HotlineRow(label: "DILG", number: "600-80-51 Local 221"),
                    HotlineRow(label: "PNP", number: "09985985120\n09295109148"),
                    HotlineRow(label: "BFP", number: "09694770980\n09171878611"),
                    HotlineRow(label: "RHU", number: "(075) 529-6736"),
                    HotlineRow(label: "DECORP", number: "(075) 522-2940"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  '*ang pagiging handa ay isang hakbang tungo sa Kaligtasan ng buhay ng inyong pamilya.*',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HotlineRow extends StatelessWidget {
  final String label;
  final String number;

  const HotlineRow
  ({super.key, 
    required this.label, 
    required this.number});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Text(
            number,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}