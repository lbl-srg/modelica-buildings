within Buildings.Templates.Plants.HeatPumps.Components.Controls;
block OpenLoop
  "Open-loop controller"
  extends Buildings.Templates.Plants.HeatPumps.Components.Interfaces.PartialController(
    final typ=Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop);
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet[nHp + nShc](
    y(each final unit="K", each displayUnit="degC"),
    each k=Buildings.Templates.Data.Defaults.THeaWatSupMed)
    "HW supply temperature set point"
    annotation(Placement(transformation(extent={{-20,310},{-40,330}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet[nHp + nShc](
    y(each final unit="K", each displayUnit="degC"),
    each k=Buildings.Templates.Data.Defaults.TChiWatSup)
    "CHW supply temperature set point"
    annotation(Placement(transformation(extent={{-20,270},{-40,290}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValHeaWatHpInlIso[nHp](
    each table=[0, 0; 1, 1; 3, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.have_hp and cfg.have_heaWat and cfg.have_valHpInlIso
    "Heat pump inlet HW isolation valve opening signal"
    annotation(Placement(transformation(extent={{-100,250},{-120,270}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValHeaWatHpOutIso[nHp](
    each table=[0, 0; 1, 1; 3, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.have_hp and cfg.have_heaWat and cfg.have_valHpOutIso
    "Heat pump outlet HW isolation valve opening signal"
    annotation(Placement(transformation(extent={{-100,210},{-120,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatHpInlIso[nHp](
    each table=[0, 0; 3.1, 1; 5, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.have_hp and cfg.have_chiWat and cfg.have_valHpInlIso
    "Heat pump inlet CHW isolation valve opening signal"
    annotation(Placement(transformation(extent={{-100,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatHpOutIso[nHp](
    each table=[0, 0; 3.1, 1; 5, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.have_hp and cfg.have_chiWat and cfg.have_valHpOutIso
    "Heat pump outlet CHW isolation valve opening signal"
    annotation(Placement(transformation(extent={{-100,-130},{-120,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Hp[nHp](
    each table=[0, 0; 1, 1],
    each timeScale=1000,
    each period=5000)
    "Heat pump start/stop command"
    annotation(Placement(transformation(extent={{-100,330},{-120,350}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1HeaHp[nHp](
    each table=[0, 1; 3, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.is_rev
    "Heat pump heating mode command"
    annotation(Placement(transformation(extent={{-100,290},{-120,310}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumHeaWatPri[cfg.nPumHeaWatPri](
    each table=if cfg.have_pumPriComHp then [0,0; 1,1; 3,0; 3.1,1; 5,0]
      else [0,0; 1, 1; 3,0; 5,0],
    each timeScale=1000,
    each period=5000) if cfg.have_heaWat
    "Primary CHW pump start/stop command"
    annotation (Placement(transformation(extent={{-100,170},{-120,190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatPri[cfg.nPumChiWatPri](
    each table=[0, 0; 3.1, 1; 5, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.typPumChiWatPriHp <>
    Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
    or cfg.typPumChiWatPriShc <>
    Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
    "Primary CHW pump start/stop command"
    annotation(Placement(transformation(extent={{-100,-210},{-120,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumHeaWatSec[cfg.nPumHeaWatSec](
    each table=[0, 0; 1, 1; 3, 0; 5, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.typPumHeaWatSec <>
      Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Secondary HW pump start/stop command"
    annotation(Placement(transformation(extent={{-100,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatSec[cfg.nPumChiWatSec](
    each table=[0, 0; 3.1, 1; 5, 1],
    each timeScale=1000,
    each period=5000)
    if cfg.typPumChiWatSec <>
      Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Secondary CHW pump start/stop command"
    annotation(Placement(transformation(extent={{-100,-250},{-120,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yPumHeaWatSec(k=1)
    if cfg.typPumHeaWatSec <>
      Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Secondary HW pump speed signal"
    annotation(Placement(transformation(extent={{-60,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yPumChiWatSec(k=1)
    if cfg.typPumChiWatSec <>
      Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Secondary CHW pump speed signal"
    annotation(Placement(transformation(extent={{-140,-250},{-160,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yPumHeaWatPriHdr(k=1)
    if (cfg.typPumHeaWatPriHp == Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
    or cfg.typPumHeaWatPriShc == Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable)
    and cfg.typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Headered primary HW pump speed signal"
    annotation(Placement(transformation(extent={{-60,170},{-80,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yPumChiWatPriHdr(k=1)
    if (cfg.typPumChiWatPriHp == Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
    or cfg.typPumChiWatPriShc == Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable)
    and cfg.typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Headered primary CHW pump speed signal"
    annotation(Placement(transformation(extent={{-60,-210},{-80,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yPumHeaWatPriDed[cfg.nPumHeaWatPri](
    each k=1)
    if (cfg.typPumHeaWatPriHp == Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
    or cfg.typPumHeaWatPriShc == Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable)
      and cfg.typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    "Dedicated primary HW pump speed signal"
    annotation(Placement(transformation(extent={{-20,170},{-40,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yPumChiWatPriDed[cfg.nPumChiWatPri](
    each k=1)
    if cfg.typArrPumPri ==
    Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    and (cfg.typPumChiWatPriHp == Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
    or cfg.typPumChiWatPriShc == Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable)
    "Dedicated primary CHW pump speed signal"
    annotation(Placement(transformation(extent={{-20,-210},{-40,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatShcInlIso[nShc](
    each table=[0, 0; 3.1, 1; 5, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.have_shc and cfg.have_chiWat and cfg.have_valShcInlIso
    "SHC unit inlet CHW isolation valve opening signal"
    annotation(Placement(transformation(extent={{-40,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatShcOutIso[nShc](
    each table=[0, 0; 3.1, 1; 5, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.have_shc and cfg.have_chiWat and cfg.have_valShcOutIso
    "SHC unit outlet CHW isolation valve opening signal"
    annotation(Placement(transformation(extent={{-40,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValHeaWatShcInlIso[nShc](
    each table=[0, 0; 1, 1; 3, 0; 5, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.have_shc and cfg.have_heaWat and cfg.have_valShcInlIso
    "SHC unit inlet HW isolation valve opening signal"
    annotation(Placement(transformation(extent={{-60,250},{-80,270}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValHeaWatShcOutIso[nShc](
    each table=[0, 0; 1, 1; 3, 0; 5, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.have_shc and cfg.have_heaWat and cfg.have_valShcOutIso
    "SHC unit outlet HW isolation valve opening signal"
    annotation(Placement(transformation(extent={{-60,210},{-80,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1HeaShc[nShc](
    each table=[0, 0; 1, 1; 4, 0],
    each timeScale=1000,
    each period=5000)
    if cfg.have_shc
    "SHC unit heating on/off command"
    annotation(Placement(transformation(extent={{-60,350},{-80,370}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1CooShc[nShc](
    each table=[0, 0; 2.5, 1],
    each timeScale=1000,
    each period=5000)
    if cfg.have_shc
    "SHC unit cooling on/off command"
    annotation(Placement(transformation(extent={{-60,310},{-80,330}})));
equation
  /* Control point connection - start */
  connect(TChiWatSupSet[nHp + 1:nHp + nShc].y, busShc.TChiWatSet);
  connect(THeaWatSupSet[nHp + 1:nHp + nShc].y, busShc.THeaWatSet);
  connect(y1Hp.y[1], busHp.y1);
  connect(y1HeaHp.y[1], busHp.y1Hea);
  connect(y1PumChiWatPri.y[1], busPumChiWatPri.y1);
  connect(yPumChiWatPriHdr.y, busPumChiWatPri.y);
  connect(yPumChiWatPriDed.y, busPumChiWatPri.y);
  connect(y1PumChiWatSec.y[1], busPumChiWatSec.y1);
  connect(yPumChiWatSec.y, busPumChiWatSec.y);
  connect(y1PumHeaWatPri.y[1], busPumHeaWatPri.y1);
  connect(yPumHeaWatPriHdr.y, busPumHeaWatPri.y);
  connect(yPumHeaWatPriDed.y, busPumHeaWatPri.y);
  connect(y1PumHeaWatSec.y[1], busPumHeaWatSec.y1);
  connect(yPumHeaWatSec.y, busPumHeaWatSec.y);
  connect(TChiWatSupSet[1:nHp].y, busHp.TChiWatSet);
  connect(THeaWatSupSet[1:nHp].y, busHp.THeaWatSet);
  connect(y1CooShc.y[1], busShc.y1Coo);
  connect(y1HeaShc.y[1], busShc.y1Hea);
  connect(y1ValChiWatHpInlIso.y[1], busValChiWatHpInlIso.y1);
  connect(y1ValChiWatHpOutIso.y[1], busValChiWatHpOutIso.y1);
  connect(y1ValHeaWatHpInlIso.y[1], busValHeaWatHpInlIso.y1);
  connect(y1ValHeaWatHpOutIso.y[1], busValHeaWatHpOutIso.y1);
  connect(y1ValChiWatShcInlIso.y[1], busValChiWatShcInlIso.y1);
  connect(y1ValChiWatShcOutIso.y[1], busValChiWatShcOutIso.y1);
  connect(y1ValHeaWatShcInlIso.y[1], busValHeaWatShcInlIso.y1);
  connect(y1ValHeaWatShcOutIso.y[1], busValHeaWatShcOutIso.y1);
  /* Control point connection - stop */
annotation(defaultComponentName="ctl",
  Documentation(
    info="<html>
<p>
  This is an open loop controller providing control inputs for the plant model
  <a href=\"modelica://Buildings.Templates.Plants.HeatPumps.AirToWater\">
    Buildings.Templates.Plants.HeatPumps.AirToWater</a>. It is only used for
  testing purposes.
</p>
</html>"));
end OpenLoop;
