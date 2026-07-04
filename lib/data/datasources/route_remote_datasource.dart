import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/route_assessment_model.dart';

class RouteRemoteDataSource {
  final ApiClient _client;

  RouteRemoteDataSource(this._client);

  Future<RouteAssessmentResponseDto> assessRoute(
      RouteAssessmentRequestDto request) async {
    final response = await _client.post(
      ApiConstants.routesAssess,
      data: request.toJson(),
    );
    return RouteAssessmentResponseDto.fromJson(response.data);
  }
}
