import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  ThemeMode _themeMode = ThemeMode.light;
  Timer? _timer;
  int _rating = 0;
  bool _isRatingDialogVisible = false;
  bool _isRatingDialogEnabled = true;

  final List<String> _imagePaths = [
    'assets/image1.jpg', // Ensure these images are added to your assets
    'assets/image2.jpg',
  ];

  late PageController _pageController;
  int _currentPage = 0;

  void _showImagePreview(String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Image.asset(imagePath),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.3, // Adjust this to control the size of the image
    );

    // Start a timer to auto-scroll the images
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        if (_currentPage < _imagePaths.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });

    _startRatingTimer();
  }

  void _startRatingTimer() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (_isRatingDialogEnabled) {
        _showRatingDialog();
      }
    });
  }

  void _showRatingDialog() {
    if (_isRatingDialogVisible) return;

    _isRatingDialogVisible = true;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                  _isRatingDialogVisible = false;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < _rating ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 10),
            Text(
              'Rate this app',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ).then((_) {
      _isRatingDialogVisible = false;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
      // Optionally, show a user-friendly message
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _themeMode == ThemeMode.dark;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 60,
                  child: Center(
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              _buildMenuItem(
                icon: Icons.home,
                title: 'Home',
                onTap: () {
                  try {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage(title: 'Flutter Demo Home Page')),
                    );
                  } catch (e) {
                    print('Error navigating to Home: $e');
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Navigation Error'),
                        content: Text('An error occurred while trying to navigate to the Home page.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              _buildMenuItem(
                icon: Icons.table_chart,
                title: 'Excel Page',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ExcelPage()),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.settings,
                title: 'Settings',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Settings'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Enable Star Rating'),
                              Switch(
                                value: _isRatingDialogEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    _isRatingDialogEnabled = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  // Show profile card
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.purple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage('assets/profile.jpg'), // Ensure you have this image in your assets
                            ),
                            SizedBox(height: 10),
                            Text(
                              'John Doe',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Software Engineer',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Age: 30',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Mobile: +1234567890',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Close', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                      backgroundColor: Colors.transparent,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: Text('CV'),
                onTap: () {
                  // Navigate to the CVPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CVPage()),
                  );
                },
              ),
              Spacer(), // Pushes the "About" items to the bottom
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About this application'),
                onTap: () {
                  // Handle the about application action
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('About this application'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'This is a Flutter demo application.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Features:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('- Increment and decrement a counter with animations.'),
                            Text('- Toggle between light and dark themes.'),
                            Text('- Rate the app using a star rating dialog.'),
                            Text('- Navigate through different sections using a drawer menu.'),
                            Text('- View profile information with a gradient background.'),
                            Text('- Access external links like Instagram.'),
                            SizedBox(height: 10),
                            Text(
                              'Developer:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Developed by Ayush (IT4B.in)'),
                            Text('Contact: +917766866355'),
                            Text('Email: ayush@example.com'),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.book),
                title: Text('Documentation'),
                onTap: () {
                  // Handle the documentation action
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Documentation'),
                      content: Text('Documentation details go here.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Divider(), // Adds a divider before the developer info
              ListTile(
                leading: Icon(Icons.developer_mode),
                title: Text('Developed by Ayush (IT4B.in)'),
                onTap: () {
                  // Open Instagram link
                  _launchURL('https://www.instagram.com/ayushkssk');
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Dark Mode'),
                    Switch(
                      value: _themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        setState(() {
                          _themeMode = value ? ThemeMode.dark : ThemeMode.light;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: _themeMode == ThemeMode.dark ? Colors.green : null,
                    ),
              ),
              SizedBox(
                height: 200, // Adjust the height as needed
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _imagePaths.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _showImagePreview(_imagePaths[index]),
                      child: Image.asset(
                        _imagePaths[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: _incrementCounter,
                    tooltip: 'Increment',
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: _resetCounter,
                    tooltip: 'Zero',
                    child: const Icon(Icons.exposure_zero),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: _decrementCounter,
                    tooltip: 'Decrement',
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isRatingDialogEnabled = !_isRatingDialogEnabled;
            });
          },
          child: Icon(
            _isRatingDialogEnabled ? Icons.star : Icons.star_border,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({super.key});

  @override
  AnimatedCounterState createState() => AnimatedCounterState();
}

class AnimatedCounterState extends State<AnimatedCounter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _controller.forward(from: 0);
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/logo.png'),
        title: const Text('Animated Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + _animation.value * 0.5,
                  child: Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: _incrementCounter,
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _decrementCounter,
                  tooltip: 'Decrement',
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget errorWidgetBuilder(FlutterErrorDetails details) {
  return Center(
    child: Text(
      'Something went wrong!',
      style: TextStyle(color: Colors.red),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

void main() {
  runApp(MyApp());
}

class ExcelPage extends StatelessWidget {
  const ExcelPage({super.key});

  Future<void> _mergeCSVFiles(BuildContext context) async {
    // Pick multiple CSV files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      allowMultiple: true,
    );

    if (result != null) {
      // Prepare files for upload
      List<http.MultipartFile> files = [];
      for (var file in result.files) {
        files.add(await http.MultipartFile.fromPath('files', file.path!));
      }

      // Send files to the Flask server
      var request = http.MultipartRequest('POST', Uri.parse('http://127.0.0.1:5000/upload'));
      request.files.addAll(files);
      var response = await request.send();

      if (response.statusCode == 200) {
        // Handle successful merge and download
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CSV files merged successfully!')));
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to merge CSV files.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _mergeCSVFiles(context),
          child: const Text('Merge CSV Files'),
        ),
      ),
    );
  }
}

class CVPage extends StatelessWidget {
  const CVPage({super.key});

  @override
  Widget build(BuildContext context) {
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse('https://newcv24.onrender.com/'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('CV'),
        actions: <Widget>[
          NavigationControls(Future.value(controller)),
        ],
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture, {super.key});

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady = snapshot.connectionState == ConnectionState.done;
        final WebViewController? controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoBack()) {
                        await controller.goBack();
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoForward()) {
                        await controller.goForward();
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller!.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}

Widget _buildMenuItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: onTap,
  );
}
