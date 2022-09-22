within Buildings.Templates.ChilledWaterPlants.Components.Data;
record Controller "Record for plant controller"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Chiller typChi
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nChi
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Distribution typDisChiWat
    "Type of CHW distribution system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPumChiWatSec
    "Number of secondary CHW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Cooler typCoo
    "Condenser water cooling equipment"
    annotation(Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nCoo
    "Number of cooler units"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.PumpMultipleSpeedControl typCtrSpePumConWat
    "Type of CW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi](
    each final min=0)
    "Design CHW mass flow rate for each chiller"
    annotation(Dialog(group="Chiller flow setpoints"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_min[nChi](
    each final min=0)
    "Minimum CHW mass flow rate for each chiller"
    annotation(Dialog(group="Chiller flow setpoints"));
  parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal[nChi](
    each final min=0)
    "Design CW mass flow rate for each chiller"
    annotation(Dialog(group="Chiller flow setpoints", enable=
    typCtrSpePumConWat==Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon or
    typCtrSpePumConWat==Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableDedicated));
end Controller;
