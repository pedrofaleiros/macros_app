import 'package:flutter/cupertino.dart';
import 'package:ios_macros/src/features/home/domain/model/food_model.dart';
import 'package:ios_macros/src/features/home/presentation/view/widgets/draggable_foods_page/feedback.dart';
import 'package:ios_macros/src/features/home/presentation/view/widgets/foods_list_tile.dart';

class DraggableFood extends StatelessWidget {
  const DraggableFood({
    super.key,
    required this.food,
    required this.scrollController,
  });

  final FoodModel food;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<FoodModel>(
      data: food,
      // dragAnchorStrategy: childDragAnchorStrategy,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragUpdate: (details) => handleDragUpdate(
        context,
        details,
        scrollController,
      ),
      feedback: FeedBack(food: food),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: FoodListTile(food: food),
      ),
    );
  }

  void handleDragUpdate(
    BuildContext context,
    DragUpdateDetails details,
    ScrollController scrollController,
  ) {
    double scrollThreshold = 100.0;
    double speed = 5;

    if (details.globalPosition.dy <
        MediaQuery.of(context).size.height -
            (MediaQuery.of(context).size.height * 0.25)) return;

    //right
    if (details.globalPosition.dx >
        (MediaQuery.of(context).size.width - scrollThreshold)) {
      if (scrollController.position.pixels <
          scrollController.position.maxScrollExtent) {
        scrollController.jumpTo(scrollController.position.pixels + speed);
      }
    }

    //left
    if (details.globalPosition.dx < scrollThreshold) {
      if (scrollController.position.pixels >
          scrollController.position.minScrollExtent) {
        scrollController.jumpTo(scrollController.position.pixels - speed);
      }
    }
  }
}