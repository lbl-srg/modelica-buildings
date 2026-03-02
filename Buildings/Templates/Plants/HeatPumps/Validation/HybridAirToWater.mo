within Buildings.Templates.Plants.HeatPumps.Validation;
model HybridAirToWater "Validation of AWHP plant template"
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Main medium (common for CHW and HW)";
  parameter Boolean have_chiWat=true
    "Set to true if the plant provides CHW"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  inner parameter UserProject.Data.AllSystems datAll(pla(
      final cfg=pla.cfg,
      ctl(
        yPumHeaWatPriSet=1,
        yPumChiWatPriSet=1,
        staEquDouMod=[0,0,1; 1/2,1/2,1; 1,1,1],
        staEquSinMod=[1/2,1/2,0; 1,1,0; 1,1,1]),
      hp(
        mHeaWatHp_flow_nominal=0.5*datAll.pla.hp.capHeaHp_nominal/abs(datAll.pla.ctl.THeaWatSup_nominal
             - Buildings.Templates.Data.Defaults.THeaWatRetMed)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
        capHeaHp_nominal=1e6,
        mChiWatHp_flow_nominal=datAll.pla.hp.capCooHp_nominal/abs(datAll.pla.ctl.TChiWatSup_nominal
             - Buildings.Templates.Data.Defaults.TChiWatRet)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
        capCooHp_nominal=1e6)))
                          "Plant parameters"
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));
  parameter Modelica.Units.SI.PressureDifference dpTer_nominal(
    displayUnit="Pa")=3E4
    "Liquid pressure drop across terminal unit at design conditions";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    displayUnit="Pa")=dpTer_nominal
    "Terminal unit control valve pressure drop at design conditions";
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),
    Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Buildings.Templates.Components.Data.HeatPump datHpSHC(
    final cpHeaWat_default=hpSHC.cpHeaWat_default,
    final cpSou_default=hpSHC.cpSou_default,
    final typ=hpSHC.typ,
    final is_rev=hpSHC.is_rev,
    mChiWat_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal,
    dpChiWat_nominal(displayUnit="bar") = datAll.pla.hp.dpHeaWatHp_nominal,
    capCoo_nominal=datAll.pla.hp.capCooHp_nominal,
    TChiWatSup_nominal=datAll.pla.hp.TChiWatSupHp_nominal,
    TSouCoo_nominal=datAll.pla.hp.TSouCooHp_nominal,
    perHea=datAll.pla.hp.perHeaHp,
    perCoo=datAll.pla.hp.perCooHp,
    perSHC(
      fileNameHea=Modelica.Utilities.Files.loadResource(
          "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Heating.txt"),
      fileNameCoo=Modelica.Utilities.Files.loadResource(
          "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Cooling.txt"),
      fileNameShc=Modelica.Utilities.Files.loadResource(
          "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_SHC.txt")),
    mHeaWat_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal,
    dpHeaWat_nominal(displayUnit="bar") = datAll.pla.hp.dpHeaWatHp_nominal,
    capHea_nominal=datAll.pla.hp.capHeaHp_nominal,
    THeaWatSup_nominal=datAll.pla.hp.THeaWatSupHp_nominal,
    TSouHea_nominal=datAll.pla.hp.TSouHeaHp_nominal,
    dpSouWwHea_nominal(displayUnit="Pa"))
    "Simultaneous heating and cooling (SHC) air-to-water heat pump record"
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Outdoor conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-190,-20})));
  Buildings.Templates.Plants.HeatPumps.AirToWater pla(
    redeclare final package MediumHeaWat=Medium,
    cfg(have_fouPip=true),
    typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only,
    typTanHeaWat_select=Buildings.Templates.Components.Types.IntegrationPoint.None,
    typTanChiWat_select=Buildings.Templates.Components.Types.IntegrationPoint.None,
    ctl(
      cfg=pla.cfg,
      dat=pla.dat.ctl,
      is_typDis_override=true,
      typDis_override=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2,
      have_PumHeaWatSec_override=true,
      nPumHeaWatSec_override=pumHeaWatSec.nPum,
      nPumChiWatSec_override=pumChiWatSec.nPum,
      nAirHan=1,
      nEquZon=0),
    have_hrc_select=false,
    final dat=datAll.pla,
    final have_chiWat=have_chiWat,
    nHp=2,
    typPumHeaWatPri_select1=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
    final allowFlowReversal=allowFlowReversal,
    linearized=true,
    show_T=true,
    is_dpBalYPumSetCal=true)
    "Heat pump plant"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TDum(
    k=293.15,
    y(final unit="K",
      displayUnit="degC"))
    "Placeholder signal for request generator"
    annotation (Placement(transformation(extent={{-200,90},{-180,110}})));
  Fluid.Sensors.RelativePressure dpHeaWatRem[1](
    redeclare each final package Medium=Medium)
    "HW differential pressure at one remote location"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={140,-98})));
  Fluid.Sensors.RelativePressure dpChiWatRem[1](
    redeclare each final package Medium=Medium)
    if have_chiWat
    "CHW differential pressure at one remote location"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={140,-18})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests reqPlaRes(
    final heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
    final cooCoi=if have_chiWat then Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
      else Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.None)
    "Plant and reset request"
    annotation (Placement(transformation(extent={{140,62},{120,82}})));
  AirHandlersFans.Interfaces.Bus busAirHan
    "AHU control bus"
    annotation (Placement(transformation(extent={{-10,60},{30,100}}),
      iconTransformation(extent={{-340,-140},{-300,-100}})));
  Interfaces.Bus busPla "Plant control bus"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-370,-70},{-330,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratLoa(
    table=[
    0, 0, 0;
    5, 0, 0;
    7, 1, 0;
    10, 0.5, 0;
    14, 0, 0.6;
    16, 0, 1;
    18, 0, 0.6;
    22, 0.1, 0.1;
    24, 0, 0],
    timeScale=3600)
    "Fraction of design load – Index 1 for heating, 2 for cooling"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));
  Fluid.Sensors.MassFlowRate mChiWat_flow(
    redeclare final package Medium=Medium)
    if have_chiWat
    "CHW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={240,-20})));
  Fluid.Sensors.MassFlowRate mHeaWat_flow(
    redeclare final package Medium=Medium)
    "HW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={240,-100})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt[4]
    "Importance multiplier"
    annotation (Placement(transformation(extent={{50,70},{30,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[4](
    each k=10) "Request multiplier factor"
    annotation (Placement(transformation(extent={{90,110},{70,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant enaLoa(k=true)
    "Load enable"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipHeaWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mHeaWat_flow_nominal,
    final dp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max -
      max(datAll.pla.ctl.dpHeaWatRemSet_max))
    "Piping"
    annotation (Placement(transformation(extent={{130,-130},{110,-110}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipChiWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mChiWat_flow_nominal,
    final dp_nominal=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max -
      max(datAll.pla.ctl.dpChiWatRemSet_max))
    if have_chiWat
    "Piping"
    annotation (Placement(transformation(extent={{130,-50},{110,-30}})));
  Controls.Utilities.PlaceholderInteger ph[2](
    each final have_inp=have_chiWat,
    each final u_internal=0)
    "Placeholder value"
    annotation (Placement(transformation(extent={{90,74},{70,94}})));
  Buildings.Templates.Components.Loads.LoadTwoWayValve loaCoo(
    redeclare final package MediumLiq = Medium,
    final energyDynamics=energyDynamics,
    final typ=Buildings.Fluid.HydronicConfigurations.Types.Control.Cooling,
    final mLiq_flow_nominal=pla.mChiWat_flow_nominal,
    final dpTer_nominal=dpTer_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpBal1_nominal=datAll.pla.ctl.dpChiWatRemSet_max[1] - dpTer_nominal - dpValve_nominal,
    final TLiqEnt_nominal=pla.TChiWatSup_nominal,
    final TLiqLvg_nominal=pla.TChiWatRet_nominal,
    con(val(y_start=0)),
    loa(coi(show_T=true))) if have_chiWat
    "Cooling load"
    annotation (Placement(transformation(extent={{170,-10},{190,10}})));
  Buildings.Templates.Components.Loads.LoadTwoWayValve loaHea(
    redeclare final package MediumLiq = Medium,
    final energyDynamics=energyDynamics,
    final typ=Buildings.Fluid.HydronicConfigurations.Types.Control.Heating,
    final mLiq_flow_nominal=pla.mHeaWat_flow_nominal,
    final dpTer_nominal=dpTer_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpBal1_nominal=datAll.pla.ctl.dpHeaWatRemSet_max[1] - dpTer_nominal - dpValve_nominal,
    final TLiqEnt_nominal=pla.THeaWatSup_nominal,
    final TLiqLvg_nominal=pla.THeaWatRet_nominal,
    con(val(y_start=0)))                          "Heating load"
    annotation (Placement(transformation(extent={{170,-90},{190,-70}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volHeaWat(
    energyDynamics=energyDynamics,
    final m_flow_nominal=pla.mHeaWat_flow_nominal,
    V=Buildings.Templates.Data.Defaults.ratVLiqByCap*pla.capHea_nominal,
    redeclare package Medium = Medium,
    nPorts=2)                          "Fluid volume in distribution system"
    annotation (Placement(transformation(extent={{80,-80},{100,-100}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volChiWat(
    energyDynamics=energyDynamics,
    final m_flow_nominal=pla.mChiWat_flow_nominal,
    V=Buildings.Templates.Data.Defaults.ratVLiqByCap*pla.capCoo_nominal,
    redeclare package Medium = Medium,
    nPorts=2) if have_chiWat           "Fluid volume in distribution system"
    annotation (Placement(transformation(extent={{80,0},{100,-20}})));
  Fluid.FixedResistances.Junction junHWPriSup(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={pla.mHeaWat_flow_nominal,-pla.mHeaWat_flow_nominal,pla.mHeaWat_flow_nominal},
    dp_nominal={0,0,0})
    "Primary supply junction between 2-pipe and 4-pipe ASHPs"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Fluid.FixedResistances.Junction junHWPriRet(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={pla.mHeaWat_flow_nominal,-pla.mHeaWat_flow_nominal,-pla.mHeaWat_flow_nominal},
    dp_nominal={0,0,0})
    "Primary return junction between 2-pipe and 4-pipe ASHPs"
    annotation (Placement(transformation(extent={{-70,-130},{-90,-110}})));
  Buildings.Templates.Components.HeatPumps.AirToWaterSHC hpSHC(
    redeclare package MediumHeaWat = Medium,
    redeclare package MediumSou = Medium,
    is_rev=true,
    dat=datHpSHC)
    "4-pipe ASHP with simultaneous HW and CHW supply"
    annotation (Placement(transformation(extent={{-84,-200},{-64,-180}})));
  Fluid.FixedResistances.Junction junCHWPriSup(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={pla.mChiWat_flow_nominal,-pla.mChiWat_flow_nominal,pla.mChiWat_flow_nominal},
    dp_nominal={0,0,0})
    "Primary CHW supply junction between 2-pipe and 4-pipe ASHPs"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Fluid.FixedResistances.Junction junCHWPriRet(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={pla.mChiWat_flow_nominal,-pla.mChiWat_flow_nominal,-pla.mChiWat_flow_nominal},
    dp_nominal={0,0,0})
    "Primary CHW return junction between 2-pipe and 4-pipe ASHPs"
    annotation (Placement(transformation(extent={{-30,-50},{-50,-30}})));
  Buildings.Templates.Components.Pumps.Single pumHWFouPip(
    have_var=false,
    have_valChe=true,
    redeclare package Medium = Medium,
    dat(
      m_flow_nominal=datAll.pla.pumHeaWatPri.m_flow_nominal[1],
      dp_nominal=datAll.pla.pumHeaWatPri.dp_nominal[1],
      per=datAll.pla.pumHeaWatPri.per[1])) "HW primary pump for 4-pipe ASHP"
    annotation (Placement(transformation(extent={{-110,-200},{-90,-180}})));
  Buildings.Templates.Components.Pumps.Single pumCHWFouPip(
    have_var=false,
    have_valChe=true,
    redeclare package Medium = Medium,
    dat(
      m_flow_nominal=datAll.pla.pumHeaWatPri.m_flow_nominal[1],
      dp_nominal=datAll.pla.pumHeaWatPri.dp_nominal[1],
      per=datAll.pla.pumHeaWatPri.per[1])) "CHW primary pump for 4-pipe ASHP"
    annotation (Placement(transformation(extent={{-40,-210},{-60,-190}})));
  Fluid.FixedResistances.Junction junCHWBypSup(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={pla.mChiWat_flow_nominal,-pla.mChiWat_flow_nominal,-pla.mChiWat_flow_nominal},
    dp_nominal={0,0,0}) "CHW supply bypass leg junction"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Fluid.FixedResistances.Junction junCHWBypRet(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={pla.mChiWat_flow_nominal,-pla.mChiWat_flow_nominal,pla.mChiWat_flow_nominal},
    dp_nominal={0,0,0}) "CHW return bypass leg junction" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,-40})));
  Fluid.FixedResistances.Junction junHWBypSup(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={pla.mHeaWat_flow_nominal,-pla.mHeaWat_flow_nominal,-pla.mHeaWat_flow_nominal},
    dp_nominal={0,0,0}) "HW supply bypass leg junction"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
  Fluid.FixedResistances.Junction junHWBypRet(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={pla.mHeaWat_flow_nominal,-pla.mHeaWat_flow_nominal,pla.mHeaWat_flow_nominal},
    dp_nominal={0,0,0}) "HW return bypass leg junction" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-20,-120})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatSec(
    redeclare package Medium = Medium,
    nPum=2,
    dat(m_flow_nominal=fill(pla.mChiWat_flow_nominal/pumChiWatSec.dat.nPum,
          pumChiWatSec.dat.nPum), dp_nominal=fill(max(pla.hp.dpHeaWatHp_nominal,
          pla.hp.dpChiWatHp_nominal), pumChiWatSec.dat.nPum)))
    "CHW secondary pumps"
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatSec(
    redeclare package Medium = Medium,
    nPum=2,
    dat(m_flow_nominal=fill(pla.mHeaWat_flow_nominal/pumHeaWatSec.dat.nPum,
          pumHeaWatSec.dat.nPum), dp_nominal=fill(max(pla.hp.dpHeaWatHp_nominal,
          pla.hp.dpChiWatHp_nominal), pumHeaWatSec.dat.nPum)))
    "HW secondary pumps"
    annotation (Placement(transformation(extent={{26,-90},{46,-70}})));
  Buildings.Templates.Components.Routing.SingleToMultiple pumChiWatSecInl(
    redeclare package Medium = Medium,
    nPorts=pumChiWatSec.nPum,
    m_flow_nominal=pla.mChiWat_flow_nominal) "Inlet to CHW secondary pumps"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle pumChiWatSecOut(
    redeclare package Medium = Medium,
    nPorts=pumChiWatSec.nPum,
    m_flow_nominal=pla.mChiWat_flow_nominal) "Outlet from CHW secondary pumps"
    annotation (Placement(transformation(extent={{54,-10},{74,10}})));
  Buildings.Templates.Components.Routing.SingleToMultiple pumHeaWatSecInl(
    redeclare package Medium = Medium,
    nPorts=pumHeaWatSec.nPum,
    m_flow_nominal=pla.mHeaWat_flow_nominal) "Inlet to HW secondary pumps"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Templates.Components.Routing.MultipleToSingle pumHeaWatSecOut(
    redeclare package Medium = Medium,
    nPorts=pumHeaWatSec.nPum,
    m_flow_nominal=pla.mHeaWat_flow_nominal) "Outlet from HW secondary pumps"
    annotation (Placement(transformation(extent={{54,-90},{74,-70}})));
equation
  if have_chiWat then
    connect(mulInt[3].y, busAirHan.reqResChiWat)
      annotation (Line(points={{28,80},{10,80}},    color={255,127,0}));
    connect(mulInt[4].y, busAirHan.reqPlaChiWat)
      annotation (Line(points={{28,80},{10,80}},    color={255,127,0}));
  end if;
  connect(weaDat.weaBus, pla.busWea)
    annotation (Line(points={{-180,-20},{-140,-20},{-140,-40}},
                                                             color={255,204,51},thickness=0.5));
  connect(TDum.y, reqPlaRes.TAirSup)
    annotation (Line(points={{-178,100},{150,100},{150,80},{142,80}}, color={0,0,127}));
  connect(TDum.y, reqPlaRes.TAirSupSet)
    annotation (Line(points={{-178,100},{150,100},{150,74},{142,74},{142,75}},
                                                                      color={0,0,127}));
  connect(busAirHan, pla.busAirHan[1])
    annotation (Line(points={{10,80},{-120,80},{-120,-42}},
                                                  color={255,204,51},thickness=0.5));
  connect(pla.bus, busPla)
    annotation (Line(points={{-160,-42},{-160,0}},color={255,204,51},thickness=0.5));
  connect(mChiWat_flow.port_b, dpChiWatRem[1].port_b)
    annotation (Line(points={{240,-30},{240,-40},{140,-40},{140,-28}},color={0,127,255}));
  connect(mHeaWat_flow.port_b, dpHeaWatRem[1].port_b)
    annotation (Line(points={{240,-110},{240,-120},{140,-120},{140,-108}},
                                                                        color={0,127,255}));
  connect(cst.y, mulInt.u1)
    annotation (Line(points={{68,120},{52,120},{52,86}},       color={255,127,0}));
  connect(mulInt[1].y, busAirHan.reqResHeaWat)
    annotation (Line(points={{28,80},{10,80}},    color={255,127,0}));
  connect(mulInt[2].y, busAirHan.reqPlaHeaWat)
    annotation (Line(points={{28,80},{10,80}},    color={255,127,0}));
  connect(mChiWat_flow.port_b, pipChiWat.port_a)
    annotation (Line(points={{240,-30},{240,-40},{130,-40}}, color={0,127,255}));
  connect(mHeaWat_flow.port_b, pipHeaWat.port_a)
    annotation (Line(points={{240,-110},{240,-120},{130,-120}},
                                                              color={0,127,255}));
  connect(reqPlaRes.yChiWatResReq, ph[1].u)
    annotation (Line(points={{118,80},{92,80},{92,84}},           color={255,127,0}));
  connect(reqPlaRes.yChiPlaReq, ph[2].u)
    annotation (Line(points={{118,75},{92,75},{92,84}},           color={255,127,0}));
  connect(reqPlaRes.yHotWatResReq, mulInt[1].u2)
    annotation (Line(points={{118,69},{52,69},{52,74}},          color={255,127,0}));
  connect(reqPlaRes.yHotWatPlaReq, mulInt[2].u2)
    annotation (Line(points={{118,64},{52,64},{52,74}},          color={255,127,0}));
  connect(ph[1].y, mulInt[3].u2)
    annotation (Line(points={{68,84},{52,84},{52,74}},           color={255,127,0}));
  connect(ph[2].y, mulInt[4].u2)
    annotation (Line(points={{68,84},{52,84},{52,74}},           color={255,127,0}));
  connect(dpChiWatRem.p_rel, busPla.dpChiWatRem)
    annotation (Line(points={{131,-18},{106,-18},{106,50},{-160,50},{-160,0}},
                                                                       color={0,0,127}),
      Text(string="%second",index=1,extent={{-6,3},{-6,3}},horizontalAlignment=TextAlignment.Right));
  connect(dpHeaWatRem.p_rel, busPla.dpHeaWatRem)
    annotation (Line(points={{131,-98},{106,-98},{106,50},{-160,50},{-160,0}},
      color={0,0,127}),Text(string="%second",index=1,extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(loaCoo.port_b, mChiWat_flow.port_a) annotation (Line(points={{190,0},{
          240,0},{240,-10}},    color={0,127,255}));
  connect(dpChiWatRem[1].port_a, loaCoo.port_a)
    annotation (Line(points={{140,-8},{140,0},{170,0}},   color={0,127,255}));
  connect(loaCoo.yVal_actual, reqPlaRes.uCooCoiSet) annotation (Line(points={{192,8},
          {200,8},{200,69},{142,69}},       color={0,0,127}));
  connect(loaHea.port_b, mHeaWat_flow.port_a) annotation (Line(points={{190,-80},
          {240,-80},{240,-90}},   color={0,127,255}));
  connect(dpHeaWatRem[1].port_a, loaHea.port_a) annotation (Line(points={{140,-88},
          {140,-80},{170,-80}}, color={0,127,255}));
  connect(ratLoa.y[2], loaCoo.u) annotation (Line(points={{-178,60},{160,60},{160,
          8},{168,8}},    color={0,0,127}));
  connect(ratLoa.y[1], loaHea.u) annotation (Line(points={{-178,60},{160,60},{160,
          -72},{168,-72}},color={0,0,127}));
  connect(loaHea.yVal_actual, reqPlaRes.uHeaCoiSet) annotation (Line(points={{192,-72},
          {210,-72},{210,64},{142,64}},     color={0,0,127}));
  connect(enaLoa.y, loaCoo.u1) annotation (Line(points={{-178,20},{150,20},{150,
          4},{168,4}},
                     color={255,0,255}));
  connect(enaLoa.y, loaHea.u1) annotation (Line(points={{-178,20},{150,20},{150,
          -76},{168,-76}},
                     color={255,0,255}));
  connect(volHeaWat.ports[1], loaHea.port_a)
    annotation (Line(points={{89,-80},{170,-80}}, color={0,127,255}));
  connect(volChiWat.ports[1], loaCoo.port_a)
    annotation (Line(points={{89,0},{170,0}},   color={0,127,255}));
  connect(pla.port_bHeaWat, junHWPriSup.port_1) annotation (Line(points={{-120,-70},
          {-100,-70},{-100,-80},{-90,-80}},      color={0,127,255}));
  connect(junHWPriRet.port_2, pla.port_aHeaWat) annotation (Line(points={{-90,-120},
          {-114,-120},{-114,-78},{-120,-78}},
                                            color={0,127,255}));
  connect(weaDat.weaBus, hpSHC.busWea) annotation (Line(
      points={{-180,-20},{-170,-20},{-170,-146},{-80,-146},{-80,-180}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.hpFouPip, hpSHC.bus) annotation (Line(
      points={{-160,0},{-160,-42},{-166,-42},{-166,-136},{-74,-136},{-74,-180}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(pla.port_bChiWat, junCHWPriSup.port_1) annotation (Line(points={{-120,
          -56},{-114,-56},{-114,0},{-60,0}},     color={0,127,255}));
  connect(hpSHC.port_bSou, junCHWPriSup.port_3) annotation (Line(points={{-84,
          -200},{-116,-200},{-116,-20},{-50,-20},{-50,-10}}, color={0,127,255}));
  connect(junCHWPriRet.port_2, pla.port_aChiWat) annotation (Line(points={{-50,-40},
          {-110,-40},{-110,-64},{-120,-64}},      color={0,127,255}));
  connect(hpSHC.port_a, pumHWFouPip.port_b)
    annotation (Line(points={{-84,-190},{-90,-190}}, color={0,127,255}));
  connect(junHWPriRet.port_3, pumHWFouPip.port_a) annotation (Line(points={{-80,
          -130},{-110,-130},{-110,-190}},            color={0,127,255}));
  connect(hpSHC.port_b, junHWPriSup.port_3) annotation (Line(points={{-64,-190},
          {-50,-190},{-50,-100},{-80,-100},{-80,-90}},  color={0,127,255}));
  connect(hpSHC.port_aSou, pumCHWFouPip.port_b)
    annotation (Line(points={{-64,-200},{-60,-200}}, color={0,127,255}));
  connect(pumCHWFouPip.port_a, junCHWPriRet.port_3) annotation (Line(points={{-40,
          -200},{-40,-50}},                                      color={0,127,
          255}));
  connect(busPla.pumFouPipHeaWatPri, pumHWFouPip.bus) annotation (Line(
      points={{-160,0},{-160,-42},{-166,-42},{-166,-136},{-100,-136},{-100,-180}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busPla.pumFouPipChiWatPri, pumCHWFouPip.bus) annotation (Line(
      points={{-160,0},{-160,-42},{-166,-42},{-166,-136},{-50,-136},{-50,-190}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(junCHWPriSup.port_2, junCHWBypSup.port_1)
    annotation (Line(points={{-40,0},{-30,0}},     color={0,127,255}));
  connect(pipChiWat.port_b, junCHWBypRet.port_1)
    annotation (Line(points={{110,-40},{0,-40}}, color={0,127,255}));
  connect(junCHWBypRet.port_2, junCHWPriRet.port_1)
    annotation (Line(points={{-20,-40},{-30,-40}}, color={0,127,255}));
  connect(junCHWBypRet.port_3, junCHWBypSup.port_3)
    annotation (Line(points={{-10,-30},{-10,-20},{-20,-20},{-20,-10}},
                                               color={0,127,255}));
  connect(junHWPriSup.port_2, junHWBypSup.port_1)
    annotation (Line(points={{-70,-80},{-30,-80}},   color={0,127,255}));
  connect(junHWPriRet.port_1, junHWBypRet.port_2)
    annotation (Line(points={{-70,-120},{-30,-120}}, color={0,127,255}));
  connect(junHWBypRet.port_1, pipHeaWat.port_b)
    annotation (Line(points={{-10,-120},{110,-120}},
                                                   color={0,127,255}));
  connect(junHWBypRet.port_3, junHWBypSup.port_3)
    annotation (Line(points={{-20,-110},{-20,-90}},
                                                 color={0,127,255}));
  connect(junCHWBypSup.port_2, pumChiWatSecInl.port_a)
    annotation (Line(points={{-10,0},{0,0}}, color={0,127,255}));
  connect(pumChiWatSecInl.ports_b, pumChiWatSec.ports_a)
    annotation (Line(points={{20,0},{26,0}}, color={0,127,255}));
  connect(pumChiWatSec.ports_b, pumChiWatSecOut.ports_a)
    annotation (Line(points={{46,0},{54,0}}, color={0,127,255}));
  connect(pumChiWatSecOut.port_b, volChiWat.ports[2])
    annotation (Line(points={{74,0},{91,0}}, color={0,127,255}));
  connect(junHWBypSup.port_2, pumHeaWatSecInl.port_a)
    annotation (Line(points={{-10,-80},{0,-80}}, color={0,127,255}));
  connect(pumHeaWatSecInl.ports_b, pumHeaWatSec.ports_a)
    annotation (Line(points={{20,-80},{26,-80}}, color={0,127,255}));
  connect(pumHeaWatSec.ports_b, pumHeaWatSecOut.ports_a)
    annotation (Line(points={{46,-80},{54,-80}}, color={0,127,255}));
  connect(pumHeaWatSecOut.port_b, volHeaWat.ports[2])
    annotation (Line(points={{74,-80},{91,-80}}, color={0,127,255}));
  connect(busPla.pumHeaWatSec, pumHeaWatSec.bus) annotation (Line(
      points={{-160,0},{-160,16},{-90,16},{-90,-56},{36,-56},{36,-70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busPla.pumChiWatSec, pumChiWatSec.bus) annotation (Line(
      points={{-160,0},{-160,16},{36,16},{36,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Validation/HybridAirToWater.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=86400.0),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps.AirToWater\">
Buildings.Templates.Plants.HeatPumps.AirToWater</a>
by simulating a <i>24</i>-hour period with overlapping heating and
cooling loads.
The heating loads reach their peak value first, the cooling loads reach it last.
</p>
<p>
Three equally sized heat pumps are modeled, which can all be lead/lag alternated.
A heat recovery chiller is included (<code>pla.have_hrc_select=true</code>)
and connected to the HW and CHW return pipes (sidestream integration).
A unique aggregated load is modeled on each loop using a heat exchanger component
exposed to conditioned space air, and a two-way modulating valve.
An importance multiplier of <i>10</i> is applied to the plant requests
and reset requests generated from the valve position.
</p>
<p>
The user can toggle the top-level parameter <code>have_chiWat</code>
to switch between a cooling and heating system (the default setting)
to a heating-only system.
Advanced equipment and control options can be modified via the parameter
dialog of the plant component.
</p>
<p>
Simulating this model shows how the plant responds to a varying load by
</p>
<ul>
<li>
staging or unstaging the AWHPs and the HRC with the associated primary pumps,
</li>
<li>
rotating lead/lag alternate equipment to ensure even wear,
</li>
<li>
resetting the supply temperature and remote differential pressure
in both the CHW and HW loops based on the valve position,
</li>
<li>
staging and controlling the secondary pumps to meet the
remote differential pressure setpoint.
</li>
</ul>
<p>
Note that the HRC model does not explicitly represent compressor cycling.
As a result, the cycling-based disabling condition specified in
<a href=\"modelica://Buildings.Templates.Plants.Controls.HeatRecoveryChillers.Enable\">
Buildings.Templates.Plants.Controls.HeatRecoveryChillers.Enable</a>
is never triggered.
This limitation may lead to overestimating the HRC operating time.
</p>
<h4>Details</h4>
<p>
By default, all valves within the plant are modeled considering a linear
variation of the pressure drop with the flow rate (<code>pla.linearized=true</code>),
as opposed to the quadratic relationship usually considered for
a turbulent flow regime.
By limiting the size of the system of nonlinear equations, this setting
reduces the risk of solver failure and the time to solution for testing
various plant configurations.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 18, 2026, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-240,-220},{260,180}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end HybridAirToWater;
