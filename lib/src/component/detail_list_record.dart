import 'package:flutter/cupertino.dart';

class DetailListRecord extends StatelessWidget {
  const DetailListRecord(
      {super.key, required this.label, required this.values});

  final String label;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final valueWidgets = values.map((h) {
      return Text(
        h,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      );
    }).toList();
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: valueWidgets,
                  )))
        ]));
  }
}
