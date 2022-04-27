import 'package:flutter/material.dart';
import 'package:recipe_app_ui/utils/iterable_extensions.dart';

class SideMenu extends StatelessWidget {
  final Widget profileImage;
  final List<MenuItem> items;
  final int currentIndex;
  final void Function(int)? onItemSelected;

  const SideMenu({
    Key? key,
    required this.profileImage,
    required this.items,
    this.currentIndex = 0,
    this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(40)),
        child: Container(
          color: const Color(0xFF1B1B1B),
          child: Column(
            children: [
              SafeArea(child: profileImage),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: items
                        .mapIndexed(
                          (element, index) => MenuItemWidget(
                            title: element.title,
                            selected: currentIndex == index,
                            onTap: () => onItemSelected?.call(index),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final String title;

  MenuItem(this.title);
}

class MenuItemWidget extends StatelessWidget {
  final String title;
  final bool selected;
  final void Function() onTap;

  const MenuItemWidget({
    Key? key,
    required this.title,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFFEB800) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: RotatedBox(
          quarterTurns: 3,
          child: SizedBox(
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: selected
                        ? const Color(0xFF1B1B1B)
                        : const Color(0xFF969696),
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
