within Buildings.Templates.Components.Valve;
model EqualPercentage
  extends Buildings.Templates.Components.Valve.Interfaces.Valve(final typ=
        Buildings.Templates.Components.Types.Valve.EqualPercentage);
  Fluid.Actuators.Valves.TwoWayEqualPercentage val
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_a, val.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(val.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(busCon.out.y, val.y) annotation (Line(
      points={{0,100},{0,80},{-20,80},{-20,40},{0,40},{0,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(val.y_actual, busCon.y_actual) annotation (Line(points={{5,7},{20,
          7},{20,80},{0,80},{0,100}},          color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(graphics={                                             Line(
          points={{-100,0},{-60,0}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{-60,40},{-60,-40}},
          color={175,175,175},
          thickness=0.5),
        Line(
          points={{60,40},{60,-40}},
          color={175,175,175},
          thickness=0.5),
        Line(
          points={{-60,40},{60,-40}},
          color={175,175,175},
          thickness=0.5),
        Line(
          points={{-60,-40},{60,40}},
          color={175,175,175},
          thickness=0.5),
        Line(
          points={{-78,0}},
          color={175,175,175},
          thickness=0.5),                                                 Line(
          points={{60,0},{100,0}},
          color={28,108,200},
          thickness=1)}));
end EqualPercentage;
