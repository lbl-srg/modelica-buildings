within Buildings.Fluid.Geothermal.Aquifer.Data;
record Rock "Soil data record of rock heat transfer properties"
  extends Buildings.Fluid.Geothermal.Aquifer.Data.Template(
    kSoi=2.8,
    dSoi=2680,
    cSoi=833,
    phi=0.2,
    K=1E-5);
  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="aquDat",
Documentation(
info="<html>
<p>
This data record contains the heat transfer properties of rock.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 2023, Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end Rock;
