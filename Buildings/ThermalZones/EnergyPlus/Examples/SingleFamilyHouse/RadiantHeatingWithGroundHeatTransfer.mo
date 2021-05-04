within Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse;
model RadiantHeatingWithGroundHeatTransfer
  "Example model with one thermal zone with a radiant floor and ground heat transfer modeled in Modelica"
  extends Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.Unconditioned;
  package MediumW=Buildings.Media.Water
    "Water medium";
  constant Modelica.SIunits.Area AFlo=185.8
    "Floor area";
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal=12000
    "Nominal heat flow rate for heating";
  parameter Modelica.SIunits.MassFlowRate mHea_flow_nominal=QHea_flow_nominal/4200/10
    "Design water mass flow rate for heating";
  parameter HeatTransfer.Data.OpaqueConstructions.Generic layFlo(
    nLay=3,
    material={
      Buildings.HeatTransfer.Data.Solids.Concrete(x=0.08),
      Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.10),
      Buildings.HeatTransfer.Data.Solids.Concrete(x=0.2)})
    "Material layers from surface a to b (8cm concrete, 10 cm insulation, 20 cm concrete)"
    annotation (Placement(transformation(extent={{-20,-240},{0,-220}})));
  parameter HeatTransfer.Data.Solids.Generic soil(
    x=2,
    k=1.3,
    c=800,
    d=1500)
    "Soil properties"
    annotation (Placement(transformation(extent={{40,-308},{60,-288}})));
  Buildings.ThermalZones.EnergyPlus.ZoneSurface livFlo(
    surfaceName="Living:Floor")
    "Surface of living room floor"
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));
  Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab slaFlo(
    redeclare package Medium=MediumW,
    allowFlowReversal=false,
    layers=layFlo,
    iLayPip=1,
    pipe=Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    disPip=0.2,
    nCir=3,
    A=AFlo,
    m_flow_nominal=mHea_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    show_T=true)
    "Slab for floor with embedded pipes, connected to soil"
    annotation (Placement(transformation(extent={{0,-270},{20,-250}})));
  Fluid.Sources.Boundary_ph pre(
    redeclare package Medium=MediumW,
    nPorts=1,
    p(displayUnit="Pa")=300000)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{72,-270},{52,-250}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaLivFlo
    "Surface heat flow rate"
    annotation (Placement(transformation(extent={{98,-184},{118,-164}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSurLivFlo
    "Surface temperature for floor of living room"
    annotation (Placement(transformation(extent={{20,-190},{40,-170}})));
  Controls.OBC.CDL.Continuous.PID conHea(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    k=2,
    Ti(
      displayUnit="min")=3600)
    "Controller for heating"
    annotation (Placement(transformation(extent={{-200,-140},{-180,-120}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHea(
    k(final unit="K",
      displayUnit="degC")=293.15,
    y(final unit="K",
      displayUnit="degC"))
    "Room temperture set point for heating"
    annotation (Placement(transformation(extent={{-240,-140},{-220,-120}})));
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
    annotation (Placement(transformation(extent={{-80,-270},{-60,-250}})));
  Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare final package Medium=MediumW,
    allowFlowReversal=false,
    m_flow_nominal=mHea_flow_nominal,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=QHea_flow_nominal)
    "Ideal heater"
    annotation (Placement(transformation(extent={{-40,-270},{-20,-250}})));
  HeatTransfer.Conduction.SingleLayer soi(
    A=AFlo,
    material=soil,
    steadyStateInitial=true,
    stateAtSurface_a=false,
    stateAtSurface_b=false,
    T_a_start=283.15,
    T_b_start=283.75)
    "2m deep soil (per definition on p.4 of ASHRAE 140-2007)"
    annotation (Placement(transformation(extent={{12.5,-12.5},{-7.5,7.5}},rotation=-90,origin={16.5,-299.5})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TSoi(
    T=293.15)
    "Boundary condition for construction"
    annotation (Placement(transformation(extent={{0,0},{20,20}},origin={-32,-330})));
  Controls.OBC.CDL.Continuous.Hysteresis hysHea(
    uLow=0.1,
    uHigh=0.2)
    "Hysteresis to switch system on and off"
    annotation (Placement(transformation(extent={{-160,-140},{-140,-120}})));
  Controls.OBC.CDL.Logical.Switch swiBoi
    "Switch for boiler"
    annotation (Placement(transformation(extent={{-120,-180},{-100,-160}})));
  Controls.OBC.CDL.Logical.Switch swiPum
    "Switch for pump"
    annotation (Placement(transformation(extent={{-120,-210},{-100,-190}})));
  Controls.OBC.CDL.Continuous.Sources.Constant on(
    k=1)
    "On signal"
    annotation (Placement(transformation(extent={{-200,-220},{-180,-200}})));
  Controls.OBC.CDL.Continuous.Sources.Constant off(
    k=0)
    "Off signal"
    annotation (Placement(transformation(extent={{-200,-188},{-180,-168}})));

initial equation
  // The floor area can be obtained from EnergyPlus, but it is a structural parameter used to
  // size the system and therefore we hard-code it here.
  assert(
    abs(
      AFlo-zon.AFlo) < 0.1,
    "Floor area AFlo differs from EnergyPlus floor area.");

equation
  connect(slaFlo.port_b,pre.ports[1])
    annotation (Line(points={{20,-260},{52,-260}},color={0,127,255}));
  connect(livFlo.Q_flow,preHeaLivFlo.Q_flow)
    annotation (Line(points={{82,-174},{98,-174}},color={0,0,127}));
  connect(preHeaLivFlo.port,slaFlo.surf_a)
    annotation (Line(points={{118,-174},{124,-174},{124,-200},{14,-200},{14,-250}},color={191,0,0}));
  connect(TSurLivFlo.port,slaFlo.surf_a)
    annotation (Line(points={{20,-180},{14,-180},{14,-250}},color={191,0,0}));
  connect(zon.TAir,conHea.u_m)
    annotation (Line(points={{41,18},{48,18},{48,40},{-260,40},{-260,-150},{-190,-150},{-190,-142}},color={0,0,127}));
  connect(TSetRooHea.y,conHea.u_s)
    annotation (Line(points={{-218,-130},{-202,-130}},color={0,0,127}));
  connect(hea.port_b,slaFlo.port_a)
    annotation (Line(points={{-20,-260},{0,-260}},color={0,127,255}));
  connect(pum.port_b,hea.port_a)
    annotation (Line(points={{-60,-260},{-40,-260}},color={0,127,255}));
  connect(pum.port_a,slaFlo.port_b)
    annotation (Line(points={{-80,-260},{-90,-260},{-90,-280},{40,-280},{40,-260},{20,-260}},color={0,127,255}));
  connect(TSurLivFlo.T,livFlo.T)
    annotation (Line(points={{40,-180},{58,-180}},color={0,0,127}));
  connect(TSoi.port,soi.port_a)
    annotation (Line(points={{-12,-320},{14,-320},{14,-312}},color={191,0,0}));
  connect(soi.port_b,slaFlo.surf_b)
    annotation (Line(points={{14,-292},{14,-270}},color={191,0,0}));
  connect(conHea.y,hysHea.u)
    annotation (Line(points={{-178,-130},{-162,-130}},color={0,0,127}));
  connect(swiBoi.u1,conHea.y)
    annotation (Line(points={{-122,-162},{-168,-162},{-168,-130},{-178,-130}},color={0,0,127}));
  connect(swiBoi.y,hea.u)
    annotation (Line(points={{-98,-170},{-52,-170},{-52,-254},{-42,-254}},color={0,0,127}));
  connect(off.y,swiPum.u3)
    annotation (Line(points={{-178,-178},{-140,-178},{-140,-208},{-122,-208}},color={0,0,127}));
  connect(off.y,swiBoi.u3)
    annotation (Line(points={{-178,-178},{-122,-178}},color={0,0,127}));
  connect(on.y,swiPum.u1)
    annotation (Line(points={{-178,-210},{-160,-210},{-160,-192},{-122,-192}},color={0,0,127}));
  connect(pum.y,swiPum.y)
    annotation (Line(points={{-70,-248},{-70,-200},{-98,-200}},color={0,0,127}));
  connect(hysHea.y,swiPum.u2)
    annotation (Line(points={{-138,-130},{-130,-130},{-130,-200},{-122,-200}},color={255,0,255}));
  connect(hysHea.y,swiBoi.u2)
    annotation (Line(points={{-138,-130},{-130,-130},{-130,-170},{-122,-170}},color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/SingleFamilyHouse/RadiantHeatingWithGroundHeatTransfer.mos" "Simulate and plot"),
    experiment(
      StopTime=432000,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
Model that uses EnergyPlus for the simulation of a building with one thermal zone
that has a radiant floor, used for heating.
The EnergyPlus model has one conditioned zone that is above ground. This conditioned zone
has an unconditioned attic.
This model has no cooling and hence will overheat in summer. See
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.RadiantHeatingCooling\">
Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.RadiantHeatingCooling</a>
for a similar model that also has cooling.
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
</html>",
      revisions="<html>
<ul>
<li>
March 16, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-320,-340},{160,60}})),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}})));
end RadiantHeatingWithGroundHeatTransfer;
