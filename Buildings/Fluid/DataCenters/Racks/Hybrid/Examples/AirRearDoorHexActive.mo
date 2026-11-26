within Buildings.Fluid.DataCenters.Racks.Hybrid.Examples;
model AirRearDoorHexActive
  "Example model for air-cooled rack with active rear door heat exchanger"
  extends Buildings.Fluid.DataCenters.Racks.Hybrid.Examples.AirRearDoorHexPassive(
    redeclare replaceable parameter Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexActive.Generic dat
    constrainedby Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexActive.Generic(
      air=datAir,
      reaDooHex(
        mAir_flow_nominal=datReaDooHex.mAir_flow_nominal,
        mCoo_flow_nominal=datReaDooHex.mCoo_flow_nominal,
        Q_flow_nominal=datReaDooHex.Q_flow_nominal,
        TAirIn_nominal=datReaDooHex.TAirIn_nominal,
        TCooIn_nominal=datReaDooHex.TCooIn_nominal,
        dpCoo_nominal=datReaDooHex.dpCoo_nominal,
        dpAir_nominal=datReaDooHex.dpAir_nominal,
        cpCoo_nominal=datReaDooHex.cpCoo_nominal,
        cpAir_nominal=datReaDooHex.cpAir_nominal)),
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
November 26, 2026, by Michael Wetter:<br/>
Added <code>parameter</code> prefix to redeclaration of <code>dat</code> and
propagated fields of <code>datReaDooHex</code> through its constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4926\">Buildings, #4926</a>.
</li>
<li>
September 29, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirRearDoorHexActive;
