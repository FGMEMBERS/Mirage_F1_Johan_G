###################################
# /!\   None of this is tested!   #
#                                 #
# Consider it pseudo code for now #
###################################



# Lists of properties

# List of properties for the warning lights (red) on the failure warning panel
var failure_warning_panel_warning_light_properties =
  [ battery,
    emergency-ac-power,
    fuel-pressure-engine,
    oil-pressure,
    electric-hydraulic-pump,
    emergency-hydraulic,
    cabin-temperature,
    cabin-pressure,
    autopilot,
    alternator-modulation,
    bleed-off-valve ];

# List of properties for the caution lights (amber) on the failure warning panel
var failure_warning_panel_warning_light_properties =
  [ alternator[0],
    alternator[1],
    transformer-rectifier[0],
    fuel-pressure-pump[0],
    fuel-pressure-pump[1],
    transformer-rectifier[1],
    fuel-level,
    hydraulic-pressure[0],
    hydraulic-pressure[1],
    oxygen-level,
    equipment-temperature,
    autotrim,
    transponder,
    pitot,
    air-data-computer,
    yaw-damper,
    pitch-damper,
    roll-damper,
    elevator,
    rudder,
    slat-flap ];



# Lists of resettable properties

# List of resettable failure warning light properties
var resettable_failure_warning_light_properties =
    failure_warning_panel_warning_light_properties ~ failure_warning_panel_warning_light_properties;

# List of resettable warning horn sound properties
var resettable_failure_warning_horn_sounds =
  [ master-failure,
    limits,
    limit-incidence ];



# List of listerners and helper functions for adding and removing listeners

# List of listener ids
var listeners = [];


# Helper function for adding listeners
#
# Parameters:
#   property:   Property to register the listener to
#   function:   Function to register to that listener
#   runtime:    Either of
                    0:  Run function every time the property
                        is written to.
                    1:  Run function only when changes are written.
                    2:  Also run the function when child nodes are
                        created or written to.

var add_listener = func(property, function, runtime) {
  append(listeners, setlistener(property, function, runtime)
};

# Helper function for removing all listeners
var remove_all_listeners = func {
    foreach(var id, listerners)
        remove_listener(id)
};

# Remove all listerners on reinit
_setlistener( "/sim/signals/reinit", remove_all_listeners );



# Functions and helper functions for tripping warnings

# Trip oxygen regulator failure warning and warning horn
var master_failure_warning = func() {
    setprop("/instrumentation/warning-horn/oxygen-regulator", true)
    setprop("/instrumentation/master-failure-warning/master-failure", true)
    setprop("/instrumentation/failure-warning-panel/oxygen-regulator", true)
};


# Trip the master warning light (red side) and warning horn
var master_failure_warning = func() {
    setprop("/instrumentation/warning horn/master-failure", true)
    setprop("/instrumentation/master-failure-warning/master-failure", true)
};

# Trip the master caution warning light (amber side)
var master_failure_warning = func() {
    setprop("/instrumentation/master-failure-warning/master-caution", true)
};



# Function for resetting resettable warnings

# Reset master failure warning light, resettable warning horn sounds,
# and resettable failure warning panel lights
var reset_master_failure_warning_light = func() {
    foreach(property, resettable_failure_warning_horn_sounds) 
        setprop("/instrumentation/warning-horn/" ~ property, false)

    setprop("/instrumentation/master-failure-warning/master-failure", false)
    setprop("/instrumentation/master-failure-warning/master-caution", false)
    
    foreach(property, resettable_failure_warning_light_properties) 
        setprop("/instrumentation/failure-warning-panel/" ~ property, false)
};
