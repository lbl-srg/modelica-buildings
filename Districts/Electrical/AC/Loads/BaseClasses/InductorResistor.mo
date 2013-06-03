within Districts.Electrical.AC.Loads.BaseClasses;
model InductorResistor "Model of an inductive and resistive load"
extends Districts.Electrical.AC.Loads.BaseClasses.SingleOnePhaseModel(
    v(re(start=1), im(start=1)));

  parameter Modelica.SIunits.Power P_nominal(min=0)
    "Nominal power (P_nominal >= 0)";
  parameter Real pf(min=0, max=1) = 0.8 "Power factor";

  Modelica.SIunits.ComplexPower S "Complex power into the component";
  Modelica.SIunits.Angle phi "Phase shift";
protected
  constant Boolean lagging = true
    "Set to true for inductive loads (motor, transformer), or false otherwise";

equation
  phi = Districts.Electrical.AC.BaseClasses.powerFactor(pf=pf, lagging=lagging);
  S = Modelica.ComplexMath.fromPolar(max(100*Modelica.Constants.eps, P_nominal/pf), phi);
  S = v * Modelica.ComplexMath.conj(i);
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
and assigns the complex power <i>S = -P/pf &ang; &phi;</i>.
The relation between complex power, complex voltage and complex current is computed
as 
<i>S = v &sdot; i<sup>*</sup></i>,
where <i>i<sup>*</sup></i> is the complex conjugate of the current.
</p>
</html>", revisions="<html>
<ul>
<li>
January 2, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end InductorResistor;
