import 'package:share/share.dart';

Future<void> share() async {
  return Share.share(
      "Hey I've found this app very useful where you can take daily coding challenges and can also learn coding concepts which would really help you in taking coding interviews.\nDownload Daily Coding Challenges app from Google Play \nhttps://play.google.com/store/apps/details?id=com.vktech.daily_coding_challenges",
      subject: "Download Daily Coding Challenges App from Google Play");
}
