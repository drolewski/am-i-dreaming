import 'package:am_i_dreaming/src/model/dream_document.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dream_list_item.dart';

class DreamsList extends StatefulWidget {
  const DreamsList(
      {super.key, required this.dreamDocuments, required this.isDreamSet});

  final List<DreamDocument> dreamDocuments;
  final bool isDreamSet;

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
    return !widget.isDreamSet
        ? const CircularProgressIndicator()
        : widget.dreamDocuments.isEmpty
            ? Text(
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                AppLocalizations.of(context)!.no_dreams)
            : ShaderMask(
                shaderCallback: (bounds) =>
                    _maskingGradient.createShader(bounds),
                blendMode: BlendMode.dstIn,
                child: AnimatedList(
                  key: _key,
                  reverse: true,
                  padding: const EdgeInsets.only(top: 60),
                  initialItemCount: widget.dreamDocuments.length,
                  itemBuilder: (_, int index, Animation<double> animation) {
                    return DreamListItem(
                      dream: widget.dreamDocuments[index],
                      dreamIndex: index,
                      animation: animation,
                    );
                  },
                ));
  }
}
