within Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses;
model Floor_Autosizing "Extension of floor model with autosizing for one system"
  extends Floor(
    eas(hvacSystemName="VAV1"),
    sou(hvacSystemName="VAV1"),
    cor(hvacSystemName="VAV1"),
    nor(hvacSystemName="VAV1"),
    wes(hvacSystemName="VAV1"));
  SystemSizing sysVAV1(hvacSystemName="VAV1", autosizeHVAC=true)
    "System sizing object for VAV1"
    annotation (Placement(transformation(extent={{80,460},{100,480}})));
annotation(Documentation(
revisions="<html>
<ul>
<li>
July 22, 2026, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end Floor_Autosizing;
