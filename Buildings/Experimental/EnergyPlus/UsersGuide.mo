within Buildings.Experimental.EnergyPlus;
package UsersGuide "EnergyPlus package user's guide"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
Documentation(info="<html>

<h4>Overview</h4>
<p>
This user guide describes how to use the EnergyPlus building envelope model.
For each thermal zone, an instance of
<a href=\"modelica://Buildings.Experimental.EnergyPlus.ThermalZone\"</a>
Buildings.Experimental.EnergyPlus.ThermalZone</a> need to be made.
This instance allows to specify the name of the EnergyPlus input data (idf) file
and the name of the thermal zone, as specified in the idf file.
These names will then be used to connect the Modelica zone model with the
EnergyPlus zone.
</p>
<p>
The following conventions are made:
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
</p>
</html>", revisions="<html>
<ul>
<li>
May 22, 2019, by Michael Wetter:<br/>
Created User's guide.
</li>
</ul>
</html>"));
end UsersGuide;
