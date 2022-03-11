import 'dart:developer';

import 'package:bezlimit_test_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItemSelectionPage extends StatefulWidget {
  const ItemSelectionPage({
    Key? key,
    required this.initIndex,
    required this.itemCount,
  }) : super(key: key);

  final int initIndex;
  final int itemCount;
  @override
  State<ItemSelectionPage> createState() => _ItemSelectionPageState();
}

class _ItemSelectionPageState extends State<ItemSelectionPage> {
  late final TextEditingController textController;
  bool _numberInputIsValid = true;
  late int _selectedIndex;

  @override
  void initState() {
    textController = TextEditingController(text: widget.initIndex.toString());
    _selectedIndex = widget.initIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              TextField(
                autofocus: true,
                controller: textController,
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.headline4,
                onChanged: (String val) {
                  final v = int.tryParse(val);
                  log('parse value $v');

                  ///validator max value
                  if (v == null || v > widget.itemCount - 1 || v < 0) {
                    setState(() => _numberInputIsValid = false);
                  } else {
                    /// set last value
                    _selectedIndex = v;
                    setState(() => _numberInputIsValid = true);
                  }
                },
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  errorText: _numberInputIsValid
                      ? null
                      : '${l10n.pleaseEnterNumberFrom0To} ${widget.itemCount - 1}',
                  labelText: l10n.enterInteger,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_numberInputIsValid) {
                    FocusScope.of(context).requestFocus(FocusNode());

                    Navigator.pop(context, _selectedIndex);

                
                  }
                },
                child: Text(l10n.save),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
