within Buildings.Fluid.Geothermal.Borefields.Validation.BaseClasses;
record ConstantHeatInjection_100Boreholes_Configuration
  "Configuration data record for 100 boreholes validation case"
  extends Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Template(
      borCon = Types.BoreholeConfiguration.SingleUTube,
      cooBor=[0.0, 0.0;
7.5, 0.0;
15.0, 0.0;
22.5, 0.0;
30.0, 0.0;
37.5, 0.0;
45.0, 0.0;
52.5, 0.0;
60.0, 0.0;
67.5, 0.0;
0.0, 7.5;
7.5, 7.5;
15.0, 7.5;
22.5, 7.5;
30.0, 7.5;
37.5, 7.5;
45.0, 7.5;
52.5, 7.5;
60.0, 7.5;
67.5, 7.5;
0.0, 15.0;
7.5, 15.0;
15.0, 15.0;
22.5, 15.0;
30.0, 15.0;
37.5, 15.0;
45.0, 15.0;
52.5, 15.0;
60.0, 15.0;
67.5, 15.0;
0.0, 22.5;
7.5, 22.5;
15.0, 22.5;
22.5, 22.5;
30.0, 22.5;
37.5, 22.5;
45.0, 22.5;
52.5, 22.5;
60.0, 22.5;
67.5, 22.5;
0.0, 30.0;
7.5, 30.0;
15.0, 30.0;
22.5, 30.0;
30.0, 30.0;
37.5, 30.0;
45.0, 30.0;
52.5, 30.0;
60.0, 30.0;
67.5, 30.0;
0.0, 37.5;
7.5, 37.5;
15.0, 37.5;
22.5, 37.5;
30.0, 37.5;
37.5, 37.5;
45.0, 37.5;
52.5, 37.5;
60.0, 37.5;
67.5, 37.5;
0.0, 45.0;
7.5, 45.0;
15.0, 45.0;
22.5, 45.0;
30.0, 45.0;
37.5, 45.0;
45.0, 45.0;
52.5, 45.0;
60.0, 45.0;
67.5, 45.0;
0.0, 52.5;
7.5, 52.5;
15.0, 52.5;
22.5, 52.5;
30.0, 52.5;
37.5, 52.5;
45.0, 52.5;
52.5, 52.5;
60.0, 52.5;
67.5, 52.5;
0.0, 60.0;
7.5, 60.0;
15.0, 60.0;
22.5, 60.0;
30.0, 60.0;
37.5, 60.0;
45.0, 60.0;
52.5, 60.0;
60.0, 60.0;
67.5, 60.0;
0.0, 67.5;
7.5, 67.5;
15.0, 67.5;
22.5, 67.5;
30.0, 67.5;
37.5, 67.5;
45.0, 67.5;
52.5, 67.5;
60.0, 67.5;
67.5, 67.5],
      mBor_flow_nominal=0.3,
      dp_nominal=5e4,
      hBor=150.0,
      rBor=0.075,
      dBor=4.0,
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
This record contains the configuration data of a field of <i>100</i> boreholes..
</p>
</html>",
revisions="<html>
<ul>
<li>
May 27, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConstantHeatInjection_100Boreholes_Configuration;
