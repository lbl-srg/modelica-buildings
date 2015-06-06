within Buildings.Electrical.AC.ThreePhasesBalanced.Lines;
model TwoPortResistance "Model of a resistance with two electrical ports"
  extends Buildings.Electrical.AC.OnePhase.Lines.TwoPortResistance(
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p);
  annotation (
    defaultComponentName="lineR",
    Documentation(revisions="<html>
<ul>
<li>
August 25, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
Resistance that connects two AC three-phase
balanced interfaces. This model can be used to represent a
cable in a three-phase balanced AC system.
</p>
<p>
See model
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Lines.TwoPortResistance\">
Buildings.Electrical.AC.OnePhase.Lines.TwoPortResistance</a> for more
information.
</p>
</html>"));
end TwoPortResistance;
