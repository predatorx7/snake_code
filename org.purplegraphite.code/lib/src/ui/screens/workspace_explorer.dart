// import 'dart:io';

// import 'package:code/src/common/routing_const.dart';
// import 'package:code/src/models/plain_model/entity.dart';
// import 'package:code/src/models/view_model/browser_controller.dart';
// import 'package:code/src/ui/components/newfolder_dialog.dart';
// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:path/path.dart' as path;
// import 'package:provider/provider.dart';

// /// Local files & directories browser
// class WorkspaceExplorerScreen extends StatefulWidget {
//   const WorkspaceExplorerScreen({Key key}) : super(key: key);
//   @override
//   _WorkspaceExplorerScreenState createState() =>
//       _WorkspaceExplorerScreenState();
// }

// class _WorkspaceExplorerScreenState extends State<WorkspaceExplorerScreen> {
//   BrowserController _view;
//   final String _createNewHero = 'createNewHero';
//   Directory dir;
//   @override
//   void initState() {
//     super.initState();
//     dir = Provider.of<EditorController>(context, listen: false).workspace ??
//         Directory.systemTemp;
//     Provider.of<BrowserController>(context, listen: false).setCurrent(dir);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   void didChangeDependencies() {
//     _view = Provider.of<BrowserController>(context);
//     super.didChangeDependencies();
//   }

//   Icon getFileTypeIcon(Entity object) {
//     FileStat stat = object?.stat;
//     IconData data;
//     Color color;
//     switch (stat?.type) {
//       case FileSystemEntityType.directory:
//         data = EvaIcons.folder;
//         color = Theme.of(context).accentColor;
//         break;
//       case FileSystemEntityType.file:
//         data = EvaIcons.fileOutline;
//         color = Colors.grey;
//         break;
//       default:
//         data = EvaIcons.alertCircleOutline;
//     }
//     if (object?.basename[0] == '.') {
//       // File represents a hidden entity
//       color = color.withAlpha(0xbb);
//     }
//     return Icon(data, color: color);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           path.basename(dir?.path ?? ''),
//         ),
//       ),
//       body: Visibility(
//         visible: _view.currentEntities?.isNotEmpty ?? false,
//         child: ListView.builder(
//           key: ValueKey(_view.current.path),
//           itemCount: _view.currentEntities.length,
//           itemBuilder: (BuildContext context, int index) {
//             Entity object = _view.currentEntities[index];
//             Widget child = ListTile(
//               key: ValueKey(object.id),
//               onTap: () {
//                 if (object.entity is Directory) {
//                   var x = Directory.fromUri(
//                     Uri(path: object.absolutePath),
//                   );
//                   Navigator.pushNamed(context, BrowserScreenRoute,
//                       arguments: x);
//                 }
//               },
//               leading: getFileTypeIcon(object),
//               title: Text(object.basename),
//               trailing: Visibility(
//                 visible:
//                     _view.recentlyCreatedFolder.contains(object.absolutePath),
//                 child: Icon(
//                   Icons.fiber_new,
//                   color: Colors.red,
//                   size: 28,
//                 ),
//               ),
//             );
//             if (_view.recentlyCreatedFolder.contains(object.absolutePath)) {
//               child = Container(
//                 color: Theme.of(context).primaryColor.withAlpha(0x22),
//                 child: child,
//               );
//             }
//             return child;
//           },
//         ),
//         replacement: Visibility(
//           visible: !_view.stopLoading,
//           child: Center(
//             child: CircularProgressIndicator(),
//           ),
//           replacement: Builder(
//             builder: (context) {
//               Color _itemColor = Theme.of(context).accentColor.withAlpha(0xCC);
//               Widget warning = Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Icon(
//                     EvaIcons.infoOutline,
//                     color: _itemColor,
//                   ),
//                   SizedBox(width: 10),
//                   Text(
//                     'There\'s nothing here',
//                     style: TextStyle(
//                       color: _itemColor,
//                       fontSize: 18,
//                     ),
//                   ),
//                 ],
//               );
//               return Center(child: warning);
//             },
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           print('Create file');
//           newFolderDialog(context, (textController) {
//             _view.createFolderAndAddToRecent(context, textController.text);
//           });
//         },
//         heroTag: _createNewHero,
//         icon: Icon(
//           EvaIcons.folderAddOutline,
//         ),
//         label: Text('Create folder'),
//       ),
//     );
//   }
// }
