within Districts.Electrical.AC.Sources;
model Generator "Model of a generator"
  // Because the turbine produces power, we use the variable capacitor instead of
  // the inductor as a base class. fixme: check if this is correct
  extends Districts.Electrical.AC.Loads.VariableCapacitorResistor(isLoad=false);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={255,255,255}),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-52,48},{-52,-52},{60,-16},{60,12},{-52,48}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
                                 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p>
Model of an inductive generator.
</p>
<p>
This model must be used with 
<a href=\"modelica://Districts.Electrical.AC.Sources.Grid\">
Districts.Electrical.AC.Sources.Grid</a>
or with a voltage source from the package
<a href=\"modelica://Modelica.Electrical.QuasiStationary.SinglePhase.Sources\"
Modelica.Electrical.QuasiStationary.SinglePhase.Sources</a>.
Otherwise, there will be no equation that defines the phase
angle of the voltage.
</p>
</html>", revisions="<html>
<ul>
<li>
January 4, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Generator;
