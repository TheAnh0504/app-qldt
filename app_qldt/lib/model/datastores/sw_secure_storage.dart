import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/asymmetric/api.dart';

const swSecureStorage = FlutterSecureStorage();
const ssPrivateKey = "privateKey";
const ssPublicKey = "publicKey";

extension SWSSExtension on FlutterSecureStorage {
  Future<(RSAPrivateKey?, DateTime)?> getPrivateKey() async {
    return read(key: ssPrivateKey).then((value) {
      if (value == null) return null;
      final obj = jsonDecode(value);
      return (
        RSAPrivateKey(BigInt.parse(obj["m"]), BigInt.parse(obj["d"]),
            BigInt.parse(obj["p"]), BigInt.parse(obj["q"])),
        DateTime.parse(obj["createdAt"])
      );
    });
  }

  Future<(RSAPublicKey?, DateTime)?> getPublicKey() async {
    return read(key: ssPublicKey).then((value) {
      if (value == null) return null;
      final obj = jsonDecode(value);
      return (
        RSAPublicKey(BigInt.parse(obj["m"]), BigInt.parse(obj["e"])),
        DateTime.parse(obj["createdAt"])
      );
    });
  }
}
