within Buildings.Templates.ChilledWaterPlant.Components.Chillers.Interfaces;
record Data "Data for chillers"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.Chiller typ "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.Compressor
    typCom = Buildings.Templates.ChilledWaterPlant.Components.Types.Compressor.ConstantSpeed
    "Type of compressor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean isAirCoo
    "= true, chillers are air cooled,
    = false, chillers are water cooled"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  // fixme: Figure out what this entails with existing chiller class
  parameter Boolean is_heaPreCon = false
    "= true if chiller is controlled with head pressure";
  parameter Boolean have_heaPreSig = false
    "= true if chiller has a head pressure signal"
    annotation(Dialog(enable=is_heaPreCon));
  parameter Boolean have_TChiWatChiSup = true
    "= true if chiller chilled water supply temperature is measured"
    annotation (Dialog(enable=not is_heaPreCon or have_heaPreSig));
  parameter Boolean have_TConWatRet = true
    "= true if chiller condenser water return temperature is measured"
    annotation (Dialog(enable=not is_heaPreCon or have_heaPreSig));

  // Equipment characteristics

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(min=0)=0
    "Condenser water side nominal mass flow rate"
    annotation(Dialog(group="Nominal condition", enable=not isAirCoo));
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(min=0)
    "Chilled water side nominal mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp1_nominal=0
    "Pressure difference"
    annotation(Dialog(group = "Nominal condition", enable=not isAirCoo));
  parameter Modelica.Units.SI.PressureDifference dp2_nominal
    "Pressure difference"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.Units.SI.Power Q_flow_nominal
    "Total cooling heat flow rate (<0 by convention)"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.Units.SI.Temperature TCHWSup_nominal
    "Design (minimum) CHW supply temperature"
    annotation(Dialog(group = "Nominal condition"));
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic
    per constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller(
      QEva_flow_nominal=Q_flow_nominal,
      TEvaLvg_nominal=TCHWSup_nominal,
      mEva_flow_nominal=m2_flow_nominal,
      mCon_flow_nominal=m1_flow_nominal)
    "Chiller performance data"
    annotation(Dialog(group = "Nominal condition"));

end Data;
