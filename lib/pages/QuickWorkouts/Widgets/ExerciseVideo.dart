import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/pages/QuickWorkouts/pages/QuickWorkoutTypes.dart';
import 'package:fitness_app/pages/QuickWorkouts/Widgets/timeline.dart';
import 'package:fitness_app/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ExerciseScreen extends StatefulWidget {
  final String index;

  ExerciseScreen({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  VideoPlayerController? _videoPlayerController;
  final YoutubeExplode youtube = YoutubeExplode();
  bool _isLoading = true;
  DocumentSnapshot? workout;

  @override
  void initState() {
    super.initState();
    _getWorkoutAndInitializeVideo();
  }

  Future<void> getWorkout() async {
    try {
      workout = await FirebaseFirestore.instance
          .collection('quick_Workout')
          .doc('Core_Cusher')
          .get();
    } catch (e) {
      log("Some error occurred: $e");
      rethrow;
    }
  }

  Future<void> _getWorkoutAndInitializeVideo() async {
    await getWorkout(); // Fetch workout document first

    if (workout != null && workout!.data() != null) {
      Map<String, dynamic> data = workout!.data() as Map<String, dynamic>;
      String videoUrl = data[widget.index]['video_url'];

      log(videoUrl);
      try {
        var videoId = VideoId(videoUrl);
        var manifest = await youtube.videos.streamsClient.getManifest(videoId);

        if (manifest.videoOnly.isNotEmpty && manifest.audioOnly.isNotEmpty) {
          var videoStream = manifest.videoOnly.withHighestBitrate();
          log("Found video-only and audio-only streams.");

          _videoPlayerController =
              VideoPlayerController.network(videoStream.url.toString())
                ..initialize().then((_) {
                  setState(() {
                    _isLoading = false;
                  });
                  _videoPlayerController!.setLooping(true);
                  _videoPlayerController!.play();
                });
        } else {
          log("No available streams for this video.");
        }
      } catch (e) {
        log("Failed to fetch video streams: $e");
      }
    } else {
      log("Workout data or video URL not found.");
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    youtube.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading || !_isVideoControllerInitialized()
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF01FBE2)))
            : SafeArea(
                child: FutureBuilder(
                  future: getWorkout(),
                  builder: (context, snapshot) {
                    Map<String, dynamic> data =
                        workout!.data() as Map<String, dynamic>;

                    var val = data[widget.index];
                    return Padding(
                      padding: EdgeInsets.all(20.w),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.close_outlined,
                                  color: Colors.black45,
                                  size: 30,
                                )),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(10.w),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: AspectRatio(
                                    aspectRatio: _videoPlayerController!
                                        .value.aspectRatio,
                                    child: VideoPlayer(_videoPlayerController!),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              val['name'],
                              style: GoogleFonts.ubuntu(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              "${val['duration']} | ${val['level']} | ${val['calories']} Calories Burn",
                              style: GoogleFonts.ubuntu(
                                  color: const Color(0xFF08EBE2),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Text(
                              'Description :',
                              style: GoogleFonts.ubuntu(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              val['description'],
                              textAlign: TextAlign.start,
                              style: GoogleFonts.ubuntu(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            ListTile(
                              leading: Text(
                                'How To Do It',
                                style: GoogleFonts.ubuntu(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800),
                              ),
                              trailing: Text(
                                "${val['steps'].length.toString()} Steps",
                                style: GoogleFonts.ubuntu(
                                    color: Colors.black45,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            SizedBox(
                              height: 500.h,
                              child: ListView.builder(
                                itemCount: val['steps'].length,
                                itemBuilder: (context, index) {
                                  return TimeLineItems(
                                      isFirst: (index + 1) == 1 ? true : false,
                                      islast: (index + 1) == val['steps'].length
                                          ? true
                                          : false,
                                      title: val['steps']
                                          [(index + 1).toString()]['title'],
                                      title2: val['steps']
                                          [(index + 1).toString()]['actions']);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ));
  }

  bool _isVideoControllerInitialized() {
    return _videoPlayerController?.value.isInitialized ?? false;
  }
}
