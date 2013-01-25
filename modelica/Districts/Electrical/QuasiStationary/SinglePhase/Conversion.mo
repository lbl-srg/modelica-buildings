within Districts.Electrical.QuasiStationary.SinglePhase;
package Conversion "Package with models for AC/DC conversion"
  extends Modelica.Icons.Package;
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

    Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin pin_pQS
      annotation (Placement(transformation(extent={{-110,110},{-90,90}}),
          iconTransformation(extent={{-110,110},{-90,90}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin pin_nQS
      annotation (Placement(transformation(extent={{-110,-110},{-90,-90}}),
          iconTransformation(extent={{-110,-110},{-90,-90}})));
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_pDC
      annotation (Placement(transformation(extent={{90,110},{110,90}}),
          iconTransformation(extent={{90,110},{110,90}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_nDC
      annotation (Placement(transformation(extent={{90,-110},{110,-90}}),
          iconTransformation(extent={{90,-110},{110,-90}})));
  protected
    Modelica.SIunits.ComplexVoltage  vQS= pin_pQS.v - pin_nQS.v "AC QS voltage";
    Modelica.SIunits.ComplexCurrent  iQS= pin_pQS.i "AC QS current";
    output Modelica.SIunits.Voltage vQSabs='abs'(vQS) "Abs(AC QS voltage)";
    output Modelica.SIunits.Current iQSabs='abs'(iQS) "Abs(AC QS current)";
    Modelica.SIunits.ComplexPower  sQS= vQS*conj(iQS) "AC QS apparent power";
    Modelica.SIunits.ActivePower pQS = real(sQS) "AC QS active power";
    Modelica.SIunits.ReactivePower qQS = imag(sQS) "AC QS reactive power";
    Modelica.SIunits.Voltage vDC = pin_pDC.v - pin_nDC.v "DC voltage";
    Modelica.SIunits.Current iDC = pin_pDC.i "DC current";
    Modelica.SIunits.Power pDC = vDC*iDC "DC power";
  equation
  //QS balances
    Connections.branch(pin_pQS.reference, pin_nQS.reference);
    pin_pQS.reference.gamma = pin_nQS.reference.gamma;
    pin_pQS.i + pin_nQS.i = Complex(0);
  //DC current balance
    pin_pDC.i + pin_nDC.i = 0;
  //voltage relation
    vDC = 'abs'(vQS)*conversionFactor;
  //power balance
    LossPower = (1-eta) * abs(pDC);
    pQS + pDC - LossPower = 0;
  //define reactive power
    qQS = 0;
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
</html>",   revisions="<html>
<ul>
<li>
January 4, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  end ACDCConverter;
end Conversion;
