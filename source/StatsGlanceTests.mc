using Toybox.Lang;
using Toybox.System;
using Toybox.Graphics;
using Toybox.Test;

var view = new StatsGlanceView();

function assertEq(logger, actual, expected) {
  try {
    Test.assertEqual(actual, expected);
  } catch (ex instanceof Test.AssertException) {
    logger.error(Lang.format("Actual: $1$, Expected: $2$", [actual, expected]));
    throw ex;
  }
}

(:test)
function maybe(logger) {
  assertEq(logger, view.maybe(10), 10);
  assertEq(logger, view.maybe(0), 0);
  assertEq(logger, view.maybe(null), 0);
  return true;
}

(:test)
function cadenceZone(logger) {
  assertEq(logger, view.cadenceZone(0), Graphics.COLOR_TRANSPARENT);
  assertEq(logger, view.cadenceZone(169), Graphics.COLOR_TRANSPARENT);
  assertEq(logger, view.cadenceZone(170), Graphics.COLOR_GREEN);
  assertEq(logger, view.cadenceZone(179), Graphics.COLOR_GREEN);
  assertEq(logger, view.cadenceZone(180), Graphics.COLOR_BLUE);
  assertEq(logger, view.cadenceZone(181), Graphics.COLOR_BLUE);
  return true;
}

(:test)
function hrZone(logger) {
  var hrZones = [100, 120, 140, 160, 175, 195];

  assertEq(logger, view.hrZone(0, hrZones), Graphics.COLOR_TRANSPARENT);
  assertEq(logger, view.hrZone(99, hrZones), Graphics.COLOR_TRANSPARENT);
  assertEq(logger, view.hrZone(120, hrZones), Graphics.COLOR_TRANSPARENT);
  assertEq(logger, view.hrZone(140, hrZones), Graphics.COLOR_TRANSPARENT);
  assertEq(logger, view.hrZone(141, hrZones), Graphics.COLOR_GREEN);
  assertEq(logger, view.hrZone(160, hrZones), Graphics.COLOR_GREEN);
  assertEq(logger, view.hrZone(161, hrZones), Graphics.COLOR_ORANGE);
  assertEq(logger, view.hrZone(175, hrZones), Graphics.COLOR_ORANGE);
  assertEq(logger, view.hrZone(176, hrZones), Graphics.COLOR_RED);
  assertEq(logger, view.hrZone(195, hrZones), Graphics.COLOR_RED);
  assertEq(logger, view.hrZone(200, hrZones), Graphics.COLOR_RED);
  return true;
}

(:test)
function formatDuration(logger) {
  assertEq(logger, view.formatDuration(0), "0:00");
  assertEq(logger, view.formatDuration(30000), "0:30");
  assertEq(logger, view.formatDuration(87000), "1:27");
  assertEq(logger, view.formatDuration(3597000), "59:57");
  assertEq(logger, view.formatDuration(3600000), "1:00:00");
  assertEq(logger, view.formatDuration(34789000), "9:39:49");
  return true;
}

(:test)
function formatDistance(logger) {
  assertEq(logger, view.formatDistance(5000), "5.01");
  assertEq(logger, view.formatDistance(5232), "5.23");
  assertEq(logger, view.formatDistance(7236), "7.24");
  assertEq(logger, view.formatDistance(9929), "9.93");
  assertEq(logger, view.formatDistance(10112), "10.1");
  assertEq(logger, view.formatDistance(121232), "121.2");
  return true;
}

(:test)
function formatPace(logger) {
  assertEq(logger, view.formatPace(0), "0:00");
  assertEq(logger, view.formatPace(3.333), "5:00");
  assertEq(logger, view.formatPace(0.833), "20:00");
  // If really slow, call it zero
  assertEq(logger, view.formatPace(0.5), "0:00");
  return true;
}
