import 'package:crypto/crypto.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
// import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:pointycastle/random/fortuna_random.dart';
// import 'dart:typed_data';
import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:pointycastle/random/fortuna_random.dart';

class Wallet {
  // ignore: unused_field
  late RSAPrivateKey _privateKey;
  RSAPublicKey? _publicKey;

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Wallet() {
    _generateKeyPair();
  }

  void _generateKeyPair() async {
    final seed = await _generateRandomSeed();

    final fortunaRandom = FortunaRandom();
    fortunaRandom.seed(KeyParameter(seed));

    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
        fortunaRandom,
      ));

    final pair = keyGen.generateKeyPair();

    _privateKey = pair.privateKey as RSAPrivateKey;
    _publicKey = pair.publicKey as RSAPublicKey?;
  }

  Future<Uint8List> _generateRandomSeed() async {
    final seedString = await _secureStorage.read(key: 'wallet_seed');

    if (seedString != null && seedString.isNotEmpty) {
      final seed = base64.decode(seedString);
      return Uint8List.fromList(seed);
    } else {
      final seed = _generateRandomBytes();
      await _secureStorage.write(
          key: 'wallet_seed', value: base64.encode(seed));
      return seed;
    }
  }

  Uint8List _generateRandomBytes() {
    final random = Random.secure();
    return Uint8List.fromList(List.generate(32, (_) => random.nextInt(256)));
  }

  String getPublicKeyAddress() {
    if (_publicKey == null) {
      throw Exception('Wallet has not been initialized');
    }

    final publicKeyBytes = _publicKey?.modulus!.toRadixString(16).codeUnits;
    final publicKeyHash = sha256.convert(publicKeyBytes!).toString();

    return 'ISLAMI-$publicKeyHash';
  }
}
