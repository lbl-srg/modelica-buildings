within Buildings.Fluid.Storage.HeatPumpWaterHeater.Data;
record WrappedCondenser
  "Wrapped condenser heat pump water heater data"
  extends Modelica.Icons.Record;
  replaceable parameter Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.Baseclasses.WaterTank datTanWat
    constrainedby Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.Baseclasses.WaterTank
    "Sizing and performance data for water tank and integrated condenser coil/heat exchanger"
    annotation(choicesAllMatching=true);

  replaceable parameter Buildings.Fluid.Movers.Data.Generic datFan
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Sizing and performance data for evaporator fan"
    annotation(choicesAllMatching=true);

  replaceable parameter Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil datCoi
    constrainedby Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil
    "Sizing and performance data for evaporator coil"
    annotation(choicesAllMatching=true);

annotation (preferredView="info",
defaultComponentName="datWraHPWH",
Documentation(info="<html>
<p>This record declares the performance data for the components in the wrapped condenser 
heat pump water heater, including the water tank, evaporator fan and the evaporator 
coil. The parameters for the integrated condenser coil in the water tank are included
within the water tank data record <code>datTanWat</code>.</p>
</html>",
revisions="<html>
<ul>
    <li>
    September 24, 2024 by Karthik Devaprasad:</br>
    First implementation.
    </li>
    </ul>
</html>"));

end WrappedCondenser;
