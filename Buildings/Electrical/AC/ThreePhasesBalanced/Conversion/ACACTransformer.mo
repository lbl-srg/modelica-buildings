within Buildings.Electrical.AC.ThreePhasesBalanced.Conversion;
model ACACTransformer "AC AC transformer three phase balanced systems"
  extends Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer(
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p);
  annotation (
  defaultComponentName="traACAC",
  Documentation(info="<html>
<p>
Simple transformer model for three-phase
balanced AC systems. The model does not include core and
magnetic losses.
</p>
<p>
See model
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer\">
Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer</a> for more
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
end ACACTransformer;
