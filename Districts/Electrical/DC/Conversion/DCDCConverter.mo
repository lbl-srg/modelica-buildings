within Districts.Electrical.DC.Conversion;
model DCDCConverter "DC DC converter"
  // fixme: add example. Consider adding a constant loss therm for

  parameter Real conversionFactor
    "Ratio of DC voltage on side 2 / DC voltage on side 1";
  parameter Real eta(min=0, max=1)
    "Converter efficiency, pLoss = (1-eta) * pDC2";
  Modelica.SIunits.Power LossPower "Loss power";

  Modelica.Electrical.Analog.Interfaces.PositivePin pin1_pDC
    "Positive pin on side 1"
    annotation (Placement(transformation(extent={{-110,110},{-90,90}}),
        iconTransformation(extent={{-110,110},{-90,90}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin1_nDC
    "Negative pin on side 1"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}}),
        iconTransformation(extent={{-110,-110},{-90,-90}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin2_pDC
    "Positive pin on side 2"
    annotation (Placement(transformation(extent={{90,110},{110,90}}),
        iconTransformation(extent={{90,110},{110,90}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin2_nDC
    "Negative pin on side 2"
    annotation (Placement(transformation(extent={{90,-110},{110,-90}}),
        iconTransformation(extent={{90,-110},{110,-90}})));
protected
  Modelica.SIunits.Voltage vDC1= pin1_pDC.v - pin1_nDC.v "DC voltage";
  Modelica.SIunits.Current iDC1 = pin1_pDC.i "DC current";
  Modelica.SIunits.Power pDC1 = vDC1*iDC1 "DC power";
  Modelica.SIunits.Voltage vDC2 = pin2_pDC.v - pin2_nDC.v "DC voltage";
  Modelica.SIunits.Current iDC2 = pin2_pDC.i "DC current";
  Modelica.SIunits.Power pDC2 = vDC2*iDC2 "DC power";
equation

 //DC current balance
  pin1_pDC.i + pin1_nDC.i = 0;
//DC current balance
  pin2_pDC.i + pin2_nDC.i = 0;
//voltage relation
  vDC2 = vDC1*conversionFactor;
//power balance
  LossPower = (1-eta) * abs(pDC2);
  pDC1 + pDC2 - LossPower = 0;

  annotation (Diagram(graphics), Icon(graphics={
        Line(
          points={{2,100},{2,60},{82,60},{2,60},{82,-60},{2,-60},{2,60},{2,-100}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{40,40},{100,0}},
          lineColor={0,0,255},
          textString="DC"),
        Line(
          points={{-2,100},{-2,60},{-82,60},{-2,60},{-82,-60},{-2,-60},{-2,60},
              {-2,-100}},
          color={85,170,255},
          smooth=Smooth.None),
        Text(
          extent={{-100,40},{-40,0}},
          lineColor={85,170,255},
          textString="DC"),
        Text(
          extent={{-100,92},{100,60}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,-60},{100,-92}},
          lineColor={0,0,255},
          textString="%conversionFactor"),
        Text(
          extent={{-100,-100},{100,-132}},
          lineColor={0,0,255},
          textString="%eta")}),
    Documentation(info="<html>
<p>
This is an DC DC converter, based on a power balance between DC and DC side.
The paramater <i>conversionFactor</i> defines the ratio between the two averaged DC voltages
The loss of the converter is proportional to the power transmitted to the second DC side.
The parameter <code>eps</code> is the efficiency of the transfer.
The loss is computed as
<i>P<sub>loss</sub> = (1-&eta;) |P<sub>DC2</sub>|</i>,
where <i>|P<sub>DC2</sub>|</i> is the power transmitted on the second DC side.
</p>
<h4>Note:</h4>
<p>
This model is derived from 
<a href=\"modelica://Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealDCDCConverter\">
Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealDCDCConverter</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 28, 2012, by Thierry S. Nouidui:<br>
First implementation.
</li>
</ul>
</html>"));
end DCDCConverter;
