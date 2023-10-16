import 'package:flutter/material.dart';

class TopBoard extends StatelessWidget {
  const TopBoard({Key? key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.zero,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Pinned',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              PinnedCardList(),
              SizedBox(height: 20),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 2, // Adjust the shadow height
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4, // Adjust the blurRadius
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



class PinnedCard extends StatelessWidget {
  const PinnedCard({Key? key, required this.cardData}) : super(key: key);

  final CreditCardData cardData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: cardData.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [ // Add a drop shadow
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Shadow color with opacity
            offset: Offset(0, 2), // Offset of the shadow (horizontal, vertical)
            blurRadius: 5, // Radius of the blur effect
            spreadRadius: 1, // How far the shadow spreads
          )

        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${cardData.cardNumber}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              '${cardData.cardHolder}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              '${cardData.expiryDate}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class PinnedCardList extends StatelessWidget {
  const PinnedCardList({Key? key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Scroll horizontally
      child: Row(
        children: [
          PinnedCard(
            cardData: CreditCardData(
              cardHolder: 'John Doe',
              cardNumber: '**** **** **** 1234',
              expiryDate: '12/24',
              cardColor: Theme.of(context).hintColor,
            ),
          ),
          PinnedCard(
            cardData: CreditCardData(
              cardHolder: 'Alice Smith',
              cardNumber: '**** **** **** 5678',
              expiryDate: '09/23',
              cardColor: Theme.of(context).hintColor,
            ),
          ),
          // Add more PinnedCard widgets for additional cards
        ],
      ),
    );
  }
}

class CreditCardData {
  final String cardHolder;
  final String cardNumber;
  final String expiryDate;
  final Color cardColor;

  CreditCardData({
    required this.cardHolder,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardColor,
  });
}

