import 'package:flutter/material.dart';
import 'weibo_homelist_page.dart';

class WeiBoFollowPage extends StatefulWidget {
  final String personId;

  const WeiBoFollowPage({Key key, this.personId}) : super(key: key);
  @override
  _WeiBoFollowPageState createState() => _WeiBoFollowPageState();
}

class _WeiBoFollowPageState extends State<WeiBoFollowPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.personId != null)
          Container(
            color: Colors.white,
            width: BoxConstraints.expand().maxWidth,
            alignment: Alignment.center,
            child: Text(widget.personId),
          ),
        Expanded(
          child: WeiBoHomeListPager(mCatId: "0"),
        ),
      ],
    );
  }
}
