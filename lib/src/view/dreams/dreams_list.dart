import 'package:am_i_dreaming/src/model/dream_document.dart';
import 'package:flutter/cupertino.dart';

import '../../util/date_formater.dart';

class DreamsList extends StatefulWidget {
  const DreamsList({super.key, required this.dreamDocuments});

  final List<DreamDocument> dreamDocuments;

  @override
  State<StatefulWidget> createState() => _DreamsListState();
}

class _DreamsListState extends State<DreamsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        for (var dream in widget.dreamDocuments)
          Text('${formatTimestamp(context, dream.timestamp)}: ${dream.text}'),
        const SizedBox(height: 8),
      ],
    );
  }
}
