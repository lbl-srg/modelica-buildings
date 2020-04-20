within Buildings.ThermalZones.EnergyPlus;
package UsersGuide "EnergyPlus package user's guide"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
Documentation(info="<html>
<h4>Overview</h4>
<p>
This user guide describes how to use the EnergyPlus building envelope model.
</p>
<p>
To instanciate a building, proceed as follows:
</p>
<ol>
<li>
For each building, an instance of
<a href=\"Buildings.ThermalZones.EnergyPlus.Building\">
Buildings.ThermalZones.EnergyPlus.Building</a> needs to be made.
This instance is automatically named <code>building</code> and this
name must not be changed.
This allows to specify building-level parameters such as the
EnergyPlus input file name and weather file name.
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
For the weather file, both <code>.mos</code> and <code>.epw</code> files
must be provided in the same directory. The files must have the same name, except
for the different extension.
The <code>.epw</code> file will be used by the EnergyPlus envelope model, and the <code>.mos</code>
file will be used by the Modelica model, and must be specified by the parameter <code>weaName</code>
in the instance <code>building</code>.
</li>
</ol>
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
/usr/bin/ld: cannot find -lfmilib_shared
collect2: error: ld returned 1 exit status
</pre>
<h5>Models with multiple thermal zones</h5>
<p>
For Dymola 2019FD01 and Dymola 2020, only one thermal zone can be in EnergyPlus.
For Dymola 2020x, this limitation will be corrected if the flag
</p>
<pre>
Hidden.AvoidDoubleComputation=true
</pre>
<p>
is set in the Dymola command line window.
For Dymola 2021, this flag will be set to <code>true</code> by default.
</p>
<p>
This limitation only affects Dymola. JModelica can simulate Modelica models
for which the EnergyPlus model has multiple thermal zones, or for which
multiple buildings are simulated in EnergyPlus.
</p>
</html>", revisions="<html>
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
