within Buildings.BuildingLoads.EnergyPlusModels;
model BuildingB "Model for building B"
 extends BaseClasses.Building(redeclare BaseClasses.B_fmu Building_FMU,
 fmi_fmuLocation="/mnt/hgfs/Documents/Projects/District/NewBranch-Electrical/modelica-buildings/Buildings/Resources/Library/FMU/B");
end BuildingB;
