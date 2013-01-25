within Districts.Electrical.QuasiStationary.SinglePhase.Loads;
model Resistor "Model of a resistive load"
extends Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.OnePort;

  parameter Modelica.SIunits.Power P_nominal(min=0)
    "Nominal power (P_nominal >= 0)";
protected
  Modelica.SIunits.Resistance R(start=1) "Resistance";
equation
  P_nominal = Modelica.ComplexMath.real(v*Modelica.ComplexMath.conj(i));
  v = R*i;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={255,255,255}),
          Rectangle(
            extent={{-70,30},{70,-30}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
          origin={-3.55271e-15,2},
          rotation=180),
          Line(points={{-10,0},{10,0}},  color={0,0,0},
          origin={80,0},
          rotation=180),
          Line(points={{-10,0},{10,0}},color={0,0,0},
          origin={-80,0},
          rotation=180),
        Text(
          extent={{14,140},{104,98}},
          lineColor={0,0,255},
          textString="%name")}),
          Documentation(info="<html>
<p>
Model of a resistive load. It may be used to model a load that has
a power factor of one.
</p>
<p>
The model computes the power as
<i>P = real(v &sdot; i<sup>*</sup>)</i>,
where <i>i<sup>*</sup></i> is the complex conjugate of the current.
Complex voltage and complex current are related as <i>v = R &nbsp; i</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 2, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Resistor;
