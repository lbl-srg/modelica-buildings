within Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Examples;
model Active
  "Example model for hybrid liquid-cooled and air-cooled rack with active rear door heat exchanger"
  extends Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Examples.Passive(
    redeclare replaceable Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.Generic dat
    constrainedby Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.Generic(
      liq=datLiq,
      air=datAir,
      reaDooHex=datReaDooHex),
    redeclare replaceable Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Active rac
    constrainedby Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.BaseClasses.PartialRack(
      redeclare package MediumLiq = MediumLiq,
      redeclare package MediumAir = MediumAir,
      redeclare package MediumReaDooHex = MediumReaDooHex,
      dat=dat),
    redeclare replaceable parameter
      Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.BaseClasses.RearDoorHex
      datReaDooHex
    constrainedby
      Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexPassive.BaseClasses.RearDoorHex);

  Controls.OBC.CDL.Reals.Sources.Constant TSetReaDooRet(k=273.15 + 30)
    "Temperature setpoint for air leaving rear door heat exchanger"
    annotation (Placement(transformation(extent={{6,-50},{26,-30}})));
equation
  connect(TSetReaDooRet.y, rac.TSetReaDooHexAir) annotation (Line(points={{28,-40},
          {32,-40},{32,2},{38,2}},             color={0,0,127}));
  annotation (
    experiment(
      StopTime=7200,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DataCenterEquipment/Racks/Hybrid/LiquidCooledSinglePhaseRearDoorHex/Examples/Active.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model of a hybrid IT rack with liquid-cooled, air-cooled, and active rear door
heat exchanger components.
</p>
<p>
This model is identical to
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Examples.Passive\">
Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Examples.Passive</a>
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
end Active;
