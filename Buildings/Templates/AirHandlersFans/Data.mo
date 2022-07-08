within Buildings.Templates.AirHandlersFans;
package Data "Records for design and operating parameters"
  extends Modelica.Icons.MaterialPropertiesPackage;

  record PartialAirHandler "Record for air handler interface class"
    extends Modelica.Icons.Record;

    parameter Buildings.Templates.AirHandlersFans.Types.Configuration typ
      "Type of system"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Fan typFanSup
      "Type of supply fan"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Fan typFanRet
      "Type of return fan"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Fan typFanRel
      "Type of relief fan"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Boolean have_souChiWat
      "Set to true if cooling coil requires fluid ports on the source side"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Boolean have_souHeaWat
      "Set to true if heating coil requires fluid ports on the source side"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.AirHandlersFans.Types.Controller typCtl
      "Type of controller"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

    parameter String id
     "System tag"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    parameter String id_souChiWat=""
      "CHW supply system tag"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=have_souChiWat));
    parameter String id_souHeaWat=""
      "HHW supply system tag"
      annotation (Evaluate=true, Dialog(group="Configuration",
      enable=have_souHeaWat));

    parameter Modelica.Units.SI.MassFlowRate mAirSup_flow_nominal
      "Supply air mass flow rate"
      annotation (Dialog(group="Mechanical",
        enable=typ<>Buildings.Templates.AirHandlersFans.Types.Configuration.ExhaustOnly));

    parameter Modelica.Units.SI.MassFlowRate mAirRet_flow_nominal
      "Return air mass flow rate"
      annotation (Dialog(group="Mechanical",
        enable=typ<>Buildings.Templates.AirHandlersFans.Types.Configuration.SupplyOnly));

    replaceable parameter Buildings.Templates.AirHandlersFans.Components.Data.PartialController
      ctl(
      final typFanSup=typFanSup,
      final typFanRel=typFanRel,
      final typFanRet=typFanRet,
      final typ=typCtl)
      "Controller"
      annotation (Dialog(group="Controls"));
  end PartialAirHandler;

  record VAVMultiZone "Record for multiple-zone VAV"
    extends Buildings.Templates.AirHandlersFans.Data.PartialAirHandler(
      redeclare Buildings.Templates.AirHandlersFans.Components.Data.VAVMultiZoneController
      ctl(
        final typSecRel=typSecRel,
        final typSecOut=typSecOut,
        final buiPreCon=buiPreCon),
      final mAirSup_flow_nominal=if typFanSup<>Buildings.Templates.Components.Types.Fan.None
      then fanSup.m_flow_nominal else 0,
      final mAirRet_flow_nominal=if typFanRet<>Buildings.Templates.Components.Types.Fan.None
      then fanRet.m_flow_nominal
      elseif typFanRel<>Buildings.Templates.Components.Types.Fan.None
      then fanRel.m_flow_nominal
      elseif typFanSup<>Buildings.Templates.Components.Types.Fan.None
      then fanSup.m_flow_nominal else 0);

    parameter Buildings.Templates.Components.Types.Coil typCoiHeaPre
      "Type of heating coil in preheat position"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Coil typCoiCoo
      "Type of cooling coil"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Coil typCoiHeaReh
      "Type of heating coil in reheat position"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Valve typValCoiHeaPre
      "Type of valve for heating coil in preheat position"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Valve typValCoiCoo
      "Type of valve for cooling coil"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Valve typValCoiHeaReh
      "Type of valve for heating coil in reheat position"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection typSecOut
      "Type of outdoor air section"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
      "Type of building pressure control system"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

    parameter Buildings.Templates.Components.Data.Fan fanSup(
      final typ=typFanSup)
      "Supply fan"
      annotation (Dialog(
      group="Fans", enable=typFanSup <> Buildings.Templates.Components.Types.Fan.None));

    extends
      Buildings.Templates.AirHandlersFans.Components.Data.OutdoorReliefReturnSection(
      fanRel,
      fanRet,
      damOut(
        m_flow_nominal=mAirSup_flow_nominal),
      damOutMin(
        m_flow_nominal=mOutMin_flow_nominal),
      damRel(
        m_flow_nominal=mAirRet_flow_nominal),
      damRet(
        m_flow_nominal=mAirRet_flow_nominal))
      annotation (
        Dialog(group="Dampers and economizer"));

    parameter Buildings.Templates.Components.Data.Coil coiHeaPre(
      final typ=typCoiHeaPre,
      final typVal=typValCoiHeaPre,
      final have_sou=have_souHeaWat,
      mAir_flow_nominal=mAirSup_flow_nominal)
      "Heating coil in preheat position"
      annotation (Dialog(group="Coils",
      enable=typCoiHeaPre <> Buildings.Templates.Components.Types.Coil.None));

    parameter Buildings.Templates.Components.Data.Coil coiCoo(
      final typ=typCoiCoo,
      final typVal=typValCoiCoo,
      final have_sou=have_souChiWat,
      mAir_flow_nominal=mAirSup_flow_nominal)
      "Cooling coil"
      annotation (Dialog(
      group="Coils", enable=typCoiCoo <> Buildings.Templates.Components.Types.Coil.None));

    parameter Buildings.Templates.Components.Data.Coil coiHeaReh(
      final typ=typCoiHeaReh,
      final typVal=typValCoiHeaReh,
      final have_sou=have_souHeaWat,
      mAir_flow_nominal=mAirSup_flow_nominal)
      "Heating coil in reheat position"
      annotation (Dialog(group="Coils",
      enable=typCoiHeaReh <> Buildings.Templates.Components.Types.Coil.None));

  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName = "dat");
  end VAVMultiZone;
annotation (Documentation(info="<html>
<p>
This package provides records for design and operating parameters.
</p>
</html>"));
end Data;
