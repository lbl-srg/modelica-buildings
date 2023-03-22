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
  parameter Buildings.Templates.Components.Types.ModelBoilerHotWater typModBoiCon
    "Type of boiler model for condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.ModelBoilerHotWater typModBoiNon
    "Type of boiler model for non-condensing boilers"
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
  parameter Boolean have_valHeaWatMinByp
    "Set to true if the plant has a HW minimum flow bypass valve"
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
  parameter Boolean have_varPumHeaWatPri
    "Set to true for variable speed primary HW pumps"
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
    final have_varPumHeaWatPri=have_varPumHeaWatPri,
    final typPumHeaWatSec=typPumHeaWatSec,
    final nPumHeaWatSec=nPumHeaWatSec,
    final have_valHeaWatMinByp=have_valHeaWatMinByp,
    final have_senDpHeaWatLoc=have_senDpHeaWatLoc,
    final nSenDpHeaWatRem=nSenDpHeaWatRem,
    final have_senVHeaWatSec=have_senVHeaWatSec,
    final typArrPumHeaWatPriCon=typArrPumHeaWatPriCon,
    final typArrPumHeaWatPriNon=typArrPumHeaWatPriNon)
    "Controller"
    annotation(Dialog(group="Controls"));

  parameter Buildings.Templates.HeatingPlants.HotWater.Components.Data.BoilerGroup boiCon(
    final nBoi=nBoiCon,
    final typMod=typModBoiCon,
    capBoi_nominal=ctl.capBoiCon_nominal,
    THeaWatBoiSup_nominal=fill(if have_boiCon and have_boiNon then ctl.THeaWatConSup_nominal
     else ctl.THeaWatSup_nominal, nBoiCon))
    "Condensing boilers"
    annotation(Dialog(group="Boilers", enable=have_boiCon));

  parameter Buildings.Templates.HeatingPlants.HotWater.Components.Data.BoilerGroup boiNon(
    final nBoi=nBoiNon,
    final typMod=typModBoiNon,
    capBoi_nominal=ctl.capBoiNon_nominal,
    THeaWatBoiSup_nominal=fill(ctl.THeaWatSup_nominal, nBoiNon))
    "Non-condensing boilers"
    annotation(Dialog(group="Boilers", enable=have_boiNon));

  parameter Buildings.Templates.Components.Data.PumpMultiple pumHeaWatPriCon(
    final nPum=nPumHeaWatPriCon,
    final rho_default=rho_default,
    final typ=if have_boiCon then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=boiCon.mHeaWatBoi_flow_nominal)
    "Primary HW pumps - Condensing boilers"
    annotation(Dialog(group="Primary HW loop", enable=have_boiCon));
  parameter Buildings.Templates.Components.Data.PumpMultiple pumHeaWatPriNon(
    final nPum=nPumHeaWatPriNon,
    final rho_default=rho_default,
    final typ=if have_boiNon then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=boiNon.mHeaWatBoi_flow_nominal)
    "Primary HW pumps - Non-condensing boilers"
    annotation(Dialog(group="Primary HW loop", enable=have_boiNon));
  parameter Buildings.Templates.Components.Data.Valve valHeaWatMinByp(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    m_flow_nominal=(if have_boiCon then max(ctl.VHeaWatBoiCon_flow_min)
      else max(ctl.VHeaWatBoiNon_flow_min)) * rho_default,
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValBypMin)
    "HW minimum flow bypass valve"
    annotation(Dialog(group="Primary HW loop", enable=have_valHeaWatMinByp));

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
