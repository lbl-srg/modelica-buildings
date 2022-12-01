within Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse;
model RadiantHeatingWithGroundHeatTransfer
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
    annotation (Placement(transformation(extent={{40,-220},{60,-200}})));
  parameter HeatTransfer.Data.Solids.Generic soil(
    x=2,
    k=1.3,
    c=800,
    d=1500)
    "Soil properties"
    annotation (Placement(transformation(extent={{40,-288},{60,-268}})));
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
    annotation (Placement(transformation(extent={{0,-250},{20,-230}})));
  Fluid.Sources.Boundary_ph pre(
    redeclare package Medium=MediumW,
    p(displayUnit="Pa")=300000,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{80,-250},{60,-230}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaLivFlo
    "Surface heat flow rate"
    annotation (Placement(transformation(extent={{98,-134},{118,-114}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSurLivFlo
    "Surface temperature for floor of living room"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHea(
    k(final unit="K",
      displayUnit="degC")=293.15,
    y(final unit="K",
      displayUnit="degC")) "Room temperture set point for heating"
    annotation (Placement(transformation(extent={{-260,-150},{-240,-130}})));
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
    annotation (Placement(transformation(extent={{-120,-250},{-100,-230}})));
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
            -279.5})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TSoi(
    T=293.15)
    "Boundary condition for construction"
    annotation (Placement(transformation(extent={{0,0},{-20,20}},
                                                                origin={60,-320})));

  Controls.OBC.RadiantSystems.Heating.HighMassSupplyTemperature_TRoom conHea(
    TSupSet_max=303.15,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    k=2)
    "Controller for radiant heating system"
    annotation (Placement(transformation(extent={{-214,-166},{-194,-146}})));
  Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    m_flow_nominal=mHea_flow_nominal,
    tau=0,
    transferHeat=true) "Leaving water temperature sensor"
    annotation (Placement(transformation(extent={{-160,-250},{-140,-230}})));
  Controls.OBC.CDL.Continuous.PIDWithReset conSup(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.1,
    Ti(displayUnit="min") = 7200,
    final yMax=1,
    final yMin=0.2,
    final reverseActing=true,
    y_reset=0.2) "Controller for heat pump"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  Controls.OBC.CDL.Continuous.Switch swi
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));
  Controls.OBC.CDL.Continuous.Sources.Constant off(
    final k = 0)
    "Output 0 to switch heater off"
    annotation (Placement(transformation(extent={{-260,-188},{-240,-168}})));
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
    enable_temperature_protection=true,
    TEvaMin=268.15,
    datHeaPum=
        Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating.ClimateMaster_TMW036_12kW_4_90COP_R410A())
      "Heat pump"
    annotation (Placement(transformation(extent={{-50,-256},{-30,-236}})));
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
    annotation (Placement(transformation(extent={{-120,-310},{-100,-290}})));
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
    annotation (Placement(transformation(extent={{-168,-316},{-136,-284}})));
  Fluid.Sources.Boundary_ph pre1(
    redeclare package Medium = MediumG,
    p(displayUnit="Pa") = 300000,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-212,-310},{-192,-290}})));
  Modelica.Blocks.Math.Add TOpe(
    k1=0.5,
    k2=0.5,
    u1(final unit="K", displayUnit="degC"),
    u2(final unit="K", displayUnit="degC"),
    y(final unit="K", displayUnit="degC"))
      "Operative temperature"
    annotation (Placement(transformation(extent={{60,2},{80,22}})));
  Modelica.Blocks.Sources.RealExpression QCon(y=heaPum.QCon_flow)
    "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{140,-280},{160,-260}})));
  Modelica.Blocks.Sources.RealExpression PEle1(y=heaPum.P + pum.P + pumBor.P)
    "Electricity use"
    annotation (Placement(transformation(extent={{140,-318},{160,-298}})));
  Modelica.Blocks.Continuous.Integrator EHea(
    k(final unit="1/m2")=1/AFlo,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    u(final unit="W"),
    y(final unit="J/m2",
      displayUnit="kWh/m2"))
    "Produced heat per unit area of floor"
    annotation (Placement(transformation(extent={{180,-280},{200,-260}})));
  Modelica.Blocks.Continuous.Integrator EEle(
    k(final unit="1/m2")=1/AFlo,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=1E-10,
    u(final unit="W"),
    y(final unit="J/m2",
      displayUnit="kWh/m2"))
    "Electricity use per floor area"
    annotation (Placement(transformation(extent={{180,-318},{200,-298}})));
  Controls.OBC.CDL.Continuous.Divide COP "Coefficient of performance"
    annotation (Placement(transformation(extent={{220,-300},{240,-280}})));
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
    annotation (Line(points={{118,-124},{124,-124},{124,-150},{14,-150},{14,
          -230}},                                                                  color={191,0,0}));
  connect(TSurLivFlo.port,slaFlo.surf_a)
    annotation (Line(points={{20,-130},{14,-130},{14,-230}},color={191,0,0}));
  connect(TSurLivFlo.T,livFlo.T)
    annotation (Line(points={{41,-130},{58,-130}},color={0,0,127}));
  connect(TSoi.port,soi.port_a)
    annotation (Line(points={{40,-310},{14,-310},{14,-292}}, color={191,0,0}));
  connect(soi.port_b,slaFlo.surf_b)
    annotation (Line(points={{14,-272},{14,-250}},color={191,0,0}));
  connect(TSetRooHea.y, conHea.TRooSet) annotation (Line(points={{-238,-140},{-230,
          -140},{-230,-150},{-216,-150}},      color={0,0,127}));
  connect(conHea.yPum, pum.y) annotation (Line(points={{-192,-162},{-180,-162},{
          -180,-218},{-110,-218},{-110,-228}},
                      color={0,0,127}));
  connect(conHea.TSupSet, conSup.u_s) annotation (Line(points={{-192,-150},{
          -162,-150}},                    color={0,0,127}));
  connect(senTem.T, conSup.u_m) annotation (Line(points={{-150,-229},{-150,-162}},
                             color={0,0,127}));
  connect(conHea.on, swi.u2) annotation (Line(points={{-192,-158},{-176,-158},{-176,
          -170},{-102,-170}},color={255,0,255}));
  connect(conSup.y, swi.u1) annotation (Line(points={{-138,-150},{-120,-150},{
          -120,-162},{-102,-162}},
                             color={0,0,127}));
  connect(off.y, swi.u3)
    annotation (Line(points={{-238,-178},{-102,-178}},color={0,0,127}));
  connect(pum.port_b, heaPum.port_a1)
    annotation (Line(points={{-100,-240},{-50,-240}}, color={0,127,255}));
  connect(slaFlo.port_a, heaPum.port_b1)
    annotation (Line(points={{0,-240},{-30,-240}}, color={0,127,255}));
  connect(swi.y, heaPum.y) annotation (Line(points={{-78,-170},{-70,-170},{-70,-243},
          {-52,-243}},                       color={0,0,127}));
  connect(borHol.port_b, pumBor.port_a)
    annotation (Line(points={{-136,-300},{-120,-300}}, color={0,127,255}));
  connect(pumBor.port_b, heaPum.port_a2) annotation (Line(points={{-100,-300},{-20,
          -300},{-20,-252},{-30,-252}}, color={0,127,255}));
  connect(heaPum.port_b2, borHol.port_a) annotation (Line(points={{-50,-252},{-80,
          -252},{-80,-280},{-180,-280},{-180,-300},{-168,-300}}, color={0,127,255}));
  connect(pre1.ports[1], borHol.port_a)
    annotation (Line(points={{-192,-300},{-168,-300}}, color={0,127,255}));
  connect(pumBor.y, conHea.yPum) annotation (Line(points={{-110,-288},{-110,-270},
          {-180,-270},{-180,-162},{-192,-162}},                         color={0,
          0,127}));
  connect(senTem.port_b, pum.port_a)
    annotation (Line(points={{-140,-240},{-120,-240}}, color={0,127,255}));
  connect(senTem.port_a, slaFlo.port_b) annotation (Line(points={{-160,-240},{-168,
          -240},{-168,-260},{30,-260},{30,-240},{20,-240}}, color={0,127,255}));
  connect(slaFlo.port_b, pre.ports[1])
    annotation (Line(points={{20,-240},{60,-240}}, color={0,127,255}));
  connect(conHea.on, conSup.trigger) annotation (Line(points={{-192,-158},{-176,
          -158},{-176,-170},{-156,-170},{-156,-162}}, color={255,0,255}));
  connect(zon.TAir, TOpe.u1)
    annotation (Line(points={{41,18},{58,18}}, color={0,0,127}));
  connect(zon.TRad, TOpe.u2)
    annotation (Line(points={{41,14},{48,14},{48,6},{58,6}}, color={0,0,127}));
  connect(TOpe.y, conHea.TRoo) annotation (Line(points={{81,12},{100,12},{100,40},
          {-280,40},{-280,-156},{-216,-156}}, color={0,0,127}));
  connect(EHea.u, QCon.y)
    annotation (Line(points={{178,-270},{161,-270}}, color={0,0,127}));
  connect(EEle.u, PEle1.y)
    annotation (Line(points={{178,-308},{161,-308}}, color={0,0,127}));
  connect(EEle.y, COP.u2) annotation (Line(points={{201,-308},{208,-308},{208,-296},
          {218,-296}}, color={0,0,127}));
  connect(EHea.y, COP.u1) annotation (Line(points={{201,-270},{210,-270},{210,-284},
          {218,-284}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Examples/SingleFamilyHouse/RadiantHeatingWithGroundHeatTransfer.mos" "Simulate and plot"),
    experiment(
      StopTime=1728000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
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
is calculated based on the room temperature control error, and
this set point is used to regulate the heat pump speed to track the
water temperature that leaves the radiant slab.
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
    Diagram(coordinateSystem(extent={{-320,-340},{260,60}})),
    Icon(coordinateSystem(extent={{-320,-340},{260,60}})));
end RadiantHeatingWithGroundHeatTransfer;
