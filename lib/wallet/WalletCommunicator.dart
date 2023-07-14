//comm with wallet over ssi agent

import 'dart:convert';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import '../main/config.dart';
import 'WalletItem.dart';

class WalletCommunicator {

  final Logger logger = Logger();

  Future<bool> issue(WalletItem item) async {
    //get connection ID from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String connectionId = prefs.getString('connectionId') ?? '';


    Map<String, dynamic> credentialProposal = {
      '@type': 'issue-credential/1.0/credential-preview',
      'attributes': item.attributes,
    };


    Map<String, dynamic> payload = {
      'auto_remove': true,
      'comment': item.comment,
      'connection_id': connectionId,
      'cred_def_id': item.credDefId,
      'credential_proposal': credentialProposal,
      'issuer_did': item.issuerDid,
      'schema_id': item.schemaId,
      'schema_issuer_did': item.schemaIssuerDid,
      'schema_name': item.schemaName,
      'schema_version': item.schemaVersion,
      'trace': true,
    };


    String payloadJson = jsonEncode(payload);


    Uri url = Uri.parse('$acapyAgentUrl/issue-credential/send');
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: payloadJson,
    );

    // Log request
    logger.d('Issuing credential to $connectionId:');
    logger.d('  Payload: $payloadJson');
    logger.d('  Response: ${response.body}');

    // Check if request was successful
    if (response.statusCode == 200) {
      logger.i('Credential issued successfully');
      return true;
    } else {
      logger.e('Error issuing credential: ${response.statusCode}');
      return false;
    }
  }


  Future<bool> requestProof(WalletItem item) async {
    // Get connection ID from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String connectionId = prefs.getString('connectionId') ?? '';

// Build proof request JSON
    Map<String, dynamic> proofRequest = {
      'comment': item.comment,
      'connection_id': connectionId,
      'proof_request': {
        'name': item.schemaName,
        'version': item.schemaVersion,
        'nonce': '1234567890',
        'non_revoked': {
          'to': DateTime
              .now()
              .millisecondsSinceEpoch ~/ 1000,
        },
        'requested_attributes': {},
        'requested_predicates': {},
        'restrictions': [
          {
            'schema_name': item.schemaName,
          },
        ],
      },
      'trace': true,
    };

    // Add requested attributes to proof request
    for (var i = 0; i < item.attributes.length; i++) {
      var attribute = item.attributes[i];
      proofRequest['proof_request']['requested_attributes'][attribute['name']] =
      {
        'names': [attribute['name']],
        'restrictions': [
          {
            'schema_name': item.schemaName,
          },
        ],
        'non_revoked': {
          'to': DateTime
              .now()
              .millisecondsSinceEpoch ~/ 1000,
        },
      };
    }

    // Convert payload to JSON string
    String payloadJson = jsonEncode(proofRequest);

    // Send HTTP POST request to server to send proof request
    Uri url = Uri.parse('$acapyAgentUrl/present-proof/send-request');
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: payloadJson,
    );
    logger.d('Sending proof request to $connectionId:');
    logger.d('  Payload: $payloadJson');
    logger.d('  Response: ${response.body}');

    // Check if request was successful
    if (response.statusCode == 200) {
      // Get presentation exchange ID (pres_ex_id) from response body
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      String presExId = responseBody['presentation_exchange_id'];

      //presentation payload JSON
      Map<String, dynamic> presentation = {
        'comment': 'Presentation from Flutter app',
        'presentation': {},
        'trace': true,
      };

      //add attributes to presentation
      for (var i = 0; i < item.attributes.length; i++) {
        var attribute = item.attributes[i];
        presentation['presentation'][attribute['name']] = {
          'raw': attribute['value'],
        };
      }

      //convert payload to JSON string
      String presentationJson = jsonEncode(presentation);

      //send HTTP POST request to server to send presentation

      Uri presentationUrl = Uri.parse(
          '$acapyAgentUrl/present-proof/records/$presExId/verify-presentation');

      int timeout = 60; // timeout in seconds
      int startTime = DateTime.now().millisecondsSinceEpoch;
      while (true) {
        if ((DateTime.now().millisecondsSinceEpoch - startTime) / 1000 > timeout) {
          logger.e('Presentation verification timed out');
          break;
        }

        http.Response presentationResponse = await http.post(
          presentationUrl,
          headers: {
            'Content-Type': 'application/json',
          },
          body: presentationJson,
        );

        //log presentation request
        logger.d('Sending presentation response:');
        logger.d('  Payload: $presentationJson');
        logger.d('  Response status code: ${presentationResponse.statusCode}');

        //check the response status code to see if the presentation is verified
        if (presentationResponse.statusCode == 200) {
          logger.i('Presentation verified successfully');
          // ... NEED TO HANDLE THE VERIFIED CREDENTIAL!!!!! MAYBE BOOLEAN??????
          return true;
          break;
        } else if (presentationResponse.statusCode == 400) {
          logger.d('Presentation not verified yet, checking again in 1 second...');
          //wait for 1 second before checking status again
          await Future.delayed(Duration(seconds: 1));
          continue; //reexecute HTTP POST request and check response status code again
        } else if (presentationResponse.statusCode == 404) {
          logger.e('Presentation exchange not found');
          return false;
          break;
        } else {
          logger.e('Error verifying presentation: ${presentationResponse.statusCode}');
          return false;
          break;
        }
      }
    }
    return false;
  }
}

//get




//update






