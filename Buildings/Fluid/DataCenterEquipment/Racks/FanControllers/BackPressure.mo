within Buildings.Fluid.DataCenterEquipment.Racks.FanControllers;
model BackPressure
  "Controller for fan that regulates speed to attain zero back pressure"

  parameter Real k(
    final unit="1",
    min=Modelica.Constants.small) = 1
    "Gain of PI controller"
    annotation(Dialog(group="Controller"));

  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 60
    "Integrator time constant of PI controller"
    annotation(Dialog(group="Controller"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput pMea(
    final unit="Pa")
    "Measured pressure at inlet of rear door heat exchanger"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput pSet(
    final unit="Pa") "Set point for inlet air pressure"
    annotation (Placement(
      transformation(
        origin={-120,0},
        extent={{-20,-20},{20,20}}),
      iconTransformation(
        origin={-120,0},
        extent={{-20,-20},{20,20}})));

  Buildings.Controls.OBC.CDL.Reals.PID con(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=k,
    final Ti=Ti,
    r(final unit="Pa") = 10,
    final reverseActing=false,
    u_s(final unit="Pa"),
    u_m(final unit="Pa"))
    "Fan speed PI controller"
    annotation (Placement(transformation(
      origin={0,50},
      extent={{-10,-60},{10,-40}})));

  Controls.OBC.CDL.Interfaces.RealOutput y "Fan control signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  connect(pSet, con.u_s)
    annotation (Line(points={{-120,0},{-12,0}},   color={0,0,127}));

  connect(pMea, con.u_m)
    annotation (Line(points={{0,-120},{0,-12}}, color={0,0,127}));
  connect(con.y, y) annotation (Line(points={{12,0},{120,0}}, color={0,0,127}));
  annotation (
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{40,-44},{92,-92}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{56,-46},{56,-90},{91,-68},{56,-46}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Rectangle(
          extent={{-36,32},{44,-28}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-36,32},{-36,-28},{-4,2},{-36,32}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,0},{-36,0}},   color={0,0,127}),
        Text(
          extent={{74,38},{92,8}},
          textColor={0,0,127},
          textString="y"),
        Text(
          extent={{104,44},{156,2}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(con.y,
            leftJustified=false,
            significantDigits=3))),
        Text(
          extent={{-96,40},{-56,-8}},
          textColor={0,0,127},
          textString="pSet"),
        Text(
          extent={{-48,-62},{-8,-110}},
          textColor={0,0,127},
          textString="pMea"),
        Line(points={{0,-100},{0,-28}},   color={0,0,127}),
        Line(points={{44,0},{108,0}},     color={0,0,127})}),
    defaultComponentName="con",
    Documentation(
      info="<html>
<p>
PI-controller to regulate a fan to attain zero back pressure.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 15, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BackPressure;
