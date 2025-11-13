within Buildings.DHC.ETS.Combined.Data;
record HeatPump
  "Parameters for the modular expandable heat pump in energy transfer station"
  extends Modelica.Icons.Record;
  constant Modelica.Units.SI.SpecificHeatCapacity cpWat =
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq;

  parameter Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump dat
    = Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.WAMAK_WaterToWater_220kW()
    "Performance map for the heat pump"
    annotation (Dialog(group="Performance map"));
  final parameter Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic datCoo
    = Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.EN14511.Carrier30XWP1012_1MW()
    "Not used - placeholder performance map for the cooling mode, has no influence"
    annotation (Dialog(group="Performance map"));

  parameter Real PLRMax(
    min=0, max=1, final unit="1") = 1 "Maximum part load ratio"
    annotation (Dialog(group="Part load"));
  parameter Real PLRMin(
   min=0, max=1, final unit="1")= 0.3 "Minimum part load ratio"
    annotation (Dialog(group="Part load"));

  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)
    "Nominal heating capacity"
    annotation (Dialog(group="Condenser"));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(
    max=-Modelica.Constants.eps)
    "Nominal cooling capacity"
    annotation (Dialog(group="Evaporator"));
  // fixme: verify that all data are indeed used by the model, and delete what is not used.
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal(
    min=Modelica.Constants.eps)
    "Nominal temperature difference in condenser medium (positive)"
    annotation (Dialog(group="Condenser"));
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal(
    min=Modelica.Constants.eps)
    "Nominal temperature difference in evaporator medium (positive)"
    annotation (Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.TemperatureDifference TConLvg_nominal(
     displayUnit="degC") "Nominal condenser leaving temperature"
    annotation (Dialog(group="Condenser"));
  parameter Modelica.Units.SI.TemperatureDifference TEvaLvg_nominal(
     displayUnit="degC") "Nominal evaporator leaving temperature"
    annotation (Dialog(group="Evaporator"));
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
    QHea_flow_nominal/dTCon_nominal/cpWat
    "Nominal medium flow rate in the condenser"
    annotation (Dialog(group="Condenser"));
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal =
    abs(QCoo_flow_nominal/dTEva_nominal)/cpWat
    "Nominal medium flow rate in the evaporator"
    annotation (Dialog(group="Evaporator"));

annotation(defaultComponentName="datHeaPum",
defaultComponentPrefixes="parameter");
end HeatPump;
