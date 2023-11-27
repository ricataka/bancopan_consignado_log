library timeline_node;

import 'package:flutter/material.dart';

enum TimelineNodeType { left, right }

enum TimelineNodePointType { none, circle }

enum TimelineNodeLineType { none, full, topHalf, bottomHalf }

class TimelineNodeStyle {
  final TimelineNodeType type;
  final TimelineNodePointType pointType;
  final Color pointColor;
  final double pointRadius;
  final TimelineNodeLineType lineType;
  final Color lineColor;
  final double lineWidth;
  final double preferredWidth;

  const TimelineNodeStyle(
      {this.type = TimelineNodeType.left,
      this.pointType = TimelineNodePointType.none,
      this.pointColor = Colors.blue,
      this.pointRadius = 6,
      this.lineType = TimelineNodeLineType.none,
      this.lineColor = Colors.blue,
      this.lineWidth = 2,
      this.preferredWidth = 50});
}

class TimelineNode extends StatefulWidget {
  final TimelineNodeStyle style;
  final Widget child;

  const TimelineNode({Key? key, required this.style, required this.child})
      : super(key: key);

  @override
  State<TimelineNode> createState() => _TimelineNodeState();
}

class _TimelineNodeState extends State<TimelineNode> {
  Widget layout() {
    Widget nodeLine = SizedBox(
      width: widget.style.preferredWidth,
      height: double.infinity,
      child: CustomPaint(
        painter: TimelineNodeLinePainter(style: widget.style),
      ),
    );
    Widget nodeContent = Expanded(child: widget.child);
    List<Widget> nodeRowChildren = [];
    switch (widget.style.type) {
      case TimelineNodeType.left:
        nodeRowChildren.add(nodeLine);
        nodeRowChildren.add(nodeContent);
        break;
      case TimelineNodeType.right:
        nodeRowChildren.add(nodeContent);
        nodeRowChildren.add(nodeLine);
        break;
    }
    return IntrinsicHeight(
      child: Row(
        children: nodeRowChildren,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return layout();
  }
}

class TimelineNodeLinePainter extends CustomPainter {
 final TimelineNodeStyle style;

  const TimelineNodeLinePainter({required this.style});

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint();
    linePaint.color = style.lineColor;
    linePaint.strokeWidth = style.lineWidth;
    switch (style.lineType) {
      case TimelineNodeLineType.none:
        break;
      case TimelineNodeLineType.full:
        canvas.drawLine(Offset(size.width / 2, 0),
            Offset(size.width / 2, size.height), linePaint);
        break;
      case TimelineNodeLineType.topHalf:
        canvas.drawLine(Offset(size.width / 2, 0),
            Offset(size.width / 2, size.height / 2), linePaint);
        break;
      case TimelineNodeLineType.bottomHalf:
        canvas.drawLine(Offset(size.width / 2, size.height / 2),
            Offset(size.width / 2, size.height), linePaint);
        break;
    }

    Paint pointPaint = Paint();
    pointPaint.color = style.pointColor;

    switch (style.pointType) {
      case TimelineNodePointType.none:
        break;
      case TimelineNodePointType.circle:
        canvas.drawCircle(Offset(size.width / 2, size.height / 2),
            style.pointRadius, pointPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(TimelineNodeLinePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TimelineNodeLinePainter oldDelegate) => false;
}
