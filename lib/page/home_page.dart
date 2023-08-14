import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import '../widgets/location_card.dart';
import '../widgets/nearby_places.dart';
import '../widgets/recommended_places.dart';
import '../widgets/tourist_places.dart';
import 'calendar.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentIndex = 0;
  String _ethiopianCalendar = '';
  double _currencyExchangeRate = 0.0;
  TextEditingController _amountController = TextEditingController();
  String _conversionResult = '';
  bool _showResult = false;

  List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY', 'ETB', 'AED'];
  String _selectedCurrency1 = 'USD';
  String _selectedCurrency2 = 'EUR';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBottomNavTapped(int index) {
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      return;
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CalendarPage()),
      );
      return;
    }
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }


  Future<String> getEthiopianCalendar() async {
    try {
      var response = await http
          .get(Uri.parse('https://api.example.com/ethiopian_calendar'));
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      print('Error: $e');
    }
    return '';
  }

  Future<double> getCurrencyExchangeRate(
      String baseCurrency, String targetCurrency) async {
    try {
      var response = await http.get(Uri.parse(
          'https://v6.exchangerate-api.com/v6/8d25bfc44af7129f4a5d9951/latest/$baseCurrency'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        double exchangeRate = data['conversion_rates'][targetCurrency];

        return exchangeRate;
      }
    } catch (e) {
      print('Error: $e');
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Center(
          child: Text("Tour Application"),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          // Page 1: Home Page
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(14),
            children: [
              // LOCATION CARD
              const SizedBox(height: 15),
              const TouristPlaces(),
              // CATEGORIES
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommendation",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const RecommendedPlaces(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Places",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // places
              const NearbyPlaces(),
            ],
          ),

          // Page 2: Calendar Page
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Calendar',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  getEthiopianCalendar().then((result) {
                    setState(() {
                      _ethiopianCalendar = result;
                    });
                  });
                },
                child: const Text('Get Calendar'),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: CalendarCarousel(
                  selectedDateTime: DateTime.now(),
                  showHeader: false,
                  todayButtonColor: Colors.transparent,
                  todayBorderColor: Colors.transparent,
                  markedDatesMap: null, // Add marked dates if needed
                  onDayPressed: (DateTime date, List<dynamic> events) {
                    // Handle day press event if needed
                  },
                ),
              ),
            ],
          ),

          // Page 3: Currency Page
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Currency Exchange',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  getCurrencyExchangeRate(
                          _selectedCurrency1, _selectedCurrency2)
                      .then((result) {
                    setState(() {
                      _currencyExchangeRate = result;
                    });
                  });
                },
                child: const Text('Get Exchange Rate'),
              ),
              const SizedBox(height: 10),
              const Text('Enter amount:'),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  double amount =
                      double.tryParse(_amountController.text) ?? 0.0;
                  double result = amount * _currencyExchangeRate;
                  setState(() {
                    _conversionResult =
                        '$amount $_selectedCurrency1 = $result $_selectedCurrency2';
                    _showResult = true;
                  });
                },
                child: const Text('Convert'),
              ),
              if (_showResult)
                Text(
                  _conversionResult,
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: _selectedCurrency1,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCurrency1 = newValue!;
                      });
                    },
                    items: _currencies.map((currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/places/place1.jpg',
                              height: 20,
                              width: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(currency),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      String temp = _selectedCurrency1;
                      setState(() {
                        _selectedCurrency1 = _selectedCurrency2;
                        _selectedCurrency2 = temp;
                      });
                    },
                    icon: const Icon(Icons.swap_horiz),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedCurrency2,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCurrency2 = newValue!;
                      });
                    },
                    items: _currencies.map((currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/places/place1.jpg',
                              height: 20,
                              width: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(currency),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
          
          // Page 4: Login Page
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginPage()
            ]
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _currentIndex,
          onTap: _onBottomNavTapped, // Update this line
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Ionicons.home_outline),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.calendar),
              label: "Calendar",
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.cash_outline),
              label: "Currency",
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.person_outline),
              label: "Profile",
            ),
          ],
        )
    );
  }
}
