import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/crypto/crypto_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Coins'),
        centerTitle: true,
      ),
      body: BlocBuilder<CryptoBloc, CryptoState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Colors.grey.shade900,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: _buildBody(state),
          );
        },
      ),
    );
  }

  _buildBody(CryptoState state) {
    if (state is CryptoLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
        ),
      );
    } else if (state is CryptoLoaded) {
      return RefreshIndicator(
        color: Theme.of(context).accentColor,
        onRefresh: () async {
          context.bloc<CryptoBloc>().add(RefreshCoins());
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) =>
              _onScrollNotification(notification, state),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: state.coins.length,
            itemBuilder: (context, index) {
              final coin = state.coins[index];
              return ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${++index}',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                title: Text(
                  coin.fullName,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  coin.name,
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: Text(
                  '\$${coin.price.toStringAsFixed(4)}',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else if (state is CryptoError) {
      return Center(
        child: Text(
          'Error loading coins!\nPlease check your connection',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 18.0,
          ),
        ),
      );
    }
  }

  bool _onScrollNotification(
      ScrollNotification notification, CryptoLoaded state) {
    if (notification is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      context.bloc<CryptoBloc>().add(
            LoadMoreCoins(coins: state.coins),
          );
    }
    return false;
  }
}
