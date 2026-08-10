within Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Configuration;
record Example
  "Example definition of a configuration data record"
  extends
    Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Configuration.Template(
      nBor=4,
      mBor_flow_nominal=0.3,
      dp_nominal=5e4,
      hBor=100.0,
      rBor=0.075,
      dBor=1.0,
      rTub=0.02,
      kTub=0.5,
      eTub=0.002,
      xC=0.05,
      kSoi=2.5);
  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="conDat",
    Documentation(
info="<html>
<p>
This record presents an example for how to define configuration data records
using the template in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Configuration.Template\">
Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Configuration.Template</a>.
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
end Example;
