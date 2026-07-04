import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/incident_category_model.dart';

class CategoryRemoteDataSource {
  final ApiClient _client;

  CategoryRemoteDataSource(this._client);

  Future<List<IncidentCategoryModel>> getAllCategories() async {
    final response = await _client.get(ApiConstants.categories);
    return (response.data as List)
        .map((e) => IncidentCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<IncidentCategoryModel> createCategory(
      CreateCategoryRequest request) async {
    final response =
        await _client.post(ApiConstants.categories, data: request.toJson());
    return IncidentCategoryModel.fromJson(response.data);
  }

  Future<IncidentCategoryModel> updateCategory(
      int id, Map<String, dynamic> data) async {
    final response =
        await _client.put('${ApiConstants.categories}/$id', data: data);
    return IncidentCategoryModel.fromJson(response.data);
  }

  Future<void> deleteCategory(int id) async {
    await _client.delete('${ApiConstants.categories}/$id');
  }
}
