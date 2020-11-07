within Buildings.ThermalZones.EnergyPlus;
package UsersGuide
  "EnergyPlus package user's guide"
  extends Modelica.Icons.Information;
  annotation (
    preferredView="info",
    Documentation(
      info="<html>
<h4>Overview</h4>
<p align=\"right\">
<img alt=\"Spawn logo\" src=\"modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/spawn_icon_darkbluetxlowres.png\"  style=\"float:right;height=203px;width:587px;\"/>
</p>
<p>
This user guide describes how to use the EnergyPlus building envelope model.
</p>
<p>
Currently Windows 64 bit and Linux 64 bit are supported.
</p>
<p>
To instanciate one or several buildnig models, proceed as follows:
</p>
<ol>
<li>
Create an instance of
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Building\">
Buildings.ThermalZones.EnergyPlus.Building</a> to specify the building model.
This instance is automatically named <code>building</code> and this
name must not be changed.<br/>
</li>
<li>
In the instance <code>building</code>, specify building-level parameters such as the
EnergyPlus input file name and weather file name.
</li>
<li>
For the weather file, both <code>.mos</code> and <code>.epw</code> files
must be provided in the same directory. The files must have the same name, except
for the different extension.
The <code>.epw</code> file will be used by the EnergyPlus envelope model, and the <code>.mos</code>
file will be used by the Modelica model, and must be specified by the parameter <code>weaName</code>
in the instance <code>building</code>.
</li>
<li>
In the model that contains the instance <code>building</code>,
or in any model instanciated by that model, instantiate
for each thermal zone an instance of
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.ThermalZone\">
Buildings.ThermalZones.EnergyPlus.ThermalZone</a>.
These thermal zones will automatically be assigned the name of the
EnergyPlus input data file and weather file, as well as the other parameters
that are declared in the instance <code>building</code>.
In these instances, specify the name of the thermal zone, as it is entered
in the EnergyPlus input data file, and also assign the medium of the thermal zone,
as is done for any other fluid flow component.
This instance will then connect the Modelica zone model with the
EnergyPlus zone model.
</li>
<li>
Optionally, to write to EnergyPlus actuators or schedules during the simulation,
instantiate any number of
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Actuator\">
Buildings.ThermalZones.EnergyPlus.Actuator</a>
or
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Schedule\">
Buildings.ThermalZones.EnergyPlus.Schedule</a> models.
</li>
<li>
Optionally, to retrieve the current values of output variables from EnergyPlus,
instantiate any number of
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.OutputVariable\">
Buildings.ThermalZones.EnergyPlus.OutputVariable</a> models.
</li>
</ol>
<p>
If you have more than one building, then repeat the above steps for each building and combine
these building models in a top-level model.
See for example
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Validation.MultipleBuildings.ThreeZonesTwoBuildings\">
Buildings.ThermalZones.EnergyPlus.Validation.MultipleBuildings.ThreeZonesTwoBuildings</a>
for how to combine two buildings in one Modelica model.
</p>
<p>
For details of how to configure these models, see the information section of these models.
</p>
<h4>Conventions</h4>
<p>
The following conventions are made:
</p>
<ul>
<li>
All zones in the idf file must have a zone model in Modelica. Otherwise
the simulation stops with an error.
</li>
<li>
If there is an HVAC system in the idf file, then EnergyPlus issues a warning,
the EnergyPlus HVAC system is not simulated, but the coupled EnergyPlus/Modelica
simulation proceeds.
</li>
<li>
For the EnergyPlus envelope, either the CTF transfer function or the finite difference
method can be used.
</li>
<li>
The coupling time step is determined by EnergyPlus based on the zone time step,
as declared in the idf file.
</li>
</ul>
<!-- .................................................................... -->
<h4>Unit conversion</h4>
<p>
Units between Modelica and EnergyPlus are automatically converted, if they are specified.
The conversion is according to the table at
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Types.Units\">
Buildings.ThermalZones.EnergyPlus.Types.Units</a>.
</p>
<p>
To see what units are used, set <code>printUnits=true</code> (the default) in the
instance
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Building\">
Buildings.ThermalZones.EnergyPlus.Building</a>.
This will cause the used units to be reported in the Modelica log file.
</p>
<p>
The thermal zone model automatically converts the units.
</p>
<p>
To do unit conversion for values sent by
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Actuator\">
Buildings.ThermalZones.EnergyPlus.Actuator</a>
and by
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Schedule\">
Buildings.ThermalZones.EnergyPlus.Schedule</a>,
set the parameter <code>unit</code> to the unit of the variable obtained at
the input connector <code>u</code>. The value will then be converted
before it is sent to EnergyPlus.
The units that are used in the input <code>u</code> of this block
are reported to the Modelica log file.
</p>
<p>
To do unit conversion for values read by
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.OutputVariable\">
Buildings.ThermalZones.EnergyPlus.OutputVariable</a>,
Modelica will use the units reported by EnergyPlus.
The units that are used in the output <code>y</code> of this block
are reported to the Modelica log file.
</p>
<!-- .................................................................... -->
<h4>EnergyPlus warm-up</h4>
<p>
In Spawn there can be both connected and unconnected zones defined in the EnergyPlus input file.
Connected zones have a corresponding zone model
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.ThermalZone\">
Buildings.ThermalZones.EnergyPlus.ThermalZone</a>
in Modelica that communicates with the EnergyPlus zone heat balance model.
Unconnected zones are thermal zones which are defined entirely within the EnergyPlus input file,
and for these zones the conventional EnergyPlus algorithms are used to simulate the zone conditions,
including the air temperature and humidity, which are free floating.
In contrast, for connected zones, Modelica models the temperature and humidity.
During the initialization of a new simulation it is necessary to compute initial values
for the zone air conditions as well as the conditions of any thermal mass, such as for walls, floors and ceilings.
Conventionally, EnergyPlus handles this requirement using a warmup period,
and in Spawn the traditional EnergyPlus warmup algorithm is employed
to initialize unconnected zones.
The EnergyPlus warmup algorithm is described in the
<a href=\"https://bigladdersoftware.com/epx/docs/9-3/engineering-reference/warmup-convergence.html#warmup-convergence\">
EnergyPlus Engineering Reference</a>, and summarized in the following steps.
</p>
<ol>
<li>
<p>
Zone and wall surface temperatures are initialized to <i>23</i>&deg;C.
</p>
</li>
<li>
<p>
Zone humidity ratios are initialized to the outdoor conditions.
</p>
</li>
<li>
<p>
During warmup, the outdoor conditions are determined by the EnergyPlus weather file.
</p>
</li>
<li>
<p>
The first day of the simulation is repeated until warmup convergence,
which occurs when the minimum and maximum air temperatures during the warmup day
remain nearly the same between two successive iterations.
</p>
</li>
</ol>
<p>
Spawn initializes unconnected zones using the warmup algorithm that was just described.
However, connected zones are treated differently than in a conventional EnergyPlus simulation
because initial zone air properties are specified in the Modelica zone model.
During Spawn warmup, the following steps occur:
</p>
<ol>
<li>
<p>
All wall surface temperatures are initialized to <i>23</i>&deg;C
just as they are in a conventional EnergyPlus warmup period.
However, as in EnergyPlus, during the warmup iterations,
the exterior walls will be subject to the ambient conditions defined by the weather file.
Therefore, exterior surface temperatures will not remain fixed at their <i>23</i>&deg;C
initial condition during the warmup process.
Similarly, room-facing wall surfaces will be exposed to the zone temperature, and
therefore approach a quasi-steady state at the conclusion of warmup.
</p>
</li>
<li>
<p>
The air temperatures of unconnected zones are initialized to <i>23</i>&deg;C.
</p>
</li>
<li>
<p>
The humidity ratios of unconnected zones are initialized to the outdoor conditions.
</p>
</li>
<li>
<p>
The air temperatures and humidity ratios of connected zones are initialized to
the initial values defined in Modelica, and held fixed during the warmup period.
</p>
</li>
<li>
<p>
During warmup, the outdoor conditions are determined by the EnergyPlus weather file
in the same way as a conventional EnergyPlus simulation.
</p>
</li>
<li>
<p>
The first day of the simulation is repeated until the minimum and maximum air temperatures
during the warmup day remain nearly the same between two successive iterations.
</p>
</li>
</ol>
<p>
The Spawn warmup procedure is still invoked even if there are no unconnected zones defined in the model.
However, in this case the warmup convergence criteria will be met after only two iterations of the warmup day
because all zone temperature and humidity values are fixed to the initial values defined in Modelica.
It is possible for startup transients to still exist after Spawn warmup due thermal mass
in the wall materials not being fully exposed to the surface boundary conditions
defined by the outdoor environment and the initial zone air conditions.
A future enhancement may define a new warmup convergence criteria that takes into account
the internal wall temperatures.
</p>
<!-- .................................................................... -->
<h4>Notes for Dymola</h4>
<h5>64 bit configuration</h5>
<p>
Make sure Dymola compiles in 64 bit, which can be done by setting the flag
</p>
<pre>
Advanced.CompileWith64 = 2
</pre>
<p>
Otherwise, you may get an error such as
</p>
<pre>
/usr/bin/ld: cannot find -lfmilib_shared
collect2: error: ld returned 1 exit status
</pre>
<h5>Models with multiple thermal zones</h5>
<p>
For Dymola 2019FD01 and Dymola 2020, only one thermal zone can be in EnergyPlus.
For Dymola 2020x, this limitation is removed if the flag
</p>
<pre>
Hidden.AvoidDoubleComputation=true
</pre>
<p>
is set in the Dymola command line window.
For Dymola 2021, this flag will be set to <code>true</code> by default.
</p>
<p>
This limitation only affects Dymola. OPTIMICA and JModelica can simulate Modelica models
for which the EnergyPlus model has multiple thermal zones, or for which
multiple buildings are simulated in EnergyPlus.
</p>
</html>",
      revisions="<html>
<ul>
<li>
April 20, 2020, by Kun Zhang: <br/>
Added note for weather file.
</li>
<li>
August 26, 2019, by Michael Wetter:<br/>
Added note about Dymola (Dassault Service Request SR00584808).
</li>
<li>
May 22, 2019, by Michael Wetter:<br/>
Created User's guide.
</li>
</ul>
</html>"));
end UsersGuide;
