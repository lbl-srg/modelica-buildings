within Buildings.Experimental.ScalableModels.Controls;
expandable connector SubControlBus
  "Sub-control bus that is adapted to the signals connected to it"
  extends Modelica.Icons.SignalSubBus;
  Modelica.SIunits.Temperature TRooMin "Minimum temperature of multiple zones";
  Modelica.SIunits.Temperature TRooAve "Average temperature of multiple zones";
  Modelica.SIunits.Temperature TRooSetHea "Room heating setpoint temperature";
  Modelica.SIunits.Temperature TRooSetCoo "Room cooling setpoint temperature";
  Modelica.SIunits.Temperature TOut "Outdoor air temperature";
  Modelica.SIunits.Time dTNexOcc "Time to next occupancy period";
  Boolean occupied "Occupancy status";
  Integer controlMode "System operation modes";

  annotation (
    defaultComponentPrefixes="protected",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Rectangle(
                  extent={{-20,2},{22,-2}},
                  lineColor={255,204,51},
                  lineThickness=0.5)}),
    Documentation(info="<html>
<p>
This connector defines the <code>expandable connector</code> SubControlBus that
is used as sub-bus in the
<a href=\"modelica://Modelica.Blocks.Examples.BusUsage\">BusUsage</a> example.
Note, this is an expandable connector which has a <i>default</i> set of
signals (the input/output causalities of the signals are
determined from the connections to this bus).
</p>
</html>", revisions="<html>
<ul>
<li>
June 16, 2017, by Jianjun Hu:<br/>
First implementation.<br/>
</li>
</ul>
</html>"));

end SubControlBus;
