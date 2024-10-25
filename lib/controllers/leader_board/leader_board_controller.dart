import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:studyapp/controllers/auth_controller.dart';
import 'package:studyapp/firebase_ref/loading_status.dart';
import 'package:studyapp/firebase_ref/references.dart';
import 'package:studyapp/models/models.dart';
import 'package:studyapp/utils/logger.dart';

class LeaderBoardController extends GetxController {
  final leaderBoard = <LeaderBoardData>[].obs;
  final myScores = Rxn<LeaderBoardData>();
  final loadingStatus = LoadingStatus.completed.obs;

  void getAll(String paperId) async {
    loadingStatus.value = LoadingStatus.loading;
    try {
      final QuerySnapshot<Map<String, dynamic>> _leaderBoardSnapShot =
      await getleaderBoard(paperId: paperId)
          .orderBy("points", descending: true)
          .limit(50)
          .get();
      final allData = _leaderBoardSnapShot.docs
          .map((score) => LeaderBoardData.fromSnapShot(score))
          .toList();

      for (var data in allData) {
        final userSnapshot = await userFR.doc(data.userId).get();
        data.user = UserData.fromSnapShot(userSnapshot);
      }

      leaderBoard.assignAll(allData);
      loadingStatus.value = LoadingStatus.completed;
    } catch (e) {
      loadingStatus.value = LoadingStatus.error;
      AppLogger.e(e);
    }
  }

  void getMyScores(String paperId) async {
    final user = Get.find<AuthController>().getUser();

    if (user == null) {
      return; // User is not logged in, so return early
    }

    try {
      final DocumentSnapshot<Map<String, dynamic>> _leaderBoardSnapShot = await getleaderBoard(paperId: paperId).doc(user.email).get();

      // Check if the document exists before trying to read its data
      if (_leaderBoardSnapShot.exists) {
        final _myScores = LeaderBoardData.fromSnapShot(_leaderBoardSnapShot);
        _myScores.user = UserData(
          name: user.displayName ?? 'Unknown', // Use a default value if displayName is null
          image: user.photoURL,
        );
        myScores.value = _myScores;
      } else {
        // Handle the case where the document doesn't exist
        AppLogger.e("Document does not exist for user: ${user.email}");
        myScores.value = null; // Optionally reset myScores to null or a default value
      }
    } catch (e) {
      AppLogger.e("Error fetching user scores: $e");
    }
  }

}