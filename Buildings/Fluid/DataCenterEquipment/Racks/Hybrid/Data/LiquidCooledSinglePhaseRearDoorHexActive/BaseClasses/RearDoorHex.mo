within Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.BaseClasses;
record RearDoorHex "Data record for active rear door heat exchanger"
  extends Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexPassive.BaseClasses.RearDoorHex;

  parameter Modelica.Units.SI.Power PFan_nominal(final min=0)=-0.04*Q_flow_nominal
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
and overrides the parameterization for an integrated fan.
The nominal air mass flow rate <code>mAir_flow_nominal</code> is derived from
<code>PIT_nominal</code> and the inherited <code>dTAir_nominal</code> (default 10 K),
so the user specifies the IT load rather than the mass flow rate directly.
</p>
<p>
The fan nominal power <code>PFan_nominal</code> defaults to 4% of <code>PIT_nominal</code>.
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
