import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';

import 'package:resmedia_already_at_the_table/logic/skeletons/Booking.dart';
import 'package:resmedia_already_at_the_table/model/UserModel.dart';

class BookingBloc extends BlocBase {
  @protected
  @override
  void dispose() {
    _bookingSkeleton.dispose();
    super.dispose();
  }

  final BookingSkeleton _bookingSkeleton;
  BookingBone get bookingBone => _bookingSkeleton;

  BookingBloc({@required UserModel user}) : this._bookingSkeleton = BookingSkeleton(user: user);
  static BookingBloc init(BookingBloc bloc) => BlocProvider.init(bloc);
  factory BookingBloc.of() => BlocProvider.of<BookingBloc>();
  static void close() => BlocProvider.dispose<BookingBloc>();
}
