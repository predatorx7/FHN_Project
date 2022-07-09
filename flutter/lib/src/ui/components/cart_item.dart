import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping/src/data/data.dart';
import 'package:transparent_image/transparent_image.dart';

class SampleItemPicture extends StatelessWidget {
  const SampleItemPicture({
    Key? key,
    required this.item,
  }) : super(key: key);

  final SampleItem item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: item.thumbnailUrl ?? item.url ?? '',
        fit: BoxFit.fill,
      ),
    );
  }
}

class ItemTileBar extends StatelessWidget {
  const ItemTileBar({
    Key? key,
    required this.item,
  }) : super(key: key);

  final SampleItem item;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final currencyFormat = NumberFormat("#,##0.00", locale.toString());

    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            item.title ?? '-',
            maxLines: 2,
            textAlign: TextAlign.start,
            overflow: TextOverflow.fade,
            style: textTheme.titleSmall,
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: '₹',
                  ),
                  TextSpan(
                    text: currencyFormat.format(item.price ?? 0.0),
                  ),
                ],
              ),
              style: textTheme.labelLarge?.merge(TextStyle(
                color: Theme.of(context).colorScheme.primary.withRed(200),
                fontSize: 18,
              )),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }
}
