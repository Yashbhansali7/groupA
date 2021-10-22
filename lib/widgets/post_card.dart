

import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final int index;
  final jsonResponse;
  PostCard(this.index, this.jsonResponse);
  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool favSelected = false;
  bool commentSelected = false;
  

  @override
  Widget build(BuildContext context) {
    
  var json= widget.jsonResponse['contents'][widget.index];
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
                  backgroundImage: NetworkImage(json['message']['user']['userProfiles'][0]['image'].toString()),
                ),
              ),
              Container(
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Post Title Here',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(json['message']['user']['name'],
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
            },
            child: Image.network(
              json['message']['attachment'],
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
                        if (favSelected) json['likeCount'] += 1;
                        if (!favSelected) json['likeCount'] -= 1;
                      }),
                  icon: Icon(
                    favSelected
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: favSelected ? Colors.pink : Colors.black,
                  )),
              Text(json['likeCount'].toString()),
              IconButton(
                  onPressed: () => setState(() {
                        commentSelected = !commentSelected;
                        if (commentSelected) json['commentCount'] += 1;
                        if (!commentSelected) json['commentCount'] -= 1;
                      }),
                  icon: Icon(
                    commentSelected ? Icons.comment : Icons.comment_outlined,
                    color: commentSelected ? Colors.blueGrey : Colors.black,
                  )),
              Text(json['commentCount'].toString()),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Container(
                width: 335,
                child: Text(
                  json['message']['body'],
                  softWrap: true,
                  maxLines: 4,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}

