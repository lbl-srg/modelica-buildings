within Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Interfaces;
record Data "Data for primary pump groups"
  extends Buildings.Templates.Components.Pumps.Interfaces.Data;

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPumpGroup typ "Type of pump"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_byp "= true if primary pump group has a return bypass"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_chiByp "= true if chilled water loop has a chiller bypass"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPum "Number of pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean is_dedicated=
    typ == Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPumpGroup.Dedicated;

  // Equipment characteristics

  parameter Modelica.Units.SI.PressureDifference dpCHWValve_nominal=0
    "Nominal pressure drop of chiller valves on chilled water side"
    annotation(Dialog(group = "Nominal condition", enable=not is_dedicated));
  parameter Modelica.Units.SI.PressureDifference dpByp_nominal=0
    "Bypass valve pressure drop"
    annotation(Dialog(enable=have_byp));
  parameter Modelica.Units.SI.PressureDifference dpChiByp_nominal=0
    "Chiller bypass valve pressure drop"
    annotation(Dialog(enable=have_chiByp));

end Data;
