within Buildings.Templates.ChilledWaterPlants.Validation.UserProject.Data;
class AllSystems "Base class for storing system parameters"
  extends Buildings.Templates.Data.AllSystems;

  // The following instance name matches the system tag.
  outer replaceable Buildings.Templates.ChilledWaterPlants.Interfaces.PartialChilledWaterLoop CHI;

  parameter Buildings.Templates.ChilledWaterPlants.Data.ChilledWaterPlant _CHI
    "CHW plant parameters";
end AllSystems;
