within Buildings.BuildingLoads.EnergyPlusModels;
model BuildingD "Model for building D"
 extends BaseClasses.Building(redeclare BaseClasses.D_fmu Building_FMU,
 fmi_fmuLocation="/mnt/hgfs/Documents/Projects/District/NewBranch-Electrical/modelica-buildings/Buildings/Resources/Library/FMU/D");
end BuildingD;
