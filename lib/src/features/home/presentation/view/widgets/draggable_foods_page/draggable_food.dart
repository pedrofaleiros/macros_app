import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ios_macros/src/features/home/domain/model/food_model.dart';
import 'package:ios_macros/src/features/home/presentation/view/widgets/draggable_foods_page/feedback.dart';
import 'package:ios_macros/src/features/home/presentation/view/widgets/foods_list_tile.dart';
import 'package:ios_macros/src/features/home/presentation/viewmodel/add_item_viewmodel.dart';
import 'package:ios_macros/src/features/home/presentation/viewmodel/meal_viewmodel.dart';
import 'package:provider/provider.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

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
    return KeyboardVisibilityBuilder(
      builder: (context, keyboardIsVisible) {
        return LongPressDraggable<FoodModel>(
          data: food,
          // dragAnchorStrategy: childDragAnchorStrategy,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          onDragStarted: () {
            FocusScope.of(context).unfocus();
          },
          onDragUpdate: (details) => handleDragUpdate(
            context,
            details,
            scrollController,
            keyboardIsVisible,
          ),
          feedback: FeedBack(food: food),
          child: Observer(builder: (_) {
            final addItemViewmodel = context.read<AddItemViewmodel>();
            return GestureDetector(
              onTap: () => addItemViewmodel.copy(food),
              behavior: HitTestBehavior.opaque,
              child: FoodListTile(
                amount: 100,
                food: food,
                selected: (addItemViewmodel.food != null) &&
                    (addItemViewmodel.food!.id == food.id),
              ),
            );
          }),
        );
      },
    );
  }

  void handleDragUpdate(
    BuildContext context,
    DragUpdateDetails details,
    ScrollController scrollController,
    bool keyboardIsVisible,
  ) {
    if (context.read<MealViewmodel>().meals.isEmpty || keyboardIsVisible) {
      return;
    }

    double scrollThreshold = 125.0;
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
