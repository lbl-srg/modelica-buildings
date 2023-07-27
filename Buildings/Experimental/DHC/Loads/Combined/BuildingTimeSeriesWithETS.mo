within Buildings.Experimental.DHC.Loads.Combined;
model BuildingTimeSeriesWithETS
  "Model of a building with loads provided as time series, connected to an ETS"
  extends Buildings.Experimental.DHC.Loads.Combined.BaseClasses.PartialBuildingWithETS(
    redeclare Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses.BuildingTimeSeries bui(
      final filNam=filNam,
      have_hotWat=true,
      T_aHeaWat_nominal=ets.THeaWatSup_nominal,
      T_bHeaWat_nominal=ets.THeaWatRet_nominal,
      T_aChiWat_nominal=ets.TChiWatSup_nominal,
      T_bChiWat_nominal=ets.TChiWatRet_nominal),
    ets(
      have_hotWat=true,
      QChiWat_flow_nominal=QCoo_flow_nominal,
      QHeaWat_flow_nominal=QHea_flow_nominal,
      QHotWat_flow_nominal=QHot_flow_nominal));
  parameter String filNam
    "Library path of the file with thermal loads as time series";
  final parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(
    max=-Modelica.Constants.eps)=
    bui.facMul * bui.QCoo_flow_nominal
    "Space cooling design load (<=0)"
    annotation (Dialog(group="Design parameter"));
  final parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)=
    bui.facMul * bui.QHea_flow_nominal
    "Space heating design load (>=0)"
    annotation (Dialog(group="Design parameter"));
  final parameter Modelica.Units.SI.HeatFlowRate QHot_flow_nominal(
    min=Modelica.Constants.eps)=
    bui.facMul * Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
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
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter loaHeaNor(
    k=1/QHea_flow_nominal) "Normalized heating load"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold enaHeaCoo[2](each t=1e-4)
    "Threshold comparison to enable heating and cooling"
    annotation (Placement(transformation(extent={{-110,-130},{-90,-110}})));
  Modelica.Blocks.Sources.BooleanConstant enaSHW(
    final k=true) if have_hotWat
    "SHW production enable signal"
    annotation (Placement(transformation(extent={{0,-130},{-20,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter loaCooNor(k=1/
        QCoo_flow_nominal) "Normalized cooling load"
    annotation (Placement(transformation(extent={{-200,-150},{-180,-130}})));
equation
  connect(bui.QReqHotWat_flow, ets.loaSHW) annotation (Line(points={{28,4},{28,
          -10},{-64,-10},{-64,-74},{-34,-74}}, color={0,0,127}));
  connect(THotWatSupSet, ets.THotWatSupSet) annotation (Line(points={{-320,40},
          {-136,40},{-136,-66},{-34,-66}},  color={0,0,127}));
  connect(TColWat, ets.TColWat) annotation (Line(points={{-320,0},{-148,0},{
          -148,-70},{-34,-70}},  color={0,0,127}));
  connect(enaHeaCoo[1].y, ets.uHea) annotation (Line(points={{-88,-120},{-40,
          -120},{-40,-46},{-34,-46}}, color={255,0,255}));
  connect(enaHeaCoo[2].y, ets.uCoo) annotation (Line(points={{-88,-120},{-40,
          -120},{-40,-50},{-34,-50}}, color={255,0,255}));
  connect(enaSHW.y, ets.uSHW) annotation (Line(points={{-21,-120},{-38,-120},{-38,
          -54},{-34,-54}}, color={255,0,255}));
  connect(loaHeaNor.y, enaHeaCoo[1].u) annotation (Line(points={{-178,-100},{
          -120,-100},{-120,-120},{-112,-120}}, color={0,0,127}));
  connect(loaCooNor.y, enaHeaCoo[2].u) annotation (Line(points={{-178,-140},{
          -120,-140},{-120,-120},{-112,-120}}, color={0,0,127}));
  connect(bui.QReqHea_flow, loaHeaNor.u) annotation (Line(points={{20,4},{20,-6},
          {-218,-6},{-218,-100},{-202,-100}}, color={0,0,127}));
  connect(bui.QReqCoo_flow, loaCooNor.u) annotation (Line(points={{24,4},{24,-4},
          {-220,-4},{-220,-140},{-202,-140}}, color={0,0,127}));
  connect(loaHeaNor.y, resTHeaWatSup.u) annotation (Line(points={{-178,-100},{
          -120,-100},{-120,-40},{-112,-40}},  color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
This model is composed of a heat pump based energy transfer station model
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.HeatPumpHeatExchanger_Current\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.HeatPumpHeatExchanger</a>
connected to a simplified building model where the space heating, cooling
and hot water loads are provided as time series.
</p>
<h4>Scaling</h4>
<p>
The parameter <code>bui.facMul</code> is the multiplier factor
applied to the building loads that are provided as time series.
It is used to represent multiple identical buildings served by
a unique energy transfer station.
The parameter <code>facMul</code> is the multiplier factor
applied to the whole system composed of the building(s) and the
energy transfer station.
It is used to represent multiple identical ETSs served by
the DHC system.
So, if for instance the overall heating and cooling efficiency is
equal to <i>1</i>, then the load on the district loop
is the load provided as time series multiplied by <i>facMul * bui.facMul</i>.
</p>
<p>
Note that the parameters <code>QCoo_flow_nominal</code>, <code>QHea_flow_nominal</code>
and <code>QHot_flow_nominal</code> are the <i>ETS</i> design values. They include
the building loads multiplier factor <code>bui.facMul</code> but not
the building and ETS multiplier factor <code>facMul</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 21, 2022, by David Blum:<br/>
Change <code>bui.facMulHea</code> and <code>bui.facMulCoo</code> to be default.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2302\">
issue 2302</a>.
</li>
<li>
February 23, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-300,-300},{
            300,300}})));
end BuildingTimeSeriesWithETS;
