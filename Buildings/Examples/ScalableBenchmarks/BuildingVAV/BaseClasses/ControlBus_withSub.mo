within Buildings.Examples.ScalableBenchmarks.BuildingVAV.BaseClasses;
expandable connector ControlBus_withSub "Vector of SubControlBus"
  extends Modelica.Icons.SignalBus;
  parameter Integer nSubBus "Sub-bus used for sub-system control";

  Buildings.Examples.ScalableBenchmarks.BuildingVAV.BaseClasses.SubControlBus subBus[nSubBus]
    "Combined signal" annotation (HideResult=false);
  annotation (
    Documentation(info="<html>
<p>
This connector defines a vector of the <code>expandable connector</code> SubControlBus that
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
end ControlBus_withSub;
