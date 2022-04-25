import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/lyrics_bloc/lyrics_bloc.dart';

enum ButtonState {
  initial,
  loading,
  loaded,
  error,
}

class DownloadButton extends StatefulWidget {
  final Function onPressed;
  final int index;

  const DownloadButton({Key? key, required this.onPressed, required this.index}) : super(key: key);

  @override
  State<DownloadButton> createState() => _DownloadButtonState();

}

class _DownloadButtonState extends State<DownloadButton> {
  ButtonState state = ButtonState.initial;

  void changeState(ButtonState newState) {
    super.setState(() {
      state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<LyricsBloc>(context),
      listener: (context, state) {
        if(state is LyricsLoaded && this.state == ButtonState.loading ){
          changeState(ButtonState.loaded);
          Timer(const Duration(seconds: 3), () {
            changeState(ButtonState.initial);
          });
        }
        if((state is NoInternetConnection || state is LyricsError) && this.state == ButtonState.loading) {
          changeState(ButtonState.error);
          Timer(const Duration(seconds: 3), () {
            changeState(ButtonState.initial);
          });
        }
        if(state is LyricsLoading && widget.index == state.index){
          changeState(ButtonState.loading);
        }
      },
      child: Builder(builder: (context) {
        if (state == ButtonState.loading) {
          return const CircularProgressIndicator(strokeWidth: 2);
        } else if (state == ButtonState.loaded) {
          return circularBorder(icon: Icons.done);
        } else if (state == ButtonState.error){
          return circularBorder(icon: Icons.error, color: Colors.grey);
        }
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          child: circularBorder(icon: Icons.download),
          onTap: () {
            widget.onPressed();
            changeState(ButtonState.loading);
          },
        );
      },),
    );
  }

  Widget circularBorder({required IconData icon, Color color = Colors.blue}) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }
}
