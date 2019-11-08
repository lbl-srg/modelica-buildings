within Buildings.Experimental.EnergyPlus.BaseClasses;
function scheduleExchange
  "Exchange the values with the EnergyPlus schedule"
  extends Modelica.Icons.Function;

  input Buildings.Experimental.EnergyPlus.BaseClasses.FMUScheduleClass
    adapter "External object";
  input Boolean initialCall "Set to true if initial() is true, false otherwise";
  input Modelica.SIunits.Time tModel "Current model time";
  input Real u "Value for the EnergyPlus schedule";
  output Modelica.SIunits.Time tNext "Next time that the schedule variable needs to be sent";

  external "C" ScheduleExchange(adapter, initialCall, tModel, u, tNext)
      annotation (
        IncludeDirectory="modelica://Buildings/Resources/C-Sources/EnergyPlus",
        Include="#include \"ScheduleExchange.c\"");

  annotation (Documentation(info="<html>
<p>
External function that sends data to an EnergyPlus schedule.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 8, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end scheduleExchange;
