within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Validation.Data;
record FanData "Fan data for the validation model"
  extends Buildings.Fluid.Movers.Data.Generic(
    speed_rpm_nominal=2900,
    power(
      V_flow={0, 0.042691, 0.085382, 0.128073, 0.170764, 0.213455, 0.256146,
        0.298837, 0.341528, 0.384219, 0.42691},
      P={4.510,6.747,8.782, 11.002,13.794,17.548, 22.650, 29.489, 38.451, 49.926,
        64.300}),
    pressure(
      V_flow={0.042691, 0.085382, 0.128073, 0.170764, 0.213455, 0.256146, 0.298837,
        0.341528, 0.384219, 0.42691},
      dp={7500,1875,833.33,468.75,300,208.33,153.06,117.1875, 92.59, 75}),
    motorCooledByFluid=true);
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datFan",
Documentation(info="<html>
<p>
Fan performance data record based on EnergyPlus example file available in the 
Buildings library
(modelica-buildings/Buildings/Resources/Data/Fluid/ZoneEquipment/PackagedTerminalHeatPump/1ZonePTHP.idf).
<br>
The volume flowrate values are derived by splitting the nominal flowrate from the 
EnergyPlus sizing report into ten datapoints. The power values are calculated for 
each flowrate datapoint with the power curve coefficients from EnergyPlus. 
</p>
</html>",   revisions="<html>
<ul>
<li>
April 10, 2023, by Xing Lu and Karthik Devaprasad:
<br/>
First implementation.
</li>
</ul>
</html>"));
end FanData;
