import 'dart:io';

import 'package:flutter/material.dart';
import 'package:random_recipe_app/models/recipe.dart';

class ThumbnailCard extends StatefulWidget {
  const ThumbnailCard({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<ThumbnailCard> createState() => _ThumbnailCardState();
}

class _ThumbnailCardState extends State<ThumbnailCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tweenAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _tweenAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 25, end: 40), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 40, end: 25), weight: 1),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 10),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 240,
            child: widget.recipe.thumbnailPath.isEmpty
                ? Image.asset(
                    'assets/thumbnails/dummy_thumbnail.png',
                    width: double.infinity,
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.center,
                  )
                : Image.file(File(widget.recipe.thumbnailPath)),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _tweenAnimation,
              builder: (context, child) {
                return IconButton(
                  onPressed: () {
                    _controller.reset();
                    _controller.forward();
                    setState(() {
                      widget.recipe.toggleIsFav();
                    });
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: widget.recipe.isFav ? Colors.red : Colors.grey[400],
                    size: _tweenAnimation.value,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
