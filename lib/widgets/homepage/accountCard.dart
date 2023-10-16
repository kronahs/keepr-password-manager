import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final String imageUrl; // URL for the account's logo image
  final String accountName;
  final String accountEmail;
  final VoidCallback? onPress;

  const AccountCard({
    Key? key,
    required this.imageUrl,
    required this.accountName,
    required this.accountEmail,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl.isNotEmpty
                    ? imageUrl
                    : 'https://www.activeliving.ie/content/uploads/2020/04/placeholder-logo-2.png',
                width: 42, // Set the width to make the image bigger
                height: 42, // Set the height to make the image bigger
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Handle image loading errors here
                  // You can log the error or return a fallback image URL
                  print('Error loading image: $error');
                  // Return the placeholder image URL to display in case of errors
                  return Image.network(
                    'https://www.activeliving.ie/content/uploads/2020/04/placeholder-logo-2.png',
                    width: 42, // Set the width to make the image bigger
                    height: 42, // Set the height to make the image bigger
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.accountName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(this.accountEmail),
              ],
            )
          ],
        ),
      ),
    );
  }
}
