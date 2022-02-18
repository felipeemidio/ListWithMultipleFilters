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

  void _filter(Map<String, List<String>?> filters) {
    setState(() {
      filteredPhones = phoneList;
      filters.forEach((key, value) {
        if((value ?? []).isNotEmpty) {
          filteredPhones = filteredPhones.where((phone) {
            switch(key) {
              case 'brand':
                return value!.contains(phone.brand);
              case 'color':
                return value!.contains(phone.color);
              case 'price':
                if(value!.contains(prices[2])) {
                  return phone.price <= 1000;
                }
                if(value.contains(prices[1])) {
                  return phone.price <= 500;
                }
                if(value.contains(prices[0])) {
                  return phone.price <= 100;
                }
                return true;
              default:
                return false;
            }
          }).toList();
        }
      });
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
            onPressed: () {
              showDialog<Filter>(context: context, builder: (_) {
                return FilterDialog(onApplyFilters: _filter,);
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