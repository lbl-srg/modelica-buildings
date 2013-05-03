within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
block SpeedRatioSelector
  "Selects speed ratio and decides mode of operation for heat pump"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  parameter Real cooModMinSpeRat(min=0,max=1)
    "Minimum speed ratio in cooling mode";
  parameter Real cooModSpeRatDeaBan= 0.05
    "Deadband for minimum speed ratio in cooling mode";
  parameter Real heaModMinSpeRat(min=0,max=1)
    "Minimum speed ratio in heating mode";
  parameter Real heaModSpeRatDeaBan= 0.05
    "Deadband for minimum speed ratio in heating mode";
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
protected
  Modelica.Blocks.Logical.Hysteresis heaDeaBan(uLow=heaModMinSpeRat, uHigh=
        heaModMinSpeRat + heaModSpeRatDeaBan)
    "Speed ratio deadband for heating mode"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
protected
  Modelica.Blocks.Logical.Hysteresis cooDeaBan(uLow=cooModMinSpeRat, uHigh=
        cooModMinSpeRat + cooModSpeRatDeaBan)
    "Speed ratio deadband for cooling mode"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
public
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.SpeedRatioPass speRatPas
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  connect(heaSpeRat, heaDeaBan.u) annotation (Line(
      points={{-120,50},{-62,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooSpeRat, cooDeaBan.u) annotation (Line(
      points={{-120,-50},{-62,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaDeaBan.y, speRatPas.heaModOn) annotation (Line(
      points={{-39,50},{-8,50},{-8,10},{18,10}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(cooDeaBan.y, speRatPas.cooModOn) annotation (Line(
      points={{-39,-50},{-10,-50},{-10,-10},{18,-10}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(heaSpeRat, speRatPas.heaSpeRat) annotation (Line(
      points={{-120,50},{-80,50},{-80,4},{18,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooSpeRat, speRatPas.cooSpeRat) annotation (Line(
      points={{-120,-50},{-80,-50},{-80,-4},{18,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRatPas.speRat, speRat) annotation (Line(
      points={{41,-4},{70,-4},{70,-40},{110,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRatPas.mode, mode) annotation (Line(
      points={{41,4},{70,4},{70,40},{110,40}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (defaultComponentName="speRatSel", Diagram(graphics), Documentation(info="<html>
<p>
This block is used in variable speed heat pump
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWaterHP.VariableSpeed\"> 
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWaterHP.VariableSpeed</a>. 
Variable speed heat pump has two speed ratio inputs, one for heating mode and another for cooling mode operation. 
This block takes both signals as input, uses deadband value for minimum speed ratio and decides mode of operation.
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
Jan 14, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"),Icon(graphics), Diagram(graphics));
end SpeedRatioSelector;
