import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clew_app/core/ui/app_color.dart';
import 'package:flutter/material.dart';

class PhotoCarousel extends StatefulWidget {
  final double height;
  final double maxHeight;
  final double imageExpansionHeight;
  final List<String> urls;

  static const Duration autoplayInterval = Duration(milliseconds: 5000);
  static const Duration autoplayDuration = Duration(milliseconds: 500);
  static const Duration zooomDuration = Duration(milliseconds: 6000);

  const PhotoCarousel({
    Key? key,
    required this.urls,
    required this.height,
    required this.maxHeight,
    required this.imageExpansionHeight,
  }) : super(key: key);

  @override
  _PhotoCarouselState createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel>
    with SingleTickerProviderStateMixin {
  int _activeIndex = 0;
  Timer? _scrollTimer;

  late PageController _pageController;
  late AnimationController _animationController;

  int getIndex(int index) => (index + widget.urls.length) % widget.urls.length;

  @override
  void initState() {
    super.initState();
    _activeIndex = 0;

    _animationController = AnimationController(
      vsync: this,
      duration: PhotoCarousel.zooomDuration,
      lowerBound: 1,
      upperBound: 1.15,
    );

    _pageController = PageController(
      initialPage: _activeIndex,
      keepPage: false,
    );

    if (widget.urls.length > 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _resetAndStartTimer();
      });
    }
  }

  _resetAndStartTimer() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(PhotoCarousel.autoplayInterval, (timer) {
      if (mounted) {
        _pageController.nextPage(
          duration: PhotoCarousel.autoplayDuration,
          curve: Curves.easeIn,
        );
      }
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.black,
          child: PageView.builder(
            controller: _pageController,
            physics: widget.urls.length > 1
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => widget.urls.isNotEmpty
                ? ScaleTransition(
                    scale: _animationController,
                    child: DecoratedBox(
                      position: DecorationPosition.foreground,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(1 -
                                (widget.maxHeight - widget.height) /
                                    (widget.imageExpansionHeight -
                                        kToolbarHeight)),
                            Colors.black.withOpacity(1 -
                                0.4 *
                                    (widget.maxHeight - widget.height) /
                                    (widget.imageExpansionHeight -
                                        kToolbarHeight)),
                          ],
                          stops: const [0, 1],
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.urls[getIndex(index)],
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(),
                        errorWidget: (context, url, error) => Container(),
                      ),
                    ),
                  )
                : Container(),
            onPageChanged: (int index) {
              if (mounted) {
                setState(() {
                  _activeIndex = index;
                });
              }
              _resetAndStartTimer();
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < widget.urls.length; i++)
                Opacity(
                  opacity: (widget.maxHeight - widget.height) /
                      (widget.imageExpansionHeight - kToolbarHeight),
                  child: Container(
                    key: ValueKey<int>(i),
                    width: i == getIndex(_activeIndex) ? 48 / 8 : 48 / 12,
                    height: i == getIndex(_activeIndex) ? 48 / 8 : 48 / 12,
                    margin: EdgeInsets.symmetric(vertical: 16) +
                        EdgeInsets.symmetric(horizontal: 16 * 0.25),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == getIndex(_activeIndex)
                          ? Color(0xB72B7A)
                          : AppColor.mainColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
