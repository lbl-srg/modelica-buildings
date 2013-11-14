within Buildings.BuildingLoads.EnergyPlusModels;
model BuildingC "Model for building C"
 extends BaseClasses.Building(redeclare BaseClasses.C_fmu Building_FMU,
 fmi_fmuLocation="/mnt/hgfs/Documents/Projects/District/NewBranch-Electrical/modelica-buildings/Buildings/Resources/Library/FMU/C");
end BuildingC;
