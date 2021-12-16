within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion;
model ACACTransformerStepUpDY
  "AC AC transformer simplified equivalent circuit (DY step up)"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses.PartialConverterStepUpDY(
    redeclare Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer conv1(
      VHigh=VHigh,
      XoverR=XoverR,
      Zperc=Zperc,
      ground_1=ground_1,
      ground_2=ground_2,
      VABase=VABase/3,
      VLow=VLow/sqrt(3),
      phi_1=0.5235987755983),
    redeclare Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer conv2(
      VHigh=VHigh,
      XoverR=XoverR,
      Zperc=Zperc,
      ground_1=ground_1,
      ground_2=ground_2,
      VABase=VABase/3,
      VLow=VLow/sqrt(3),
      phi_1=-1.5707963267949),
    redeclare Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer conv3(
      VHigh=VHigh,
      XoverR=XoverR,
      Zperc=Zperc,
      ground_1=ground_1,
      ground_2=ground_2,
      VABase=VABase/3,
      VLow=VLow/sqrt(3),
      phi_1=2.6179938779915));
  parameter Modelica.Units.SI.Voltage VHigh
    "Rms voltage on side 1 of the transformer (primary side)";
  parameter Modelica.Units.SI.Voltage VLow
    "Rms voltage on side 2 of the transformer (secondary side)";
  parameter Modelica.Units.SI.ApparentPower VABase
    "Nominal power of the transformer";
  parameter Real XoverR
    "Ratio between the complex and real components of the impedance (XL/R)";
  parameter Real Zperc "Short circuit impedance";
  parameter Boolean ground_1 = false "Connect side 1 of transformer to ground" annotation(Dialog(tab = "Ground", group="side 1"));
  parameter Boolean ground_2 = true "Connect side 2 of transformer to ground" annotation(Dialog(tab = "Ground", group="side 2"));
equation

  annotation (
  defaultComponentName="tra",
 Icon(graphics={
        Text(
          extent={{-100,-60},{100,-92}},
          textColor={0,0,0},
          textString="%name"),
        Text(
          extent={{-130,60},{-70,20}},
          textColor={11,193,87},
          textString="1"),
        Text(
          extent={{-130,100},{-70,60}},
          textColor={11,193,87},
          textString="AC"),
        Text(
          extent={{70,100},{130,60}},
          textColor={0,120,120},
          textString="AC"),
        Text(
          extent={{70,60},{130,20}},
          textColor={0,120,120},
          textString="2"),
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
          textColor={0,120,120},
          textString="R"),
        Text(
          extent={{-20,60},{-4,48}},
          textColor={0,120,120},
          textString="L"),
        Line(
          points={{60,26},{60,6},{46,-8}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{60,6},{74,-8}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-52,-6},{-32,24},{-12,-6},{-52,-6}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{0,60},{32,92}},
          color={0,120,120},
          smooth=Smooth.None),
        Polygon(
          points={{34,88},{40,100},{28,94},{34,88}},
          lineColor={0,120,120},
          smooth=Smooth.None,
          fillColor={0,120,120},
          fillPattern=FillPattern.Solid)}),
    Documentation(revisions="<html>
<ul>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
June 6, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This is a simplified equivalent transformer model with Delta-Y connection
(voltage step up).
The model accounts for winding Joule losses and leakage reactances
that are represented by a series of a resistance <i>R</i> and an
inductance <i>L</i>. The resistance and the inductance represent the
effects of the secondary and primary side of the transformer.
</p>
<p>
The model is parameterized using the following parameters
</p>
<ul>
<li><code>Vhigh</code> - RMS voltage at primary side,</li>
<li><code>Vlow</code> - RMS voltage at secondary side,</li>
<li><code>VAbase</code> - apparent nominal power of the transformer,</li>
<li><code>XoverR</code> - ratio between reactance and resistance, and</li>
<li><code>Zperc</code> - the short circuit impedance.</li>
</ul>
<p>
Given the nominal conditions, the model computes the values of the resistance and inductance.
</p>

<h4>Configuration:</h4>
<p>
The image below describes the connection of the windings.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/Conversion/BaseClasses/DY_b.png\"/>
</p>

<h4>Note:</h4>
<p>
This model reuses models from
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer\">
Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer</a>.
</p>
<p>
See
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses.PartialConverterStepUpDY\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses.PartialConverterStepUpDY</a> for
details on the connections.
</p>
</html>"));
end ACACTransformerStepUpDY;
