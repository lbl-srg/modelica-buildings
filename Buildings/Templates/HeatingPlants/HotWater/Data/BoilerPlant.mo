within Buildings.Templates.HeatingPlants.HotWater.Data;
record BoilerPlant "Record for HW plant model"
  extends Modelica.Icons.Record;

  parameter Boolean have_boiCon
    "Set to true if the plant includes condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_boiNon
    "Set to true if the plant includes non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nBoiCon
    "Number of condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nBoiNon
    "Number of non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.ModelBoilerHotWater typMod
    "Type of boiler model"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary typPumHeaWatSec
    "Type of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPumHeaWatPriCon
    "Number of primary HW pumps - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPumHeaWatPriNon
    "Number of primary HW pumps - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPumHeaWatSec
    "Number of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_valHeaWatMinBypCon
    "Set to true if the condensing boiler group has a HW minimum flow bypass valve"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_valHeaWatMinBypNon
    "Set to true if the non-condensing boiler group has a HW minimum flow bypass valve"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_senDpHeaWatLoc
    "Set to true for local HW differential pressure sensor hardwired to plant controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nSenDpHeaWatRem
    "Number of remote HW differential pressure sensors used for HW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_senVHeaWatSec
    "Set to true if secondary loop is equipped with a flow meter"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPriCon
    "Type of primary HW pump arrangement - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPriNon
    "Type of primary HW pump arrangement - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_varPumHeaWatPriCon
    "Set to true for variable speed primary HW pumps - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_varPumHeaWatPriNon
    "Set to true for variable speed primary HW pumps - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.HeatingPlants.HotWater.Types.Controller typCtl
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.Density rho_default=
    Modelica.Media.Water.ConstantPropertyLiquidWater.d_const
    "HW default density"
    annotation(Dialog(enable=false));

  parameter Buildings.Templates.HeatingPlants.HotWater.Components.Data.Controller ctl(
    final typ=typCtl,
    final have_boiCon=have_boiCon,
    final have_boiNon=have_boiNon,
    final nBoiCon=nBoiCon,
    final nBoiNon=nBoiNon,
    final nPumHeaWatPriCon=nPumHeaWatPriCon,
    final nPumHeaWatPriNon=nPumHeaWatPriNon,
    final have_varPumHeaWatPriCon=have_varPumHeaWatPriCon,
    final have_varPumHeaWatPriNon=have_varPumHeaWatPriNon,
    final typPumHeaWatSec=typPumHeaWatSec,
    final nPumHeaWatSec=nPumHeaWatSec,
    final have_valHeaWatMinBypCon=have_valHeaWatMinBypCon,
    final have_valHeaWatMinBypNon=have_valHeaWatMinBypNon,
    final have_senDpHeaWatLoc=have_senDpHeaWatLoc,
    final nSenDpHeaWatRem=nSenDpHeaWatRem,
    final have_senVHeaWatSec=have_senVHeaWatSec,
    final typArrPumHeaWatPriCon=typArrPumHeaWatPriCon,
    final typArrPumHeaWatPriNon=typArrPumHeaWatPriNon)
    "Controller"
    annotation(Dialog(group="Controls"));

  parameter Buildings.Templates.HeatingPlants.HotWater.Components.Data.BoilerGroup boiCon(
    final nBoi=nBoiCon,
    final typMod=typMod,
    capBoi_nominal=ctl.capBoiCon_nominal,
    THeaWatBoiSup_nominal=fill(if have_boiCon and have_boiNon then ctl.THeaWatConSup_nominal
     else ctl.THeaWatSup_nominal, nBoiCon))
    "Condensing boilers"
    annotation(Dialog(group="Boilers", enable=have_boiCon));

  parameter Buildings.Templates.HeatingPlants.HotWater.Components.Data.BoilerGroup boiNon(
    final nBoi=nBoiNon,
    final typMod=typMod,
    capBoi_nominal=ctl.capBoiNon_nominal,
    THeaWatBoiSup_nominal=fill(ctl.THeaWatSup_nominal, nBoiNon))
    "Non-condensing boilers"
    annotation(Dialog(group="Boilers", enable=have_boiNon));

  parameter Buildings.Templates.Components.Data.PumpMultiple pumHeaWatPriCon(
    final nPum=nPumHeaWatPriCon,
    final rho_default=rho_default,
    final typ=if have_boiCon then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=fill(if have_boiCon then sum(boiCon.mHeaWatBoi_flow_nominal) /
      max(nPumHeaWatPriCon, 1) else 0, nPumHeaWatPriCon))
    "Primary HW pumps - Condensing boilers"
    annotation(Dialog(group="Primary HW loop", enable=have_boiCon));
  parameter Buildings.Templates.Components.Data.PumpMultiple pumHeaWatPriNon(
    final nPum=nPumHeaWatPriNon,
    final rho_default=rho_default,
    final typ=if have_boiNon then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=fill(if have_boiNon then sum(boiNon.mHeaWatBoi_flow_nominal) /
      max(nPumHeaWatPriNon, 1) else 0, nPumHeaWatPriNon))
    "Primary HW pumps - Non-condensing boilers"
    annotation(Dialog(group="Primary HW loop", enable=have_boiNon));
  parameter Buildings.Templates.Components.Data.Valve valHeaWatMinBypCon(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    m_flow_nominal=
      if have_valHeaWatMinBypCon then max(ctl.VHeaWatBoiCon_flow_min) * rho_default
      else 0,
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValBypMin)
    "HW minimum flow bypass valve - Condensing boilers"
    annotation(Dialog(group="Primary HW loop", enable=have_valHeaWatMinBypCon));
  parameter Buildings.Templates.Components.Data.Valve valHeaWatMinBypNon(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    m_flow_nominal=
      if have_valHeaWatMinBypNon then max(ctl.VHeaWatBoiNon_flow_min) * rho_default
      else 0,
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValBypMin)
    "HW minimum flow bypass valve - Non-condensing boilers"
    annotation(Dialog(group="Primary HW loop", enable=have_valHeaWatMinBypNon));

  parameter Buildings.Templates.Components.Data.PumpMultiple pumHeaWatSec(
    final nPum=nPumHeaWatSec,
    final rho_default=rho_default,
    final typ=if typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized
      then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None)
    "Secondary HW pumps"
    annotation(Dialog(group="Secondary HW loop",
    enable=typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized));

  annotation (Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for
HW plant models that can be found within
<a href=\"modelica://Buildings.Templates.HeatingPlants.HotWater\">
Buildings.Templates.HeatingPlants.HotWater</a>.
</p>
<p>
Most of the parameters should be assigned through the sub-record
dedicated to the controller.
All parameters that are also needed to parameterize other plant
components are propagated from the controller sub-record
to the corresponding equipment sub-records.
Note that those parameter bindings are not final so they may be
overwritten in case a component is parameterized at nominal
conditions that differ from the design conditions specified
in the controller sub-record.
</p>
</html>"));

end BoilerPlant;
