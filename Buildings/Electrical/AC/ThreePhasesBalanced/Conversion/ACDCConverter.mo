within Buildings.Electrical.AC.ThreePhasesBalanced.Conversion;
model ACDCConverter "AC DC converter"
  extends Buildings.Electrical.AC.OnePhase.Conversion.ACDCConverter(
    redeclare Interfaces.Terminal_n terminal_n);

  annotation (
defaultComponentName="conACDC",
Documentation(info="<html>
<p>
This model represents a simplified conversion between a three-phase
balanced AC system and a DC systems.
</p>
<p>
See model
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Conversion.ACDCConverter\">
Buildings.Electrical.AC.OnePhase.Conversion.ACDCConverter</a> for more
information.
</p>
</html>", revisions="<html>
<ul>
<li>
September 22, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
July 24, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ACDCConverter;
