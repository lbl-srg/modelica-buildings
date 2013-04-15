within Districts.Electrical.AC.Loads;
model InductorResistor "Model of an inductive and resistive load"
extends Districts.Electrical.AC.Loads.BaseClasses.InductorResistor(lagging=true);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={255,255,255}),
        Text(
          extent={{14,140},{104,98}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(extent={{-10,-10},{10,10}},
          origin={20,0},
          rotation=360),
        Ellipse(extent={{50,-10},{70,10}}),
        Ellipse(extent={{30,-10},{50,10}}),
        Rectangle(
          extent={{10,0},{70,-12}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Line(points={{-10,0},{12,1.46953e-15}},
                                         color={0,0,0},
          origin={0,0},
          rotation=180),
          Line(points={{-10,0},{10,1.22461e-15}},
                                         color={0,0,0},
          origin={80,0},
          rotation=180)}),       Diagram(coordinateSystem(preserveAspectRatio=false,
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
January 2, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end InductorResistor;
