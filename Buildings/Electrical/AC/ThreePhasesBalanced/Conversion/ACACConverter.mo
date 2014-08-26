within Buildings.Electrical.AC.ThreePhasesBalanced.Conversion;
model ACACConverter "AC AC converter three phase balanced systems"
  extends Buildings.Electrical.AC.OnePhase.Conversion.ACACConverter(redeclare
      Interfaces.Terminal_n terminal_n, redeclare Interfaces.Terminal_p
      terminal_p);
  annotation (Documentation(info="<html>
<p>
This is simplified model that represents a conversion betwee two AC 
three phases balanced systems. The conversion losses are represented by a 
constant efficiency <code>eta</code>.
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
January 29, 2012, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end ACACConverter;
