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
        staEqu=datAll.pla.ctl.staEquSinMod,
        staEquDouMod=[0,0,1; 1/2,1/2,1; 1,1,1],
        staEquSinMod=[1/2,1/2,0; 1,1,0; 1,1,1]),
      hp(
        mHeaWatHp_flow_nominal=0.5*datAll.pla.hp.capHeaHp_nominal/abs(datAll.pla.ctl.THeaWatSup_nominal
             - Buildings.Templates.Data.Defaults.THeaWatRetMed)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
        capHeaHp_nominal=1e6,
        mChiWatHp_flow_nominal=datAll.pla.hp.capCooHp_nominal/abs(datAll.pla.ctl.TChiWatSup_nominal
             - Buildings.Templates.Data.Defaults.TChiWatRet)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
        capCooHp_nominal=1.2e6)))
                          "Plant parameters"
    annotation (Placement(transformation(extent={{-220,140},{-200,160}})));
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
    annotation (Placement(transformation(extent={{-220,-60},{-200,-40}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Outdoor conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-210,-20})));
  Buildings.Templates.Plants.HeatPumps.AirToWater pla(
    redeclare final package MediumHeaWat=Medium,
    cfg(have_fouPip=true),
    typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only,
    typTanHeaWat_select=Buildings.Templates.Components.Types.IntegrationPoint.None,
    typTanChiWat_select=Buildings.Templates.Components.Types.IntegrationPoint.None,
    ctl(
      is_typDis_override=true,
      typDis_override=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2,
      have_PumHeaWatSec_override=true,
      nPumHeaWatSec_override=pumHeaWatSec.nPum,
      nPumChiWatSec_override=pumChiWatSec.nPum,
      nAirHan=1,
      nEquZon=0,
      have_senDpHeaWatRemWir=true),
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
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TDum(
    k=293.15,
    y(final unit="K",
      displayUnit="degC"))
    "Placeholder signal for request generator"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}})));
  Buildings.Fluid.Sensors.RelativePressure dpHeaWatRem[1](
    redeclare each final package Medium=Medium)
    "HW differential pressure at one remote location"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={160,-98})));
  Buildings.Fluid.Sensors.RelativePressure dpChiWatRem[1](
    redeclare each final package Medium=Medium)
    if have_chiWat
    "CHW differential pressure at one remote location"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={160,-18})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests reqPlaRes(
    final heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
    final cooCoi=if have_chiWat then Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
      else Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.None)
    "Plant and reset request"
    annotation (Placement(transformation(extent={{120,62},{100,82}})));
  AirHandlersFans.Interfaces.Bus busAirHan
    "AHU control bus"
    annotation (Placement(transformation(extent={{-30,60},{10,100}}),
      iconTransformation(extent={{-340,-140},{-300,-100}})));
  Interfaces.Bus busPla "Plant control bus"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
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
    annotation (Placement(transformation(extent={{-220,50},{-200,70}})));
  Buildings.Fluid.Sensors.VolumeFlowRate VChiWatSec_flow(redeclare final package Medium
      = Medium, m_flow_nominal=pla.mChiWat_flow_nominal) if have_chiWat
    "CHW secondary volume flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,-20})));
  Buildings.Fluid.Sensors.VolumeFlowRate VHeaWatSec_flow(redeclare final package Medium
      = Medium, m_flow_nominal=pla.mHeaWat_flow_nominal)
    "HW secondary volume flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,-100})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt[4]
    "Importance multiplier"
    annotation (Placement(transformation(extent={{30,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[4](
    each k=10) "Request multiplier factor"
    annotation (Placement(transformation(extent={{70,110},{50,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant enaLoa(k=true)
    "Load enable"
    annotation (Placement(transformation(extent={{-220,10},{-200,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipHeaWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mHeaWat_flow_nominal,
    final dp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max -
      max(datAll.pla.ctl.dpHeaWatRemSet_max))
    "Piping"
    annotation (Placement(transformation(extent={{140,-130},{120,-110}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipChiWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mChiWat_flow_nominal,
    final dp_nominal=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max -
      max(datAll.pla.ctl.dpChiWatRemSet_max))
    if have_chiWat
    "Piping"
    annotation (Placement(transformation(extent={{140,-50},{120,-30}})));
  Controls.Utilities.PlaceholderInteger ph[2](
    each final have_inp=have_chiWat,
    each final u_internal=0)
    "Placeholder value"
    annotation (Placement(transformation(extent={{70,74},{50,94}})));
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
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
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
    annotation (Placement(transformation(extent={{180,-90},{200,-70}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volHeaWat(
    energyDynamics=energyDynamics,
    final m_flow_nominal=pla.mHeaWat_flow_nominal,
    V=Buildings.Templates.Data.Defaults.ratVLiqByCap*pla.capHea_nominal,
    redeclare package Medium = Medium,
    nPorts=2)                          "Fluid volume in distribution system"
    annotation (Placement(transformation(extent={{110,-80},{130,-100}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volChiWat(
    energyDynamics=energyDynamics,
    final m_flow_nominal=pla.mChiWat_flow_nominal,
    V=Buildings.Templates.Data.Defaults.ratVLiqByCap*pla.capCoo_nominal,
    redeclare package Medium = Medium,
    nPorts=2) if have_chiWat           "Fluid volume in distribution system"
    annotation (Placement(transformation(extent={{110,0},{130,-20}})));
  Fluid.FixedResistances.Junction junHWPriSup(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={pla.mHeaWat_flow_nominal,-pla.mHeaWat_flow_nominal,pla.mHeaWat_flow_nominal},
    dp_nominal={0,0,0})
    "Primary supply junction between 2-pipe and 4-pipe ASHPs"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Fluid.FixedResistances.Junction junHWPriRet(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={pla.mHeaWat_flow_nominal,-pla.mHeaWat_flow_nominal,-pla.mHeaWat_flow_nominal},
    dp_nominal={0,0,0})
    "Primary return junction between 2-pipe and 4-pipe ASHPs"
    annotation (Placement(transformation(extent={{-90,-130},{-110,-110}})));
  Buildings.Templates.Components.HeatPumps.AirToWaterSHC hpSHC(
    redeclare package MediumHeaWat = Medium,
    redeclare package MediumSou = Medium,
    is_rev=true,
    dat=datHpSHC)
    "4-pipe ASHP with simultaneous HW and CHW supply"
    annotation (Placement(transformation(extent={{-104,-200},{-84,-180}})));
  Fluid.FixedResistances.Junction junCHWPriSup(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={pla.mChiWat_flow_nominal,-pla.mChiWat_flow_nominal,pla.mChiWat_flow_nominal},
    dp_nominal={0,0,0})
    "Primary CHW supply junction between 2-pipe and 4-pipe ASHPs"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Fluid.FixedResistances.Junction junCHWPriRet(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={pla.mChiWat_flow_nominal,-pla.mChiWat_flow_nominal,-pla.mChiWat_flow_nominal},
    dp_nominal={0,0,0})
    "Primary CHW return junction between 2-pipe and 4-pipe ASHPs"
    annotation (Placement(transformation(extent={{-90,-50},{-110,-30}})));
  Buildings.Templates.Components.Pumps.Single pumHWFouPip(
    have_var=false,
    have_valChe=true,
    redeclare package Medium = Medium,
    dat(
      m_flow_nominal=datAll.pla.pumHeaWatPri.m_flow_nominal[1],
      dp_nominal=datAll.pla.pumHeaWatPri.dp_nominal[1],
      per=datAll.pla.pumHeaWatPri.per[1])) "HW primary pump for 4-pipe ASHP"
    annotation (Placement(transformation(extent={{-130,-200},{-110,-180}})));
  Buildings.Templates.Components.Pumps.Single pumCHWFouPip(
    have_var=false,
    have_valChe=true,
    redeclare package Medium = Medium,
    dat(
      m_flow_nominal=datAll.pla.pumHeaWatPri.m_flow_nominal[1],
      dp_nominal=datAll.pla.pumHeaWatPri.dp_nominal[1],
      per=datAll.pla.pumHeaWatPri.per[1])) "CHW primary pump for 4-pipe ASHP"
    annotation (Placement(transformation(extent={{-60,-210},{-80,-190}})));
  Fluid.FixedResistances.Junction junCHWBypSup(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={pla.mChiWat_flow_nominal,-pla.mChiWat_flow_nominal,-pla.mChiWat_flow_nominal},
    dp_nominal={0,0,0}) "CHW supply bypass leg junction"
    annotation (Placement(transformation(extent={{-34,-10},{-14,10}})));
  Fluid.FixedResistances.Junction junCHWBypRet(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={pla.mChiWat_flow_nominal,-pla.mChiWat_flow_nominal,pla.mChiWat_flow_nominal},
    dp_nominal={0,0,0}) "CHW return bypass leg junction" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-14,-40})));
  Fluid.FixedResistances.Junction junHWBypSup(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={pla.mHeaWat_flow_nominal,-pla.mHeaWat_flow_nominal,-pla.mHeaWat_flow_nominal},
    dp_nominal={0,0,0}) "HW supply bypass leg junction"
    annotation (Placement(transformation(extent={{-34,-90},{-14,-70}})));
  Fluid.FixedResistances.Junction junHWBypRet(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={pla.mHeaWat_flow_nominal,-pla.mHeaWat_flow_nominal,pla.mHeaWat_flow_nominal},
    dp_nominal={0,0,0}) "HW return bypass leg junction" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-24,-120})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatSec(
    redeclare package Medium = Medium,
    nPum=2,
    dat(m_flow_nominal=fill(pla.mChiWat_flow_nominal/pumChiWatSec.dat.nPum,
          pumChiWatSec.dat.nPum), dp_nominal=fill(max(pla.hp.dpHeaWatHp_nominal,
          pla.hp.dpChiWatHp_nominal), pumChiWatSec.dat.nPum)))
    "CHW secondary pumps"
    annotation (Placement(transformation(extent={{18,-10},{38,10}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatSec(
    redeclare package Medium = Medium,
    nPum=2,
    dat(m_flow_nominal=fill(pla.mHeaWat_flow_nominal/pumHeaWatSec.dat.nPum,
          pumHeaWatSec.dat.nPum), dp_nominal=fill(max(pla.hp.dpHeaWatHp_nominal,
          pla.hp.dpChiWatHp_nominal), pumHeaWatSec.dat.nPum)))
    "HW secondary pumps"
    annotation (Placement(transformation(extent={{18,-90},{38,-70}})));
  Buildings.Templates.Components.Routing.SingleToMultiple pumChiWatSecInl(
    redeclare package Medium = Medium,
    nPorts=pumChiWatSec.nPum,
    m_flow_nominal=pla.mChiWat_flow_nominal) "Inlet to CHW secondary pumps"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle pumChiWatSecOut(
    redeclare package Medium = Medium,
    nPorts=pumChiWatSec.nPum,
    m_flow_nominal=pla.mChiWat_flow_nominal) "Outlet from CHW secondary pumps"
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  Buildings.Templates.Components.Routing.SingleToMultiple pumHeaWatSecInl(
    redeclare package Medium = Medium,
    nPorts=pumHeaWatSec.nPum,
    m_flow_nominal=pla.mHeaWat_flow_nominal) "Inlet to HW secondary pumps"
    annotation (Placement(transformation(extent={{-8,-90},{12,-70}})));
  Buildings.Templates.Components.Routing.MultipleToSingle pumHeaWatSecOut(
    redeclare package Medium = Medium,
    nPorts=pumHeaWatSec.nPum,
    m_flow_nominal=pla.mHeaWat_flow_nominal) "Outlet from HW secondary pumps"
    annotation (Placement(transformation(extent={{46,-90},{66,-70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemChiWatPriSup(
    redeclare package Medium= Medium,
    m_flow_nominal=pla.mChiWat_flow_nominal)
    "Chilled water primary supply temperature"
    annotation (Placement(transformation(extent={{-84,-10},{-64,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemChiWatPriRet(
    redeclare package Medium = Medium,
    m_flow_nominal=pla.mChiWat_flow_nominal)
    "Chilled water primary return temperature"
    annotation (Placement(transformation(extent={{-84,-50},{-64,-30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemChiWatSecSup(
    redeclare package Medium=Medium,
    m_flow_nominal=pla.mChiWat_flow_nominal)
    "Chilled water secondary supply temperature"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemChiWatSecRet(
    redeclare package Medium=Medium,
    m_flow_nominal=pla.mChiWat_flow_nominal)
    "Chilled water secondary return temperature"
    annotation (Placement(transformation(extent={{72,-50},{92,-30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHeaWatPriSup(
    redeclare package Medium=Medium,
    m_flow_nominal=pla.mHeaWat_flow_nominal)
    "Hot water primary supply temperature"
    annotation (Placement(transformation(extent={{-84,-90},{-64,-70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHeaWatPriRet(
    redeclare package Medium=Medium,
    m_flow_nominal=pla.mHeaWat_flow_nominal)
    "Hot water primary return temperature"
    annotation (Placement(transformation(extent={{-82,-130},{-62,-110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHeaWatSecSup(
    redeclare package Medium=Medium,
    m_flow_nominal=pla.mHeaWat_flow_nominal)
    "Hot water secondary supply temperature"
    annotation (Placement(transformation(extent={{74,-90},{94,-70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHeaWatSecRet(
    redeclare package Medium = Medium,
    m_flow_nominal=pla.mHeaWat_flow_nominal)
    "Hot water secondary return temperature"
    annotation (Placement(transformation(extent={{76,-130},{96,-110}})));
  Buildings.Fluid.Sensors.VolumeFlowRate VChiWatPri_flow(
    redeclare final package Medium = Medium,
    m_flow_nominal=pla.mChiWat_flow_nominal) if have_chiWat
    "CHW primary volume flow rate"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-48,0})));
  Buildings.Fluid.Sensors.VolumeFlowRate VHeaWatPri_flow(
    redeclare final package Medium = Medium,
    m_flow_nominal=pla.mHeaWat_flow_nominal)
    "HW primary volume flow rate"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-48,-80})));
equation
  if have_chiWat then
    connect(mulInt[3].y, busAirHan.reqResChiWat)
      annotation (Line(points={{8,80},{-10,80}},    color={255,127,0}));
    connect(mulInt[4].y, busAirHan.reqPlaChiWat)
      annotation (Line(points={{8,80},{-10,80}},    color={255,127,0}));
  end if;
  connect(weaDat.weaBus, pla.busWea)
    annotation (Line(points={{-200,-20},{-160,-20},{-160,-40}},
                                                             color={255,204,51},thickness=0.5));
  connect(TDum.y, reqPlaRes.TAirSup)
    annotation (Line(points={{-198,100},{130,100},{130,80},{122,80}}, color={0,0,127}));
  connect(TDum.y, reqPlaRes.TAirSupSet)
    annotation (Line(points={{-198,100},{130,100},{130,74},{122,74},{122,75}},
                                                                      color={0,0,127}));
  connect(busAirHan, pla.busAirHan[1])
    annotation (Line(points={{-10,80},{-140,80},{-140,-42}},
                                                  color={255,204,51},thickness=0.5));
  connect(pla.bus, busPla)
    annotation (Line(points={{-180,-42},{-180,0}},color={255,204,51},thickness=0.5));
  connect(VChiWatSec_flow.port_b, dpChiWatRem[1].port_b) annotation (Line(
        points={{240,-30},{240,-40},{160,-40},{160,-28}}, color={0,127,255}));
  connect(VHeaWatSec_flow.port_b, dpHeaWatRem[1].port_b) annotation (Line(
        points={{240,-110},{240,-120},{160,-120},{160,-108}}, color={0,127,255}));
  connect(cst.y, mulInt.u1)
    annotation (Line(points={{48,120},{32,120},{32,86}},       color={255,127,0}));
  connect(mulInt[1].y, busAirHan.reqResHeaWat)
    annotation (Line(points={{8,80},{-10,80}},    color={255,127,0}));
  connect(mulInt[2].y, busAirHan.reqPlaHeaWat)
    annotation (Line(points={{8,80},{-10,80}},    color={255,127,0}));
  connect(VChiWatSec_flow.port_b, pipChiWat.port_a) annotation (Line(points={{240,
          -30},{240,-40},{140,-40}}, color={0,127,255}));
  connect(VHeaWatSec_flow.port_b, pipHeaWat.port_a) annotation (Line(points={{240,
          -110},{240,-120},{140,-120}}, color={0,127,255}));
  connect(reqPlaRes.yChiWatResReq, ph[1].u)
    annotation (Line(points={{98,80},{72,80},{72,84}},            color={255,127,0}));
  connect(reqPlaRes.yChiPlaReq, ph[2].u)
    annotation (Line(points={{98,75},{72,75},{72,84}},            color={255,127,0}));
  connect(reqPlaRes.yHotWatResReq, mulInt[1].u2)
    annotation (Line(points={{98,69},{32,69},{32,74}},           color={255,127,0}));
  connect(reqPlaRes.yHotWatPlaReq, mulInt[2].u2)
    annotation (Line(points={{98,64},{32,64},{32,74}},           color={255,127,0}));
  connect(ph[1].y, mulInt[3].u2)
    annotation (Line(points={{48,84},{32,84},{32,74}},           color={255,127,0}));
  connect(ph[2].y, mulInt[4].u2)
    annotation (Line(points={{48,84},{32,84},{32,74}},           color={255,127,0}));
  connect(dpChiWatRem.p_rel, busPla.dpChiWatRem)
    annotation (Line(points={{151,-18},{144,-18},{144,50},{-180,50},{-180,0}},
                                                                       color={0,0,127}),
      Text(string="%second",index=1,extent={{-6,3},{-6,3}},horizontalAlignment=TextAlignment.Right));
  connect(dpHeaWatRem.p_rel, busPla.dpHeaWatRem)
    annotation (Line(points={{151,-98},{144,-98},{144,50},{-180,50},{-180,0}},
      color={0,0,127}),Text(string="%second",index=1,extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(loaCoo.port_b, VChiWatSec_flow.port_a)
    annotation (Line(points={{200,0},{240,0},{240,-10}}, color={0,127,255}));
  connect(dpChiWatRem[1].port_a, loaCoo.port_a)
    annotation (Line(points={{160,-8},{160,0},{180,0}},   color={0,127,255}));
  connect(loaCoo.yVal_actual, reqPlaRes.uCooCoiSet) annotation (Line(points={{202,8},
          {214,8},{214,69},{122,69}},       color={0,0,127}));
  connect(loaHea.port_b, VHeaWatSec_flow.port_a) annotation (Line(points={{200,-80},
          {240,-80},{240,-90}}, color={0,127,255}));
  connect(dpHeaWatRem[1].port_a, loaHea.port_a) annotation (Line(points={{160,-88},
          {160,-80},{180,-80}}, color={0,127,255}));
  connect(ratLoa.y[2], loaCoo.u) annotation (Line(points={{-198,60},{172,60},{172,
          8},{178,8}},    color={0,0,127}));
  connect(ratLoa.y[1], loaHea.u) annotation (Line(points={{-198,60},{172,60},{172,
          -72},{178,-72}},color={0,0,127}));
  connect(loaHea.yVal_actual, reqPlaRes.uHeaCoiSet) annotation (Line(points={{202,-72},
          {220,-72},{220,64},{122,64}},     color={0,0,127}));
  connect(enaLoa.y, loaCoo.u1) annotation (Line(points={{-198,20},{168,20},{168,
          4},{178,4}},
                     color={255,0,255}));
  connect(enaLoa.y, loaHea.u1) annotation (Line(points={{-198,20},{168,20},{168,
          -76},{178,-76}},
                     color={255,0,255}));
  connect(volHeaWat.ports[1], loaHea.port_a)
    annotation (Line(points={{119,-80},{180,-80}},color={0,127,255}));
  connect(volChiWat.ports[1], loaCoo.port_a)
    annotation (Line(points={{119,0},{180,0}},  color={0,127,255}));
  connect(pla.port_bHeaWat, junHWPriSup.port_1) annotation (Line(points={{-140,-70},
          {-120,-70},{-120,-80},{-110,-80}},     color={0,127,255}));
  connect(junHWPriRet.port_2, pla.port_aHeaWat) annotation (Line(points={{-110,-120},
          {-134,-120},{-134,-78},{-140,-78}},
                                            color={0,127,255}));
  connect(weaDat.weaBus, hpSHC.busWea) annotation (Line(
      points={{-200,-20},{-190,-20},{-190,-146},{-100,-146},{-100,-180}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.hpFouPip, hpSHC.bus) annotation (Line(
      points={{-180,0},{-180,-42},{-186,-42},{-186,-136},{-94,-136},{-94,-180}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(pla.port_bChiWat, junCHWPriSup.port_1) annotation (Line(points={{-140,
          -56},{-134,-56},{-134,0},{-110,0}},    color={0,127,255}));
  connect(hpSHC.port_bSou, junCHWPriSup.port_3) annotation (Line(points={{-104,-200},
          {-136,-200},{-136,-20},{-100,-20},{-100,-10}},     color={0,127,255}));
  connect(junCHWPriRet.port_2, pla.port_aChiWat) annotation (Line(points={{-110,
          -40},{-130,-40},{-130,-64},{-140,-64}}, color={0,127,255}));
  connect(hpSHC.port_a, pumHWFouPip.port_b)
    annotation (Line(points={{-104,-190},{-110,-190}},
                                                     color={0,127,255}));
  connect(junHWPriRet.port_3, pumHWFouPip.port_a) annotation (Line(points={{-100,
          -130},{-130,-130},{-130,-190}},            color={0,127,255}));
  connect(hpSHC.port_b, junHWPriSup.port_3) annotation (Line(points={{-84,-190},
          {-78,-190},{-78,-100},{-100,-100},{-100,-90}},color={0,127,255}));
  connect(hpSHC.port_aSou, pumCHWFouPip.port_b)
    annotation (Line(points={{-84,-200},{-80,-200}}, color={0,127,255}));
  connect(pumCHWFouPip.port_a, junCHWPriRet.port_3) annotation (Line(points={{-60,
          -200},{0,-200},{0,-56},{-100,-56},{-100,-50}},         color={0,127,
          255}));
  connect(busPla.pumFouPipHeaWatPri, pumHWFouPip.bus) annotation (Line(
      points={{-180,0},{-180,-42},{-186,-42},{-186,-136},{-120,-136},{-120,-180}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busPla.pumFouPipChiWatPri, pumCHWFouPip.bus) annotation (Line(
      points={{-180,0},{-180,-42},{-186,-42},{-186,-136},{-70,-136},{-70,-190}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(junCHWBypRet.port_3, junCHWBypSup.port_3)
    annotation (Line(points={{-14,-30},{-14,-20},{-24,-20},{-24,-10}},
                                               color={0,127,255}));
  connect(junHWBypRet.port_3, junHWBypSup.port_3)
    annotation (Line(points={{-24,-110},{-24,-90}},
                                                 color={0,127,255}));
  connect(junCHWBypSup.port_2, pumChiWatSecInl.port_a)
    annotation (Line(points={{-14,0},{-8,0}},color={0,127,255}));
  connect(pumChiWatSecInl.ports_b, pumChiWatSec.ports_a)
    annotation (Line(points={{12,0},{18,0}}, color={0,127,255}));
  connect(pumChiWatSec.ports_b, pumChiWatSecOut.ports_a)
    annotation (Line(points={{38,0},{46,0}}, color={0,127,255}));
  connect(junHWBypSup.port_2, pumHeaWatSecInl.port_a)
    annotation (Line(points={{-14,-80},{-8,-80}},color={0,127,255}));
  connect(pumHeaWatSecInl.ports_b, pumHeaWatSec.ports_a)
    annotation (Line(points={{12,-80},{18,-80}}, color={0,127,255}));
  connect(pumHeaWatSec.ports_b, pumHeaWatSecOut.ports_a)
    annotation (Line(points={{38,-80},{46,-80}}, color={0,127,255}));
  connect(busPla.pumHeaWatSec, pumHeaWatSec.bus) annotation (Line(
      points={{-180,0},{-180,-10},{-124,-10},{-124,-60},{36,-60},{36,-70},{28,-70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busPla.pumChiWatSec, pumChiWatSec.bus) annotation (Line(
      points={{-180,0},{-140,0},{-140,18},{28,18},{28,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(junCHWPriSup.port_2, senTemChiWatPriSup.port_a)
    annotation (Line(points={{-90,0},{-84,0}}, color={0,127,255}));
  connect(junCHWBypRet.port_2, senTemChiWatPriRet.port_b)
    annotation (Line(points={{-24,-40},{-64,-40}}, color={0,127,255}));
  connect(senTemChiWatPriRet.port_a, junCHWPriRet.port_1)
    annotation (Line(points={{-84,-40},{-90,-40}}, color={0,127,255}));
  connect(pumChiWatSecOut.port_b, senTemChiWatSecSup.port_a)
    annotation (Line(points={{66,0},{70,0}}, color={0,127,255}));
  connect(senTemChiWatSecSup.port_b, volChiWat.ports[2])
    annotation (Line(points={{90,0},{121,0}}, color={0,127,255}));
  connect(pipChiWat.port_b, senTemChiWatSecRet.port_b)
    annotation (Line(points={{120,-40},{92,-40}}, color={0,127,255}));
  connect(senTemChiWatSecRet.port_a, junCHWBypRet.port_1)
    annotation (Line(points={{72,-40},{-4,-40}}, color={0,127,255}));
  connect(junHWPriSup.port_2, senTemHeaWatPriSup.port_a)
    annotation (Line(points={{-90,-80},{-84,-80}}, color={0,127,255}));
  connect(junHWPriRet.port_1, senTemHeaWatPriRet.port_a)
    annotation (Line(points={{-90,-120},{-82,-120}}, color={0,127,255}));
  connect(senTemHeaWatPriRet.port_b, junHWBypRet.port_2)
    annotation (Line(points={{-62,-120},{-34,-120}}, color={0,127,255}));
  connect(pumHeaWatSecOut.port_b, senTemHeaWatSecSup.port_a)
    annotation (Line(points={{66,-80},{74,-80}}, color={0,127,255}));
  connect(senTemHeaWatSecSup.port_b, volHeaWat.ports[2])
    annotation (Line(points={{94,-80},{121,-80}}, color={0,127,255}));
  connect(junHWBypRet.port_1, senTemHeaWatSecRet.port_a)
    annotation (Line(points={{-14,-120},{76,-120}}, color={0,127,255}));
  connect(senTemHeaWatSecRet.port_b, pipHeaWat.port_b)
    annotation (Line(points={{96,-120},{120,-120}}, color={0,127,255}));
  connect(senTemChiWatPriSup.port_b, VChiWatPri_flow.port_a)
    annotation (Line(points={{-64,0},{-58,0}}, color={0,127,255}));
  connect(VChiWatPri_flow.port_b, junCHWBypSup.port_1)
    annotation (Line(points={{-38,0},{-34,0}}, color={0,127,255}));
  connect(senTemHeaWatPriSup.port_b, VHeaWatPri_flow.port_a)
    annotation (Line(points={{-64,-80},{-58,-80}}, color={0,127,255}));
  connect(VHeaWatPri_flow.port_b, junHWBypSup.port_1)
    annotation (Line(points={{-38,-80},{-34,-80}}, color={0,127,255}));
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
The plant consists of two 2-pipe air-source heat pumps (ASHPs) combined with a 4-pipe
ASHP. The 2-pipe ASHPs can be lead/lag alternated. The plant uses a constant-primary,
variable-secondary hydronic distribution system.
A unique aggregated load is modeled on each loop using a heat exchanger component
exposed to conditioned space air, and a two-way modulating valve.
An importance multiplier of <i>10</i> is applied to the plant requests
and reset requests generated from the valve position.
</p>
<p>
Some of the advanced equipment and control options can be modified via the parameter
dialog of the plant component.
</p>
<p>
Simulating this model shows how the plant responds to a varying load by
</p>
<ul>
<li>
staging or unstaging the AWHPs with the associated primary pumps,
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
