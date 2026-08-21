within Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Filling;
record Bentonite
  "Filling data record of Bentonite heat transfer properties"
  extends
    Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Filling.Template(
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
June 22, 2026, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Bentonite;
