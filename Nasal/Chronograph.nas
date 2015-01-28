# Nasal module that handles some common tasks related to
# the cronograph of the cockpit clock.
#
# When /instrumentation/clock/chronograph-state == "started"
# the property rule defined in Chronograph.xml
# will continuously update /instrumentation/clock/elapsed-time-sec.


# Cycles trough the clock states started/stopped/reset
var cycle = func() {

  # The property to cycle and its valid states
  var states = props.Node.new ({
    "property": "/instrumentation/clock/chronograph-state",
    "value": ["started", "stopped", "reset"]
  });

  fgcommand("property-cycle", states);

  # Whate state is the chronograph in after cycling the state?
  var state = getprop("/instrumentation/clock/chronograph-state");

  # Reset the elapsed time if the chronograph was reset
  if (state == "reset") {
    resetElapsedTime();
  };

  # Instantaneously reset the offset before the chronograph is started
  if (state == "started") {
    resetChronographOffset();
  };

};

# Slowly resets "/instrumentation/clock/elapsed-time-sec"
# This property is used for the animation of the chronograph hands.
var resetElapsedTime = func() {

  interpolate (
    "/instrumentation/clock/elapsed-time-sec", 0, 0.2
  );

}

# Resets "/instrumentation/clock/chronograph-offset-sec"
# This property is used by the property rule that updates the elapsed time.
var resetChronographOffset = func() {

  var t = getprop("/sim/time/elapsed-sec") + getprop("/sim/time/warp");

  setprop("/instrumentation/clock/chronograph-offset-sec", t);

}
