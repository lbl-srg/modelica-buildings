within Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse;
model HeatPumpRadiantHeatingGroundHeatTransfer
  "Example model with one thermal zone with a radiant floor and ground heat transfer modeled in Modelica"
  extends
    Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.Unconditioned;
  package MediumW=Buildings.Media.Water
    "Water medium";
  package MediumG=Buildings.Media.Antifreeze.EthyleneGlycolWater(property_T=293.15, X_a=0.40)
    "Water glycol";
  constant Modelica.Units.SI.Area AFlo=185.8 "Floor area";
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=12000
    "Nominal heat flow rate for heating";
  parameter Modelica.Units.SI.MassFlowRate mHea_flow_nominal=QHea_flow_nominal/
      4200/5 "Design water mass flow rate for heating";
  parameter Modelica.Units.SI.MassFlowRate mBor_flow_nominal=mHea_flow_nominal*(1-1/4)*4200/3500
   "Design water mass flow rate for heating";
  parameter HeatTransfer.Data.OpaqueConstructions.Generic layFlo(
    nLay=3,
    material={
      Buildings.HeatTransfer.Data.Solids.Concrete(x=0.08),
      Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.20),
      Buildings.HeatTransfer.Data.Solids.Concrete(x=0.2)})
    "Material layers from surface a to b (8cm concrete, 20 cm insulation, 20 cm concrete)"
    annotation (Placement(transformation(extent={{40,-280},{60,-260}})));
  parameter HeatTransfer.Data.Solids.Generic soil(
    x=2,
    k=1.3,
    c=800,
    d=1500)
    "Soil properties"
    annotation (Placement(transformation(extent={{40,-348},{60,-328}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ZoneSurface livFlo(
    surfaceName="Living:Floor")
    "Surface of living room floor"
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));
  Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab slaFlo(
    redeclare package Medium=MediumW,
    allowFlowReversal=false,
    layers=layFlo,
    iLayPip=1,
    pipe=Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    disPip=0.15,
    nCir=3,
    A=AFlo,
    m_flow_nominal=mHea_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    show_T=true)
    "Slab for floor with embedded pipes, connected to soil"
    annotation (Placement(transformation(extent={{0,-310},{20,-290}})));
  Fluid.Sources.Boundary_ph pre(
    redeclare package Medium=MediumW,
    p(displayUnit="Pa")=300000,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{80,-310},{60,-290}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaLivFlo
    "Surface heat flow rate"
    annotation (Placement(transformation(extent={{98,-134},{118,-114}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSurLivFlo
    "Surface temperature for floor of living room"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));
  Controls.OBC.CDL.Reals.Sources.Constant TSetRooHea(k(
      final unit="K",
      displayUnit="degC") = 293.15, y(final unit="K", displayUnit="degC"))
    "Room temperture set point for heating"
    annotation (Placement(transformation(extent={{-320,-150},{-300,-130}})));
  Fluid.Movers.SpeedControlled_y pum(
    redeclare package Medium=MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per(
      pressure(
        V_flow=2*{0,mHea_flow_nominal}/1000,
        dp=2*{14000,0}),
      speed_nominal,
      constantSpeed,
      speeds),
    inputType=Buildings.Fluid.Types.InputType.Continuous)
    "Pump"
    annotation (Placement(transformation(extent={{-120,-310},{-100,-290}})));
  HeatTransfer.Conduction.SingleLayer soi(
    A=AFlo,
    material=soil,
    steadyStateInitial=true,
    stateAtSurface_a=false,
    stateAtSurface_b=false,
    T_a_start=283.15,
    T_b_start=283.75)
    "2m deep soil (per definition on p.4 of ASHRAE 140-2007)"
    annotation (Placement(transformation(extent={{12.5,-12.5},{-7.5,7.5}},rotation=-90,origin={16.5,
            -339.5})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TSoi(
    T=293.15)
    "Boundary condition for construction"
    annotation (Placement(transformation(extent={{0,0},{-20,20}},
                                                                origin={60,-380})));

  Controls.OBC.RadiantSystems.Heating.HighMassSupplyTemperature_TRoom conHea(
    TSupSet_max=328.15,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    k=2,
    Ti=7200,
    Td=600)
    "Controller for radiant heating system"
    annotation (Placement(transformation(extent={{-280,-156},{-260,-136}})));
  Controls.OBC.CDL.Reals.PIDWithReset conSup(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=4,
    Ti(displayUnit="min") = 60,
    r=10,
    final yMax=1,
    final yMin=0.2,
    final reverseActing=true,
    y_reset=0.2) "Controller for heat pump"
    annotation (Placement(transformation(extent={{-160,-150},{-140,-130}})));
  Controls.OBC.CDL.Reals.Switch swiHeaPum "Switch for heat pump signal"
    annotation (Placement(transformation(extent={{-120,-158},{-100,-138}})));
  Controls.OBC.CDL.Reals.Sources.Constant off(
    final k = 0)
    "Output 0 to switch heater off"
    annotation (Placement(transformation(extent={{-320,-188},{-300,-168}})));
  Fluid.HeatPumps.ScrollWaterToWater heaPum(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumG,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    m1_flow_nominal=mHea_flow_nominal,
    m2_flow_nominal=mBor_flow_nominal,
    show_T=true,
    dp1_nominal=10000,
    dp2_nominal=10000,
    scaling_factor=1.3*QHea_flow_nominal/12000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    enable_temperature_protection=true,
    TEvaMin=268.15,
    datHeaPum=
        Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating.ClimateMaster_TMW036_12kW_4_90COP_R410A())
      "Heat pump"
    annotation (Placement(transformation(extent={{-70,-316},{-50,-296}})));
  Fluid.Movers.SpeedControlled_y pumBor(
    redeclare package Medium = MediumG,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per(
      pressure(V_flow=2*{0,mBor_flow_nominal}/1000,
      dp=2*{60000+10000,0}),
      speed_nominal,
      constantSpeed,
      speeds),
    inputType=Buildings.Fluid.Types.InputType.Continuous) "Pump"
    annotation (Placement(transformation(extent={{-120,-370},{-100,-350}})));
 Fluid.Geothermal.Boreholes.UTube borHol(
    redeclare package Medium = MediumG,
    hBor=200,
    dp_nominal=60000,
    dT_dz=0.0015,
    samplePeriod=604800,
    m_flow_nominal=mBor_flow_nominal,
    redeclare parameter HeatTransfer.Data.BoreholeFillings.Bentonite matFil,
    redeclare parameter HeatTransfer.Data.Soil.Sandstone matSoi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Borehole heat exchanger"
    annotation (Placement(transformation(extent={{-168,-376},{-136,-344}})));
  Fluid.Sources.Boundary_ph pre1(
    redeclare package Medium = MediumG,
    p(displayUnit="Pa") = 300000,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-212,-370},{-192,-350}})));
  Modelica.Blocks.Math.Add TOpe(
    k1=0.5,
    k2=0.5,
    u1(final unit="K", displayUnit="degC"),
    u2(final unit="K", displayUnit="degC"),
    y(final unit="K", displayUnit="degC"))
      "Operative temperature"
    annotation (Placement(transformation(extent={{100,2},{120,22}})));
  Modelica.Blocks.Sources.RealExpression QCon(y=heaPum.QCon_flow)
    "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{140,-340},{160,-320}})));
  Modelica.Blocks.Sources.RealExpression PEle1(y=heaPum.P + pum.P + pumBor.P)
    "Electricity use"
    annotation (Placement(transformation(extent={{140,-378},{160,-358}})));
  Modelica.Blocks.Continuous.Integrator EHea(
    k(final unit="1/m2")=1/AFlo,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    u(final unit="W"),
    y(final unit="J/m2",
      displayUnit="kW.h/m2"))
    "Produced heat per unit area of floor"
    annotation (Placement(transformation(extent={{180,-340},{200,-320}})));
  Modelica.Blocks.Continuous.Integrator EEle(
    k(final unit="1/m2")=1/AFlo,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=1E-10,
    u(final unit="W"),
    y(final unit="J/m2",
      displayUnit="kW.h/m2"))
    "Electricity use per floor area"
    annotation (Placement(transformation(extent={{180,-378},{200,-358}})));
  Controls.OBC.CDL.Reals.Divide COP "Coefficient of performance"
    annotation (Placement(transformation(extent={{220,-360},{240,-340}})));
  Controls.OBC.CDL.Logical.Sources.Pulse ava(
    width=22/24,
    period=24*3600,
    shift=7*3600)
    "Availability schedule to block heat pump operation in early morning (assuming grid is at capacity)"
    annotation (Placement(transformation(extent={{-320,-220},{-300,-200}})));
  Controls.OBC.CDL.Reals.Switch swiPum "Switch for circulation pumps"
    annotation (Placement(transformation(extent={{-240,-220},{-220,-200}})));
  Controls.OBC.CDL.Logical.And onHeaPum "On/off signal for heat pump"
    annotation (Placement(transformation(extent={{-200,-190},{-180,-170}})));
  Fluid.Sensors.TemperatureTwoPort senTemSup(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    m_flow_nominal=mHea_flow_nominal,
    tau=0,
    transferHeat=true) "Water supply temperature"
    annotation (Placement(transformation(extent={{-34,-310},{-14,-290}})));
  Modelica.Blocks.Continuous.FirstOrder firOrdTRad(
    T(displayUnit="min") = 600,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    y_start(
      unit="K",
      displayUnit="degC") = 293.15,
    u(
     final unit="K",
     displayUnit="degC"),
    y(final unit="K",
      displayUnit="degC"))
    "First order filter to avoid step change in radiative temperature after EnergyPlus sampling"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
initial equation
  // The floor area can be obtained from EnergyPlus, but it is a structural parameter used to
  // size the system and therefore we hard-code it here.
  assert(
    abs(
      AFlo-zon.AFlo) < 0.1,
    "Floor area AFlo differs from EnergyPlus floor area.");

equation
  connect(livFlo.Q_flow,preHeaLivFlo.Q_flow)
    annotation (Line(points={{82,-124},{98,-124}},color={0,0,127}));
  connect(preHeaLivFlo.port,slaFlo.surf_a)
    annotation (Line(points={{118,-124},{128,-124},{128,-150},{14,-150},{14,-290}},color={191,0,0}));
  connect(TSurLivFlo.port,slaFlo.surf_a)
    annotation (Line(points={{20,-130},{14,-130},{14,-290}},color={191,0,0}));
  connect(TSurLivFlo.T,livFlo.T)
    annotation (Line(points={{41,-130},{58,-130}},color={0,0,127}));
  connect(TSoi.port,soi.port_a)
    annotation (Line(points={{40,-370},{14,-370},{14,-352}}, color={191,0,0}));
  connect(soi.port_b,slaFlo.surf_b)
    annotation (Line(points={{14,-332},{14,-310}},color={191,0,0}));
  connect(conHea.TSupSet, conSup.u_s) annotation (Line(points={{-258,-140},{-162,
          -140}},                         color={0,0,127}));
  connect(conSup.y, swiHeaPum.u1)
    annotation (Line(points={{-138,-140},{-122,-140}}, color={0,0,127}));
  connect(off.y, swiHeaPum.u3) annotation (Line(points={{-298,-178},{-250,-178},
          {-250,-156},{-122,-156}}, color={0,0,127}));
  connect(pum.port_b, heaPum.port_a1)
    annotation (Line(points={{-100,-300},{-70,-300}}, color={0,127,255}));
  connect(swiHeaPum.y, heaPum.y) annotation (Line(points={{-98,-148},{-80,-148},
          {-80,-303},{-72,-303}}, color={0,0,127}));
  connect(borHol.port_b, pumBor.port_a)
    annotation (Line(points={{-136,-360},{-120,-360}}, color={0,127,255}));
  connect(pumBor.port_b, heaPum.port_a2) annotation (Line(points={{-100,-360},{-40,
          -360},{-40,-312},{-50,-312}}, color={0,127,255}));
  connect(heaPum.port_b2, borHol.port_a) annotation (Line(points={{-70,-312},{-80,
          -312},{-80,-340},{-180,-340},{-180,-360},{-168,-360}}, color={0,127,255}));
  connect(pre1.ports[1], borHol.port_a)
    annotation (Line(points={{-192,-360},{-168,-360}}, color={0,127,255}));
  connect(slaFlo.port_b, pre.ports[1])
    annotation (Line(points={{20,-300},{60,-300}}, color={0,127,255}));
  connect(zon.TAir, TOpe.u1)
    annotation (Line(points={{41,18},{98,18}}, color={0,0,127}));
  connect(EHea.u, QCon.y)
    annotation (Line(points={{178,-330},{161,-330}}, color={0,0,127}));
  connect(EEle.u, PEle1.y)
    annotation (Line(points={{178,-368},{161,-368}}, color={0,0,127}));
  connect(EEle.y, COP.u2) annotation (Line(points={{201,-368},{208,-368},{208,-356},
          {218,-356}}, color={0,0,127}));
  connect(EHea.y, COP.u1) annotation (Line(points={{201,-330},{210,-330},{210,-344},
          {218,-344}}, color={0,0,127}));
  connect(conHea.yPum, swiPum.u1) annotation (Line(points={{-258,-152},{-246,-152},
          {-246,-202},{-242,-202}}, color={0,0,127}));
  connect(ava.y, swiPum.u2) annotation (Line(points={{-298,-210},{-242,-210}},
                              color={255,0,255}));
  connect(swiPum.y, pum.y) annotation (Line(points={{-218,-210},{-110,-210},{-110,
          -288}}, color={0,0,127}));
  connect(swiPum.y, pumBor.y) annotation (Line(points={{-218,-210},{-190,-210},{
          -190,-330},{-110,-330},{-110,-348}}, color={0,0,127}));
  connect(conHea.on, onHeaPum.u1) annotation (Line(points={{-258,-148},{-212,-148},
          {-212,-180},{-202,-180}}, color={255,0,255}));
  connect(onHeaPum.y, swiHeaPum.u2) annotation (Line(points={{-178,-180},{-132,-180},
          {-132,-148},{-122,-148}}, color={255,0,255}));
  connect(ava.y, onHeaPum.u2) annotation (Line(points={{-298,-210},{-260,-210},{
          -260,-188},{-202,-188}}, color={255,0,255}));
  connect(swiPum.u3, off.y) annotation (Line(points={{-242,-218},{-250,-218},{-250,
          -178},{-298,-178}}, color={0,0,127}));
  connect(onHeaPum.y, conSup.trigger) annotation (Line(points={{-178,-180},{-156,
          -180},{-156,-152}}, color={255,0,255}));
  connect(slaFlo.port_a, senTemSup.port_b)
    annotation (Line(points={{0,-300},{-14,-300}}, color={0,127,255}));
  connect(senTemSup.port_a, heaPum.port_b1)
    annotation (Line(points={{-34,-300},{-50,-300}}, color={0,127,255}));
  connect(senTemSup.T, conSup.u_m) annotation (Line(points={{-24,-289},{-24,-192},
          {-150,-192},{-150,-152}}, color={0,0,127}));
  connect(TSetRooHea.y, conHea.TRooSet)
    annotation (Line(points={{-298,-140},{-282,-140}}, color={0,0,127}));
  connect(TOpe.u2, firOrdTRad.y)
    annotation (Line(points={{98,6},{90,6},{90,0},{81,0}}, color={0,0,127}));
  connect(zon.TRad, firOrdTRad.u)
    annotation (Line(points={{41,14},{50,14},{50,0},{58,0}}, color={0,0,127}));
  connect(TOpe.y, conHea.TRoo) annotation (Line(points={{121,12},{128,12},{128,40},
          {-330,40},{-330,-160},{-292,-160},{-292,-146},{-282,-146}}, color={0,0,
          127}));
  connect(slaFlo.port_b, pum.port_a) annotation (Line(points={{20,-300},{30,-300},
          {30,-320},{-130,-320},{-130,-300},{-120,-300}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Examples/SingleFamilyHouse/HeatPumpRadiantHeatingGroundHeatTransfer.mos" "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
Model that uses EnergyPlus for the simulation of a building with one thermal zone
that has a radiant floor, used for heating.
The EnergyPlus model has one conditioned zone that is above ground. This conditioned zone
has an unconditioned attic.
Heating is provided with a geothermal heat pump and a radiant floor.
The heat pump is controlled to track
a set point of the water temperature that leaves the radiant slab.
Hence, the control is cascading:
First, the set point temperature for the water that leaves the radiant slab
is calculated based on the operative room temperature control error, and
this set point is used to regulate the heat pump speed to track the
water temperature that leaves the radiant slab.
The heat pump system is switched off from 5:00 to 7:00, which illustrates
how to block operation for example because electricity use needs to be reduced
during these hours. However, the model does not preheat the slab prior to this period.
</p>
<p>
To the right of the thermal zone is a block that computes the operative room temperature.
The operative temperature calculation uses as input the room air temperature and the radiative temperature of the zone.
The radiative temperature is fed into a first order filter before it is used to compute the operative temperature.
This is because the EnergyPlus coupling samples the radiative temperature.
Without this filter, the operative temperature used in the controller would have a discrete
jump at every EnergyPlus time step, and this jump would be propagated through the controller,
which would yield jumps in the output of the controller.
</p>
<p>
This model has no cooling and hence will overheat in summer. See
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.RadiantHeatingCooling_TRoom\">
Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.RadiantHeatingCooling_TRoom</a>
for a model that also has cooling.
</p>
<p>
The next section explains how the radiant floor is configured.
</p>
<h4>Coupling of radiant floor to EnergyPlus model</h4>
<p>
The radiant floor is modeled in the instance <code>slaFlo</code> at the bottom of the schematic model view,
using the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab</a>.
This instance models the heat transfer from surface of the floor to the lower surface of the slab.
In this example, the construction is defined by the instance <code>layFlo</code>.
(See the <a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide</a>
for how to configure a radiant slab.)
In this example, the surface <code>slaFlo.surf_a</code> is connected to the instance
<code>flo</code>.
This connection is made by measuring the surface temperture, sending this as an input to
<code>livFlo</code>, and setting the heat flow rate at the surface from the instance <code>livFlo</code>
to the surface <code>slaFlo.surf_a</code>.
</p>
<p>
The underside of the slab is connected to the heat conduction model <code>soi</code>
which computes the heat transfer to the soil because this building has no basement.
</p>
</html>", revisions = "<html>
<ul>
<li>
March 11, 2024, by Michael Wetter:<br/>
Corrected wrong <code>displayUnit</code> string.
</li>
<li>
December 1, 2022, by Michael Wetter:<br/>
Replaced idealized heating with geothermal heat pump,
increased thickness of insulation of radiant slab, and
changed pipe spacing.
</li>
<li>
March 16, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-340,-400},{260,60}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end HeatPumpRadiantHeatingGroundHeatTransfer;
