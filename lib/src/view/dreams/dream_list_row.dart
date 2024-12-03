import 'package:flutter/cupertino.dart';

import '../../model/dream_document.dart';
import '../../util/date_formater.dart';

class DreamListRow extends StatefulWidget {
  const DreamListRow({super.key, required this.dream});

  final DreamDocument dream;

  @override
  State<StatefulWidget> createState() => _DreamListRowState();
}

class _DreamListRowState extends State<DreamListRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 100,
            child: Text(
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                formatTimestamp(context, widget.dream.timestamp))),
        const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Icon(
              CupertinoIcons.zzz,
              size: 18,
            )),
        Expanded(
            child: Text(
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                widget.dream.text))
      ],
    );
  }
}
