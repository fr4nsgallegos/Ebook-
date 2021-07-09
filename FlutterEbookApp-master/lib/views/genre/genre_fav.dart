import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_ebook_app/components/body_builder.dart';
import 'package:flutter_ebook_app/components/book_list_item.dart';
import 'package:flutter_ebook_app/components/loading_widget.dart';
import 'package:flutter_ebook_app/models/category.dart';
import 'package:flutter_ebook_app/session/session_heper.dart';
import 'package:flutter_ebook_app/view_models/genre_provider.dart';
import 'package:provider/provider.dart';

class GenreFav extends StatefulWidget {
  final String title;
  final String url;

  GenreFav({
    Key key,
    @required this.title,
    @required this.url,
  }) : super(key: key);

  @override
  _GenreFavState createState() => _GenreFavState();
}

class _GenreFavState extends State<GenreFav> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<GenreProvider>(context, listen: false)
          .getFeed(widget.url),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, GenreProvider provider, Widget child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('${widget.title}'),
          ),
          body: _buildBody(provider),
        );
      },
    );
  }

  Widget _buildBody(GenreProvider provider) {
    return BodyBuilder(
      apiRequestStatus: provider.apiRequestStatus,
      child: _buildBodyList(provider),
      reload: () => provider.getFeed(widget.url),
    );
  }

  _buildBodyList(GenreProvider provider) {
    return ListView(
      controller: provider.controller,
      children: <Widget>[
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          shrinkWrap: true,
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            Entry entry = provider.items[index];
            SessionHelper().favoriteListPdf.add(entry);
            return Padding(
              padding: EdgeInsets.all(5.0),
              child: BookListItem(
                img: entry.link[1].href,
                title: entry.title.t,
                author: entry.author.name.t,
                desc: entry.summary.t,
                entry: entry,
              ),
            );
          },
        ),
        SizedBox(height: 10.0),
        provider.loadingMore
            ? Container(
                height: 80.0,
                child: _buildProgressIndicator(),
              )
            : SizedBox(),
      ],
    );
  }

  _buildProgressIndicator() {
    return LoadingWidget();
  }
}
