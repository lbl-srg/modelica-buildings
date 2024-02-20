within Buildings.Templates.Plants.HeatPumps.Components.Controls;
block OpenLoop
  "Open-loop controller"
  extends Buildings.Templates.Plants.HeatPumps.Components.Interfaces.PartialController(
    final typ=Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop);
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet[nHp](
    y(
      each final unit="K",
      each displayUnit="degC"),
    each k=Buildings.Templates.Data.Defaults.THeaWatSupMed)
    "Heat pump HW supply temperature set point"
    annotation (Placement(transformation(extent={{-80,190},{-100,210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet[nHp](
    y(
      each final unit="K",
      each displayUnit="degC"),
    each k=Buildings.Templates.Data.Defaults.TChiWatSup)
    "Heat pump CHW supply temperature set point"
    annotation (Placement(transformation(extent={{-80,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValHeaWatHpInlIso[nHp](
    each table=[
      0, 0;
      1, 1;
      3, 0;
      5, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.have_heaWat and cfg.have_valHpInlIso
    "Heat pump inlet HW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-180,110},{-200,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValHeaWatHpOutIso[nHp](
    each table=[
      0, 0;
      1, 1;
      3, 0;
      5, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.have_heaWat and cfg.have_valHpOutIso
    "Heat pump outlet HW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-180,70},{-200,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatHpInlIso[nHp](
    each table=[
      0, 0;
      3.1, 1;
      5, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.have_chiWat and cfg.have_valHpInlIso
    "Heat pump inlet CHW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-180,-90},{-200,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatHpOutIso[nHp](
    each table=[
      0, 0;
      3.1, 1;
      5, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.have_chiWat and cfg.have_valHpOutIso
    "Heat pump outlet CHW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-180,-130},{-200,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Hp[nHp](
    each table=[
      0, 0;
      1, 0;
      1, 1;
      5, 1],
    each timeScale=1000,
    each period=5000)
    "Heat pump start/stop cpmmand"
    annotation (Placement(transformation(extent={{-180,190},{-200,210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1HeaHp[nHp](
    each table=[
      0, 1;
      3, 0;
      5, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.is_rev
    "Heat pump heating mode command"
    annotation (Placement(transformation(extent={{-180,150},{-200,170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumHeaWatPri[cfg.nPumHeaWatPri](
    each table=if cfg.have_pumChiWatPriDed or not cfg.have_chiWat then[
      0, 0;
      1, 1;
      3, 0;
      5, 0] else[
      0, 0;
      1, 1;
      3, 0;
      3.1, 1;
      5, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.have_heaWat
    "Primary CHW pump start/stop command"
    annotation (Placement(transformation(extent={{30,130},{50,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatPri[cfg.nPumChiWatPri](
    each table=[
      0, 0;
      3.1, 1;
      5, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.have_pumChiWatPriDed
    "Primary CHW pump start/stop command"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumHeaWatSec[cfg.nPumHeaWatSec](
    each table=[
      0, 0;
      1, 1;
      3, 0;
      5, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.typPumHeaWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Secondary HW pump start/stop command"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatSec[cfg.nPumChiWatSec](
    each table=[
      0, 0;
      3, 1;
      5, 1],
    each timeScale=1000,
    each period=5000)
    if cfg.typPumChiWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Secondary CHW pump start/stop command"
    annotation (Placement(transformation(extent={{30,-130},{50,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yPumHeaWatSec(
    k=1)
    if cfg.typPumHeaWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Secondary HW pump speed signal"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yPumChiWatSec(
    k=1)
    if cfg.typPumChiWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Secondary CHW pump speed signal"
    annotation (Placement(transformation(extent={{60,-150},{80,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TSet[nHp](
    y(
      each final unit="K",
      each displayUnit="degC"))
    "Active supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,170},{-160,190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru[nHp](
    each final k=true)
    if not cfg.is_rev
    "Constant"
    annotation (Placement(transformation(extent={{-80,230},{-100,250}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yPumHeaWatPri(
    k=1)
    if cfg.have_heaWat and cfg.have_varPumHeaWatPri
    "Primary HW pump speed signal"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yPumChiWatPri(
    k=1)
    if cfg.have_pumChiWatPriDed and cfg.have_varPumHeaWatPri
    "Primary CHW pump speed signal"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
equation
  /* Control point connection - start */ connect(y1PumHeaWatPri.y[1], busPumHeaWatPri.y1);
  connect(yPumHeaWatPri.y, busPumHeaWatPri.y);
  connect(y1PumHeaWatSec.y[1], busPumHeaWatSec.y1);
  connect(yPumHeaWatSec.y, busPumHeaWatSec.y);
  connect(y1ValHeaWatHpInlIso.y[1], busValHeaWatHpInlIso.y1);
  connect(y1ValHeaWatHpOutIso.y[1], busValHeaWatHpOutIso.y1);
  connect(yPumChiWatSec.y, busPumChiWatSec.y);
  connect(y1ValChiWatHpOutIso.y[1], busValChiWatHpOutIso.y1);
  connect(y1PumChiWatPri.y[1], busPumChiWatPri.y1);
  connect(yPumChiWatPri.y, busPumChiWatPri.y);
  connect(y1ValChiWatHpInlIso.y[1], busValChiWatHpInlIso.y1);
  connect(y1PumChiWatSec.y[1], busPumChiWatSec.y1);
  connect(y1Hp.y[1], busHp.y1);
  connect(y1HeaHp.y[1], busHp.y1Hea);
  connect(TSet.y, busHp.TSet);
  /* Control point connection - stop */connect(TChiWatSupSet.y, TSet.u3)
    annotation (Line(points={{-102,160},{-120,160},{-120,172},{-138,172}},color={0,0,127}));
  connect(THeaWatSupSet.y, TSet.u1)
    annotation (Line(points={{-102,200},{-120,200},{-120,188},{-138,188}},color={0,0,127}));
  connect(y1HeaHp.y[1], TSet.u2)
    annotation (Line(points={{-202,160},{-210,160},{-210,140},{-130,140},{-130,180},{-138,180}},
      color={255,0,255}));
  connect(tru.y, TSet.u2)
    annotation (Line(points={{-102,240},{-130,240},{-130,180},{-138,180}},color={255,0,255}));
  annotation (
    defaultComponentName="ctl");
end OpenLoop;
