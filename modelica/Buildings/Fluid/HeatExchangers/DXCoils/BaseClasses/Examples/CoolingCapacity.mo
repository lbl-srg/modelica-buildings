within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model CoolingCapacity "Test model for CoolingCapacity"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.GasesConstantDensity.MoistAirUnsaturated;
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacity cooCap(
    per={per},
    m_flow_small=0.0001*per.nomVal.m_flow_nominal,
    nSta=1) "Cooling capacity calculation"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    duration=2400,
    startTime=600,
    height=per.nomVal.m_flow_nominal,
    offset=0) "Mass flow rate of air"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica.Blocks.Sources.Ramp TWetBulIn(
    duration=2400,
    startTime=600,
    height=10,
    offset=273.15 + 19.4) "Air wet bulb temperature entring the coil"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Modelica.Blocks.Sources.IntegerStep onOff(startTime=600)
    "Compressor on-off signal"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Modelica.Blocks.Sources.Ramp TConIn(
    duration=2400,
    startTime=600,
    height=5,
    offset=273.15 + 30)
    "Condenser inlet temperature (Outside drybulb temperature)"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Data.BaseClasses.Generic per(
    nomVal(
      Q_flow_nominal=-21000,
      COP_nominal=3,
      SHR_nominal=0.8,
      m_flow_nominal=1.5),
    perCur=
        Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Curve_III(),
    spe=188.49555921539) "Performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

equation
  connect(TConIn.y, cooCap.TConIn) annotation (Line(
      points={{-59,20},{-46,20},{-46,4.8},{-21,4.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow.y, cooCap.m_flow) annotation (Line(
      points={{-59,-20},{-46,-20},{-46,6.10623e-16},{-21,6.10623e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TWetBulIn.y, cooCap.TIn) annotation (Line(
      points={{-59,-60},{-40,-60},{-40,-4.8},{-21,-4.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, cooCap.stage) annotation (Line(
      points={{-59,60},{-32,60},{-32,10},{-21,10}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/BaseClasses/Examples/CoolingCapacity.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of cooling capacity function 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacity\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacity</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 10, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end CoolingCapacity;
