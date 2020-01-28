within Buildings.ThermalZones.EnergyPlus.BaseClasses;
function writerExchange
  "Exchange the values with the EnergyPlus actuator or schedule"
  extends Modelica.Icons.Function;

  input Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUWriterClass adapter
    "External object";
  input Boolean initialCall "Set to true if initial() is true, false otherwise";
  input Modelica.SIunits.Time tModel "Current model time";
  input Real u "Value for the EnergyPlus actuator or schedule";
  output Modelica.SIunits.Time tNext "Next time that the actuator or schedule variable needs to be sent";

  external "C" WriterExchange(adapter, initialCall, tModel, u, tNext)
      annotation (
        IncludeDirectory="modelica://Buildings/Resources/C-Sources/EnergyPlus",
        Include="#include \"WriterExchange.c\"");

  annotation (Documentation(info="<html>
<p>
External function that sends data to an EnergyPlus actuator or schedule.
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
end writerExchange;
