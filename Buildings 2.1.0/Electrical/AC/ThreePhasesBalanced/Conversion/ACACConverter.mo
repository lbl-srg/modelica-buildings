within Buildings.Electrical.AC.ThreePhasesBalanced.Conversion;
model ACACConverter "AC AC converter three phase balanced systems"
  extends Buildings.Electrical.AC.OnePhase.Conversion.ACACConverter(
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p);
  annotation (
  defaultComponentName="conACAC",
  Documentation(info="<html>
<p>
This model represents a simplified conversion between two AC
three-phase balanced systems. The conversion losses are represented by a
constant efficiency <i>&eta;</i>.
</p>
<p>
See model
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Conversion.ACACConverter\">
Buildings.Electrical.AC.OnePhase.Conversion.ACACConverter</a> for more
information.
</p>
</html>", revisions="<html>
<ul>
<li>
September 22, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
January 29, 2012, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end ACACConverter;
