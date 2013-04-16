within Districts.Electrical.AC.Sensors;
model GeneralizedSensor
  extends Districts.Electrical.AC.Loads.BaseClasses.GeneralizedOnePhaseModel(final measureP = true);
  Districts.Electrical.AC.Interfaces.SinglePhasePlug loads          annotation (Placement(
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{
            80,-20},{120,20}})));
equation


  connect(sPhasePlug.p, loads.p) annotation (Line(
      points={{-100,8.88178e-16},{0,8.88178e-16},{0,4.44089e-16},{100,
          4.44089e-16}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(sPhasePlug.n, loads.n) annotation (Line(
      points={{-100,8.88178e-16},{0,8.88178e-16},{0,8.88178e-16},{100,
          8.88178e-16}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Rectangle(
          extent={{-80,40},{80,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-92,0},{-80,0}},
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
          points={{80,0},{92,0}},
          color={0,0,0},
          smooth=Smooth.None)}),    Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end GeneralizedSensor;
