import 'package:flutter/material.dart';

class BudgetSimulator extends StatefulWidget {
  const BudgetSimulator({super.key});

  @override
  State<BudgetSimulator> createState() => _BudgetSimulatorState();
}

class _BudgetSimulatorState extends State<BudgetSimulator> {
  final _formKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> _revenues = [];
  final List<Map<String, dynamic>> _expenses = [];

  void _addRevenueRow() {
    setState(() {
      _revenues.add({'type': '', 'amount': TextEditingController()});
    });
  }

  void _addExpenseRow() {
    setState(() {
      _expenses.add({'type': '', 'amount': TextEditingController()});
    });
  }

  double _calculateTotal(List<Map<String, dynamic>> items) {
    double total = 0;
    for (var item in items) {
      final amountText = item['amount'].text;
      if (amountText.isNotEmpty && double.tryParse(amountText) != null) {
        total += double.parse(amountText);
      }
    }
    return total;
  }

  double get totalRevenues => _calculateTotal(_revenues);
  double get totalExpenses => _calculateTotal(_expenses);
  double get balance => totalRevenues - totalExpenses;

  void _showSummaryDialog(BuildContext context) {
    String summary = 'Revenus :\n';
    for (var revenue in _revenues) {
      final type = revenue['type'] ?? 'Inconnu';
      final amount = revenue['amount'].text.isNotEmpty
          ? revenue['amount'].text
          : '0';
      summary += '- $type : $amount TND\n';
    }

    summary += '\nDépenses :\n';
    for (var expense in _expenses) {
      final type = expense['type'] ?? 'Inconnu';
      final amount = expense['amount'].text.isNotEmpty
          ? expense['amount'].text
          : '0';
      summary += '- $type : $amount TND\n';
    }

    summary += '\nTotal des revenus : ${totalRevenues.toStringAsFixed(2)} TND\n';
    summary += 'Total des dépenses : ${totalExpenses.toStringAsFixed(2)} TND\n';
    summary += 'Solde restant : ${balance.toStringAsFixed(2)} TND';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Résumé'),
        content: Text(summary),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),

//BODY
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

// REVENUES Section
              const Text(
                'Revenus',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ..._revenues.map((revenue) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [

// REVENUES Type
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Type de revenu',
                            hintText: 'Salaire, Retraite, Loyer...',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrez un type';
                            }
                            return null;
                          },
                          onChanged: (value) => revenue['type'] = value,
                        ),
                      ),
                      const SizedBox(width: 8),

// REVENUES Amount
                      Expanded(
                        child: TextFormField(
                          controller: revenue['amount'],
                          decoration: const InputDecoration(
                            labelText: 'Montant (TND)',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrez une valeur';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Entrez un nombre valide';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),

// ADD REVENUES BUTTON
              ElevatedButton(
                onPressed: _addRevenueRow,
                child: const Text('Ajouter un revenu'),
              ),

              const SizedBox(height: 20),

// EXPENSES Section
              const Text(
                'Dépenses',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ..._expenses.map((expense) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
// EXPENSES Type
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Type de dépense',
                            hintText: 'Transport, Internet, Habillement...'
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrez un type';
                            }
                            return null;
                          },
                          onChanged: (value) => expense['type'] = value,
                        ),
                      ),
                      const SizedBox(width: 8),

// EXPENSES Amount
                      Expanded(
                        child: TextFormField(
                          controller: expense['amount'],
                          decoration: const InputDecoration(
                            labelText: 'Montant (TND)',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrez une valeur';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Entrez un nombre valide';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),

// ADD EXPENSES BUTTON
              ElevatedButton(
                onPressed: _addExpenseRow,
                child: const Text('Ajouter une dépense'),
              ),

              const SizedBox(height: 20),

              // Totals
              Text(
                'Total des revenus : ${totalRevenues.toStringAsFixed(2)} TND',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Total des dépenses : ${totalExpenses.toStringAsFixed(2)} TND',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Solde restant : ${balance.toStringAsFixed(2)} TND',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

// SUBMIT BUTTON
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showSummaryDialog(context);
                  }
                },
                child: const Text('Soumettre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
