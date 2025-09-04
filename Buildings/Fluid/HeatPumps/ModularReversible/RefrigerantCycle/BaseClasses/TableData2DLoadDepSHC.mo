within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
block TableData2DLoadDepSHC
  "Modeling block for simultaneous heating and cooling systems based on load-dependent 2D table data"

  parameter Integer nUni(final min=1)=1
    "Number of modules";
  parameter Boolean use_TLoaLvgForCtl=true
    "Set to true for leaving temperature control, false for entering temperature control"
    annotation (Evaluate=true);
  parameter Boolean use_TEvaOutForTab
    "=true to use CHW temperature at outlet for table data, false for inlet";
  parameter Boolean use_TConOutForTab
    "=true to use HW temperature at outlet for table data, false for inlet";
  parameter Modelica.Units.SI.DimensionlessRatio PLRHeaSup[:](each final min=0)
    "PLR values at which heat flow rate and power data are provided - Heating";
  parameter Modelica.Units.SI.DimensionlessRatio PLRCooSup[:](each final min=0)
    "PLR values at which heat flow rate and power data are provided - Cooling";
  parameter Modelica.Units.SI.DimensionlessRatio PLRShcSup[:](each final min=0)
    "PLR values at which heat flow rate and power data are provided - SHC";
  final parameter Modelica.Units.SI.DimensionlessRatio PLRHeaCyc_min=min(PLRHeaSup)
    "Minimum PLR before cycling off the last compressor - Heating";
  final parameter Modelica.Units.SI.DimensionlessRatio PLRCooCyc_min=min(PLRCooSup)
    "Minimum PLR before cycling off the last compressor - Cooling";
  final parameter Modelica.Units.SI.DimensionlessRatio PLRShcCyc_min=min(PLRShcSup)
    "Minimum PLR before cycling off the last compressor - SHC";
  parameter Modelica.Units.SI.Power P_min(final min=0)=0
    "Remaining power when system is enabled with all compressors cycled off";
  final parameter Integer nPLRHea=size(PLRHeaSup, 1)
    "Number of PLR support points - Heating"
    annotation (Evaluate=true);
  final parameter Integer nPLRCoo=size(PLRCooSup, 1)
    "Number of PLR support points - Cooling"
    annotation (Evaluate=true);
  final parameter Integer nPLRShc=size(PLRShcSup, 1)
    "Number of PLR support points - SHC"
    annotation (Evaluate=true);
  parameter String fileNameHea
    "File where performance data are stored - Heating (single module)"
    annotation (Dialog(loadSelector(filter="Text files (*.txt)",caption=
      "Open file in which table is present")));
  parameter String fileNameCoo
    "File where performance data are stored - Cooling (single module)"
    annotation (Dialog(loadSelector(filter="Text files (*.txt)",caption=
      "Open file in which table is present")));
  parameter String fileNameShc
    "File where performance data are stored - SHC (single module)"
    annotation (Dialog(loadSelector(filter="Text files (*.txt)",caption=
      "Open file in which table is present")));
  final parameter Modelica.Blocks.Types.Smoothness smoothness=
    Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation";
  final parameter Modelica.Blocks.Types.Extrapolation extrapolation=
    Modelica.Blocks.Types.Extrapolation.HoldLastPoint
    "Extrapolation of data outside the definition range";
  parameter String tabNamQHea[nPLRHea]={"q@" + String(p,
    format=".2f") for p in PLRHeaSor}
    "Table names with heat flow rate data - Heating"
    annotation (Evaluate=true,
    Dialog(tab="Advanced"));
  parameter String tabNamPHea[nPLRHea]={"p@" + String(p,
    format=".2f") for p in PLRHeaSor}
    "Table names with power data - Heating"
    annotation (Evaluate=true,
    Dialog(tab="Advanced"));
  parameter String tabNamQCoo[nPLRCoo]={"q@" + String(p,
    format=".2f") for p in PLRCooSor}
    "Table names with heat flow rate data - Cooling"
    annotation (Evaluate=true,
    Dialog(tab="Advanced"));
  parameter String tabNamPCoo[nPLRCoo]={"p@" + String(p,
    format=".2f") for p in PLRCooSor}
    "Table names with power data - Cooling"
    annotation (Evaluate=true,
    Dialog(tab="Advanced"));
  parameter String tabNamQShc[nPLRShc]={"q@" + String(p,
    format=".2f") for p in PLRShcSor}
    "Table names with cooling heat flow rate data - SHC"
    annotation (Evaluate=true,
    Dialog(tab="Advanced"));
  parameter String tabNamPShc[nPLRShc]={"p@" + String(p,
    format=".2f") for p in PLRShcSor}
    "Table names with power data - SHC"
    annotation (Evaluate=true,
    Dialog(tab="Advanced"));
  parameter Modelica.Units.SI.Temperature THw_nominal
    "HW temperature — Entering or leaving depending on use_TConOutForTab"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChw_nominal
    "CHW temperature — Entering or leaving depending on use_TEvaOutForTab"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TAmbHea_nominal
    "Ambient-side fluid temperature — Entering"
    annotation (Dialog(group="Nominal condition - Heating"));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal
    "Heating heat flow rate - All modules"
    annotation (Dialog(group="Nominal condition - Heating"));
  parameter Modelica.Units.SI.Temperature TAmbCoo_nominal
    "Ambient-side fluid temperature — Entering"
    annotation (Dialog(group="Nominal condition - Cooling"));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal
    "Cooling heat flow rate - All modules"
    annotation (Dialog(group="Nominal condition - Cooling"));
  parameter Modelica.Units.SI.HeatFlowRate QHeaShc_flow_nominal
    "Heating heat flow rate - All modules"
    annotation (Dialog(group="Nominal condition - SHC"));
  parameter Modelica.Units.SI.HeatFlowRate QCooShc_flow_nominal
    "Cooling heat flow rate - All modules"
    annotation (Dialog(group="Nominal condition - SHC"));
  parameter Real dtRun(
    final min=0,
    final unit="s") = 300
    "Minimum stage runtime"
    annotation (Dialog(tab="Advanced", group="Staging logic"));
  parameter Real dtMea(
    final min=0,
    final unit="s") = 120
    "Load averaging time window"
    annotation (Dialog(tab="Advanced", group="Staging logic"));
  parameter Real SPLR(
    final max=1,
    final min=0) = 0.9
    "Staging part load ratio"
    annotation (Dialog(tab="Advanced", group="Staging logic"));
  parameter Modelica.Units.SI.TemperatureDifference dTSaf(
    final min=0) = 2
    "Maximum temperature deviation from setpoint before limiting demand for safety (>0)"
    annotation (Dialog(tab="Advanced", group="Safeties"));
  // OMC and OCT require getTable2DValueNoDer2() to be called in initial equation section.
  // Binding equations yield incorrect results but no error!
  final parameter Modelica.Units.SI.Power PHeaInt_nominal[nPLRHea](
    each fixed=false)
    "Power interpolated at nominal conditions, at each PLR - Heating, single module";
  final parameter Modelica.Units.SI.HeatFlowRate QHeaInt_flow_nominal[nPLRHea](
    each fixed=false)
    "Heat flow rate interpolated at nominal conditions, at each PLR - Heating, single module";
  final parameter Modelica.Units.SI.Power PHeaInt1_nominal=Modelica.Math.Vectors.interpolate(
    PLRHeaSor, PHeaInt_nominal, 1)
    "Power interpolated at nominal conditions, at PLR=1 - Heating, single module";
  final parameter Modelica.Units.SI.HeatFlowRate QHeaInt1_flow_nominal=Modelica.Math.Vectors.interpolate(
    PLRHeaSor, QHeaInt_flow_nominal, 1)
    "Heat flow rate interpolated at nominal conditions, at PLR=1 - Heating, single module";
  final parameter Modelica.Units.SI.Power PCooInt_nominal[nPLRCoo](
    each fixed=false)
    "Power interpolated at nominal conditions, at each PLR - Cooling, single module";
  final parameter Modelica.Units.SI.HeatFlowRate QCooInt_flow_nominal[nPLRCoo](
    each fixed=false)
    "Heat flow rate interpolated at nominal conditions, at each PLR - Cooling, single module";
  final parameter Modelica.Units.SI.Power PCooInt1_nominal=Modelica.Math.Vectors.interpolate(
    PLRCooSor, PCooInt_nominal, 1)
    "Power interpolated at nominal conditions, at PLR=1 - Cooling, single module";
  final parameter Modelica.Units.SI.HeatFlowRate QCooInt1_flow_nominal=Modelica.Math.Vectors.interpolate(
    PLRCooSor, QCooInt_flow_nominal, 1)
    "Heat flow rate interpolated at nominal conditions, at PLR=1 - Cooling, single module";
  final parameter Modelica.Units.SI.Power PShcInt_nominal[nPLRShc](
    each fixed=false)
    "Power interpolated at nominal conditions, at each PLR - SHC, single module";
  final parameter Modelica.Units.SI.HeatFlowRate QCooShcInt_flow_nominal[nPLRShc](
    each fixed=false)
    "Cooling heat flow rate interpolated at nominal conditions, at each PLR - SHC, single module";
  final parameter Modelica.Units.SI.Power PShcInt1_nominal=Modelica.Math.Vectors.interpolate(
    PLRShcSor, PShcInt_nominal, 1)
    "Power interpolated at nominal conditions, at PLR=1 - SHC, single module";
  final parameter Modelica.Units.SI.HeatFlowRate QCooShcInt1_flow_nominal=
    Modelica.Math.Vectors.interpolate(PLRShcSor, QCooShcInt_flow_nominal, 1)
    "Cooling heat flow rate interpolated at nominal conditions, at PLR=1 - SHC, single module";
  final parameter Modelica.Units.SI.HeatFlowRate QHeaShcInt1_flow_nominal=
    PShcInt1_nominal - QCooShcInt1_flow_nominal
    "Heating heat flow rate at nominal conditions, at PLR=1 - SHC, single module";
  final parameter Real scaFacHea(
    unit="1")=QHea_flow_nominal / (nUni * QHeaInt1_flow_nominal)
    "Scaling factor for interpolated heat flow rate and power - Heating";
  final parameter Real scaFacCoo(
    unit="1")=QCoo_flow_nominal / (nUni * QCooInt1_flow_nominal)
    "Scaling factor for interpolated heat flow rate and power - Cooling";
  final parameter Real scaFacCooShc(
    unit="1")=QCooShc_flow_nominal / (nUni * QCooShcInt1_flow_nominal)
    "Scaling factor for interpolated cooling heat flow rate and power - SHC";
  final parameter Real scaFacHeaShc(
    unit="1")=QHeaShc_flow_nominal / (nUni * QHeaShcInt1_flow_nominal)
    "Scaling factor for interpolated heating heat flow rate - SHC";
  final parameter Modelica.Units.SI.Power P_nominal=max({scaFacHea *
    PHeaInt1_nominal, scaFacCoo * PCooInt1_nominal, scaFacCooShc *
    PShcInt1_nominal})
    "Maximum power at nominal conditions (external use) - All modes";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput on
    "On/off command: true to enable heat pump, false to disable heat pump"
    annotation (Placement(transformation(extent={{-140,120},{-100,160}}),
      iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mode
    "Operating mode command (from Buildings.Fluid.HeatPumps.Types.OperatingModes)"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THwEnt(
    final unit="K",
    displayUnit="degC")
    "Condenser entering HW temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THwLvg(
    final unit="K",
    displayUnit="degC")
    "Condenser leaving HW temperature"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChwEnt(
    final unit="K",
    displayUnit="degC")
    "Evaporator entering CHW temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChwLvg(
    final unit="K",
    displayUnit="degC")
    "Evaporator leaving CHW temperature"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAmbEnt(
    final unit="K",
    displayUnit="degC")
    "Entering fluid temperature on ambient side"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cpHw(
    final unit="J/(kg.K)")
    "HW specific heat capacity"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cpChw(
    final unit="J/(kg.K)")
    "CHW specific heat capacity"
    annotation (Placement(transformation(extent={{-140,-160},{-100,-120}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChwSet(
    final unit="K",
    displayUnit="degC")
    "CHW temperature setpoint"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THwSet(
    final unit="K",
    displayUnit="degC") "HW temperature setpoint"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mHw_flow(
    final unit="kg/s")
    "HW mass flow rate"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mChw_flow(
    final unit="kg/s")
    "CHW mass flow rate"
    annotation (Placement(transformation(extent={{-140,-140},{-100,-100}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(
    final unit="W") "Input power"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QHea_flow(
    final unit="J/s") "Heating heat flow rate"
    annotation (Placement(transformation(extent={{100,120},{140,160}}),
      iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QCoo_flow(
    final unit="J/s")
    "Cooling heat flow rate"
    annotation (Placement(transformation(extent={{100,100},{140,140}}),
      iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nUniHea(start=0)
    "Number of modules in heating mode"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nUniCoo(start=0)
    "Number of modules in cooling mode"
    annotation (Placement(transformation(extent={{100,-120},{140,-80}}),
      iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nUniShc(start=0)
    "Number of modules in SHC mode (may be cycling into single mode)"
    annotation (Placement(transformation(extent={{100,-160},{140,-120}}),
      iconTransformation(extent={{100,-160},{140,-120}})));
protected
  final parameter Real PLRHeaSor[nPLRHea]=Modelica.Math.Vectors.sort(PLRHeaSup)
    "PLR values in increasing order - Heating";
  final parameter Real PLRHea_max=PLRHeaSor[nPLRHea]
    "Maximum PLR";
  final parameter Modelica.Blocks.Types.ExternalCombiTable2D tabQHea[nPLRHea]=
    Modelica.Blocks.Types.ExternalCombiTable2D(
    tableName=tabNamQHea,
    fileName=fill(fileNameHea, nPLRHea),
    table=fill(fill(0.0, 1, 2), nPLRHea),
    smoothness=fill(smoothness, nPLRHea),
    extrapolation=fill(extrapolation, nPLRHea),
    verboseRead=fill(false, nPLRHea))
    "External table objects for heat flow interpolation ";
  final parameter Modelica.Blocks.Types.ExternalCombiTable2D tabPHea[nPLRHea]=
    Modelica.Blocks.Types.ExternalCombiTable2D(
    tableName=tabNamPHea,
    fileName=fill(fileNameHea, nPLRHea),
    table=fill(fill(0.0, 1, 2), nPLRHea),
    smoothness=fill(smoothness, nPLRHea),
    extrapolation=fill(extrapolation, nPLRHea),
    verboseRead=fill(false, nPLRHea))
    "External table objects for power interpolation";
  final parameter Real PLRCooSor[nPLRCoo]=Modelica.Math.Vectors.sort(PLRCooSup)
    "PLR values in increasing order - Cooling";
  final parameter Real PLRCoo_max=PLRCooSor[nPLRCoo]
    "Maximum PLR - Cooling";
  final parameter Modelica.Blocks.Types.ExternalCombiTable2D tabQCoo[nPLRCoo]=
    Modelica.Blocks.Types.ExternalCombiTable2D(
    tableName=tabNamQCoo,
    fileName=fill(fileNameCoo, nPLRCoo),
    table=fill(fill(0.0, 1, 2), nPLRCoo),
    smoothness=fill(smoothness, nPLRCoo),
    extrapolation=fill(extrapolation, nPLRCoo),
    verboseRead=fill(false, nPLRCoo))
    "External table objects for heat flow interpolation - Cooling";
  final parameter Modelica.Blocks.Types.ExternalCombiTable2D tabPCoo[nPLRCoo]=
    Modelica.Blocks.Types.ExternalCombiTable2D(
    tableName=tabNamPCoo,
    fileName=fill(fileNameCoo, nPLRCoo),
    table=fill(fill(0.0, 1, 2), nPLRCoo),
    smoothness=fill(smoothness, nPLRCoo),
    extrapolation=fill(extrapolation, nPLRCoo),
    verboseRead=fill(false, nPLRCoo))
    "External table objects for power interpolation - Cooling";
  final parameter Real PLRShcSor[nPLRShc]=Modelica.Math.Vectors.sort(PLRShcSup)
    "PLR values in increasing order - SHC";
  final parameter Real PLRShc_max=PLRShcSor[nPLRShc]
    "Maximum PLR - SHC";
  final parameter Modelica.Blocks.Types.ExternalCombiTable2D tabQShc[nPLRShc]=
    Modelica.Blocks.Types.ExternalCombiTable2D(
    tableName=tabNamQShc,
    fileName=fill(fileNameShc, nPLRShc),
    table=fill(fill(0.0, 1, 2), nPLRShc),
    smoothness=fill(smoothness, nPLRShc),
    extrapolation=fill(extrapolation, nPLRShc),
    verboseRead=fill(false, nPLRShc))
    "External table objects for heat flow interpolation - SHC";
  final parameter Modelica.Blocks.Types.ExternalCombiTable2D tabPShc[nPLRShc]=
    Modelica.Blocks.Types.ExternalCombiTable2D(
    tableName=tabNamPShc,
    fileName=fill(fileNameShc, nPLRShc),
    table=fill(fill(0.0, 1, 2), nPLRShc),
    smoothness=fill(smoothness, nPLRShc),
    extrapolation=fill(extrapolation, nPLRShc),
    verboseRead=fill(false, nPLRShc))
    "External table objects for power interpolation - SHC";
  constant Real deltaX = 1E-3
    "Small number used for smoothing";
  Modelica.Units.SI.HeatFlowRate QHeaSet_flow
    "Heating load - All modules";
  Modelica.Units.SI.HeatFlowRate QCooSet_flow
    "Cooling load - All modules";
  Modelica.Units.SI.HeatFlowRate QHeaSetRes_flow
    "Residual heating load - All modules except those in SHC mode";
  Modelica.Units.SI.HeatFlowRate QCooSetRes_flow
    "Residual cooling load - All modules except those in SHC mode";
  Modelica.Units.SI.HeatFlowRate QHeaSetMea_flow
    "Time-averaged heating load - All modules";
  Modelica.Units.SI.HeatFlowRate QCooSetMea_flow
    "Time-averaged cooling load - All modules";
  Modelica.Units.SI.HeatFlowRate QHeaSetResMea_flow
    "Time-averaged residual heating load - All modules except those in SHC mode";
  Modelica.Units.SI.HeatFlowRate QCooSetResMea_flow
    "Time-averaged residual cooling load - All modules except those in SHC mode";
  Modelica.Units.SI.HeatFlowRate QHeaSaf_flow
    "Demand limit for safe heating operation";
  Modelica.Units.SI.HeatFlowRate  QCooSaf_flow
    "Demand limit for safe cooling operation";
  Modelica.Units.SI.HeatFlowRate QHeaShc_flow
    "Heating heat flow rate - All modules in SHC mode";
  Modelica.Units.SI.HeatFlowRate QCooShc_flow
    "Cooling heat flow rate - All modules in SHC mode";
  Modelica.Units.SI.HeatFlowRate QHeaShcNoCyc_flow
    "Heating heat flow rate without cycling - All modules in SHC mode";
  Modelica.Units.SI.HeatFlowRate QCooShcNoCyc_flow
    "Cooling heat flow rate without cycling - All modules in SHC mode";
  Modelica.Units.SI.HeatFlowRate QHeaShcCyc_flow
    "Heating heat flow rate when cycling in heating only mode - All modules cycling from SHC mode";
  Modelica.Units.SI.HeatFlowRate QCooShcCyc_flow
    "Cooling heat flow rate when cycling in cooling only mode - All modules cycling from SHC mode";
  Modelica.Units.SI.HeatFlowRate QHeaInt_flow[nPLRHea]
    "Capacity at PLR support points - Heating, single module";
  Modelica.Units.SI.Power PHeaInt[nPLRHea]
    "Input power at PLR support points - Heating, single module";
  Modelica.Units.SI.HeatFlowRate QCooInt_flow[nPLRCoo]
    "Capacity at PLR support points - Cooling, single module";
  Modelica.Units.SI.Power PCooInt[nPLRCoo]
    "Input power at PLR support points - Cooling, single module";
  Modelica.Units.SI.HeatFlowRate QCooShcInt_flow[nPLRShc]
    "Cooling capacity at PLR support points - SHC, single module";
  Modelica.Units.SI.HeatFlowRate QHeaShcInt_flow[nPLRShc]
    "Heating capacity at PLR support points - SHC, single module";
  Modelica.Units.SI.HeatFlowRate QHeaShcExc_flow
    "Excess heating heat flow rate - All modules in SHC mode";
  Modelica.Units.SI.HeatFlowRate QCooShcExc_flow
    "Excess cooling heat flow rate - All modules in SHC mode";
  Modelica.Units.SI.Power PShcInt[nPLRShc]
    "Input power at PLR support points - SHC, single module";
  Real PLRHea(start=1)
    "Part load ratio - Modules in heating mode";
  Real PLRCoo(start=1)
    "Part load ratio - Modules in cooling mode";
  Real PLRShc(start=1)
    "Part load ratio - Modules in SHC mode";
  Real PLRShcSaf
    "Limiting part load ratio for safety - Modules in SHC mode";
  Real PLRShcLoa
    "Part load ratio satisfying the most demanding side - Modules in SHC mode";
  Real PLRHeaShcCyc(start=1)
    "Part load ratio - Modules in SHC mode that cycle in heating mode";
  Real PLRCooShcCyc(start=1)
    "Part load ratio - Modules in SHC mode that cycle in cooling mode";
  Modelica.Units.SI.Temperature THwTab=if use_TConOutForTab then THwLvg else THwEnt
    "HW temperature used for table data interpolation";
  Modelica.Units.SI.Temperature TChwTab=if use_TEvaOutForTab then TChwLvg else TChwEnt
    "CHW temperature used for table data interpolation";
  Modelica.Units.SI.Temperature TAmbTab=TAmbEnt
    "Fluid temperature on ambient side used for table data interpolation";
  Modelica.Units.SI.Temperature THwCtl=if use_TLoaLvgForCtl then THwEnt else THwLvg
    "HW temperature used for load calculation (Delta-T with setpoint)";
  Modelica.Units.SI.Temperature TChwCtl=if use_TLoaLvgForCtl then TChwEnt else TChwLvg
    "CHW temperature used for load calculation (Delta-T with setpoint)";
  Real sigLoa=if use_TLoaLvgForCtl then 1 else - 1
    "Sign of Delta-T used for load calculation";
  Real ratCycShc(start=1)
    "Cycling ratio between SHC and single mode for load balancing";
  Integer nUniHeaShcRaw(start=0, fixed=true)
    "Number of modules required to meet heating load based on SHC capacity";
  Integer nUniCooShcRaw(start=0, fixed=true)
    "Number of modules required to meet cooling load based on SHC capacity";
  discrete Real entryTime(final quantity="Time", final unit="s")
    "Time instant when stage started";
  Integer nUniHeaRaw(start=0, fixed=true)
    "Number of modules in heating mode - Without runtime requirement";
  Integer nUniCooRaw(start=0, fixed=true)
    "Number of modules in cooling mode - Without runtime requirement";
  Integer nUniShcRaw(start=0, fixed=true)
    "Number of modules in SHC mode (may be cycling into cooling or heating mode) - Without runtime requirement";
  Integer pre_nUniShcRaw(start=0, fixed=true)=pre(nUniShcRaw)
    "Left limit of nUniShcRaw";
  Integer pre_nUniHeaRaw(start=0, fixed=true)=pre(nUniHeaRaw)
    "Left limit of nUniHeaRaw";
  Integer pre_nUniCooRaw(start=0, fixed=true)=pre(nUniCooRaw)
    "Left limit of nUniCooRaw";
  Integer useHeaShc(start=0, fixed=true)
    "Calculation variable to zero out nUniHeaRaw when the bank is cooling dominated and SHC activated";
  Integer useCooShc(start=0, fixed=true)
    "Calculation variable to zero out nUniCooRaw when the bank is heating dominated and SHC activated";
  Integer useHea
    "Calculation variable to compute nUniHeaRaw in heating only mode";
  Integer useCoo
    "Calculation variable to compute nUniCooRaw in cooling only mode";
initial equation
  PHeaInt_nominal=Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(tabPHea, fill(
    THw_nominal, nPLRHea), fill(TAmbHea_nominal, nPLRHea));
  QHeaInt_flow_nominal=Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
    tabQHea, fill(THw_nominal, nPLRHea), fill(TAmbHea_nominal, nPLRHea));
  PCooInt_nominal=Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(tabPCoo, fill(
    TChw_nominal, nPLRCoo), fill(TAmbCoo_nominal, nPLRCoo));
  QCooInt_flow_nominal=Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
    tabQCoo, fill(TChw_nominal, nPLRCoo), fill(TAmbCoo_nominal, nPLRCoo));
  PShcInt_nominal=Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(tabPShc, fill(
    TChw_nominal, nPLRShc), fill(THw_nominal, nPLRShc));
  QCooShcInt_flow_nominal=Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
    tabQShc, fill(TChw_nominal, nPLRShc), fill(THw_nominal, nPLRShc));
  pre(nUniShc) = nUniShcRaw;
  pre(nUniHea) = nUniHeaRaw;
  pre(nUniCoo) = nUniCooRaw;
  pre(entryTime) = -Modelica.Constants.inf;
  QHeaSetMea_flow = 0;
  QCooSetMea_flow = 0;
equation
  // Update number of modules in each mode with respect to
  // - minimum stage runtime
  // - step-by-step staging
  // - maximum number of modules in bank
  // - priority order: SHC > heating > cooling
  when {initial(), change(pre_nUniShcRaw), change(pre_nUniHeaRaw), change(pre_nUniCooRaw),
    time >= pre(entryTime) + dtRun} then
    if time >= pre(entryTime) + dtRun then
      nUniShc = pre(nUniShc) + (
        if nUniShcRaw > pre(nUniShc) and pre(nUniShc) < nUni then 1
        elseif pre(nUniShc) > 0 and nUniShcRaw < pre(nUniShc) then -1
        else 0);
      nUniHea = pre(nUniHea) + (
        if nUniHeaRaw > pre(nUniHea) and
          nUniShc <= pre(nUniShc) and
          nUniShc + pre(nUniHea) < nUni then 1
        elseif pre(nUniHea) > 0 and
          nUniShc >= pre(nUniShc) and (
          nUniHeaRaw < pre(nUniHea) or
          nUniShc + pre(nUniHea) + pre(nUniCoo) > nUni) then -1
        else 0);
      nUniCoo = pre(nUniCoo) + (
        if nUniCooRaw > pre(nUniCoo) and
          nUniShc <= pre(nUniShc) and
          nUniShc + nUniHea + pre(nUniCoo) < nUni then 1
        elseif pre(nUniCoo) > 0 and
          nUniShc >= pre(nUniShc) and (
          nUniCooRaw < pre(nUniCoo) or
          nUniShc + nUniHea + pre(nUniCoo) > nUni) then -1
        else 0);
    else
      nUniShc = pre(nUniShc);
      nUniHea = pre(nUniHea);
      nUniCoo = pre(nUniCoo);
    end if;
    entryTime=if change(nUniShc) or change(nUniHea) or change(nUniCoo) then time
      else pre(entryTime);
  end when;
  // Update calculation variables for number of modules in single-mode depending on dominant load
  when {change(nUniShcRaw),change(nUniHeaShcRaw),change(nUniCooShcRaw)} then
    useHeaShc=if nUniShcRaw < nUni and nUniHeaShcRaw > nUniShcRaw then 1 else 0;
    useCooShc=if nUniShcRaw < nUni and nUniCooShcRaw > nUniShcRaw then 1 else 0;
  end when;
  if on and mode == Buildings.Fluid.HeatPumps.ModularReversible.Types.OperatingModes.heating
       then
    useHea=1;
    useCoo=0;
  elseif on and mode == Buildings.Fluid.HeatPumps.ModularReversible.Types.OperatingModes.cooling
       then
    useHea=0;
    useCoo=1;
  else
    useHea=0;
    useCoo=0;
  end if;
  // Calculate total heating and cooling loads
  QHeaSet_flow = max(0, sigLoa * (THwSet - THwCtl) * cpHw * mHw_flow);
  QCooSet_flow = min(0, sigLoa * (TChwSet - TChwCtl) * cpChw * mChw_flow);
  QHeaSaf_flow = QHeaSet_flow + dTSaf * cpHw * mHw_flow;
  QCooSaf_flow = QCooSet_flow - dTSaf * cpChw * mChw_flow;
  dtMea * der(QHeaSetMea_flow) = QHeaSet_flow - QHeaSetMea_flow;
  dtMea * der(QCooSetMea_flow) = QCooSet_flow - QCooSetMea_flow;
  // Calculate capacity in each mode given actual condenser and evaporator-side temperature
  QHeaInt_flow = scaFacHea * Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
    tabQHea, fill(THwTab, nPLRHea), fill(TAmbTab, nPLRHea));
  QCooInt_flow = scaFacCoo * Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
    tabQCoo, fill(TChwTab, nPLRCoo), fill(TAmbTab, nPLRCoo));
  QCooShcInt_flow=scaFacCooShc * Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
    tabQShc, fill(TChwTab, nPLRShc), fill(THwTab, nPLRShc));
  QHeaShcInt_flow=scaFacHeaShc *(PShcInt .- QCooShcInt_flow) / scaFacCooShc;
  // Calculate number of modules in SHC mode and PLR for these modules
  // (deltaX guards against numerical residuals influencing stage transitions near zero load)
  if on and mode == Buildings.Fluid.HeatPumps.ModularReversible.Types.OperatingModes.shc
       then
    nUniHeaShcRaw = integer(ceil((QHeaSetMea_flow - 10 * deltaX *
      QHeaShc_flow_nominal) / SPLR / max(
      cat(
        1,
        QHeaShcInt_flow,
        {deltaX*QHeaShc_flow_nominal}))));
    nUniCooShcRaw = integer(ceil((QCooSetMea_flow - 10 * deltaX *
      QCooShc_flow_nominal) / SPLR / min(
      cat(
        1,
        QCooShcInt_flow,
        {deltaX*QCooShc_flow_nominal}))));
  else
    nUniHeaShcRaw = 0;
    nUniCooShcRaw = 0;
  end if;
  nUniShcRaw =min({nUni,nUniHeaShcRaw,nUniCooShcRaw});
  if nUniShc > 0 then
    // Calculate PLR for modules in SHC mode
    // Using smoothLimit() instead of smoothMin(smoothMax()) below triggers chattering with OCT
    PLRShcSaf = min(
      Modelica.Math.Vectors.interpolate(
        cat(1, {0}, QHeaShcInt_flow),
        cat(1, {0}, PLRShcSor),
        QHeaSaf_flow / max(1, nUniShc + nUniHea)),
      Modelica.Math.Vectors.interpolate(
        abs(cat(1, {0}, QCooShcInt_flow)),
        cat(1, {0}, PLRShcSor),
        abs(QCooSaf_flow / max(1, nUniShc + nUniCoo))));
    PLRShcLoa = Buildings.Utilities.Math.Functions.smoothMin(
      Buildings.Utilities.Math.Functions.smoothMax(
        Modelica.Math.Vectors.interpolate(
          cat(1, {0}, QHeaShcInt_flow),
          cat(1, {0}, PLRShcSor),
          QHeaSet_flow / max(1, nUniShc + nUniHea)),
        Modelica.Math.Vectors.interpolate(
          abs(cat(1, {0}, QCooShcInt_flow)),
          cat(1, {0}, PLRShcSor),
          abs(QCooSet_flow / max(1, nUniShc + nUniCoo))),
        deltaX),
      PLRShc_max, deltaX);
    PLRShc = min(PLRShcSaf, PLRShcLoa);
    // Calculate thermal output of module in SHC mode without single-mode cycling
    QHeaShcNoCyc_flow = Modelica.Math.Vectors.interpolate(
      cat(1, {0}, PLRShcSor),
      cat(1, {0}, QHeaShcInt_flow),
      PLRShc);
    QCooShcNoCyc_flow = Modelica.Math.Vectors.interpolate(
      cat(1, {0}, PLRShcSor),
      cat(1, {0}, QCooShcInt_flow),
      PLRShc);
    // Calculate excess heat flow rate and SHC cycling ratio to balance heating and cooling loads
    // ratCycShc=1 means perfect balance (no cycling): module continuously runs in SHC.
    QHeaShcExc_flow = max(0, nUniShc * (QHeaShcNoCyc_flow - QHeaSet_flow / max(1, nUniShc + nUniHea)));
    QCooShcExc_flow = min(0, nUniShc * (QCooShcNoCyc_flow - QCooSet_flow / max(1, nUniShc + nUniCoo)));
    ratCycShc = 1 - Buildings.Utilities.Math.Functions.smoothMin(
      1,
      Buildings.Utilities.Math.Functions.smoothMax(
        QHeaShcExc_flow * Buildings.Utilities.Math.Functions.inverseXRegularized(
          QHeaShcNoCyc_flow, deltaX * QHeaShc_flow_nominal / nUni),
        QCooShcExc_flow * Buildings.Utilities.Math.Functions.inverseXRegularized(
          QCooShcNoCyc_flow, deltaX * abs(QCooShc_flow_nominal) / nUni),
        deltaX),
      deltaX);
    QHeaShc_flow = (nUniShc - 1 + ratCycShc) * QHeaShcNoCyc_flow;
    QCooShc_flow = (nUniShc - 1 + ratCycShc) * QCooShcNoCyc_flow;
    // Calculate PLR and thermal output of SHC module cycling into single-mode
    // Using smoothLimit() instead of smoothMin(smoothMax()) below makes
    // OCT fail to update the events when simulating Validation.TableData2DLoadDepSHC
    PLRHeaShcCyc = Buildings.Utilities.Math.Functions.smoothMin(
      Buildings.Utilities.Math.Functions.smoothMax(
        Modelica.Math.Vectors.interpolate(
          cat(1, {0}, QHeaInt_flow),
          cat(1, {0}, PLRHeaSor),
          (QHeaSet_flow / max(1, nUniShc + nUniHea) * nUniShc - QHeaShc_flow) *
          Buildings.Utilities.Math.Functions.inverseXRegularized(
            1 - ratCycShc, deltaX)),
        0, deltaX),
      PLRHea_max, deltaX);
    PLRCooShcCyc = Buildings.Utilities.Math.Functions.smoothMin(
      Buildings.Utilities.Math.Functions.smoothMax(
        Modelica.Math.Vectors.interpolate(
          abs(cat(1, {0}, QCooInt_flow)),
          cat(1, {0}, PLRCooSor),
          abs(QCooSet_flow / max(1, nUniShc + nUniCoo) * nUniShc - QCooShc_flow) *
          Buildings.Utilities.Math.Functions.inverseXRegularized(
            1 - ratCycShc, deltaX)),
        0, deltaX),
      PLRCoo_max, deltaX);
    QHeaShcCyc_flow = (1 - ratCycShc) * Modelica.Math.Vectors.interpolate(
      cat(1, {0}, PLRHeaSor), cat(1, {0}, QHeaInt_flow), PLRHeaShcCyc);
    QCooShcCyc_flow = (1 - ratCycShc) * Modelica.Math.Vectors.interpolate(
      cat(1, {0}, PLRCooSor), cat(1, {0}, QCooInt_flow), PLRCooShcCyc);
  else
    PLRShcSaf=0;
    PLRShcLoa=0;
    PLRShc=0;
    QHeaShcNoCyc_flow=0;
    QCooShcNoCyc_flow=0;
    ratCycShc=0;
    QHeaShc_flow=0;
    QCooShc_flow=0;
    QHeaShcExc_flow=0;
    QCooShcExc_flow=0;
    PLRHeaShcCyc=0;
    PLRCooShcCyc=0;
    QHeaShcCyc_flow=0;
    QCooShcCyc_flow=0;
  end if;
  // Calculate residual load, number of modules in single mode and PLR for these modules
  // (deltaX guards against numerical residuals influencing stage transitions near zero load)
  QHeaSetRes_flow = QHeaSet_flow -(QHeaShc_flow + QHeaShcCyc_flow);
  QCooSetRes_flow = QCooSet_flow -(QCooShc_flow + QCooShcCyc_flow);
  QHeaSetResMea_flow = QHeaSetMea_flow - (QHeaShc_flow + QHeaShcCyc_flow);
  QCooSetResMea_flow = QCooSetMea_flow - (QCooShc_flow + QCooShcCyc_flow);
  nUniHeaRaw=max(useHeaShc, useHea) * integer(ceil(
    (QHeaSetResMea_flow - 10 * deltaX * QHea_flow_nominal) / SPLR /
    max(cat(1, QHeaInt_flow, {deltaX * QHea_flow_nominal}))));
  nUniCooRaw=max(useCooShc, useCoo) * integer(ceil(
    (QCooSetResMea_flow - 10 * deltaX * QCoo_flow_nominal) / SPLR /
    min(cat(1, QCooInt_flow, {deltaX * QCoo_flow_nominal}))));
  if nUniHea > 0 then
    PLRHea=max(0, min(PLRHea_max, Modelica.Math.Vectors.interpolate(
      cat(1, {0}, QHeaInt_flow),
      cat(1, {0}, PLRHeaSor),
      QHeaSetRes_flow / nUniHea)));
    PHeaInt=scaFacHea * Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
      tabPHea, fill(THwTab, nPLRHea), fill(TAmbTab, nPLRHea));
  else
    PLRHea=0;
    PHeaInt=fill(0, nPLRHea);
  end if;
  if nUniCoo > 0 then
    PLRCoo=max(0, min(PLRCoo_max, Modelica.Math.Vectors.interpolate(
      abs(cat(1, {0}, QCooInt_flow)),
      cat(1, {0}, PLRCooSor),
      abs(QCooSetRes_flow / nUniCoo))));
    PCooInt=scaFacCoo * Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
      tabPCoo, fill(TChwTab, nPLRCoo), fill(TAmbTab, nPLRCoo));
  else
    PLRCoo = 0;
    PCooInt = fill(0, nPLRCoo);
  end if;
  // Calculate total heating and cooling flow rate and power
  PShcInt = scaFacCooShc * Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
    tabPShc, fill(TChwTab, nPLRShc), fill(THwTab, nPLRShc));
  QHea_flow = nUniHea * Modelica.Math.Vectors.interpolate(
    cat(1, {0}, PLRHeaSor), cat(1, {0}, QHeaInt_flow), PLRHea) +
    QHeaShc_flow + QHeaShcCyc_flow;
  QCoo_flow = nUniCoo * Modelica.Math.Vectors.interpolate(
    cat(1, {0}, PLRCooSor), cat(1, {0}, QCooInt_flow), PLRCoo) +
    QCooShc_flow + QCooShcCyc_flow;
  P = nUniHea * Modelica.Math.Vectors.interpolate(
      cat(1, {0}, PLRHeaSor), cat(1, {0}, PHeaInt), PLRHea) +
    nUniCoo * Modelica.Math.Vectors.interpolate(
      cat(1, {0}, PLRCooSor), cat(1, {0}, PCooInt), PLRCoo) +
    nUniShc * (ratCycShc * Modelica.Math.Vectors.interpolate(
      cat(1, {0}, PLRShcSor), cat(1, {0}, PShcInt), PLRShc) +
      (1 - ratCycShc) * (
        Modelica.Math.Vectors.interpolate(
          cat(1, {0}, PLRHeaSor), cat(1, {0}, PHeaInt), PLRHeaShcCyc) +
        Modelica.Math.Vectors.interpolate(
          cat(1, {0}, PLRCooSor), cat(1, {0}, PCooInt), PLRCooShcCyc)));
annotation (Dialog(tab="Advanced"),
Documentation(
info="<html>
<p>
This block provides the core implementation to model simultaneous heating and
cooling (SHC) systems, also referred to as multipipe polyvalent units or \"Type A\"
in Eurovent (2025).
Since the most recent versions of these systems are composed of multiple modules,
the implementation includes the staging logic for an arbitrary number of
modules <code>nUni</code>. Nevertheless, single-module systems can also be
appropriately represented by setting <code>nUni = 1</code>.
</p>
<p>
All kinds of capacity-modulation processes are supported, such as
VFD-driven compressors, multiple on-off compressors, and single compressor cycling.
The method used to interpolate capacity and power based on user-provided data is
taken from
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep</a>.
Users should be familiar with this latter block before continuing with this documentation.
</p>
<p>
The block implements the following functionalities.
</p>
<ul>
<li>
Ideal controls
</li>
<li>
Capacity and power calculation
</li>
<li>
Module staging
</li>
<li>
Load balancing between the HW and CHW side
</li>
</ul>
<h4>System and module operating mode</h4>
<p>
The block input <code>mode</code> allows switching between three system operating modes.
</p>
<ol>
<li>
Heating-only: In this mode, all modules operate as heat pumps, tracking
the HW temperature setpoint and sourcing heat from the ambient-side fluid.
</li>
<li>
Cooling-only: In this mode, all modules operate as chillers, tracking the CHW temperature
setpoint and rejecting heat to the ambient-side fluid.
</li>
<li>
Simultaneous heating and cooling: In this mode, some modules operate as  heat recovery chillers,
sourcing heat from the CHW circuit and rejecting heat to the HW circuit.
The system load balancing logic (see Section \"Load balancing between the HW and CHW side\")
ensures that, on average, both the HW temperature setpoint and the CHW temperature setpoint
are met by these modules. Additional modules may concurrently run in heating-only or
cooling-only mode to match the residual load.
In the extreme case where the system is only exposed to heating (resp. cooling) loads,
all modules will run in heating-only (resp. cooling-only) mode.
</li>
</ol>
<h4>Ideal controls</h4>
<p>
For each module operating mode, the block implements ideal controls by
solving for the part load ratio required to meet the load (more precisely the minimum
between the load and the actual capacity for the current source and sink temperatures).
This is done by interpolating the PLR values along the heat flow rate values
for a given load.
As described in Section \"Load balancing between the HW and CHW side\", the part load ratio
for modules in SHC mode is the maximum between the PLR values for the heating load and
the cooling load.
</p>
<p>
The load is calculated based on the HW and CHW-side side variables and the temperature setpoint
provided as inputs. The setpoint either represents a leaving (supply) temperature setpoint if
<code>use_TLoaLvgForCtl</code> is <code>true</code> (default setting) or the entering (return)
temperature if <code>use_TLoaLvgForCtl</code> is <code>false</code>.
</p>
<p>
In contrast to the implementation in
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep</a>
the current block does not expose the PLR value, and therefore does not support external modeling
of equipment safeties.
</p>
<h4>Capacity and power calculation</h4>
<p>
The capacity and power calculation follows the same logic as the one described in
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep</a>
except that the current block does not include compressor false loading, i.e., both the capacity
and power are linearly interpolated along PLR between <i>0</i> and <code>min(PLR&lt;Shc|Hea|Coo&gt;Sup)</code>.
</p>
<h5>Performance data file and scaling</h5>
<p>
The performance data are read from external ASCII files that must meet
the requirements specified in the documentation of
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep</a>.
</p>
<p>
A performance data file must be provided for each module operating mode:
heating-only, cooling-only and simultaneous heating and cooling.
It is expected that performance data be provided for a single module.
This is however a loose requirement as the scaling logic anyway ensures that
the nominal heat flow rates <code>Q*_flow_nominal</code> provided as parameters
match the values interpolated from the performance data, times the number of modules.
</p>
<p>
Note that for single-mode performance data, the ambient-side fluid temperature
must correspond to the <b>entering</b> temperature, while the model supports
choosing between entering or leaving temperature for the CHW and HW via
the parameters <code>use_TEvaOutForTab</code> and <code>use_TConOutForTab</code>,
respectively.
</p>
<h4>Module staging</h4>
<p>
First, the heating and cooling loads <code>QHeaSet_flow</code> and <code>QCooSet_flow</code>
are calculated from the block inputs (see Section \"Ideal controls\").
The staging logic uses time-averaged heating and cooling loads
<code>QHeaSetMea_flow</code> and <code>QCooSetMea_flow</code>.
An exponential moving average (<code>dtMea * der(Q&lt;Hea|Coo&gt;SetMea_flow) =
Q&lt;Hea|Coo&gt;Set_flow - Q&lt;Hea|Coo&gt;SetMea_flow</code>)
is used for computational efficiency.
</p>
<p>
Then the model evaluates the capacity of a single module in each mode, based on the current
source and sink fluid temperature (see Section \"Capacity and power calculation\").
The number of modules required to run to meet the load is then calculated for each mode as follows.
</p>
<ul>
<li>
Number of modules required to run in SHC mode to meet the heating load:<br/>
<code>nUniHeaShcRaw = ceil(QHeaSetMea_flow / max(QHeaShcInt_flow) / SPLR)</code>,<br/>
where <code>max(QHeaShcInt_flow)</code> is the heating capacity of one module in SHC mode
and <code>SPLR</code> is a parameter representing the staging part load ratio.
Note that this parameter should be strictly lower than <code>1</code> because
the number of staged modules ultimately conditions the opening of isolation valves
and the staging of primary pumps. If <code>SPLR = 1</code> it is
likely that the mass flow rate will limit the load below the capacity of a
single module, practically preventing the system from staging up until the
return temperature exceeds the design value.
</li>
<li>
Number of modules required to run in SHC mode to meet the cooling load:<br/>
<code>nUniCooShcRaw = ceil(QCooSetMea_flow / min(QCooSHcInt_flow) / SPLR)</code>,<br/>
where <code>min(QCooSHcInt_flow)</code> is the cooling capacity of one module in SHC mode.
</li>
<li>
Number of modules required to run in SHC mode:<br/>
<code>nUniShcRaw = min(nUniCooShcRaw, nUniHeaShcRaw)</code>.<br/>
This condition means that the system stops staging modules in SHC mode
when either the cooling load or the heating load is met.
</li>
<li>
Number of modules required to run in heating mode:<br/>
<code>nUniHeaRaw = ceil(QHeaSetResMea_flow / max(QHeaInt_flow) / SPLR)</code>,<br/>
where <code>QHeaSetResMea_flow</code> is the residual heating load, calculated as the
time-averaged heating load minus the heating output of modules in SHC mode,
and <code>max(QHeaInt_flow)</code> is the capacity of one module in heating-only mode.
</li>
<li>
Number of modules required to run in cooling mode:<br/>
<code>nUniCooRaw = ceil(QCooSetResMea_flow / min(QCooInt_flow) / SPLR)</code>,<br/>
where <code>QCooSetResMea_flow</code> is the residual cooling load, calculated as the
time-averaged cooling load minus the cooling output of modules in SHC mode,
and <code>min(QCooInt_flow)</code> is the capacity of one module in cooling-only mode.
</li>
</ul>
<p>
Discrete-event logic is then used to calculate the actual number of modules in
each mode (<code>nUniShc</code>, <code>nUniHea</code> and <code>nUniCoo</code>)
considering the following requirements.
</p>
<ul>
<li>Minimum stage runtime: The number of modules enabled in each mode must stay unchanged
for at least <code>dtRun</code>.</li>
<li>Step-by-step staging: Only one module can be enabled or disabled on the HW side at the
same time, and similarly for the CHW side. However, \"hot swapping\" is allowed,
where one module can be enabled or disabled in SHC mode while one module is simultaneously
being disabled or enabled in heating or cooling mode.
</li>
<li>Priority order: When the total number of modules required to run in each mode
(<code>nUniShcRaw + nUniHeaRaw + nUniCooRaw</code>) exceeds the number of modules in the bank,
the following priority applies where modules required in SHC mode are staged first and
modules required in cooling mode are staged last.</li>
</ul>
<h4>Load balancing between the HW and CHW side</h4>
<p>
A fundamental assumption for load balancing is that the system is composed
of equally sized modules that are hydronically balanced, connected in
parallel arrangement and controlled at the same setpoint.
This implies that each module connected to the HW (resp. CHW) loop handles an
equal fraction of the total heating (resp. cooling) load, irrespective of whether
the module operates in SHC or single mode.
This assumption is strictly true on the dominant side.
However, as explained below, it is only partially true on the non-dominant side where
setpoint deviations occur in the modules with excess thermal output and in
the compensating module.
</p>
<p>
Based on this assumption, on the dominant side, the heating or cooling load of each
module in SHC mode can be calculated as:</p>
<code>Q&lt;Hea|Coo&gt;SetUniShc_flow = Q&lt;Hea|Coo&gt;Set_flow / (nUniShc + nUni&lt;Hea|Coo&gt;)</code>.
<p>
In order to achieve load balancing between the CHW and HW sides for the
subset of modules in SHC mode, the model assumes that these modules are loaded
for the most demanding side, and that <b>a single module</b> can cycle between
SHC and the corresponding single-mode operation.
For example, in case of <i>90&nbsp;&percnt;</i> cooling load and <i>60&nbsp;&percnt;</i>
heating load, the module will cycle between SHC at <i>90&nbsp;&percnt;</i>&nbsp;PLR during
<i>2/3</i> of the time and cooling-only at <i>90&nbsp;&percnt;</i>&nbsp;PLR during
<i>1/3</i> of the time.
This logic is inspired from the sequence of operation of a multipipe heat pump system
(Johnson Controls, 2024) where the last enabled circuit cycles between
SHC and single-mode operation to balance the heating and cooling loads.
</p>
<p>
The part load ratio of each module in SHC mode to satisfy the most demanding side is:</p>
<code>PLRShcLoa = min(PLRShcSup, max(fHeaShc<sup>-1</sup>(QHeaSetUniShc_flow),
fCooShc<sup>-1</sup>(QCooSetUniShc_flow)))</code>,
<p>
where <code>f&lt;Hea|Coo&gt;Shc<sup>-1</sup></code> is the linear interpolation of the part
load ratio along the module heating or cooling capacity at the actual source and sink temperature,
based on the performance data provided for SHC operation.
</p>
<p>
A demand limiting logic is implemented to prevent overcooling or overheating due to the stage
minimum runtime requirement and the possible flow variations resulting from modulating the primary
pump speed and/or the minimum flow bypass valve.
This logic uses a temperature deviation from setpoint <code>dTSaf</code>, which is converted to
limiting heat flow rates <code>Q&lt;Hea|Coo&gt;Saf_flow</code>.
The limiting part load ratio is calculated as:</p>
<code>PLRShcSaf = min(fHeaShc<sup>-1</sup>(QHeaSaf_flow / (nUniShc + nUniHea)),
fCooShc<sup>-1</sup>(QCooSaf_flow / (nUniShc + nUniCoo)))</code>.
<p>
The effective part load ratio of each module in SHC mode is then the minimum of the load-based and
safety-limited values:</p>
<code>PLRShc = min(PLRShcLoa, PLRShcSaf)</code>.
<p>
The excess heating or cooling heat flow rate (non-dominant side) of the modules in SHC mode
is then calculated as:</p>
<code>Q&lt;Hea|Coo&gt;ShcExc_flow = nUniShc * (f&lt;Hea|Coo&gt;Shc(PLRShc) -
Q&lt;Hea|Coo&gt;SetUniShc_flow)</code>,
<p>where <code>f&lt;Hea|Coo&gt;Shc</code> is the linear interpolation of the module heating or
cooling capacity along the part load ratio at the actual source and sink temperature,
based on the performance data provided for SHC operation.</p>
<p>
This excess heat flow rate is compensated by cycling a single module, which gives the following
expression of the cycling ratio for this module:</p>
<code>ratCycShc = 1 - min(1, max(QHeaShcExc_flow / fHeaShc(PLRShc), QCooShcExc_flow / fCooShc(PLRShc)))</code>,
<p>where <code>ratCycShc = 1</code> means perfect balance, i.e., the module does not cycle and
continuously runs in SHC mode, and <code>ratCycShc = 0</code> means that the module continuously
runs in single mode.</p>
<p>
The actual heating or cooling heat flow rate of the modules in SHC mode is:</p>
<code>Q&lt;Hea|Coo&gt;Shc_flow = (nUniShc - 1 + ratCycShc) * f&lt;Hea|Coo&gt;Shc(PLRShc)</code>.
<p>
The residual load that the module which cycles between SHC and single-mode must handle is:</p>
<code>Q&lt;Hea|Coo&gt;SetUniShc_flow * nUniShc - Q&lt;Hea|Coo&gt;Shc_flow</code>,
<p>which gives the part load ratio <code>PLR&lt;Hea|Coo&gt;ShcCyc</code> of this module while
it runs in single mode.
The corresponding heating or cooling heat flow rate is then:</p>
<code>Q&lt;Hea|Coo&gt;ShcCyc_flow = (1 - ratCycShc) * f&lt;Hea|Coo&gt;(PLR&lt;Hea|Coo&gt;ShcCyc)</code>,
<p>where <code>f&lt;Hea|Coo&gt;</code> is the linear interpolation of the module capacity along
the part load ratio at the actual source and sink temperature,
based on the performance data provided for single-mode operation.</p>
<p>
The residual heating or cooling loads that the modules running in single mode must meet
can now be calculated as:</p>
<code>Q&lt;Hea|Coo&gt;SetRes_flow = Q&lt;Hea|Coo&gt;Set_flow -
(Q&lt;Hea|Coo&gt;Shc_flow + Q&lt;Hea|Coo&gt;ShcCyc_flow)</code>,
<p>
which ultimately allows calculating the PLR value of these modules and their contribution
to the total heating and cooling output of the bank.
</p>
<h4>Implementation limitations</h4>
<p>
The load balancing logic relies on a subset of modules producing excess heat flow rate
while another module compensates for it.
The fundamental assumption of even load between modules therefore breaks down on
the non-dominant side.
In a real system where the modules are hydronically balanced, this load imbalance yields
varying leaving temperatures across modules.
In the worst case, the deviation from setpoint is <code>SPLR / 2</code> times the
design &Delta;T.
</p>
<p>
These temperature discrepancies are neglected in the model which \"numerically absorbs\"
them by simply adjusting the load that each module must handle.
This creates a modeling uncertainty that is deemed acceptable given the error magnitude
and partial cancellation of opposing errors from modules that exhibit setpoint overshoot
and modules that exhibit setpoint undershoot.
</p>
<h4>References</h4>
<ul>
<li>
Eurovent (2025). Technical certification rules (TCR) of the Eurovent certified performance
mark liquid chilling packages and hydronic heat pumps (ECP - 3 LCPHP, Rev. 02-2025).
<a href=\"https://www.eurovent-certification.com/media/images/c2c/031/c2c031f2dd38173a81e30a42f7d6f42a386f047c.pdf\">
https://www.eurovent-certification.com/media/images/c2c/031/c2c031f2dd38173a81e30a42f7d6f42a386f047c.pdf</a>
</li>
<li>
Johnson Controls, Inc. (2024). YMAE application guide - YMAE air-to-water inverter scroll heat pumps.
YORK.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
July 1, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-100,-160},{100,160}})),
    Icon(
      coordinateSystem(
        extent={{-100,-160},{100,160}}), graphics={
                                Rectangle(
        extent={{-100,-160},{100,160}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-150,210},{150,170}},
        textString="%name",
        textColor={0,0,255})}));
end TableData2DLoadDepSHC;
