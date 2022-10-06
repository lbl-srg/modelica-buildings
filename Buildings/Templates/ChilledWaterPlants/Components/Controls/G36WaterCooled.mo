within Buildings.Templates.ChilledWaterPlants.Components.Controls;
block G36WaterCooled
  "Guideline 36 controller for CHW plant with water-cooled chillers"
  extends Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialController(
    final typ=Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36);

  parameter Boolean closeCoupledPlant=false
    "True: the plant is close coupled, i.e. the pipe length from the chillers to cooling towers does not exceed approximately 100 feet"
    annotation (Dialog(tab="General"));

  // ---- General: Chiller configuration ----

  parameter Boolean have_ponyChiller=false
    "True: have pony chiller"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  // FIXME: #2299 Incorrect description and usage of this parameter.
  parameter Boolean need_reduceChillerDemand=false
    "True: need limit chiller demand when chiller staging"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  // FIXME: #2299
  final parameter Real desCap(unit="W")=sum(dat.capChi_nominal)
    "Plant design capacity"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Integer chiTyp[nChi]={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal}
    "Chiller type. Recommended staging order: positive displacement, variable speed centrifugal, constant speed centrifugal"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Real capChi_min[nChi](each final unit="W", each final min=0)=
    0.3 .* dat.capChi_nominal
    "Chiller minimum cycling load"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Boolean have_ctrHeaPre = false
    "Set to true if head pressure control available from chiller controller"
    annotation(Dialog(tab="General", group="Chillers configuration",
      enable=not isAirCoo));

  final parameter Boolean anyVsdCen = Modelica.Math.BooleanVectors.anyTrue({
    chiTyp[i]==Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal
    for i in 1:nChi})
    "Set to true if the plant has at least one variable speed centrifugal chiller"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  // ---- General: Chiller staging settings ----

  parameter Integer nSta = 2
    "Number of chiller stages, neither zero stage nor the stages with enabled waterside economizer is included"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Integer totSta=6
    "Total number of plant stages, including stage zero and the stages with a Waterside Economizer, if applicable"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Integer staMat[nSta, nChi] = {{1,0},{1,1}}
    "Staging matrix with chiller stage as row index and chiller as column index"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Real desChiNum[nSta+1]={0,1,2}
    "Design number of chiller that should be ON at each chiller stage, including the zero stage"
    annotation (Dialog(tab="General", group="Staging configuration", enable=have_fixSpeConWatPum));

  parameter Real staVec[totSta]={0,0.5,1,1.5,2,2.5}
    "Plant stage vector, element value like x.5 means chiller stage x plus Waterside Economizer"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Real desConWatPumSpe[totSta](
    final min=fill(0, totSta),
    final max=fill(1, totSta)) = {0,0.5,0.75,0.6,0.75,0.9}
    "Design condenser water pump speed setpoints, according to current chiller stage and Waterside Economizer status"
    annotation (Dialog(tab="General", group="Staging configuration",
      enable=not isAirCoo));

  parameter Real desConWatPumNum[totSta]={0,1,1,2,2,2}
    "Design number of condenser water pumps that should be ON, according to current chiller stage and Waterside Economizer status"
    annotation (Dialog(tab="General", group="Staging configuration",
      enable=not isAirCoo));

  parameter Real towCelOnSet[totSta]={0,2,2,4,4,4}
    "Design number of tower fan cells that should be ON, according to current chiller stage and Waterside Economizer status"
    annotation(Dialog(tab="General", group="Staging configuration",
      enable=not isAirCoo));

  // ---- General: Cooling tower ----

  final parameter Modelica.Units.SI.Temperature dTAppTow_nominal(displayUnit="K", final min=0)=
    cooTowSec.dTApp_nominal
    "Design cooling tower approach"
    annotation(Evaluate=true, Dialog(tab="General", group="Cooling tower"));

  // ---- Plant enable ----

  parameter Real schTab[4,2] = [0,1; 6*3600,1; 19*3600,1; 24*3600,1]
    "Plant enabling schedule allowing operators to lock out the plant during off-hour"
    annotation(Dialog(tab="Plant enable"));

  // ---- Waterside economizer ----

  /*
  FIXME: Those parameters should be declared in the interface class
  Buildings.Templates.ChilledWaterPlant.Components.Economizer.Interfaces.PartialEconomizer
  and accessed with inner/outer reference.
  */
  parameter Modelica.Units.SI.Temperature dTAppEco_nominal(displayUnit="K", final min=0)=2
    "Design heat exchanger approach"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Design parameters", enable=have_eco));

  parameter Real VHeaExcDes_flow(unit="m3/s")=0.015
    "Desing heat exchanger chilled water volume flow rate"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Design parameters", enable=have_eco));

  parameter Integer nPum_nominal(final max=nPumPri, final min=1) = nPumPri
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(tab="Chilled water pumps", group="Nominal conditions"));

  // ---- Staging setpoints ----

  parameter Real posDisMult(unit="1")=0.8
    "Positive displacement chiller type staging multiplier"
    annotation (Dialog(tab="Staging", group="Staging part load ratio"));

  parameter Real conSpeCenMult(unit="1")=0.9
    "Constant speed centrifugal chiller type staging multiplier"
    annotation (Dialog(tab="Staging", group="Staging part load ratio"));

  parameter Real anyOutOfScoMult(unit="1")=0.9
    "Outside of G36 recommended staging order chiller type SPLR multiplier"
    annotation(Evaluate=true, __cdl(ValueInReference=False), Dialog(tab="Staging", group="Staging part load ratio"));

  parameter Real varSpeStaMin(unit="1")=0.45
    "Minimum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen, tab="Staging", group="Staging part load ratio"));

  parameter Real varSpeStaMax(unit="1")=0.9
    "Maximum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen, tab="Staging", group="Staging part load ratio"));

  // ---- Staging up and down process ----

  parameter Real chiDemRedFac(unit="1")=0.75
    "Demand reducing factor of current operating chillers"
    annotation (Dialog(tab="Staging", group="Up and down process", enable=need_reduceChillerDemand));

  // ---- Cooling tower: Water level control ----
  parameter Real watLevMin(unit="1")=0.7
    "Minimum cooling tower water level recommended by manufacturer"
     annotation (Dialog(tab="Cooling Towers", group="Makeup water"));

  parameter Real watLevMax(unit="1")=1
    "Maximum cooling tower water level recommended by manufacturer"
    annotation (Dialog(tab="Cooling Towers", group="Makeup water"));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Controller ctr(
    final closeCoupledPlant=closeCoupledPlant,
    final nChi=nChi,
    final have_parChi=
      typArrChi==Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel,
    final have_ponyChiller=have_ponyChiller,
    final need_reduceChillerDemand=need_reduceChillerDemand,
    final desCap=desCap,
    final chiTyp=chiTyp,
    final chiDesCap=chiDesCap,
    final chiMinCap=chiMinCap,
    final TChiWatSupMin=TChiWatSupMin,
    final minChiLif=minChiLif,
    final have_heaPreConSig=have_heaPreConSig,
    final anyVsdCen=anyVsdCen,
    final have_WSE=have_WSE,
    final heaExcAppDes=heaExcAppDes,
    final have_byPasValCon=have_byPasValCon,
    final nChiWatPum=nChiWatPum,
    final have_heaChiWatPum=have_heaChiWatPum,
    final have_locSenChiWatPum=have_locSenChiWatPum,
    final nSenChiWatPum=nSenChiWatPum,
    final nConWatPum=nConWatPum,
    final have_fixSpeConWatPum=have_fixSpeConWatPum,
    final fixConWatPumSpe=fixConWatPumSpe,
    final have_heaConWatPum=have_heaConWatPum,
    final nSta=nSta,
    final totSta=totSta,
    final staMat=staMat,
    final desChiNum=desChiNum,
    final staVec=staVec,
    final desConWatPumSpe=desConWatPumSpe,
    final desConWatPumNum=desConWatPumNum,
    final towCelOnSet=towCelOnSet,
    final nTowCel=nTowCel,
    final cooTowAppDes=cooTowAppDes,
    final schTab=schTab,
    final TChiLocOut=TChiLocOut,
    final plaThrTim=plaThrTim,
    final reqThrTim=reqThrTim,
    final ignReq=ignReq,
    final holdPeriod=holdPeriod,
    final delDis=delDis,
    final TOffsetEna=TOffsetEna,
    final TOffsetDis=TOffsetDis,
    final TOutWetDes=TOutWetDes,
    final VHeaExcDes_flow=VHeaExcDes_flow,
    final step=step,
    final wseOnTimDec=wseOnTimDec,
    final wseOnTimInc=wseOnTimInc,
    final dpDes=dpDes,
    final ecoValCon=ecoValCon,
    final kEcoVal=kEcoVal,
    final TiEcoVal=TiEcoVal,
    final TdEcoVal=TdEcoVal,
    final minEcoSpe=minEcoSpe,
    final desEcoSpe=desEcoSpe,
    final minConWatPumSpe=minConWatPumSpe,
    final minHeaPreValPos=minHeaPreValPos,
    final controllerTypeHeaPre=controllerTypeHeaPre,
    final kHeaPreCon=kHeaPreCon,
    final TiHeaPreCon=TiHeaPreCon,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet,
    final maxFloSet=maxFloSet,
    final controllerTypeMinFloByp=controllerTypeMinFloByp,
    final kMinFloBypCon=kMinFloBypCon,
    final TiMinFloBypCon=TiMinFloBypCon,
    final TdMinFloBypCon=TdMinFloBypCon,
    final yMaxFloBypCon=yMaxFloBypCon,
    final yMinFloBypCon=yMinFloBypCon,
    final minChiWatPumSpe=minChiWatPumSpe,
    final maxChiWatPumSpe=maxChiWatPumSpe,
    final nPum_nominal=nPum_nominal,
    final VChiWat_flow_nominal=VChiWat_flow_nominal,
    final maxLocDp=maxLocDp,
    final controllerTypeChiWatPum=controllerTypeChiWatPum,
    final kChiWatPum=kChiWatPum,
    final TiChiWatPum=TiChiWatPum,
    final TdChiWatPum=TdChiWatPum,
    final holTim=holTim,
    final iniSet=iniSet,
    final minSet=minSet,
    final maxSet=maxSet,
    final delTim=delTim,
    final samplePeriod=samplePeriod,
    final numIgnReq=numIgnReq,
    final triAmo=triAmo,
    final resAmo=resAmo,
    final maxRes=maxRes,
    final dpChiWatPumMin=dpChiWatPumMin,
    final dpChiWatPumMax=dpChiWatPumMax,
    final TChiWatSupMax=TChiWatSupMax,
    final halSet=halSet,
    final avePer=avePer,
    final delayStaCha=delayStaCha,
    final parLoaRatDelay=parLoaRatDelay,
    final faiSafTruDelay=faiSafTruDelay,
    final effConTruDelay=effConTruDelay,
    final shortTDelay=shortTDelay,
    final longTDelay=longTDelay,
    final posDisMult=posDisMult,
    final conSpeCenMult=conSpeCenMult,
    final anyOutOfScoMult=anyOutOfScoMult,
    final varSpeStaMin=varSpeStaMin,
    final varSpeStaMax=varSpeStaMax,
    final smallTDif=smallTDif,
    final largeTDif=largeTDif,
    final faiSafTDif=faiSafTDif,
    final dpDif=dpDif,
    final TDif=TDif,
    final faiSafDpDif=faiSafDpDif,
    final effConSigDif=effConSigDif,
    final chiDemRedFac=chiDemRedFac,
    final holChiDemTim=holChiDemTim,
    final aftByPasSetTim=aftByPasSetTim,
    final waiTim=waiTim,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final proOnTim=proOnTim,
    final thrTimEnb=thrTimEnb,
    final fanSpeMin=fanSpeMin,
    final fanSpeMax=fanSpeMax,
    final intOpeCon=intOpeCon,
    final kIntOpeTowFan=kIntOpeTowFan,
    final TiIntOpeTowFan=TiIntOpeTowFan,
    final TdIntOpeTowFan=TdIntOpeTowFan,
    final chiWatConTowFan=chiWatConTowFan,
    final kWSETowFan=kWSETowFan,
    final TiWSETowFan=TiWSETowFan,
    final TdWSETowFan=TdWSETowFan,
    final LIFT_min=LIFT_min,
    final TConWatSup_nominal=TConWatSup_nominal,
    final TConWatRet_nominal=TConWatRet_nominal,
    final couPlaCon=couPlaCon,
    final kCouPla=kCouPla,
    final TiCouPla=TiCouPla,
    final TdCouPla=TdCouPla,
    final yCouPlaMax=yCouPlaMax,
    final yCouPlaMin=yCouPlaMin,
    final samplePeriodConTDiff=samplePeriodConTDiff,
    final supWatCon=supWatCon,
    final kSupCon=kSupCon,
    final TiSupCon=TiSupCon,
    final TdSupCon=TdSupCon,
    final ySupConMax=ySupConMax,
    final ySupConMin=ySupConMin,
    final iniPlaTim=iniPlaTim,
    final ramTim=ramTim,
    final cheMinFanSpe=cheMinFanSpe,
    final cheMaxTowSpe=cheMaxTowSpe,
    final cheTowOff=cheTowOff,
    final chaTowCelIsoTim=chaTowCelIsoTim,
    final watLevMin=watLevMin,
    final watLevMax=watLevMax,
    final locDt=locDt,
    final hysDt=hysDt,
    final dpDifHys=dpDifHys,
    final relFloDif=relFloDif,
    final speChe=speChe)
    "Plant controller"
    annotation (Placement(transformation(extent={{0,-40},{20,20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_uChiConIsoVal[nChi](
      each k=true)
    "#2299 Chiller CW isolation valve open end switch status only used for FD + Should be DI or AI"
    annotation (Placement(transformation(extent={{-140,230},{-120,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uHeaPreCon[nChi](
      each k=0) "From built-in chiller controller: how should it be generated?"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uChiLoa[nChi](
      each k=1) "Should be computed internally, in J/s, not A."
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_uChiAva[nChi](each
      k=true)
    "Instead 2 input points should be declared for each chiller: Chiller Fault Code and Chiller local/auto switch?"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_uChiHeaCon[nChi](
      each k=true)
    "This signal should be internally computed by the stage up and down sequences"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uChiWatIsoVal[nChi](
      each k=1) "Should be optional and exclusive from `uChiIsoVal`"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant FIXME_TChiWatSupResReq(k=0)
    "That input should be conditional and another (conditional) array input is needed + Request not available from VAV controller"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant FIXME_chiPlaReq(k=0)
    "Request not available from VAV controller"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uConWatPumSpe[nPumCon](
    each k=1) "Should be computed internally"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uChiCooLoa[nChi](
    each k=1)
    "The chiller load (𝑄𝑟𝑒𝑞𝑢𝑖𝑟𝑒𝑑) shall be internally calculated by the controller based on §5.2.4.7"
    annotation (Placement(transformation(extent={{-100,-190},{-80,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uFanSpe(k=1)
    "This should be the commanded speed `ySpeSet` computed internally"
    annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uIsoVal[nCoo](
    each k=1)
    "#2299 Should be optional. If present, 2 (or 4 if both inlet and outlet valves are used) Boolean inputs should be present (as opposed to 1 real) for each tower (cell)"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_watLev(k=1)
    "How do we take that into account?"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_uTowSta[nCoo](
    each k=true) "Missing CT status in system model"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_yHeaPreConVal[nChi](
      each k=true)
    "Various configurations not covered: modulating in controller, 2-position in system model."
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator FIXME_TChiWatSupSet(
      nout=nChi)
    "System model should be refactored to use the same set point for all units"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_yTowCelIsoVal[nCoo](
      each k=true) "Should be Boolean and conditional to a configuration parameter"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uLifMin(
    k=dat.dTLif_min)
    "Unconnected inside input connector"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uLifMax(
    k=dat.TConWatRet_nominal - dat.TChiWatSup_nominal)
    "Unconnected inside input connector"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_uChiIsoVal[nChi](
      each k=true)
    "#2299 Chiller CHW isolation valve open end switch status only used for FD + Should be DI or AI"
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));
equation
  /* Control point connection - start */
  connect(bus.chi.y1ChiWatReq, ctr.uChiWatReq);
  connect(bus.chi.y1ConWatReq, ctr.uConWatReq);
  connect(bus.pumPri.uStaPumPri, ctr.uChiWatPum);
  connect(bus.dpChiWatLoc, ctr.dpChiWat_local);
  connect(bus.dpChiWatRem, ctr.dpChiWat_remote);
  connect(bus.pumPri.V_flow, ctr.VChiWat_flow);
  connect(bus.chi.sta, ctr.uChi);
  // FIXME: should be computed by controller.
  connect(bus.TWetAirOut, ctr.TOutWet);
  connect(bus.wse.TChiWatEcoLvg, ctr.TChiWatRetDow);
  // FIXME: ctrPla.TChiWatRet should be conditional to have_eco.
  // Another input is required for Plant Chilled Water return temperature.
  if have_eco then
    connect(bus.wse.TChiWatEcoEnt, ctr.TChiWatRet);
  else
    connect(bus.TPriRet, ctr.TChiWatRet);
  end if;
  connect(bus.TConWatRet, ctr.TConWatRet);
  // FIXME: busCon.pumPri.TPriSup should be renamed.
  connect(bus.pumPri.TPriSup, ctr.TChiWatSup);
  // FIXME: Rename uStaPumPri as "Pri" does not apply to condenser water pumps.
  connect(bus.uStaPumPri, ctr.uConWatPum);
  connect(bus.TAirOut, ctr.TOut);
  connect(bus.TConWatSup, ctr.TConWatSup);

  connect(FIXME_uHeaPreCon.y, ctr.uHeaPreCon);
  connect(FIXME_uChiLoa.y, ctr.uChiLoa);
  connect(FIXME_uChiAva.y, ctr.uChiAva);
  connect(FIXME_uChiHeaCon.y, ctr.uChiHeaCon);
  connect(FIXME_TChiWatSupResReq.y, ctr.TChiWatSupResReq);
  connect(FIXME_chiPlaReq.y, ctr.chiPlaReq);
  connect(FIXME_uConWatPumSpe.y, ctr.uConWatPumSpe);
  connect(FIXME_uChiCooLoa.y, ctr.uChiCooLoa);
  connect(FIXME_uFanSpe.y, ctr.uFanSpe);
  connect(FIXME_uIsoVal.y, ctr.uIsoVal);
  connect(FIXME_watLev.y, ctr.watLev);
  connect(FIXME_uChiIsoVal.y, ctr.uChiIsoVal);
  connect(FIXME_uChiConIsoVal.y, ctr.uChiConIsoVal);
  connect(FIXME_uChiWatIsoVal.y, ctr.uChiWatIsoVal);

  // Controller outputs
  connect(FIXME_TChiWatSupSet.y, bus.chi.TSet);

  // FIXME: System model should be refactored to use the same set point for all units.
  // Same holds for the control block.
  connect(ctr.yChiPumSpe, bus.pumPri.ySpe);

  // FIXME: System model does not have a variable for the chilled water pump on/off command.
  // connect(ctrPla.yChiWatPum, busCon.pumPri.y);

  // FIXME: Incorrect quantity, should have unit="1".
  // connect(ctrPla.yChiDem, busCon.yChiDem);

  connect(ctr.yChi, bus.chi.on);

  // FIXME: Should not be an output of ctrPla
  // connect(ctrPla.yHeaPreConValSta, busCon.yHeaPreConValSta);

  // FIXME: Missing configurations in controller and system model.
  connect(FIXME_yHeaPreConVal.y, bus.valConWatChiIso.y);

  // FIXME: Missing configurations in controller and system model.
  // For instance "a single common speed point is appropriate".
  connect(ctr.yConWatPumSpe, bus.ySpe);

  // FIXME: This is not an output per §4. LIST OF POINTS. Should be deleted.
  // connect(ctrPla.yChiWatMinFloSet, busCon.yChiWatMinFloSet);

  // FIXME: No on/off command for condenser water pumps in systme model.
  // connect(ctrPla.yConWatPum, busCon.y);

  // FIXME: Only modulating valve supported by controller.
  connect(ctr.yChiWatIsoVal, bus.valChiWatChiIso.y);

  // FIXME: Controller output does not exist in real life.
  // connect(ctrPla.yReaChiDemLim, busCon.yReaChiDemLim);

  // FIXME: Missing configurations in controller.
  connect(ctr.yMinValPosSet, bus.pumPri.valPriMinFloByp.y);

  // FIXME: This is not an output per §4. LIST OF POINTS. Should be deleted.
  // connect(ctrPla.yNumCel, busCon.yNumCel);

  connect(FIXME_yTowCelIsoVal.y, bus.valCooInlIso.y1);
  connect(FIXME_yTowCelIsoVal.y, bus.valCooOutIso.y1);

  connect(ctr.yTowFanSpe, bus.cooTow.yFan);

  // FIXME: CT start signal not implemented in system model.
  // connect(ctrPla.yTowCel, busCon.cooTow.yFan);

  // FIXME: Left unconnected for now. Shall we compute water use?
  // connect(ctrPla.yMakUp, busCon.cooTow.yMakUp);

  /* Control point connection - stop */

  connect(ctr.TChiWatSupSet, FIXME_TChiWatSupSet.u) annotation (Line(points={{22,
          11},{40,11},{40,20},{58,20}}, color={0,0,127}));
  annotation (Documentation(info="<html>

</html>"));
end G36WaterCooled;
