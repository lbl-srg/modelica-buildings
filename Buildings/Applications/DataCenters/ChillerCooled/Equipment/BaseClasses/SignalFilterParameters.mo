within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
record SignalFilterParameters
  "Record that contains the parameters of the filtered opening for multiple valves and dampers"
  parameter Integer numAct(min=1)=4 "Number of filters";
  parameter Boolean use_strokeTime=false
    "= true, if opening is filtered to avoid a step change in actuator position"
    annotation(Dialog(tab="Dynamics", group=
          "Time needed to open or close valve"));

  parameter Modelica.Units.SI.Time strokeTime=30
    "Time needed to open or close valve"
    annotation (Dialog(
      tab="Dynamics",
      group="Time needed to open or close valve",
      enable=use_strokeTime));
  parameter Modelica.Blocks.Types.Init initValve=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Time needed to open or close valve",enable=use_strokeTime));
  parameter Real[numAct] yValve_start=fill(1,numAct)
    "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Time needed to open or close valve",enable=use_strokeTime));
  annotation (    Documentation(revisions="<html>
<ul>
<li>
August 26, 2024, by Michael Wetter:<br/>
Implemented linear actuator travel dynamics.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3965\">Buildings, #3965</a>.
</li>
<li>
November 15, 2022, by Michael Wetter:<br/>
Change <code>strokeTime</code> to 30 seconds so that it is the same as for pumps.
Otherwise, pumps may work against almost closed valves.
</li>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>
Record that contains essential parameters for the vectored signal filters.
The number of filters is specified by <code>nFilter</code>.
</p>
<p>
Note that all the signal filters have the same on/off control signal, rising time, and initialization type,
which are specified by <code>use_strokeTime, strokeTime</code> and <code>initValve</code> respectively.
However, they can have different initial valves, specified by <code>yValve_start</code>.
</p>
</html>"));
end SignalFilterParameters;
