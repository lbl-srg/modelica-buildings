within Districts.Electrical.DC.Conversion;
model DCDCConverter "DC DC converter"
  // fixme: add example. Consider adding a constant loss therm for

  parameter Real conversionFactor
    "Ratio of DC voltage on side 2 / DC voltage on side 1";
  parameter Real eta(min=0, max=1)
    "Converter efficiency, pLoss = (1-eta) * pDC2";
  Modelica.SIunits.Power LossPower "Loss power";

protected
  Modelica.SIunits.Voltage vDC1= dCplug1.p.v - dCplug1.n.v "DC voltage";
  Modelica.SIunits.Current iDC1 = dCplug1.p.i "DC current";
  Modelica.SIunits.Power pDC1 = vDC1*iDC1 "DC power";
  Modelica.SIunits.Voltage vDC2 = dCplug2.p.v - dCplug2.n.v "DC voltage";
  Modelica.SIunits.Current iDC2 = dCplug2.p.i "DC current";
  Modelica.SIunits.Power pDC2 = vDC2*iDC2 "DC power";
public
  Interfaces.DCplug dCplug1 annotation (Placement(transformation(extent={{-120,-20},
            {-100,0}}), iconTransformation(extent={{-120,-20},{-80,20}})));
  Interfaces.DCplug dCplug2 annotation (Placement(transformation(extent={{80,-20},
            {100,0}}), iconTransformation(extent={{80,-20},{120,20}})));
equation

 //DC current balance
  dCplug1.p.i + dCplug1.n.i = 0;
//DC current balance
  dCplug2.p.i + dCplug2.n.i = 0;
//voltage relation
  vDC2 = vDC1*conversionFactor;
//power balance
  LossPower = (1-eta) * abs(pDC2);
  pDC1 + pDC2 - LossPower = 0;

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
          extent={{36,54},{96,14}},
          lineColor={0,0,255},
          textString="DC"),
        Line(
          points={{-2,100},{-2,60},{-82,60},{-2,60},{-82,-60},{-2,-60},{-2,60},
              {-2,-100}},
          color={85,170,255},
          smooth=Smooth.None),
        Text(
          extent={{-88,54},{-28,14}},
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
