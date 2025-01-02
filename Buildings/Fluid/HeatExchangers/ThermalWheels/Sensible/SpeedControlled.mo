within Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible;
model SpeedControlled
  "Sensible heat recovery wheel with a variable speed drive"
  extends Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses.PartialWheel;
  parameter Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Generic per
    "Record with performance data"
    annotation (Placement(transformation(extent={{28,78},{48,98}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSpe(
    final unit="1",
    final max=1)
    "Wheel speed ratio"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Sensible
    senWhe(final per=per)
    "Correct the wheel performance based on the wheel speed"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Calculate the heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

equation
  connect(port_a1, hex.port_a1) annotation (Line(points={{-180,80},{-60,80},{-60,6},
    {-10,6}}, color={0,127,255},
      thickness=0.5));
  connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{60,-6},{60,
          -80},{100,-80}}, color={0,127,255},
      thickness=0.5));
  connect(senWhe.epsSenCor, mul.u2) annotation (Line(points={{-138,0},{-114,0},{
          -114,-16},{-62,-16}}, color={0,0,127}));
  connect(effCal.eps, mul.u1) annotation (Line(points={{-78,0},{-70,0},{-70,-4},
          {-62,-4}}, color={0,0,127}));
  connect(mul.y, hex.eps) annotation (Line(points={{-38,-10},{-20,-10},{-20,0},{
          -12,0}}, color={0,0,127}));
  connect(uSpe, senWhe.uSpe) annotation (Line(points={{-200,0},{-162,0}},
          color={0,0,127}));
  connect(senWhe.P, P) annotation (Line(points={{-138,8},{-134,8},{-134,68},{88,
          68},{88,-40},{120,-40}}, color={0,0,127}));
  connect(eps, mul.y) annotation (Line(points={{120,40},{80,40},{80,-20},{-20,-20},
          {-20,-10},{-38,-10}},      color={0,0,127}));
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
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Sensible\">
Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Sensible</a>.
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
