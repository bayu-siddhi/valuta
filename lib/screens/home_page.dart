import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valuta/services/currency_api.dart';
import 'package:valuta/screens/converter_page.dart';

final NumberFormat numberFormat = NumberFormat('#,##0.00000');

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CurrencyApiService _api = CurrencyApiService();

  bool _isRatesLoading = true;
  late Future<Map<String, dynamic>> _ratesFuture;
  late Future<Map<String, dynamic>> _currenciesFuture;

  String _baseCurrency = "usd"; // default
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _currenciesFuture = _api.getCurrencies();
    _loadRates();
  }

  void _loadRates() {
    setState(() {
      _isRatesLoading = true;
      _ratesFuture = _api.getExchangeRates(_baseCurrency);
    });

    _ratesFuture.whenComplete(() {
      if (mounted) {
        setState(() {
          _isRatesLoading = false;
        });
      }
    });
  }

  void _onBaseCurrencyChanged(String newCurrency) {
    setState(() {
      _baseCurrency = newCurrency;
    });
    _loadRates();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallHeight = MediaQuery.of(context).size.height < 400;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Exchange Rates",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.only(top: 12.0),
          child: ConditionalScroll(
            scrollIf: isSmallHeight,
            child: Column(
              children: [
                _buildHeaderSection(),
                if (isSmallHeight)
                  _buildRatesSection(isSmallHeight)
                else
                  Expanded(child: _buildRatesSection(isSmallHeight)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        // Dropdown Base Currency
        FutureBuilder<Map<String, dynamic>>(
          future: _currenciesFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: LinearProgressIndicator(),
              );
            }

            final Map<String, dynamic> currenciesMap = snapshot.data!;
            final List<String> currencyCodes = currenciesMap.keys.toList()
              ..sort();

            return Padding(
              padding: const EdgeInsets.only(left: 16, top: 12, right: 16),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: _baseCurrency,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: "Base Currency",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                selectedItemBuilder: (context) {
                  return currencyCodes.map((code) {
                    final String currencyName = currenciesMap[code];

                    return Text(
                      "${code.toUpperCase()} ($currencyName)",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.purple.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  }).toList();
                },
                items: currencyCodes.map((code) {
                  final String currencyName = currenciesMap[code];

                  return DropdownMenuItem<String>(
                    value: code,
                    child: Text(
                      "${code.toUpperCase()} ($currencyName)",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _onBaseCurrencyChanged(value);
                  }
                },
              ),
            );
          },
        ),
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: TextField(
            enabled: !_isRatesLoading,
            decoration: InputDecoration(
              isDense: true,
              hintText: _isRatesLoading
                  ? "Loading Exchange Rates..."
                  : "Search",
              hintStyle: Theme.of(context).textTheme.bodyMedium,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: _isRatesLoading
                ? null
                : (value) {
                    setState(() {
                      _searchQuery = value.toUpperCase();
                    });
                  },
          ),
        ),
      ],
    );
  }

  Widget _buildRatesSection(bool isSmallHeight) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _ratesFuture,
      builder: (context, ratesSnapshot) {
        if (ratesSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!ratesSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final rates = ratesSnapshot.data!;

        if (rates[_baseCurrency] == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return FutureBuilder<Map<String, dynamic>>(
          future: _currenciesFuture,
          builder: (context, currencySnapshot) {
            if (!currencySnapshot.hasData) {
              return const SizedBox();
            }

            final currenciesMap = currencySnapshot.data!;
            final String date = rates["date"] ?? "-";

            final Map<String, dynamic> baseRates = Map<String, dynamic>.from(
              rates[_baseCurrency],
            );

            final filteredKeys = baseRates.keys.where((key) {
              if (_searchQuery.isEmpty) return true;
              final String currencyName = (currenciesMap[key] ?? "")
                  .toString()
                  .toUpperCase();
              return key.toUpperCase().contains(_searchQuery) ||
                  currencyName.contains(_searchQuery);
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Text(
                    "Last update: $date",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                const SizedBox(height: 10),

                isSmallHeight
                    ? _buildListView(
                        filteredKeys,
                        baseRates,
                        currenciesMap,
                        isSmallHeight,
                      )
                    : Expanded(
                        child: _buildListView(
                          filteredKeys,
                          baseRates,
                          currenciesMap,
                          isSmallHeight,
                        ),
                      ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildListView(
    List filteredKeys,
    Map baseRates,
    Map currenciesMap,
    bool isSmallHeight,
  ) {
    return filteredKeys.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Mata uang tidak ditemukan"),
            ),
          )
        : ListView.builder(
            shrinkWrap: isSmallHeight,
            physics: isSmallHeight
                ? const NeverScrollableScrollPhysics()
                : null,
            itemCount: filteredKeys.length,
            itemBuilder: (context, index) {
              final code = filteredKeys[index];
              final rate = baseRates[code];
              final name = currenciesMap[code] ?? code.toUpperCase();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConverterPage(
                          sourceCurrency: _baseCurrency,
                          targetCurrency: code,
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade200,
                    child: Text(
                      code.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    rate != null ? numberFormat.format(rate) : "-",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
  }
}

class ConditionalScroll extends StatelessWidget {
  final Widget child;
  final bool scrollIf;

  const ConditionalScroll({
    super.key,
    required this.child,
    required this.scrollIf,
  });

  @override
  Widget build(BuildContext context) {
    return scrollIf ? SingleChildScrollView(child: child) : child;
  }
}
