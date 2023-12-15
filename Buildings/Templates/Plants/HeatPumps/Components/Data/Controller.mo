within Buildings.Templates.Plants.HeatPumps.Components.Data;
record Controller "Record for plant controller"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Plants.HeatPumps.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nHeaPum
    "Number of heat pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPumHeaWatPri
    "Number of primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPumHeaWatSec
    "Number of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Plants.HeatPumps.Types.Distribution typDisHeaWat
    "Type of HW distribution system"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_valHeaWatMinByp
    "Set to true if the HW loop has a minimum flow bypass valve"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary typPumHeaWatSec
    "Type of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_senDpHeaWatLoc
    "Set to true for local HW differential pressure sensor hardwired to plant controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nSenDpHeaWatRem
    "Number of remote HW differential pressure sensors used for HW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_senVHeaWatSec
    "Set to true if secondary loop is equipped with a flow meter"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPri
    "Type of primary HW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal(
    displayUnit="degC",
    start=Buildings.Templates.Data.Defaults.THeaWatSup,
    final min=273.15)
    "Design (highest) HW supply temperature setpoint"
    annotation(Dialog(group="Temperature setpoints"));
  parameter Modelica.Units.SI.Temperature TOutLck(
    displayUnit="degC",
    final min=273.15)=Buildings.Templates.Data.Defaults.TOutHeaLck
    "Outdoor air lockout temperature above which the plant is prevented from operating"
    annotation(Dialog(group="Temperature setpoints", enable=
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));

  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatHeaPum_flow_nominal[nHeaPum](
    start=fill(0.1, nHeaPum),
    displayUnit=fill("L/s", nHeaPum),
    final min=fill(0, nHeaPum))
    "Design HW volume flow rate - Each heat pump"
    annotation(Dialog(group="Heat pump flow setpoints", enable=
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    have_valHeaWatMinByp));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatHeaPum_flow_min[nHeaPum](
    start=fill(0.1, nHeaPum),
    displayUnit=fill("L/s", nHeaPum),
    final min=fill(0, nHeaPum))
    "Minimum HW volume flow rate - Each heat pump"
    annotation(Dialog(group="Heat pump flow setpoints", enable=
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));
  parameter Real PLRHeaPum_min[nHeaPum](
    start=fill(0.5, nHeaPum),
    final unit=fill("1", nHeaPum))
    "Heat pump minimum part load ratio"
    annotation(Dialog(group="Capacity", enable=
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));
  parameter Modelica.Units.SI.HeatFlowRate capHeaPum_nominal[nHeaPum](
    start=fill(1, nHeaPum),
    final min=fill(0, nHeaPum))
    "Design capacity"
    annotation(Dialog(group="Capacity", enable=
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatPri_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design primary HW volume flow rate"
    annotation(Dialog(group="Capacity", enable=
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    typDisHeaWat==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only and
    typArrPumHeaWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatSec_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design secondary HW volume flow rate"
    annotation(Dialog(group="Capacity", enable=
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None and
    have_senVHeaWatSec));

  parameter Modelica.Units.SI.PressureDifference dpHeaWatRemSet_nominal[nSenDpHeaWatRem](
    start=fill(Buildings.Templates.Data.Defaults.dpHeaWatSet_max, nSenDpHeaWatRem),
    final min=fill(0, nSenDpHeaWatRem))
    "Design (maximum) HW differential pressure setpoint - Remote sensor"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    (typDisHeaWat==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only or
    typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None)));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatLocSet_nominal(
    start=Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max,
    final min=0)
    "Design (maximum) HW differential pressure setpoint - Local sensor"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    have_senDpHeaWatLoc));
  parameter Real yPumHeaWatPri_min(
    final unit="1",
    final min=0,
    final max=1)=0.1
    "Primary HW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    typDisHeaWat==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
  parameter Real yPumHeaWatSec_min(
    final unit="1",
    final min=0,
    final max=1)=0.1
    "Secondary HW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None));

  annotation (
  defaultComponentName="datCtl",
  Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for
heat pump plant controllers that can be found within
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Components.Controls\">
Buildings.Templates.Plants.HeatPumps.Components.Controls</a>.
</p>
</html>"));
end Controller;
