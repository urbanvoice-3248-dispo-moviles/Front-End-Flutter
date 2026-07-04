import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/vote_model.dart';

class VoteRemoteDataSource {
  final ApiClient _client;

  VoteRemoteDataSource(this._client);

  Future<VoteResponseDto> toggleVote(
      int reportId, String voteType, int userId) async {
    final response = await _client.post(
      ApiConstants.votes,
      data: VoteRequestDto(reportId: reportId, voteType: voteType).toJson(),
      headers: {'X-User-ID': userId.toString()},
    );
    return VoteResponseDto.fromJson(response.data);
  }

  Future<VoteResponseDto> getVotes(int reportId) async {
    final response =
        await _client.get('${ApiConstants.votes}/$reportId');
    return VoteResponseDto.fromJson(response.data);
  }
}
