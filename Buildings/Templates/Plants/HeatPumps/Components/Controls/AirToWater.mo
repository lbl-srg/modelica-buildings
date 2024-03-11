within Buildings.Templates.Plants.HeatPumps.Components.Controls;
model AirToWater
  "Controller for AWHP plant"
  extends Buildings.Templates.Plants.HeatPumps.Components.Interfaces.PartialController(
    final typ=Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater);
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
  Buildings.Templates.Plants.Controls.HeatPumps.AirToWater ctl
    "Plant controller"
    annotation (Placement(transformation(extent={{-10,-20},{10,20}})));
equation
  /* Control point connection - start */ connect(yPumHeaWatPri.y, busPumHeaWatPri.y);
  connect(yPumHeaWatSec.y, busPumHeaWatSec.y);
  connect(yPumChiWatSec.y, busPumChiWatSec.y);
  connect(yPumChiWatPri.y, busPumChiWatPri.y);
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
end AirToWater;
