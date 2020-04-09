import '../models/coin_model.dart';

abstract class BaseCryptoRepository {
  Future<List<Coin>> getCoins({int page});
  void dispose();
}
