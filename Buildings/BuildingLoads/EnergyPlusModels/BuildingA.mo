within Buildings.BuildingLoads.EnergyPlusModels;
model BuildingA "Model for building A"
 extends BaseClasses.Building(redeclare BaseClasses.A_fmu Building_FMU,
 fmi_fmuLocation="file:////mnt/hgfs/Documents/Projects/District/NewBranch-Electrical/modelica-buildings/Buildings/Resources/Library/FMU/A");
end BuildingA;
