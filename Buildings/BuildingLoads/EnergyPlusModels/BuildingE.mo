within Buildings.BuildingLoads.EnergyPlusModels;
model BuildingE "Model for building E"
 extends BaseClasses.Building(redeclare BaseClasses.E_fmu Building_FMU,
 fmi_fmuLocation="/mnt/hgfs/Documents/Projects/District/NewBranch-Electrical/modelica-buildings/Buildings/Resources/Library/FMU/E");
end BuildingE;
