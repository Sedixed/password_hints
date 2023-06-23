import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'FIRST_PRIME', obfuscate: true)
  static final firstPrime = _Env.firstPrime;

  @EnviedField(varName: 'SECOND_PRIME', obfuscate: true)
  static final secondPrime = _Env.secondPrime;

  @EnviedField(varName: 'CYPHER_EXPONENT', obfuscate: true)
  static final cypherExponent = _Env.cypherExponent;

  @EnviedField(varName: 'MODULAR_INVERSE', obfuscate: true)
  static final modularInverse = _Env.modularInverse;
}
