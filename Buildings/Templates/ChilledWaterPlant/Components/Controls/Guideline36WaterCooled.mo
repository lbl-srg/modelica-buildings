within Buildings.Templates.ChilledWaterPlant.Components.Controls;
block Guideline36WaterCooled
  "Guideline 36 controller for CHW plant with water-cooled chillers"
  extends Interfaces.PartialController(
    final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.Controller.Guideline36);

  parameter Boolean closeCoupledPlant=false
    "True: the plant is close coupled, i.e. the pipe length from the chillers to cooling towers does not exceed approximately 100 feet"
    annotation (Dialog(tab="General"));

  // ---- General: Chiller configuration ----
  parameter Boolean have_ponyChiller=false
    "True: have pony chiller"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Boolean need_reduceChillerDemand=false
    "True: need limit chiller demand when chiller staging"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Integer chiTyp[nChi]={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal}
    "Chiller type. Recommended staging order: positive displacement, variable speed centrifugal, constant speed centrifugal"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Real capChi_min[nChi](final unit="W", final min=0) = 0.3 .* capChi_nominal
    "Chiller minimum cycling load"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Modelica.Units.SI.TemperatureDifference dTLif_min(displayUnit="K")=
    if isAirCoo then 0 else
    dat.getReal(varName=id + ".control.lift.dTLif_min.value")
    "Minimum allowable lift at minimum load for chiller"
    annotation(Dialog(tab="General", group="Chillers configuration",
      enable=not have_heaPreConSig and not isAirCoo));

  parameter Boolean have_ctrHeaPre = false
    "Set to true if head pressure control available from chiller controller"
    annotation(Dialog(tab="General", group="Chillers configuration",
      enable=not isAirCoo));

  final parameter Boolean anyVsdCen = Modelica.Math.BooleanVectors.anyTrue({
    chiTyp[i]==Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal
    for i in 1:nChi})
    "Set to true if the plant has at least one variable speed centrifugal chiller"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  // ---- General: Condenser water pump ----

  /* FIXME: Currently same configuration (have_dedPum) for CW and CHW pumps.
  parameter Boolean have_heaConWatPum=true
    "True: headered condenser water pumps"
    annotation (Dialog(tab="General", group="Condenser water pump"));
    */

  // ---- General: Chiller staging settings ----

  parameter Integer nSta = 2
    "Number of chiller stages, neither zero stage nor the stages with enabled waterside economizer is included"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Integer totSta=6
    "Total number of plant stages, including stage zero and the stages with a WSE, if applicable"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Integer staMat[nSta, nChi] = {{1,0},{1,1}}
    "Staging matrix with chiller stage as row index and chiller as column index"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Real desChiNum[nSta+1]={0,1,2}
    "Design number of chiller that should be ON at each chiller stage, including the zero stage"
    annotation (Dialog(tab="General", group="Staging configuration", enable=have_fixSpeConWatPum));

  parameter Real staVec[totSta]={0,0.5,1,1.5,2,2.5}
    "Plant stage vector, element value like x.5 means chiller stage x plus WSE"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Real desConWatPumSpe[totSta](
    final min=fill(0, totSta),
    final max=fill(1, totSta)) = {0,0.5,0.75,0.6,0.75,0.9}
    "Design condenser water pump speed setpoints, according to current chiller stage and WSE status"
    annotation (Dialog(tab="General", group="Staging configuration",
      enable=not isAirCoo));

  parameter Real desConWatPumNum[totSta]={0,1,1,2,2,2}
    "Design number of condenser water pumps that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(tab="General", group="Staging configuration",
      enable=not isAirCoo));

  parameter Real towCelOnSet[totSta]={0,2,2,4,4,4}
    "Design number of tower fan cells that should be ON, according to current chiller stage and WSE status"
    annotation(Dialog(tab="General", group="Staging configuration",
      enable=not isAirCoo));

  // ---- General: Cooling tower ----

  final parameter Integer nCelTow = cooTow.nCel
    "Total number of cooling tower cells"
    annotation (Evaluate=true, Dialog(tab="General", group="Cooling tower"));

  final parameter Modelica.Units.SI.Temperature dTAppTow_nominal(displayUnit="K", final min=0)=
    cooTow.dTApp_nominal
    "Design cooling tower approach"
    annotation(Evaluate=true, Dialog(tab="General", group="Cooling tower"));

  // ---- Plant enable ----

  parameter Real schTab[4,2] = [0,1; 6*3600,1; 19*3600,1; 24*3600,1]
    "Plant enabling schedule allowing operators to lock out the plant during off-hour"
    annotation(Dialog(tab="Plant enable"));

  // ---- Waterside economizer ----

  /* 
  FIXME: Those parameters should be declared in the interface class 
  Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces.PartialReturnSection
  and accessed with inner/outer reference.
  */
  parameter Modelica.Units.SI.Temperature dTAppWSE_nominal(displayUnit="K", final min=0)=2
    "Design heat exchanger approach"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Design parameters", enable=have_WSE));

  parameter Real VHeaExcDes_flow(unit="m3/s")=0.015
    "Desing heat exchanger chilled water volume flow rate"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Design parameters", enable=have_WSE));

  // ---- Head pressure ----

  parameter Real yPumCW_min(final unit="1", final min=0, final max=1)=
    dat.getReal(varName=id + ".control.yPumCW_min.value")
    "Minimum CW pump speed ratio"
    annotation(Dialog(enable= not ((not have_WSE) and have_fixSpeConWatPum), tab="Head pressure", group="Limits"));

  parameter Real yValIsoCon_min(final unit="1", final min=0, final max=1)=
    dat.getReal(varName=id + ".control.yValIsoCon_min.value")
    "Minimum head pressure control valve opening ratio"
    annotation(Dialog(enable= (not ((not have_WSE) and (not have_fixSpeConWatPum))), tab="Head pressure", group="Limits"));

  // ---- Chilled water pumps ----

  parameter Real yPumCHW_min(final unit="1", final min=0, final max=1)=
    dat.getReal(varName=id + ".control.yPumCHW_min.value")
    "Minimum CHW pump speed ratio"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  parameter Integer nPum_nominal(
    final max=nPumPri,
    final min=1)=nPumPri
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

  // ---- Cooling tower: fan speed ----

  parameter Real fanSpeMin(unit="1")=0.1
    "Minimum tower fan speed"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed"));

  // Fan speed control: controlling condenser return water temperature when WSE is not enabled

  parameter Modelica.Units.SI.Temperature  TCWSup_nominal(displayUnit="degC")=
    if isAirCoo then 273.15 else
    dat.getReal(varName=id + ".control.TCWSup_nominal.value")
    "CW supply temperature of each chiller (identical for all chillers)"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control"));

  parameter Real TCWRet_nominal(displayUnit="degC")=
    if isAirCoo then 273.15 else
    dat.getReal(varName=id + ".control.TCWRet_nominal.value")
    "CW return temperature of each chiller (identical for all chillers)"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control"));

  // ---- Cooling tower: Water level control ----
  parameter Real watLevMin(unit="1")=0.7
    "Minimum cooling tower water level recommended by manufacturer"
     annotation (Dialog(tab="Cooling Towers", group="Makeup water"));

  parameter Real watLevMax(unit="1")=1
    "Maximum cooling tower water level recommended by manufacturer"
    annotation (Dialog(tab="Cooling Towers", group="Makeup water"));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Controller chiPlaCon(
    final closeCoupledPlant=closeCoupledPlant,
    final nChi=nChi,
    final have_parChi=have_parChi,
    final have_ponyChiller=have_ponyChiller,
    final need_reduceChillerDemand=need_reduceChillerDemand,
    final desCap=cap_nominal,
    final chiTyp=chiTyp,
    final chiDesCap=capChi_nominal,
    final chiMinCap=capChi_min,
    TChiWatSupMin=fill(TCHWSupSet_min, nChi),
    final minChiLif=dTLif_min,
    final have_heaPreConSig=have_ctrHeaPre,
    final anyVsdCen=anyVsdCen,
    final have_WSE=have_WSE,
    final heaExcAppDes=dTAppWSE_nominal,
    final nChiWatPum=nPumPri,
    final have_heaChiWatPum=not have_dedPum,
    final have_locSenChiWatPum=have_senDpCHWLoc,
    final nSenChiWatPum=nSenDpCHWRem,
    final nConWatPum=nPumCon,
    final have_fixSpeConWatPum=have_fixSpeConWatPum,
    final fixConWatPumSpe=fixConWatPumSpe,
    final have_heaConWatPum=not have_dedPum,
    final nSta=nSta,
    final totSta=totSta,
    final staMat=staMat,
    final desChiNum=desChiNum,
    final staVec=staVec,
    final desConWatPumSpe=desConWatPumSpe,
    final desConWatPumNum=desConWatPumNum,
    final towCelOnSet=towCelOnSet,
    final nTowCel=nCelTow,
    final cooTowAppDes=dTAppTow_nominal,
    final schTab=schTab,
    final TChiLocOut=TAirOutLoc,
    final TOutWetDes=cooTow.TAirInWB_nominal,
    final VHeaExcDes_flow=VHeaExcDes_flow,
    final minConWatPumSpe=yPumCW_min,
    final minHeaPreValPos=yValIsoCon_min,
    final minFloSet=mCHWChi_flow_min / 1000,
    final maxFloSet=mCHWChi_flow_nominal / 1000,
    final minChiWatPumSpe=yPumCHW_min,
    final nPum_nominal=nPum_nominal,
    final VChiWat_flow_nominal=mCHWPri_flow_nominal / 1000,
    final maxLocDp=dpCHWLoc_max,
    final triAmo=triAmo,
    final resAmo=resAmo,
    final maxRes=maxRes,
    final dpChiWatPumMax=dpCHWRem_max,
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
    final LIFT_min=fill(dTLif_min, nChi),
    final TConWatSup_nominal=TCWSup_nominal,
    final TConWatRet_nominal=TCWRet_nominal,
    final watLevMin=watLevMin,
    final watLevMax=watLevMax)
    "CHW plant controller"
    annotation (Placement(transformation(extent={{0,-40},{20,20}})));

    annotation(Dialog(tab="General", group="Chillers configuration"));
end Guideline36WaterCooled;
