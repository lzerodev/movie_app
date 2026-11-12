import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

/// Ingresso com estrela em recorte. Uma única silhueta para os dois temas.
class RtmLogo extends StatelessWidget {
  final double size;
  const RtmLogo({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/brand/rtm-mark.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.primary,
        BlendMode.srcIn,
      ),
      semanticsLabel: 'RTM',
    );
  }
}
