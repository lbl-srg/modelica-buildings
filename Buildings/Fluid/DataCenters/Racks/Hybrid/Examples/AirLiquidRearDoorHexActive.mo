within Buildings.Fluid.DataCenters.Racks.Hybrid.Examples;
model AirLiquidRearDoorHexActive
  "Example model for hybrid liquid-cooled and air-cooled rack with active rear door heat exchanger"
  extends
    Buildings.Fluid.DataCenters.Racks.Hybrid.Examples.AirLiquidRearDoorHexPassive(
    redeclare replaceable
      Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirLiquidRearDoorHexActive.Generic
      dat constrainedby
      Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirLiquidRearDoorHexActive.Generic(
      liq=datLiq,
      air=datAir,
      reaDooHex=datReaDooHex),
    redeclare replaceable
      Buildings.Fluid.DataCenters.Racks.Hybrid.AirLiquidRearDoorHexActive rac
      constrainedby
      Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses.PartialAirLiquidRearDoorHex(
      redeclare package MediumLiq = MediumLiq,
      redeclare package MediumAir = MediumAir,
      redeclare package MediumReaDooHex = MediumReaDooHex,
      dat=dat),
    redeclare replaceable parameter
      Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Active.Generic
      datReaDooHex constrainedby
      Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Passive.Generic);

  annotation (
    experiment(
      StopTime=7200,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DataCenters/Racks/Hybrid/Examples/AirLiquidRearDoorHexActive.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model of a hybrid IT rack with liquid-cooled, air-cooled, and active rear door
heat exchanger components.
</p>
<p>
This model is identical to
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.Hybrid.Examples.AirLiquidRearDoorHexPassive\">
Buildings.Fluid.DataCenters.Racks.Hybrid.Examples.AirLiquidRearDoorHexPassive</a>
except that the rear door heat exchanger has a built-in fan.
</p>
</html>", revisions="<html>
<ul>
<li>
September 17, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirLiquidRearDoorHexActive;
