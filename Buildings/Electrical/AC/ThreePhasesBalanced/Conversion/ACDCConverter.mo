within Buildings.Electrical.AC.ThreePhasesBalanced.Conversion;
model ACDCConverter "AC DC converter"
  extends Buildings.Electrical.AC.OnePhase.Conversion.ACDCConverter(redeclare
      Interfaces.Terminal_n terminal_n);

  annotation (Documentation(info="<html>
<p>
This is simplified model that represents a conversion betwee a three phases
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
July 24, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ACDCConverter;
