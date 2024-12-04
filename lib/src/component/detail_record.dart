import 'package:flutter/cupertino.dart';

class DetailsRecord extends StatelessWidget {
  const DetailsRecord({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(children: [
          Expanded(
              child: Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          )),
          Expanded(
              child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    value,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  )))
        ]));
  }
}
