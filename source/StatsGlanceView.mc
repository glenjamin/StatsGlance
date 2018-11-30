using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.UserProfile;

class StatsGlanceView extends WatchUi.DataField {

  const xSize = 218;
  const xMid = 109;
  const xSpace = 5;

  const textLeft = xMid - xSpace;
  const textRight = xMid + xSpace;

  const yA = 65;
  const yAB = yB - yA;
  const yB = 124;
  const yBC = yC - yB;
  const yC = 183;

  const ySize = 218;
  const y1 = 9;
  const y2 = 50;
  const y2l = 102;
  const y2lMargin = 5;
  const y3 = 109;
  const y3l = 124;
  const y3lMargin = 8;
  const y4 = 180;

  hidden var hrZones = [0, 0, 0, 0, 0, 0];

  hidden var intervalMode = false;
  hidden var intervalDuration = 0;
  hidden var intervalDistance = 0;
  hidden var intervalLastDuration = 0;

  hidden var duration = 0;
  hidden var cadence = 0;
  hidden var hr = 0;
  hidden var distance = 0;
  hidden var avgSpeed = 0;
  hidden var speed = 0;
  hidden var elevation = 0;

  function initialize() {
    DataField.initialize();
  }

  function onLayout(dc) {
    hrZones = UserProfile.getHeartRateZones(UserProfile.getCurrentSport());
  }

  function onTimerLap() {
    // If the first lap is less than 1 minute long, enable interval mode
    if (intervalMode || duration < 60000) {
      intervalMode = true;
      intervalLastDuration = duration - intervalDuration;
      intervalDuration = duration;
      intervalDistance = distance;
    }
  }

  // The given info object contains all the current workout information.
  // Calculate a value and save it locally in this method.
  // Note that compute() and onUpdate() are asynchronous, and there is no
  // guarantee that compute() will be called before onUpdate().
  function compute(info) {
    duration = maybe(info.timerTime);
    cadence = maybe(info.currentCadence);
    hr = maybe(info.currentHeartRate);
    distance = maybe(info.elapsedDistance);
    avgSpeed = maybe(info.averageSpeed);
    speed = maybe(info.currentSpeed);
    elevation = maybe(info.totalAscent);
  }

  // Display the value you computed here. This will be called
  // once a second when the data field is visible.
  function onUpdate(dc) {
    // Convert numbers to formatted strings
    var durationToShow = intervalMode ? duration - intervalDuration : duration;
    var lDuration = formatDuration(durationToShow);
    var lCadence = formatInteger(cadence);
    var lHr = formatInteger(hr);
    var lDistance = formatDistance(
      intervalMode ? distance - intervalDistance : distance
    );
    var lTopLeftLabel = intervalMode ? "last" : "avg";
    var lTopLeft = intervalMode
      ? formatDuration(intervalLastDuration) : formatPace(avgSpeed);
    var lSpeed = formatPace(speed);
    var lElevation = formatInteger(elevation);

    var durationSize = Graphics.FONT_NUMBER_HOT;
    var durationY = y2;
    if (durationToShow >= 3600000) {
      durationSize = Graphics.FONT_NUMBER_MEDIUM;
      durationY += 19;
    }

    // Background
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
    dc.clear();

    // HR / Cadence Zones
    var cadenceColor = cadenceZone(cadence);
    if (cadenceColor != Graphics.COLOR_TRANSPARENT) {
      dc.setColor(cadenceColor, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(0, yA, 40, yAB);
    }
    var hrColor = hrZone(hr, hrZones);
    if (hrColor != Graphics.COLOR_TRANSPARENT) {
      dc.setColor(hrColor, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(0, yB, 40, yBC);
    }

    // Gridlines
    dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
    dc.drawLine(xMid, 0, xMid, ySize);
    dc.drawLine(0, yA, xSize, yA);
    dc.drawLine(0, yB, xSize, yB);
    dc.drawLine(0, yC, xSize, yC);

    // Labels
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

    dc.drawText(textLeft, y1 - 8, Graphics.FONT_XTINY, lTopLeftLabel, Graphics.TEXT_JUSTIFY_RIGHT);

    var distanceWidth = dc.getTextWidthInPixels(lDistance, Graphics.FONT_NUMBER_MEDIUM);
    dc.drawText(textRight + distanceWidth + 2, y1 + 38, Graphics.FONT_XTINY, "km", Graphics.TEXT_JUSTIFY_LEFT);

    dc.drawText(y2lMargin, y2l, Graphics.FONT_TINY, "cad", Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawText(y3lMargin, y3l, Graphics.FONT_TINY, "hr", Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawText(ySize - y3lMargin, y3l, Graphics.FONT_XTINY, "spd", Graphics.TEXT_JUSTIFY_RIGHT);

    var elevationWidth = dc.getTextWidthInPixels(lElevation, Graphics.FONT_NUMBER_MILD);
    dc.drawText(textRight + elevationWidth + 2, y4, Graphics.FONT_XTINY, "m", Graphics.TEXT_JUSTIFY_LEFT);

    // Data
    dc.drawText(textLeft, y1, Graphics.FONT_NUMBER_MEDIUM, lTopLeft, Graphics.TEXT_JUSTIFY_RIGHT);
    dc.drawText(textLeft, y2, Graphics.FONT_NUMBER_HOT, lCadence, Graphics.TEXT_JUSTIFY_RIGHT);
    dc.drawText(textLeft, y3, Graphics.FONT_NUMBER_HOT, lHr, Graphics.TEXT_JUSTIFY_RIGHT);
    dc.drawText(textLeft, y4, Graphics.FONT_NUMBER_MILD, getCurrentTime(), Graphics.TEXT_JUSTIFY_RIGHT);

    dc.drawText(textRight, y1, Graphics.FONT_NUMBER_MEDIUM, lDistance, Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawText(textRight, durationY, durationSize, lDuration, Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawText(textRight, y3, Graphics.FONT_NUMBER_HOT, lSpeed, Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawText(textRight, y4, Graphics.FONT_NUMBER_MILD, lElevation, Graphics.TEXT_JUSTIFY_LEFT);
  }

  function maybe(maybeValue) {
    if (maybeValue == null) {
    	return 0;
    }
    return maybeValue;
  }

  function cadenceZone(n) {
    if (n >= 180) {
      return Graphics.COLOR_BLUE;
    }
    if (n >= 170) {
      return Graphics.COLOR_GREEN;
    }
    return Graphics.COLOR_TRANSPARENT;
  }

  function hrZone(n, zones) {
    if (n > zones[4]) {
      return Graphics.COLOR_ORANGE;
    }
    if (n > zones[3]) {
      return Graphics.COLOR_YELLOW;
    }
    if (n > zones[2]) {
      return Graphics.COLOR_GREEN;
    }
    return Graphics.COLOR_TRANSPARENT;
  }

  function formatDuration(milliseconds) {
    var totalSeconds = Math.round(milliseconds / 1000.0).toNumber();

    var minutes = totalSeconds / 60;
    var seconds = totalSeconds % 60;

    if (minutes < 60) {
    	return minutes.format("%d") + ":" + seconds.format("%02d");
    }

    var hours = minutes / 60;
    minutes = minutes % 60;

    return hours.format("%d") + ":" + minutes.format("%02d") + ":" + seconds.format("%02d");
  }

  function formatDistance(m) {
    var km = m / 1000.0;
    if (km < 10) {
      return km.format("%.2f");
    }
    return km.format("%.1f");
  }

  function formatInteger(n) {
    return n.format("%d");
  }

  function formatPace(mPerSec) {
    if (mPerSec <= 0.5) {
      return "0:00";
    }
    var mPerMin = mPerSec * 60.0;
    var minPerKm = 1000.0 / mPerMin;
    var minPerKmMins = minPerKm.toNumber();
    var minPerKmSecs = (minPerKm - minPerKmMins) * 60;
    return minPerKmMins + ":" + minPerKmSecs.format("%02d");
  }

  function getCurrentTime() {
    var clockTime = System.getClockTime();
    return Lang.format("$1$:$2$", [
      clockTime.hour,
      clockTime.min.format("%.2d")
    ]);
  }
}
