within Buildings.DHC.ETS.Combined.Examples.BuildingTimeSeries.BaseClasses;
model BuildingETS
  "Load connected to the network via ETS with or without DHW integration"
  extends Buildings.DHC.ETS.Combined.Examples.BuildingTimeSeries.BaseClasses.PartialBuildingETS(
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
      datHeaPum=datHeaPum));

  parameter Boolean have_eleNonHva "The ETS has non-HVAC electricity load"
    annotation (Dialog(group="Configuration"));

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

  Buildings.Controls.SetPoints.Table THeaWatSupSet(
    final table=datBuiSet.tabHeaWatRes,
    final offset=0,
    final constantExtrapolation=true,
    y(final unit="K", displayUnit="degC"))
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Buildings.Controls.SetPoints.Table TChiWatSupSet(
    final table=datBuiSet.tabChiWatRes,
    final offset=0,
    final constantExtrapolation=true,
    y(final unit="K", displayUnit="degC"))
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THotWatSupSet(
    final k=datBuiSet.THotWatSupFix_nominal,
    y(final unit="K", displayUnit="degC")) if have_hotWat
    "Domestic hot water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TColWat(
    final k=datBuiSet.TColWat_nominal,
    y(final unit="K", displayUnit="degC")) if have_hotWat
    "Domestic cold water temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
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
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEleNonHva(final unit="W")
    if have_eleNonHva
    "Power drawn by non-HVAC electricity load" annotation (
      Placement(transformation(extent={{300,-20},{340,20}}), iconTransformation(
          extent={{100,-40},{140,0}})));
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
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        defaultComponentName = "bui");
end BuildingETS;
