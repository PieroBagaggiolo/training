import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/interface/page/booking_page.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/BookingBloc.dart';

class BookingScreen extends StatefulWidget {
  static const String ROUTE = "BookingScreen";

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _bookingBloc = BookingBloc.of();

  @override
  void dispose() {
    BookingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Prenotazioni"),
      ),
      body: BoneProvider(
        bone: _bookingBloc.bookingBone,
        child: BookingPage(),
      ),
    );
  }
}
