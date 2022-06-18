import 'package:clew_app/core/ui/app_color.dart';
import 'package:clew_app/features/events/data/repository/transaction_repository.dart';
import 'package:clew_app/features/events/presentation/bloc/transaction_bloc/bloc/transaction_bloc.dart';
import 'package:clew_app/features/events/presentation/widgets/hours_page.dart';
import 'package:clew_app/features/events/presentation/widgets/photo_carusel.dart';
import 'package:clew_app/features/events/presentation/widgets/street_page.dart';
import 'package:clew_app/features/user/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecificEventPage extends StatefulWidget {
  SpecificEventPage(
      {required this.imgUrl,
      required this.title,
      required this.time,
      required this.date,
      required this.desciption,
      required this.spendPoints,
      this.index,
      this.identify = 1,
      Key? key})
      : super(key: key);
  String imgUrl;
  String title;
  String time;
  String date;
  String desciption;
  int spendPoints;
  int? index;
  int identify;

  @override
  State<SpecificEventPage> createState() => _SpecificEventPageState();
}

class _SpecificEventPageState extends State<SpecificEventPage> {
  late final String _imgUrl;
  late final String _title;
  late final String _time;
  late final String _date;
  late final String _desciption;
  late final int _spendPoints;
  late final int _index;
  late final int _identify;

  @override
  void initState() {
    _imgUrl = widget.imgUrl;
    _title = widget.title;
    _time = widget.time;
    _date = widget.date;
    _desciption = widget.desciption;
    _spendPoints = widget.spendPoints;
    _index = widget.index ?? 0;
    _identify = widget.identify;

    super.initState();
  }

  static const double imageExpandedHeight = 473;
  @override
  Widget build(BuildContext context) {
    return _buildUI(_desciption, _spendPoints, _index, _identify);
  }

  _buildUI(String description, int spendPoints, int index, int identify) {
    return Scaffold(
      backgroundColor: AppColor.mainColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: _buildExtraInfo(description, spendPoints, index, identify),
            )
          ],
        ),
      ),
    );
  }

  _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      leadingWidth: 56,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.close,
                size: 24,
                color: AppColor.mainColor,
              ),
            ),
          ),
        ),
      ),
      primary: true,
      pinned: true,
      expandedHeight: imageExpandedHeight,
      actions: const [
        Padding(
          padding: EdgeInsets.only(
            right: 10,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(Icons.favorite),
          ),
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (context, size) {
          double height = kToolbarHeight + MediaQuery.of(context).padding.top;
          return Stack(
            children: [
              Positioned.fill(
                child: Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12 *
                            2 *
                            (size.maxHeight - height) /
                            (imageExpandedHeight - kToolbarHeight)),
                        bottomRight: Radius.circular(
                          12 *
                              2 *
                              (size.maxHeight - height) /
                              (imageExpandedHeight - kToolbarHeight),
                        )),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: PhotoCarousel(
                      height: height,
                      maxHeight: size.maxHeight,
                      imageExpansionHeight: imageExpandedHeight,
                      urls: [
                        _imgUrl,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Opacity(
                    opacity: (size.maxHeight - height) /
                        (imageExpandedHeight - kToolbarHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HoursBadge(),
                        SizedBox(width: 16 * 0.25),
                        Text(
                          _title,
                          style: const TextStyle(
                            fontSize: 28,
                            height: 34 / 28,
                            color: AppColor.mainColor,
                          ),
                        ),
                        const SizedBox(width: 16 * 0.25),
                        StreetBadge(
                          street: '29-й км Новорижского ш.',
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _buildExtraInfo(
      String description, int spendPoints, int index, int identify) {
    return RepositoryProvider(
      create: (context) => TransactionRepository(),
      child: RepositoryProvider(
        create: (context) => UserRepository(),
        child: BlocProvider(
          create: (context) => TransactionBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
            transactionRepository:
                RepositoryProvider.of<TransactionRepository>(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              _buildDescription(description),
              SizedBox(height: 16),
              _buildMap(),
              identify == 0 ? Container() : _buildButton(spendPoints, index),
            ],
          ),
        ),
      ),
    );
  }

  _buildDescription(String description) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        description,
        style: const TextStyle(
          fontSize: 16,
          height: 20 / 16,
          color: Colors.black,
        ),
      ),
    );
  }

  _buildButton(int spendPoints, int index) {
    return RepositoryProvider(
      create: (context) => TransactionRepository(),
      child: RepositoryProvider(
        create: (context) => UserRepository(),
        child: BlocProvider(
          create: (context) => TransactionBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
            transactionRepository:
                RepositoryProvider.of<TransactionRepository>(context),
          ),
          child: Container(
            width: double.infinity,
            height: 90,
            padding: const EdgeInsets.symmetric(horizontal: 16) +
                const EdgeInsets.only(bottom: 30, top: 20),
            child: BlocConsumer<TransactionBloc, TransactionState>(
              listener: (context, state) {
                if (state is TransactionSuccessState) {
                  Navigator.pop(context);
                  _showPopupMenu2(spendPoints, '1200', '1000', index);
                }
              },
              builder: (context, state) {
                if (state is TransactionSuccessState) {
                  return ElevatedButton(
                    onPressed: () {
                      _showPopupMenu2(spendPoints, '1200', '1000', index);
                    },
                    child: const Text("Купить билет со скидкой"),
                  );
                } else {
                  return ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<TransactionBloc>(context)
                          .add(PressBuyTicketEvent(index));
                      _showPopupMenu(spendPoints, '1200', '1000', index);
                    },
                    child: const Text("Купить билет"),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  _buildMap() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Image.network(
          'https://avatars.mds.yandex.net/get-bunker/128809/13ca6b0546c6785d8b3194c9e3e501350200263e/orig'),
    );
  }

  _showPopupMenu(int points, String oldPrice, String newPrice, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return RepositoryProvider(
          create: (context) => TransactionRepository(),
          child: RepositoryProvider(
            create: (context) => UserRepository(),
            child: BlocProvider(
              create: (context) => TransactionBloc(
                userRepository: RepositoryProvider.of<UserRepository>(context),
                transactionRepository:
                    RepositoryProvider.of<TransactionRepository>(context),
              ),
              child: AlertDialog(
                content: Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.width * 0.55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Активировать скидку за $points баллов?',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: BlocConsumer<TransactionBloc, TransactionState>(
                          listener: (context, state) async {
                            if (state is TransactionSuccessState) {
                              print(123);
                              final url = Uri.parse("https://yoomoney.ru/");
                              if (await canLaunchUrl(url)) launchUrl(url);
                            }
                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () async {
                                BlocProvider.of<TransactionBloc>(context)
                                    .add(PressButtonEvent(points, index));
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Да',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final url = Uri.parse("https://yoomoney.ru/");
                            if (await canLaunchUrl(url)) launchUrl(url);

                            Navigator.pop(context);
                          },
                          child: Text(
                            'Просто купить билет',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Отмена'),
                        style: ElevatedButton.styleFrom(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _showPopupMenu2(int points, String oldPrice, String newPrice, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return RepositoryProvider(
          create: (context) => UserRepository(),
          child: BlocProvider(
            create: (context) => TransactionBloc(
              userRepository: RepositoryProvider.of<UserRepository>(context),
              transactionRepository:
                  RepositoryProvider.of<TransactionRepository>(context),
            ),
            child: AlertDialog(
              content: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.width * 0.50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Вы уже активировали скидку!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final url = Uri.parse("https://yoomoney.ru/");
                          if (await canLaunchUrl(url)) launchUrl(url);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Купить билет',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Отмена'),
                      style: ElevatedButton.styleFrom(),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
