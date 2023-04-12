within Buildings.Templates.HeatingPlants.HotWater.Components.Data;
record Controller "Record for plant controller"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.HeatingPlants.HotWater.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
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
  parameter Integer nPumHeaWatPriCon
    "Number of primary HW pumps - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPumHeaWatPriNon
    "Number of primary HW pumps - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_varPumHeaWatPri
    "Set to true for variable speed primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary typPumHeaWatSec
    "Type of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
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

  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal(
    displayUnit="degC",
    start=Buildings.Templates.Data.Defaults.THeaWatSup,
    final min=273.15)
    "Design (highest) HW supply temperature setpoint"
    annotation(Dialog(group="Temperature setpoints"));
  parameter Modelica.Units.SI.Temperature THeaWatConSup_nominal(
    displayUnit="degC",
    start=Buildings.Templates.Data.Defaults.THeaWatSup,
    final min=273.15)
    "Design (highest) HW supply temperature setpoint for condensing boilers"
    annotation(Dialog(group="Temperature setpoints", enable=have_boiCon and have_boiNon));
  parameter Modelica.Units.SI.Temperature TOutLck(
    displayUnit="degC",
    final min=273.15)=Buildings.Templates.Data.Defaults.TOutBoiLck
    "Outdoor air lockout temperature above which the plant is prevented from operating"
    annotation(Dialog(group="Temperature setpoints", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36));

  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatBoiCon_flow_nominal[nBoiCon](
    start=fill(0.1, nBoiCon),
    displayUnit=fill("L/s", nBoiCon),
    final min=fill(0, nBoiCon))
    "Design HW volume flow rate - Each condensing boiler"
    annotation(Dialog(group="Boiler flow setpoints", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    have_boiCon and have_valHeaWatMinByp));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatBoiCon_flow_min[nBoiCon](
    start=fill(0.1, nBoiCon),
    displayUnit=fill("L/s", nBoiCon),
    final min=fill(0, nBoiCon))
    "Minimum HW volume flow rate - Each condensing boiler"
    annotation(Dialog(group="Boiler flow setpoints", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    have_boiCon));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatBoiNon_flow_nominal[nBoiNon](
    start=fill(0.1, nBoiNon),
    displayUnit=fill("L/s", nBoiNon),
    final min=fill(0, nBoiNon))
    "Design HW volume flow rate - Each non-condensing boiler"
    annotation(Dialog(group="Boiler flow setpoints", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    have_boiNon
    and have_valHeaWatMinByp));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatBoiNon_flow_min[nBoiNon](
    start=fill(0.1, nBoiNon),
    displayUnit=fill("L/s", nBoiNon),
    final min=fill(0, nBoiNon))
    "Minimum HW volume flow rate - Each non-condensing boiler"
    annotation(Dialog(group="Boiler flow setpoints", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    have_boiNon));
  parameter Real ratFirBoiCon_min[nBoiCon](
    start=fill(0.2, nBoiCon),
    final unit=fill("1", nBoiCon))
    "Boiler minimum firing rate before cycling"
    annotation(Dialog(group="Minimum boiler firing rate", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    have_boiCon));
  parameter Real ratFirBoiNon_min[nBoiNon](
    start=fill(0.2, nBoiNon),
    final unit=fill("1", nBoiNon))
    "Boiler minimum firing rate before cycling"
    annotation(Dialog(group="Minimum boiler firing rate", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    have_boiCon));
  parameter Modelica.Units.SI.HeatFlowRate capBoiCon_nominal[nBoiCon](
    start=fill(1, nBoiCon),
    final min=fill(0, nBoiCon))
    "Design capacity - Each condensing boiler"
    annotation(Dialog(group="Capacity", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36));
  parameter Modelica.Units.SI.HeatFlowRate capBoiNon_nominal[nBoiNon](
    start=fill(1, nBoiNon),
    final min=fill(0, nBoiNon))
    "Design capacity - Each non-condensing boiler"
    annotation(Dialog(group="Capacity", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatPri_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design primary HW volume flow rate"
    annotation(Dialog(group="Capacity", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None and
    have_varPumHeaWatPri and typArrPumHeaWatPriCon==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatSec_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design secondary HW volume flow rate"
    annotation(Dialog(group="Capacity", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None and
    have_senVHeaWatSec));

  parameter Modelica.Units.SI.PressureDifference dpHeaWatRemSet_nominal[nSenDpHeaWatRem](
    start=fill(Buildings.Templates.Data.Defaults.dpHeaWatSet_max, nSenDpHeaWatRem),
    final min=fill(0, nSenDpHeaWatRem))
    "Design (maximum) HW differential pressure setpoint - Remote sensor"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    (have_varPumHeaWatPri and typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None or
    typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None)));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatLocSet_nominal(
    start=Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max,
    final min=0)
    "Design (maximum) HW differential pressure setpoint - Local sensor"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    have_senDpHeaWatLoc));
  parameter Real yPumHeaWatPri_min(
    final unit="1",
    final min=0,
    final max=1)=0.1
    "Primary HW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    have_varPumHeaWatPri and
    typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None));
  parameter Real yPumHeaWatSec_min(
    final unit="1",
    final min=0,
    final max=1)=0.1
    "Secondary HW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None));
  parameter Real yPumHeaWatPriSta_min[nSta](
    each final unit="1",
    each final min=0,
    each final max=1,
    each start=0.3)
    "Primary HW pump speed delivering minimum flow through boilers - Each plant stage"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    have_varPumHeaWatPri and
    typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None));

  // FIXME: How are interchangeable units (lead/lag alternated) specified?
  parameter Integer sta[:, nBoiCon + nBoiNon](
    each final min=0,
    each final max=1)
    "Staging matrix with plant stage as row index and boiler as column index (starting with condensing boilers): 0 for disabled, 1 for enabled"
    annotation (Dialog(group="Plant staging"));
  final parameter Integer nSta(start=1) = size(sta, 1)
    "Number of plant stages"
    annotation (Evaluate=true, Dialog(group="Plant staging"));

  annotation (
  defaultComponentName="datCtl",
  Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
HW plant controllers that can be found within 
<a href=\"modelica://Buildings.Templates.HeatingPlants.HotWater.Components.Controls\">
Buildings.Templates.HeatingPlants.HotWater.Components.Controls</a>.
</p>
<p>
For hybrid plants, units shall be indexed so that condensing boilers have the 
lowest indices and non-condensing boilers have the highest indices.
</p>
</html>"));
end Controller;
