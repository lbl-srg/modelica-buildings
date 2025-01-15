within Buildings.Templates.Plants.Chillers.Validation.UserProject.Data;
partial class AllSystems "Base class for storing system parameters"
  extends Buildings.Templates.Data.AllSystems;

  // The following instance name matches the system tag.
  outer replaceable Buildings.Templates.Plants.Chillers.Interfaces.PartialChilledWaterLoop CHI;

  parameter Buildings.Templates.Plants.Chillers.Data.ChilledWaterPlant _CHI
    "CHW plant parameters";
  annotation (Documentation(info="<html>
<p>
This is the base class used for storing system parameters.
</p>
</html>"));
end AllSystems;
