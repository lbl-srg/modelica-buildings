within Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses;
pure function exchange
  "Exchange the values with the EnergyPlus thermal zone"
  extends Modelica.Icons.Function;
  input Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.SpawnExternalObject adapter
    "External object";
  input Boolean initialCall
    "Set to true if initial() is true, false otherwise";
  input Integer nY
    "Size of output y";
  input Real u[:]
    "Input values. First all inputs, then the current model time";
  input Real dummy
    "Dummy value (used to force Modelica tools to call initialize())";
  output Real y[nY]
    "Output values. First all outputs, then all derivatives, then next event time";
external "C" exchange_Modelica_EnergyPlus_9_6_0(
  adapter,initialCall,u,dummy,y)
  annotation (
      Include="#include <EnergyPlus_9_6_0_Wrapper.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      Library={"ModelicaBuildingsEnergyPlus_9_6_0","fmilib_shared"});
  annotation (
    Documentation(
      info="<html>
<p>
External function that exchanges data with EnergyPlus.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 11, 2021, by Michael Wetter:<br/>
Declared function as <code>pure</code> for MSL 4.0.0.
</li>
<li>
February 18, 2021, by Michael Wetter:<br/>
Refactor synchronization of constructors.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2360\">#2360</a>.
</li>
<li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end exchange;
