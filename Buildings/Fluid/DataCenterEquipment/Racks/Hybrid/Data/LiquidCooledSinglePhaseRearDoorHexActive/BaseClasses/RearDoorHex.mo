within Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.BaseClasses;
record RearDoorHex "Data record for active rear door heat exchanger"
  extends Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexPassive.BaseClasses.RearDoorHex;

  parameter Modelica.Units.SI.Power PFan_nominal(final min=0)=mAir_flow_nominal*dpAir_nominal/eta_nominal/Buildings.Media.Air.dStp
    "Fan power at full speed"
    annotation (Dialog(group="Fan power"));

  parameter Real eta_nominal(
    final unit="1",
    final min=Modelica.Constants.small) = 0.7
    "Fan and motor combined efficiency at nominal conditions"
    annotation(Dialog(group="Fan"));
annotation (
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Data record for an active rear door heat exchanger used in IT rack models.
</p>
<p>
This record extends
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexPassive.BaseClasses.RearDoorHex\">
Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexPassive.BaseClasses.RearDoorHex</a>
and adds performance data for the fans.l</code> defaults to 4% of <code>PIT_nominal</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 18, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end RearDoorHex;
