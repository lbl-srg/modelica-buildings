within Buildings.Electrical.AC.ThreePhasesBalanced.Sources;
model Grid "Electrical grid"
  extends Buildings.Electrical.AC.OnePhase.Sources.Grid(redeclare
      Interfaces.Terminal_p
                        terminal, V = 480,
  redeclare Buildings.Electrical.AC.ThreePhasesBalanced.Sources.FixedVoltage sou);

  annotation (
  defaultComponentName="gri",
    Documentation(info="<html>
<p>
Model that can be used to represent the electrical grid supply. 
See <a href=\"modelica://Buildings.Electrical.AC.OnePhase.Sources.Grid\">
Buildings.Electrical.AC.OnePhase.Sources.Grid</a> for
more information.
</p>
</html>",
 revisions="<html>
<ul>
<li>
August 24, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
January 2, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end Grid;
