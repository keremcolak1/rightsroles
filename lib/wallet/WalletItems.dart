//predefine all wallet items

import 'package:myfirstapp/main/config.dart';
import 'package:myfirstapp/rights/RightsManager.dart';

import 'WalletItem.dart';




WalletItem climateSettings = WalletItem(
  comment: 'Climate Settings',
  credDefId: 'Ex2aUnrrvTWRZyW9mYouPc:3:CL:17:Climate Settings',
  issuerDid: 'Ex2aUnrrvTWRZyW9mYouPc',
  schemaId: 'Ex2aUnrrvTWRZyW9mYouPc:2:climateSettings:1.0',
  schemaIssuerDid: 'Ex2aUnrrvTWRZyW9mYouPc',
  schemaName: 'climateSettings',
  schemaVersion: '1.0',
  attributes: [
    {'name': 'user_display_temperature_units', 'value': 'Celsius'},
    {'name': 'ac_on', 'value': 'true'},
    {'name': 'current_temperature', 'value': '20'},
  ],
);

WalletItem vissPurpose = WalletItem(
  comment: 'Viss Purpose',
  credDefId: 'Ex2aUnrrvTWRZyW9mYouPc:3:CL:20:Viss Purpose',
  issuerDid: 'Ex2aUnrrvTWRZyW9mYouPc',
  schemaId: 'Ex2aUnrrvTWRZyW9mYouPc:2:vissPurpose:1.0',
  schemaIssuerDid: 'Ex2aUnrrvTWRZyW9mYouPc',
  schemaName: 'vissPurpose',
  schemaVersion: '1.0',
  attributes: [
    {'name': 'expires', 'value': 'not yet'}, //check this
    {'name': 'name', 'value': 'general'},
    {'name': 'token', 'value': ''},
  ],
);



