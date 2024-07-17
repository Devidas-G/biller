import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di.dart' as di;
import 'features/bill/providers/bill_provider.dart';
import 'providers/homeprovider.dart';
import 'views/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BillProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey.shade300,
          primaryColor: Colors.deepPurpleAccent.shade700,
          listTileTheme: ListTileThemeData(
            contentPadding: const EdgeInsets.only(left: 5, right: 5),
            tileColor: Colors.white, // Set your desired background color here
            selectedTileColor:
                Colors.blue[100], // Optional: color when the tile is selected
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 5, bottom: 5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.deepPurpleAccent.shade700,
                  foregroundColor: Colors.white)),
        ),
        home: const Homepage(),
      ),
    );
  }
}
