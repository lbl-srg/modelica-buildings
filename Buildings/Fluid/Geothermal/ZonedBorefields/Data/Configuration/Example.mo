within Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration;
record Example "Configuration data record for examples"
  extends
    Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Template(
    borCon=Borefields.Types.BoreholeConfiguration.SingleUTube,
    cooBor={{4.50,0.00},{7.50,0.00}},
    mBor_flow_nominal={0.5,0.5},
    dp_nominal={5e4,5e4},
    hBor=100.0,
    rBor=0.075,
    dBor=1.0,
    nZon=2,
    iZon={1,2},
    rTub=0.02,
    kTub=0.5,
    eTub=0.002,
    xC=0.05);
  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="conDat",
    Documentation(
info="<html>
<p>
This record presents an example for how to define configuration data records
using the template in
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Template\">
Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Template</a>.
</p>
<p>
The configuration consists in 524 boreholes divided into 4 zones of 80, 148,
148 and 148 boreholes. The borefield is configured in a cylindrical arrangement
with the 4 zones distributed in annular regions. The borefield configuration
is shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/ZonedBorefields/ExampleConfiguration.png\" />
</p>
</html>",
revisions="<html>
<ul>
<li>
February 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end Example;
