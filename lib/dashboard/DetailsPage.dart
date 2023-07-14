import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../wallet/WalletCommunicator.dart';
import '../wallet/WalletItem.dart';
import 'ShopScreen.dart';


class DetailsPage extends StatefulWidget {
  final WalletItem walletItem;

  const DetailsPage({Key? key, required this.walletItem}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool _isLoading = false;
  bool _isVerified = false;
  final WalletCommunicator walletCommunicator = WalletCommunicator();

  static const yaleBlue = Color(0xff16588E);

  Future<void> _requestProof() async {
    setState(() {
      _isLoading = true;
    });
    _isVerified = await walletCommunicator.requestProof(widget.walletItem);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "Details",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: ShopScreen.yaleBlue,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                '${widget.walletItem.comment}',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Divider(
              thickness: 2,
              color: yaleBlue,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.walletItem.attributes.length,
                itemBuilder: (BuildContext context, int index) {
                  final attribute = widget.walletItem.attributes[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${attribute['name']}:',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${attribute['value']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    walletCommunicator.issue(widget.walletItem);
                  },
                  child: const Text('Issue'),
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                    _requestProof();
                  },
                  child: _isLoading
                      ? const CupertinoActivityIndicator()
                      : const Text('Proof'),
                ),
                if (_isVerified != null)
                  Icon(
                    _isVerified
                        ? Icons.check_circle
                        : Icons.cancel_outlined,
                    color: _isVerified ? Colors.green : Colors.red,
                    size: 36,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}