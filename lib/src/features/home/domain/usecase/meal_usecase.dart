import 'package:ios_macros/src/features/home/data/dto/item_dto.dart';
import 'package:ios_macros/src/features/home/data/repository/create_item_repository.dart';
import 'package:ios_macros/src/features/home/data/repository/delete_item_repository.dart';
import 'package:ios_macros/src/features/home/data/repository/get_meals_repository.dart';
import 'package:ios_macros/src/features/home/domain/model/item_model.dart';
import 'package:ios_macros/src/features/home/domain/model/meal_model.dart';

class MealUsecase {
  Future<List<MealModel>> get(String? token) async {
    if (token == null) {
      throw InvalidTokenException();
    }

    final repo = GetMealsRepository();

    final response = await repo.execute(token: token);

    return response;
  }

  Future<MealModel> create(String? token) async {
    throw Exception();
  }

  Future<void> deleteMeal() async {}
  Future<ItemModel> createItem(
    String? token,
    ItemDTO item,
  ) async {
    if (token == null) {
      throw InvalidTokenException();
    }

    final repo = CreateItemRepository();

    final response = await repo.execute(
      token: token,
      body: item.toMap(),
    );

    return response;
  }

  Future<void> deleteItem(String? token, String itemId) async {
    if (token == null) {
      throw InvalidTokenException();
    }

    final repo = DeleteItemRepository();

    await repo.execute(
      token: token,
      queryParams: {
        "item_id": itemId,
      },
    );
  }
}

class InvalidTokenException implements Exception {
  final String? message;

  InvalidTokenException({this.message});

  @override
  String toString() => message ?? 'token null';
}
