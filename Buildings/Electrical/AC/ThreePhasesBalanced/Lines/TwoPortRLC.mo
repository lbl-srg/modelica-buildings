within Buildings.Electrical.AC.ThreePhasesBalanced.Lines;
model TwoPortRLC "Model of a RLC element with two electrical ports"
  extends Buildings.Electrical.AC.OnePhase.Lines.TwoPortRLC(
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p);
  annotation (
    defaultComponentName="lineRLC",
    Documentation(revisions="<html>
<ul>
<li>
August 25, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
RLC impedance that connects two AC three-phase
balanced interfaces. This model can be used to represent a
cable in a three-phase balanced AC system.
</p>
<p>
See model
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Lines.TwoPortRLC\">
Buildings.Electrical.AC.OnePhase.Lines.TwoPortRLC</a> for more
information.
</p>
</html>"));
end TwoPortRLC;
