using Toybox.Lang;
using Toybox.System;
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
	assertEq(logger, view.formatDistance(null), "0.00");
    assertEq(logger, view.formatDistance(5), "5.00");
    assertEq(logger, view.formatDistance(5.232456), "5.23");
    assertEq(logger, view.formatDistance(7.236324), "7.24");
    assertEq(logger, view.formatDistance(9.929323), "9.93");
    assertEq(logger, view.formatDistance(10.11212245346), "10.1");
    assertEq(logger, view.formatDistance(121.2323), "121.2");
    return true;
}

(:test)
function formatPace(logger) {
	assertEq(logger, view.formatPace(null), "0:00");
	assertEq(logger, view.formatPace(0), "0:00");
	assertEq(logger, view.formatPace(3.333), "5:00");
    return true;
}