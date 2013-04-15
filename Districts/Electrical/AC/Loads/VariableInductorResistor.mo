within Districts.Electrical.AC.Loads;
model VariableInductorResistor
  "Model of an inductive and resistive load with actual power as an input signal"
extends Districts.Electrical.AC.Loads.BaseClasses.VariableInductorResistor(
      lagging=true);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={255,255,255}),
          Line(points={{0,0},{12,1.46953e-15}},
                                         color={0,0,0},
          origin={0,0},
          rotation=180),
        Ellipse(extent={{-10,-10},{10,10}},
          origin={10,0},
          rotation=360),
        Ellipse(extent={{20,-10},{40,10}}),
        Ellipse(extent={{40,-10},{60,10}}),
          Line(points={{-6.85214e-44,-8.39117e-60},{10,1.22461e-15}},
                                         color={0,0,0},
          origin={70,0},
          rotation=180),
        Rectangle(
          extent={{0,0},{60,-12}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
                                 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p>
Model of an inductive load that takes as an input signal the actual power.
It may be used to model an inductive motor.
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
In this model, current lags voltage, as is the case for an inductive motor.
For a capacitive load, use
<a href=\"modelica://Districts.Electrical.AC.Loads.VariableCapacitorResistor\">
Districts.Electrical.AC.Loads.SinglePhase.VariableCapacitorResistor</a>.
</p>
<h4>Implementation</h4>
<p>
To avoid a singularity if the control input signal <i>y</i> is zero, the model uses internally
the signal <i>y<sub>int</sub> = 1E-12 + y * (1 - 1E-12)</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 3, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end VariableInductorResistor;
