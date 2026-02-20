within Buildings.DHC.Examples.Combined.ETSHeatRecoveryHeatPump_BuildingTimeSeries.BaseClasses;
model BuildingETS
  "Load connected to the network via ETS with or without DHW integration"
  extends Buildings.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS(
    redeclare Buildings.DHC.Examples.Combined.ETSHeatRecoveryHeatPump_BuildingTimeSeries.BaseClasses.BuildingTimeSeries bui(
      final filNam=filNam,
      final T_aHeaWat_nominal=datBuiSet.THeaWatSup_nominal,
      final T_bHeaWat_nominal=datBuiSet.THeaWatRet_nominal,
      final T_aChiWat_nominal=datBuiSet.TChiWatSup_nominal,
      final T_bChiWat_nominal=datBuiSet.TChiWatRet_nominal,
      final have_hotWat=have_hotWat,
      QHea_flow_nominal=facTerUniSizHea*Buildings.DHC.Loads.BaseClasses.getPeakLoad(
        string="#Peak space heating load",
        filNam=Modelica.Utilities.Files.loadResource(filNam))),
    redeclare Buildings.DHC.ETS.Combined.HeatRecoveryHeatPump ets(
      final have_hotWat=QHotWat_flow_nominal > Modelica.Constants.eps,
      QChiWat_flow_nominal=QCoo_flow_nominal,
      QHeaWat_flow_nominal=QHea_flow_nominal,
      QHotWat_flow_nominal=QHot_flow_nominal,
      dp1Hex_nominal=40E3,
      dp2Hex_nominal=40E3,
      QHex_flow_nominal=max(abs(QCoo_flow_nominal),QHea_flow_nominal),
      T_a1Hex_nominal=283.65,
      T_b1Hex_nominal=279.65,
      T_a2Hex_nominal=276.65,
      T_b2Hex_nominal=282.65,
      QWSE_flow_nominal=QCoo_flow_nominal,
      VTanHeaWat=datHeaPum.mCon_flow_nominal*datBuiSet.dTHeaWat_nominal*5*60/
          1000,
      VTanChiWat=datHeaPum.mEva_flow_nominal*datBuiSet.dTChiWat_nominal*5*60/
          1000,
      have_WSE=false,
      dpCon_nominal=40E3,
      dpEva_nominal=40E3,
      datDhw=datDhw,
      TCon_start=if have_hotWat then min(datBuiSet.THeaWatSup_nominal,
          datBuiSet.THotWatSupTan_nominal) else datBuiSet.THeaWatSup_nominal,
      TEva_start=datBuiSet.TChiWatSup_nominal,
      datHeaPum=datHeaPum),
    nPorts_heaWat=1,
    nPorts_chiWat=1);

  parameter Boolean have_eleNonHva
    "Set to true to enable a data reader and output signal for non-HVAC electrical load"
    annotation (Dialog(group="Configuration"));

  parameter Real facTerUniSizHea(final unit="1")
    "Factor to increase design capacity of space terminal units for heating";
  parameter String filNam "File name for the load profile";

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

  parameter Buildings.DHC.Examples.Combined.ETSHeatRecoveryHeatPump_BuildingTimeSeries.Data.HVAC datBuiSet
    "Building set points" annotation (Placement(
      transformation(extent={{20,140},{40,160}})));
  parameter Buildings.DHC.ETS.Combined.Data.WAMAK_220kW datHeaPum(
    PLRMin=0.2/3 "20%, and assume 3 chillers in parallel",
    QHeaDes_flow_nominal=max(QHea_flow_nominal, abs(QCoo_flow_nominal)*1.2),
    QCooDes_flow_nominal=QCoo_flow_nominal,
    final dTCon_nominal=datBuiSet.dTHeaWat_nominal,
    final dTEva_nominal=datBuiSet.dTChiWat_nominal,
    THeaConLvg_nominal=max(datBuiSet.THeaWatSup_nominal, datBuiSet.THotWatSupTan_nominal),
    THeaEvaLvg_nominal=273.15 + 3.5,
    TCooConLvg_nominal=273.15 + 31,
    TCooEvaLvg_nominal=datBuiSet.TChiWatSup_nominal)
    "Heat recovery heat pump parameters"
    annotation (Placement(transformation(extent={{20,180},{40,200}})));

  final parameter Modelica.Units.SI.Temperature TChiWatRet_nominal=
      datBuiSet.TChiWatRet_nominal "Chilled water return temperature from building load"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.Temperature THeaWatRet_nominal=
      datBuiSet.THeaWatRet_nominal "Heating water return temperature from building load"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(min=0) = 4
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal =
    datBuiSet.TChiWatSup_nominal "Chilled water supply temperature to building load"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal =
    datBuiSet.THeaWatSup_nominal "Heating water supply temperature to building load"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature THotWatSup_nominal =
    datBuiSet.THotWatSupFix_nominal "Domestic hot water supply temperature to fixtures"
    annotation (Dialog(group="ETS model parameters", enable=have_hotWat));

  parameter Buildings.DHC.Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger datDhw(
      VTan=datHeaPum.mCon_flow_nominal*datBuiSet.dTHeaWat_nominal*5*60/1000,
      mDom_flow_nominal=datDhw.QHex_flow_nominal/4200/(datDhw.TDom_nominal-datDhw.TCol_nominal),
      QHex_flow_nominal=if have_hotWat then QHotWat_flow_nominal else
        QHeaWat_flow_nominal,
    TDom_nominal=datBuiSet.THotWatSupTan_nominal)
    "Performance data of the domestic hot water component"
    annotation (Placement(transformation(extent={{20,222},{40,242}})));
  parameter Modelica.Units.SI.HeatFlowRate QHot_flow_nominal(
    min=0)=Buildings.DHC.Loads.BaseClasses.getPeakLoad(
          string="#Peak water heating load",
          filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Design parameter"));

  // Replaceable sources for set points and for fresh water supply
  replaceable Buildings.Controls.SetPoints.Table THeaWatSupSet(
    final table=datBuiSet.tabHeaWatRes,
    final offset=0,
    final constantExtrapolation=true)
    constrainedby Modelica.Blocks.Interfaces.SISO(
      y(final unit="K", displayUnit="degC"))
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  replaceable Buildings.Controls.SetPoints.Table TChiWatSupSet(
    final table=datBuiSet.tabChiWatRes,
    final offset=0,
    final constantExtrapolation=true)
    constrainedby Modelica.Blocks.Interfaces.SISO(
      y(final unit="K", displayUnit="degC"))
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

  replaceable Buildings.Controls.OBC.CDL.Reals.Sources.Constant THotWatSupSet(
    final k(final unit="K", displayUnit="degC")=datBuiSet.THotWatSupFix_nominal)
    if have_hotWat
    constrainedby Modelica.Blocks.Interfaces.SO(y(final unit="K", displayUnit="degC"))
    "Domestic hot water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  replaceable Buildings.Controls.OBC.CDL.Reals.Sources.Constant TColWat(
    final k(final unit="K", displayUnit="degC")=288.15)
    if have_hotWat
    constrainedby Modelica.Blocks.Interfaces.SO(y(final unit="K", displayUnit="degC"))
    "Domestic cold water temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));

  // Output connectors for main energy use
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEleNonHva(final unit="W")
    if have_eleNonHva
    "Power drawn by non-HVAC electricity load" annotation (
      Placement(transformation(extent={{300,-20},{340,20}}), iconTransformation(
          extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dHHeaWat_flow(final unit="W")
    "Heating water distributed energy flow rate"
    annotation (Placement(transformation(extent={{300,-140},{340,-100}}),
      iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dHChiWat_flow(final unit="W")
    "Chilled water distributed energy flow rate"
    annotation (Placement(transformation(extent={{300,-100},{340,-60}}),
      iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-20,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dHHotWat_flow(final unit="W")
    if have_hotWat
    "Domestic hot water distributed energy flow rate" annotation (Placement(
        transformation(extent={{300,-180},{340,-140}}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-60,-120})));

  Modelica.Blocks.Sources.CombiTimeTable loaEleNonHva(
    final tableOnFile=true,
    tableName="tab1",
    final fileName=Modelica.Utilities.Files.loadResource(filNam),
    extrapolation=bui.loa.extrapolation,
    y(each unit="W"),
    timeScale=bui.loa.timeScale,
    offset={0},
    columns={5},
    smoothness=bui.loa.smoothness) if have_eleNonHva
    "Reader for non-HVAC electricity load"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulPEleNonHva(
    u(final unit="W"),
    final k=facMul) if have_eleNonHva "Scaling"
    annotation (Placement(transformation(extent={{270,-10},{290,10}})));
equation
  connect(ets.QReqHotWat_flow, bui.QReqHotWat_flow) annotation (Line(points={{-34,-54},
          {-40,-54},{-40,-120},{84,-120},{84,-2},{28,-2},{28,4}},      color={0,
          0,127}));
  connect(ets.THotWatSupSet, THotWatSupSet.y) annotation (Line(points={{-34,-46},
          {-72,-46},{-72,-10},{-118,-10}},
                                       color={0,0,127}));
  connect(TColWat.y, ets.TColWat) annotation (Line(points={{-118,-50},{-76,-50},
          {-76,-50},{-34,-50}}, color={0,0,127}));
  connect(ets.dHChiWat_flow, dHChiWat_flow) annotation (Line(points={{28,-90},{
          28,-100},{280,-100},{280,-80},{320,-80}}, color={0,0,127}));
  connect(dHHeaWat_flow, ets.dHHeaWat_flow) annotation (Line(points={{320,-120},
          {280,-120},{280,-106},{24,-106},{24,-90}}, color={0,0,127}));
  connect(ets.dHHotWat_flow, dHHotWat_flow) annotation (Line(points={{20,-90},{
          20,-112},{276,-112},{276,-160},{320,-160}}, color={0,0,127}));
  connect(THeaWatSupSet.y, ets.THeaWatSupSet) annotation (Line(points={{-119,70},
          {-64,70},{-64,-58},{-34,-58}}, color={0,0,127}));
  connect(weaBus.TDryBul, THeaWatSupSet.u) annotation (Line(
      points={{0.1,280.1},{-152,280.1},{-152,70},{-142,70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TChiWatSupSet.y, ets.TChiWatSupSet) annotation (Line(points={{-119,30},
          {-68,30},{-68,-62},{-34,-62}}, color={0,0,127}));
  connect(weaBus.TDryBul, TChiWatSupSet.u) annotation (Line(
      points={{0.1,280.1},{-152,280.1},{-152,30},{-142,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(mulPEleNonHva.y, PEleNonHva)
    annotation (Line(points={{292,0},{320,0}}, color={0,0,127}));
  connect(loaEleNonHva.y[1], mulPEleNonHva.u)
    annotation (Line(points={{181,0},{268,0}}, color={0,0,127}));
  connect(bui.THeaSupSet, THeaWatSupSet.y) annotation (Line(points={{-32,58},{-64,
          58},{-64,70},{-119,70}}, color={0,0,127}));
  connect(TChiWatSupSet.y, bui.TCooSupSet) annotation (Line(points={{-119,30},{-68,
          30},{-68,48},{-32,48}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        defaultComponentName = "bui",
    Documentation(info="<html>
<p>
Model that connects a building thermal and cooling load, specified by time series,
with an energy transfer station, and exposes the fluid connections of the energy transfer
station for connecting it to district energy service lines.
</p>
<p>
The model extends from
<a href=\"modelica://Buildings.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS\">
Buildings.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS</a>,
which connects the building and the load, and exposes the fluid connection for connecting
it to the district service line.
The building load is modeled by reading time series, and drawing as much heating or cooling
water as determined by its control. This is implemented through
<a href=\"modelica://Buildings.DHC.Examples.Combined.ETSHeatRecoveryHeatPump_BuildingTimeSeries.BaseClasses.BuildingTimeSeries\">
Buildings.DHC.Examples.Combined.ETSHeatRecoveryHeatPump_BuildingTimeSeries.BaseClasses.BuildingTimeSeries</a>.
The energy transfer station uses a heat recovery heat pump, and can optionally have domestic hot water
preparation.
This is implemented in
<a href=\"modelica://Buildings.DHC.ETS.Combined.HeatRecoveryHeatPump\">
Buildings.DHC.ETS.Combined.HeatRecoveryHeatPump</a>.
</p>
<p>
See the respective models for a detailed description.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 14, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BuildingETS;
