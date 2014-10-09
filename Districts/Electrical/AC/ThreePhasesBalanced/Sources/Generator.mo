within Districts.Electrical.AC.ThreePhasesBalanced.Sources;
model Generator "Model of a generator"
  // Because the turbine produces power, we use the variable capacitor instead of
  // the inductor as a base class. fixme: check if this is correct
  extends Districts.Electrical.AC.OnePhase.Sources.Generator(
    redeclare Interfaces.Terminal_p terminal);
  annotation (Documentation(info="<html>
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
January 4, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generator;
