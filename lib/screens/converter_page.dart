import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valuta/services/currency_api.dart';

String formatResult(double value) {
  if (value == 0) return "0.00";

  if (value.abs() < 0.01) {
    return NumberFormat('#,##0.000000').format(value);
  }

  return NumberFormat('#,##0.00').format(value);
}

class ConverterPage extends StatefulWidget {
  final String sourceCurrency;
  final String targetCurrency;

  const ConverterPage({
    this.sourceCurrency = "usd",
    this.targetCurrency = "idr",
    super.key,
  });

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final CurrencyApiService _api = CurrencyApiService();
  final TextEditingController _amountController = TextEditingController();

  Map<String, dynamic>? _currencies;
  Map<String, dynamic>? _rates;

  bool _isLoadingCurrencies = true;
  late String _sourceCurrency;
  late String _targetCurrency;
  double _result = 0;
  String? _lastUpdate;

  @override
  void initState() {
    super.initState();
    _sourceCurrency = widget.sourceCurrency;
    _targetCurrency = widget.targetCurrency;
    _loadCurrencies();
    _loadRates();
  }

  Future<void> _loadCurrencies() async {
    final data = await _api.getCurrencies();
    setState(() {
      _currencies = Map<String, dynamic>.from(data);
    });
  }

  Future<void> _loadRates() async {
    final data = await _api.getExchangeRates(_sourceCurrency);
    setState(() {
      _rates = Map<String, dynamic>.from(data[_sourceCurrency]);
      _lastUpdate = data["date"];
      _isLoadingCurrencies = false;
    });
    _calculate();
  }

  void _onSourceCurrencyChanged(String newCurrency) {
    setState(() {
      _sourceCurrency = newCurrency;
    });
    _loadRates();
  }

  void _onTargetCurrencyChanged(String newCurrency) {
    setState(() {
      _targetCurrency = newCurrency;
    });
    _calculate();
  }

  Future<void> _calculate() async {
    if (_amountController.text.isEmpty || _rates == null) {
      setState(() {
        _result = 0;
      });
      return;
    }

    if (!_rates!.containsKey(_targetCurrency)) {
      setState(() {
        _result = 0;
      });
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      setState(() {
        _result = 0;
      });
      return;
    }

    final rate = _rates![_targetCurrency];

    setState(() {
      _result = amount * rate;
    });
  }

  void _reverseCurrency() {
    setState(() {
      final temp = _sourceCurrency;
      _sourceCurrency = _targetCurrency;
      _targetCurrency = temp;
    });
    _loadRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Currency Converter",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDropdown(
                              label: "From",
                              currency: _sourceCurrency,
                              onChanged: (val) =>
                                  _onSourceCurrencyChanged(val!),
                            ),
                            const SizedBox(height: 12),
                            _buildDropdown(
                              label: "To",
                              currency: _targetCurrency,
                              onChanged: (val) =>
                                  _onTargetCurrencyChanged(val!),
                            ),
                            if (_lastUpdate != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  "Last update: $_lastUpdate",
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _isLoadingCurrencies
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              icon: const Icon(Icons.swap_vert, size: 32),
                              onPressed: _reverseCurrency,
                              color: Colors.purple,
                            ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Amount
                  TextField(
                    enabled: !_isLoadingCurrencies,
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: _isLoadingCurrencies
                          ? "Loading Exchange Rates..."
                          : "Enter amount",
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: _isLoadingCurrencies
                        ? null
                        : (_) => _calculate(),
                  ),

                  const SizedBox(height: 40),

                  // Conversion Result
                  const Text("Result:", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  _isLoadingCurrencies
                      ? const CircularProgressIndicator()
                      : Text(
                          "${formatResult(_result)} ${_targetCurrency.toUpperCase()}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String currency,
    required ValueChanged<String?> onChanged,
  }) {
    if (_isLoadingCurrencies || _currencies == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: LinearProgressIndicator(),
      );
    }

    final Map<String, dynamic> currenciesMap = _currencies!;
    final List<String> currencyCodes = currenciesMap.keys.toList()..sort();

    return DropdownButtonFormField<String>(
      isExpanded: true,
      initialValue: currency,
      decoration: InputDecoration(
        isDense: true,
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: currencyCodes.map((code) {
        return DropdownMenuItem<String>(
          value: code,
          child: Text(
            "${code.toUpperCase()} (${currenciesMap[code]})",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
