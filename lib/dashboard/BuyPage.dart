import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:myfirstapp/backend/ShopBackend.dart';
import 'ShopScreen.dart';

class BuyScreen extends StatelessWidget {
  final ShopItem item;

  const BuyScreen({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(item.name,style: const TextStyle(
          color: Colors.white,
        )),
        backgroundColor: ShopScreen.yaleBlue,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Buy ${item.name} for \$${item.price.toStringAsFixed(2)}?',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            CupertinoButton.filled(
              child: const Text('Buy'),
              onPressed: () {
                // TODO: Implement buy functionality later
              },
            ),
          ],
        ),
      ),
    );
  }
}