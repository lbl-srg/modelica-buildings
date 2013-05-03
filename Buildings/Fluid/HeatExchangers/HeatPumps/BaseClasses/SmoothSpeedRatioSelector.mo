within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
block SmoothSpeedRatioSelector
  "Selects speed ratio and decides mode of operation for heat pump"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  parameter Real cooModMinSpeRat(min=0,max=1)
    "Minimum speed ratio in cooling mode";
//   parameter Real cooModSpeRatDeaBan= 0.05
//     "Deadband for minimum speed ratio in cooling mode";
  parameter Real heaModMinSpeRat(min=0,max=1)
    "Minimum speed ratio in heating mode";
//   parameter Real heaModSpeRatDeaBan= 0.05
//     "Deadband for minimum speed ratio in heating mode";

output Real smoHeaSpeRat "Smoothed heating mode speed ratio";
output Real smoCooSpeRat "Smoothed Cooling mode speed ratio";
  constant Real deltax=0.01;
    Modelica.Blocks.Interfaces.IntegerOutput mode
    "Mode of operation of heatpump (mode=0: off, mode=1: heating, mode=2: cooling)"
annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealInput heaSpeRat(final min=0)
    "Heating mode speed ratio"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput cooSpeRat(final min=0)
    "Heating mode speed ratio"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
    Modelica.Blocks.Interfaces.RealOutput speRat "Speed ratio of the heat pump"
annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
equation
  assert(not (smoHeaSpeRat>0 and smoCooSpeRat>0), "Both speed ratios are greater that minimum speed ratio. Any one speed ratio input can drive the heat pump at a time.");
  mode = if smoHeaSpeRat>0 then 1 else if smoCooSpeRat>0 then 2 else 0;
  speRat= if mode == 0 then 0 else if smoHeaSpeRat>0 then smoHeaSpeRat else smoCooSpeRat;

  smoHeaSpeRat= Buildings.Utilities.Math.Functions.spliceFunction(
    pos=heaSpeRat,
    neg=0,
    x=heaSpeRat - heaModMinSpeRat,
    deltax=deltax);
  smoCooSpeRat= Buildings.Utilities.Math.Functions.spliceFunction(
    pos=cooSpeRat,
    neg=0,
    x=cooSpeRat - cooModMinSpeRat,
    deltax=deltax);
  annotation (defaultComponentName="speRatSel", Diagram(graphics), Documentation(info="<html>
<p>
This block indentifies the mode of operation of the heat pump. mode = 1 indicates heating and mode = 2 indicate cooling operation. 
This block also provides an output for indepent value required for splice function.
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 09, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"),Icon(graphics), Diagram(graphics));
end SmoothSpeedRatioSelector;
