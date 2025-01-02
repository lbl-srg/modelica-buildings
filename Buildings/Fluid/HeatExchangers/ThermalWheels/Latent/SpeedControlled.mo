within Buildings.Fluid.HeatExchangers.ThermalWheels.Latent;
model SpeedControlled
  "Enthalpy recovery wheel with a variable speed drive"
  extends Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses.PartialWheel;
  parameter
    Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Generic
    per
    "Record with performance data"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSpe(
    final unit="1",
    final max=1)
    "Wheel speed ratio"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Latent
    latWhe(final per=per)
    "Correct the wheel performance based on the wheel speed"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Correct the sensible heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul1
    "Correct the latent heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));

equation
  connect(hex.port_a2, port_a2)
    annotation (Line(points={{30,-6},{40,-6},{40,-80},{100,-80}},
    color={0,127,255},
      thickness=0.5));
  connect(hex.port_a1, port_a1)
    annotation (Line(points={{10,6},{-32,6},{-32,80},{-180,80}},  color={0,127,255},
      thickness=0.5));
  connect(latWhe.epsSenCor, mul.u1) annotation (Line(points={{-98,120},{-80,120},
          {-80,146},{-62,146}}, color={0,0,127}));
  connect(latWhe.epsLatCor, mul1.u1) annotation (Line(points={{-98,112},{-80,112},
          {-80,106},{-62,106}}, color={0,0,127}));
  connect(effCal.epsSen, mul.u2) annotation (Line(points={{-78,5},{-70,5},{-70,134},
          {-62,134}}, color={0,0,127}));
  connect(effCal.epsLat, mul1.u2) annotation (Line(points={{-78,-5},{-64,-5},{-64,
          94},{-62,94}}, color={0,0,127}));
  connect(mul.y, hex.epsSen)
    annotation (Line(points={{-38,140},{0,140},{0,3},{8,3}}, color={0,0,127}));
  connect(hex.epsLat, mul1.y) annotation (Line(points={{8,-3},{-20,-3},{-20,100},
          {-38,100}}, color={0,0,127}));
  connect(mul.y, epsSen) annotation (Line(points={{-38,140},{20,140},{20,40},{
          120,40}},color={0,0,127}));
  connect(mul1.y, epsLat) annotation (Line(points={{-38,100},{90,100},{90,0},{
          120,0}},color={0,0,127}));
  connect(latWhe.P, P) annotation (Line(points={{-98,128},{-88,128},{-88,40},{
          -46,40},{-46,-40},{120,-40}},color={0,0,127}));
  connect(latWhe.uSpe, uSpe) annotation (Line(points={{-122,120},{-168,120},{-168,
          0},{-200,0}}, color={0,0,127}));
annotation (
   defaultComponentName="whe",Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
   graphics={
        Polygon(
          points={{0,100},{0,100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.None)}),
          Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{100,160}})),
Documentation(info="<html>
<p>
Model of an enthalpy recovery wheel, which has the 
wheel speed as the input to control the heat recovery.
</p>
<p>
This model does not require geometric data. The performance is defined by specifying
the part load (75% of the nominal supply flow rate) and nominal sensible and latent
heat exchanger effectiveness in both heating and cooling conditions.
</p>
<p>
The operation of the heat recovery wheel is adjustable by modulating the wheel speed.
See details about the impacts of the wheel speed in 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Latent\">
Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Latent</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 29, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpeedControlled;
