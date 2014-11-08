# hide hud if view-number != 0

setlistener("/sim/current-view/view-number", func(n) {

    setprop("/sim/hud/visibility[1]", n.getValue() == 0);

}, 1);