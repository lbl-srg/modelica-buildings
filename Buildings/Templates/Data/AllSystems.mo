within Buildings.Templates.Data;
class AllSystems "Top-level (whole building) system parameters"
  parameter Buildings.Templates.Types.Units sysUni
    "Unit system";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard stdEne
    "Energy standard"
    annotation(Evaluate=true);
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard stdVen
    "Ventilation standard"
    annotation(Evaluate=true);
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone ashCliZon(
    start=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1A)
    "ASHRAE climate zone"
    annotation (Dialog(
    enable=stdEne==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone tit24CliZon(
    start=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_1)
    "California Title 24 climate zone"
    annotation (Dialog(
    enable=stdEne==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24));
annotation (
  defaultComponentPrefixes = "inner parameter",
  defaultComponentName = "datAll",
  Documentation(info="<html>
<p>
This class provides the set of sizing and operating parameters for the whole HVAC system.
</p>
</html>"),
    Icon(graphics={
        Text(
          textColor={0,0,255},
          extent={{-150,60},{150,100}},
          textString="%name"),
        Rectangle(
          origin={0,-25},
          lineColor={64,64,64},
          fillColor={85,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100.0,-75.0},{100.0,75.0}},
          radius=25.0),
        Line(
          points={{-100,0},{100,0}},
          color={64,64,64}),
        Line(
          origin={0,-50},
          points={{-100.0,0.0},{100.0,0.0}},
          color={64,64,64}),
        Line(
          origin={0,-25},
          points={{0.0,75.0},{0.0,-75.0}},
          color={64,64,64})}));

end AllSystems;
