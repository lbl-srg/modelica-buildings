within Buildings.Templates.Plants.Boilers.HotWater.Validation;
model BoilerPlant
  "Validation of boiler plant template with G36 controls"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium";

  replaceable parameter Buildings.Templates.Plants.Boilers.HotWater.Validation.UserProject.Data.AllSystems datAll(
    pla(final cfg=pla.cfg))
    "Design and operating parameters"
    annotation(Placement(transformation(extent={{-150,90},{-130,110}})));
  parameter Modelica.Units.SI.Time tau = 10
    "Time constant at nominal flow"
    annotation(Dialog(tab="Dynamics",
      group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics =
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true,
      Dialog(tab="Dynamics",
        group="Conservation equations"));
  Buildings.Templates.Plants.Boilers.HotWater.BoilerPlant pla(
    redeclare final package Medium=Medium,
    nBoiCon_select=2,
    typArrPumHeaWatPriCon_select=Buildings.Templates.Components.Types.PumpArrangement.Headered,
    typ=Buildings.Templates.Plants.Boilers.HotWater.Types.Boiler.Condensing,
    nBoiNon_select=2,
    typPumHeaWatPriNon=Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsPrimary.Constant,
    typArrPumHeaWatPriNon_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    typPumHeaWatSec1_select=Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.Centralized,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final dat=datAll.pla,
    show_T=true,
    ctl(
      nAirHan=1,
      nEquZon=0,
      typMeaCtlHeaWatPri=Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement.FlowDecoupler,
      have_senDpHeaWatRemWir=true),
    THeaWatPriSupNon(show_T=true))
    "Boiler plant"
    annotation(Placement(transformation(extent={{-80,-100},{-40,-60}})));
  UserProject.BASControlPoints sigBAS
    "BAS control points"
    annotation(Placement(transformation(extent={{-150,-30},{-130,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TAirSup(
    k=293.15,
    y(final unit="K", displayUnit="degC"))
    "Placeholder signal for request generator"
    annotation(Placement(transformation(extent={{-150,50},{-130,70}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests reqPlaRes(
    final heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
    final cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.None)
    "Plant and reset request"
    annotation(Placement(transformation(extent={{110,30},{90,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratLoa(
    table=[0, 0; 5, 0; 7, 1; 12, 0.2; 16, 0.8; 22, 0.1; 24, 0],
    timeScale=3600)
    "Fraction of design load"
    annotation(Placement(transformation(extent={{-150,10},{-130,30}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt[2]
    "Importance multiplier"
    annotation(Placement(transformation(extent={{20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[2](each k=10)
    "Request multiplier factor"
    annotation(Placement(transformation(extent={{110,70},{90,90}})));
  AirHandlersFans.Interfaces.Bus busAirHan
    "AHU control bus"
    annotation(Placement(transformation(extent={{-60,20},{-20,60}}),
      iconTransformation(extent={{-340,-140},{-300,-100}})));
  HeatPumps.Interfaces.Bus busPla
    "Plant control bus"
    annotation(Placement(transformation(extent={{-100,-40},{-60,0}}),
      iconTransformation(extent={{-370,-70},{-330,-30}})));
  Fluid.Sensors.RelativePressure dpHeaWatRem[1](
    redeclare each final package Medium=Medium)
    "HW differential pressure at one remote location"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={80,-80})));
  Fluid.Sensors.MassFlowRate mHeaWatLoo_flow(
    redeclare final package Medium=Medium)
    "HW loop mass flow rate"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={160,-80})));
  Fluid.FixedResistances.PressureDrop pipHeaWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mHeaWat_flow_nominal,
    final dp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max - max(
      datAll.pla.ctl.dpHeaWatRemSet_max))
    "Piping"
    annotation(Placement(transformation(extent={{40,-110},{20,-90}})));
  Fluid.Sensors.TemperatureTwoPort THeaWatSup(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mHeaWat_flow_nominal)
    "HW supply temperature"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={0,-60})));
  Buildings.Templates.Components.Loads.LoadTwoWayValve loa(
    redeclare final package MediumLiq=Medium,
    final typ=Buildings.Fluid.HydronicConfigurations.Types.Control.Heating,
    final mLiq_flow_nominal=pla.mHeaWat_flow_nominal,
    dpBal1_nominal=datAll.pla.ctl.dpHeaWatRemSet_max[1] - loa.dpTer_nominal -
      loa.dpValve_nominal,
    final TLiqEnt_nominal=pla.THeaWatSup_nominal,
    final TLiqLvg_nominal=pla.THeaWatRet_nominal,
    final energyDynamics=energyDynamics)
    "Heating load"
    annotation(Placement(transformation(extent={{110,-70},{130,-50}})));
  Fluid.MixingVolumes.MixingVolume vol(
    final energyDynamics=energyDynamics,
    m_flow_nominal=pla.mHeaWat_flow_nominal,
    V=Buildings.Templates.Data.Defaults.ratVLiqByCap * pla.cap_nominal,
    redeclare package Medium=Medium,
    nPorts=2)
    "Fluid volume in distribution system"
    annotation(Placement(transformation(extent={{20,-60},{40,-40}})));
equation
  connect(TAirSup.y, reqPlaRes.TAirSup)
    annotation(Line(points={{-128,60},{120,60},{120,48},{112,48}},
      color={0,0,127}));
  connect(TAirSup.y, reqPlaRes.TAirSupSet)
    annotation(Line(points={{-128,60},{120,60},{120,43},{112,43}},
      color={0,0,127}));
  connect(busAirHan, pla.busAirHan[1])
    annotation(Line(points={{-40,40},{-40,-66}},
      color={255,204,51},
      thickness=0.5));
  connect(pla.bus, busPla)
    annotation(Line(points={{-80,-70},{-80,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(cst.y, mulInt.u1)
    annotation(Line(points={{88,80},{60,80},{60,46},{22,46}},
      color={255,127,0}));
  connect(mHeaWatLoo_flow.port_b, dpHeaWatRem[1].port_b)
    annotation(Line(points={{160,-90},{160,-100},{80,-100},{80,-90}},
      color={0,127,255}));
  connect(sigBAS.bus, busPla)
    annotation(Line(points={{-130,-20},{-80,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(mHeaWatLoo_flow.port_b, pipHeaWat.port_a)
    annotation(Line(points={{160,-90},{160,-100},{40,-100}},
      color={0,127,255}));
  connect(mulInt[1].y, busAirHan.reqPlaHeaWat)
    annotation(Line(points={{-2,40},{-40,40}},
      color={255,127,0}));
  connect(mulInt[2].y, busAirHan.reqResHeaWat)
    annotation(Line(points={{-2,40},{-40,40}},
      color={255,127,0}));
  connect(reqPlaRes.yHotWatPlaReq, mulInt[1].u2)
    annotation(Line(points={{88,32},{80,32},{80,34},{22,34}},
      color={255,127,0}));
  connect(reqPlaRes.yHotWatResReq, mulInt[2].u2)
    annotation(Line(points={{88,37},{80,37},{80,34},{22,34}},
      color={255,127,0}));
  connect(dpHeaWatRem.p_rel, busPla.dpHeaWatRem)
    annotation(Line(points={{71,-80},{60,-80},{60,-22},{-80,-22},{-80,-20}},
      color={0,0,127}));
  connect(pla.port_b, THeaWatSup.port_a)
    annotation(Line(points={{-39.8,-80},{-20,-80},{-20,-60},{-10,-60}},
      color={0,127,255}));
  connect(loa.port_b, mHeaWatLoo_flow.port_a)
    annotation(Line(points={{130,-60},{160,-60},{160,-70}},
      color={0,127,255}));
  connect(dpHeaWatRem[1].port_a, loa.port_a)
    annotation(Line(points={{80,-70},{80,-60},{110,-60}},
      color={0,127,255}));
  connect(loa.yVal_actual, reqPlaRes.uHeaCoiSet)
    annotation(Line(points={{132,-52},{140,-52},{140,32},{112,32}},
      color={0,0,127}));
  connect(ratLoa.y[1], loa.u)
    annotation(Line(points={{-128,20},{100,20},{100,-52},{108,-52}},
      color={0,0,127}));
  connect(THeaWatSup.port_b, vol.ports[1])
    annotation(Line(points={{10,-60},{29,-60}},
      color={0,127,255}));
  connect(vol.ports[2], loa.port_a)
    annotation(Line(points={{31,-60},{110,-60}},
      color={0,127,255}));
  connect(pipHeaWat.port_b, pla.port_a)
    annotation(Line(points={{20,-100},{-20,-100},{-20,-90},{-39.8,-90}},
      color={0,127,255}));
  connect(loa.u1, busPla.u1Sch)
    annotation(Line(points={{108,-56},{96,-56},{96,-20},{-80,-20}},
      color={255,0,255}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Boilers/HotWater/Validation/BoilerPlant.mos"
    "Simulate and plot"),
  experiment(Tolerance=1e-6,
    StopTime=86400.0),
  Documentation(
    info="<html>
<p>
  This model validates
  <a href=\"modelica://Buildings.Templates.Plants.Boilers.HotWater.BoilerPlant\">
    Buildings.Templates.Plants.Boilers.HotWater.BoilerPlant</a> by
  simulating a
  <i>24</i>-hour period during which the heating loads reach their peak value.
</p>
<p>
  Two equally sized condensing boilers are modeled. A unique aggregated load
  is modeled on the CHW loop using a heat exchanger component exposed to
  conditioned space air, and a two-way modulating valve. An importance
  multiplier of <i>10</i> is applied to the plant requests and reset requests
  generated from the valve position.
</p>
<p>
  Advanced equipment and control options can be modified via the parameter
  dialog of the plant component.
</p>
<p>Simulating this model shows how the plant responds to a varying load by</p>
<ul>
  <li>staging or unstaging the boilers,</li>
  <li>resetting the supply temperature based on the valve position,</li>
  <li>
    staging and controlling the primary pumps to meet the remote differential
    pressure setpoint.
  </li>
</ul>
<p>
  A Python script is provided with this model to test all supported system
  configurations, see
  <code>Buildings/Resources/Scripts/travis/templates/BoilerPlant.py</code>.
</p>
</html>"),
  Diagram(coordinateSystem(extent={{-180,-140},{180,140}})));
end BoilerPlant;
