import 'package:flutter/material.dart';

class BudgetSimulator extends StatefulWidget {
  const BudgetSimulator({super.key});

  @override
  State<BudgetSimulator> createState() => _BudgetSimulatorState();
}

class _BudgetSimulatorState extends State<BudgetSimulator> {
  final _formKey = GlobalKey<FormState>();

// INITIALIZE DYNAMIC LISTS
  final List<Map<String, dynamic>> _revenues = [];
  final List<Map<String, dynamic>> _expenses = [];

// GETTER FOR THE FUNCTION CALCULATE_TOTAL WITH PARAMETERS
  double get totalRevenues => _calculateTotal(_revenues);
  double get totalExpenses => _calculateTotal(_expenses);
  double get balance => totalRevenues - totalExpenses;

// FUNCTION TO REFRESH THE PAGE
  void _refreshPage() {
    setState(() {
      _revenues.clear();
      _expenses.clear();
    });
  }

// ADD REVENUE ROW FUNCTION
  void _addRevenueRow() {
    setState(() {
      _revenues.add({'type': '', 'amount': TextEditingController()});
    });
  }

// ADD EXPENSE ROW FUNCTION
  void _addExpenseRow() {
    setState(() {
      _expenses.add({'type': '', 'amount': TextEditingController()});
    });
  }

// REMOVE ROW FUNCTION
  void _removeRow(List<Map<String, dynamic>> list, int index) {
    setState(() {
      list.removeAt(index);
    });
  }


// FUNCTION TO ITERATE THROUGH THE LISTS AND CALCULATE TOTAL AMOUNTS
  double _calculateTotal(List<Map<String, dynamic>> items) {
    double total = 0;
    for (var item in items) {

      // RETRIEVE THE AMOUNT
      final amountText = item['amount'].text;
      if (amountText.isNotEmpty && double.tryParse(amountText) != null) {

      // ADD TO TOTAL
        total += double.parse(amountText);
      }
    }
    return total;
  }



// FUNCTION FOR ALERT WITH ALL DETAILS INSERTED AND TOTALS
  void _showSummaryDialog(BuildContext context) {

    // INITIALIZE THE ALERT BODY
    String summary = 'Revenus :\n';

    for (var revenue in _revenues) {
    // RETRIEVE THE TYPE
      final type = revenue['type'] ?? 'Inconnu';

    // RETRIEVE THE AMOUNT
      final amount =
          revenue['amount'].text.isNotEmpty ? revenue['amount'].text : '0';

    // ADD A LINE CONTAIN THE DETAILS TO THE REVENUES DETAILS
      summary += '- $type : $amount TND\n';
    }

    summary += '\nDépenses :\n';
    for (var expense in _expenses) {
      final type = expense['type'] ?? 'Inconnu';
      final amount =
          expense['amount'].text.isNotEmpty ? expense['amount'].text : '0';

    // ADD A LINE CONTAIN THE DETAILS TO THE EXPENSES DETAILS
      summary += '- $type : $amount TND\n';
    }

    // ADD A LINE CONTAIN THE DETAILS TO THE TOTALS
    summary +=
        '\nTotal des revenus : ${totalRevenues.toStringAsFixed(2)} TND\n';
    summary += 'Total des dépenses : ${totalExpenses.toStringAsFixed(2)} TND\n';

    // INITIALIZE THE DIALOG WITH HEADER AND CONTENT FROM THE ALERT
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Résumé'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        children: [
          Text(summary),
          const SizedBox(height: 10),
          Text(
            'Solde restant : ${balance.toStringAsFixed(2)} TND \n',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getBalanceColor(),
            ),
          ),
          Text(
            _getBalanceMessage(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,

            ),
          ),
        ],
        ),
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

// FUNCTION TO GET THE BALANCE MESSAGE
  String _getBalanceMessage() {
    if (balance > 0) {
      return "Vous êtes dans le vert ! Vous avez un surplus de ${balance.toStringAsFixed(2)} TND.";
    } else if (balance < 0) {
      return "Attention ! Vous êtes dans le rouge avec un déficit de ${(-balance).toStringAsFixed(2)} TND.";
    } else {
      return "Votre solde est équilibré.";
    }
  }

// FUNCTION TO GET THE COLOR FROM THE BALANCE CONDITION
  Color _getBalanceColor() {
    if (balance > 0) {
      return Colors.green;
    } else if (balance < 0) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }


// ------------------ END OF FUNCTIONS AND DECLARATION ------------------------


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
    // SINGLE_CHILD_SCROLLVIEW TO ALLOW THE USER TO SCROLL
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
// REVENUES Section
                const Text(
                  'Revenus',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

    // TRANSFORM OF LIST _revenues TO Map ['salaire',..] devient {0: 'salaire',..}
    // ENTRIES RETURNS A COLLECTION OF KEY-VALUE PAIRS
                ..._revenues.asMap().entries.map((entry) {

    // INDEX OF THE ELEMENT
                  int index = entry.key;

    // THE ELEMENT ITSELF
                  var revenue = entry.value;
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
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black26),
                          onPressed: () => _removeRow(_revenues, index),
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

    // TRANSFORM OF LIST _expenses TO Map ['transport',...] devient {0: 'transport',...'}
    // ENTRIES RETURNS A COLLECTION OF KEY-VALUE PAIRS
                ..._expenses.asMap().entries.map((entry) {
    // INDEX OF THE ELEMENT
                  int index = entry.key;

    // THE ELEMENT ITSELF
                  var expense = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
    // EXPENSES Type
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Type de dépense',
                                hintText: 'Transport, Internet, Habillement...'),
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
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black26),
                          onPressed: () => _removeRow(_expenses, index),
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

// TOTALS
                Text(
                  'Total des revenus : ${totalRevenues.toStringAsFixed(2)} TND',
                  style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total des dépenses : ${totalExpenses.toStringAsFixed(2)} TND',
                  style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Solde restant : ${balance.toStringAsFixed(2)} TND',
                  style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
// BALANCE MESSAGE
                const SizedBox(height: 20),
                Text(
                  _getBalanceMessage(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getBalanceColor(),
                  ),
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
      ),

// REFRESH BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshPage,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
