import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/interface/screen/check_order.dart';
import 'package:resmedia_already_at_the_table/interface/widget/BottonBarButton.dart';
import 'package:resmedia_already_at_the_table/interface/widget/Menu.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/ChairBloc.dart';
import 'package:resmedia_already_at_the_table/model/menu_model.dart';

class CartScreen extends StatefulWidget {
  static const ROUTE = "CartScreen";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with SubscribeStateMixin {
  final _chairBloc = ChairBloc.of();

  @override
  void initState() {
    super.initState();
    subscribe = _chairBloc.outCountProducts.listen((count) {
      if (count == 0) PocketRouter()..popBeforeMe(context, CartScreen.ROUTE);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Carello"),
      ),
      body: ObservableBuilder<List<MenuModel>>(
        builder: (context, menus, state) {
          if (menus == null) return state.toWidget();

          return BoneProvider(
            bone: _chairBloc.foodBone,
            child: CustomScrollView(
              slivers: Menu.toList(menus: menus),
            ),
          );
        },
        stream: _chairBloc.foodBone.outMenus,
      ),
      bottomNavigationBar: StreamBuilder<int>(
          stream: _chairBloc.outCountProducts,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == 0) return const SizedBox();

            return BottomBarButton(
              onPressed: () => PocketRouter().push(context, CheckOrderScreen.ROUTE),
              child: Text("Procedi al Pagamento"),
            );
          }),
    );
  }
}

class MenuTree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
