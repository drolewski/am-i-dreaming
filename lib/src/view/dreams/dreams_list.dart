import 'package:am_i_dreaming/src/model/dream_document.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dream_list_item.dart';

class DreamsList extends StatefulWidget {
  const DreamsList({super.key, required this.dreamDocuments});

  final List<DreamDocument> dreamDocuments;

  @override
  State<StatefulWidget> createState() => _DreamsListState();
}

class _DreamsListState extends State<DreamsList> {
  final _key = GlobalKey();

  static const Gradient _maskingGradient = LinearGradient(colors: [
    CupertinoColors.transparent,
    CupertinoColors.systemTeal,
  ], stops: [
    0.0,
    0.4,
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);

  @override
  Widget build(BuildContext context) {
    return widget.dreamDocuments.isEmpty
        ? const CircularProgressIndicator()
        : ShaderMask(
            shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
            blendMode: BlendMode.dstIn,
            child: AnimatedList(
              key: _key,
              reverse: true,
              padding: const EdgeInsets.only(top: 60),
              initialItemCount: widget.dreamDocuments.length,
              itemBuilder: (_, int index, Animation<double> animation) {
                return DreamListItem(
                  dream: widget.dreamDocuments[index],
                  animation: animation,
                );
              },
            ));
  }
}
