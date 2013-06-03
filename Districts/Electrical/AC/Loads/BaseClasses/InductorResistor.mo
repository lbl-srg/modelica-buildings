within Districts.Electrical.AC.Loads.BaseClasses;
model InductorResistor "Model of an inductive and resistive load"
extends Districts.Electrical.AC.Loads.BaseClasses.SingleOnePhaseModel(
    v(re(start=1), im(start=1)));

  parameter Modelica.SIunits.Power P_nominal(min=0)
    "Nominal power (P_nominal >= 0)";
  parameter Real pf(min=0, max=1) = 0.8 "Power factor";
  Modelica.SIunits.Angle phi "Phase shift";
  Modelica.SIunits.ComplexImpedance Z "Impedance of the load";
protected
  Real R "Resistance of impedence Z";
  Real X "Reactance of impedance Z";
  Real Isquare "square of the absolute value of the complex current";
  constant Boolean lagging = true
    "Set to true for inductive loads (motor, transformer), or false otherwise";

equation
  phi = Districts.Electrical.AC.BaseClasses.powerFactor(pf=pf, lagging=lagging);

  Isquare = i.re^2 + i.im^2 +100*Modelica.Constants.eps;

  R = P_nominal/Isquare;
  X = ((P_nominal/pf)*sin(phi))/Isquare;

  Z = Complex(R,X);

  v = Z*i;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Rectangle(
          extent={{-80,40},{80,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                   Rectangle(extent={{-100,100},{100,-100}},
            lineColor={255,255,255}),
          Line(points={{-10,0},{12,1.46953e-15}},
                                         color={0,0,0},
          origin={-80,0},
          rotation=180),
        Text(
          extent={{-120,100},{120,60}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-11.5,29.5},{11.5,-29.5}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-41.5,0.5},
          rotation=90)}),        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p>
Model of an inductive load. It may be used to model an inductive motor.
</p>
<p>
A parameter or input to the model is the real power <i>P</i>, and a parameter
is the power factor <i>pf=cos(&phi;)</i>.
In this model, current lags voltage, as is the case for an inductive motor.
For a capacitive load, use
<a href=\"modelica://Districts.Electrical.AC.Loads.CapacitorResistor\">
Districts.Electrical.AC.Loads.SinglePhase.CapacitorResistor</a>.
</p>
<p>
The model computes the phase angle of the power <i>&phi;</i>
and assigns the complex impedance <i>Z = R + jX</i>.
The equations of the model are derived from<br/><br/>
<i>v = Z &middot; i</i><br/><br/>
<i>v &middot; i<sup>*</sup> = Z &middot; i &middot; i<sup>*</sup></i><br/><br/>
<i>v &middot; i<sup>*</sup> = Z &middot; Isquare </i><br/><br/>
<i>P +jQ = Z &middot; Isquare </i><br/><br/>
where <i>Isquare</i> (N.B. a Real number) is the square of the modulus of the complex current <i>i</i>, and <i>i<sup>*</sup></i> is 
the conjugate of the complex current.<br/>
The real and complex components of the impedance are then computed as
<br/><br/>
<i>R = P/Isquare</i>, <i>X = Q/Isquare</i>
<br/><br/>
where the complex power <i>Q</i> is computed as
<br/><br/>
<i>Q=(P/pf) &middot; sin(&phi;)</i>
<br/><br/>
<b>Note:</b><br/>
Has been added a very small constant when computing <i>Isquare</i> to avoid numerical problems during the initialization, 
or when the current is almost null.
<br/><br/>
Isquare = i.re^2 + i.im^2 +100*Modelica.Constants.eps;
</p>
</html>", revisions="<html>
<ul>
<li>
May 17, 2013, by Marco Bonvini:<br>
Modified the equations, now the impedance Z is explicitly computed, solving numerical issue during inizialization.
</li>
<li>
January 2, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end InductorResistor;
