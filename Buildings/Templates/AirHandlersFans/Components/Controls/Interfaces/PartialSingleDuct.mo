within Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces;
partial block PartialSingleDuct "Partial control block for single duct AHU"
  extends Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces.PartialController;

  parameter Buildings.Templates.AirHandlersFans.Types.ControlSupplyFan typCtrFanSup=
    Buildings.Templates.AirHandlersFans.Types.ControlSupplyFan.Airflow
    "Supply fan control type"
    annotation (Evaluate=true,
      Dialog(
        group="System and building parameters",
        enable=typFanSup <> Buildings.Templates.Components.Types.Fan.None));

  // FIXME: implement computation based on speed if Calculated.
  parameter Buildings.Templates.AirHandlersFans.Types.ControlReturnFan typCtrFanRet=
    Buildings.Templates.AirHandlersFans.Types.ControlReturnFan.Airflow
    "Return fan control type"
    annotation (Evaluate=true,
      Dialog(
        group="System and building parameters",
        enable=typFanRet <> Buildings.Templates.Components.Types.Fan.None));

  parameter Boolean use_enthalpy=false
    "Set to true if enthalpy measurement is used in addition to temperature measurement"
    annotation (Dialog(
      tab="Economizer",
      enable=secOutRel.typ<>Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer));

  parameter Boolean use_TMix=true
    "Set to true if mixed air temperature measurement is enabled"
     annotation(Dialog(
       group="Economizer freeze protection",
       enable=secOutRel.typ<>Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer));

  outer replaceable
    OutdoorReliefReturnSection.Interfaces.PartialOutdoorReliefReturnSection
    secOutRel "Outdoor/relief/return air section";

  outer replaceable Buildings.Templates.Components.Coils.None coiCoo
    "Cooling coil";
  outer replaceable Buildings.Templates.Components.Coils.None coiHea
    "Heating coil";
  outer replaceable Buildings.Templates.Components.Coils.None coiReh
    "Reheat coil";

  outer parameter Buildings.Templates.Components.Types.Fan typFanSup
    "Type of supply fan";
  outer parameter Buildings.Templates.Components.Types.Fan typFanRet
    "Type of relief/return fan";

  annotation (Documentation(info="<html>
</html>"));
end PartialSingleDuct;
