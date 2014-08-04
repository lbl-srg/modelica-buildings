within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion;
model ACACTransformerDD
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses.PartialConverterDD(
    redeclare Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer conv1(
      XoverR=XoverR,
      Zperc=Zperc,
      ground_1=ground_1,
      ground_2=ground_2,
      VABase=VABase/3,
      VHigh=VHigh,
      VLow=VLow,
      phi_1=0.5235987755983),
    redeclare Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer conv2(
      XoverR=XoverR,
      Zperc=Zperc,
      ground_1=ground_1,
      ground_2=ground_2,
      VABase=VABase/3,
      VHigh=VHigh,
      VLow=VLow,
      phi_1=-1.5707963267949),
    redeclare Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer conv3(
      XoverR=XoverR,
      Zperc=Zperc,
      ground_1=ground_1,
      ground_2=ground_2,
      VABase=VABase/3,
      VHigh=VHigh,
      VLow=VLow,
      phi_1=2.6179938779915));
  parameter Modelica.SIunits.Voltage VHigh
    "Rms voltage on side 1 of the transformer (primary side)";
  parameter Modelica.SIunits.Voltage VLow
    "Rms voltage on side 2 of the transformer (secondary side)";
  parameter Modelica.SIunits.ApparentPower VABase
    "Nominal power of the transformer";
  parameter Real XoverR
    "Ratio between the complex and real components of the impedance (XL/R)";
  parameter Real Zperc "Short circuit impedance";
  parameter Boolean ground_1 = false "Connect side 1 of transformer to ground" annotation(Dialog(tab = "Ground", group="side 1"));
  parameter Boolean ground_2 = true "Connect side 2 of transformer to ground" annotation(Dialog(tab = "Ground", group="side 2"));
equation

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
        Text(
          extent={{-100,-60},{100,-92}},
          lineColor={0,120,120},
          textString="%name"),
        Text(
          extent={{-130,60},{-70,20}},
          lineColor={11,193,87},
          textString="1"),
        Text(
          extent={{-130,100},{-70,60}},
          lineColor={11,193,87},
          textString="AC"),
        Text(
          extent={{70,100},{130,60}},
          lineColor={0,120,120},
          textString="AC"),
        Text(
          extent={{70,60},{130,20}},
          lineColor={0,120,120},
          textString="2"),
        Line(
          points={{-80,-40},{-120,-40}},
          color=DynamicSelect({0,120,120}, if ground_1 then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-80,-40},{-106,-14}},
          color=DynamicSelect({0,120,120}, if ground_1 then {0,120,120} else {255,
              255,255}),
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-102,-16},{-114,-24},{-118,-42}},
          color=DynamicSelect({0,120,120}, if ground_1 then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.Bezier),
        Line(
          points={{80,-40},{120,-40}},
          color=DynamicSelect({0,120,120}, if ground_2 then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{80,-40},{106,-14}},
          color=DynamicSelect({0,120,120}, if ground_2 then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{102,-16},{114,-24},{118,-42}},
          color=DynamicSelect({0,120,120}, if ground_2 then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.Bezier),
        Line(
          points={{-72,40},{-66,40},{-64,44},{-60,36},{-56,44},{-52,36},{-48,44},
              {-44,36},{-42,40},{-38,40}},
          color={0,127,127},
          smooth=Smooth.None),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-60,-7.34764e-15}},
          color={0,127,127},
          origin={-40,40},
          rotation=180),
        Ellipse(
          extent={{-30,46},{-18,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-18,46},{-6,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-6,46},{6,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,40},{6,28}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{20,40},{20,20}},
          color={0,127,127},
          smooth=Smooth.None),
        Ellipse(
          extent={{14,20},{26,8}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{14,8},{26,-4}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{14,-4},{26,-16}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,20},{20,-16}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{20,-16},{20,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{20,-40},{-70,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{34,40},{34,20}},
          color={0,127,127},
          smooth=Smooth.None),
        Ellipse(
          extent={{40,20},{28,8}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{40,8},{28,-4}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{40,-4},{28,-16}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{44,20},{34,-16}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{34,-16},{34,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{70,-40},{34,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{70,40},{34,40}},
          color={0,127,127},
          smooth=Smooth.None),
        Text(
          extent={{-64,60},{-48,48}},
          lineColor={0,120,120},
          textString="R"),
        Text(
          extent={{-20,60},{-4,48}},
          lineColor={0,120,120},
          textString="L"),
        Line(
          points={{-50,-8},{-30,22},{-10,-8},{-50,-8}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{40,-8},{60,22},{80,-8},{40,-8}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5)}));
end ACACTransformerDD;
