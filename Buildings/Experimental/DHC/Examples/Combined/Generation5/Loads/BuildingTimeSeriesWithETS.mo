within Buildings.Experimental.DHC.Examples.Combined.Generation5.Loads;
model BuildingTimeSeriesWithETS
  "Model of a building with loads provided as time series, connected to an ETS"
  extends BaseClasses.PartialBuildingWithETS(
    redeclare DHC.Loads.Examples.BaseClasses.BuildingTimeSeries bui(
      final filNam=filNam,
      have_hotWat=true,
      T_aHeaWat_nominal=ets.THeaWatSup_nominal,
      T_bHeaWat_nominal=ets.THeaWatRet_nominal,
      T_aChiWat_nominal=ets.TChiWatSup_nominal,
      T_bChiWat_nominal=ets.TChiWatRet_nominal,
      facMulHea=10*QHea_flow_nominal/(1.7E5),
      facMulCoo=40*QCoo_flow_nominal/(-1.5E5)),
    ets(
      have_hotWat=true,
      QChiWat_flow_nominal=QCoo_flow_nominal,
      QHeaWat_flow_nominal=QHea_flow_nominal,
      QHotWat_flow_nominal=QHot_flow_nominal));
  parameter String filNam
    "Library path of the file with thermal loads as time series";
  final parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(
    max=-Modelica.Constants.eps)=bui.facMul * bui.QCoo_flow_nominal
    "Space cooling design load (<=0)"
    annotation (Dialog(group="Design parameter"));
  final parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)=bui.facMul * bui.QHea_flow_nominal
    "Space heating design load (>=0)"
    annotation (Dialog(group="Design parameter"));
  final parameter Modelica.SIunits.HeatFlowRate QHot_flow_nominal(
    min=Modelica.Constants.eps)=bui.facMul *
    DHC.Loads.BaseClasses.getPeakLoad(
      string="#Peak water heating load",
      filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Hot water design load (>=0)"
    annotation (Dialog(group="Design parameter"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Service hot water supply temperature set point"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,40}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,30})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TColWat(
    final unit="K",
    displayUnit="degC")
    "Cold water temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,0}),   iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-80,-120})));
  Controls.OBC.CDL.Continuous.Gain loaHeaNor(k=1/bui.QHea_flow_nominal)
    "Normalized heating load"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold enaHeaCoo[2](each t=1e-4)
    "Threshold comparison to enable heating and cooling"
    annotation (Placement(transformation(extent={{-110,-130},{-90,-110}})));
  Modelica.Blocks.Sources.BooleanConstant enaSHW(
    final k=true) if have_hotWat
    "SHW production enable signal"
    annotation (Placement(transformation(extent={{0,-130},{-20,-110}})));
  Controls.OBC.CDL.Continuous.Gain loaCooNor(k=1/bui.QCoo_flow_nominal)
    "Normalized cooling load"
    annotation (Placement(transformation(extent={{-200,-150},{-180,-130}})));
equation
  connect(bui.QReqHotWat_flow, ets.loaSHW) annotation (Line(points={{28,4},{28,
          -10},{-64,-10},{-64,-74},{-34,-74}},
                                             color={0,0,127}));
  connect(THotWatSupSet, ets.THotWatSupSet) annotation (Line(points={{-320,40},
          {-136,40},{-136,-66},{-34,-66}},  color={0,0,127}));
  connect(TColWat, ets.TColWat) annotation (Line(points={{-320,0},{-148,0},{
          -148,-70},{-34,-70}},  color={0,0,127}));
  connect(enaHeaCoo[1].y, ets.uHea) annotation (Line(points={{-88,-120},{-40,
          -120},{-40,-46},{-34,-46}},
                                color={255,0,255}));
  connect(enaHeaCoo[2].y, ets.uCoo) annotation (Line(points={{-88,-120},{-40,
          -120},{-40,-50},{-34,-50}},
                                color={255,0,255}));
  connect(enaSHW.y, ets.uSHW) annotation (Line(points={{-21,-120},{-38,-120},{-38,
          -54},{-34,-54}}, color={255,0,255}));
  connect(loaHeaNor.y, enaHeaCoo[1].u) annotation (Line(points={{-178,-100},{
          -120,-100},{-120,-120},{-112,-120}},
                                         color={0,0,127}));
  connect(loaCooNor.y, enaHeaCoo[2].u) annotation (Line(points={{-178,-140},{
          -120,-140},{-120,-120},{-112,-120}},
                                         color={0,0,127}));
  connect(bui.QReqHea_flow, loaHeaNor.u) annotation (Line(points={{20,4},{20,-6},
          {-218,-6},{-218,-100},{-202,-100}}, color={0,0,127}));
  connect(bui.QReqCoo_flow, loaCooNor.u) annotation (Line(points={{24,4},{24,-4},
          {-220,-4},{-220,-140},{-202,-140}}, color={0,0,127}));
  connect(loaHeaNor.y, resTHeaWatSup.u) annotation (Line(points={{-178,-100},{
          -120,-100},{-120,-40},{-112,-40}},                  color={0,0,127}));
  annotation (Line(
      points={{-1,100},{0.1,100},{0.1,71.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right),
    Documentation(info="<html>
<p>
This model is composed of a heat pump based energy transfer station model 
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.HeatPumpHeatExchanger\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.HeatPumpHeatExchanger</a>
connected to a simplified building model where the space heating, cooling 
and hot water loads are provided as time series.
</p>
</html>", revisions="<html>
<ul>
<li>
February 23, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-300,-300},{
            300,300}})));
end BuildingTimeSeriesWithETS;
