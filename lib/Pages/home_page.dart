import 'package:digital_wallet/Pages/budget_simulator.dart';
import 'package:digital_wallet/Pages/currency_converter.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 30, fontFamily: "Roboto", fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      foregroundColor: Colors.teal[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
    );
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
          actions: [
            IconButton(
              icon: const Icon(Icons.wallet_rounded),
              onPressed: () {

              },
            ),
          ],
        ),

        backgroundColor: Colors.grey[200],

// BODY BEGIN

        body: IntroductionScreen(
          showDoneButton: false,
          showNextButton: false,
          pages: [

// FIRST SERVICE

            PageViewModel(
                title: "Simulateur de Budget \n 👛",
                body: "Ce calculateur vous aidera à établir un budget "
                    "simplifié Il est facile à remplir.",
                image: Image.asset("assets/budget.png"),
                footer: ElevatedButton(
                  style: style,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BudgetSimulator()
                      ),
                    );
                  },
                  child: const Text("Enter"),
                ),
                decoration: const PageDecoration(
                    pageMargin: EdgeInsets.fromLTRB(10, 150, 10, 10)
                )
            ),

//SECOND SERVICE

            PageViewModel(
              title: " Convertisseur de Monnaie \n💸",
              body: "Tapez dans le champ concerné les"
                  " symboles de devise ISO à 3 lettres et le montant à convertir."
                  " Vous pouvez convertir des devises mondiales",
              image: Image.asset("assets/convert.png"),
              footer: Container(
                margin: const EdgeInsets.only(top: 20), // Adds margin above the button
                child: ElevatedButton(
                  style: style,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CurrencyConverter(),
                      ),
                    );
                  },
                  child: const Text("Enter"),
                ),
              ),
              decoration: const PageDecoration(
                pageMargin: EdgeInsets.fromLTRB(10, 150, 10, 10), // Custom page margin
              ),
            ),
          ],
        )
    );
  }
}
