within Buildings.Electrical.AC.ThreePhasesBalanced.Lines;
model TwoPortInductance "Model of an inductance with two electrical ports"
  extends Buildings.Electrical.AC.OnePhase.Lines.TwoPortInductance(
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p);
  annotation (
    defaultComponentName="lineL",
    Diagram(graphics), Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(revisions="<html>
<ul>
<li>
August 25, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
Inductance that connects two AC three phases 
balanced interfaces. This model can be used to represent a
cable in a three phases balanced AC system.
</p>
<p>
See model
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Lines.TwoPortInductance\">
Buildings.Electrical.AC.OnePhase.Lines.TwoPortInductance</a> for more 
information.
</p>
</html>"));
end TwoPortInductance;
