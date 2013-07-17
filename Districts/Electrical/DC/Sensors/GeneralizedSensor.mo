within Districts.Electrical.DC.Sensors;
model GeneralizedSensor
  extends Districts.Electrical.Interfaces.PartialTwoPort;
  Modelica.Blocks.Interfaces.RealOutput V "Voltage"           annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,-50}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-90})));
  Modelica.Blocks.Interfaces.RealOutput I "Current"           annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,-50}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,-90})));
equation
  V = terminal_n.PhaseSystem.systemVoltage(terminal_n.v);
  I = terminal_n.PhaseSystem.systemCurrent(terminal_n.i);
  connect(terminal_n, terminal_p) annotation (Line(
      points={{-100,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-70,28},{70,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-92,0},{-70,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-60,100},{60,60}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="P,V,I"),
        Polygon(
          points={{-0.48,33.6},{18,28},{18,59.2},{-0.48,33.6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-37.6,15.7},{-54,22}},     color={0,0,0}),
        Line(points={{-22.9,34.8},{-32,50}},     color={0,0,0}),
        Line(points={{0,60},{0,42}}, color={0,0,0}),
        Line(points={{22.9,34.8},{32,50}},     color={0,0,0}),
        Line(points={{37.6,15.7},{54,24}},     color={0,0,0}),
        Line(points={{0,2},{9.02,30.6}}, color={0,0,0}),
        Ellipse(
          extent={{-5,7},{5,-3}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{70,0},{92,0}},
          color={0,0,0},
          smooth=Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics));
end GeneralizedSensor;
