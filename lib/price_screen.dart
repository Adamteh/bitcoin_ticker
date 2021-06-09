import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  CoinData coinData = CoinData();
  String btcData = '?';
  String etcData = '?';
  String ltcData = '?';
  void fetchedCoinData() async {
    try {
      List data = await coinData.getCoinData(currency: selectedCurrency);
      setState(() {
        // if(data !=null){
        //   for (int i = 0; i < 3; i++) {

        //   }
        // }
        if (data != null) {
          if (data[0] != 'NODATA') {
            btcData = data[0].toString();
          }
          if (data[1] != 'NODATA') {
            etcData = data[1].toString();
          }
          if (data[2] != 'NODATA') {
            ltcData = data[2].toString();
          }
        }
      });
    } catch (error) {
      throw 'Problem with the get request';
    }
  }

  Widget checkPlatformToBuildPicker() {
    Widget picker;
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      picker = CupertinoPicker(
          itemExtent: currenciesList.length.toDouble(),
          onSelectedItemChanged: (selectedIndex) {
            setState(() {
              selectedCurrency = currenciesList[selectedIndex];
            });
            fetchedCoinData();
          },
          children: currenciesList.map<Text>((String value) {
            return Text(value);
          }).toList());
    } else {
      picker = DropdownButton<String>(
          dropdownColor: Colors.lightBlue,
          value: selectedCurrency,
          items: currenciesList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCurrency = value;
            });
            fetchedCoinData();
          });
    }

    return picker;
  }

  @override
  void initState() {
    fetchedCoinData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(btcData);
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cryptoList.map((String value) {
              return Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 $value = ${value == 'BTC' ? btcData : value == 'ETC' ? etcData : ltcData} $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: checkPlatformToBuildPicker()),
        ],
      ),
    );
  }
}
