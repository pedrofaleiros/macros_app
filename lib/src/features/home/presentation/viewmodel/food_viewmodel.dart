import 'package:ios_macros/src/features/home/domain/model/food_model.dart';
import 'package:ios_macros/src/features/home/domain/usecase/food_usecase.dart';
import 'package:mobx/mobx.dart';
part 'food_viewmodel.g.dart';

class FoodViewmodel = _FoodViewmodelBase with _$FoodViewmodel;

abstract class _FoodViewmodelBase with Store {
  final FoodUsecase _usecase = FoodUsecase();

  @observable
  ObservableList<FoodModel> foods = <FoodModel>[].asObservable();

  @observable
  bool isLoading = false;

  @action
  Future<void> getFoods(String? token) async {
    isLoading = true;

    // await Future.delayed(const Duration(milliseconds: 300));

    try {
      final response = await _usecase.get(token);

      foods.clear();

      for (var element in response) {
        foods.add(element);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> getFoodsWithName(String? token, String? name) async {
    isLoading = true;

    // await Future.delayed(const Duration(milliseconds: 300));

    try {
      final response = await _usecase.getWithName(token, name);

      foods.clear();

      for (var element in response) {
        foods.add(element);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading = false;
    }
  }
}
