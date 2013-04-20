within Districts.Electrical.AC.Loads;
model CapacitorResistor "Model of a capacitive and resistive load"
  extends Districts.Electrical.AC.Loads.BaseClasses.InductorResistor(lagging=
        false);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),      graphics={
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
          Line(points={{-26,-3.18398e-15},{6.85214e-44,8.39117e-60}},
                                         color={0,0,0},
          origin={48,0},
          rotation=180)}),       Documentation(info="<html>
<p>
Model of a capacitive load. It may be used to model a bank of capacitors.
</p>
<p>
A parameter or input to the model is the real power <i>P</i>, and a parameter
is the power factor <i>pf=cos(&phi;)</i>.
In this model, current leads voltage, as is the case for a capacitor bank.
For an inductive load, use
<a href=\"modelica://Districts.Electrical.AC.Loads.InductorResistor\">
Districts.Electrical.AC.Loads.InductorResistor</a>.</p>
<p>
The model computes the phase angle of the power <i>&phi;</i>
and assigns the complex power <i>S = -P/pf &ang; &phi;</i>.
The relation between complex power, complex voltage and complex current is computed
as 
<i>S = v &sdot; i<sup>*</sup></i>,
where <i>i<sup>*</sup></i> is the complex conjugate of the current.
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
end CapacitorResistor;
