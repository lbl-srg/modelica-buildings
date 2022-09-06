within Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces;
partial block PartialVAVMultizone "Interface class for multiple-zone VAV controller"
  extends
    Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces.PartialController(
      redeclare
      Buildings.Templates.AirHandlersFans.Components.Data.VAVMultiZoneController
      dat(typSecRel=secOutRel.typSecRel,
      stdEne=stdEne,
      stdVen=stdVen,
      have_CO2Sen=have_CO2Sen));

  outer replaceable Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.Interfaces.PartialOutdoorReliefReturnSection
    secOutRel "Outdoor/relief/return air section";
  outer replaceable Buildings.Templates.Components.Coils.None coiCoo
    "Cooling coil";
  outer replaceable Buildings.Templates.Components.Coils.None coiHeaPre
    "Heating coil (preheat position)";
  outer replaceable Buildings.Templates.Components.Coils.None coiHeaReh
    "Heating coil (reheat position)";

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer typCtlEco=
    Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb
    "Economizer control type"
    annotation (Evaluate=true,
      Dialog(
        tab="Economizer",
        enable=secOutRel.typ<>Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer));

  parameter Buildings.Templates.AirHandlersFans.Types.ControlFanReturn typCtlFanRet=
    Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.AirflowMeasured
    "Return fan control type"
    annotation (Evaluate=true,
      Dialog(
        group="Configuration",
        enable=typFanRet <> Buildings.Templates.Components.Types.Fan.None));

  parameter Boolean use_TMix=true
    "Set to true if mixed air temperature measurement is enabled"
    annotation(Dialog(
     group="Economizer",
     enable=typ<>Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
       secOutRel.typ<>Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat typFreSta=
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
    "Type of freeze stat"
    annotation(Evaluate=true);

  final parameter Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection typSecOut=
    secOutRel.typSecOut
    "Type of outdoor air section"
    annotation (Dialog(group="Economizer"));

  final parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon=
    if secOutRel.typSecRel==Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReliefDamper
      then Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
    elseif secOutRel.typSecRel==Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReliefFan
      then Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    elseif secOutRel.typSecRel==Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReturnFan
      then (if typCtlFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.AirflowCalculated
          then Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
        elseif typCtlFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.AirflowMeasured
          then Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
        elseif typCtlFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.BuildingPressure
          then Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp
        else Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper)
    else Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
    "Type of building pressure control system"
    annotation (Dialog(group="Economizer"));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard stdEne=
    Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.Not_Specified
    "Energy standard, ASHRAE 90.1 or Title 24"
    annotation(Dialog(enable=
    typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone),
    Evaluate=true);

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard stdVen=
    Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.Not_Specified
    "Ventilation standard, ASHRAE 62.1 or Title 24"
    annotation(Dialog(enable=
    typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone),
    Evaluate=true);

  parameter Boolean have_CO2Sen=false
    "Set to true if there are zones with CO2 sensor"
    annotation (Dialog(group="Configuration",
      enable=
      typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      typSecOut==Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure and
      stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016));

initial equation
  if typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone then
    // We check the fallback "else" clause.
    if buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper then
      assert(secOutRel.typSecRel==Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReliefDamper,
       "In "+ getInstanceName() + ": "+
       "The system configuration is incompatible with available options for building pressure control.");
    end if;
    assert(stdVen<>Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.Not_Specified,
      "In "+ getInstanceName() + ": "+
      "The ventilation standard cannot be unspecified.");
    assert(stdEne<>Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.Not_Specified,
      "In "+ getInstanceName() + ": "+
      "The energy standard cannot be unspecified.");
  end if;

  annotation (Documentation(info="<html>
<p>
This partial class provides a standard interface for multiple-zone VAV controllers.
</p>
</html>"));
end PartialVAVMultizone;
