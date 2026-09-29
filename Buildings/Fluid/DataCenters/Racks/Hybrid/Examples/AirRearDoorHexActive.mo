within Buildings.Fluid.DataCenters.Racks.Hybrid.Examples;
model AirRearDoorHexActive
  "Example model for air-cooled rack with active rear door heat exchanger"
  extends
    Buildings.Fluid.DataCenters.Racks.Hybrid.Examples.AirRearDoorHexPassive(
      redeclare replaceable Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexActive.Generic dat
      constrainedby Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexActive.Generic(
        air=datAir,
        reaDooHex=datReaDooHex),
    redeclare replaceable Buildings.Fluid.DataCenters.Racks.Hybrid.AirRearDoorHexActive rac
      constrainedby Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses.PartialAirRearDoorHex(
        redeclare package MediumAir = MediumAir,
        redeclare package MediumReaDooHex = MediumReaDooHex,
        dat=dat),
    redeclare replaceable parameter Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Active.Generic datReaDooHex
      constrainedby Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Passive.Generic);

  annotation (
    experiment(
      StopTime=7200,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DataCenters/Racks/Hybrid/Examples/AirRearDoorHexActive.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model of an air-cooled IT rack with an active rear door
heat exchanger.
</p>
<p>
This model is identical to
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.Hybrid.Examples.AirRearDoorHexPassive\">
Buildings.Fluid.DataCenters.Racks.Hybrid.Examples.AirRearDoorHexPassive</a>
except that the rear door heat exchanger has a built-in fan.
</p>
</html>", revisions="<html>
<ul>
<li>
September 29, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirRearDoorHexActive;
