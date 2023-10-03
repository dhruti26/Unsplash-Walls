import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

// var file = await DefaultCacheManager().getSingleFile(url);
class FullScreen extends StatelessWidget {
  String imgUrl;
  FullScreen({super.key, required this.imgUrl});
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // Future<void> setWallpaperFromFile(
  //     String wallpaperUrl, BuildContext context) async {
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text("Downloading Started...")));
  //   try {
  //     // Saved with this method.
  //     var imageId = await ImageDownloader.downloadImage(wallpaperUrl);
  //     if (imageId == null) {
  //       return;
  //     }
  //     // Below is a method of obtaining saved image information.
  //     var fileName = await ImageDownloader.findName(imageId);
  //     var path = await ImageDownloader.findPath(imageId);
  //     var size = await ImageDownloader.findByteSize(imageId);
  //     var mimeType = await ImageDownloader.findMimeType(imageId);
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("Downloaded Sucessfully"),
  //       action: SnackBarAction(
  //           label: "Open",
  //           onPressed: () {
  //             OpenFile.open(path!);
  //           }),
  //     ));
  //     print("IMAGE DOWNLOADED");
  //   } on PlatformException catch (error) {
  //     print(error);
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text("Error Occured - $error")));
  //   }
  // }


  Future<void> setWallpaperFromFile(String wallpaperUrl, BuildContext context) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Downloading Started...")));
    try {

      final directory = await getExternalStorageDirectory();
      final savedDir = directory!.path;

      final taskId = await FlutterDownloader.enqueue(
        url: wallpaperUrl,
        savedDir: savedDir,
        fileName: 'image.png', // Specify the desired file name.
        showNotification: true, // Show a notification during download.
        openFileFromNotification: true, // Open the downloaded file when the notification is tapped.
      );

      FlutterDownloader.registerCallback((id, status, progress) async {
        if (status == DownloadTaskStatus.complete) {
          // Download is complete.
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Downloaded Successfully"),
            action: SnackBarAction(
              label: "Open",
              onPressed: () async {
                final filePath = await FlutterDownloader.open(taskId: taskId ?? '');
                if (filePath != null) {
                  // Set wallpaper from the downloaded file.
                  final result = await WallpaperManager.setWallpaperFromFile(
                    filePath as String,
                    WallpaperManager.LOCK_SCREEN, // Use WallpaperManager.LOCK_SCREEN for lock screen.
                  );
                  if (result) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Wallpaper set successfully."),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Failed to set wallpaper."),
                    ));
                  }
                }
              },
            ),
          ));
        } else if (status == DownloadTaskStatus.failed) {
          // Download failed. You can handle this case as needed.
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Download Failed"),
          ));
        }
      });
    } on PlatformException catch (error) {
      print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error Occurred - $error")));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: ElevatedButton(
          onPressed: () async {
            await setWallpaperFromFile(imgUrl, context);
          },
          child: Text("Set Wallpaper")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imgUrl), fit: BoxFit.cover)),
      ),
    );
  }
}
