within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
record SignalFilterParameters
  "Record that contains the parameters of the filtered opening for multiple valves and dampers"
  parameter Integer numFil(min=1)=4 "Number of filters";
  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered opening"));
  parameter Modelica.Units.SI.Time riseTimeValve=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init initValve=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  parameter Real[numFil] yValve_start=fill(1,numFil)
    "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  annotation (    Documentation(revisions="<html>
<ul>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
Record that contains essential parameters for the vectored signal filters.
The number of filters is specified by <code>nFilter</code>.
<p>
Note that all the signal filters have the same on/off control signal, rising time, and initialization type,
which are specified by <code>use_inputFilter, riseTimeValve</code> and <code>initValve</code> respectively.
However, they can have different initial valves, specified by <code>yValve_start</code>.
</p>
</html>"));
end SignalFilterParameters;
