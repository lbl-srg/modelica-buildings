within Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses;
model Floor_Autosizing_MultipleSystems
  "Extension of floor model with autosizing using multiple systems"
  extends Floor(
    eas(hvacSystemName="perimeter"),
    sou(hvacSystemName="perimeter"),
    cor(hvacSystemName="core"),
    nor(hvacSystemName="perimeter"),
    wes(hvacSystemName="perimeter"));
public
  SystemSizing sysSizPer(hvacSystemName="perimeter", autosizeHVAC=true)
    "System sizing object for perimeter system"
    annotation (Placement(transformation(extent={{20,460},{40,480}})));
  SystemSizing sysSizCor(hvacSystemName="core", autosizeHVAC=false)
    "System sizing object for core system"
    annotation (Placement(transformation(extent={{60,460},{80,480}})));
end Floor_Autosizing_MultipleSystems;
