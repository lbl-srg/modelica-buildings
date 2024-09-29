within Buildings.Fluid.Storage.HeatPumpWaterHeater.Validation.Data;
record Fan
  "Fan data"
  extends Buildings.Fluid.Movers.Data.Generic(
    power(V_flow={0,0.0189917,0.0379834,0.0569751,0.0759668,0.0949585,
    0.1139502,0.1329419,0.1519336,0.1709253,0.189917}, P={0.869,1.301,1.693,
    2.121,2.659,3.383,4.366,5.685,7.412,9.624,12.395}),
   pressure(V_flow={0.0189917,0.0379834,0.0569751,0.0759668,0.0949585,
    0.1139502,0.1329419,0.1519336,0.1709253,0.189917}, dp={6500,1625,722.2222222,
    406.25,260,180.5555556,132.6530612,101.5625,80.24691358,65}),
    motorCooledByFluid=true);
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>Fan performance data record.  The volume flowrate values are derived by splitting
the nominal flowrate from the EnergyPlus sizing report into ten datapoints. The
power values are calculated for each flowrate datapoint with the power curve
coefficients from EnergyPlus. </p>
</html>",   revisions="<html>
<ul>
    <li>
    September 24, 2024 by Xing Lu, Karthik Devaprasad and Cerrina Mouchref:</br>
    First implementation.
    </li>
    </ul>
</html>"));
end Fan;
