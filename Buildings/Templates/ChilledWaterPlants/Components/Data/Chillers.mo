within Buildings.Templates.ChilledWaterPlants.Components.Data;
record Chillers "Data for chillers"
  extends Modelica.Icons.Record;

  // Configuration parameters
  parameter Integer nChi(final min=1)
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Chiller typ=Buildings.Templates.ChilledWaterPlants.Types.Chiller.WaterCooled
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Compressor typCom=
      Buildings.Templates.ChilledWaterPlants.Types.Compressor.VariableSpeed
    "Type of compressor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl
    typCtrHeaPre=Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.BuiltIn
    "Type of head pressure control"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // Equipment characteristics
  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal[nChi](
    each final min=0)
    "CHW design mass flow rate for each chiller"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal[nChi](
    each final min=0)
    "CW design mass flow rate for each chiller"
    annotation(Dialog(group="Nominal condition",
    enable=typ == Buildings.Templates.ChilledWaterPlants.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.PressureDifference dpChiWat_nominal[nChi](each final
            min=0, each start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "CHW design pressure drop for each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConWat_nominal[nChi](each final
            min=0, each start=Buildings.Templates.Data.Defaults.dpConWatChi)
    "CW design pressure drop for each chiller" annotation (Dialog(group=
          "Nominal condition", enable=typ == Buildings.Templates.ChilledWaterPlants.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.HeatFlowRate cap_nominal[nChi](
    each final min=0)
    "Cooling capacity for each chiller"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal[nChi](
    each final min=260)
    "Design (lowest) CHW supply temperature for each chiller"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChiWatSup_max[nChi](
    final min=TChiWatSup_nominal)=fill(16+273.15, nChi)
    "Maximum CHW supply temperature for each chiller"
    annotation(Dialog(group="Nominal condition"));
  parameter Real PLRMinUnl[nChi](
    final min=PLRMin,
    each final max=1)=PLRMin
    "Minimum unloading ratio (before engaging hot gas bypass, if any)";
  parameter Real PLRMin[nChi](
    each final min=0,
    each final max=1)=fill(0.15, nChi)
    "Minimum part load ratio before cycling";
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic
    per[nChi]
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller(
      QEva_flow_nominal=-1 * cap_nominal,
      TEvaLvg_nominal=TChiWatSup_nominal,
      TEvaLvg_min=TChiWatSup_nominal,
      TEvaLvg_max=TChiWatSup_max,
      PLRMin=PLRMin,
      PLRMinUnl=PLRMinUnl,
      mEva_flow_nominal=mChiWat_flow_nominal,
      mCon_flow_nominal=mConWat_flow_nominal)
    "Chiller performance data"
    annotation(Dialog(group="Nominal condition"));
end Chillers;
