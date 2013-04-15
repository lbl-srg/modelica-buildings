within Districts.Electrical.AC.Conversion;
model ACACConverter "AC AC converter"
  // fixme: add example. Consider adding a constant loss therm for
  // parasitic losses
  import Modelica.ComplexMath.real;
  import Modelica.ComplexMath.imag;
  import Modelica.ComplexMath.conj;
  import Modelica.ComplexMath.'abs';
  import Modelica.ComplexMath.arg;

  parameter Real conversionFactor
    "Ratio of QS rms voltage on side 2 / QS rms voltage on side 1";
  parameter Real eta(min=0, max=1)
    "Converter efficiency, pLoss = (1-eta) * 'abs'(v2QS)";
  Modelica.SIunits.Power LossPower "Loss power";

  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin pin1_pQS
    "Positive pin on side 1"
    annotation (Placement(transformation(extent={{-110,110},{-90,90}}),
        iconTransformation(extent={{-110,110},{-90,90}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin pin1_nQS
    "Negative pin on side 1"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}}),
        iconTransformation(extent={{-110,-110},{-90,-90}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin pin2_pQS
    "Positive pin on side 2"
    annotation (Placement(transformation(extent={{90,110},{110,90}}),
        iconTransformation(extent={{90,110},{110,90}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin pin2_nQS
    "Negative pin on side 2"
    annotation (Placement(transformation(extent={{90,-110},{110,-90}}),
        iconTransformation(extent={{90,-110},{110,-90}})));
protected
  Modelica.SIunits.ComplexVoltage  v1QS= pin1_pQS.v - pin1_nQS.v
    "AC QS voltage";
  Modelica.SIunits.ComplexCurrent  i1QS= pin1_pQS.i "AC QS current";
  output Modelica.SIunits.Voltage v1QSabs='abs'(v1QS) "Abs(AC QS voltage)";
  output Modelica.SIunits.Current i1QSabs='abs'(i1QS) "Abs(AC QS current)";
  Modelica.SIunits.ComplexPower  s1QS= v1QS*conj(i1QS) "AC QS apparent power";
  Modelica.SIunits.ActivePower p1QS = real(s1QS) "AC QS active power";
  Modelica.SIunits.ReactivePower q1QS = imag(s1QS) "AC QS reactive power";

  Modelica.SIunits.ComplexVoltage  v2QS= pin2_pQS.v - pin2_nQS.v
    "AC QS voltage";
  Modelica.SIunits.ComplexCurrent  i2QS= pin2_pQS.i "AC QS current";
  output Modelica.SIunits.Voltage v2QSabs='abs'(v2QS) "Abs(AC QS voltage)";
  output Modelica.SIunits.Current i2QSabs='abs'(i2QS) "Abs(AC QS current)";
  Modelica.SIunits.ComplexPower  s2QS= v2QS*conj(i2QS) "AC QS apparent power";
  Modelica.SIunits.ActivePower p2QS = real(s2QS) "AC QS active power";
  Modelica.SIunits.ReactivePower q2QS = imag(s2QS) "AC QS reactive power";

equation
//QS balances
  Connections.branch(pin1_pQS.reference, pin1_nQS.reference);
  Connections.branch(pin2_pQS.reference, pin2_nQS.reference);
  pin1_pQS.reference.gamma = pin1_nQS.reference.gamma;
  pin2_pQS.reference.gamma = pin2_nQS.reference.gamma;
  pin1_pQS.i + pin1_nQS.i = Complex(0);
  pin2_pQS.i + pin2_nQS.i = Complex(0);

//voltage relation
  'abs'(v2QS) = 'abs'(v1QS)*conversionFactor;
//fixme: do we need to do anything for the phase or should we assume the phase remains the same?
//power balance
  LossPower = (1-eta) * 'abs'(v2QS);
  p1QS + p2QS - LossPower = 0;
//define reactive power
  q1QS = 0;
  q2QS = 0;
  annotation (Diagram(graphics), Icon(graphics={
        Line(
          points={{2,100},{2,60},{82,60},{2,60},{82,-60},{2,-60},{2,60},{2,-100}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{40,40},{100,0}},
          lineColor={0,0,255},
          textString="QS"),
        Line(
          points={{-2,100},{-2,60},{-82,60},{-2,60},{-82,-60},{-2,-60},{-2,60},
              {-2,-100}},
          color={85,170,255},
          smooth=Smooth.None),
        Text(
          extent={{-100,40},{-40,0}},
          lineColor={85,170,255},
          textString="QS"),
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
This is an AC AC converter, based on a power balance between both QS circuit sides.
The paramater <i>conversionFactor</i> defines the ratio between averaged the QS rms voltages.
The loss of the converter is proportional to the power transmitted at the second circuit side.
The parameter <code>eps</code> is the efficiency of the transfer.
The loss is computed as
<i>P<sub>loss</sub> = (1-&eta;) |P<sub>DC</sub>|</i>,
where <i>|P<sub>DC</sub>|</i> is the power transmitted on the second circuit side.
Furthermore, reactive power on both QS side are set to 0.
</p>
<h4>Note:</h4>
<p>
This model is derived from 
<a href=\"modelica://Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealACDCConverter\">
Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealACDCConverter</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 29, 2012, by Thierry S. Nouidui:<br>
First implementation.
</li>
</ul>
</html>"));
end ACACConverter;
