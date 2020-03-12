import 'package:share/share.dart';

Future<void> share({String title, String subject}) async {
  return Share.share(
      title == null
          ? "Hey I've found this app very useful where you can take daily coding challenges and can also learn coding concepts which would really help you in taking coding interviews.\nDownload Daily Coding Challenges app from Google Play \nhttps://play.google.com/store/apps/details?id=com.vktech.daily_coding_challenges "
          : title + subject + "\n\nDownload Daily Coding Challenges, Concepts & Articles App from Google Play:\nhttps://play.google.com/store/apps/details?id=com.vktech.daily_coding_challenges",
      subject: "\nDownload Daily Coding Challenges, Concepts & Articles App from Google Play");
}
