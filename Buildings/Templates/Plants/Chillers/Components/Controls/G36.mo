within Buildings.Templates.Plants.Chillers.Components.Controls;
block G36
  "Guideline 36 controller for CHW plant"
  extends Buildings.Templates.Plants.Chillers.Components.Interfaces.PartialController(
    final typ=Buildings.Templates.Plants.Chillers.Types.Controller.G36);
  final parameter Boolean closeCoupledPlant=is_clsCpl
    "True: the plant is close coupled, i.e. the pipe length from the chillers to cooling towers does not exceed approximately 100 feet"
    annotation (Dialog(tab="General"));
  // ---- General: Chiller configuration ----
  final parameter Boolean have_parChi=cfg.typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
    "Flag: true means that the plant has parallel chillers"
    annotation (Dialog(tab="General",group="Chillers configuration"));
  parameter Boolean have_ponyChiller=false
    "True: have pony chiller"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  // FIXME: #2299 Incorrect description and usage of this parameter.
  parameter Boolean need_reduceChillerDemand=false
    "True: need limit chiller demand when chiller staging"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.ChillersAndStages
    chiTyp[cfg.nChi]=fill(
    Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.ChillersAndStages.VariableSpeedCentrifugal,
    cfg.nChi)
    "Chiller type. Recommended staging order: positive displacement, variable speed centrifugal, constant speed centrifugal"
    annotation (Dialog(tab="General",group="Chillers configuration"));
  final parameter Real chiDesCap[cfg.nChi](
    each final unit="W")=dat.capChi_nominal
    "Design chiller capacities vector"
    annotation (Dialog(tab="General",group="Chillers configuration"));
  final parameter Real chiMinCap[cfg.nChi](
    each final unit="W")=dat.capUnlChi_min
    "Chiller minimum cycling loads vector"
    annotation (Dialog(tab="General",group="Chillers configuration"));
  final parameter Real TChiWatSupMin[cfg.nChi](
    each final unit="K",
    each displayUnit="degC")=dat.TChiWatSupChi_nominal
    "Minimum chilled water supply temperature"
    annotation (Dialog(tab="General",group="Chillers configuration"));
  final parameter Real minChiLif[cfg.nChi](
    each final unit="K")=dat.dTLifChi_min
    "Minimum lift of each chiller"
    annotation (Dialog(tab="General", group="Chillers configuration"));
  final parameter Boolean have_heaPreConSig=typCtlHea == Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.BuiltIn
    "True: if there is head pressure control signal from chiller controller"
    annotation (Dialog(tab="General",group="Chillers configuration"));
  // ---- General: Waterside economizer ----
  final parameter Boolean have_WSE=cfg.typEco <> Buildings.Templates.Plants.Chillers.Types.Economizer.None
    "True if the plant has waterside economizer. When the plant has waterside economizer, the condenser water pump speed must be variable"
    annotation (Dialog(tab="General",group="Waterside economizer"));
  final parameter Real heaExcAppDes(
    unit="K",
    displayUnit="K")=dat.dTAppEco_nominal
    "Design heat exchanger approach"
    annotation (Evaluate=true,
    Dialog(tab="General",group="Waterside economizer",
      enable=have_WSE));
  final parameter Boolean have_byPasValCon=cfg.typEco == Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithValve
    "True: chilled water flow through economizer is controlled using heat exchanger bypass valve"
    annotation (Dialog(group="Waterside economizer",
      enable=have_WSE));
  // ----- General: Chilled water pump ---
  final parameter Integer nChiWatPum=cfg.nPumChiWatPri
    "Total number of chilled water pumps"
    annotation (Dialog(tab="General",group="Chilled water pump"));
  final parameter Boolean have_heaChiWatPum=cfg.typArrPumChiWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Flag of headered chilled water pumps design: true=headered, false=dedicated"
    annotation (Dialog(tab="General",group="Chilled water pump"));
  final parameter Boolean have_locSenChiWatPum=not cfg.have_senDpChiWatRemWir
    "True: there is local differential pressure sensor hardwired to the plant controller"
    annotation (Dialog(tab="General",group="Chilled water pump"));
  final parameter Integer nSenChiWatPum=cfg.nSenDpChiWatRem
    "Total number of remote differential pressure sensors hardwired to the plant controller"
    annotation (Dialog(tab="General",group="Chilled water pump"));
  // ---- General: Condenser water pump ----
  final parameter Integer nConWatPum=cfg.nPumConWat
    "Total number of condenser water pumps"
    annotation (Dialog(tab="General",group="Condenser water pump"));
  final parameter Boolean have_fixSpeConWatPum=not cfg.have_pumConWatVar
    "True: the plant has fixed speed condenser water pumps. When the plant has waterside economizer, it must be false"
    annotation (Dialog(tab="General",group="Condenser water pump",
      enable=not have_WSE));
  final parameter Boolean have_heaConWatPum=cfg.typArrPumConWat == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "True: headered condenser water pumps"
    annotation (Dialog(tab="General",group="Condenser water pump"));
  // ---- General: Chiller staging settings ----
  final parameter Integer nStaChiOnl=if cfg.typEco == Buildings.Templates.Plants.Chillers.Types.Economizer.None
    then nSta - 1 else sum({if sta[i, nUniSta] > 0 then 0 else 1 for i in 1:nSta}) -
    1
    "Number of chiller stages, neither zero stage nor the stages with enabled waterside economizer is included"
    annotation (Evaluate=true,
    Dialog(tab="General",group="Staging configuration"));
  final parameter Integer totSta=nSta
    "Total number of plant stages, including stage zero and the stages with a WSE, if applicable"
    annotation (Evaluate=true,
    Dialog(tab="General",group="Staging configuration"));
  // FIXME #2299: This should be refactored, see details in the PR page.
  // How can we specify that chillers are interchangeable (as opposed to required to run at a given stage) and should be lead/lag alternated?
  final parameter Integer staMat[nStaChiOnl, cfg.nChi](
    each fixed=false)
    "Staging matrix with chiller stage as row index and chiller as column index"
    annotation (Dialog(tab="General",group="Staging configuration"));
  final parameter Real desChiNum[nStaChiOnl + 1]={if i == 0 then 0 else sum(
    staMat[i]) for i in 0:nStaChiOnl}
    "Design number of chiller that should be ON at each chiller stage, including the zero stage"
    annotation (Dialog(tab="General",group="Staging configuration"));
  final parameter Real staTmp[nSta, nUniSta]={{if sta[i, j] > 0 then (if j <= cfg.nChi
    then sta[i, j] else 0.5) else 0 for j in 1:nUniSta} for i in 1:nSta}
    "Intermediary parameter to compute staVec"
    annotation (Dialog(tab="General",group="Staging configuration"));
  final parameter Real staVec[nSta]={sum(staTmp[i]) for i in 1:nSta}
    "Plant stage vector, element value like x.5 means chiller stage x plus WSE"
    annotation (Dialog(tab="General",group="Staging configuration"));
  // FIXME #2299: Should only be enabled in case of water-cooled plants with variable speed condenser pumps.
  final parameter Real desConWatPumSpe[nSta](
    final min=fill(0, nSta),
    final max=fill(1, nSta))=dat.yPumConWatSta_nominal
    "Design condenser water pump speed setpoints, according to current chiller stage and WSE status"
    annotation (Dialog(tab="General",group="Staging configuration"));
  // FIXME #2299: For dedicated CW pumps this should be a 2-D array [nSta, nPumConWat] which is more aligned with §5.20.9.6.
  final parameter Real desConWatPumNum[nSta]=dat.yPumConWatSta_nominal
    "Design number of condenser water pumps that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(tab="General",group="Staging configuration"));
  final parameter Real towCelOnSet[nSta]=dat.staCoo
    "Design number of tower fan cells that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(tab="General",group="Staging configuration"));
  // ---- General: Cooling tower ----
  final parameter Integer nTowCel=cfg.nCoo
    "Total number of cooling tower cells"
    annotation (Dialog(tab="General",group="Cooling tower"));
  final parameter Real cooTowAppDes(
    unit="K",
    displayUnit="K")=dat.dTAppCoo_nominal
    "Design cooling tower approach"
    annotation (Evaluate=true,
    Dialog(tab="General",group="Cooling tower"));
  // ---- Plant enable ----
  // FIXME #2299: This should be a software point (input connector), not a parameter.
  // Currently disabled.
  parameter Real schTab[4, 2]=[
    0, 1;
    6 * 3600, 1;
    19 * 3600, 1;
    24 * 3600, 1]
    "Plant enabling schedule allowing operators to lock out the plant during off-hour"
    annotation (Dialog(tab="Plant enable",
      enable=false));
  final parameter Real TChiLocOut(
    final unit="K",
    displayUnit="degC")=dat.TOutChiWatLck
    "Outdoor air lockout temperature below which the chiller plant should be disabled"
    annotation (Dialog(tab="Plant enable"));
  // ---- Waterside economizer ----
  final parameter Real TOutWetDes(
    final unit="K",
    displayUnit="degC")=dat.TWetBulCooEnt_nominal
    "Design outdoor air wet bulb temperature"
    annotation (Evaluate=true,
    Dialog(tab="Waterside economizer",group="Design parameters"));
  final parameter Real VHeaExcDes_flow(
    final unit="m3/s")=dat.VChiWatEco_flow_nominal
    "Design heat exchanger chilled water volume flow rate"
    annotation (Evaluate=true,
    Dialog(tab="Waterside economizer",group="Design parameters"));
  final parameter Real dpDes=dat.dpChiWatEco_nominal
    "Design pressure difference across the chilled water side economizer"
    annotation (Dialog(tab="Waterside economizer",group="Valve or pump control"));
  // ---- Head pressure ----
  final parameter Real minConWatPumSpe(
    final unit="1")=dat.yPumConWat_min
    "Minimum condenser water pump speed"
    annotation (Dialog(enable=not
                                 ((not have_WSE) and
                                                    have_fixSpeConWatPum),tab=
    "Head pressure",group="Limits"));
  final parameter Real minHeaPreValPos(
    final unit="1")=dat.yValConWatChiIso_min
    "Minimum head pressure control valve position"
    annotation (Dialog(enable=(not
                                  ((not have_WSE) and
                                                     (not have_fixSpeConWatPum))),tab=
    "Head pressure",group="Limits"));
  // ---- Minimum flow bypass ----
  final parameter Real minFloSet[cfg.nChi](
    each final unit="m3/s")=dat.VChiWatChi_flow_min
    "Minimum chilled water flow through each chiller"
    annotation (Dialog(tab="Minimum flow bypass",group="Flow limits"));
  final parameter Real maxFloSet[cfg.nChi](
    each final unit="m3/s")=dat.VChiWatChi_flow_nominal
    "Maximum chilled water flow through each chiller"
    annotation (Dialog(tab="Minimum flow bypass",group="Flow limits"));
  // ---- Chilled water pumps ----
  // FIXME #2299: Dependency to stage and plant configuration not addressed.
  final parameter Real minChiWatPumSpe(
    unit="1")=dat.yPumChiWatPri_min
    "Minimum pump speed"
    annotation (Dialog(tab="Chilled water pumps",group="Speed controller"));
  // FIXME #2299: Dependency to stage and plant configuration not addressed.
  final parameter Real maxChiWatPumSpe(
    unit="1")=1
    "Maximum pump speed"
    annotation (Dialog(tab="Chilled water pumps",group="Speed controller"));
  final parameter Integer nPum_nominal(
    final max=nChiWatPum,
    final min=1)=dat.cfg.nPumChiWatPri
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(tab="Chilled water pumps",group="Nominal conditions"));
  // FIXME #2299: Dependency to plant configuration not addressed.
  final parameter Real VChiWat_flow_nominal(
    unit="m3/s")=dat.VChiWatPri_flow_nominal
    "Total plant design chilled water flow rate"
    annotation (Dialog(tab="Chilled water pumps",group="Nominal conditions"));
  final parameter Real maxLocDp(
    unit="Pa")=dat.dpChiWatLocSet_max
    "Maximum chilled water loop local differential pressure setpoint"
    annotation (Dialog(tab="Chilled water pumps",group=
      "Pump speed control when there is local DP sensor"));
  // ---- Plant reset ----
  final parameter Real dpChiWatMin[nSenChiWatPum](
    each final unit="Pa",
    each displayUnit="Pa")=dat.dpChiWatRemSet_min
    "Minimum chilled water differential pressure setpoint, the array size equals to the number of remote pressure sensor"
    annotation (Dialog(tab="Plant Reset",group="Chilled water supply"));
  final parameter Real dpChiWatMax[nSenChiWatPum](
    each final unit="Pa",
    each displayUnit="Pa")=dat.dpChiWatRemSet_max
    "Maximum chilled water differential pressure setpoint, the array size equals to the number of remote pressure sensor"
    annotation (Dialog(tab="Plant Reset",group="Chilled water supply"));
  final parameter Real TPlaChiWatSupMax(
    final unit="K",
    displayUnit="degC")=dat.TChiWatSup_max
    "Maximum chilled water supply temperature setpoint used in plant reset logic"
    annotation (Dialog(tab="Plant Reset",group="Chilled water supply"));
  // ---- Cooling tower: fan speed ----
  final parameter Real fanSpeMin(
    unit="1")=dat.yFanCoo_min
    "Minimum tower fan speed"
    annotation (Dialog(tab="Cooling Towers",group="Fan speed"));
  // Fan speed control: controlling condenser return water temperature when WSE is not enabled
  final parameter Real TConWatSup_nominal[cfg.nChi](
    each final unit="K",
    each displayUnit="degC")=dat.TConWatSupChi_nominal
    "Condenser water supply temperature (condenser entering) of each chiller"
    annotation (Evaluate=true,
    Dialog(tab="Cooling Towers",group="Fan speed: Return temperature control"));
  final parameter Real TConWatRet_nominal[cfg.nChi](
    each final unit="K",
    each displayUnit="degC")=dat.TConWatRetChi_nominal
    "Condenser water return temperature (condenser leaving) of each chiller"
    annotation (Evaluate=true,
    Dialog(tab="Cooling Towers",group="Fan speed: Return temperature control"));
  // ---- Cooling tower: Water level control ----
  // FIXME #2299: Should be homogenous to [m].
  final parameter Real watLevMin(
    unit="1")=dat.hLevCoo_min / dat.hLevAlaCoo_max
    "Minimum cooling tower water level recommended by manufacturer"
    annotation (Dialog(tab="Cooling Towers",group="Makeup water"));
  // FIXME #2299: Should be homogenous to [m].
  final parameter Real watLevMax(
    unit="1")=dat.hLevCoo_max / dat.hLevAlaCoo_max
    "Maximum cooling tower water level recommended by manufacturer"
    annotation (Dialog(tab="Cooling Towers",group="Makeup water"));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Controller ctl(
    final nChi=cfg.nChi,
    final closeCoupledPlant=closeCoupledPlant,
    final have_ponyChiller=have_ponyChiller,
    final need_reduceChillerDemand=need_reduceChillerDemand,
    final chiTyp=chiTyp,
    final schTab=schTab,
    final have_parChi=have_parChi,
    final chiDesCap=chiDesCap,
    final chiMinCap=chiMinCap,
    final TChiWatSupMin=TChiWatSupMin,
    final have_heaPreConSig=have_heaPreConSig,
    final have_WSE=have_WSE,
    final heaExcAppDes=heaExcAppDes,
    final have_byPasValCon=have_byPasValCon,
    final nChiWatPum=nChiWatPum,
    final have_heaChiWatPum=have_heaChiWatPum,
    final have_locSenChiWatPum=have_locSenChiWatPum,
    final nSenChiWatPum=nSenChiWatPum,
    final nConWatPum=nConWatPum,
    final have_fixSpeConWatPum=have_fixSpeConWatPum,
    final have_heaConWatPum=have_heaConWatPum,
    final nSta=nStaChiOnl,
    final totSta=nSta,
    final staMat=staMat,
    final desChiNum=desChiNum,
    final staVec=staVec,
    final desConWatPumSpe=desConWatPumSpe,
    final desConWatPumNum=desConWatPumNum,
    final towCelOnSet=towCelOnSet,
    final nTowCel=nTowCel,
    final cooTowAppDes=cooTowAppDes,
    final TChiLocOut=TChiLocOut,
    final TOutWetDes=TOutWetDes,
    final VHeaExcDes_flow=VHeaExcDes_flow,
    final dpDes=dpDes,
    final minConWatPumSpe=minConWatPumSpe,
    final minHeaPreValPos=minHeaPreValPos,
    final minFloSet=minFloSet,
    final maxFloSet=maxFloSet,
    final minChiWatPumSpe=minChiWatPumSpe,
    final maxChiWatPumSpe=maxChiWatPumSpe,
    final nPum_nominal=nPum_nominal,
    final VChiWat_flow_nominal=VChiWat_flow_nominal,
    final maxLocDp=maxLocDp,
    final dpChiWatMin=dpChiWatMin,
    final dpChiWatMax=dpChiWatMax,
    final TPlaChiWatSupMax=TPlaChiWatSupMax,
    final fanSpeMin=fanSpeMin,
    final minChiLif=minChiLif,
    final TConWatSup_nominal=TConWatSup_nominal,
    final TConWatRet_nominal=TConWatRet_nominal,
    final watLevMin=watLevMin,
    final watLevMax=watLevMax)
    "Plant controller"
    annotation (Placement(transformation(extent={{0,-40},{20,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant RFE_uHeaPreCon[cfg.nChi](
    each k=0)
    "Add chiller head pressure control demand signal from onboard chiller controller"
    annotation (Placement(transformation(extent={{-140,-270},{-120,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uChiAva[cfg.nChi](each k=true)
    "Boiler available signal – Implementation does not handle fault detection yet"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Templates.Components.Controls.StatusEmulator
                                                      FIXME_uChiHeaCon[cfg.nChi]
    "#2299: This signal should be internally computed by the stage up and down sequences"
    annotation (Placement(transformation(extent={{20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant RFE_watLev(
    k=0.1) "Add tower basin model with water level and heating demand signal"
    annotation (Placement(transformation(extent={{-100,-270},{-80,-250}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum FIXME_yChiPumSpe(
    final k=fill(1 / cfg.nPumChiWatPri, cfg.nPumChiWatPri),
    final nin=cfg.nPumChiWatPri)
    if cfg.have_pumChiWatPriVar
    "#2299 Should be scalar and conditional"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum FIXME_yTowFanSpe(
    final k=fill(1 / cfg.nCoo, cfg.nCoo),
    final nin=cfg.nCoo)
    "#2299 Should be scalar and conditional"
    annotation (Placement(transformation(extent={{50,-100},{70,-80}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator FIXME_TChiWatSupSet(
    final nout=cfg.nChi)
    "#2299 Should be vectorial (typ. each chiller)"
    annotation (Placement(transformation(extent={{50,18},{70,38}})));
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
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_yValChiWatChiByp(
    final k=false)
    if cfg.have_valChiWatChiBypPar
    "#2299 For primary-only parallel chiller plants with WSE, missing logic for chiller bypass valve"
    annotation (Placement(transformation(extent={{50,-130},{70,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis FIXME_y1ValConWatIso(
    uLow=0.1,
    uHigh=0.2)
    if cfg.typEco <> Buildings.Templates.Plants.Chillers.Types.Economizer.None
    "#2299 Should be Boolean"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax FIXME_yConWatPumSpe(
    final nin=nConWatPum)
    if cfg.typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
      and cfg.typArrPumConWat == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "#2299 Should be scalar in case of headered CW pumps"
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis FIXME_yTowCelIsoVal[cfg.nCoo](
    each uLow=0.1, each uHigh=0.2)
    if cfg.typValCooInlIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    or cfg.typValCooOutIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "#2299 Should be Boolean and conditional to a configuration parameter"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Templates.Plants.Controls.Utilities.PlaceholderReal FIXME_uFanSpe(
    u_internal=0)
    "#2299: This should be the commanded speed `ySpeSet` computed internally"
    annotation (Placement(transformation(extent={{20,-150},{0,-130}})));
  Buildings.Templates.Plants.Controls.Utilities.PlaceholderReal FIXME_uConWatPumSpe[cfg.nPumConWat](
    each u_internal=0)
    "#2299: Should be the commanded speed output from subcontroller."
    annotation (Placement(transformation(extent={{20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply
                                         FIXME_uChiLoa[cfg.nChi]
    "#2299: The chiller load (𝑄𝑟𝑒𝑞𝑢𝑖𝑟𝑒𝑑) shall be internally calculated by the controller"
    annotation (Placement(transformation(extent={{-150,190},{-130,210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yChi_actual[cfg.nChi]
    "Convert chiller status to real"
    annotation (Placement(transformation(extent={{-190,190},{-170,210}})));
  Modelica.Blocks.Sources.RealExpression loaChiDivChiOn[cfg.nChi](each y=if
        Modelica.Math.BooleanVectors.anyTrue(yChi_actual.u) then ctl.staSetCon.yCapReq
        /sum(yChi_actual.y) else 0)
    "Chiller load divided by number of running chillers"
    annotation (Placement(transformation(extent={{-190,160},{-170,180}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal FIXME_uIsoVal[cfg.nCoo]
    "#2299 Should be Boolean + missing dependency to plant configuration"
    annotation (Placement(transformation(extent={{-190,-150},{-170,-130}})));
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
  connect(busChi.y1_actual, ctl.uChi);
  connect(bus.TChiWatEcoAft, ctl.TChiWatRetDow);
  /* FIXME #2299: In G36 controller there is only one input point TChiWatRet
  which is both used for WSE control (as TChiWatEcoBef) and capacity requirement.
  The use of TChiWatEcoBef for capacity requirement in primary-only plants is incorrect.
  */
  if cfg.typEco <> Buildings.Templates.Plants.Chillers.Types.Economizer.None
    then
    connect(bus.TChiWatEcoBef, ctl.TChiWatRet);
  else
    connect(bus.TChiWatPlaRet, ctl.TChiWatRet);
  end if;
  connect(bus.TConWatSup, ctl.TConWatSup);
  connect(bus.TChiWatPriSup, ctl.TChiWatSup);
  connect(bus.dpChiWatEco, ctl.dpChiWat);
  connect(bus.pumConWat.y1_actual, ctl.uConWatPum);
  connect(busValChiWatChiIso.y_actual, ctl.uChiWatIsoVal);
  // HACK Dymola does not automatically remove the clause at translation.
  if cfg.typEco == Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithPump
    then
    connect(bus.pumChiWatEco.y1_actual, ctl.uEcoPum);
  end if;
  connect(bus.TChiWatEcoEnt, ctl.TEntHex);
  connect(bus.TOut, ctl.TOut);
  connect(busCoo.y1_actual, ctl.uTowSta);
  connect(busValChiWatChiIso.y_actual, ctl.uChiWatIsoVal);
  connect(RFE_uHeaPreCon.y, ctl.uHeaPreCon);
  connect(RFE_watLev.y, ctl.watLev);
  connect(bus.VChiWatPri_flow, ctl.VChiWat_flow);
  connect(bus.TOut, ctl.TOut);
  connect(bus.phiOut, ctl.phi);
  connect(bus.TConWatRet, ctl.TConWatRet);

  // Controller outputs
  connect(ctl.TChiWatSupSet, bus.TChiWatSupSet);
  connect(ctl.yMinValPosSet, bus.valChiWatMinByp.y);
  connect(ctl.yChiWatIsoVal, busValChiWatChiIso.y);
  connect(ctl.yConWatIsoVal, busValConWatChiIso.y);
  connect(ctl.y1ConWatIsoVal, busValConWatChiIso.y1);
  connect(ctl.yWseRetVal, bus.valChiWatEcoByp.y);
  connect(ctl.yWsePumOn, bus.pumChiWatEco.y1);
  connect(ctl.yWsePumSpe, bus.pumChiWatEco.y);
  connect(FIXME_TChiWatSupSet.y, busChi.TSet);
  connect(ctl.yChiWatPum, bus.pumChiWatPri.y1);
  connect(FIXME_yChiPumSpe.y, bus.pumChiWatPri.y);
  connect(ctl.yChi, busChi.y1);
  connect(ctl.yConWatPum, bus.pumConWat.y1);
  connect(FIXME_yConWatPumSpe.y, bus.pumConWat.y);
  connect(FIXME_yTowFanSpe.y, bus.yCoo);
  connect(ctl.yTowCel, bus.y1Coo);
  connect(FIXME_yTowCelIsoVal.y, busValCooInlIso.y1);
  connect(FIXME_yTowCelIsoVal.y, busValCooOutIso.y1);
  connect(FIXME_yValChiWatChiByp.y, bus.valChiWatChiByp.y1);
  connect(FIXME_y1ValConWatIso.y, bus.valConWatEcoIso.y1);
  /* Control point connection - stop */
  connect(ctl.yChiPumSpe, FIXME_yChiPumSpe.u)
    annotation (Line(points={{22,22},{42,22},{42,0},{48,0}},        color={0,0,127}));
  connect(ctl.yTowFanSpe, FIXME_yTowFanSpe.u)
    annotation (Line(points={{22,-24},{36,-24},{36,-90},{48,-90}},  color={0,0,127}));
  connect(ctl.TChiWatSupSet, FIXME_TChiWatSupSet.u)
    annotation (Line(points={{22,28},{48,28}},                  color={0,0,127}));
  connect(reqPlaChiWat.y, ctl.chiPlaReq)
    annotation (Line(points={{168,154},{-18,154},{-18,-16},{-2,-16}},color={255,127,0}));
  connect(reqResChiWat.y, ctl.TChiWatSupResReq)
    annotation (Line(points={{168,114},{-16,114},{-16,-14},{-2,-14}},    color={255,127,0}));
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
  connect(ctl.yEcoConWatIsoVal, FIXME_y1ValConWatIso.u)
    annotation (Line(points={{22,39},{40,39},{40,60},{48,60}},        color={0,0,127}));
  connect(ctl.yConWatPumSpe, FIXME_yConWatPumSpe.u)
    annotation (Line(points={{22,6},{40,6},{40,-30},{48,-30}},
      color={0,0,127}));
  connect(uChiAva.y, ctl.uChiAva) annotation (Line(points={{-38,0},{-20,0},{-20,
          -3},{-2,-3}}, color={255,0,255}));
  connect(ctl.yTowCelIsoVal, FIXME_yTowCelIsoVal.u) annotation (Line(points={{22,
          -18},{38,-18},{38,-60},{48,-60}}, color={0,0,127}));
  connect(FIXME_yTowFanSpe.y, FIXME_uFanSpe.u) annotation (Line(points={{72,-90},
          {80,-90},{80,-140},{22,-140}}, color={0,0,127}));
  connect(FIXME_uFanSpe.y, ctl.uFanSpe) annotation (Line(points={{-2,-140},{-20,
          -140},{-20,-30},{-2,-30}}, color={0,0,127}));
  connect(ctl.yConWatPumSpe, FIXME_uConWatPumSpe.u) annotation (Line(points={{22,
          6},{40,6},{40,-100},{22,-100}}, color={0,0,127}));
  connect(FIXME_uConWatPumSpe.y, ctl.uConWatPumSpe) annotation (Line(points={{-2,
          -100},{-18,-100},{-18,-20},{-2,-20}}, color={0,0,127}));
  connect(FIXME_uChiLoa.y, ctl.uChiCooLoa) annotation (Line(points={{-128,200},{
          -22,200},{-22,-26},{-2,-26}},
                                    color={0,0,127}));
  connect(FIXME_uChiLoa.y, ctl.uChiLoa) annotation (Line(points={{-128,200},{-22,
          200},{-22,2},{-2,2}}, color={0,0,127}));
  connect(busChi.y1_actual, yChi_actual.u) annotation (Line(
      points={{-240,200},{-192,200}},
      color={255,204,51},
      thickness=0.5));
  connect(yChi_actual.y, FIXME_uChiLoa.u1) annotation (Line(points={{-168,200},{
          -160,200},{-160,206},{-152,206}}, color={0,0,127}));
  connect(loaChiDivChiOn.y, FIXME_uChiLoa.u2) annotation (Line(points={{-169,170},
          {-160,170},{-160,194},{-152,194}}, color={0,0,127}));
  connect(busValCooInlIso.y1_actual, FIXME_uIsoVal.u) annotation (Line(
      points={{-240,-140},{-192,-140}},
      color={255,204,51},
      thickness=0.5));
  connect(FIXME_uIsoVal.y, ctl.uIsoVal) annotation (Line(points={{-168,-140},{-22,
          -140},{-22,-34},{-2,-34}}, color={0,0,127}));
  connect(ctl.y1ConWatIsoVal, FIXME_uChiHeaCon.y1) annotation (Line(points={{22,
          13},{34,13},{34,-60},{22,-60}}, color={255,0,255}));
  connect(FIXME_uChiHeaCon.y1_actual, ctl.uChiHeaCon) annotation (Line(points={
          {-2,-60},{-14,-60},{-14,-10},{-2,-10}}, color={255,0,255}));
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
<h4>Details</h4>
<p>
To be updated.
</p>
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
