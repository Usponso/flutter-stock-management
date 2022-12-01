import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/TransactionProvider.dart';

enum ActionType { buy, sale }

class OrderRadioInput extends StatefulWidget {
  const OrderRadioInput({super.key});

  @override
  State<OrderRadioInput> createState() => _OrderRadioInput();
}

class _OrderRadioInput extends State<OrderRadioInput> {
  ActionType? _type = ActionType.sale;

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(builder: (context, provider, child) {
      return Row(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              child: ListTile(
                title: const Text('Vente'),
                leading: Radio<ActionType>(
                  value: ActionType.sale,
                  groupValue: _type,
                  onChanged: (ActionType? value) {
                    setState(() {
                      _type = value;
                      Provider.of<TransactionProvider>(context, listen: false)
                          .setActionType(false);
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: ListTile(
                title: const Text('Achat'),
                leading: Radio<ActionType>(
                  value: ActionType.buy,
                  groupValue: _type,
                  onChanged: (ActionType? value) {
                    setState(() {
                      _type = value;
                      Provider.of<TransactionProvider>(context, listen: false)
                          .setActionType(true);
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
