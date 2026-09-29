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
</html>",
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
