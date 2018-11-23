using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time;

class StatsGlanceView extends WatchUi.DataField {

  hidden var xSize = 218;
  hidden var xMid = 109;
  hidden var xSpace = 6;

  hidden var yA = 50;
  hidden var yB = 109;
  hidden var yC = 168;

  hidden var textLeft = xMid - xSpace;
  hidden var textRight = xMid + xSpace;

  hidden var ySize = 218;
  hidden var y1 = 14;
  hidden var y2 = 35;
  hidden var y2l = 85;
  hidden var y3 = 93;
  hidden var y3l = 111;
  hidden var y4 = 170;
  hidden var ylMargin = 5;

  hidden var duration = "0:00";
  hidden var cadence = "0";
  hidden var hr = "0";
  hidden var time = "00:00";
  hidden var distance = "0";
  hidden var avgSpeed = "0:00";
  hidden var speed = "0:00";
  hidden var elevation = "3200";

    function initialize() {
        DataField.initialize();
    }

    function onLayout(dc) {
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
    	duration = formatDuration(info.timerTime);
    	cadence = formatInteger(info.currentCadence);
    	hr = formatInteger(info.currentHeartRate);
    	time = getCurrentTime();
    	distance = formatDistance(info.elapsedDistance);
    	avgSpeed = formatPace(info.averageSpeed);
    	speed = formatPace(info.currentSpeed);
    	elevation = formatInteger(info.totalAscent);
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc) {
        // Background
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

  // Gridlines
  dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
  dc.drawLine(xMid, 0, xMid, ySize);
  dc.drawLine(0, yA, xSize, yA);
  dc.drawLine(0, yB, xSize, yB);
  dc.drawLine(0, yC, xSize, yC);

        // Labels
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);

        var distanceWidth = dc.getTextWidthInPixels(distance, Graphics.FONT_NUMBER_MILD);
        dc.drawText(textRight + distanceWidth + 2, y1 + 13, Graphics.FONT_XTINY, "km", Graphics.TEXT_JUSTIFY_LEFT);

        var elevationWidth = dc.getTextWidthInPixels(elevation, Graphics.FONT_NUMBER_MILD);
        dc.drawText(textRight + elevationWidth + 2, y4 + 13, Graphics.FONT_XTINY, "m", Graphics.TEXT_JUSTIFY_LEFT);

        dc.drawText(ylMargin, y2l, Graphics.FONT_TINY, "cad", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(ylMargin, y3l, Graphics.FONT_TINY, "hr", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(ySize - ylMargin, y2l, Graphics.FONT_TINY, "avg", Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(ySize - ylMargin, y3l, Graphics.FONT_TINY, "spd", Graphics.TEXT_JUSTIFY_RIGHT);

        // Data
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        dc.drawText(textLeft, y1, Graphics.FONT_NUMBER_MILD, duration, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(textLeft, y2, Graphics.FONT_NUMBER_HOT, cadence, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(textLeft, y3, Graphics.FONT_NUMBER_HOT, hr, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(textLeft, y4, Graphics.FONT_NUMBER_MILD, time, Graphics.TEXT_JUSTIFY_RIGHT);

        dc.drawText(textRight, y1, Graphics.FONT_NUMBER_MILD, distance, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(textRight, y2, Graphics.FONT_NUMBER_HOT, avgSpeed, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(textRight, y3, Graphics.FONT_NUMBER_HOT, speed, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(textRight, y4, Graphics.FONT_NUMBER_MILD, elevation, Graphics.TEXT_JUSTIFY_LEFT);
    }

    function maybe(maybeValue, fallback) {
    	if (maybeValue == null) {
    		return fallback;
    	}
    	return maybeValue;
    }
    function formatDuration(milliseconds) {
    	var totalSeconds = milliseconds / 1000;

    	var minutes = totalSeconds / 60;
    	var seconds = totalSeconds % 60;

    	if (minutes < 60) {
    		return minutes.format("%d") + ":" + seconds.format("%02d");
    	}

    	var hours = minutes / 60;
    	minutes = minutes % 60;

    	return hours.format("%d") + ":" + minutes.format("%02d") + ":" + seconds.format("%02d");
  }
  function formatDistance(maybeDistance) {
  if (maybeDistance == null) {
  return "0.00";
  }
  var km = maybeDistance / 1000.0;
  if (km < 10) {
  return km.format("%.2f");
  }
  return km.format("%.1f");
  }
  function formatInteger(maybeNumber) {
  if (maybeNumber == null) {
  return "0";
  }
  return maybeNumber.format("%d");
  }
  function formatPace(maybePace) {
  if (maybePace == null || maybePace < 0.02) {
  return "0:00";
  }
  var mPerMin = maybePace * 60.0;
  var minPerKm = 1000.0 / mPerMin;
  var minPerKmMins = minPerKm.toNumber();
  var minPerKmSecs = (minPerKm - minPerKmMins) * 60;
  return minPerKmMins + ":" + minPerKmSecs.format("%02d");
  }
  function getCurrentTime() {
  var clockTime = System.getClockTime();
  return Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%.2d")]);
  }
}
