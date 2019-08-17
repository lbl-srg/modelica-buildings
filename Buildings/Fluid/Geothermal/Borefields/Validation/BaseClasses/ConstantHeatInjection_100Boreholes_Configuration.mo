within Buildings.Fluid.Geothermal.Borefields.Validation.BaseClasses;
record ConstantHeatInjection_100Boreholes_Configuration
  "Configuration data record for 100 boreholes validation case"
  extends Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Template(
      borCon = Types.BoreholeConfiguration.SingleUTube,
      cooBor={{7.5*mod(i-1,10), 7.5*floor((i-1)/10)} for i in 1:100},
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
This record contains the configuration data of a field of <i>100</i> boreholes.
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
