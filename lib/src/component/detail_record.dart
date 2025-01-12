import 'package:flutter/cupertino.dart';

class DetailsRecord extends StatelessWidget {
  const DetailsRecord({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Container(
            decoration: const BoxDecoration(color: CupertinoColors.systemFill),
            child: Row(children: [
              Expanded(
                  child: Text(
                label,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              )),
              Expanded(
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        textAlign: TextAlign.end,
                        value,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w400),
                      )))
            ])));
  }
}
