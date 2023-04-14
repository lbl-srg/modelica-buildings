within Buildings.Templates.HeatingPlants.HotWater.Components.Controls;
block OpenLoop
  extends
    Buildings.Templates.HeatingPlants.HotWater.Components.Interfaces.PartialController(
    final typ=Buildings.Templates.HeatingPlants.HotWater.Types.Controller.OpenLoop);

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Con_default[nBoiCon](
    each table=[0,0; 1,1; 2,0],
    each timeScale=1000,
    each period=2000)
    "Default Enable signal for all condensing units"
    annotation (Placement(transformation(extent={{-140,270},{-120,290}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Non_default[nBoiNon](
    each table=[0,0; 1,1; 2,0],
    each timeScale=1000,
    each period=2000)
    "Default Enable signal for all non-condensing units"
    annotation (Placement(transformation(extent={{-80,270},{-60,290}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1BoiCon[nBoiCon](
    table=y1Con_default.table,
    timeScale=y1Con_default.timeScale,
    period=y1Con_default.period) if have_boiCon
    "Boiler Enable signal - Condensing Boilers"
    annotation (Placement(transformation(extent={{-120,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatConSupSet(
    y(final unit="K", displayUnit="degC"), final k=dat.THeaWatConSup_nominal)
    if have_boiCon
    "HW supply temperature set point - Condensing Boilers"
    annotation (Placement(transformation(extent={{-120,210},{-140,230}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep(
    final nout=nBoiCon)  if have_boiCon
    "Replicate signal"
    annotation (Placement(transformation(extent={{-150,210},{-170,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValBoiConIso[nBoiCon](
    table=y1Con_default.table,
    timeScale=y1Con_default.timeScale,
    period=y1Con_default.period) if have_boiCon
    "Boiler isolation valve opening signal - Condensing Boilers"
    annotation (Placement(transformation(extent={{-120,110},{-140,130}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1BoiNon[nBoiNon](
    table=y1Non_default.table,
    timeScale=y1Non_default.timeScale,
    period=y1Non_default.period) if have_boiNon
    "Boiler Enable signal - Non-condensing Boilers"
    annotation (Placement(transformation(extent={{-60,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(
    y(final unit="K", displayUnit="degC"), final k=dat.THeaWatSup_nominal)
    if have_boiNon
    "HW supply temperature set point"
    annotation (Placement(transformation(extent={{-60,190},{-80,210}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep1(
    final nout=nBoiNon) if have_boiNon
    "Replicate signal"
    annotation (Placement(transformation(extent={{-90,190},{-110,210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValBoiNonIso[nBoiNon](
    table=y1Non_default.table,
    timeScale=y1Non_default.timeScale,
    period=y1Non_default.period) if have_boiNon
    "Boiler isolation valve opening signal - Non-condensing Boilers"
    annotation (Placement(transformation(extent={{-60,90},{-80,110}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumHeaWatPriCon[
    nPumHeaWatPriCon](
    table=y1Con_default.table,
    timeScale=y1Con_default.timeScale,
    period=y1Con_default.period) if have_boiCon
    "Primary HW pump Enable signal - Condensing Boilers"
    annotation (Placement(transformation(extent={{-120,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumHeaWatPriCon(
    y(final unit="1"), k=1) if have_boiCon and have_varPumHeaWatPriCon
    "Primary HW pump speed signal - Condensing Boilers"
    annotation (Placement(transformation(extent={{-120,30},{-140,50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumHeaWatPriNon[
    nPumHeaWatPriNon](
    table=y1Non_default.table,
    timeScale=y1Non_default.timeScale,
    period=y1Non_default.period) if have_boiNon
    "Primary HW pump Enable signal - Non-condensing Boilers"
    annotation (Placement(transformation(extent={{-60,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumHeaWatPriNon(
    y(final unit="1"), k=1) if have_boiNon and have_varPumHeaWatPriNon
    "Primary HW pump speed signal - Non-condensing Boilers"
    annotation (Placement(transformation(extent={{-60,10},{-80,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumHeaWatSec[
    nPumHeaWatSec](
    table=y1Con_default.table,
    timeScale=y1Con_default.timeScale,
    period=y1Con_default.period) if typPumHeaWatSec == Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized
    "Secondary HW pump Enable signal"
    annotation (Placement(transformation(extent={{-120,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumHeaWatSec(
    y(final unit="1"), k=1)
    if typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized
    "Secondary HW pump speed signal"
    annotation (Placement(transformation(extent={{-120,-90},{-140,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValHeaWatMinByp(
    y(final unit="1"), k=0) if have_valHeaWatMinBypCon or have_valHeaWatMinBypNon
    "HW minimum flow bypass valve opening signal"
    annotation (Placement(transformation(extent={{-120,-10},{-140,10}})));
equation
  connect(y1PumHeaWatPriCon.y[1], busPumHeaWatPriCon.y1)
    annotation (Line(points={{-142,80},{-240,80},{-240,60}},color={255,0,255}));
  connect(yPumHeaWatPriCon.y, busPumHeaWatPriCon.y)
    annotation (Line(points={{-142,40},{-240,40},{-240,60}}, color={0,0,127}));
  connect(y1PumHeaWatSec.y[1], busPumHeaWatSec.y1)
    annotation (Line(points={{-142,-40},{-220,-40}}, color={255,0,255}));
  connect(yPumHeaWatSec.y, busPumHeaWatSec.y) annotation (Line(points={{-142,-80},
          {-220,-80},{-220,-40}}, color={0,0,127}));
  connect(y1PumHeaWatPriNon.y[1], busPumHeaWatPriNon.y1)
    annotation (Line(points={{-82,60},{-180,60}}, color={255,0,255}));
  connect(y1ValBoiNonIso.y[1], busValBoiNonIso.y1)
    annotation (Line(points={{-82,100},{-180,100}}, color={255,0,255}));
  connect(yPumHeaWatPriNon.y, busPumHeaWatPriNon.y)
    annotation (Line(points={{-82,20},{-160,20},{-160,56},{-180,56},{-180,60}},
                                                            color={0,0,127}));
  connect(y1BoiCon.y[1], busBoiCon.y1) annotation (Line(points={{-142,180},{
          -240,180},{-240,140}},
                            color={255,0,255}));
  connect(THeaWatConSupSet.y, rep.u)
    annotation (Line(points={{-142,220},{-148,220}}, color={0,0,127}));
  connect(rep.y, busBoiCon.THeaWatSupSet) annotation (Line(points={{-172,220},{-240,
          220},{-240,140}}, color={0,0,127}));
  connect(THeaWatSupSet.y, rep1.u)
    annotation (Line(points={{-82,200},{-88,200}}, color={0,0,127}));
  connect(rep1.y, busBoiNon.THeaWatSupSet) annotation (Line(points={{-112,200},{
          -180,200},{-180,140}}, color={0,0,127}));
  connect(y1BoiNon.y[1], busBoiNon.y1) annotation (Line(points={{-82,160},{-180,
          160},{-180,140}}, color={255,0,255}));
  connect(y1ValBoiConIso.y[1], busValBoiConIso.y1) annotation (Line(points={{-142,
          120},{-240,120},{-240,100}}, color={255,0,255}));
  connect(yValHeaWatMinByp.y, busValHeaWatMinBypCon.y) annotation (Line(points={{-142,0},
          {-180,0},{-180,8},{-240,8},{-240,20}},
                                            color={0,0,127}));
  connect(yValHeaWatMinByp.y, busValHeaWatMinBypNon.y)
    annotation (Line(points={{-142,0},{-180,0},{-180,20}}, color={0,0,127}));
  annotation (
  defaultComponentName="ctl");
end OpenLoop;
