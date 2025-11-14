within Buildings.DHC.ETS.Combined.Data;
record HeatPump
  "Parameters for the modular expandable heat pump in energy transfer station"
  extends Modelica.Icons.Record;
  constant Modelica.Units.SI.SpecificHeatCapacity cpWat =
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq;

  parameter Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump datHea =
    Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.WAMAK_WaterToWater_220kW()
    "Performance map for the heat pump"
    annotation (Dialog(group="Performance map"));
//  parameter Real PLRMax(
//    min=0, max=1, final unit="1") = 1 "Maximum part load ratio"
//    annotation (Dialog(group="Part load"));
  parameter Real PLRMin(
   min=0, max=1, final unit="1")= 0.3 "Minimum part load ratio"
    annotation (Dialog(group="Part load"));

  parameter Modelica.Units.SI.HeatFlowRate QHeaDes_flow_nominal(min=Modelica.Constants.eps)
    "Desired design heating capacity"
    annotation (Dialog(group="Heating design condition"));

  parameter Modelica.Units.SI.HeatFlowRate QCooDes_flow_nominal(max=-Modelica.Constants.eps)
    "Desired design cooling capacity"
    annotation (Dialog(group="Cooling design condition"));

  // fixme: verify that all data are indeed used by the model, and delete what is not used.
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal(
    min=Modelica.Constants.eps)
    "Nominal temperature difference in condenser medium (positive)"
    annotation (Dialog(group="Condenser"));
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal(
    min=Modelica.Constants.eps)
    "Nominal temperature difference in evaporator medium (positive)"
    annotation (Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.Temperature THeaConLvg_nominal(
      displayUnit="degC")
    "Nominal condenser leaving temperature at desired heating capacity"
    annotation (Dialog(group="Heating design condition"));
  parameter Modelica.Units.SI.Temperature THeaEvaLvg_nominal(
      displayUnit="degC")
    "Nominal evaporator leaving temperature at desired heating capacity"
    annotation (Dialog(group="Heating design condition"));
  parameter Modelica.Units.SI.Temperature TCooConLvg_nominal(
      displayUnit="degC")
    "Nominal condenser leaving temperature at desired cooling capacity"
    annotation (Dialog(group="Cooling design condition"));
  parameter Modelica.Units.SI.Temperature TCooEvaLvg_nominal(
      displayUnit="degC")
    "Nominal evaporator leaving temperature at desired cooling capacity"
    annotation (Dialog(group="Cooling design condition"));
//  parameter Modelica.Units.SI.Temperature TConEntMin(displayUnit="degC") =
//    25 + 273.15
//    "Minimum of condenser water entering temperature"
//    annotation (Dialog(group="Condenser"));
//  parameter Modelica.Units.SI.Temperature TEvaEntMax(displayUnit="degC") =
//    20 + 273.15
//    "Maximum of evaporator water entering temperature"
//    annotation (Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.Temperature TConLvgMin(displayUnit="degC") =
    15 + 273.15
    "Minimum value for condenser leaving temperature"
    annotation (Dialog(group="Condenser"));
  parameter Modelica.Units.SI.Temperature TEvaLvgMin(displayUnit="degC") =
    4 + 273.15
    "Minimum value for leaving evaporator temperature"
    annotation (Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.Temperature TEvaLvgMax(displayUnit="degC") =
    15 + 273.15
    "Maximum value for leaving evaporator temperature"
    annotation (Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal =
      QHeaDes_flow_nominal/dTCon_nominal/cpWat
    "Nominal medium flow rate in the condenser"
    annotation (Dialog(group="Condenser"));
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal =
    abs(QCooDes_flow_nominal/dTEva_nominal)/cpWat
    "Nominal medium flow rate in the evaporator"
    annotation (Dialog(group="Evaporator"));

  final parameter Modelica.Units.SI.HeatFlowRate QConHeaNoSca_flow_nominal =
    Modelica.Blocks.Tables.Internal.getTable2DValue(
       tableID=tableID_QCon_flow,
       u1=THeaConLvg_nominal,
       u2=THeaEvaLvg_nominal)
      "Heating capacity based on table at heating design condition, without any scaling";

  final parameter Real scaFac = QHeaDes_flow_nominal / QConHeaNoSca_flow_nominal
     "Scaling factor at heating design conditions";

  final parameter Modelica.Units.SI.Power PEleCooNoSca_nominal =
    Modelica.Blocks.Tables.Internal.getTable2DValue(
      tableID=tableID_PEle,
      u1=TCooConLvg_nominal,
      u2=TCooEvaLvg_nominal)
     "Electricity use at cooling design conditions based on table, without any scaling";

  final parameter Modelica.Units.SI.HeatFlowRate QConCooNoSca_flow_nominal =
    Modelica.Blocks.Tables.Internal.getTable2DValue(
      tableID=tableID_QCon_flow,
      u1=TCooConLvg_nominal,
      u2=TCooEvaLvg_nominal)
      "Heating capacity based on table at cooling design condition, without any scaling";

  final parameter Modelica.Units.SI.HeatFlowRate QEvaCooNoSca_flow_nominal = -(QConCooNoSca_flow_nominal - PEleCooNoSca_nominal)
      "Cooling capacity based on table at cooling design condition, without any scaling";

  final parameter Modelica.Units.SI.HeatFlowRate QCooAct_flow_nominal = scaFac * QEvaCooNoSca_flow_nominal
      "Actual cooling capacity at cooling design condition, taking into account scaling";

  final parameter Real COPHea_nominal(final min=1, final unit="1") =
     QConHeaNoSca_flow_nominal / Modelica.Blocks.Tables.Internal.getTable2DValue(
       tableID=tableID_PEle,
       u1=THeaConLvg_nominal,
       u2=THeaEvaLvg_nominal) "COP heating, at heating design conditions";
  final parameter Real COPCoo_nominal(final min=0, final unit="1") =
     -QEvaCooNoSca_flow_nominal / PEleCooNoSca_nominal "COP cooling, at cooling design conditions";

  final parameter Modelica.Blocks.Types.ExternalCombiTable2D tableID_QCon_flow=
      Modelica.Blocks.Types.ExternalCombiTable2D(
      "NoName",
      "NoName",
      datHea.tabQCon_flow,
      Modelica.Blocks.Types.Smoothness.LinearSegments,
      Modelica.Blocks.Types.Extrapolation.LastTwoPoints,
      false) "External table object" annotation (HideResult=true);
   final parameter Modelica.Blocks.Types.ExternalCombiTable2D tableID_PEle=
      Modelica.Blocks.Types.ExternalCombiTable2D(
        "NoName",
        "NoName",
        datHea.tabPEle,
        Modelica.Blocks.Types.Smoothness.LinearSegments,
        Modelica.Blocks.Types.Extrapolation.LastTwoPoints,
        false) "External table object" annotation (HideResult=true);
annotation(defaultComponentName="datHeaPum",
defaultComponentPrefixes="parameter");

end HeatPump;
