within Districts.Electrical.AC.Loads;
model VariableCapacitorResistor
  "Model of a capacitive and resistive load with actual power as an input signal"
  extends Districts.Electrical.AC.Loads.BaseClasses.VariableInductorResistor(
      lagging=false);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{
            -100,-100},{100,100}}), graphics={
        Line(
          points={{0,28},{0,-28}},
          color={0,0,255},
          thickness=0.5,
          origin={48,0},
          rotation=180),
        Line(
          points={{0,28},{0,-28}},
          color={0,0,255},
          thickness=0.5,
          origin={40,0},
          rotation=180),
          Line(points={{-42,-5.14335e-15},{10,0}},
                                         color={0,0,0},
          origin={-2,0},
          rotation=180),
          Line(points={{-42,-5.14335e-15},{6.85214e-44,8.39117e-60}},
                                         color={0,0,0},
          origin={48,0},
          rotation=180)}),       Documentation(info="<html>
<p>
Model of a capacitive load that takes as an input signal the actual power.
It may be used to model an bank of capacitors.
</p>
<p>
An input to the model is the control signal <i>y</i> which is defined such that
the real power <i>P</i> consumed by this model is equal to <i>P = y &nbsp; P<sub>nom</sub></i>,
where <i>P<sub>nom</sub></i> is a parameter that is equal to the nominal power.
The parameter  <i>pf<sub>nom</sub>=cos(&phi;<sub>nom</sub>)</i>
is the power factor at nominal power <i>P<sub>nom</sub></i>.
</p>
<p>
The model computes the phase angle of the power <i>&phi;</i>
and assigns the complex power <i>S = -P/pf &ang; &phi;</i>.
The relation between complex power, complex voltage and complex current is computed
as 
<i>S = v &sdot; i<sup>*</sup></i>,
where <i>i<sup>*</sup></i> is the complex conjugate of the current.
</p>
<p>
In this model, current leads voltage, as is the case for a capacitive load.
For an inductive load, use
<a href=\"modelica://Districts.Electrical.AC.Loads.VariableInductorResistor\">
Districts.Electrical.AC.Loads.SinglePhase.VariableInductorResistor</a>.
</p>
<h4>Implementation</h4>
<p>
To avoid a singularity if the control input signal <i>y</i> is zero, the model uses internally
the signal <i>y<sub>int</sub> = 1E-12 + y * (1 - 1E-12)</i>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 2, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end VariableCapacitorResistor;
