within Buildings.Fluid.Storage.HeatPumpWaterHeater.Data;
record PumpedCondenser "Pumped condenser heat pump water heater data"
  extends Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.WrappedCondenser(
    redeclare Buildings.Fluid.DXSystems.Cooling.WaterSource.Data.Generic.DXCoil
      datCoi);
  replaceable parameter Buildings.Fluid.Movers.Data.Generic datPum
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Sizing and performance data for condenser pump"
    annotation(choicesAllMatching=true);

annotation (preferredView="info",
defaultComponentName="datPumHPWH",
Documentation(info="<html>
<p>This record declares the performance data for the components in the pumped condenser 
heat pump water heater, including the water tank, evaporator fan, heat pump system 
and the condenser pump. The parameters for the integrated heat exchanger in the 
water tank are included within the water tank data record <code>datTanWat</code>.</p>
</html>",
revisions="<html>
<ul>
    <li>
    September 24, 2024 by Karthik Devaprasad:</br>
    First implementation.
    </li>
    </ul>
</html>"));

end PumpedCondenser;
