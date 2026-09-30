within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1NLoads
  "Validation of AWHP plant template with a distributed set of terminal loads"
  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Main medium (common for CHW and HW)";

  parameter Integer nLoa(final min=1) = 12
    "Number of terminal loads connected in parallel on each loop"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dpTer_nominal(
    displayUnit="Pa") = 3E4
    "Liquid pressure drop across terminal unit at design conditions";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    displayUnit="Pa") = dpTer_nominal
    "Terminal unit control valve pressure drop at design conditions";
  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"),
      Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics =
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true,
      Dialog(tab="Dynamics",
        group="Conservation equations"));
  Buildings.Templates.Plants.HeatPumps.AirToWater pla(
    redeclare final package MediumHeaWat=Medium,
    typ=Buildings.Templates.Plants.Controls.Types.PlantHeatPump.Reversible,
    final dat=datAll.pla,
    nHp_select=3,
    typArrPumPri_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    have_pumPriDedComHp_select=false,
    typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only,
    nPumHeaWatSec_select=2,
    nPumChiWatSec_select=2,
    final allowFlowReversal=allowFlowReversal,
    linearized=false,
    show_T=true,
    ctl(
      nAirHan=1,
      nEquZon=0,
      have_senTPriRet_select=true,
      have_senTLooRet_select=true,
      have_senDpHeaWatRemWir=false),
    is_dpBalYPumSetCal=true,
    dpChiWatLoo_nominal=datAll.pla.ctl.dpChiWatLocSet_max,
    dpHeaWatLoo_nominal=datAll.pla.ctl.dpHeaWatLocSet_max)
    "Heat pump plant"
    annotation(Placement(transformation(extent={{-80,-100},{-40,-60}})));
  /*
   * HACK(AntoineGautier):
   * Keep 'datAll' declared after 'pla' below.
   * With Dymola 2026x Refresh 1, declaring 'datAll' *before* 'pla' yields a
   * large overhead in checkModel/translateModel, see the same comment in
   * Buildings.Templates.Plants.Chillers.Validation.WaterCooled.
   */
  inner replaceable parameter UserProject.Data.AirToWaterReversibleHeatRecovery datAll(
    pla(final cfg=pla.cfg))
    "Plant parameters"
    annotation(Placement(transformation(extent={{-180,120},{-160,140}})));
  final parameter Boolean have_chiWat = pla.have_chiWat
    "Set to true if the plant provides CHW"
    annotation(Evaluate=true);
  final parameter Modelica.Units.SI.PressureDifference dpHeaWatDis_nominal(
    displayUnit="Pa") = Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max -
    max(datAll.pla.ctl.dpHeaWatRemSet_max)
    "HW distribution piping pressure drop at design flow, supply and return combined";
  final parameter Modelica.Units.SI.PressureDifference dpChiWatDis_nominal(
    displayUnit="Pa") = Buildings.Templates.Data.Defaults.dpChiWatLocSet_max -
    max(datAll.pla.ctl.dpChiWatRemSet_max)
    "CHW distribution piping pressure drop at design flow, supply and return combined";
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Outdoor conditions"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-170,-40})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TDum(
    k=293.15,
    y(final unit="K", displayUnit="degC"))
    "Placeholder signal for request generator"
    annotation(Placement(transformation(extent={{-180,70},{-160,90}})));
  Buildings.Fluid.Sensors.RelativePressure dpHeaWatRem[1](
    redeclare each final package Medium=Medium)
    "HW differential pressure at one remote location"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={120,-118})));
  Buildings.Fluid.Sensors.RelativePressure dpChiWatRem[1](
    redeclare each final package Medium=Medium)
    if have_chiWat
    "CHW differential pressure at one remote location"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={120,-58})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests reqPlaRes(
    final heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
    final cooCoi=if have_chiWat
      then Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
      else Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.None)
    "Plant and reset request"
    annotation(Placement(transformation(extent={{90,42},{70,62}})));
  Buildings.Templates.AirHandlersFans.Interfaces.Bus busAirHan
    "AHU control bus"
    annotation(Placement(transformation(extent={{-60,40},{-20,80}}),
      iconTransformation(extent={{-340,-140},{-300,-100}})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus busPla
    "Plant control bus"
    annotation(Placement(transformation(extent={{-100,-40},{-60,0}}),
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
    annotation(Placement(transformation(extent={{-180,30},{-160,50}})));
  Buildings.Fluid.Sensors.VolumeFlowRate VChiWat_flow(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mChiWat_flow_nominal)
    if have_chiWat
    "CHW volume flow rate"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=180,
      origin={0,-80})));
  Buildings.Fluid.Sensors.VolumeFlowRate VHeaWat_flow(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mHeaWat_flow_nominal)
    "HW volume flow rate"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=180,
      origin={0,-140})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt[4]
    "Importance multiplier"
    annotation(Placement(transformation(extent={{0,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[4](each k=10)
    "Request multiplier factor"
    annotation(Placement(transformation(extent={{40,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant enaLoa(k=true)
    "Load enable"
    annotation(Placement(transformation(extent={{-180,-10},{-160,10}})));
  Buildings.Templates.Plants.Controls.Utilities.PlaceholderInteger ph[2](
    each final have_inp=have_chiWat,
    each final u_internal=0)
    "Placeholder value"
    annotation(Placement(transformation(extent={{40,54},{20,74}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipHeaWatSup[nLoa](
    redeclare each final package Medium=Medium,
    final m_flow_nominal={pla.mHeaWat_flow_nominal * (nLoa - i + 1) / nLoa
      for i in 1:nLoa},
    each final dp_nominal=dpHeaWatDis_nominal / (2 * nLoa))
    "HW supply main – Segment i feeds the branch of terminal unit i"
    annotation(Placement(transformation(extent={{30,-110},{50,-90}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipHeaWatRet[nLoa](
    redeclare each final package Medium=Medium,
    final m_flow_nominal={pla.mHeaWat_flow_nominal * (nLoa - i + 1) / nLoa
      for i in 1:nLoa},
    each final dp_nominal=dpHeaWatDis_nominal / (2 * nLoa))
    "HW return main – Segment i drains the branch of terminal unit i"
    annotation(Placement(transformation(extent={{50,-150},{30,-130}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipChiWatSup[nLoa](
    redeclare each final package Medium=Medium,
    final m_flow_nominal={pla.mChiWat_flow_nominal * (nLoa - i + 1) / nLoa
      for i in 1:nLoa},
    each final dp_nominal=dpChiWatDis_nominal / (2 * nLoa))
    if have_chiWat
    "CHW supply main – Segment i feeds the branch of terminal unit i"
    annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipChiWatRet[nLoa](
    redeclare each final package Medium=Medium,
    final m_flow_nominal={pla.mChiWat_flow_nominal * (nLoa - i + 1) / nLoa
      for i in 1:nLoa},
    each final dp_nominal=dpChiWatDis_nominal / (2 * nLoa))
    if have_chiWat
    "CHW return main – Segment i drains the branch of terminal unit i"
    annotation(Placement(transformation(extent={{50,-90},{30,-70}})));
  Buildings.Templates.Components.Loads.LoadTwoWayValve loaCoo[nLoa](
    redeclare each final package MediumLiq=Medium,
    each final energyDynamics=energyDynamics,
    each final typ=Buildings.Fluid.HydronicConfigurations.Types.Control.Cooling,
    each final mLiq_flow_nominal=pla.mChiWat_flow_nominal / nLoa,
    each final dpTer_nominal=dpTer_nominal,
    each final dpValve_nominal=dpValve_nominal,
    final dpBal1_nominal={datAll.pla.ctl.dpChiWatRemSet_max[1] - dpTer_nominal -
      dpValve_nominal + (nLoa - i) * dpChiWatDis_nominal / nLoa for i in 1:nLoa},
    each final TLiqEnt_nominal=pla.TChiWatSup_nominal,
    each final TLiqLvg_nominal=pla.TChiWatRet_nominal,
    con(val(each y_start=0)))
    if have_chiWat
    "Cooling loads"
    annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Buildings.Templates.Components.Loads.LoadTwoWayValve loaHea[nLoa](
    redeclare each final package MediumLiq=Medium,
    each final energyDynamics=energyDynamics,
    each final typ=Buildings.Fluid.HydronicConfigurations.Types.Control.Heating,
    each final mLiq_flow_nominal=pla.mHeaWat_flow_nominal / nLoa,
    each final dpTer_nominal=dpTer_nominal,
    each final dpValve_nominal=dpValve_nominal,
    final dpBal1_nominal={datAll.pla.ctl.dpHeaWatRemSet_max[1] - dpTer_nominal -
      dpValve_nominal + (nLoa - i) * dpHeaWatDis_nominal / nLoa for i in 1:nLoa},
    each final TLiqEnt_nominal=pla.THeaWatSup_nominal,
    each final TLiqLvg_nominal=pla.THeaWatRet_nominal,
    con(val(each y_start=0)))
    "Heating loads"
    annotation(Placement(transformation(extent={{70,-110},{90,-90}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax yValCoo_max(nin=nLoa)
    if have_chiWat
    "Maximum cooling coil valve position"
    annotation(Placement(transformation(extent={{130,-10},{150,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax yValHea_max(nin=nLoa)
    "Maximum heating coil valve position"
    annotation(Placement(transformation(extent={{130,-40},{150,-20}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volHeaWat(
    energyDynamics=energyDynamics,
    final m_flow_nominal=pla.mHeaWat_flow_nominal,
    V=Buildings.Templates.Data.Defaults.ratVLiqByCap * pla.capHea_nominal,
    redeclare package Medium=Medium,
    nPorts=2)
    "Fluid volume in distribution system"
    annotation(Placement(transformation(extent={{-10,-100},{10,-120}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volChiWat(
    energyDynamics=energyDynamics,
    final m_flow_nominal=pla.mChiWat_flow_nominal,
    V=Buildings.Templates.Data.Defaults.ratVLiqByCap * pla.capCoo_nominal,
    redeclare package Medium=Medium,
    nPorts=2)
    if have_chiWat
    "Fluid volume in distribution system"
    annotation(Placement(transformation(extent={{-10,-40},{10,-60}})));
equation
  if have_chiWat then
    connect(mulInt[3].y, busAirHan.reqResChiWat)
      annotation(Line(points={{-22,60},{-40,60}},
        color={255,127,0}));
    connect(mulInt[4].y, busAirHan.reqPlaChiWat)
      annotation(Line(points={{-22,60},{-40,60}},
        color={255,127,0}));
  end if;
  // Distribution mains: terminal unit 1 is the closest to the plant,
  // terminal unit nLoa the most remote.
  for i in 1:(nLoa - 1) loop
    connect(pipHeaWatSup[i].port_b, pipHeaWatSup[i + 1].port_a)
      annotation(Line(points={{50,-100},{30,-100}},
        color={0,127,255}));
    connect(pipHeaWatRet[i + 1].port_b, pipHeaWatRet[i].port_a)
      annotation(Line(points={{30,-140},{50,-140}},
        color={0,127,255}));
    connect(pipChiWatSup[i].port_b, pipChiWatSup[i + 1].port_a)
      annotation(Line(points={{50,-40},{30,-40}},
        color={0,127,255}));
    connect(pipChiWatRet[i + 1].port_b, pipChiWatRet[i].port_a)
      annotation(Line(points={{30,-80},{50,-80}},
        color={0,127,255}));
  end for;
  for i in 1:nLoa loop
    connect(pipHeaWatSup[i].port_b, loaHea[i].port_a)
      annotation(Line(points={{50,-100},{70,-100}},
        color={0,127,255}));
    connect(loaHea[i].port_b, pipHeaWatRet[i].port_a)
      annotation(Line(points={{90,-100},{100,-100},{100,-140},{50,-140}},
        color={0,127,255}));
    connect(pipChiWatSup[i].port_b, loaCoo[i].port_a)
      annotation(Line(points={{50,-40},{70,-40}},
        color={0,127,255}));
    connect(loaCoo[i].port_b, pipChiWatRet[i].port_a)
      annotation(Line(points={{90,-40},{100,-40},{100,-80},{50,-80}},
        color={0,127,255}));
    connect(ratLoa.y[1], loaHea[i].u)
      annotation(Line(points={{-158,40},{60,40},{60,-92},{68,-92}},
        color={0,0,127}));
    connect(ratLoa.y[2], loaCoo[i].u)
      annotation(Line(points={{-158,40},{60,40},{60,-32},{68,-32}},
        color={0,0,127}));
    connect(enaLoa.y, loaHea[i].u1)
      annotation(Line(points={{-158,0},{56,0},{56,-96},{68,-96}},
        color={255,0,255}));
    connect(enaLoa.y, loaCoo[i].u1)
      annotation(Line(points={{-158,0},{56,0},{56,-36},{68,-36}},
        color={255,0,255}));
  end for;
  connect(weaDat.weaBus, pla.busWea)
    annotation(Line(points={{-160,-40},{-60,-40},{-60,-60}},
      color={255,204,51},
      thickness=0.5));
  connect(TDum.y, reqPlaRes.TAirSup)
    annotation(Line(points={{-158,80},{100,80},{100,60},{92,60}},
      color={0,0,127}));
  connect(TDum.y, reqPlaRes.TAirSupSet)
    annotation(Line(points={{-158,80},{100,80},{100,55},{92,55}},
      color={0,0,127}));
  connect(busAirHan, pla.busAirHan[1])
    annotation(Line(points={{-40,60},{-40,-62}},
      color={255,204,51},
      thickness=0.5));
  connect(pla.bus, busPla)
    annotation(Line(points={{-80,-62},{-80,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(cst.y, mulInt.u1)
    annotation(Line(points={{18,100},{6,100},{6,66},{2,66}},
      color={255,127,0}));
  connect(mulInt[1].y, busAirHan.reqResHeaWat)
    annotation(Line(points={{-22,60},{-40,60}},
      color={255,127,0}));
  connect(mulInt[2].y, busAirHan.reqPlaHeaWat)
    annotation(Line(points={{-22,60},{-40,60}},
      color={255,127,0}));
  connect(reqPlaRes.yChiWatResReq, ph[1].u)
    annotation(Line(points={{68,60},{50,60},{50,64},{42,64}},
      color={255,127,0}));
  connect(reqPlaRes.yChiPlaReq, ph[2].u)
    annotation(Line(points={{68,55},{50,55},{50,64},{42,64}},
      color={255,127,0}));
  connect(reqPlaRes.yHotWatResReq, mulInt[1].u2)
    annotation(Line(points={{68,49},{12,49},{12,54},{2,54}},
      color={255,127,0}));
  connect(reqPlaRes.yHotWatPlaReq, mulInt[2].u2)
    annotation(Line(points={{68,44},{12,44},{12,54},{2,54}},
      color={255,127,0}));
  connect(ph[1].y, mulInt[3].u2)
    annotation(Line(points={{18,64},{12,64},{12,54},{2,54}},
      color={255,127,0}));
  connect(ph[2].y, mulInt[4].u2)
    annotation(Line(points={{18,64},{12,64},{12,54},{2,54}},
      color={255,127,0}));
  connect(dpChiWatRem.p_rel, busPla.dpChiWatRem)
    annotation(Line(points={{111,-58},{22,-58},{22,-18},{-80,-18},{-80,-20}},
      color={0,0,127}),
      Text(string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
  connect(dpHeaWatRem.p_rel, busPla.dpHeaWatRem)
    annotation(Line(points={{111,-118},{20,-118},{20,-20},{-80,-20}},
      color={0,0,127}),
      Text(string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
  // The remote differential pressure sensors are located just upstream of the
  // last connected terminal unit.
  connect(pipChiWatSup[nLoa].port_b, dpChiWatRem[1].port_a)
    annotation(Line(points={{50,-40},{120,-40},{120,-48}},
      color={0,127,255}));
  connect(pipChiWatRet[nLoa].port_a, dpChiWatRem[1].port_b)
    annotation(Line(points={{50,-80},{120,-80},{120,-68}},
      color={0,127,255}));
  connect(pipHeaWatSup[nLoa].port_b, dpHeaWatRem[1].port_a)
    annotation(Line(points={{50,-100},{120,-100},{120,-108}},
      color={0,127,255}));
  connect(pipHeaWatRet[nLoa].port_a, dpHeaWatRem[1].port_b)
    annotation(Line(points={{50,-140},{120,-140},{120,-128}},
      color={0,127,255}));
  connect(loaCoo.yVal_actual, yValCoo_max.u)
    annotation(Line(points={{92,-32},{128,-32},{128,0}},
      color={0,0,127}));
  connect(loaHea.yVal_actual, yValHea_max.u)
    annotation(Line(points={{92,-92},{128,-92},{128,-30}},
      color={0,0,127}));
  connect(yValCoo_max.y, reqPlaRes.uCooCoiSet)
    annotation(Line(points={{152,0},{160,0},{160,49},{92,49}},
      color={0,0,127}));
  connect(yValHea_max.y, reqPlaRes.uHeaCoiSet)
    annotation(Line(points={{152,-30},{164,-30},{164,44},{92,44}},
      color={0,0,127}));
  connect(pla.port_bHeaWat, volHeaWat.ports[1])
    annotation(Line(points={{-40,-90},{-20,-90},{-20,-100},{-1,-100}},
      color={0,127,255}));
  connect(volHeaWat.ports[2], pipHeaWatSup[1].port_a)
    annotation(Line(points={{1,-100},{30,-100}},
      color={0,127,255}));
  connect(pipHeaWatRet[1].port_b, VHeaWat_flow.port_a)
    annotation(Line(points={{30,-140},{10,-140}},
      color={0,127,255}));
  connect(VHeaWat_flow.port_b, pla.port_aHeaWat)
    annotation(Line(points={{-10,-140},{-30,-140},{-30,-98},{-40,-98}},
      color={0,127,255}));
  connect(pla.port_bChiWat, volChiWat.ports[1])
    annotation(Line(points={{-40,-76},{-20,-76},{-20,-40},{-1,-40}},
      color={0,127,255}));
  connect(volChiWat.ports[2], pipChiWatSup[1].port_a)
    annotation(Line(points={{1,-40},{30,-40}},
      color={0,127,255}));
  connect(pipChiWatRet[1].port_b, VChiWat_flow.port_a)
    annotation(Line(points={{30,-80},{10,-80}},
      color={0,127,255}));
  connect(VChiWat_flow.port_b, pla.port_aChiWat)
    annotation(Line(points={{-10,-80},{-40,-80},{-40,-84}},
      color={0,127,255}));
annotation(
  experiment(StopTime=86400,
    Tolerance=1e-06,
    __Dymola_Algorithm="Cvode"),
  Documentation(
    info="<html>
<p>
  This model is a variant of
  <a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Validation.HardCase1\">
    Buildings.Templates.Plants.HeatPumps.Validation.HardCase1</a>
  in which the single aggregated load of each loop is replaced by
  <code>nLoa</code> terminal units distributed along a supply and a return
  main. It is used to assess how the cost of the plant hydraulic equations
  scales with the number of components exposed to the plant supply pressure.
</p>
<p>
  Terminal unit <i>1</i> is the closest to the plant, terminal unit
  <code>nLoa</code> the most remote. Each main is split into <code>nLoa</code>
  segments of equal design pressure drop, each sized for the flow rate it
  carries at design conditions. The total pressure drop of the two mains and
  the pressure drop of the most remote branch are independent of
  <code>nLoa</code> and equal to those of the aggregated load model, so the
  design operating point of the plant is unchanged. The primary balancing
  valve of each branch absorbs the additional pressure available closer to the
  plant.
</p>
<p>
  The remote differential pressure sensors are located just upstream of the
  last connected terminal unit. The plant requests and reset requests are
  generated from the maximum valve position over all terminal units of each
  loop.
</p>
</html>

Sizes after manipulation of the nonlinear systems: {31, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
Number of numerical Jacobians: 24


Warning: Failed to solve nonlinear system using Newton solver.
  During initialization at time: 0
  Tag: initialization.nonlinear[25]

  Common causes:
   * The system of equations has no solution - the residual will be above zero.
     - This may be caused by initial conditions not being fully specified, check the translation log.
     - In some cases the event-logic can cause this.
   * Starting values are too far from the solution, see homotopy in the manual.
     - In rare cases this could occur at events.
   * The equations are too discontinuous for the nonlinear solver - the residual will have knees.
     - Likely caused by over-using noEvent.
  Especially consider the first two items above when the nonlinear solver fails during initialization.

  To get more information consider the options:
   * Simulation/Setup/Translation/Generate listing of translated Modelica code in dsmodel.mof
   * Simulation/Setup/Translation/List non-linear iteration variables
   * Simulation/Setup/Debug/Store variables after failed initialization
     - If a failure to solve a nonlinear equation caused failed initialization.
   * The options under the group Simulation/Setup/Debug/Nonlinear solver diagnostics

  Jacobian inverse norm estimate: 6.80175e+14
  Condition number estimate: 5.7452e+13
  1-norm of the residual = 1.3448E+11
  The residual is large, using better start values can be a solution.

  Last value of the solution:
    pla.pumPri.pumChiWat.valChe[1].dp = -7.95346E-05
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 300005
    pipHeaWatRet[1].dp = 9.7789E-06
    pipHeaWatRet[12].dp = -8.99087E-08
    pipHeaWatSup[11].dp = -8.97763E-08
    pipHeaWatSup[10].dp = -9.01073E-08
    pipHeaWatSup[9].dp = 0.000235485
    pipHeaWatSup[8].dp = 2.36282E-05
    pipHeaWatSup[7].dp = 1.96895E-05
    pipHeaWatSup[6].dp = 1.6876E-05
    pipHeaWatSup[5].dp = 1.4766E-05
    pipHeaWatSup[4].dp = 1.31248E-05
    pipHeaWatSup[3].dp = 1.18119E-05
    pipHeaWatSup[2].dp = 1.0796E-05
    pla.valIso.valHeaWatUniInlIso[3].port_b.p = 300005
    dpChiWatRem[1].port_a.p = 300005
    pipChiWatSup[12].dp = 1.48191E-12
    pipChiWatSup[11].dp = 1.48195E-12
    pipChiWatSup[10].dp = 1.48195E-12
    pipChiWatRet[9].dp = 1.45895E-12
    pipChiWatSup[8].dp = 1.48195E-12
    pipChiWatSup[7].dp = 1.48195E-12
    pipChiWatSup[6].dp = 1.48196E-12
    pipChiWatSup[5].dp = 1.48196E-12
    pipChiWatSup[4].dp = 1.48196E-12
    pipChiWatSup[3].dp = 1.48196E-12
    pipChiWatSup[2].dp = 1.48196E-12
    pla.pumPri.pumChiWat.valChe[3].dp = -7.95046E-05
    pla.pumPri.pumHeaWat.valChe[2].dp = 0.0328714
    pla.valIso.port_aChiWat.m_flow = 1.91614E-06
    pla.valChiWatMinByp.lin.dp = 3.62795E-05
    pipChiWatSup[1].dp = 1.48195E-12
  Last value of the residual:
    { 1.22917E-06, 1.23278E-06, 1.23278E-06, 1.23272E-06, 1.23272E-06,
      1.23284E-06, 1.2333E-06, 3.56062E-06, -1.09582E-06, 1.23237E-06,
      1.23325E-06, 1.23138E-06, 51.7938, 35.5606, 35.5597,
      35.5597, 35.5597, 35.5588, -6.72401E+10, -6.724E+10,
      0.0284882, -0.0217854, 19.7318, -20.2456, -0.587962,
      1.32327E-09, 0.506487, 53.6186, 39.4709, -19.4049,
      2.21791E-15, -0.559094 }
 
Trying to solve non-linear system using global homotopy-method.
Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase1NLoads
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 21817.64718820151
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 6.31635e+11
  Condition number estimate: 1.26327e+11
  1-norm of the residual = 5245.62
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 306081
    pla.pumPri.pumChiWat.valChe[3].dp = 66.9568
    pla.valIso.valHeaWatUniInlIso[3].port_b.p = 306078
    pipHeaWatSup[12].port_a.m_flow = 3.11878
    pipHeaWatSup[11].port_a.m_flow = 6.23756
    pipHeaWatSup[10].port_a.m_flow = 9.35634
    pipHeaWatSup[9].port_a.m_flow = 12.4751
    pipHeaWatSup[8].port_a.m_flow = 15.5939
    pipHeaWatSup[7].port_a.m_flow = 18.7127
    pipHeaWatSup[6].port_a.m_flow = 21.8315
    pipHeaWatSup[5].port_a.m_flow = 24.9502
    pipHeaWatSup[4].port_a.m_flow = 28.069
    pipHeaWatSup[3].port_a.m_flow = 31.1878
    pipHeaWatSup[2].port_a.m_flow = 34.3066
    loaHea[1].port_a.m_flow = 3.11878
    pla.pumPri.pumHeaWat.valChe[2].dp = 14595.3
    pla.pumPri.pumChiWat.valChe[2].dp = 66.955
    pla.valIso.valChiWatUniInlIso[3].lin.dp = 17.2327
    pla.port_aChiWat.m_flow = -4.17295E-08
    pipChiWatSup[9].port_a.m_flow = -7.62227E-08
    pla.valIso.port_aChiWat.m_flow = 8.17532E-07
    pipChiWatSup[2].port_a.m_flow = -1.35008E-07
    pipChiWatSup[3].port_a.m_flow = -1.52322E-07
    pipChiWatSup[4].port_a.m_flow = -1.55215E-07
    pipChiWatSup[5].port_a.m_flow = -1.46351E-07
    pipChiWatSup[6].port_a.m_flow = -1.31192E-07
    pipChiWatSup[7].port_a.m_flow = -1.13324E-07
    pipChiWatSup[8].port_a.m_flow = -9.47369E-08
    pipChiWatSup[10].port_a.m_flow = -5.78978E-08
    pipChiWatSup[11].port_a.m_flow = -3.95493E-08
    pipChiWatSup[12].port_a.m_flow = -2.06551E-08
  Last value of the residual:
    { -286.05, -340.352, -384.627, -408.33, -418.532,
      -421.24, -420.965, -420.252, -420.341, -422.396,
      -429.027, -0.000325298, -0.000401626, -0.000403495, -0.000367046,
      -0.00032442, -0.000286255, -0.000258319, -0.000242763, -0.000237839,
      -0.00023862, -0.000236542, -5.48353E-07, 5.85521E-07, -435.436,
      -435.438, 0.000587279, -6.33016E-08, 6.33298E-08, 2.63374,
      -9.2393E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 22019.39658486529
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 6.49644e+11
  Condition number estimate: 1.36744e+11
  1-norm of the residual = 14359
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 309101
    pla.pumPri.pumChiWat.valChe[3].dp = 111.066
    pla.valIso.valHeaWatUniInlIso[3].port_b.p = 309087
    pipHeaWatSup[12].port_a.m_flow = 2.94916
    pipHeaWatSup[11].port_a.m_flow = 5.89832
    pipHeaWatSup[10].port_a.m_flow = 8.84748
    pipHeaWatSup[9].port_a.m_flow = 11.7966
    pipHeaWatSup[8].port_a.m_flow = 14.7458
    pipHeaWatSup[7].port_a.m_flow = 17.695
    pipHeaWatSup[6].port_a.m_flow = 20.6441
    pipHeaWatSup[5].port_a.m_flow = 23.5933
    pipHeaWatSup[4].port_a.m_flow = 26.5424
    pipHeaWatSup[3].port_a.m_flow = 29.4916
    pipHeaWatSup[2].port_a.m_flow = 32.4408
    loaHea[1].port_a.m_flow = 2.94916
    pla.pumPri.pumHeaWat.valChe[2].dp = 13622.6
    pla.pumPri.pumChiWat.valChe[2].dp = 111.066
    pla.valIso.valChiWatUniInlIso[3].lin.dp = -5958.36
    pla.port_aChiWat.m_flow = 1.78575E-05
    pipChiWatSup[9].port_a.m_flow = 6.16177E-06
    pla.valIso.port_aChiWat.m_flow = -0.000300626
    pipChiWatSup[2].port_a.m_flow = 1.66323E-05
    pipChiWatSup[3].port_a.m_flow = 1.52468E-05
    pipChiWatSup[4].port_a.m_flow = 1.37967E-05
    pipChiWatSup[5].port_a.m_flow = 1.22992E-05
    pipChiWatSup[6].port_a.m_flow = 1.07748E-05
    pipChiWatSup[7].port_a.m_flow = 9.23893E-06
    pipChiWatSup[8].port_a.m_flow = 7.70021E-06
    pipChiWatSup[10].port_a.m_flow = 4.62405E-06
    pipChiWatSup[11].port_a.m_flow = 3.08625E-06
    pipChiWatSup[12].port_a.m_flow = 1.54642E-06
  Last value of the residual:
    { 603.518, 846.687, 1025.46, 1126.78, 1169.67,
      1180.58, 1179.5, 1176.79, 1177.1, 1184.75,
      1209.56, -0.0101894, -0.00791035, -0.00573587, -0.00380824,
      -0.00219419, -0.000932178, -2.79157E-05, 0.000540264, 0.000816577,
      0.000866814, 0.00079964, 8.40192E-07, 7.0398E-07, 1233.65,
      1233.65, 1.74624, -4.29052E-08, 4.44367E-08, 9.5456,
      -1.01784E-06 }
 
SUNDIALS: CVODE CVode At t = 22021.3, mxstep steps taken before reaching tout.

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 24015.03206556056
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 3.5253e+11
  Condition number estimate: 6.63334e+10
  1-norm of the residual = 1975.23
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 301811
    pla.pumPri.pumChiWat.valChe[3].dp = 67.2031
    pla.valIso.valHeaWatUniInlIso[3].port_b.p = 301807
    pipHeaWatSup[12].port_a.m_flow = 3.32465
    pipHeaWatSup[11].port_a.m_flow = 6.64931
    pipHeaWatSup[10].port_a.m_flow = 9.97396
    pipHeaWatSup[9].port_a.m_flow = 13.2986
    pipHeaWatSup[8].port_a.m_flow = 16.6233
    pipHeaWatSup[7].port_a.m_flow = 19.9479
    pipHeaWatSup[6].port_a.m_flow = 23.2726
    pipHeaWatSup[5].port_a.m_flow = 26.5972
    pipHeaWatSup[4].port_a.m_flow = 29.9219
    pipHeaWatSup[3].port_a.m_flow = 33.2465
    pipHeaWatSup[2].port_a.m_flow = 36.5712
    loaHea[1].port_a.m_flow = 3.32465
    pla.pumPri.pumHeaWat.valChe[2].dp = 15972.9
    pla.pumPri.pumChiWat.valChe[2].dp = 67.203
    pla.valIso.valChiWatUniInlIso[3].lin.dp = -912.806
    pla.port_aChiWat.m_flow = 2.60763E-06
    pipChiWatSup[9].port_a.m_flow = 8.93495E-07
    pla.valIso.port_aChiWat.m_flow = -4.60757E-05
    pipChiWatSup[2].port_a.m_flow = 2.42669E-06
    pipChiWatSup[3].port_a.m_flow = 2.22171E-06
    pipChiWatSup[4].port_a.m_flow = 2.00652E-06
    pipChiWatSup[5].port_a.m_flow = 1.78603E-06
    pipChiWatSup[6].port_a.m_flow = 1.56331E-06
    pipChiWatSup[7].port_a.m_flow = 1.34E-06
    pipChiWatSup[8].port_a.m_flow = 1.11669E-06
    pipChiWatSup[10].port_a.m_flow = 6.70391E-07
    pipChiWatSup[11].port_a.m_flow = 4.47277E-07
    pipChiWatSup[12].port_a.m_flow = 2.23959E-07
  Last value of the residual:
    { 90.5265, 128.964, 148.92, 157.317, 159.554,
      159.546, 159.093, 158.767, 158.803, 159.572,
      161.987, 0.00254538, 0.00184008, 0.00125211, 0.000789242,
      0.00044732, 0.000212089, 6.32391E-05, -2.16832E-05, -6.44628E-05,
      -8.48628E-05, -9.81371E-05, -1.79345E-07, -2.06182E-07, 164.248,
      164.248, 0.0136233, 1.96009E-08, -2.01799E-08, 3.66825,
      2.7683E-07 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 23995.77977827807
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 6.17437e+11
  Condition number estimate: 1.19543e+11
  1-norm of the residual = 249.19
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 303729
    pla.pumPri.pumChiWat.valChe[3].dp = 270.647
    pla.valIso.valHeaWatUniInlIso[3].port_b.p = 303539
    pipHeaWatSup[12].port_a.m_flow = 3.19972
    pipHeaWatSup[11].port_a.m_flow = 6.39944
    pipHeaWatSup[10].port_a.m_flow = 9.59916
    pipHeaWatSup[9].port_a.m_flow = 12.7989
    pipHeaWatSup[8].port_a.m_flow = 15.9986
    pipHeaWatSup[7].port_a.m_flow = 19.1983
    pipHeaWatSup[6].port_a.m_flow = 22.3981
    pipHeaWatSup[5].port_a.m_flow = 25.5978
    pipHeaWatSup[4].port_a.m_flow = 28.7975
    pipHeaWatSup[3].port_a.m_flow = 31.9972
    pipHeaWatSup[2].port_a.m_flow = 35.1969
    loaHea[1].port_a.m_flow = 3.19972
    pla.pumPri.pumHeaWat.valChe[2].dp = 15382.2
    pla.pumPri.pumChiWat.valChe[2].dp = 270.647
    pla.valIso.valChiWatUniInlIso[3].lin.dp = -271.162
    pla.port_aChiWat.m_flow = 4.90058E-08
    pipChiWatSup[9].port_a.m_flow = 9.18502E-09
    pla.valIso.port_aChiWat.m_flow = -1.68501E-05
    pipChiWatSup[2].port_a.m_flow = 4.07769E-08
    pipChiWatSup[3].port_a.m_flow = 3.46058E-08
    pipChiWatSup[4].port_a.m_flow = 2.90596E-08
    pipChiWatSup[5].port_a.m_flow = 2.41507E-08
    pipChiWatSup[6].port_a.m_flow = 1.97853E-08
    pipChiWatSup[7].port_a.m_flow = 1.58808E-08
    pipChiWatSup[8].port_a.m_flow = 1.23664E-08
    pipChiWatSup[10].port_a.m_flow = 6.29935E-09
    pipChiWatSup[11].port_a.m_flow = 3.70695E-09
    pipChiWatSup[12].port_a.m_flow = 1.48437E-09
  Last value of the residual:
    { -7.74887, -10.1021, -12.502, -14.5483, -16.284,
      -17.7531, -19.0069, -20.1205, -21.2249, -22.6174,
      -25.3972, -1.87008E-05, -1.43622E-05, -1.0171E-05, -6.82654E-06,
      -4.30632E-06, -2.48395E-06, -1.22772E-06, -4.14613E-07, 6.99074E-08,
      3.42901E-07, 5.86733E-07, -1.78984E-09, 4.65527E-09, -30.4943,
      -30.4941, 0.113503, -5.42257E-10, 5.74872E-10, 0.782285,
      -2.1321E-09 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 27172.01013823501
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 4.55569e+10
  Condition number estimate: 3.08996e+10
  1-norm of the residual = 2.83367E+09
  The residual is large, using better start values can be a solution.

  Last value of the solution:
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 319702
    pla.pumPri.pumChiWat.valChe[3].dp = 2426.15
    pla.valIso.valHeaWatUniInlIso[3].port_b.p = 289755
    pipHeaWatSup[12].port_a.m_flow = 2.90331
    pipHeaWatSup[11].port_a.m_flow = 5.6803
    pipHeaWatSup[10].port_a.m_flow = 8.54633
    pipHeaWatSup[9].port_a.m_flow = 11.4634
    pipHeaWatSup[8].port_a.m_flow = 14.4033
    pipHeaWatSup[7].port_a.m_flow = 17.3555
    pipHeaWatSup[6].port_a.m_flow = 20.3152
    pipHeaWatSup[5].port_a.m_flow = 23.277
    pipHeaWatSup[4].port_a.m_flow = 26.2486
    pipHeaWatSup[3].port_a.m_flow = 29.3517
    pipHeaWatSup[2].port_a.m_flow = 32.9
    loaHea[1].port_a.m_flow = 2.86018
    pla.pumPri.pumHeaWat.valChe[2].dp = 16913.7
    pla.pumPri.pumChiWat.valChe[2].dp = 1167.15
    pla.valIso.valChiWatUniInlIso[3].lin.dp = 13831.3
    pla.port_aChiWat.m_flow = 0.169802
    pipChiWatSup[9].port_a.m_flow = 3.59853E-05
    pla.valIso.port_aChiWat.m_flow = -0.0347702
    pipChiWatSup[2].port_a.m_flow = 0.128694
    pipChiWatSup[3].port_a.m_flow = 0.0281158
    pipChiWatSup[4].port_a.m_flow = 0.0010746
    pipChiWatSup[5].port_a.m_flow = 9.60476E-05
    pipChiWatSup[6].port_a.m_flow = 7.10844E-05
    pipChiWatSup[7].port_a.m_flow = 6.0447E-05
    pipChiWatSup[8].port_a.m_flow = 4.86969E-05
    pipChiWatSup[10].port_a.m_flow = 2.29255E-05
    pipChiWatSup[11].port_a.m_flow = 1.07201E-05
    pipChiWatSup[12].port_a.m_flow = 1.64571E-06
  Last value of the residual:
    { 6.61243E+08, -7.85448E+07, -1.87024E+08, -1.90616E+08, -1.9067E+08,
      -1.90665E+08, -1.90662E+08, -1.9066E+08, -1.90664E+08, -1.90675E+08,
      -1.90703E+08, 49746.3, 16041.6, 7399.05, 6629.35,
      6318.92, 5715.27, 4919.45, 3725.33, 1602.6,
      -1399.22, 2761.55, -0.894388, -13.2391, -1.90712E+08,
      -1.90726E+08, 4.56818, 1.90319, -1.86844, 1940.88,
      8.79647 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 27206.54236884509
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 6.88766e+11
  Condition number estimate: 6.2061e+11
  1-norm of the residual = 3.77843E+07
  The residual is large, using better start values can be a solution.

  Last value of the solution:
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 350608
    pla.pumPri.pumChiWat.valChe[3].dp = 714.937
    pla.valIso.valHeaWatUniInlIso[3].port_b.p = 349893
    pipHeaWatSup[12].port_a.m_flow = 0.607865
    pipHeaWatSup[11].port_a.m_flow = 1.22041
    pipHeaWatSup[10].port_a.m_flow = 1.83585
    pipHeaWatSup[9].port_a.m_flow = 2.45338
    pipHeaWatSup[8].port_a.m_flow = 3.07257
    pipHeaWatSup[7].port_a.m_flow = 3.6933
    pipHeaWatSup[6].port_a.m_flow = 4.31572
    pipHeaWatSup[5].port_a.m_flow = 4.9403
    pipHeaWatSup[4].port_a.m_flow = 5.56735
    pipHeaWatSup[3].port_a.m_flow = 6.19583
    pipHeaWatSup[2].port_a.m_flow = 6.82009
    loaHea[1].port_a.m_flow = 0.623108
    pla.pumPri.pumHeaWat.valChe[2].dp = 1892.88
    pla.pumPri.pumChiWat.valChe[2].dp = 1149.25
    pla.valIso.valChiWatUniInlIso[3].lin.dp = 130221
    pla.port_aChiWat.m_flow = -0.000457971
    pipChiWatSup[9].port_a.m_flow = -0.000148618
    pla.valIso.port_aChiWat.m_flow = 0.00652281
    pipChiWatSup[2].port_a.m_flow = -0.00113694
    pipChiWatSup[3].port_a.m_flow = -0.000401841
    pipChiWatSup[4].port_a.m_flow = -0.000332015
    pipChiWatSup[5].port_a.m_flow = -0.000295995
    pipChiWatSup[6].port_a.m_flow = -0.000259721
    pipChiWatSup[7].port_a.m_flow = -0.000223041
    pipChiWatSup[8].port_a.m_flow = -0.000186
    pipChiWatSup[10].port_a.m_flow = -0.000110974
    pipChiWatSup[11].port_a.m_flow = -7.32736E-05
    pipChiWatSup[12].port_a.m_flow = -3.59681E-05
  Last value of the residual:
    { -5.32515E+06, -2.81981E+06, -2.69251E+06, -2.69346E+06, -2.695E+06,
      -2.69635E+06, -2.69764E+06, -2.69862E+06, -2.69884E+06, -2.69735E+06,
      -2.69231E+06, 27.7305, 87.948, 82.1376, 67.6919,
      59.3346, 57.1709, 58.0858, 59.6863, 60.4209,
      58.9208, 52.5707, 1.92408, 0.607525, -2.68854E+06,
      -2.68781E+06, 1.06046, 0.034626, -0.0345907, 224.703,
      -0.821291 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 27244.40544464295
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 4.68943e+14
  Condition number estimate: 1.64402e+14
  1-norm of the residual = 2.26966E+07
  The residual is large, using better start values can be a solution.

  Last value of the solution:
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 351334
    pla.pumPri.pumChiWat.valChe[3].dp = 880.301
    pla.valIso.valHeaWatUniInlIso[3].port_b.p = 351295
    pipHeaWatSup[12].port_a.m_flow = -0.00103859
    pipHeaWatSup[11].port_a.m_flow = -0.00204071
    pipHeaWatSup[10].port_a.m_flow = 0.00400164
    pipHeaWatSup[9].port_a.m_flow = 0.0121525
    pipHeaWatSup[8].port_a.m_flow = 0.0236013
    pipHeaWatSup[7].port_a.m_flow = 0.0396414
    pipHeaWatSup[6].port_a.m_flow = 0.0609928
    pipHeaWatSup[5].port_a.m_flow = 0.0878265
    pipHeaWatSup[4].port_a.m_flow = 0.119976
    pipHeaWatSup[3].port_a.m_flow = 0.157124
    pipHeaWatSup[2].port_a.m_flow = 0.198914
    loaHea[1].port_a.m_flow = 0.046111
    pla.pumPri.pumHeaWat.valChe[2].dp = -1856.75
    pla.pumPri.pumChiWat.valChe[2].dp = 103.427
    pla.valIso.valChiWatUniInlIso[3].lin.dp = 3.68291E+06
    pla.port_aChiWat.m_flow = -0.0109948
    pipChiWatSup[9].port_a.m_flow = -0.00386463
    pla.valIso.port_aChiWat.m_flow = 0.185079
    pipChiWatSup[2].port_a.m_flow = -0.0105001
    pipChiWatSup[3].port_a.m_flow = -0.00951881
    pipChiWatSup[4].port_a.m_flow = -0.00863643
    pipChiWatSup[5].port_a.m_flow = -0.00771194
    pipChiWatSup[6].port_a.m_flow = -0.00675934
    pipChiWatSup[7].port_a.m_flow = -0.00579512
    pipChiWatSup[8].port_a.m_flow = -0.00482924
    pipChiWatSup[10].port_a.m_flow = -0.00290106
    pipChiWatSup[11].port_a.m_flow = -0.00193746
    pipChiWatSup[12].port_a.m_flow = -0.000971904
  Last value of the residual:
    { -1.83313E+06, -1.46035E+06, -1.61902E+06, -1.72488E+06, -1.76867E+06,
      -1.77492E+06, -1.77013E+06, -1.76619E+06, -1.76633E+06, -1.7737E+06,
      -1.79761E+06, 0.120288, 0.204847, 0.247202, 0.266504,
      0.284914, 0.323209, 0.393687, 0.47534, 0.414299,
      -0.646149, -0.893086, 0.182559, -0.0320925, -1.8203E+06,
      -1.82111E+06, 0.0903496, 0.000343131, -0.000376326, -191.99,
      -0.257176 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 27206.6748252385
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 2.63548e+11
  Condition number estimate: 5.45879e+10
  1-norm of the residual = 243.8
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 317048
    pla.pumPri.pumChiWat.valChe[3].dp = 217.562
    pla.valIso.valHeaWatUniInlIso[3].port_b.p = 316964
    pipHeaWatSup[12].port_a.m_flow = 3.01812
    pipHeaWatSup[11].port_a.m_flow = 6.03625
    pipHeaWatSup[10].port_a.m_flow = 9.05437
    pipHeaWatSup[9].port_a.m_flow = 12.0725
    pipHeaWatSup[8].port_a.m_flow = 15.0906
    pipHeaWatSup[7].port_a.m_flow = 18.1087
    pipHeaWatSup[6].port_a.m_flow = 21.1269
    pipHeaWatSup[5].port_a.m_flow = 24.145
    pipHeaWatSup[4].port_a.m_flow = 27.1631
    pipHeaWatSup[3].port_a.m_flow = 30.1812
    pipHeaWatSup[2].port_a.m_flow = 33.1994
    loaHea[1].port_a.m_flow = 3.01812
    pla.pumPri.pumHeaWat.valChe[2].dp = 11069.6
    pla.pumPri.pumChiWat.valChe[2].dp = 217.562
    pla.valIso.valChiWatUniInlIso[3].lin.dp = -212.03
    pla.port_aChiWat.m_flow = -1.13543E-09
    pipChiWatSup[9].port_a.m_flow = -4.61259E-09
    pla.valIso.port_aChiWat.m_flow = -1.20954E-05
    pipChiWatSup[2].port_a.m_flow = -5.45703E-09
    pipChiWatSup[3].port_a.m_flow = -7.21373E-09
    pipChiWatSup[4].port_a.m_flow = -8.02597E-09
    pipChiWatSup[5].port_a.m_flow = -8.05819E-09
    pipChiWatSup[6].port_a.m_flow = -7.54432E-09
    pipChiWatSup[7].port_a.m_flow = -6.69766E-09
    pipChiWatSup[8].port_a.m_flow = -5.6848E-09
    pipChiWatSup[10].port_a.m_flow = -3.53021E-09
    pipChiWatSup[11].port_a.m_flow = -2.43979E-09
    pipChiWatSup[12].port_a.m_flow = -1.30131E-09
  Last value of the residual:
    { -9.65836, -13.2148, -16.1521, -18.2084, -19.4616,
      -20.0875, -20.3109, -20.3492, -20.3795, -20.5605,
      -21.1736, -1.06032E-05, -8.26019E-06, -6.91664E-06, -6.5472E-06,
      -6.55872E-06, -6.59749E-06, -6.46093E-06, -6.07711E-06, -5.482E-06,
      -4.80656E-06, -4.38874E-06, -1.50155E-09, 4.80895E-09, -21.8171,
      -21.8171, 0.0421367, -7.61959E-10, 7.59556E-10, 0.566912,
      -2.34482E-09 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 28956.83899122524
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 6.36773e+11
  Condition number estimate: 1.38973e+11
  1-norm of the residual = 79703.9
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 320163
    pla.pumPri.pumChiWat.valChe[3].dp = 168.713
    pla.valIso.valHeaWatUniInlIso[3].port_b.p = 320125
    pipHeaWatSup[12].port_a.m_flow = 2.70658
    pipHeaWatSup[11].port_a.m_flow = 5.41315
    pipHeaWatSup[10].port_a.m_flow = 8.11973
    pipHeaWatSup[9].port_a.m_flow = 10.8263
    pipHeaWatSup[8].port_a.m_flow = 13.5329
    pipHeaWatSup[7].port_a.m_flow = 16.2395
    pipHeaWatSup[6].port_a.m_flow = 18.946
    pipHeaWatSup[5].port_a.m_flow = 21.6526
    pipHeaWatSup[4].port_a.m_flow = 24.3592
    pipHeaWatSup[3].port_a.m_flow = 27.0658
    pipHeaWatSup[2].port_a.m_flow = 29.7723
    loaHea[1].port_a.m_flow = 2.70658
    pla.pumPri.pumHeaWat.valChe[2].dp = 10058
    pla.pumPri.pumChiWat.valChe[2].dp = 168.92
    pla.valIso.valChiWatUniInlIso[3].lin.dp = 178.395
    pla.port_aChiWat.m_flow = 2.70958E-06
    pipChiWatSup[9].port_a.m_flow = -1.2175E-07
    pla.valIso.port_aChiWat.m_flow = 8.36278E-06
    pipChiWatSup[2].port_a.m_flow = 1.01755E-06
    pipChiWatSup[3].port_a.m_flow = 4.79807E-07
    pipChiWatSup[4].port_a.m_flow = 1.00962E-07
    pipChiWatSup[5].port_a.m_flow = -8.19269E-08
    pipChiWatSup[6].port_a.m_flow = -1.47239E-07
    pipChiWatSup[7].port_a.m_flow = -1.54268E-07
    pipChiWatSup[8].port_a.m_flow = -1.39884E-07
    pipChiWatSup[10].port_a.m_flow = -1.04987E-07
    pipChiWatSup[11].port_a.m_flow = -8.73188E-08
    pipChiWatSup[12].port_a.m_flow = -5.98208E-08
  Last value of the residual:
    { -4346.59, -4944.94, -5682.83, -6125.58, -6345.05,
      -6425.68, -6439.8, -6434.64, -6438.05, -6475.06,
      -6596.78, -0.0466377, -0.0328843, -0.0193943, -0.00744783,
      0.00191383, 0.00838675, 0.0120243, 0.0131687, 0.0123807,
      0.0103785, 0.00818931, 8.96253E-06, 1.13915E-06, -6718.88,
      -6718.63, 0.00871089, 1.10976E-06, -1.11294E-06, 11.2173,
      -5.5942E-06 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 36016.98260032378
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 9.09727e+10
  Condition number estimate: 2.95883e+11
  1-norm of the residual = 103754
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 337224
    pla.pumPri.pumChiWat.valChe[3].dp = -38310.3
    pla.valIso.valHeaWatUniInlIso[3].port_b.p = 306861
    pipHeaWatSup[12].port_a.m_flow = 2.73035
    pipHeaWatSup[11].port_a.m_flow = 5.46069
    pipHeaWatSup[10].port_a.m_flow = 8.19104
    pipHeaWatSup[9].port_a.m_flow = 10.9214
    pipHeaWatSup[8].port_a.m_flow = 13.6517
    pipHeaWatSup[7].port_a.m_flow = 16.3821
    pipHeaWatSup[6].port_a.m_flow = 19.1124
    pipHeaWatSup[5].port_a.m_flow = 21.8428
    pipHeaWatSup[4].port_a.m_flow = 24.5731
    pipHeaWatSup[3].port_a.m_flow = 27.3035
    pipHeaWatSup[2].port_a.m_flow = 30.0338
    loaHea[1].port_a.m_flow = 2.73035
    pla.pumPri.pumHeaWat.valChe[2].dp = 14354.4
    pla.pumPri.pumChiWat.valChe[2].dp = -38310.3
    pla.valIso.valChiWatUniInlIso[3].lin.dp = 37831.6
    pla.port_aChiWat.m_flow = -1.86319E-05
    pipChiWatSup[9].port_a.m_flow = 4.87765E-06
    pla.valIso.port_aChiWat.m_flow = 0.00139703
    pipChiWatSup[2].port_a.m_flow = 9.11026E-06
    pipChiWatSup[3].port_a.m_flow = 5.60491E-06
    pipChiWatSup[4].port_a.m_flow = 7.87404E-06
    pipChiWatSup[5].port_a.m_flow = 8.4695E-06
    pipChiWatSup[6].port_a.m_flow = 8.04348E-06
    pipChiWatSup[7].port_a.m_flow = 7.11295E-06
    pipChiWatSup[8].port_a.m_flow = 6.00606E-06
    pipChiWatSup[10].port_a.m_flow = 3.76791E-06
    pipChiWatSup[11].port_a.m_flow = 2.65369E-06
    pipChiWatSup[12].port_a.m_flow = 1.45924E-06
  Last value of the residual:
    { 8686.11, 7080.94, 7546.18, 7830.13, 7970.37,
      8019.39, 8025.38, 8020.19, 8021.43, 8043.73,
      8117.34, 0.000139973, -0.000361582, -0.000793656, -0.00109608,
      -0.0012337, -0.00120193, -0.00102678, -0.000758633, -0.000460936,
      -0.000195431, -3.63187E-06, 1.20454E-08, -2.50255E-08, 8190.41,
      8190.41, 1.40607E-05, -3.59255E-09, 1.36182E-08, -12.3422,
      1.95943E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 36310.53622082651
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 4.28781e+08
  Condition number estimate: 9.92634e+07
  1-norm of the residual = 18540.1
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 351325
    pla.pumPri.pumChiWat.valChe[3].dp = -29839.5
    pla.valIso.valHeaWatUniInlIso[3].port_b.p = 322802
    pipHeaWatSup[12].port_a.m_flow = 2.14081
    pipHeaWatSup[11].port_a.m_flow = 4.28164
    pipHeaWatSup[10].port_a.m_flow = 6.4225
    pipHeaWatSup[9].port_a.m_flow = 8.5634
    pipHeaWatSup[8].port_a.m_flow = 10.7043
    pipHeaWatSup[7].port_a.m_flow = 12.8452
    pipHeaWatSup[6].port_a.m_flow = 14.9862
    pipHeaWatSup[5].port_a.m_flow = 17.1271
    pipHeaWatSup[4].port_a.m_flow = 19.268
    pipHeaWatSup[3].port_a.m_flow = 21.4089
    pipHeaWatSup[2].port_a.m_flow = 23.5498
    loaHea[1].port_a.m_flow = 2.14082
    pla.pumPri.pumHeaWat.valChe[2].dp = 9205.8
    pla.pumPri.pumChiWat.valChe[2].dp = -29839.4
    pla.valIso.valChiWatUniInlIso[3].lin.dp = 23497.7
    pla.port_aChiWat.m_flow = 0.66183
    pipChiWatSup[9].port_a.m_flow = 0.224146
    pla.valIso.port_aChiWat.m_flow = -0.0101818
    pipChiWatSup[2].port_a.m_flow = 0.614356
    pipChiWatSup[3].port_a.m_flow = 0.556144
    pipChiWatSup[4].port_a.m_flow = 0.499848
    pipChiWatSup[5].port_a.m_flow = 0.445051
    pipChiWatSup[6].port_a.m_flow = 0.390957
    pipChiWatSup[7].port_a.m_flow = 0.336113
    pipChiWatSup[8].port_a.m_flow = 0.280215
    pipChiWatSup[10].port_a.m_flow = 0.168153
    pipChiWatSup[11].port_a.m_flow = 0.112171
    pipChiWatSup[12].port_a.m_flow = 0.0561532
  Last value of the residual:
    { 1817.39, 1475.4, 1217.99, 1104.06, 1242.15,
      1435.98, 1474.43, 1468.78, 1474.91, 1489.17,
      1521.38, 2.34256, 5.34265, 7.48839, 8.68938,
      8.94838, 8.34791, 7.06047, 5.34221, 3.49951,
      1.83872, 0.609256, -0.00142751, -0.00222251, 1367.07,
      1381.31, 0.000449999, 0.00558296, 0.00530436, 10.5696,
      0.00253763 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 36312.18673354972
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 2.03406e+07
  Condition number estimate: 4.79312e+06
  1-norm of the residual = 7647.22
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 351327
    pla.pumPri.pumChiWat.valChe[3].dp = -25984.1
    pla.valIso.valHeaWatUniInlIso[3].port_b.p = 325739
    pipHeaWatSup[12].port_a.m_flow = 2.02469
    pipHeaWatSup[11].port_a.m_flow = 4.04939
    pipHeaWatSup[10].port_a.m_flow = 6.07409
    pipHeaWatSup[9].port_a.m_flow = 8.09881
    pipHeaWatSup[8].port_a.m_flow = 10.1235
    pipHeaWatSup[7].port_a.m_flow = 12.1483
    pipHeaWatSup[6].port_a.m_flow = 14.173
    pipHeaWatSup[5].port_a.m_flow = 16.1977
    pipHeaWatSup[4].port_a.m_flow = 18.2224
    pipHeaWatSup[3].port_a.m_flow = 20.2471
    pipHeaWatSup[2].port_a.m_flow = 22.2718
    loaHea[1].port_a.m_flow = 2.02467
    pla.pumPri.pumHeaWat.valChe[2].dp = 8257.25
    pla.pumPri.pumChiWat.valChe[2].dp = -25984.1
    pla.valIso.valChiWatUniInlIso[3].lin.dp = 25899.5
    pla.port_aChiWat.m_flow = 0.0064439
    pipChiWatSup[9].port_a.m_flow = 0.00401432
    pla.valIso.port_aChiWat.m_flow = -0.00130439
    pipChiWatSup[2].port_a.m_flow = 0.0126215
    pipChiWatSup[3].port_a.m_flow = 0.00990201
    pipChiWatSup[4].port_a.m_flow = 0.00904082
    pipChiWatSup[5].port_a.m_flow = 0.00805572
    pipChiWatSup[6].port_a.m_flow = 0.00703896
    pipChiWatSup[7].port_a.m_flow = 0.00602355
    pipChiWatSup[8].port_a.m_flow = 0.0050157
    pipChiWatSup[10].port_a.m_flow = 0.00301726
    pipChiWatSup[11].port_a.m_flow = 0.00202127
    pipChiWatSup[12].port_a.m_flow = 0.00102004
  Last value of the residual:
    { 711.632, 563.574, 573.591, 576.259, 576.3,
      575.845, 575.476, 575.279, 575.341, 575.907,
      577.553, 0.255013, 1.68653, 2.54796, 3.04256,
      3.27329, 3.30974, 3.18912, 2.92667, 2.52787,
      2.00325, 1.40497, -0.0471302, 0.0116277, 581.935,
      579.133, -0.00112813, 0.00107713, 0.00110292, -3.11748,
      -0.044856 }
 
SUNDIALS: CVODE CVode At t = 45767.3, mxstep steps taken before reaching tout.
SUNDIALS: CVODE CVode At t = 71446.6, mxstep steps taken before reaching tout.
SUNDIALS: CVODE CVode At t = 76556.4, mxstep steps taken before reaching tout.

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 37.4828 seconds
   CPU-time for initialization               : 0.433773 seconds
   Number of result points                   : 1615
   Number of grid points                     : 501
   Number of accepted steps                  : 16895
   Number of rejected steps                  : 518
   Number of f-evaluations (dynamics)        : 25879
   Number of non-linear iteration            : 24665
   Number of non-linear convergence failures : 887
   Number of Jacobian-evaluations            : 1363
   Number of crossing function evaluations   : 19530
   Number of model time events               : 418
   Number of state events                    : 141
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1NLoads",
    revisions="<html>
<ul>
<li>
September 18, 2026, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(coordinateSystem(extent={{-200,-160},{200,160}})),
    Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={238,46,47},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}}),
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}})}));
end HardCase1NLoads;
