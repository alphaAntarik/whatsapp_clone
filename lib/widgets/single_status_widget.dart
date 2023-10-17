import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/status_model.dart';

class SingleStatus extends StatelessWidget {
  const SingleStatus({
    super.key,
    required this.status,
  });

  final StatusModel status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 10),
      child: Row(
        children: [
          Container(
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    status.status!,
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
              alignment: WrapAlignment
                  .center, // Controls text alignment within the container
              runAlignment:
                  WrapAlignment.center, // Controls text alignment in a new line
              direction: Axis.horizontal, // Text direction
              spacing: 8.0, // Spacing between items (adjust as needed)
              runSpacing: 8.0, // Spacin
              // textDirection: TextDirection.ltr,
            ),
            width: 70, // Set the width of the circular container
            height: 70, // Set the height of the circular container
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Make the container circular
              color: Colors.white, // Set the container's color
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  status.name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                DateFormat.jm().format(DateTime.parse(status.dateonly!)),
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.normal),
              )
            ],
          ),
        ],
      ),
    );
  }
}
