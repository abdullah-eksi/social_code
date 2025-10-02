import 'package:flutter/material.dart';

class SliderMenu extends StatefulWidget {
  final List<String> items;
  final Function(int) onTap;
  final int initialIndex;

  const SliderMenu({
    super.key,
    required this.items,
    required this.onTap,
    this.initialIndex = 0,
  });

  @override
  State<SliderMenu> createState() => _SliderMenuState();
}

class _SliderMenuState extends State<SliderMenu> {
  int selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _itemKeys = [];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    _itemKeys.addAll(List.generate(widget.items.length, (_) => GlobalKey()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected();
    });
  }

  void _onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onTap(index);
    _scrollToSelected();
  }

  void _scrollToSelected() {
    if (_itemKeys[selectedIndex].currentContext != null) {
      RenderBox renderBox = _itemKeys[selectedIndex]
          .currentContext!
          .findRenderObject() as RenderBox;
      double itemCenter =
          renderBox.localToGlobal(Offset.zero).dx + renderBox.size.width / 2;
      double screenCenter = MediaQuery.of(context).size.width / 2;
      double offset = _scrollController.offset + itemCenter - screenCenter;
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(), // Kaydırmayı yumuşak yapar
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => _onItemTap(index),
            child: Container(
              key: _itemKeys[index],
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.items[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 3,
                    width: isSelected ? 20 : 0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
