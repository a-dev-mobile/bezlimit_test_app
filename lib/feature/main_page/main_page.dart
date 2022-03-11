// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:math' hide log;

import 'package:bezlimit_test_app/core/widgets/custom_snackbar.dart';
import 'package:bezlimit_test_app/feature/item_selection_page/item_selection_page.dart';
import 'package:bezlimit_test_app/feature/main_page/widgets/long_card_field.dart';
import 'package:bezlimit_test_app/feature/main_page/widgets/square_card_field.dart';
import 'package:bezlimit_test_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ScrollController _scrollControllerVertical = ScrollController();
  final ScrollController _scrollControllerHorizontal = ScrollController();
  static const int _itemCount = 1000;
  static const double _squareCardDimension = 90;
  static const double _squareCardPading = 16;
  int? _selectedIndex;

  final ValueNotifier<double> _scrollProgressVertical =
      ValueNotifier<double>(0);

  @override
  void initState() {
    enableScrollListenerVertical();
    super.initState();
  }

  void scrollToSelected() {
    if (_selectedIndex == null) return;

    if (_scrollControllerHorizontal.hasClients) {
      _scrollControllerHorizontal.animateTo(
        (_squareCardDimension * (_selectedIndex! - 1)) +
            (_selectedIndex! * _squareCardPading) -
            (_squareCardPading * 4),
        duration: const Duration(milliseconds: 3000),
        curve: Curves.ease,
      );
    }
  }

  void enableScrollListenerVertical() {
    return _scrollControllerVertical.addListener(() {
      final position = _scrollControllerVertical.position;
      _scrollProgressVertical.value =
          position.pixels / position.maxScrollExtent;

      if (_scrollProgressVertical.value == 1) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            showMySnackBar(context.l10n.snackBar),
          );
      }
    });
  }

  @override
  void dispose() {
    _scrollControllerVertical.dispose();
    _scrollControllerHorizontal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    log('---build');
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildAnimatedSVG(),
            CustomScrollView(
              controller: _scrollControllerVertical,
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: size.width * 0.72,
                  ),
                ),
                SliverFillRemaining(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      color: Colors.grey[300],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._buildLongCardField(size),
                          const SizedBox(height: 50),
                          _buildSquareCardField(
                            dimension: _squareCardDimension,
                            selectedIndex: _selectedIndex,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareCardField({
    required double dimension,
    int? selectedIndex,
  }) {
    return SizedBox(
      height: dimension,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        controller: _scrollControllerHorizontal,
        itemCount: _itemCount,
        itemBuilder: (context, index) {
          return SquareCardField(
            /// selected block
            isSelected: index == selectedIndex,
            index: index,
            dimension: dimension,
            onClick: (int i) async {
              _selectedIndex = await Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ItemSelectionPage(initIndex: i, itemCount: _itemCount),
                ),
              );
              scrollToSelected();
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: _squareCardPading);
        },
      ),
    );
  }

  List<Widget> _buildLongCardField(Size size) {
    return [
      const SizedBox(height: 26),
      LongCardField(width: size.width * 0.7),
      const SizedBox(height: 14),
      LongCardField(width: size.width * 0.86),
      const SizedBox(height: 14),
      LongCardField(width: size.width * 0.57)
    ];
  }

  Widget _buildAnimatedSVG() {
    return Positioned(
      left: -100,
      top: -100,
      child: ValueListenableBuilder<double>(
        valueListenable: _scrollProgressVertical,
        builder: (BuildContext context, double value, Widget? child) {
          return Transform.rotate(
            angle: -pi * _scrollProgressVertical.value,
            child:
                SvgPicture.asset('assets/circle.svg', width: 300, height: 300),
          );
        },
      ),
    );
  }
}
