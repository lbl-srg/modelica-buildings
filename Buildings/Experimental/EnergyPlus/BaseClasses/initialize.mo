within Buildings.Experimental.EnergyPlus.BaseClasses;
function initialize "Initialization"
  input Buildings.Experimental.EnergyPlus.BaseClasses.FMUZoneClass
    adapter "External object";
  input Modelica.SIunits.Time startTime "Start time of the simulation";
  input Modelica.SIunits.Temperature T_start "Initial value of the zone air temperature";
  output Modelica.SIunits.Area AFlo "Zone floor area";
  output Modelica.SIunits.Volume V "Zone air volume";
  output Real mSenFac "Factor for scaling the sensible thermal mass of the zone air volume";

  external "C" ZoneInstantiate(adapter, startTime, T_start, AFlo, V, mSenFac)
 annotation (
   IncludeDirectory="modelica://Buildings/Resources/C-Sources/EnergyPlus",
   Include="#include \"ZoneInstantiate.c\"");

  annotation (Documentation(info="<html>
<p>
External function to obtain parameters from the EnergyPlus FMU.
</p>
</html>", revisions="<html>
<ul><li>
March 1, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end initialize;
