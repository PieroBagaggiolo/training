import 'package:dash/dash.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/ChairEditBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/DrinkBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/TableEditBloc.dart';

part 'provider.g.dart';

@BlocProvider.register(DrinkBloc)
@BlocProvider.register(TableEditBloc)
@BlocProvider.register(InviterBloc)
abstract class Provider {}
