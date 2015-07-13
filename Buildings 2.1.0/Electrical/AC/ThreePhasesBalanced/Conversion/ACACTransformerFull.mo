within Buildings.Electrical.AC.ThreePhasesBalanced.Conversion;
model ACACTransformerFull
  "AC AC transformer full model for three phase balanced systems"
  extends Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformerFull(
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p);
  annotation (
defaultComponentName="traACAC",
Documentation(info="<html>
<p>
Model of a transformer for three-phase
balanced AC systems. The model includes core and magnetic losses.
</p>
<p>
See model
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformerFull\">
Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformerFull</a> for more
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
end ACACTransformerFull;
