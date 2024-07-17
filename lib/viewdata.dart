// import 'package:flutter/material.dart';
// import 'db_helper.dart';

// class DataDisplayScreen extends StatelessWidget {
//   final DBHelper dbHelper = DBHelper();

//   // Future<List<Map<String, dynamic>>> _getData() async {
//   //   //return await dbHelper.fetchData();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Data Display'),
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _getData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No data found'));
//           } else {
//             final data = snapshot.data!;
//             return ListView.builder(
//               itemCount: data.length,
//               itemBuilder: (context, index) {
//                 final row = data[index];
//                 return ListTile(
//                   title: Text('Row ${row['id']}'),
//                   subtitle: Text(
//                       'Column1: ${row['column1']}, Column2: ${row['column2']}, Column3: ${row['column3']}'),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
