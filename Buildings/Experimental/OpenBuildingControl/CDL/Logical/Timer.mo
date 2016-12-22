within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block Timer
  "Timer measuring the time from the time instant where the Boolean input became true"

  extends Modelica.Blocks.Icons.PartialBooleanBlock;
  Modelica.Blocks.Interfaces.BooleanInput u
    "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  discrete Modelica.SIunits.Time entryTime "Time instant when u became true";
initial equation
  pre(entryTime) = 0;
equation
  when u then
    entryTime = time;
  end when;
  y = if u then time - entryTime else 0.0;
  annotation (
    Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={
      Line(points={{-90.0,-70.0},{82.0,-70.0}},
        color={192,192,192}),
      Line(points={{-80.0,68.0},{-80.0,-80.0}},
        color={192,192,192}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90.0,-70.0},{68.0,-62.0},{68.0,-78.0},{90.0,-70.0}}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
      Line(points={{-80.0,-70.0},{-60.0,-70.0},{-60.0,-26.0},{38.0,-26.0},{38.0,-70.0},{66.0,-70.0}},
        color={255,0,255}),
      Line(points={{-80.0,0.0},{-62.0,0.0},{40.0,90.0},{40.0,0.0},{68.0,0.0}},
        color={0,0,127})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Line(points={{-90,-70},{82,-70}}, color={0,
          0,0}),Line(points={{-80,68},{-80,-80}}),Polygon(
            points={{90,-70},{68,-62},{68,-78},{90,-70}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Polygon(
            points={{-80,90},{-88,68},{-72,68},{-80,90}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Line(points={{-80,-68},{-60,-68},{
          -60,-40},{20,-40},{20,-68},{60,-68}}, color={255,0,255}),Line(
          points={{-80,-20},{-60,-20},{20,60},{20,-20},{60,-20},{60,-20}},
          color={0,0,255}),Text(
            extent={{-88,6},{-54,-4}},
            lineColor={0,0,0},
            textString="y"),Text(
            extent={{48,-80},{84,-88}},
            lineColor={0,0,0},
            textString="time"),Text(
            extent={{-88,-36},{-54,-46}},
            lineColor={0,0,0},
            textString="u")}),
    Documentation(info="<html>
<p> When the Boolean input \"u\" becomes <b>true</b>, the timer is started
and the output \"y\" is the time from the time instant where u became true.
The timer is stopped and the output is reset to zero, once the
input becomes false.
</p>
</html>"));
end Timer;
