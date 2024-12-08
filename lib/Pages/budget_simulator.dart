import 'package:flutter/material.dart';

class BudgetSimulator extends StatefulWidget {
  const BudgetSimulator({super.key});

  @override
  State<BudgetSimulator> createState() => _BudgetSimulatorState();
}

class _BudgetSimulatorState extends State<BudgetSimulator> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
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


    );
  }
}
