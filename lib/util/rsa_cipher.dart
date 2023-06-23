import 'dart:convert';

import 'package:passwd_hints/env/env.dart';

class RSACipherizer {
  /// First prime number.
  /// p
  final int _firstPrime = int.parse(Env.firstPrime);

  /// Second prime number.
  /// q
  final int _secondPrime = int.parse(Env.secondPrime);

  /// Cypher exponent : must be prime to euler indicator. Part of the public
  /// key.
  final int _e = int.parse(Env.cypherExponent);

  /// Modular inverse : it is the private key.
  final int _d = int.parse(Env.modularInverse);

  /// Base used for base 64 conversion.
  final int _base = 127;

  /// Blank used to fill base 64 elements.
  final String _blank = '-';

  /// Cypher modulo. Part of the public key.
  int get n => _firstPrime * _secondPrime;

  /// Euler indicator.
  /// phi(n)
  int get phiN => (_firstPrime - 1) * (_secondPrime - 1);

  int _encrypt(int message) {
    int localE = _e;
    int encryptedMessage = 1;
    while (localE > 0) {
      encryptedMessage *= message;
      encryptedMessage %= n;
      --localE;
    }
    return encryptedMessage;
  }

  int _decrypt(int encryptedMessage) {
    int localD = _d;
    int decryptedMessage = 1;
    while (localD > 0) {
      decryptedMessage *= encryptedMessage;
      decryptedMessage %= n;
      --localD;
    }
    return decryptedMessage;
  }

  String cipherMessage(String message) {
    List<int> ciphered = List.empty(growable: true);
    for (int i = 0; i < message.length; ++i) {
      ciphered.add(_encrypt(message[i].codeUnitAt(0)));
    }
    List<String> b64List = List.empty(growable: true);

    int longest = 0;
    for (int i in ciphered) {
      int tempI = i;
      List<int> bytes = List.empty(growable: true);
      int cpt = 0;
      while (tempI > 0) {
        bytes.add(tempI % _base);
        tempI = (tempI / _base).floor();
        ++cpt;
      }
      if (cpt > longest) {
        longest = cpt + 1;
      }
      b64List.add(base64.encode(bytes));
    }
    for (int i = 0; i < b64List.length; ++i) {
      int diff = longest - b64List[i].length;
      while (diff > 0) {
        b64List[i] += _blank;
        --diff;
      }
    }
    return b64List.join();
  }

  String decipherMessage(String cipheredMessage) {
    String decipheredMessage = '';
    List<String> parts = _splitByLength(cipheredMessage, 4);
    List<int> intParts = List.empty(growable: true);
    for (String part in parts) {
      String trimmed = part.replaceAll(_blank, '');
      List<int> bytes = base64.decode(trimmed);
      int intPart = 0;
      for (int i = bytes.length - 1; i >= 0; --i) {
        intPart = intPart * _base + bytes[i];
      }
      intParts.add(intPart);
    }

    for (int i in intParts) {
      decipheredMessage += String.fromCharCode(_decrypt(i));
    }
    return decipheredMessage;
  }

  List<String> _splitByLength(String value, int length) {
    List<String> pieces = [];

    for (int i = 0; i < value.length; i += length) {
      int offset = i + length;
      pieces.add(
        value.substring(i, offset >= value.length ? value.length : offset),
      );
    }
    return pieces;
  }
}
