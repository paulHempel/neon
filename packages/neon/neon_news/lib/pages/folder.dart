part of '../neon_news.dart';

class NewsFolderPage extends StatelessWidget {
  const NewsFolderPage({
    required this.bloc,
    required this.folder,
    super.key,
  });

  final NewsBloc bloc;
  final NextcloudNewsFolder folder;

  @override
  Widget build(final BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(folder.name),
        ),
        body: NewsFolderView(
          bloc: bloc,
          folder: folder,
        ),
      );
}