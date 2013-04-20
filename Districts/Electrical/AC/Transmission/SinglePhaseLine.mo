within Districts.Electrical.AC.Transmission;
model SinglePhaseLine

  Districts.Electrical.AC.Interfaces.SinglePhasePlug A annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}}), iconTransformation(extent={{-120,-20},{-80,20}})));
  Districts.Electrical.AC.Interfaces.SinglePhasePlug B annotation (Placement(transformation(extent={{90,
            -10},{110,10}}), iconTransformation(extent={{80,-20},{120,20}})));
  Line phase(
    wireMaterial = material,
    Length=Length,
    P=P,
    V=V,
    useExtTemp=true)
    annotation (Placement(transformation(extent={{-20,0},{20,40}})));
  Line neutral(
    wireMaterial = material,
    Length=Length,
    P=P,
    V=V,
    useExtTemp=true)
    annotation (Placement(transformation(extent={{-20,-40},{20,0}})));
  parameter Modelica.SIunits.Distance Length(min=0) "Length of the line";
  parameter Modelica.SIunits.Power P(min=0) "Nominal power of the line";
  parameter Modelica.SIunits.Voltage V "Nominal voltage of the line";
  parameter Boolean useExtTemp = false
    "If =true, enables the input for the temperature of the cable" annotation(Dialog(tab="Model"));
  parameter Modelica.SIunits.Temperature Tcable = material.T0
    "Fixed temperature of the cable" annotation(Dialog(tab="Model", enable = not useExtTemp));

  Modelica.Blocks.Interfaces.RealInput T if useExtTemp
    "Temperature of the cable"                                                    annotation (
     Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,30})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=T_in)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  replaceable Districts.Electrical.AC.Transmission.Materials.Material material = Districts.Electrical.AC.Transmission.Functions.choseMaterial(0.0)
    annotation (Dialog(tab="Material"),Evaluate=true, choicesAllMatching=true, Placement(transformation(extent={{40,60},{60,80}})));
protected
  Modelica.Blocks.Interfaces.RealInput T_in;
equation

  if not useExtTemp then
    T_in = Tcable;
  end if;

  connect(A.p[1], phase.A) annotation (Line(
      points={{-100,8.88178e-16},{-60,8.88178e-16},{-60,20},{-20,20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(phase.B, B.p[1]) annotation (Line(
      points={{20,20},{60,20},{60,8.88178e-16},{100,8.88178e-16}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(A.n, neutral.A) annotation (Line(
      points={{-100,8.88178e-16},{-60,8.88178e-16},{-60,-20},{-20,-20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(neutral.B, B.n) annotation (Line(
      points={{20,-20},{60,-20},{60,8.88178e-16},{100,8.88178e-16}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(realExpression.y, phase.T) annotation (Line(
      points={{-39,50},{0,50},{0,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, neutral.T) annotation (Line(
      points={{-39,50},{-34,50},{-34,0},{0,0},{0,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(
          extent={{-80,20},{-40,-20}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,20},{60,-20}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{40,20},{80,-20}},
          lineColor={0,0,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-76,12},{-92,12}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-62,20},{58,20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-62,-20},{58,-20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-76,-12},{-92,-12}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{50,20},{70,0}},
          lineColor={0,0,0},
          fillColor={255,170,85},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{50,0},{70,-20}},
          lineColor={0,0,0},
          fillColor={255,170,85},
          fillPattern=FillPattern.Solid),
        Line(
          points={{96,12},{60,12}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{96,-12},{60,-12}},
          color={0,0,0},
          smooth=Smooth.None)}),    Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics));
end SinglePhaseLine;
