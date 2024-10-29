import 'package:riwama/view/auth/login_step/signup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  static const routeName = '/onboarding';

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  bool isDarkTheme = false;
  final PageController pageController = PageController();
  int page = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            scrollDirection: Axis.vertical,
            controller: pageController,
            onPageChanged: (value) => setState(() {
              page = value;
            }),
            children: [
              onBoarding(
                imgUrl: "assets/on1.jpg",
                title: 'Welcome to The RIWAMA Mobile App',
                subTitle:
                    "Built to help the Rivers State Waste Management Agency engage the public effectively.",
                context: context,
              ),
              onBoarding(
                imgUrl: "assets/on2.png",
                title: "RIWAMA Services",
                subTitle:
                    "Experience Streamlined waste collection processes.",
                context: context,
              ),
              onBoarding(
                imgUrl: "assets/on3.jpg",
                title: "Why Choose The RIWAMA Mobile App",
                subTitle:
                    "Just with a few clicks you would promote better waste management practices and Make the Surroundings more Enjoyable.",
                context: context,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: SmoothPageIndicator(
                controller: pageController,
                count: 3,
                effect: ExpandingDotsEffect(
                  dotWidth: 10,
                  dotHeight: 10,
                  activeDotColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          if (page < 3) {
            setState(() {
              page++;
              pageController.animateToPage(
                page,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              );
            });
            if (page == 3) {
              setState(() {
                page = 0;
                context.go(Signup.routeName);
              });
            }
          }
        },
        child: const Icon(Icons.arrow_downward),
      ),
    );
  }

  Widget onBoarding({
    required String imgUrl,
    required String title,
    required String subTitle,
    required BuildContext context,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 400,
          child: Image.asset(
            imgUrl,
          ),
        ),
        Expanded(
          child: SizedBox(
            width: 600,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 40,
              ),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge
                  ),
                  SizedBox(height: 60),
                  Text(
                    subTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
