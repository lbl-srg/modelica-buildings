within Buildings.DHC.ETS.Combined.Examples.BuildingTimeSeries.BaseClasses;
partial model PartialBuildingETS
  extends Buildings.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS(
    redeclare Buildings.DHC.Loads.BaseClasses.BuildingTimeSeries bui(
      final filNam=filNam,
      final T_aHeaWat_nominal=datBuiSet.THeaWatSup_nominal,
      final T_bHeaWat_nominal=datBuiSet.THeaWatRet_nominal,
      final T_aChiWat_nominal=datBuiSet.TChiWatSup_nominal,
      final T_bChiWat_nominal=datBuiSet.TChiWatRet_nominal,
      final have_hotWat=have_hotWat,
      QHea_flow_nominal=facTerUniSizHea*Buildings.DHC.Loads.BaseClasses.getPeakLoad(
          string="#Peak space heating load",
          filNam=Modelica.Utilities.Files.loadResource(filNam))),
    nPorts_heaWat=1,
    nPorts_chiWat=1);

  parameter Real facTerUniSizHea(final unit="1")
    "Factor to increase design capacity of space terminal units for heating";
  parameter String filNam "File name for the load profile";
  parameter Buildings.DHC.ETS.Combined.Data.BuildingSetPoints datBuiSet
    "Building set points" annotation (Placement(
      transformation(extent={{20,140},{40,160}})));
  parameter Buildings.DHC.ETS.Combined.Data.HeatPump datHeaPum(
    PLRMin=0.2/3 "20%, and assume 3 chillers in parallel",
    QHea_flow_nominal=max(QHea_flow_nominal, abs(QCoo_flow_nominal)*1.2),
    QCoo_flow_nominal=QCoo_flow_nominal,
    final dTCon_nominal=datBuiSet.dTHeaWat_nominal,
    final dTEva_nominal=datBuiSet.dTChiWat_nominal,
    final TConLvg_nominal=max(datBuiSet.THeaWatSup_nominal, datBuiSet.THotWatSupTan_nominal),
    final TEvaLvg_nominal=datBuiSet.TChiWatSup_nominal)
    "Heat recovery heat pump parameters"
    annotation (Placement(transformation(extent={{20,180},{40,200}})));

  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(
    max=-Modelica.Constants.eps)=
      Buildings.DHC.Loads.BaseClasses.getPeakLoad(
        string="#Peak space cooling load",
        filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design cooling heat flow rate (<=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)=
      Buildings.DHC.Loads.BaseClasses.getPeakLoad(
        string="#Peak space heating load",
        filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Design parameter"));
  final parameter Modelica.Units.SI.Temperature TChiWatRet_nominal=
      datBuiSet.TChiWatRet_nominal "Chilled water return temperature";
  final parameter Modelica.Units.SI.Temperature THeaWatRet_nominal=
      datBuiSet.THeaWatRet_nominal "Heating water return temperature";
  parameter Modelica.Units.SI.Temperature TDisWatMin=6 + 273.15
    "District water minimum temperature" annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Temperature TDisWatMax=17 + 273.15
    "District water maximum temperature" annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(min=0) = 4
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal =
    datBuiSet.TChiWatSup_nominal "Chilled water supply temperature"
    annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal =
    datBuiSet.THeaWatSup_nominal "Heating water supply temperature"
    annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Temperature THotWatSup_nominal =
    datBuiSet.THotWatSupFix_nominal "Domestic hot water supply temperature to fixtures"
    annotation (Dialog(group="ETS model parameters", enable=have_hotWat));
  parameter Modelica.Units.SI.Temperature TColWat_nominal =
    datBuiSet.TColWat_nominal
    "Cold water temperature (for hot water production)"
    annotation (Dialog(group="ETS model parameters", enable=have_hotWat));
  parameter Modelica.Units.SI.Pressure dp_nominal(displayUnit="Pa")=50000
    "Pressure difference at nominal flow rate (for each flow leg)"
    annotation (Dialog(group="ETS model parameters"));
  parameter Real COPHeaWat_nominal(final unit="1") = 4.0
    "COP of heat pump for heating water production"
    annotation (Dialog(group="ETS model parameters"));
  parameter Real COPHotWat_nominal(final unit="1") = 2.3
    "COP of heat pump for hot water production";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        defaultComponentName = "bui");
end PartialBuildingETS;
