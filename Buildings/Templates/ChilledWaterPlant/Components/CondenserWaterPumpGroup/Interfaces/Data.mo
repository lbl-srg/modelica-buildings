within Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces;
record Data "Data for condenser water pump groups"
  extends Buildings.Templates.Components.Pumps.Interfaces.Data;

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.CondenserWaterPumpGroup typ
    "Type of pump group"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean is_dedicated=
    typ == Buildings.Templates.ChilledWaterPlant.Components.Types.CondenserWaterPumpGroup.Dedicated
    "Pump group is dedicated";

  // Equipment characteristics

  parameter Modelica.Units.SI.PressureDifference dpCWValve_nominal=0
    "Nominal pressure drop of chiller valves on condenser water side"
    annotation(Dialog(group = "Nominal condition", enable=not is_dedicated));


end Data;
