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

  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal(
    displayUnit="degC",
    start=Buildings.Templates.Data.Defaults.THeaWatSup,
    final min=273.15)
    "Design (highest) HW supply temperature setpoint"
    annotation(Dialog(group="Temperature setpoints", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36));
  parameter Modelica.Units.SI.Temperature THeaWatConSup_nominal(
    displayUnit="degC",
    start=Buildings.Templates.Data.Defaults.THeaWatSup,
    final min=273.15)
    "Design (highest) HW supply temperature setpoint for condensing boilers"
    annotation(Dialog(group="Temperature setpoints", enable=have_boiCon and have_boiNon and
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36));
  parameter Modelica.Units.SI.Temperature TOutLoc(
    displayUnit="degC",
    final min=273.15)=Buildings.Templates.Data.Defaults.TOutBoiLoc
    "Outdoor air lockout temperature above which the plant is prevented from operating"
    annotation(Dialog(group="Temperature setpoints", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36));

  parameter Modelica.Units.SI.PressureDifference dpHeaWatLocSet_min(
    start=Buildings.Templates.Data.Defaults.dpHeaWatSet_min)
    "Minimum HW differential pressure setpoint used in plant reset logic - Local sensor"
    annotation(Dialog(group="Differential pressure setpoints", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    typDisHeaWat<>Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Constant1Only and
    have_senDpHeaWatLoc));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatRemSet_min[nSenDpHeaWatRem](
    each start=Buildings.Templates.Data.Defaults.dpHeaWatSet_min)
    "Minimum HW differential pressure setpoint used in plant reset logic - Each remote sensor"
    annotation(Dialog(group="Differential pressure setpoints", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    typDisHeaWat<>Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Constant1Only and
    not have_senDpHeaWatLoc));

  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatBoiCon_flow_nominal[nBoiCon](
    each displayUnit="L/s",
    each final min=0)
    "Design HW volume flow rate - Each condensing boiler"
    annotation(Dialog(group="Boiler flow setpoints", enable=have_boiCon and
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36
    and have_valHeaWatMinByp));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatBoiCon_flow_min[nBoiCon](
    each displayUnit="L/s",
    each final min=0)
    "Minimum HW volume flow rate - Each condensing boiler"
    annotation(Dialog(group="Boiler flow setpoints", enable=have_boiCon and
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatBoiNon_flow_nominal[nBoiNon](
    each displayUnit="L/s",
    each final min=0)
    "Design HW volume flow rate - Each non-condensing boiler"
    annotation(Dialog(group="Boiler flow setpoints", enable=have_boiNon and
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36
    and have_valHeaWatMinByp));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatBoiNon_flow_min[nBoiNon](
    each displayUnit="L/s",
    each final min=0)
    "Minimum HW volume flow rate - Each non-condensing boiler"
    annotation(Dialog(group="Boiler flow setpoints", enable=have_boiNon and
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36));

  parameter Modelica.Units.SI.HeatFlowRate capBoiCon_nominal[nBoiCon](
    each final min=0)
    "Design capacity - Each condensing boiler"
    annotation(Dialog(group="Capacity", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36));
  parameter Modelica.Units.SI.HeatFlowRate capBoiNon_nominal[nBoiNon](
    each final min=0)
    "Design capacity - Each non-condensing boiler"
    annotation(Dialog(group="Capacity", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatPriCon_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)=sum(VHeaWatBoiCon_flow_nominal)
    "Design primary HW volume flow rate - Condensing boiler loop"
    annotation(Dialog(group="Capacity", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None and
    have_varPumHeaWatPri and typArrPumHeaWatPriCon==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatPriNon_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)=sum(VHeaWatBoiNon_flow_nominal)
    "Design primary HW volume flow rate - Non-condensing boiler loop"
    annotation(Dialog(group="Capacity", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None and
    have_varPumHeaWatPri and typArrPumHeaWatPriNon==Buildings.Templates.Components.Types.PumpArrangement.Headered));

  parameter Modelica.Units.SI.PressureDifference dpHeaWatRemSet_nominal[nSenDpHeaWatRem](
    each start=Buildings.Templates.Data.Defaults.dpHeaWatSet_max,
    each final min=0)
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
    final max=1,
    start=0.1)
    "Primary HW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    have_varPumHeaWatPri));
  parameter Real yPumHeaWatSec_min(
    final unit="1",
    final min=0,
    final max=1,
    start=0.1)
    "Secondary HW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None));

  annotation (
  defaultComponentName="datCtl",
  Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
HW plant controllers that can be found within 
<a href=\"modelica://Buildings.Templates.HeatingPlants.HotWater.Components.Controls\">
Buildings.Templates.HeatingPlants.HotWater.Components.Controls</a>.
</p>
</html>"));
end Controller;
