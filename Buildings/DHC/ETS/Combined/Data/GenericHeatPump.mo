within Buildings.DHC.ETS.Combined.Data;
record GenericHeatPump
  "Parameters for the heat recovery heat pump in energy transfer station"
  extends Modelica.Icons.Record;

  parameter Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump datHea
    "Performance map for the heat pump without scaling. This map will be scaled based on QHeaDes_flow_nominal using scaFac."
    annotation (Dialog(group="Performance map"));

  final parameter Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump datHeaSca(
    final use_TEvaOutForOpeEnv=datHea.use_TEvaOutForOpeEnv,
    final use_TConOutForOpeEnv=datHea.use_TConOutForOpeEnv,
    final dpEva_nominal=datHea.dpEva_nominal,
    final dpCon_nominal=datHea.dpCon_nominal,
    final tabUppBou=datHea.tabUppBou,
    final mEva_flow_nominal=datHea.mEva_flow_nominal,
    final mCon_flow_nominal=datHea.mCon_flow_nominal,
    final tabPEle=scalePerformanceTable(
      x=datHea.tabPEle,
      nR = size(datHea.tabPEle, 1),
      nC = size(datHea.tabPEle, 2),
      s=scaFac),
    final tabQCon_flow=scalePerformanceTable(
      x=datHea.tabQCon_flow,
      nR = size(datHea.tabQCon_flow, 1),
      nC = size(datHea.tabQCon_flow, 2),
      s=scaFac),
    final devIde=datHea.devIde,
    final use_TConOutForTab=datHea.use_TConOutForTab,
    final use_TEvaOutForTab=datHea.use_TEvaOutForTab)
    "Performance map for the heat pump with scaling. This map determines the actual capacity based on QHeaDes_flow_nominal."
    annotation (Dialog(group="Performance map"));

  parameter Real PLRMin(
   min=0, max=1, final unit="1")= 0.3 "Minimum part load ratio"
    annotation (Dialog(group="Part load"));

  parameter Modelica.Units.SI.HeatFlowRate QHeaDes_flow_nominal(min=Modelica.Constants.eps)
    "Desired design heating capacity"
    annotation (Dialog(group="Heating design condition"));

  parameter Modelica.Units.SI.HeatFlowRate QCooDes_flow_nominal(max=-Modelica.Constants.eps)
    "Desired design cooling capacity"
    annotation (Dialog(group="Cooling design condition"));

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

   parameter Modelica.Units.SI.Temperature TConLvgMin(displayUnit="degC") =
     15 + 273.15
     "Minimum value for condenser leaving temperature"
     annotation (Dialog(group="Condenser"));
  parameter Modelica.Units.SI.Temperature TEvaLvgMax(displayUnit="degC") =
    15 + 273.15
    "Maximum value for leaving evaporator temperature"
    annotation (Dialog(group="Evaporator"));

  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal =
      QHeaDes_flow_nominal/dTCon_nominal/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Nominal medium flow rate in the condenser"
    annotation (Dialog(group="Condenser"));

  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal =
    max(abs(QCooDes_flow_nominal/dTEva_nominal), abs(QCooAct_flow_nominal/dTEva_nominal))/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Nominal medium flow rate in the evaporator, based on larger of required and actual cooling capacity to ensure actual dTEva is not too large"
    annotation (Dialog(group="Evaporator"));

  final parameter Modelica.Units.SI.HeatFlowRate QConHeaNoSca_flow_nominal =
    Modelica.Blocks.Tables.Internal.getTable2DValue(
       tableID=tableID_QCon_flow,
       u1=THeaConLvg_nominal,
       u2=THeaEvaLvg_nominal)
      "Heating capacity based on table at heating design condition, without any scaling"
      annotation(Evaluate=true);

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
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Parameters that describe the performance of the heat pump, and design quantities
such as temperatures and design mass flow rates of the heat pump.
</p>
<p>
The performance table in <code>datHea</code> are used to describe the
change in performance for off-design conditions.
The heat pump's heating capacity is, however,
determined solely by the parameters
<code>QHeaDes_flow_nominal</code> for the desired heating capacity at the
leaving condenser temperature <code>THeaConLvg_nominal</code> and the
leaving evaporator temperature <code>THeaEvaLvg_nominal</code>.
The performance table for the evaporator heat flow rate and the electricity
consumption are then scaled up or down to meet this capacity.
This scaled capacity is stored in <code>datHeaSca</code>, and used during the simulation.
</p>
<p>
The record also computes the cooling capacity at the design conditions
<code>TCooConLvg_nominal</code> and <code>TCooEvaLvg_nominal</code>,
and stores it in the parameter <code>QCooAct_flow_nominal</code>.
This can then be compared to the desired cooling capacity
<code>QCooDes_flow_nominal</code>.
</p>
<p>
The model also computes the COP for heating and for cooling at the
design temperatures <code>THeaConLvg_nominal</code> and <code>THeaEvaLvg_nominal</code>
for heating and
<code>TCooConLvg_nominal</code> and <code>TCooEvaLvg_nominal</code>
for cooling. These are for reporting only and not used in the heat pump model.
</p>
</html>", revisions="<html>
<ul>
<li>
November 14, 2025, by Michael Wetter:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4354\">#4354</a>.
</li>
</ul>
</html>"));

end GenericHeatPump;
