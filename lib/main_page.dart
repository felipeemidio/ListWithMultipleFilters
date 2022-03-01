import 'dart:math';

import 'package:flutter/material.dart';
import 'package:list_with_filters/filter_dialog.dart';
import 'package:list_with_filters/phone.dart';
import 'package:list_with_filters/phones_list.dart';

final phoneList = [
  Phone(
    name: 'Model 1',
    price: 100.0,
    color: 'red',
    brand: 'Samsung',
  ),
  Phone(
    name: 'Model 2',
    price: 600.0,
    color: 'blue',
    brand: 'Samsung',
  ),
  Phone(
    name: 'Model 3',
    price: 200.0,
    color: 'black',
    brand: 'Xiaomi',
  ),
  Phone(
    name: 'Model 4',
    price: 650.0,
    color: 'red',
    brand: 'Apple',
  ),
  Phone(
    name: 'Model 5',
    price: 320.0,
    color: 'black',
    brand: 'Samsung',
  ),
  Phone(
    name: 'Model 6',
    price: 900.0,
    color: 'yellow',
    brand: 'Apple',
  ),
];

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Phone> filteredPhones = phoneList;

  void _filter(Map<String, List<dynamic>?> filters) {
    print("filters $filters");
    filteredPhones = phoneList.toList();

    List tempbrand = [];
    List tempcolor = [];
    List<int> tempprice2 = [];
    int tempprice = 1000;
    filters.forEach((key, value) {
      if (key == 'brand') {
        for (var i = 0; i < value!.length; i++) {
          tempbrand.add((value[i] as Map).keys.first);
        }
      } else if (key == 'color') {
        for (var i = 0; i < value!.length; i++) {
          tempcolor.add((value[i] as Map).keys.first);
        }
      } else if (key == 'price') {
        for (var i = 0; i < value!.length; i++) {
          print((value[i] as Map).keys.first.toString());
          if ((value[i] as Map)
              .keys
              .first
              .toString()
              .contains((prices[0] as Map).keys.first)) {
            tempprice2.add(100);
          }
          if ((value[i] as Map)
              .keys
              .first
              .toString()
              .contains((prices[1] as Map).keys.first)) {
            tempprice2.add(500);
          }
          if ((value[i] as Map)
              .keys
              .first
              .toString()
              .contains((prices[2] as Map).keys.first)) {
            tempprice2.add(1000);
          }
        }
      }
    });
    tempprice2.isEmpty ? tempprice == 1000 : tempprice = tempprice2.reduce(max);
    if (tempbrand.isEmpty) {
      for (var element in brands) {
        tempbrand.add((element as Map).keys.first);
      }
    }
    if (tempcolor.isEmpty) {
      for (var element in colors) {
        tempcolor.add((element as Map).keys.first);
      }
    }
    setState(() {
      filteredPhones = filteredPhones.where((phone) {
        return tempbrand.contains(phone.brand) &&
            tempcolor.contains(phone.color) &&
            phone.price <= tempprice;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cellphones List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () async {
              showDialog<Filter>(
                  context: context,
                  builder: (_) {
                    return FilterDialog(
                      onApplyFilters: _filter,
                    );
                  });
            },
          ),
        ],
      ),
      body: PhonesList(phones: filteredPhones),
    );
  }
}

class Filter {
  String name;
  bool Function(Phone) filterFn;

  Filter({required this.name, required this.filterFn});
}
