import 'package:am_i_dreaming/src/model/dream_document.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'dream_list_row.dart';

class DreamListItem extends StatefulWidget {
  const DreamListItem(
      {super.key,
      required this.dream,
      required this.animation,
      required this.dreamIndex});

  final DreamDocument dream;
  final int dreamIndex;
  final Animation<double> animation;

  @override
  State<StatefulWidget> createState() => _DreamListItemState();
}

class _DreamListItemState extends State<DreamListItem> {
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor: widget.animation,
        child: Center(
            child: Container(
                decoration: BoxDecoration(
                    color: CupertinoColors.systemFill,
                    borderRadius: BorderRadius.circular(8)),
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 4, bottom: 4),
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                    onTap: () {
                      context.push("/dream/${widget.dreamIndex}");
                    },
                    child: DreamListRow(dream: widget.dream)))));
  }
}
