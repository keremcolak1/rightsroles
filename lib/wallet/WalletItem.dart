import 'dart:ffi';

import '../main/config.dart';
import '../rights/RightsManager.dart';
import 'WalletItems.dart';

class WalletItem {
  final String comment;
  final String credDefId;
  final String issuerDid;
  final String schemaId;
  final String schemaIssuerDid;
  final String schemaName;
  final String schemaVersion;
  final List<Map<String, String>> attributes;

  WalletItem({
    required this.comment,
    required this.credDefId,
    required this.issuerDid,
    required this.schemaId,
    required this.schemaIssuerDid,
    required this.schemaName,
    required this.schemaVersion,
    required this.attributes,
  });



  static Future<List<WalletItem>> sampleItems()   async {
    await vissPurpose.updateTokenAttribute();
    List<WalletItem> walletItems = [
      climateSettings,
      vissPurpose
      // Add additional WalletItems here as needed
    ];
    return walletItems;
  }






  Future<void> updateTokenAttribute() async { //TOKENS ARE VALID ONLY FOR AN FOR RIGHT NOW!
    final rightsmanager = RightsManager(tokenUrl, "YOUR_CLIENT_ID", "YOUR_CLIENT_SECRET");
    final access = await rightsmanager.retrieveToken("WBA51EH010HY00928", "pwd", "write-wo-versionvss");
    print("access"); //save to prefs?
    print(access);

    final tokenAttributeIndex = attributes.indexWhere(
            (attribute) => attribute['name'] == 'token');
    final expiresAttributeIndex = attributes.indexWhere(
            (attribute) => attribute['name'] == 'expires');
    if (tokenAttributeIndex != -1 && expiresAttributeIndex !=-1) {
      attributes[tokenAttributeIndex]['value'] = access['access_token'] as String;
      attributes[expiresAttributeIndex]['value'] = access['expires_in'].toString();
    }
  }
}