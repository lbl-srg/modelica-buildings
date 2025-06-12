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
    final unit="s")=60
    "Minimum stage runtime"
    annotation (Dialog(tab="Advanced"));
  parameter Real dtMea(
    final min=0,
    final unit="s")=30
    "Load averaging time window";
  parameter Real SPLR(
    max=1,
    min=0)=0.9
    "Staging part load ratio"
    annotation (Dialog(tab="Advanced"));
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
    unit="1")=QHea_flow_nominal /(nUni * QHeaInt1_flow_nominal)
    "Scaling factor for interpolated heat flow rate and power - Heating";
  final parameter Real scaFacCoo(
    unit="1")=QCoo_flow_nominal /(nUni * QCooInt1_flow_nominal)
    "Scaling factor for interpolated heat flow rate and power - Cooling";
  final parameter Real scaFacCooShc(
    unit="1")=QCooShc_flow_nominal /(nUni * QCooShcInt1_flow_nominal)
    "Scaling factor for interpolated cooling heat flow rate and power - SHC";
  final parameter Real scaFacHeaShc(
    unit="1")=QHeaShc_flow_nominal /(nUni * QHeaShcInt1_flow_nominal)
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
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
      iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QHea_flow(
    final unit="J/s") "Heating heat flow rate"
    annotation (Placement(transformation(extent={{100,120},{140,160}}),
      iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QCoo_flow(
    final unit="J/s")
    "Cooling heat flow rate"
    annotation (Placement(transformation(extent={{100,80},{140,120}}),
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
  constant Real deltaX=1E-4
    "Small number used for smoothing";
  Modelica.Units.SI.HeatFlowRate QHeaSet_flow
    "Heating load - All modules";
  Modelica.Units.SI.HeatFlowRate QCooSet_flow
    "Cooling load - All modules";
  Modelica.Units.SI.HeatFlowRate QHeaSetRes_flow
    "Residual heating load - All modules except those in SHC mode";
  Modelica.Units.SI.HeatFlowRate QCooSetRes_flow
    "Residual cooling load - All modules except those in SHC mode";
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
  Integer nUniShcHea(start=0, fixed=true)
    "Number of modules required to meet heating load based on SHC capacity";
  Integer nUniShcCoo(start=0, fixed=true)
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
  pre(nUniShc)=nUniShcRaw;
  pre(nUniHea)=nUniHeaRaw;
  pre(nUniCoo)=nUniCooRaw;
  pre(entryTime)=- Modelica.Constants.inf;
equation
  // Update number of modules in each mode with respect to
  // - minimum stage runtime
  // - step-by-step staging
  // - maximum number of modules in bank
  // - priority order: SHC > heating > cooling
  when {change(pre_nUniShcRaw), change(pre_nUniHeaRaw), change(pre_nUniCooRaw),
    time >= pre(entryTime) + dtRun} then
    if time >= pre(entryTime) + dtRun then
      nUniShc=pre(nUniShc) + (if nUniShcRaw > pre(nUniShc) then 1
        elseif nUniShcRaw < pre(nUniShc) then -1 else 0);
      nUniHea=pre(nUniHea) + (if nUniShc == nUni then 0
        elseif nUniHeaRaw > pre(nUniHea) then 1
        elseif nUniHeaRaw < pre(nUniHea) then -1 else 0);
      nUniCoo=pre(nUniCoo) + (if nUniShc + nUniHea == nUni then 0
        elseif nUniCooRaw > pre(nUniCoo) then 1
        elseif nUniCooRaw < pre(nUniCoo) then -1 else 0);
    else
      nUniShc=pre(nUniShc);
      nUniHea=pre(nUniHea);
      nUniCoo=pre(nUniCoo);
    end if;
    entryTime=if change(nUniShc) or change(nUniHea) or change(nUniCoo) then time
      else pre(entryTime);
  end when;
  // Update calculation variables for number of modules in single-mode depending on dominant load
  when {initial(), change(nUniShcRaw), change(nUniShcHea), change(nUniShcCoo)}
    then
    useHeaShc=if nUniShcRaw < nUni and nUniShcHea > nUniShcRaw then 1 else 0;
    useCooShc=if nUniShcRaw < nUni and nUniShcCoo > nUniShcRaw then 1 else 0;
  end when;
  if on and mode == Buildings.Fluid.HeatPumps.Types.OperatingModes.heating then
    useHea=1;
    useCoo=0;
  elseif on and mode == Buildings.Fluid.HeatPumps.Types.OperatingModes.cooling
    then
    useHea=0;
    useCoo=1;
  else
    useHea=0;
    useCoo=0;
  end if;
  QHeaSet_flow=max(0, sigLoa *(THwSet - THwCtl) * cpHw * mHw_flow);
  QCooSet_flow=min(0, sigLoa *(TChwSet - TChwCtl) * cpChw * mChw_flow);
  QHeaInt_flow=scaFacHea * Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
    tabQHea, fill(THwTab, nPLRHea), fill(TAmbTab, nPLRHea));
  QCooInt_flow=scaFacCoo * Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
    tabQCoo, fill(TChwTab, nPLRCoo), fill(TAmbTab, nPLRCoo));
  QCooShcInt_flow=scaFacCooShc * Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
    tabQShc, fill(TChwTab, nPLRShc), fill(THwTab, nPLRShc));
  QHeaShcInt_flow=scaFacHeaShc *(PShcInt .- QCooShcInt_flow) / scaFacCooShc;
  if on and mode == Buildings.Fluid.HeatPumps.Types.OperatingModes.shc then
    nUniShcHea=integer(ceil((QHeaSet_flow - deltaX * QHeaShc_flow_nominal) / SPLR /
      max(cat(1, QHeaShcInt_flow, {deltaX * QHeaShc_flow_nominal}))));
    nUniShcCoo=integer(ceil((QCooSet_flow - deltaX * QCooShc_flow_nominal) / SPLR /
      min(cat(1, QCooShcInt_flow, {deltaX * QCooShc_flow_nominal}))));
  else
    nUniShcHea=0;
    nUniShcCoo=0;
  end if;
  nUniShcRaw=min({nUni, nUniShcHea, nUniShcCoo});
  if nUniShc > 0 then
    PLRShc=Buildings.Utilities.Math.Functions.smoothLimit(max(Modelica.Math.Vectors.interpolate(
      cat(1, {0}, QHeaShcInt_flow), cat(1, {0}, PLRShcSor), QHeaSet_flow /(
      nUniShc + nUniHea)), Modelica.Math.Vectors.interpolate(abs(cat(1, {0}, QCooShcInt_flow)), cat(
      1, {0}, PLRShcSor), abs(QCooSet_flow /(nUniShc + nUniCoo)))), 0, PLRShc_max, deltaX);
    QHeaShcNoCyc_flow=Modelica.Math.Vectors.interpolate(cat(1, {0}, PLRShcSor), cat(
      1, {0}, QHeaShcInt_flow), PLRShc);
    QCooShcNoCyc_flow=Modelica.Math.Vectors.interpolate(cat(1, {0}, PLRShcSor), cat(
      1, {0}, QCooShcInt_flow), PLRShc);
    QHeaShcExc_flow = nUniShc * (QHeaShcNoCyc_flow - QHeaSet_flow / (nUniShc + nUniHea));
    QCooShcExc_flow = nUniShc * (QCooShcNoCyc_flow - QCooSet_flow / (nUniShc + nUniCoo));
    ratCycShc=Buildings.Utilities.Math.Functions.smoothMax(0,
      1 - Buildings.Utilities.Math.Functions.smoothMax(
      QHeaShcExc_flow * Buildings.Utilities.Math.Functions.inverseXRegularized(
        QHeaShcNoCyc_flow, deltaX * QHeaShc_flow_nominal / nUni),
      QCooShcExc_flow * Buildings.Utilities.Math.Functions.inverseXRegularized(
        QCooShcNoCyc_flow, deltaX * abs(QCooShc_flow_nominal) / nUni),
      deltaX), deltaX);
    QHeaShc_flow=(nUniShc - 1 + ratCycShc) * QHeaShcNoCyc_flow;
    QCooShc_flow=(nUniShc - 1 + ratCycShc) * QCooShcNoCyc_flow;
    // Using smoothLimit() instead of smoothMin(smoothMax()) below makes
    // OCT fail to update the events when simulating Validation.TableData2DLoadDepSHC
    PLRHeaShcCyc=Buildings.Utilities.Math.Functions.smoothMin(
      Buildings.Utilities.Math.Functions.smoothMax(Modelica.Math.Vectors.interpolate(
      cat(1, {0}, QHeaInt_flow),
      cat(1, {0}, PLRHeaSor),
      (QHeaSet_flow / (nUniShc + nUniHea) * nUniShc - QHeaShc_flow) *
      Buildings.Utilities.Math.Functions.inverseXRegularized(1 - ratCycShc, deltaX)),
      0, deltaX), PLRHea_max, deltaX);
    PLRCooShcCyc=Buildings.Utilities.Math.Functions.smoothMin(
      Buildings.Utilities.Math.Functions.smoothMax(Modelica.Math.Vectors.interpolate(
      abs(cat(1, {0}, QCooInt_flow)),
      cat(1, {0}, PLRCooSor),
      abs(QCooSet_flow / (nUniShc + nUniCoo) * nUniShc - QCooShc_flow) *
      Buildings.Utilities.Math.Functions.inverseXRegularized(1 - ratCycShc, deltaX)),
      0, deltaX), PLRCoo_max, deltaX);
    QHeaShcCyc_flow=(1 - ratCycShc) * Modelica.Math.Vectors.interpolate(
      cat(1, {0}, PLRHeaSor), cat(1, {0}, QHeaInt_flow), PLRHeaShcCyc);
    QCooShcCyc_flow=(1 - ratCycShc) * Modelica.Math.Vectors.interpolate(
      cat(1, {0}, PLRCooSor), cat(1, {0}, QCooInt_flow), PLRCooShcCyc);
  else
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
  QHeaSetRes_flow=QHeaSet_flow -(QHeaShc_flow + QHeaShcCyc_flow);
  QCooSetRes_flow=QCooSet_flow -(QCooShc_flow + QCooShcCyc_flow);
  nUniHeaRaw=max(useHeaShc, useHea) * integer(ceil((QHeaSetRes_flow - deltaX *
    QHea_flow_nominal) / SPLR / max(cat(1, QHeaInt_flow, {deltaX *
    QHea_flow_nominal}))));
  nUniCooRaw=max(useCooShc, useCoo) * integer(ceil((QCooSetRes_flow - deltaX *
    QCoo_flow_nominal) / SPLR / min(cat(1, QCooInt_flow, {deltaX *
    QCoo_flow_nominal}))));
  if nUniHea > 0 then
    PLRHea=max(0, min(PLRHea_max, Modelica.Math.Vectors.interpolate(cat(1, {0}, QHeaInt_flow), cat(
      1, {0}, PLRHeaSor), QHeaSetRes_flow / nUniHea)));
    PHeaInt=scaFacHea * Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
      tabPHea, fill(THwTab, nPLRHea), fill(TAmbTab, nPLRHea));
  else
    PLRHea=0;
    PHeaInt=fill(0, nPLRHea);
  end if;
  if nUniCoo > 0 then
    PLRCoo=max(0, min(PLRCoo_max, Modelica.Math.Vectors.interpolate(abs(cat(1, {0}, QCooInt_flow)), cat(
      1, {0}, PLRCooSor), abs(QCooSetRes_flow / nUniCoo))));
    PCooInt=scaFacCoo * Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
      tabPCoo, fill(TChwTab, nPLRCoo), fill(TAmbTab, nPLRCoo));
  else
    PLRCoo=0;
    PCooInt=fill(0, nPLRCoo);
  end if;
  PShcInt=scaFacCooShc * Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
    tabPShc, fill(TChwTab, nPLRShc), fill(THwTab, nPLRShc));
  QHea_flow=nUniHea * Modelica.Math.Vectors.interpolate(cat(1, {0}, PLRHeaSor), cat(
    1, {0}, QHeaInt_flow), PLRHea) + QHeaShc_flow + QHeaShcCyc_flow;
  QCoo_flow=nUniCoo * Modelica.Math.Vectors.interpolate(cat(1, {0}, PLRCooSor), cat(
    1, {0}, QCooInt_flow), PLRCoo) + QCooShc_flow + QCooShcCyc_flow;
  P=nUniHea * Modelica.Math.Vectors.interpolate(cat(1, {0}, PLRHeaSor),
      cat(1, {0}, PHeaInt), PLRHea) +
    nUniCoo * Modelica.Math.Vectors.interpolate(cat(1, {0}, PLRCooSor),
      cat(1, {0}, PCooInt), PLRCoo) +
    nUniShc *(ratCycShc * Modelica.Math.Vectors.interpolate(cat(1, {0}, PLRShcSor), cat(
    1, {0}, PShcInt), PLRShc) +(1 - ratCycShc) *(Modelica.Math.Vectors.interpolate(
    cat(1, {0}, PLRHeaSor), cat(1, {0}, PHeaInt), PLRHeaShcCyc) + Modelica.Math.Vectors.interpolate(
    cat(1, {0}, PLRCooSor), cat(1, {0}, PCooInt), PLRCooShcCyc)));
    annotation (Dialog(tab="Advanced"),
    Documentation(
      info="<html>
The model assumes hydronic balance over each active module.
<h4>Simultaneous heating and cooling operation</h4>
<p>
Modular systems in parallel arrangement with hydronic balance over each module
require that each module handles an equal fraction of the total heating and
cooling loads.
Otherwise, when one module cannot meet its assigned load fraction, this creates
a deficit that must be compensated in two ways: another module must handle not only
an increased load, but also a modified temperature setpoint to account for the
other module's shortfall.
To achieve effective load balancing across all modules, the model assumes cycling
between simultaneous SHC mode and single-mode operation. This cycling ensures that,
on average, loads are met on both sides.
The alternative operating mode corresponds to the dominant load — for example,
when cooling loads dominate, modules will cycle between SHC mode and cooling-only
operation.
The cycling ratio <code>ratCycShc</code> is then calculated as:
<code>ratCycShc = min(...)</code>.
</p>
<p>
This block implements two core features for some chiller and heat pump models
within <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible\">
Buildings.Fluid.HeatPumps.ModularReversible</a> and
<a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible\">
Buildings.Fluid.Chillers.ModularReversible</a>.
</p>
<ul>
<li>
<b>Ideal controls</b>: The heating or cooling load is calculated based on the block
inputs. The block returns the required part load ratio <code>PLR</code>
to meet the load, within system capacity.<sup>1</sup>
</li>
<li>
<b>Capacity and power calculation</b>: The capacity and power are interpolated
from user-provided data along the load side fluid temperature,
the ambient-side fluid temperature
and the part load ratio <code>yMea</code> provided as input.<sup>2</sup>
</li>
</ul>
<p>
<sup>1</sup> The part load ratio is defined as the ratio of the actual heating
(or cooling) heat flow rate to the maximum capacity of the heat pump (or chiller)
at the given load-side and ambient-side fluid temperatures.
It is dimensionless and bounded by <code>0</code> and <code>max(PLRSup)</code>, where
the upper bound is typically equal to <code>1</code> (unless there are some
capacity margins at design conditions that need to be accounted for).
In this block, the part load ratio is used as a proxy variable
for the actual capacity modulation observable.
For systems with VFDs, this is the compressor speed.
For systems with on/off compressors, this is the capacity of the enabled
compressors divided by the total capacity.
When meeting the load by cycling on and off a single compressor,
this is the time fraction the compressor is enabled.
In all cases, the algorithm assumes continuous operation and only approximates
the performance on a time average.
Finally, note that while the part load ratio is used for generalization purposes,
either the part load ratio or the actual capacity modulation observable
(e.g., the normalized compressor speed) may be used to map the performance data.
The only requirement is that this variable be normalized, as the algorithm assumes
it equals <code>1</code> at design (selection) conditions.
</p>
<p>
<sup>2</sup> The reason why the part load ratio is both calculated (<code>PLR</code>)
and exposed as an input (<code>yMea</code>) is to allow for modeling internal safeties
that can limit operation.
If no safeties are modeled, a direct feedback of <code>PLR</code> to
<code>yMea</code> can be used.
</p>
<h4>Capacity and power calculation</h4>
<p>
When the machine is enabled (input signal <code>on</code> is true)
the capacity and power are calculated by partitioning the PLR values
into three domains, as illustrated in Figure&nbsp;1.
</p>
<ol>
<li><b>Normal capacity modulation</b><br>
This domain corresponds to the capacity range where the machine adapts to the
load without false loading or cycling on and off the last operating compressor.
Depending on the technology, this is achieved for example by modulating
the compressor speed, throttling the inlet guide vanes
or staging a varying number of compressors.
In this domain, both the machine PLR and the compressor PLR vary.
The capacity and power are linearly interpolated
based on the performance data provided in an external file, which
syntax is specified in the following section.
The interpolation is carried out along three variables: the
load-side fluid temperature, the ambient-side fluid temperature
and the part load ratio.
Note that no extrapolation is performed.
The capacity and power are limited by the minimum or maximum values
provided in the performance data file.
</li>
<li><b>Compressor false loading</b><br>
This domain corresponds to the capacity range where the machine adapts to the
load by false loading the compressor.
For a chiller, this is achieved by bypassing hot gas directly to the evaporator.
In this domain, the machine PLR varies while the compressor PLR stays
roughly the same.
The input power is considered equal to the interpolated value at
<code>TLoa</code>, <code>TSou</code>, <code>min(PLRSup)</code>.
This domain may not exist if the parameter <code>PLRCyc_min</code> is
equal to <code>min(PLRSup)</code>, which is the default setting.
</li>
<li><b>Last operating compressor cycling</b><br>
This domain corresponds to the capacity range where the last
operating compressor cycles on and off.
In this domain, the capacity is linearly interpolated between
<code>0</code> and the value at <code>TLoa</code>, <code>TSou</code>, <code>min(PLRSup)</code>,
while the power is linearly interpolated between
<code>P_min</code> and the value at <code>TLoa</code>, <code>TSou</code>,
<code>min(PLRSup)</code>, where <code>P_min</code> corresponds
to the remaining power when the machine is enabled and all compressors are disabled.
</li>
</ol>
<p>
<img src=\"modelica://Buildings/Resources/Images/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/TableData2DLoadDep.png\"
border=\"1\" alt=\"Input power as a function of the part load ratio.\"/>
</p>
<p><i>Figure 1. Input power as a function of the part load ratio.</i></p>
<h4>Performance data file</h4>
<p>
The performance data are read from an external ASCII file that must meet
the requirements specified in the documentation of
<a href=\"modelica://Modelica.Blocks.Tables.CombiTable2Ds\">
Modelica.Blocks.Tables.CombiTable2Ds</a>.
</p>
<p>
In addition, this file must contain at least two 2D-tables that provide the maximum
heating (resp. minimum cooling) heat flow rate and the input power
of the heat pump (resp. chiller) at <i>100&nbsp;&percnt;</i>
PLR.
Each row of these tables corresponds to a value of the load-side
fluid temperature, each column corresponds to a value of the
ambient-side fluid temperature.
This could be either the leaving temperature if <code>use_T*OutForTab</code>
is true, or the entering temperature if <code>use_T*OutForTab</code>
is false.
The load and ambient temperatures must cover the whole operating domain,
knowing that the model only performs interpolation and no extrapolation
of the capacity and power along these variables.
</p>
<p>
The table providing the capacity values must be named <code>q@X.XX</code>
where <code>X.XX</code> is the PLR value formatted with exactly
2 decimal places (<code>\"%.2f\"</code>).
Similarly, the table providing the power values must be named
<code>p@X.XX</code>.
</p>
<p>
Here is an example of chiller data (\"-----\" is not part of the file content):
</p>
<blockquote><pre>
-----------------------------------------------------
#1
double q@1.00(5,5)                    # Cooling heat flow rate at 100 % PLR
0 292.0 297.4 302.8 308.2             # CW temperatures as column headers
280.4 -493241 -555900 -495611 -312372 # Each row provides the capacity at a given CHW temperature
282.2 -470560 -578165 -562822 -424529
284.1 -418413 -573462 -605561 -514711
285.9 -342290 -542284 -619329 -573426
double p@1.00(5, 5)                   # Input power at 100 % PLR
0 292.0 297.4 302.8 308.2             # CW temperatures as column headers
280.4 60430 80413 80830 55530         # Each row provides the input power at a given CHW temperature
282.2 54399 80278 89151 73950
284.1 45251 76017 92822 87633
285.9 34546 68567 91833 95401
-----------------------------------------------------
</pre></blockquote>
<p>
In addition, for machines that have capacity modulation other than
cycling on and off a single compressor, the whole range of <b>normal
capacity modulation</b> must be covered by providing similar 2D-tables
at different PLR values.
The lowest PLR value will be considered as the minimum PLR value
before false loading the compressor.
If the machine has no hot gas bypass (<code>PLRCyc_min = min(PLRSup)</code>)
this will correspond to the minimum PLR value before cycling the
last operating compressor.
</p>
<p>
All the PLR values used in the performance data file must be specified
in the array parameter <code>PLRSup[:]</code>.
</p>
<h4>Compressor cycling</h4>
<p>
Compressor cycling is not explicitly modeled.
Instead, the model assumes continuous operation from <code>0</code> to <code>max(PLRSup)</code>.
The only effect of cycling taken into account is the impact of the remaining power
<code>P_min</code> when the machine is enabled and the last operating
compressor is cycled off.
Studies on chillers and heat pumps show that this is the main driver of
efficiency loss due to cycling (Rivière, 2004).
When a compressor is staged on, energy losses occur due to the overcoming of the
refrigerant pressure equalization and the heat exchanger temperature conditioning.
However, a large part of these losses is recovered when staging off the compressor,
unless the machine is disconnected from the load when compressors are disabled.
This disconnection does not happen when staging multiple compressors,
and the research shows no significant performance degradation when a
chiller cycles between different stages without completely shutting down.
And even when disabling the last operating compressor, most plant
controls require continuous operation of the primary pumps when
the chillers or heat pumps are enabled.
The European Standard for performance rating of chillers and heat pumps
at part load conditions (CEN, 2022) states that the performance degradation due to
the pressure equalization effect when the unit restarts can be considered
as negligible for hydronic systems.
The only effect that will impact the coefficient of performance
when cycling is the remaining power input when the compressor is switching off.
If this remaining power is not measured, the Standard prescribes a default
value of <i>10&nbsp;&percnt;</i> of the effective power input measured
during continuous operation at part load.
</p>
<h4>Heat recovery chillers</h4>
<p>
Heat recovery chillers can be modeled with this block.
In this case, the same chiller performance data file is used for
both cooling and heating operation.
The model assumes that all dissipated heat from the compressor
is recovered by the refrigerant. This assumption enables computing
the heating capacity as the sum of the cooling capacity and the input power.
</p>
<p>
When configured to represent a heat recovery chiller, this block uses an
additional input connector <code>coo</code> which must be true when
cooling mode is enabled, and false when heating mode is enabled.
The load side input variables must externally be connected to the
evaporator side variables in cooling mode, and to the condenser side
variables in heating mode.
The output connector <code>Q_flow</code> is always the
<i>cooling</i> heat flow rate, whatever the operating mode.
The heating heat flow rate in heating mode can be computed
externally as <code>P-Q_flow</code>.
</p>
<h4>Ideal controls</h4>
<p>
The block implements ideal controls by solving for the part load ratio
required to meet the load (more precisely the minimum between the load
and the actual capacity for the current load and ambient temperatures).
This is done by interpolating the PLR values along the heat flow rate values
for a given load.
</p>
<p>
The load is calculated based on the load side variables and the temperature
setpoint provided as inputs. The setpoint either represents a leaving (supply)
temperature setpoint if <code>use_TLoaLvgForCtl</code> is true (default setting)
or the entering (return) temperature if <code>use_TLoaLvgForCtl</code> is false.
</p>
<p>
The required PLR value is returned as an output while the actual heat flow rate
and power are calculated using the PLR value <code>yMea</code> provided as input,
which allows limiting the required PLR to account for equipment internal safeties.
</p>
<h4>References</h4>
<ul>
<li>
CEN, 2022. European Standard EN&nbsp;14825:2022&nbsp;E.
Air conditioners, liquid chilling packages and heat pumps,
with electrically driven compressors, for space heating and cooling,
commercial and process cooling - Testing and rating at part load conditions
and calculation of seasonal performance.
</li>
<li>Rivière, P. (2004). Performances saisonnières des groupes de production d’eau glaçée
[Seasonal performance of liquid chilling packages].
École Nationale Supérieure des Mines de Paris. [In French].
<a href=\"https://pastel.hal.science/pastel-00001483\">https://pastel.hal.science/pastel-00001483</a>
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
March 21, 2025, by Antoine Gautier:<br/>
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
  // OMC and OCT require getTable2DValueNoDer2() to be called in initial equation section.
  // Binding equations yield incorrect results but no error!
  // Compute total heating and cooling loads
  // Compute capacity given actual temperatures
  // Compute number of modules in SHC mode and PLR for these modules
  // (deltaX guards against numerical residuals influencing stage transitions near zero load)
    // Compute PLR for modules in SHC mode
    // Compute thermal output of module in SHC mode without single-mode cycling
    // Excess thermal output
    // Compute SHC cycling ratio to balance heating and cooling loads
    // ratCycShc=1 means perfect balance (no cycling): module continuously runs in SHC.
    // Compute PLR and thermal output of SHC module cycling into single-mode
  // Compute residual loads, number of single-mode modules and PLR
  // (deltaX guards against numerical residuals influencing stage transitions near zero load)
  // Compute total heating and cooling flow rate and power
end TableData2DLoadDepSHC;
