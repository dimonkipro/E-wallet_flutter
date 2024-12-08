import 'package:flutter/material.dart';

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  State<CurrencyConverter> createState() => _CurrencyConverter();
}

class _CurrencyConverter extends State<CurrencyConverter> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  String _res = "";
  String _selectedCurrency = 'EUR';

  // Function to REFRESH the page
  void _refreshPage() {
    setState(() {
      _res = ""; // Reset result
      _amountController.clear(); // CLEAR the amount field
      _selectedCurrency = 'EUR'; // RESET to default currency
    });
  }

  // CONVERSION Function
  void _calculate() {
    if (_formKey.currentState!.validate()) {
      double montant = double.parse(_amountController.text);
      double taux = 2.2;
      setState(() {
        _res = (montant * taux).toStringAsFixed(2); // FORMAT RESULT
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Conversion terminée avec succès")),
      );

      //ERROR CASE
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Erreur")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Portefeuille Numérique',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
        elevation: 10, // Adds shadow
        backgroundColor: Colors.teal,
      ),


      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 25),
              const Text("Convertisseur de Monnaie", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 25),

              // Amount field
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un montant';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
                controller: _amountController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.monetization_on_outlined),
                  labelText: "Montant",
                  hintText: "Entrez un montant",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              // END Amount field

              const SizedBox(height: 25),

              // Dropdown menu
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.attach_money_sharp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  labelText: "Devise cible",
                  hintText: "Choisir une devise ...",
                ),
                value: _selectedCurrency,
                items: const [
                  DropdownMenuItem(value: 'USD', child: Text('USD - United States Dollar')),
                  DropdownMenuItem(value: 'EUR', child: Text('EUR - Euro (European Union)')),
                  DropdownMenuItem(value: 'JPY', child: Text('JPY - Japanese Yen')),
                  DropdownMenuItem(value: 'GBP', child: Text('GBP - British Pound Sterling')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value!; // Update selected currency
                  });
                },
              ),
              // END Dropdown menu

              const SizedBox(height: 25),

              // Result field
              Text(
                "Résultat: $_res $_selectedCurrency",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),

              // Calculate button
              ElevatedButton(
                onPressed: _calculate,
                child: const Text("Calculate"),
              ),
              // END BUTTON
            ],
          ),
        ),
      ),
      // Floating action button to refresh the page
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshPage,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
