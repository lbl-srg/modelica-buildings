within Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces;
partial block PartialVAVMultizone "Interface class for multiple-zone VAV controller"
  extends
    Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces.PartialController(
      redeclare
      Buildings.Templates.AirHandlersFans.Components.Data.VAVMultiZoneController
      dat(typSecRel=secOutRel.typSecRel));

  outer replaceable Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.Interfaces.PartialOutdoorReliefReturnSection
    secOutRel "Outdoor/relief/return air section";
  outer replaceable Buildings.Templates.Components.Coils.None coiCoo
    "Cooling coil";
  outer replaceable Buildings.Templates.Components.Coils.None coiHeaPre
    "Heating coil (preheat position)";
  outer replaceable Buildings.Templates.Components.Coils.None coiHeaReh
    "Heating coil (reheat position)";

  parameter Buildings.Templates.AirHandlersFans.Types.ControlEconomizer typCtlEco=
    Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.FixedDryBulb
    "Economizer control type"
    annotation (Evaluate=true,
      Dialog(
        tab="Economizer",
        enable=secOutRel.typ<>Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer));

  parameter Buildings.Templates.AirHandlersFans.Types.ControlFanReturn typCtlFanRet=
    Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.AirflowTracking
    "Return fan control type"
    annotation (Evaluate=true,
      Dialog(
        group="System and building parameters",
        enable=typFanRet <> Buildings.Templates.Components.Types.Fan.None));

  parameter Boolean use_TMix=true
    "Set to true if mixed air temperature measurement is enabled"
    annotation(Dialog(
     group="Economizer freeze protection",
     enable=typ<>Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
     secOutRel.typ<>Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer));

  final parameter Boolean use_enthalpy=
    typCtlEco==Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb
    "Set to true if enthalpy measurement is used in addition to temperature measurement"
    annotation (Dialog(
      tab="Economizer",
      enable=secOutRel.typ<>Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer));

  final parameter Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns minOADes=
    if secOutRel.typSecOut==Buildings.Templates.AirHandlersFans.Types.OutdoorSection.SingleDamper
      then Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper
    elseif secOutRel.typSecOut==Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDampersAirflow
      then Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
    elseif secOutRel.typSecOut==Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDampersPressure
      then Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP
    else Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper
    "Design of minimum outdoor air and economizer function"
    annotation (Dialog(group="Economizer design"));

  final parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon=
    if secOutRel.typSecRel==Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReliefDamper
      then Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
    elseif secOutRel.typSecRel==Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReliefFan
      then Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    elseif secOutRel.typSecRel==Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReturnFan
      then (if typCtlFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.AirflowTracking
        then Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
        elseif typCtlFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.BuildingPressure
          then Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp
        else Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper)
    else Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
    "Type of building pressure control system"
    annotation (Dialog(group="Economizer design"));

  annotation (Documentation(info="<html>
</html>"));
end PartialVAVMultizone;
