import 'package:flutter/material.dart';
import 'package:list_with_filters/custom_checkbox_tile.dart';
import 'package:list_with_filters/phone.dart';

final brands = [
  'Samsung',
  'Apple',
  'Xiaomi'
];

final colors = [
  'red',
  'yellow',
  'black',
  'blue',
  'white'
];

final prices = [
  'Less or equal than 100',
  'Less or equal than 500',
  'Less or equal than 1000'
];

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
  Map<String, List<String>?> filters = {};
  List<Phone> filteredPhones = phoneList;

  void _filter() {
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
      filters.clear();
      Navigator.of(context).pop();
    });
  }

  void _handleCheckFilter(bool checked, String key, String value) {
    final currentFilters = filters[key] ?? [];
    if(checked) {
      currentFilters.add(value);
    } else {
      currentFilters.remove(value);
    }
    filters[key] = currentFilters;
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
                return SimpleDialog(
                  title: const Text('Filters',textAlign: TextAlign.center,),
                  contentPadding: const EdgeInsets.all(16),
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Select a brand'),
                        ...brands.map((el) =>
                            CustomCheckboxTile(
                              label: el,
                              onChange: (check) => _handleCheckFilter(check, 'brand', el),
                            ),
                          ).toList(),
                        const Text('Select a price'),
                        ...prices.map((el) =>
                            CustomCheckboxTile(
                              label: el,
                              onChange: (check) => _handleCheckFilter(check, 'price', el),
                            )
                          ).toList(),
                        const Text('Select a colors'),
                        ...colors.map((el) =>
                            CustomCheckboxTile(
                              label: el,
                              onChange: (check) => _handleCheckFilter(check, 'color', el),
                            ),
                          ).toList(),
                        const SizedBox(height: 24,),
                        ElevatedButton(onPressed: _filter, child: const Text('APPLY')),
                      ],
                    ),
                  ],
                );
              });
            },
          ),
        ],
      ),
      body: filteredPhones.isEmpty
          ? const Center(child: Text('No product', style: TextStyle(fontSize: 16),))
          : ListView.builder(
        itemCount: filteredPhones.length,
        itemBuilder: (_, index) {
          final currentPhone = filteredPhones[index];
          return ListTile(
            title: Text(currentPhone.name),
            subtitle: Text('${currentPhone.brand}-${currentPhone.color}'),
            trailing: Text('\$ ${currentPhone.price}'),
          );
        }
      ),
    );
  }
}

class Filter {
  String name;
  bool Function(Phone) filterFn;

  Filter({required this.name, required this.filterFn});
}