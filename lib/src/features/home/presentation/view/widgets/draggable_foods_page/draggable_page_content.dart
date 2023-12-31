import 'package:flutter/cupertino.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ios_macros/src/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:ios_macros/src/features/home/presentation/view/pages/create_meal_page.dart';
import 'package:ios_macros/src/features/home/presentation/view/widgets/draggable_foods_page/draggable_food.dart';
import 'package:ios_macros/src/features/home/presentation/view/widgets/letter_label.dart';
import 'package:ios_macros/src/features/home/presentation/view/widgets/draggable_foods_page/meals_target_list.dart';
import 'package:ios_macros/src/features/home/presentation/viewmodel/food_viewmodel.dart';
import 'package:ios_macros/src/features/home/presentation/viewmodel/meal_viewmodel.dart';
import 'package:provider/provider.dart';

class DraggablePageContent extends StatefulWidget {
  const DraggablePageContent({
    super.key,
  });

  @override
  State<DraggablePageContent> createState() => _DraggablePageContentState();
}

class _DraggablePageContentState extends State<DraggablePageContent> {
  TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final FocusNode searchFocus = FocusNode();

  Widget _searchFoodTextField(
      FoodViewmodel foodsController, String token, FocusNode focus) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CupertinoSearchTextField(
        placeholder: 'Buscar alimentos',
        focusNode: focus,
        controller: textController,
        onChanged: (value) async => await foodsController.getFoodsWithName(
          token,
          textController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isVisible) {
        return Observer(
          builder: (context) {
            final token = context.read<AuthViewmodel>().sessionUser!.token;
            final foodsController = context.read<FoodViewmodel>();
            final mealsController = context.read<MealViewmodel>();

            return Column(
              children: [
                _searchFoodTextField(foodsController, token, searchFocus),
                Expanded(
                  child: ListView.builder(
                    itemCount: foodsController.foods.length,
                    itemBuilder: (context, index) {
                      final food = foodsController.foods[index];

                      return Column(
                        children: [
                          if (_showLabel(index, foodsController))
                            LetterLabel(
                              text: food.name[0],
                            ),
                          DraggableFood(
                            scrollController: scrollController,
                            food: food,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (!isVisible)
                  mealsController.meals.isEmpty
                      ? CupertinoButton(
                          onPressed: () => Navigator.pushNamed(
                              context, CreateMealPage.routeName),
                          child: const Text('Adicionar refeicao'),
                        )
                      : MealsTargetList(scrollController: scrollController),
                if (!isVisible)
                  CupertinoButton(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.search),
                        SizedBox(width: 8),
                        Text('Buscar'),
                      ],
                    ),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(searchFocus);
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }

  bool _showLabel(int index, FoodViewmodel foodsController) {
    return index == 0 ||
        foodsController.foods[index].name[0].toUpperCase() !=
            foodsController.foods[index - 1].name[0].toUpperCase();
  }
}
