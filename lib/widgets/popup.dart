import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/utils/translate.dart';
import 'package:market_partners/widgets/my_filled_button.dart';
import 'package:market_partners/widgets/my_outlined_button.dart';

class Popup extends StatelessWidget {
  final String title;
  final Widget child;
  final bool actionButtons;
  final VoidCallback? confirmAction;

  const Popup({
    super.key,
    required this.title,
    required this.child,
    this.actionButtons = false,
    this.confirmAction,
  });

  @override
  Widget build(BuildContext context) {
    Row rowActionButtons = Row(
      children: [
        Expanded(
          child: MyOutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: TranslatedText(
              text: "Cancelar",
              style: TextStyle(color: AppColors.blue),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: MyFilledButton(
            onPressed: confirmAction,
            child: TranslatedText(
              text: "Confirmar",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );

    return AlertDialog(
      title: TranslatedText(text: title, style: AppText.titleInfoTiny),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.height * 0.5,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: SingleChildScrollView(child: child)),
            SizedBox(height: 20),
            actionButtons
                ? rowActionButtons
                : MyFilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: TranslatedText(
                    text: "Fechar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
