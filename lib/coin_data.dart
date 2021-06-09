import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<List> getCoinData({String currency}) async {
    try {
      List<dynamic> reponses = [];
      const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
      const apiKey = '4595E963-78C5-47CA-83E1-7D00CF8028C9';
      for (String crypto in cryptoList) {
        String requestURL = '$coinAPIURL/$crypto/$currency?apikey=$apiKey';
        http.Response response = await http.get(requestURL);
        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          reponses.add(jsonResponse['rate'].round());
        } else {
          reponses.add('NODATA');
        }
      }
      return reponses;
    } catch (error) {
      print(error);
      throw 'Problem with the get request';
    }
  }
}
