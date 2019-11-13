within Buildings.Experimental.EnergyPlus.BaseClasses;
function writerInitialize
  "Initialization for an EnergyPlus actuator or schedule"
  extends Modelica.Icons.Function;

  input Buildings.Experimental.EnergyPlus.BaseClasses.FMUWriterClass adapter
    "External object";
  input Modelica.SIunits.Time startTime "Start time of the simulation";

  external "C" WriterInstantiate(adapter, startTime)
 annotation (
   IncludeDirectory="modelica://Buildings/Resources/C-Sources/EnergyPlus",
   Include="#include \"WriterInstantiate.c\"");

  annotation (Documentation(info="<html>
<p>
External function to initialize the EnergyPlus actuator or schedule.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 7, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end writerInitialize;
