within Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible;
model SpeedControlled
  "Sensible heat recovery wheel with a variable speed drive"
  extends
    Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses.PartialWheel;
  parameter
    Buildings.Fluid.HeatExchangers.BaseClasses.VariableSpeedThermalWheels.BaseClasses.Data.Generic
    per "Record with performance data"
    annotation (Placement(transformation(extent={{28,78},{48,98}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSpe(
    final unit="1",
    final max=1)
    "Wheel speed ratio"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Fluid.HeatExchangers.BaseClasses.VariableSpeedThermalWheels.Sensible
    senWhe(final per=per)
    "Correct the wheel performance based on the wheel speed"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Correct the heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{-54,-24},{-34,-4}})));


equation
  connect(port_a1, hex.port_a1) annotation (Line(points={{-180,80},{-60,80},{-60,6},
    {-10,6}}, color={0,127,255}));
  connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{60,-6},{60,
          -80},{100,-80}},
                color={0,127,255}));
  connect(senWhe.epsSenCor, mul.u2) annotation (Line(points={{-118,-80},{-64,-80},
          {-64,-20},{-56,-20}}, color={0,0,127}));
  connect(effCal.eps, mul.u1) annotation (Line(points={{-78,0},{-64,0},{-64,-8},
          {-56,-8}}, color={0,0,127}));
  connect(mul.y, hex.eps) annotation (Line(points={{-32,-14},{-20,-14},{-20,0},{
          -12,0}}, color={0,0,127}));
  connect(uSpe, senWhe.uSpe) annotation (Line(points={{-200,0},{-170,0},{-170,-80},
          {-142,-80}}, color={0,0,127}));
  connect(senWhe.P, P) annotation (Line(points={{-118,-72},{40,-72},{40,-40},{
          120,-40}}, color={0,0,127}));
  connect(eps, mul.y) annotation (Line(points={{120,40},{80,40},{80,-14},{-32,
          -14}},
        color={0,0,127}));
annotation (
        defaultComponentName="whe",
        Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
    graphics={
        Polygon(
          points={{0,100},{0,100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.None)}),
          Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{100,100}})),
Documentation(info="<html>
<p>
Model of a generic, sensible heat recovery wheel, which has the 
wheel speed as the input to control the heat recovery.
</p>
<p>
This model does not require geometric data. The performance is defined by specifying
the part load (75% of the nominal supply flow rate) and nominal sensible heat
exchanger effectiveness in both heating and cooling conditions.
</p>
<p>
The operation of the heat recovery wheel is adjustable by modulating the wheel speed.
See details about the impacts of the wheel speed in 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.VariableSpeedThermalWheels.Sensible\">
Buildings.Fluid.HeatExchangers.BaseClasses.VariableSpeedThermalWheels.Sensible</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 8, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpeedControlled;
