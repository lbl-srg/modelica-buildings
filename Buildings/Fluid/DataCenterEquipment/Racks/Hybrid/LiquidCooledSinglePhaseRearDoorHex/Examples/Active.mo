within Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Examples;
model Active
  "Example model for hybrid liquid-cooled and air-cooled rack with active rear door heat exchanger"
  extends Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Examples.Passive(
    redeclare replaceable Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.Generic dat,
    redeclare replaceable Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Active rac);

  Controls.OBC.CDL.Reals.Sources.Constant TSetReaDooRet(k=273.15 + 35)
    "Temperature setpoint for return water from rear door heat exchanger"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
equation
  connect(TSetReaDooRet.y, rac.TSetReaDooHex) annotation (Line(points={{62,30},
          {70,30},{70,14},{50,14},{50,12}}, color={0,0,127}));
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
