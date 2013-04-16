within Districts.Electrical.AC.Interfaces;
model Adaptor
  "Model that allows the connection between three phases connector to single ones"

  Districts.Electrical.AC.Interfaces.ThreePhasePlug threePhasePlug annotation (Placement(
        transformation(extent={{-100,-10},{-80,10}}), iconTransformation(extent=
           {{-100,-20},{-60,20}})));
  Districts.Electrical.AC.Interfaces.SinglePhasePlug phase1 annotation (Placement(
        transformation(extent={{60,40},{80,60}}), iconTransformation(extent={{
            80,40},{120,80}})));
  Districts.Electrical.AC.Interfaces.SinglePhasePlug phase2 annotation (Placement(
        transformation(extent={{60,-10},{80,10}}), iconTransformation(extent={{
            80,-20},{120,20}})));
  Districts.Electrical.AC.Interfaces.SinglePhasePlug phase3 annotation (Placement(
        transformation(extent={{60,-60},{80,-40}}), iconTransformation(extent={
            {80,-80},{120,-40}})));
equation

  connect(threePhasePlug.n, phase3.n) annotation (Line(
      points={{-90,8.88178e-16},{-10,8.88178e-16},{-10,-50},{70,-50}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(threePhasePlug.n, phase2.n) annotation (Line(
      points={{-90,8.88178e-16},{-10,8.88178e-16},{-10,8.88178e-16},{70,
          8.88178e-16}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(threePhasePlug.n, phase1.n) annotation (Line(
      points={{-90,8.88178e-16},{-10,8.88178e-16},{-10,50},{70,50}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(threePhasePlug.p[1], phase1.p[1]) annotation (Line(
      points={{-90,8.88178e-16},{-10,8.88178e-16},{-10,50},{70,50}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(threePhasePlug.p[2], phase2.p[1]) annotation (Line(
      points={{-90,8.88178e-16},{-10,8.88178e-16},{-10,4.44089e-16},{70,
          4.44089e-16}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(threePhasePlug.p[3], phase3.p[1]) annotation (Line(
      points={{-90,8.88178e-16},{-10,8.88178e-16},{-10,-50},{70,-50}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-80,80},{100,-80}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}), Diagram(coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}}), graphics));
end Adaptor;
