within Buildings.Templates.HeatingPlants.HotWater.Components.Controls;
block OpenLoop
  extends
    Buildings.Templates.HeatingPlants.HotWater.Components.Interfaces.PartialController(
    final typ=Buildings.Templates.HeatingPlants.HotWater.Types.Controller.OpenLoop);

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1BoiCon[nBoiCon](
    each table=[0,0; 1,1; 2,0],
    each timeScale=1000,
    each period=2000) "Boiler Enable signal - Condensing Boilers"
    annotation (Placement(transformation(extent={{-120,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatConSupSet(
    y(final unit="K", displayUnit="degC"),
    k=Buildings.Templates.Data.Defaults.THeaWatConSup)
    "HW supply temperature set point - Condensing Boilers"
    annotation (Placement(transformation(extent={{-120,210},{-140,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValBoiConIso[nBoiCon](
    table=y1BoiCon.table,
    timeScale=y1BoiCon.timeScale,
    period=y1BoiCon.period)
    "Boiler isolation valve opening signal - Condensing Boilers"
    annotation (Placement(transformation(extent={{-120,110},{-140,130}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1BoiNon[nBoiNon](
    each table=[0,0; 1,1; 2,0],
    each timeScale=1000,
    each period=2000) "Boiler Enable signal - Non-condensing Boilers"
    annotation (Placement(transformation(extent={{-120,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatNonSupSet(
    y(final unit="K", displayUnit="degC"),
    k=Buildings.Templates.Data.Defaults.THeaWatSup)
    "HW supply temperature set point - Non-condensing Boilers"
    annotation (Placement(transformation(extent={{-120,210},{-140,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValBoiNonIso[nBoiNon](
    table=y1BoiNon.table,
    timeScale=y1BoiNon.timeScale,
    period=y1BoiNon.period)
    "Boiler isolation valve opening signal - Non-condensing Boilers"
    annotation (Placement(transformation(extent={{-120,110},{-140,130}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumHeaWatPriCon[
    nPumHeaWatPriCon](
    table=y1BoiCon.table,
    timeScale=y1BoiCon.timeScale,
    period=y1BoiCon.period) if have_boiCon
    "Primary HW pump Enable signal - Condensing Boilers"
    annotation (Placement(transformation(extent={{-120,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumHeaWatPriCon(
    y(final unit="1"), k=1)
    "Primary HW pump speed signal - Condensing Boilers"
    annotation (Placement(transformation(extent={{-120,30},{-140,50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumHeaWatPriNon[
    nPumHeaWatPriNon](
    table=y1BoiNon.table,
    timeScale=y1BoiNon.timeScale,
    period=y1BoiNon.period) if have_boiNon
    "Primary HW pump Enable signal - Non-condensing Boilers"
    annotation (Placement(transformation(extent={{-120,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumHeaWatPriNon(
    y(final unit="1"), k=1) if have_boiNon
    "Primary HW pump speed signal - Non-condensing Boilers"
    annotation (Placement(transformation(extent={{-120,30},{-140,50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumHeaWatSec[
    nPumHeaWatPriCon](
    table=y1BoiCon.table,
    timeScale=y1BoiCon.timeScale,
    period=y1BoiCon.period)
    if typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized
    "Secondary HW pump Enable signal"
    annotation (Placement(transformation(extent={{-120,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumHeaWatSec(
    y(final unit="1"), k=1)
    if typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized
    "Secondary HW pump speed signal"
    annotation (Placement(transformation(extent={{-120,30},{-140,50}})));


equation
  connect(y1BoiCon.y[1], bus.y1BoiCon)
    annotation (Line(points={{-142,180},{-200,180},
          {-200,0},{-260,0}}, color={255,0,255}));
  connect(THeaWatSupSet.y, bus.THeaWatConSupSet)
    annotation (Line(points={{-142,220},{-192,220},{-192,0},{-260,0}}, color={0,0,127}));
  connect(y1PumHeaWatPriCon.y[1], busPumHeaWatPriCon.y1)
    annotation (Line(points={{-142,80},{-240,80},{-240,60}},color={255,0,255}));
  connect(yPumHeaWatPriCon.y, busPumHeaWatPriCon.y)
    annotation (Line(points={{-142,40},{-240,40},{-240,60}}, color={0,0,127}));
  connect(y1ValBoiIso.y[1], busValBoiConIso.y1) annotation (Line(points={{-142,120},
          {-240,120},{-240,100}}, color={255,0,255}));
  annotation (
  defaultComponentName="ctl",
  Icon(coordinateSystBuildings(Templates(HeatingPlants(HotWater(Components(
       BoilerGroupsem(                                                                    preserveAspectRatio=false))))))),
  Diagram(coordinateSystem(preserveAspectRatio=false)));
end OpenLoop;
