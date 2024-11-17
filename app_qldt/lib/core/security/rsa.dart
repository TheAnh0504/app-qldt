import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import "package:pointycastle/export.dart";
import 'package:pointycastle/pointycastle.dart';
import 'package:app_qldt/model/datastores/sw_secure_storage.dart';

class RSA {
  static Future<(RSAPublicKey, RSAPrivateKey)> generatekeyPair(
      [int bitLength = 2048]) async {
    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
          _secureRandom()));

    final pair = keyGen.generateKeyPair();

    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;

    await swSecureStorage.write(
        key: ssPrivateKey,
        value: jsonEncode({
          "d": myPrivate.privateExponent.toString(),
          "m": myPrivate.modulus.toString(),
          "p": myPrivate.p.toString(),
          "q": myPrivate.q.toString(),
          "createdAt": DateTime.now().toIso8601String()
        }));
    await swSecureStorage.write(
        key: ssPublicKey,
        value: jsonEncode({
          "e": myPublic.publicExponent.toString(),
          "m": myPublic.modulus.toString(),
          "createdAt": DateTime.now().toIso8601String()
        }));

    return (myPublic, myPrivate);
  }

  Uint8List sign(RSAPrivateKey privateKey, Uint8List dataToSign) {
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    final sig = signer.generateSignature(dataToSign);
    return sig.bytes;
  }

  bool verify(
      RSAPublicKey publicKey, Uint8List signedData, Uint8List signature) {
    final sig = RSASignature(signature);
    final verifier = RSASigner(SHA256Digest(), '0609608648016503040201');
    verifier.init(false, PublicKeyParameter<RSAPublicKey>(publicKey));
    try {
      return verifier.verifySignature(signedData, sig);
    } on ArgumentError {
      return false;
    }
  }

  static Uint8List encrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt

    return _processInBlocks(encryptor, dataToEncrypt);
  }

  static Uint8List decrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false,
          PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt

    return _processInBlocks(decryptor, cipherText);
  }

  static Uint8List _processInBlocks(
      AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);
    final output = Uint8List(numBlocks * engine.outputBlockSize);
    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;
      outputOffset += engine.processBlock(
          input, inputOffset, chunkSize, output, outputOffset);
      inputOffset += chunkSize;
    }
    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
  }

  static SecureRandom _secureRandom() {
    final secureRandom = FortunaRandom();
    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  static String encodePublicKeyToPem(RSAPublicKey publicKey) {
    var algorithmSeq = ASN1Sequence();
    var paramsAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(ASN1ObjectIdentifier.fromName('rsaEncryption'));
    algorithmSeq.add(paramsAsn1Obj);

    var publicKeySeq = ASN1Sequence();
    publicKeySeq.add(ASN1Integer(publicKey.modulus));
    publicKeySeq.add(ASN1Integer(publicKey.exponent));
    var publicKeySeqBitString =
        ASN1BitString(stringValues: Uint8List.fromList(publicKeySeq.encode()));

    var topLevelSeq = ASN1Sequence();
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqBitString);
    var dataBase64 = base64.encode(topLevelSeq.encode());
    var chunks = _chunk(dataBase64, 64);

    return '-----BEGIN PUBLIC KEY-----\n${chunks.join('\n')}\n-----END PUBLIC KEY-----';
  }

  static String encodePrivateKeyToPem(RSAPrivateKey privateKey) {
    var version = ASN1Integer(BigInt.from(0));

    var algorithmSeq = ASN1Sequence();
    var algorithmAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList(
        [0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
    var paramsAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(algorithmAsn1Obj);
    algorithmSeq.add(paramsAsn1Obj);

    var privateKeySeq = ASN1Sequence();
    var modulus = ASN1Integer(privateKey.n);
    var publicExponent = ASN1Integer(BigInt.parse('65537'));
    var privateExponent = ASN1Integer(privateKey.privateExponent);
    var p = ASN1Integer(privateKey.p);
    var q = ASN1Integer(privateKey.q);
    var dP = privateKey.privateExponent! % (privateKey.p! - BigInt.from(1));
    var exp1 = ASN1Integer(dP);
    var dQ = privateKey.privateExponent! % (privateKey.q! - BigInt.from(1));
    var exp2 = ASN1Integer(dQ);
    var iQ = privateKey.q!.modInverse(privateKey.p!);
    var co = ASN1Integer(iQ);

    privateKeySeq.add(version);
    privateKeySeq.add(modulus);
    privateKeySeq.add(publicExponent);
    privateKeySeq.add(privateExponent);
    privateKeySeq.add(p);
    privateKeySeq.add(q);
    privateKeySeq.add(exp1);
    privateKeySeq.add(exp2);
    privateKeySeq.add(co);
    var publicKeySeqOctetString =
        ASN1OctetString(octets: Uint8List.fromList(privateKeySeq.encode()));

    var topLevelSeq = ASN1Sequence();
    topLevelSeq.add(version);
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqOctetString);
    var dataBase64 = base64.encode(topLevelSeq.encode());
    var chunks = _chunk(dataBase64, 64);
    return '-----BEGIN PRIVATE KEY-----\n${chunks.join('\n')}\n-----END PRIVATE KEY-----';
  }

  static List<String> _chunk(String s, int chunkSize) {
    var chunked = <String>[];
    for (var i = 0; i < s.length; i += chunkSize) {
      var end = (i + chunkSize < s.length) ? i + chunkSize : s.length;
      chunked.add(s.substring(i, end));
    }
    return chunked;
  }
}
