within Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses;
model Floor_Autosizing_MultipleSystems
  "Extension of floor model with autosizing for multiple systems"
  extends Floor(
    eas(hvacSystemName="perimeter", ach_inf=0.25),
    sou(hvacSystemName="perimeter", ach_inf=0.25),
    cor(hvacSystemName="core"),
    nor(hvacSystemName="perimeter", ach_inf=0.25),
    wes(hvacSystemName="perimeter", ach_inf=0.25));
public
  SystemSizing sysSizPer(hvacSystemName="perimeter", autosizeHVAC=true)
    "System sizing object for perimeter system"
    annotation (Placement(transformation(extent={{20,460},{40,480}})));
  SystemSizing sysSizCor(hvacSystemName="core", autosizeHVAC=false)
    "System sizing object for core system"
    annotation (Placement(transformation(extent={{60,460},{80,480}})));
annotation(Documentation(
revisions="<html>
<ul>
<li>
July 22, 2026, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end Floor_Autosizing_MultipleSystems;
