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
protected
  Modelica.SIunits.ComplexVoltage  v1QS= plug1.p[1].v - plug1.n.v
    "AC QS voltage";
  Modelica.SIunits.ComplexCurrent  i1QS= plug1.p[1].i "AC QS current";
  output Modelica.SIunits.Voltage v1QSabs='abs'(v1QS) "Abs(AC QS voltage)";
  output Modelica.SIunits.Current i1QSabs='abs'(i1QS) "Abs(AC QS current)";
  Modelica.SIunits.ComplexPower  s1QS= v1QS*conj(i1QS) "AC QS apparent power";
  Modelica.SIunits.ActivePower p1QS = real(s1QS) "AC QS active power";
  Modelica.SIunits.ReactivePower q1QS = imag(s1QS) "AC QS reactive power";

  Modelica.SIunits.ComplexVoltage  v2QS= plug2.p[1].v - plug2.n.v
    "AC QS voltage";
  Modelica.SIunits.ComplexCurrent  i2QS= plug2.p[1].i "AC QS current";
  output Modelica.SIunits.Voltage v2QSabs='abs'(v2QS) "Abs(AC QS voltage)";
  output Modelica.SIunits.Current i2QSabs='abs'(i2QS) "Abs(AC QS current)";
  Modelica.SIunits.ComplexPower  s2QS= v2QS*conj(i2QS) "AC QS apparent power";
  Modelica.SIunits.ActivePower p2QS = real(s2QS) "AC QS active power";
  Modelica.SIunits.ReactivePower q2QS = imag(s2QS) "AC QS reactive power";

public
  Interfaces.SinglePhasePlug plug1 "Single phase connector side 1" annotation (
      Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
  Interfaces.SinglePhasePlug plug2 "Single phase connector side 2" annotation (
      Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(
          extent={{80,-20},{120,20}})));
equation
//QS balances
  Connections.branch(plug1.p[1].reference, plug1.n.reference);
  Connections.branch(plug2.p[1].reference, plug2.n.reference);
  plug1.p[1].reference.gamma = plug1.n.reference.gamma;
  plug2.p[1].reference.gamma = plug2.n.reference.gamma;
  plug1.p[1].i + plug1.n.i = Complex(0);
  plug2.p[1].i + plug2.n.i = Complex(0);

//voltage relation
  'abs'(v2QS) = 'abs'(v1QS)*conversionFactor;
//fixme: do we need to do anything for the phase or should we assume the phase remains the same?
//power balance
  LossPower = (1-eta) * 'abs'(v2QS);
  p1QS + p2QS - LossPower = 0;
//define reactive power
  q1QS = 0;
  q2QS = 0;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Line(
          points={{2,100},{2,60},{82,60},{2,60},{82,-60},{2,-60},{2,60},{2,-100}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{36,52},{96,12}},
          lineColor={0,0,255},
          textString="QS"),
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
