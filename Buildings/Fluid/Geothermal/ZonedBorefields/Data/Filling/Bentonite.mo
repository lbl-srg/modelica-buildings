within Buildings.Fluid.Geothermal.ZonedBorefields.Data.Filling;
record Bentonite
  "Filling data record of Bentonite heat transfer properties"
  extends
    Buildings.Fluid.Geothermal.ZonedBorefields.Data.Filling.Template(
    kFil=1.15,
    dFil=1600,
    cFil=800);
  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="filDat",
Documentation(
info="<html>
<p>
This filling data record contains the heat transfer properties of bentonite.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 15, 2018, by Michael Wetter:<br/>
Revised implementation, added <code>defaultComponentPrefixes</code> and
<code>defaultComponentName</code>.
</li>
<li>
June 28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end Bentonite;
