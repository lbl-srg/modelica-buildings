within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
block SpeedRatioPass "Passes the speed ratio depending on the boolean input"
  extends Modelica.Blocks.Interfaces.BlockIcon;
    Modelica.Blocks.Interfaces.IntegerOutput mode
    "Mode of operation of heatpump (mode=0: off, mode=1: heating, mode=2: cooling)"
annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealInput heaSpeRat(final min=0)
    "Heating mode speed ratio"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput cooSpeRat(final min=0)
    "Heating mode speed ratio"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.BooleanInput heaModOn
    "Heating mode boolean input signal"   annotation (Placement(
        transformation(extent={{-140,80},{-100,120}}, rotation=0)));
    Modelica.Blocks.Interfaces.RealOutput speRat "Speed ratio of the heat pump"
annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.BooleanInput cooModOn
    "Cooling mode boolean input signal"   annotation (Placement(
        transformation(extent={{-140,-120},{-100,-80}},
                                                      rotation=0)));
algorithm
  assert(not (heaModOn and cooModOn), "Both speed ratios are greater that minimum speed ratio. Only one control input allowed to be non-zero at a time.");
  mode :=if heaModOn then 1 else if cooModOn then 2 else 0;
  speRat:=if mode == 0 then 0 else if heaModOn then heaSpeRat else cooSpeRat;
  annotation (defaultComponentName="speRatPas", Diagram(graphics), Documentation(info="<html>
<p>
This block takes both heating and cooling mode speed ratio values as input along with boolean signal and selects the mode. 
Only one input variable speed can operate the heat pump at a time, 
this block takes care of this issue by passing only one speed ratio forward.
At output, mode of operation is given out and for <i>mode</i> = 0 heat pump is off, 
<i>mode</i> = 1 indicates heating 
and <i>mode</i> = 2 indicates cooling operation. 
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 13, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"),Icon(graphics), Diagram(graphics));
end SpeedRatioPass;
