within Buildings.Experimental.OpenBuildingControl.CDL.Discrete;
block TriggeredMax
  "Compute maximum, absolute value of continuous signal at trigger instants"

  extends Modelica.Blocks.Icons.DiscreteBlock;
  Modelica.Blocks.Interfaces.RealInput u "Connector with a Real input signal"
                                         annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    "Connector with a Real output signal" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.BooleanInput trigger annotation (Placement(
        transformation(
        origin={0,-118},
        extent={{-20,-20},{20,20}},
        rotation=90)));
equation
  when trigger then
     y = max(pre(y), abs(u));
  end when;
initial equation
  y = 0;
  annotation (
    Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={
      Ellipse(lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        extent={{25.0,-10.0},{45.0,10.0}}),
      Line(points={{-100.0,0.0},{-45.0,0.0}},
        color={0,0,127}),
      Line(points={{45.0,0.0},{100.0,0.0}},
        color={0,0,127}),
      Line(points={{0.0,-100.0},{0.0,-26.0}},
        color={255,0,255}),
      Line(points={{-35.0,0.0},{28.0,-48.0}},
        color={0,0,127}),
      Text(extent={{-86.0,24.0},{82.0,82.0}},
        color={0,0,127},
        textString="max"),
      Ellipse(lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        extent={{-45.0,-10.0},{-25.0,10.0}})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Ellipse(
          extent={{-25,-10},{-45,10}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{45,-10},{25,10}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,0},{-45,0}}, color={0,0,255}),
        Line(points={{45,0},{100,0}}, color={0,0,255}),
        Line(points={{-35,0},{28,-48}}, color={0,0,255}),
        Line(points={{0,-100},{0,-26}}, color={255,0,255})}),
    Documentation(info="<html>
<p>
Samples the continuous input signal whenever the trigger input
signal is rising (i.e., trigger changes from <code>false</code> to
<code>true</code>). The maximum, absolute value of the input signal
at the sampling point is provided as output signal.
</p>
</html>"));
end TriggeredMax;
