within Districts.Electrical.AC.ThreePhasesBalanced.Sources;
model Grid "Electrical grid"
  extends Districts.Electrical.AC.OnePhase.Sources.Grid(redeclare
      Interfaces.Terminal_p terminal,
    redeclare FixedVoltage sou);

  annotation (
  defaultComponentName="gri",
    Documentation(info="<html>
<p>
Model that can be used to connect to the electrical grid supply.
</p>
<p>
The convention is that <code>P.real</code> is positive if real power is
consumed from the grid, and negative if it is fed into the grid.
</p>
<p>
The parameter <code>V</code> is the root means square of the voltage.
In US households, this is <i>120</i> Volts.
</p>
</html>",
 revisions="<html>
<ul>
<li>
January 2, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end Grid;
