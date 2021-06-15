part of 'closeable_dropdown_final.dart';

class _CloseableDropdownRouteFinal extends PopupRoute {
  _CloseableDropdownRouteFinal({
    this.label = 'dropdown',
    required this.child,
    RouteSettings? setting,
  }) : super(settings: setting);

  final String label;
  final Widget child;

  @override
  Color get barrierColor => Colors.white.withOpacity(0.7);

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => label; //todo: this is for screen readers accessibility

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

//we can use below if you want to separate concerns
  // @override
  // Widget buildTransitions(
  //   BuildContext context,
  //   Animation<double> animation,
  //   Animation<double> secondaryAnimation,
  //   Widget child,
  // ) {
  //   return Align(
  //     child: FadeTransition(
  //       opacity: animation,
  //       child: child,
  //     ),
  //   );
  // }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 150);
}
