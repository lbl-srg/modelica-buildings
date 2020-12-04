within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Loads;
model BuildingTimeSeriesWithETS
  "Model of a building with thermal loads as time series, with an energy transfer station"
  extends BaseClasses.PartialBuildingWithETS(
    redeclare DHC.Loads.Examples.BaseClasses.BuildingTimeSeries bui(
      final filNam=filNam,
      have_hotWat=true),
    ets(
      have_hotWat=true,
      QChiWat_flow_nominal=QCoo_flow_nominal,
      QHeaWat_flow_nominal=QHea_flow_nominal,
      QHotWat_flow_nominal=QHot_flow_nominal));
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(
    max=-Modelica.Constants.eps)=DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space cooling load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Space cooling design load (<=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)=DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space heating load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Space heating design load (>=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.SIunits.HeatFlowRate QHot_flow_nominal(
    min=Modelica.Constants.eps)=DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak water heating load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Hot water design load (>=0)"
    annotation (Dialog(group="Design parameter"));
  parameter String filNam
    "Library path of the file with thermal loads as time series";
  Modelica.Blocks.Interfaces.RealInput THotWatSupSet
    "Service hot water supply temperature set point" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-160,-40}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-40})));
  Modelica.Blocks.Interfaces.RealInput TColWat "Cold water temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-160,-80}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-80})));
equation
  connect(bui.QReqHotWat_flow, ets.loaSHW) annotation (Line(points={{14,6},{14,-4},
          {-64,-4},{-64,-70},{-34,-70}},     color={0,0,127}));
  connect(THotWatSupSet, ets.THotWatSupSet) annotation (Line(points={{-160,-40},
          {-100,-40},{-100,-58},{-34,-58}}, color={0,0,127}));
  connect(TColWat, ets.TColWat) annotation (Line(points={{-160,-80},{-130,-80},{
          -130,-64},{-34,-64}},  color={0,0,127}));
  annotation (Line(
      points={{-1,100},{0.1,100},{0.1,71.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
end BuildingTimeSeriesWithETS;
