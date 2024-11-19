within Buildings.Fluid.Storage.HeatPumpWaterHeater.Validation.Data;
record WaterTank
  "Example water tank data record for hot water tank"
  extends
    Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.Baseclasses.WaterTank(
    hTan = 1.6,
    VTan = 0.287691,
    dIns = 0.05,
    kIns = 0.04,
    hTemSen = 1.0625,
    nSeg = 5,
    hSegBot = 0.08,
    hSegTop = 0.86);

annotation (preferredView="info",
defaultComponentName="datTanWat",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>This record declares the geometry and performance data for the hot water tank
used in the validation models. The record calculates the scaled heating
fraction for each condenser/heat exchanger node based on the geometry data.</p>
</html>",
revisions="<html>
<ul>
    <li>
    September 24, 2024 by Xing Lu, Karthik Devaprasad and Cerrina Mouchref:</br>
    First implementation.
    </li>
    </ul>
</html>"));

end WaterTank;
