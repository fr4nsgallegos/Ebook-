// import 'package:flutter/material.dart';
// import 'package:flutter_ebook_app/pdf/pds_generate.dart';

// class PdfPage extends StatefulWidget {
//   @override
//   _PdfPageState createState() => _PdfPageState();
// }

// class _PdfPageState extends State<PdfPage> {
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//         ),
//         body: Container(
//           padding: EdgeInsets.all(32),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 ButtonWidget(
//                   text: 'Table PDF',
//                   onClicked: () async {
//                     final pdfFile = await PdfApi.generateTable();

//                     PdfApi.openFile(pdfFile);
//                   },
//                 ),
//                 const SizedBox(height: 24),
//                 ButtonWidget(
//                   text: 'Image PDF',
//                   onClicked: () async {
//                     final pdfFile = await PdfApi.generateImage();

//                     PdfApi.openFile(pdfFile);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
// }

// class ButtonWidget extends StatelessWidget {
//   final String text;
//   final VoidCallback onClicked;

//   const ButtonWidget({
//     Key key,
//     this.text,
//     this.onClicked,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) => ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           minimumSize: Size.fromHeight(40),
//         ),
//         child: FittedBox(
//           child: Text(
//             text,
//             style: TextStyle(fontSize: 20, color: Colors.white),
//           ),
//         ),
//         onPressed: onClicked,
//       );
// }
