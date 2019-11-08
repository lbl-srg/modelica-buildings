within Buildings.Experimental.EnergyPlus.BaseClasses;
function scheduleInitialize
  "Initialization for an EnergyPlus schedule"
  extends Modelica.Icons.Function;

  input Buildings.Experimental.EnergyPlus.BaseClasses.FMUScheduleClass
    adapter "External object";
  input Modelica.SIunits.Time startTime "Start time of the simulation";

  external "C" ScheduleInstantiate(adapter, startTime)
 annotation (
   IncludeDirectory="modelica://Buildings/Resources/C-Sources/EnergyPlus",
   Include="#include \"ScheduleInstantiate.c\"");

  annotation (Documentation(info="<html>
<p>
External function to initialize the EnergyPlus schedule.
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
end scheduleInitialize;
