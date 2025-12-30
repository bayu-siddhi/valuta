import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 80, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Bayu Siddhi Mukti",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Flutter Enthusiast",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "This application was developed to fulfill the final "
                        "project assignment of the Dicoding course \"Belajar "
                        "Membuat Aplikasi Flutter untuk Pemula\". It uses a "
                        "public API to provide real-time exchange rate data.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Built With:",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: const [
                    TechChip(label: "Dart 3.10.4"),
                    TechChip(label: "Flutter 3.38.5"),
                    TechChip(label: "Material 3"),
                    TechChip(label: "HTTP Request"),
                    TechChip(label: "JSON Parsing"),
                  ],
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Disclaimers:",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "This application was developed solely to fulfill the "
                        "submission requirements for the Dicoding course "
                        "\"Belajar Membuat Aplikasi Flutter untuk Pemula\". "
                        "It is intended for educational purposes only and "
                        "should not be used as a reference for actual or real-"
                        "world exchange rates.\n\n"
                        "This application does not collect, store, or process "
                        "any personal user data. The exchange rate data "
                        "in this application is obtained from a free public API"
                        ": https://github.com/fawazahmed0/exchange-api, which "
                        "is an individual open-source project. Therefore, the "
                        "accuracy and reliability of the exchange rate data "
                        "cannot be fully verified.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TechChip extends StatelessWidget {
  final String label;
  const TechChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.blue.withValues(alpha: 0.1),
    );
  }
}
