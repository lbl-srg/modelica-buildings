within Buildings.Fluid.DataCenterEquipment.Racks.FanControllers;
model Load
  "Controller for fan that regulates speed based on load signal"

  parameter Modelica.Units.SI.HeatFlowRate P_nominal(min=0)
    "IT power consumption at u=1, also called Thermal Design Power (TDP)"
    annotation (Dialog(group="Nominal condition"));

  parameter Real fanSpeed[:,:]=[0.0,0.0; 1.0,1.0]
    "Table matrix (1st column normalized IT load, 2nd fan speed, e.g., fanSpeed=[0, 0; 0.5, 0.7; 1, 1])";

  Modelica.Blocks.Interfaces.RealInput P(final unit="W", min=0)
    "Electrical power consumption of IT" annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-120,-10},
            {-100,10}})));

  Controls.OBC.CDL.Interfaces.RealOutput y "Fan control signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

    Controls.OBC.CDL.Reals.MultiplyByParameter nor(
    k=1/P_nominal,
    u(final unit="W"),
    y(final unit="1")) "Normalized IT power"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

protected
  Modelica.Blocks.Tables.CombiTable1Ds tab(
    tableOnFile=false,
    table=fanSpeed,
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    verboseExtrapolation=false) "Table look-up"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation

  connect(nor.y, tab.u)
    annotation (Line(points={{-38,0},{18,0}}, color={0,0,127}));
  connect(tab.y[1], y)
    annotation (Line(points={{41,0},{120,0}}, color={0,0,127}));
  connect(nor.u, P)
    annotation (Line(points={{-62,0},{-120,0}}, color={0,0,127}));
  annotation (
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{38,-44},{90,-92}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{56,-46},{56,-90},{91,-68},{56,-46}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Line(points={{-120,0},{-36,0}},   color={0,0,127}),
        Text(
          extent={{74,38},{92,8}},
          textColor={0,0,127},
          textString="y"),
        Text(
          extent={{104,44},{156,2}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3))),
        Text(
          extent={{-100,36},{-70,6}},
          textColor={0,0,127},
          textString="P"),
        Line(points={{24,0},{100,0}},     color={0,0,127}),
    Line(points={{24,40},{24,-40}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-36,20},{-6,40}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-36,0},{-6,20}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-36,-20},{-6,0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-36,-40},{-6,-20}}),
        Line(points={{-36,0},{24,0}},     color={0,0,127}),
        Line(points={{-36,-20},{24,-20}}, color={0,0,127}),
        Line(points={{-36,-40},{24,-40}}, color={0,0,127}),
        Line(points={{-36,40},{24,40}},   color={0,0,127}),
        Line(points={{-36,20},{24,20}},   color={0,0,127})}),
    defaultComponentName="con",
    Documentation(
      info="<html>
<p>
Controller that outputs fan speed based on IT load.
<p>
The controller computes the normalized IT load based on <code>PIT_nominal</code>,
and then does a table look-up to compute the speed.
If the normalized fan speed signal is outside <i>0...1</i>, the controller will saturate
the signal, e.g., there is no table extrapolation.
</html>",
      revisions="<html>
<ul>
<li>
September 21, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Load;
