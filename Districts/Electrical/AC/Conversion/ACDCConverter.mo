within Districts.Electrical.AC.Conversion;
model ACDCConverter "AC DC converter"
  // fixme: add example. Consider adding a constant loss therm for
  // parasitic losses
  import Modelica.ComplexMath.real;
  import Modelica.ComplexMath.imag;
  import Modelica.ComplexMath.conj;
  import Modelica.ComplexMath.'abs';
  import Modelica.ComplexMath.arg;

  parameter Real conversionFactor "Ratio of DC voltage / QS rms voltage";
  parameter Real eta(min=0, max=1)
    "Converter efficiency, pLoss = (1-eta) * pDC";
  Modelica.SIunits.Power LossPower "Loss power";

  Modelica.Electrical.Analog.Interfaces.PositivePin pin_pDC
    "Positive pin on DC side"
    annotation (Placement(transformation(extent={{90,110},{110,90}}),
        iconTransformation(extent={{90,110},{110,90}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_nDC
    "Negative pin on DC side"
    annotation (Placement(transformation(extent={{90,-110},{110,-90}}),
        iconTransformation(extent={{90,-110},{110,-90}})));
protected
  Modelica.SIunits.ComplexVoltage  vQS= plug1.phase[1].v - plug1.neutral.v
    "AC QS voltage";
  Modelica.SIunits.ComplexCurrent  iQS= plug1.phase[1].i "AC QS current";
  output Modelica.SIunits.Voltage vQSabs='abs'(vQS) "Abs(AC QS voltage)";
  output Modelica.SIunits.Current iQSabs='abs'(iQS) "Abs(AC QS current)";
  Modelica.SIunits.ComplexPower  sQS= vQS*conj(iQS) "AC QS apparent power";
  Modelica.SIunits.ActivePower pQS = real(sQS) "AC QS active power";
  Modelica.SIunits.ReactivePower qQS = imag(sQS) "AC QS reactive power";
  Modelica.SIunits.Voltage vDC = pin_pDC.v - pin_nDC.v "DC voltage";
  Modelica.SIunits.Current iDC = pin_pDC.i "DC current";
  Modelica.SIunits.Power pDC = vDC*iDC "DC power";
public
  Interfaces.SinglePhasePlug plug1 "Single phase connector side 1" annotation (
      Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
equation
//QS balances
  Connections.branch(plug1.phase[1].reference, plug1.neutral.reference);
  plug1.phase[1].reference.gamma = plug1.neutral.reference.gamma;
  plug1.phase[1].i + plug1.neutral.i = Complex(0);
//DC current balance
  pin_pDC.i + pin_nDC.i = 0;
//voltage relation
  vDC = 'abs'(vQS)*conversionFactor;
//power balance
  LossPower = (1-eta) * abs(pDC);
  pQS + pDC - LossPower = 0;
//define reactive power
  qQS = 0;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics={
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
          extent={{-100,52},{-40,12}},
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
This is an AC DC converter, based on a power balance between QS circuit and DC side.
The paramater <i>conversionFactor</i> defines the ratio between averaged DC voltage and QS rms voltage.
The loss of the converter is proportional to the power transmitted at the DC side.
The parameter <code>eps</code> is the efficiency of the transfer.
The loss is computed as
<i>P<sub>loss</sub> = (1-&eta;) |P<sub>DC</sub>|</i>,
where <i>|P<sub>DC</sub>|</i> is the power transmitted on the DC side.
Furthermore, reactive power at the QS side is set to 0.
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
January 4, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ACDCConverter;
