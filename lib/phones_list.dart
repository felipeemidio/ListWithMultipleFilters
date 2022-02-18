import 'package:flutter/material.dart';
import 'package:list_with_filters/phone.dart';

class PhonesList extends StatelessWidget {
  final List<Phone> phones;

  const PhonesList({Key? key, required this.phones}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(phones.isEmpty) {
      return const Center(child: Text('No product', style: TextStyle(fontSize: 16),));
    }

    return ListView.builder(
        itemCount: phones.length,
        itemBuilder: (_, index) {
          final currentPhone = phones[index];
          return ListTile(
            title: Text(currentPhone.name),
            subtitle: Text('${currentPhone.brand}-${currentPhone.color}'),
            trailing: Text('\$ ${currentPhone.price}'),
          );
        }
    );
  }
}
