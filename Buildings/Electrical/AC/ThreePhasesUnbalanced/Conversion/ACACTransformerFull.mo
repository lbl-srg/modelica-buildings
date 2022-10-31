within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion;
model ACACTransformerFull "AC AC transformer detailed equivalent circuit (YY)"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses.PartialConverterYY(
    redeclare Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformerFull conv1(
      VHigh=VHigh/sqrt(3),
      VLow=VLow/sqrt(3),
      f = f,
      VABase=VABase,
      R1=R1,L1=L1,R2=R2,L2=L2,
      magEffects=magEffects,
      Rm=Rm,Lm=Lm,
      ground_1=ground_1,
      ground_2=ground_2),
    redeclare Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformerFull conv2(
      VHigh=VHigh/sqrt(3),
      VLow=VLow/sqrt(3),
      f = f,
      VABase=VABase,
      R1=R1,L1=L1,R2=R2,L2=L2,
      magEffects=magEffects,
      Rm=Rm,Lm=Lm,
      ground_1=ground_1,
      ground_2=ground_2),
    redeclare Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformerFull conv3(
      VHigh=VHigh/sqrt(3),
      VLow=VLow/sqrt(3),
      f = f,
      VABase=VABase,
      R1=R1,L1=L1,R2=R2,L2=L2,
      magEffects=magEffects,
      Rm=Rm,Lm=Lm,
      ground_1=ground_1,
      ground_2=ground_2));

  parameter Modelica.Units.SI.Voltage VHigh
    "Rms voltage on side 1 of the transformer (primary side)";
  parameter Modelica.Units.SI.Voltage VLow
    "Rms voltage on side 2 of the transformer (secondary side)";
  parameter Modelica.Units.SI.ApparentPower VABase
    "Nominal power of the transformer";
  parameter Modelica.Units.SI.Frequency f(start=60) "Nominal frequency";
  parameter Buildings.Electrical.Types.PerUnit R1(min=0)
    "Resistance on side 1 of the transformer (pu)";
  parameter Buildings.Electrical.Types.PerUnit L1(min=0)
    "Inductance on side 1 of the transformer (pu)";
  parameter Buildings.Electrical.Types.PerUnit R2(min=0)
    "Resistance on side 2 of the transformer (pu)";
  parameter Buildings.Electrical.Types.PerUnit L2(min=0)
    "Inductance on side 2 of the transformer (pu)";
  parameter Boolean magEffects = false
    "If =true introduce magnetization effects"
    annotation(Dialog(group="Magnetization"));
  parameter Buildings.Electrical.Types.PerUnit Rm(min=0,start=0)
    "Magnetization resistance (pu)" annotation(Dialog(group="Magnetization", enable = magEffects));
  parameter Buildings.Electrical.Types.PerUnit Lm(min=0,start=0)
    "Magnetization inductance (pu)" annotation(Dialog(group="Magnetization", enable = magEffects));
  parameter Boolean ground_1 = false "Connect side 1 of converter to ground" annotation(Dialog(tab = "Ground", group="side 1"));
  parameter Boolean ground_2 = true "Connect side 2 of converter to ground" annotation(Dialog(tab = "Ground", group="side 2"));

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
          textString="L")}),
    Documentation(info="<html>
<p>
This is a detailed transformer model that takes into accounts the winding Joule losses,
and the leakage reactances on the primary and secondary side. The model also takes into account
the core or iron losses and the losses due to magnetization effects.
</p>
<p>
The losses are represented by a series of resistances <i>R<sub>1</sub></i>, <i>R<sub>2</sub></i>,
<i>R<sub>m</sub></i> and inductances <i>L<sub>1</sub></i>, <i>L<sub>2</sub></i>, and
<i>L<sub>m</sub></i>.
</p>
<p>
The model is parameterized using the following parameters
</p>
<ul>
<li><code>Vhigh</code> - RMS voltage at primary side,</li>
<li><code>Vlow</code> - RMS voltage at secondary side,</li>
<li><code>VAbase</code> - apparent nominal power of the transformer,</li>
<li><code>f</code> - frequency,</li>
<li><code>R_1, L_1</code> - resistance and inductance at primary side (per unit),</li>
<li><code>R_2, L_2</code> - resistance and inductance at secondary side (per unit), and</li>
<li><code>R_m, L_m</code> - resistance and inductance for magnetization effects (per unit).</li>
</ul>
<p>
Given the nominal conditions, the model computes the values of the nominal impedances
at the primary and secondary side. Given these values, the per unit values are transformed into
the actual values of the resistances and inductancs.
</p>
<p>
The magnetization losses can be enabled or disabled using the boolean flag <code>magEffects</code>.
</p>
<h4>Configuration:</h4>
<p>
The image below describes the connection of the windings.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/Conversion/BaseClasses/YY.png\"/>
</p>
<h4>Note:</h4>
<p>
This model reuses models from
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformerFull\">
Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformerFull</a>.
</p>
<p>
See
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses.PartialConverterYY\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses.PartialConverterYY</a> for
details on the connections.
</p>
</html>", revisions="<html>
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
</html>"));
end ACACTransformerFull;
