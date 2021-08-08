import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../models/post_model.dart';
import '../dummydata.dart';

class PostCard extends StatefulWidget {
  final int index;
  final bool localMode;
  PostCard(this.index, this.localMode);
  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool favSelected = false;
  bool commentSelected = false;
  
  @override
  Widget build(BuildContext context) {
  Post postData = LOCAL_DATA[widget.index];
    if (!widget.localMode) {
      postData = GLOBAL_DATA[widget.index];
    }
    return Card(
      elevation: 8,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      NetworkImage(postData.profilePhoto),
                ),
              ),
              Container(
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      postData.postName,
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(postData.userName,
                        style: TextStyle(color: Colors.grey))
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert_outlined,
                  size: 30,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullImagePageRoute(
                          postData.postImage, widget.index)));
            },
            child: Image.network(
              postData.postImage,
              height: 240,
              fit: BoxFit.fill,
              width: double.infinity,
            ),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () => setState(() {
                        favSelected = !favSelected;
                        if (favSelected)
                          postData.likeNumber += 1;
                        if (!favSelected)
                          postData.likeNumber -= 1;
                      }),
                  icon: Icon(
                    favSelected
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: favSelected ? Colors.pink : Colors.black,
                  )),
              Text(postData.likeNumber.toString()),
              IconButton(
                  onPressed: () => setState(() {
                        commentSelected = !commentSelected;
                        if (commentSelected)
                          postData.commentNumber += 1;
                        if (!commentSelected)
                          postData.commentNumber -= 1;
                      }),
                  icon: Icon(
                    commentSelected ? Icons.comment : Icons.comment_outlined,
                    color: commentSelected ? Colors.blueGrey : Colors.black,
                  )),
              Text(postData.commentNumber.toString()),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Text(
                postData.caption,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        SizedBox(height: 15,)
        ],
      ),
    );
  }
}

class FullImagePageRoute extends StatelessWidget {
  final String imageDownloadUrl;
  final int index;
  FullImagePageRoute(this.imageDownloadUrl, this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LOCAL_DATA[index].postName),
      ),
      body: Container(
        child: PhotoView(
          backgroundDecoration: BoxDecoration(color: Colors.transparent),
          imageProvider: NetworkImage(imageDownloadUrl),
          heroAttributes: const PhotoViewHeroAttributes(
            tag: "someTag",
            transitionOnUserGestures: true,
          ),
        ),
      ),
    );
  }
}
