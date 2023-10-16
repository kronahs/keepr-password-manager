import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_any_logo/flutter_logo.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:keepr/widgets/homepage/accountCard.dart';

import '../../models/account_models.dart';
import '../../repository/accounts_repository.dart';
import '../../services/firebase_auth.dart';
import 'accountDetailPage.dart';

class AllPasswordsContent extends StatelessWidget {
  final AccountRepository _repository = AccountRepository();

  @override
  Widget build(BuildContext context) {
    final documentId;

    return Expanded(
      child: StreamBuilder<List<AccountModel>>(
        stream: _repository.fetchSocialMediaAccountsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available.'));
          } else {
            final socialMediaAccounts = snapshot.data!;

            return ListView.builder(
              itemCount: socialMediaAccounts.length,
              itemBuilder: (context, index) {
                final account = socialMediaAccounts[index];

                final isLastItem = index == socialMediaAccounts.length - 1;
                final hasNextItem = index < socialMediaAccounts.length - 1;
                final hasPreviousItem = index > 0;
                return Column(
                children: [
                  Slidable(
                    key: ValueKey(account),
                    endActionPane: ActionPane(
                      motion: BehindMotion(),
                      children: [
                        SlidableAction(onPressed: (context) =>{},
                          icon: Icons.favorite,
                          backgroundColor: Theme.of(context).hintColor,
                        )
                      ],
                    ),
                    child: AccountCard(
                      imageUrl: 'https://api.kickfire.com/logo?website=${account.accountType}.com',// Use the appropriate icon property from your data
                      accountName: account.accountName,
                      accountEmail: account.accountEmail,
                      onPress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SocialMediaDetailPage(
                          imageUrl: 'https://api.kickfire.com/logo?website=${account.accountType}.com',
                          accountName: account.accountName,
                          accountEmail:  account.accountEmail,
                          accountType: account.accountType,
                          accountPassword: account.accountPassword,
                        ))
                        );
                      },
                    ),
                  ),
                  if (hasNextItem) Divider(),
                ],
                );
              },
            );
          }
        },
      ),
    );
  }
}



class FrequentlyUsedContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Lists of favourites'),
    );
  }
}

class RecentlyAddedContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Lists of recently added'),
    );
  }
}
