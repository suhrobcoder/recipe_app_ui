import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipe_app_ui/components/side_menu.dart';
import 'package:recipe_app_ui/pages/details/details_page.dart';

const categoryItems = ["Popular", "Recommended", "New"];
const selectedCategory = "Popular";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController pageController;
  double pagerIndex = 0;
  int sideMenuIndex = 0;
  int tabIndex = 0;

  @override
  void initState() {
    pageController = PageController(viewportFraction: 0.85);
    pageController.addListener(() {
      setState(() => pagerIndex = pageController.page ?? 0);
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBuilder: (context, index) {
        return Row(
          children: [
            SideMenu(
              profileImage: Image.asset("assets/images/profile.png"),
              currentIndex: sideMenuIndex,
              onItemSelected: (index) => setState(() => sideMenuIndex = index),
              items: [
                MenuItem("Breakfast"),
                MenuItem("Lunch"),
                MenuItem("Dinner"),
                MenuItem("Dessert"),
              ],
            ),
            Expanded(
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        CupertinoButton(
                            onPressed: () {},
                            child: SvgPicture.asset("assets/icons/search.svg")),
                        CupertinoButton(
                            onPressed: () {},
                            child:
                                SvgPicture.asset("assets/icons/dashboard.svg")),
                        const SizedBox(width: 20),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: AutoSizeText(
                        "Explore your favorite recipe",
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 38,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        itemCount: categoryItems.length,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          return CategoryItem(
                            title: categoryItems[index],
                            selected: selectedCategory == categoryItems[index],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: PageView.builder(
                        itemCount: 3,
                        padEnds: false,
                        controller: pageController,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 8 +
                                    12 *
                                        (1 - (pagerIndex - index).abs())
                                            .clamp(0, 1),
                                right: index == 2 ? 20 : 0,
                                top: 16,
                                bottom: 16),
                            child: Transform.scale(
                              scaleY:
                                  0.8 + 0.2 * (1 - (pagerIndex - index).abs()),
                              child: RecipeCard(
                                image: "assets/images/recipe1.png",
                                title: "Cookie Cup Cake",
                                subtitle: "20 min | Easy",
                                bookmarked: true,
                                onTap: () => Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (_) => const DetialsPage())),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      tabBar: CupertinoTabBar(
        currentIndex: tabIndex,
        iconSize: 24,
        activeColor: Colors.black,
        inactiveColor: Colors.black.withOpacity(0.75),
        onTap: (index) => setState(() => tabIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/home.svg"),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/bookmark.svg"),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/scan.svg"),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/profile.svg"),
          ),
        ],
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final bool bookmarked;
  final VoidCallback? onTap;

  const RecipeCard({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.bookmarked = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: const Offset(6, 4),
                blurRadius: 8,
                spreadRadius: 0,
                color: Colors.black.withOpacity(0.1)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 32,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                          color: Color(0xFFB4B4B4), fontSize: 15),
                    ),
                  ],
                ),
              ),
              if (bookmarked)
                const Positioned(
                  left: 28,
                  bottom: 28,
                  child: Icon(
                    Icons.bookmark,
                    color: Color(0xFFFEB800),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryItem({
    Key? key,
    required this.title,
    required this.selected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFEB800) : const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
    );
  }
}
