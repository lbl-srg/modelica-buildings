within Buildings.Fluid.Storage.HeatPumpWaterHeater.Validation.Data;
record Pump
  "Pump performance data for HPWH validation"
  extends Buildings.Fluid.Movers.Data.Generic(
    power(V_flow={0,0.000033, 0.000066, 0.000099, 0.000132, 0.000165, 0.000198, 0.000231, 0.000264, 0.000297, 0.00033},
    P={4.168, 6.236, 8.117, 10.168, 12.749, 16.219, 20.934, 27.255, 35.539, 46.144, 59.429}),
   pressure(V_flow={0.000033, 0.000066, 0.000099, 0.000132, 0.000165, 0.000198, 0.000231, 0.000264, 0.000297, 0.00033},
   dp={17935200, 4483800, 1992800, 1120950, 717408, 498200, 366024.4898, 280237.5, 221422.2222, 179352}),
    motorCooledByFluid=true);
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>Pump performance data record for use in the validation models, derived from the
EnergyPlus example model <code>WaterHeaterHeatPumpWrappedCondenser.idf</code>. The
volume flowrate values are derived by splitting the nominal flowrate from the
EnergyPlus sizing report into ten datapoints. The power values are calculated for
each flowrate datapoint with the power curve coefficients from EnergyPlus.</p>
</html>",   revisions="<html>
<ul>
    <li>
    September 24, 2024 by Xing Lu, Karthik Devaprasad and Cerrina Mouchref:</br>
    First implementation.
    </li>
    </ul>
</html>"));
end Pump;
