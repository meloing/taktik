import 'club_api.dart';
import 'course_api.dart';
import 'articles_api.dart';
import 'competition_api.dart';
import 'package:totale_reussite/services/quiz_api.dart';
import 'package:totale_reussite/services/topics_api.dart';
import 'package:totale_reussite/services/product_api.dart';
import 'package:totale_reussite/services/point_method_api.dart';

class ManageDatabase {

}

class LocalDatabase {
  Future<void> createAllTable() async{
    await ClubOfflineRequests().createClubsTable();
    await QuizOfflineRequests().createQuizzTable();
    await TopicOfflineRequests().createTopicsTable();
    await CourseOfflineRequests().createCoursesTable();
    await CourseOfflineRequests().createSubjectsTable();
    await ArticlesOfflineRequests().createArticleTable();
    await ProductOfflineRequests().createProductsTable();
    await CompetitionOfflineRequests().createCompetitionTable();
    await PointMethodOfflineRequests().createPointMethodsTable();
  }
}