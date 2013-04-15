within Districts.Electrical.AC.Interfaces;
model Adaptor
  "Model that allows the connection between three phases connector to single ones"
  TryElectric.Interfaces.ThreePhasePlug threePhasePlug annotation (Placement(
        transformation(extent={{-100,-10},{-80,10}}), iconTransformation(extent
          ={{-100,-20},{-60,20}})));
  TryElectric.Interfaces.SinglePhasePlug phase1 annotation (Placement(
        transformation(extent={{60,40},{80,60}}), iconTransformation(extent={{
            80,40},{120,80}})));
  TryElectric.Interfaces.SinglePhasePlug phase2 annotation (Placement(
        transformation(extent={{60,-10},{80,10}}), iconTransformation(extent={{
            80,-20},{120,20}})));
  TryElectric.Interfaces.SinglePhasePlug phase3 annotation (Placement(
        transformation(extent={{60,-60},{80,-40}}), iconTransformation(extent={
            {80,-80},{120,-40}})));
equation
  connect(threePhasePlug.neutral, phase2.neutral) annotation (Line(
      points={{-90,8.88178e-16},{-9,8.88178e-16},{-9,8.88178e-16},{70,
          8.88178e-16}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(threePhasePlug.neutral, phase3.neutral) annotation (Line(
      points={{-90,4.44089e-16},{0,4.44089e-16},{0,-50},{2,-50},{2,-50},{70,-50}},

      color={0,0,255},
      smooth=Smooth.None));
  connect(threePhasePlug.neutral, phase1.neutral) annotation (Line(
      points={{-90,4.44089e-16},{0,4.44089e-16},{0,0},{0,0},{0,50},{70,50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(threePhasePlug.phase[1], phase1.phase[1]) annotation (Line(
      points={{-90,4.44089e-16},{-60,4.44089e-16},{-60,0},{-60,0},{-60,50},{70,
          50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(threePhasePlug.phase[2], phase2.phase[1]) annotation (Line(
      points={{-90,4.44089e-16},{-28,0},{70,4.44089e-16}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(threePhasePlug.phase[3], phase3.phase[1]) annotation (Line(
      points={{-90,8.88178e-16},{-60,8.88178e-16},{-60,-50},{70,-50}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-80,80},{100,-80}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}}), graphics));
end Adaptor;
