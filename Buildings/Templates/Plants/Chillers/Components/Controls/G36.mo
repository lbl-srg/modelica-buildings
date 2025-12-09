within Buildings.Templates.Plants.Chillers.Components.Controls;
block G36
  "Guideline 36 controller for CHW plant"
  extends Buildings.Templates.Plants.Chillers.Components.Interfaces.PartialController(
    final typ=Buildings.Templates.Plants.Chillers.Types.Controller.G36);
  final parameter Boolean closeCoupledPlant=is_clsCpl
    "True: the plant is close coupled, i.e. the pipe length from the chillers to cooling towers does not exceed approximately 100 feet";
  // ---- General: Chiller configuration ----
  final parameter Boolean have_parChi=
    cfg.typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
    "Flag: true means that the plant has parallel chillers";
  parameter Boolean have_ponyChiller=false
    "True: have pony chiller"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Boolean use_loadShed = false
    "Set to true if a load shed logic is used"
    annotation (Dialog(tab="General", group="Chiller configuration",
    enable=cfg.typDisChiWat<>Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.ChillersAndStages
    chiTyp[cfg.nChi]=fill(
    Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.ChillersAndStages.VariableSpeedCentrifugal,
    cfg.nChi)
    "Chiller type. Recommended staging order: positive displacement, variable speed centrifugal, constant speed centrifugal"
    annotation (Dialog(tab="General",group="Chiller configuration"));
  final parameter Real chiDesCap[cfg.nChi](
    each final unit="W")=dat.capChi_nominal
    "Design chiller capacities vector";
  final parameter Real chiMinCap[cfg.nChi](
    each final unit="W") = dat.capUnlChi_min
    "Chiller minimum cycling loads vector";
  final parameter Real TChiWatSupMin[cfg.nChi](
    each final unit="K",
    each displayUnit="degC")=dat.TChiWatSupChi_nominal
    "Minimum chilled water supply temperature";
  final parameter Real dTChiMinLif[cfg.nChi]=
    dat.dTLifChi_min
    "Minimum LIFT of each chiller";
  final parameter Real dTChiMaxLif[cfg.nChi]=dat.dTLifChi_nominal
    "Maximum LIFT of each chiller";
  // ---- General: Waterside economizer ----
  final parameter Boolean have_WSE=
    cfg.typEco <> Buildings.Templates.Plants.Chillers.Types.Economizer.None
    "True if the plant has waterside economizer. When the plant has waterside economizer, the condenser water pump speed must be variable";
  final parameter Real heaExcAppDes(
    unit="K",
    displayUnit="K")=dat.dTAppEco_nominal
    "Design heat exchanger approach";
  final parameter Boolean have_byPasValCon=
    cfg.typEco == Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithValve
    "True: chilled water flow through economizer is controlled using heat exchanger bypass valve";
  // ----- General: Chilled water pump ---
  final parameter Integer nChiWatPum=cfg.nPumChiWatPri
    "Total number of chilled water pumps";
  final parameter Boolean have_heaChiWatPum=cfg.typArrPumChiWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Flag of headered chilled water pumps design: true=headered, false=dedicated";
  final parameter Boolean have_locSenChiWatPum=not cfg.have_senDpChiWatRemWir
    "True: there is local differential pressure sensor hardwired to the plant controller";
  final parameter Integer nSenChiWatPum=cfg.nSenDpChiWatRem
    "Total number of remote differential pressure sensors hardwired to the plant controller";
  // ---- General: Condenser water pump ----
  final parameter Integer nConWatPum=cfg.nPumConWat
    "Total number of condenser water pumps";
  final parameter Boolean have_fixSpeConWatPum=not cfg.have_pumConWatVar
    "True: the plant has fixed speed condenser water pumps. When the plant has waterside economizer, it must be false";
  final parameter Boolean have_heaConWatPum=cfg.typArrPumConWat == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "True: headered condenser water pumps";
  // ---- General: Chiller staging settings ----
  final parameter Integer nStaChiOnl=
    if cfg.typEco == Buildings.Templates.Plants.Chillers.Types.Economizer.None
      then nSta - 1
    else sum({if sta[i, nUniSta] > 0 then 0 else 1 for i in 2:nSta})
    "Number of chiller stages, neither zero stage nor the stages with enabled waterside economizer is included";
  final parameter Integer totSta=nSta
    "Total number of plant stages, including stage zero and the stages with a WSE, if applicable";
  final parameter Integer staMat[nStaChiOnl, cfg.nChi](
    each fixed=false)
    "Chiller staging matrix, excluding stage 0 and stages with WSE";
  final parameter Real desConWatPumSpe[nSta](
    final min=fill(0, nSta),
    final max=fill(1, nSta)) = dat.yPumConWatSta_nominal
    "Design condenser water pump speed setpoints, according to current chiller stage and WSE status";
  final parameter Integer desConWatPumNum[nSta] = dat.staPumConWat
    "Design number of condenser water pumps that should be ON, according to current chiller stage and WSE status";
  final parameter Integer towCelOnSet[nSta] = dat.staCoo
    "Design number of tower fan cells that should be ON, according to current chiller stage and WSE status";
  // ---- General: Cooling tower ----
  final parameter Integer nTowCel = cfg.nCoo
    "Total number of cooling tower cells";
  final parameter Real cooTowAppDes(
    unit="K",
    displayUnit="K")=dat.dTAppCoo_nominal
    "Design cooling tower approach";
  // ---- Plant enable ----
  final parameter Real TChiLocOut(
    final unit="K",
    displayUnit="degC")=dat.TOutChiWatLck
    "Outdoor air lockout temperature below which the chiller plant should be disabled";
  // ---- Waterside economizer ----
  final parameter Real TOutWetDes(
    final unit="K",
    displayUnit="degC")=dat.TWetBulCooEnt_nominal
    "Design outdoor air wet bulb temperature";
  final parameter Real VHeaExcDes_flow(
    final unit="m3/s")=dat.VChiWatEco_flow_nominal
    "Design heat exchanger chilled water volume flow rate";
  final parameter Real dpDes=dat.dpChiWatEco_nominal
    "Design pressure difference across the chilled water side economizer";
  // ---- Head pressure ----
  final parameter Real minConWatPumSpe(
    final unit="1")=dat.yPumConWat_min
    "Minimum condenser water pump speed";
  final parameter Real minHeaPreValPos(
    final unit="1")=dat.yValConWatChiIso_min
    "Minimum head pressure control valve position";
  // ---- Minimum flow bypass ----
  final parameter Real minFloSet[cfg.nChi](
    each final unit="m3/s")=dat.VChiWatChi_flow_min
    "Minimum chilled water flow through each chiller";
  final parameter Real maxFloSet[cfg.nChi](
    each final unit="m3/s")=dat.VChiWatChi_flow_nominal
    "Maximum chilled water flow through each chiller";
  // ---- Chilled water pumps ----
  // FIXME #2299: Dependency to stage and plant configuration not addressed.
  final parameter Real minChiWatPumSpe(
    unit="1")=dat.yPumChiWatPri_min
    "Minimum pump speed";
  // FIXME #2299: Dependency to stage and plant configuration not addressed.
  final parameter Real maxChiWatPumSpe(
    unit="1")=1
    "Maximum pump speed";
  final parameter Integer nPum_nominal(
    final max=nChiWatPum,
    final min=1)=dat.cfg.nPumChiWatPri
    "Total number of pumps that operate at design conditions";
  final parameter Real VChiWat_flow_nominal(
    unit="m3/s")=dat.VChiWatPri_flow_nominal
    "Total plant design chilled water flow rate";
  final parameter Real maxLocDp(
    unit="Pa")=dat.dpChiWatLocSet_max
    "Maximum chilled water loop local differential pressure setpoint";
  // ---- Plant reset ----
  final parameter Real dpChiWatMin[nSenChiWatPum](
    each final unit="Pa",
    each displayUnit="Pa")=dat.dpChiWatRemSet_min
    "Minimum chilled water differential pressure setpoint, the array size equals to the number of remote pressure sensor";
  final parameter Real dpChiWatMax[nSenChiWatPum](
    each final unit="Pa",
    each displayUnit="Pa")=dat.dpChiWatRemSet_max
    "Maximum chilled water differential pressure setpoint, the array size equals to the number of remote pressure sensor";
  final parameter Real TPlaChiWatSupMax(
    final unit="K",
    displayUnit="degC")=dat.TChiWatSup_max
    "Maximum chilled water supply temperature setpoint used in plant reset logic";
  // ---- Cooling tower: fan speed ----
  final parameter Real fanSpeMin(
    unit="1")=dat.yFanCoo_min
    "Minimum tower fan speed";
  // Fan speed control: controlling condenser return water temperature when WSE is not enabled
  final parameter Real TConWatSup_nominal[cfg.nChi](
    each final unit="K",
    each displayUnit="degC")=dat.TConWatSupChi_nominal
    "Condenser water supply temperature (condenser entering) of each chiller";
  final parameter Real TConWatRet_nominal[cfg.nChi](
    each final unit="K",
    each displayUnit="degC")=dat.TConWatRetChi_nominal
    "Condenser water return temperature (condenser leaving) of each chiller";
  // ---- Cooling tower: staging ----
  parameter Boolean have_endSwi=false
    "True: tower cells isolation valve have end switch"
    annotation (Dialog(group="Configuration",
      enable=cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
      and (cfg.typValCooInlIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
        or cfg.typValCooOutIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition)));
  // FIXME: missing parameter for inlet isolation valve configuration.
  final parameter Boolean have_outIsoVal=
    cfg.typValCooOutIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "True: tower cells also have outlet isolation valve";
  // ---- Cooling tower: Water level control ----
  final parameter Real watLevMin(
    unit="1")=dat.hLevCoo_min
    "Minimum cooling tower water level recommended by manufacturer";
  final parameter Real watLevMax(
    unit="1")=dat.hLevCoo_max
    "Maximum cooling tower water level recommended by manufacturer";
  Buildings.Templates.Plants.Chillers.Components.Controls.patchController ctl(
    final have_airCoo=cfg.typChi == Buildings.Templates.Components.Types.Chiller.AirCooled,
    final chiDesCap=chiDesCap,
    final chiHeaPreCon=typCtlHea,
    final chiMinCap=chiMinCap,
    final chiTyp=chiTyp,
    final closeCoupledPlant=closeCoupledPlant,
    final cooTowAppDes=cooTowAppDes,
    final desConWatPumNum=desConWatPumNum,
    final desConWatPumSpe=desConWatPumSpe,
    TiEcoVal=60,
    TiMinFloBypCon=60,
    TiChiWatPum=60,
    final dpChiWatMax=dpChiWatMax,
    final dpChiWatMin=dpChiWatMin,
    final dpDes=dpDes,
    final dTChiMinLif=dTChiMinLif,
    final dTChiMaxLif=dTChiMaxLif,
    final fanSpeMin=fanSpeMin,
    final have_byPasValCon=have_byPasValCon,
    final have_endSwi=have_endSwi,
    final have_fixSpeConWatPum=have_fixSpeConWatPum,
    final have_heaChiWatPum=have_heaChiWatPum,
    final have_heaConWatPum=have_heaConWatPum,
    final have_locSenChiWatPum=have_locSenChiWatPum,
    final have_outIsoVal=have_outIsoVal,
    final have_parChi=have_parChi,
    final have_ponyChiller=have_ponyChiller,
    final have_WSE=have_WSE,
    final heaExcAppDes=heaExcAppDes,
    final maxChiWatPumSpe=maxChiWatPumSpe,
    final maxFloSet=maxFloSet,
    final maxLocDp=maxLocDp,
    final minChiWatPumSpe=minChiWatPumSpe,
    final minConWatPumSpe=minConWatPumSpe,
    final minFloSet=minFloSet,
    final minHeaPreValPos=minHeaPreValPos,
    final nChi=cfg.nChi,
    final nChiWatPum=nChiWatPum,
    final nConWatPum=nConWatPum,
    final nPum_nominal=nPum_nominal,
    final nSenChiWatPum=nSenChiWatPum,
    final nTowCel=nTowCel,
    final use_loadShed=use_loadShed,
    final conWatPumStaMat=integer(ceil(sta)),
    final staMat=staMat,
    final TChiLocOut=TChiLocOut,
    final TChiWatSupMin=TChiWatSupMin,
    final TConWatRet_nominal=TConWatRet_nominal,
    final TConWatSup_nominal=TConWatSup_nominal,
    final totSta=nSta,
    final TOutWetDes=TOutWetDes,
    final towCelOnSet=towCelOnSet,
    final TPlaChiWatSupMax=TPlaChiWatSupMax,
    final VChiWat_flow_nominal=VChiWat_flow_nominal,
    final VHeaExcDes_flow=VHeaExcDes_flow,
    kCouPla=0.1,
    TiCouPla=60,
    final watLevMax=watLevMax,
    final watLevMin=watLevMin)
    "Plant controller"
    annotation (Placement(transformation(extent={{0,-40},{20,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant RFE_watLev(
    k=0.1) "Add tower basin model with water level and heating demand signal"
    annotation (Placement(transformation(extent={{-110,-190},{-90,-170}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqResChiWatAirHan(
    final nin=nAirHan)
    "Sum of CHW reset requests from AHU"
    annotation (Placement(transformation(extent={{230,110},{210,130}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqPlaChiWatEquZon(
    final nin=nEquZon)
    "Sum of CHW plant requests from zone equipment"
    annotation (Placement(transformation(extent={{230,-130},{210,-110}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqResChiWatEquZon(
    final nin=nEquZon)
    "Sum of CHW reset requests from zone equipment"
    annotation (Placement(transformation(extent={{230,-170},{210,-150}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqPlaChiWatAirHan(
    final nin=nAirHan)
    "Sum of CHW plant requests from AHU"
    annotation (Placement(transformation(extent={{230,150},{210,170}})));
  Buildings.Controls.OBC.CDL.Integers.Add reqPlaChiWat
    "Sum of CHW plant requests of all loads served"
    annotation (Placement(transformation(extent={{190,144},{170,164}})));
  Buildings.Controls.OBC.CDL.Integers.Add reqResChiWat
    "Sum of CHW reset requests of all loads served"
    annotation (Placement(transformation(extent={{190,104},{170,124}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.LocalDp_setpoint
    resDpChiWatLoc(
    final nSen=cfg.nSenDpChiWatRem,
    final nPum=if cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
      then cfg.nPumChiWatPri else cfg.nPumChiWatSec,
    final minLocDp=dat.dpChiWatLocSet_min,
    final maxLocDp=dat.dpChiWatLocSet_max,
    k=0.1,
    Ti=60) if not cfg.have_senDpChiWatRemWir
    "Local CHW differential pressure reset"
    annotation (Placement(transformation(extent={{-60,16},{-40,36}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter FIXME_uChiWatIsoVal(nin=cfg.nChi,
      nout=cfg.nChi) if typCtlHea <> Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.HeadPressureControl.NotRequired
    "#2299 Depends on plant configuration, should rather be the commanded position"
    annotation (Placement(transformation(extent={{-110,150},{-90,170}})));
protected
  Integer idx
    "Iteration variable for algorithm section";
initial algorithm
  idx := 1;
  if cfg.typEco <> Buildings.Templates.Plants.Chillers.Types.Economizer.None
    then
    for i in 2:nSta loop
      if sta[i, nUniSta] < 1 then
        staMat[idx] := {if sta[i, j] > 0 then 1 else 0 for j in 1:cfg.nChi};
        idx := idx + 1;
      end if;
    end for;
  else
    staMat := {{if sta[k + 1, j] > 0 then 1 else 0 for j in 1:cfg.nChi} for k in 1:nStaChiOnl};
  end if;
algorithm
  /*
  The when clause makes the variable discrete, and when the algorithm is executed,
  it is initialized with its pre value.
  */
  when sample(0, 3E7) then
    idx := 0;
  end when;
equation
  /* Control point connection - start */
  connect(busChi.y1ReqFloChiWat, ctl.uChiWatReq);
  connect(busChi.y1ReqFloConWat, ctl.uConWatReq);
  connect(bus.pumChiWatPri.y1_actual, ctl.uChiWatPum);
  connect(bus.dpChiWatLoc, ctl.dpChiWat_local);
  connect(bus.dpChiWatRem, ctl.dpChiWat_remote);
  connect(bus.VChiWatPri_flow, ctl.VChiWat_flow);
  connect(bus.TConWatRet, ctl.TConWatTowRet);
  connect(busChi.TChiWatSup, ctl.TChiWatSupChi);
  connect(busChi.TConWatRet, ctl.TConWatRet);
  connect(busChi.y1_actual, ctl.uChi);
  connect(bus.TChiWatEcoAft, ctl.TChiWatRetDow);
  if cfg.typEco <> Buildings.Templates.Plants.Chillers.Types.Economizer.None
    then
    connect(bus.TChiWatEcoBef, ctl.TChiWatRet);
  else
    connect(bus.TChiWatPlaRet, ctl.TChiWatRet);
  end if;
  connect(bus.TConWatSup, ctl.TConWatSup);
  connect(bus.TChiWatPriSup, ctl.TChiWatSup);
  connect(bus.dpChiWatEco, ctl.dpChiWat);
  // HACK Dymola does not automatically remove these clauses at translation.
  if cfg.typEco == Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithPump
    then
    connect(bus.pumChiWatEco.y1_actual, ctl.uEcoPum);
  end if;
  if cfg.typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
    then
    connect(bus.pumConWat.y1_actual, ctl.uConWatPum);
  end if;
  connect(bus.TChiWatEcoEnt, ctl.TEntHex);
  connect(busCoo.y1_actual, ctl.uTowSta);
  connect(busChi.yCtlHea, ctl.uHeaPreCon);
  connect(bus.VChiWatPri_flow, ctl.VChiWat_flow);
  connect(bus.TOut, ctl.TOut);
  connect(bus.phiOut, ctl.phi);
  connect(bus.u1SchEna, ctl.uPlaSchEna);
  connect(bus.dpChiWatRem, resDpChiWatLoc.dpChiWat_remote);
  if cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only then
    connect(bus.pumChiWatPri.y1_actual, resDpChiWatLoc.uChiWatPum);
  else
    connect(bus.pumChiWatSec.y1_actual, resDpChiWatLoc.uChiWatPum);
  end if;
  connect(bus.valCooInlIso.y0_actual, ctl.u1InIsoValClo);
  connect(bus.valCooInlIso.y1_actual, ctl.u1InIsoValOpe);
  connect(bus.valCooOutIso.y0_actual, ctl.u1OutIsoValClo);
  connect(bus.valCooOutIso.y1_actual, ctl.u1OutIsoValOpe);
  connect(FIXME_uChiWatIsoVal.y, ctl.uChiWatIsoVal)
    annotation (Line(points={{-88,160},{-20,160},{-20,-10},{-2,-10}},  color={0,0,127}));

  // Controller outputs
  connect(ctl.TChiWatSupSet, bus.TChiWatSupSet);
  connect(ctl.TChiWatSupSet, busChi.TSet);
  connect(ctl.y1WseChiWatBypVal, bus.valChiWatChiByp.y1);
  connect(ctl.yChi, busChi.y1);
  connect(ctl.yChiWatIsoVal, busValChiWatChiIso.y);
  connect(ctl.yChiWatPum, bus.pumChiWatPri.y1);
  connect(ctl.FIXME_y1ConWatIsoVal, busValConWatChiIso.y1);
  connect(ctl.FIXME_yConWatIsoVal, busValConWatChiIso.y);
  connect(ctl.yConWatPum, bus.pumConWat.y1);
  connect(ctl.yEcoConWatIsoVal, bus.valConWatEcoIso.y1);
  connect(ctl.yMinValPosSet, bus.valChiWatMinByp.y);
  connect(ctl.yTowCel, bus.y1Coo);
  connect(ctl.yWsePumOn, bus.pumChiWatEco.y1);
  connect(ctl.yWsePumSpe, bus.pumChiWatEco.y);
  connect(ctl.yWseRetVal, bus.valChiWatEcoByp.y);
  connect(ctl.yChiPumSpe, bus.pumChiWatPri.y);
  connect(ctl.yConWatPumSpe, bus.pumConWat.y);
  connect(ctl.yTowCelIsoVal, busValCooInlIso.y1);
  connect(ctl.yTowCelIsoVal, busValCooOutIso.y1);
  connect(ctl.yTowFanSpe, bus.yCoo);

  /* Control point connection - stop */
  connect(reqPlaChiWat.y, ctl.chiPlaReq)
    annotation (Line(points={{168,154},{-18,154},{-18,-14},{-2,-14}},color={255,127,0}));
  connect(reqResChiWat.y, ctl.TChiWatSupResReq)
    annotation (Line(points={{168,114},{-16,114},{-16,-12},{-2,-12}},    color={255,127,0}));
  connect(busAirHan.reqPlaChiWat, reqPlaChiWatAirHan.u)
    annotation (Line(points={{260,140},{240,140},{240,160},{232,160}},color={255,204,51},thickness=0.5));
  connect(busAirHan.reqResChiWat, reqResChiWatAirHan.u)
    annotation (Line(points={{260,140},{240,140},{240,120},{232,120}},color={255,204,51},thickness=0.5));
  connect(busEquZon.reqResChiWat, reqResChiWatEquZon.u)
    annotation (Line(points={{260,-140},{240,-140},{240,-160},{232,-160}},color={255,204,51},thickness=0.5));
  connect(busEquZon.reqPlaChiWat, reqPlaChiWatEquZon.u)
    annotation (Line(points={{260,-140},{240,-140},{240,-120},{232,-120}},color={255,204,51},thickness=0.5));
  connect(reqPlaChiWatAirHan.y, reqPlaChiWat.u1)
    annotation (Line(points={{208,160},{192,160}},color={255,127,0}));
  connect(reqResChiWatAirHan.y, reqResChiWat.u1)
    annotation (Line(points={{208,120},{192,120}},color={255,127,0}));
  connect(reqPlaChiWatEquZon.y, reqPlaChiWat.u2)
    annotation (Line(points={{208,-120},{200,-120},{200,148},{192,148}},color={255,127,0}));
  connect(reqResChiWatEquZon.y, reqResChiWat.u2)
    annotation (Line(points={{208,-160},{198,-160},{198,108},{192,108}},color={255,127,0}));
  connect(resDpChiWatLoc.dpChiWatPumSet_local, ctl.dpChiWatSet_local)
    annotation (Line(points={{-38,26},{-2,26}},                     color={0,0,127}));
  connect(ctl.FIXME_dpChiWatPumSet, resDpChiWatLoc.dpChiWatSet_remote)
    annotation (Line(points={{26,23},{30,23},{30,50},{-70,50},{-70,21},{-62,21}},
        color={0,0,127}));
  connect(busValChiWatChiIso.y_actual, FIXME_uChiWatIsoVal.u) annotation (Line(
      points={{-240,160},{-112,160}},
      color={255,204,51},
      thickness=0.5));
  connect(RFE_watLev.y, ctl.watLev) annotation (Line(points={{-88,-180},{-18,-180},
          {-18,-37},{-2,-37}},       color={0,0,127}));
  annotation (
    Documentation(
      info="<html>
<h4>Description</h4>
<p>
This is an implementation of the control sequence specified in ASHRAE (2021)
for chilled water plants.
It is based on
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Controller</a>.
</p>
<h4>Control points</h4>
<p>
The control sequence requires the following external input points in
addition to those already included in the chiller plant template.
</p>
<ul>
<li>Plant enable schedule <code>u1SchEna</code>:
DI signal with a dimensionality of zero</li>
<li>Outdoor air temperature <code>TOut</code>:
AI signal with a dimensionality of zero</li>
<li>CHW differential pressure from remote sensor(s) <code>dpChiWatRem</code>:
AI signal with a dimensionality of one, the number of remote
sensors is specified by the parameter <code>nSenDpChiWatRem</code>.</li>
<li>
Inside the sub-bus <code>busAirHan[:]</code> or <code>busEquZon[:]</code>,
with a dimensionality of one
<ul>
<li>
CHW plant requests yielded by the air handler or zone
equipment controller <code>bus(AirHan|EquZon)[:].reqPlaChiWat</code>:
AI signal (Integer), with a dimensionality of one
</li>
<li>
CHW reset requests yielded by the air handler or zone
equipment controller <code>bus(AirHan|EquZon)[:].reqResChiWat</code>:
AI signal (Integer), with a dimensionality of one
</li>
</ul>
</ul>
<h4>References</h4>
<ul>
<li>
ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end G36;
