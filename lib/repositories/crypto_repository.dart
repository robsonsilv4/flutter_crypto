import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/coin_model.dart';
import 'base_crypto_repository.dart';

class CryptoRepository extends BaseCryptoRepository {
  static const String _baseUrl = 'https://min-api.cryptocompare.con';
  static const int _perPage = 20;

  final http.Client _httpClient;

  CryptoRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  Future<List<Coin>> getCoins({int page}) async {
    List<Coin> coins = [];
    String requestUrl =
        '$_baseUrl/data/top/totalvolfull?limit=$_perPage&tsym=USD&page=$page';
    try {
      final response = await _httpClient.get(requestUrl);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> coinList = data['Data'];
        coinList.forEach(
          (json) => coins.add(Coin.fromJson(json)),
        );
      }
      return coins;
    } catch (error) {
      throw (error);
    }
  }

  @override
  void dispose() {
    _httpClient.close();
  }
}
