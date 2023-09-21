within Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse;
model RadiantHeatingCooling_TRoom
  "Example model with one thermal zone with a radiant floor where the cooling is controlled based on the room air temperature"
  extends Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.Unconditioned(building(
        idfName=Modelica.Utilities.Files.loadResource(
          "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus_9_6_0/Examples/SingleFamilyHouse_TwoSpeed_ZoneAirBalance/SingleFamilyHouse_TwoSpeed_ZoneAirBalance_aboveSoil.idf")));
  package MediumW=Buildings.Media.Water
    "Water medium";
  constant Modelica.Units.SI.Area AFlo=185.8 "Floor area";
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=7500
    "Nominal heat flow rate for heating";
  parameter Modelica.Units.SI.MassFlowRate mHea_flow_nominal=QHea_flow_nominal/
      4200/10 "Design water mass flow rate for heating";
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal=-5000
    "Nominal heat flow rate for cooling";
  parameter Modelica.Units.SI.MassFlowRate mCoo_flow_nominal=-QCoo_flow_nominal
      /4200/5 "Design water mass flow rate for heating";
  parameter HeatTransfer.Data.OpaqueConstructions.Generic layFloSoi(nLay=4,
      material={Buildings.HeatTransfer.Data.Solids.Concrete(x=0.08),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.20),
        Buildings.HeatTransfer.Data.Solids.Concrete(x=0.2),
        HeatTransfer.Data.Solids.Generic(
        x=2,
        k=1.3,
        c=800,
        d=1500)})
    "Material layers from surface a to b (8cm concrete, 20 cm insulation, 20 cm concrete, 200 cm soil, below which is the undisturbed soil assumed)"
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic layCei(
    nLay=4,
    material={
      Buildings.HeatTransfer.Data.Solids.Concrete(x=0.08),
      Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.10),
      Buildings.HeatTransfer.Data.Solids.Concrete(x=0.18),
      Buildings.HeatTransfer.Data.Solids.Concrete(x=0.02)})
    "Material layers from surface a to b (8cm concrete, 10 cm insulation, 18+2 cm concrete)"
    annotation (Placement(transformation(extent={{-18,110},{2,130}})));
  // Floor slab
  Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab slaFlo(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    layers=layFloSoi,
    iLayPip=1,
    pipe=Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    disPip=0.15,
    nCir=3,
    A=AFlo,
    m_flow_nominal=mHea_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    show_T=true) "Slab for floor with embedded pipes, connected to soil"
    annotation (Placement(transformation(extent={{0,-190},{20,-170}})));
  Fluid.Sources.Boundary_ph pre(
    redeclare package Medium=MediumW,
    p(displayUnit="Pa")=300000,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{70,-190},{50,-170}})));
  Controls.OBC.CDL.Reals.Sources.Constant TSetRooHea(
    k(final unit="K",
      displayUnit="degC")=293.15,
    y(final unit="K",
      displayUnit="degC"))
    "Room temperture set point for heating"
    annotation (Placement(transformation(extent={{-180,-154},{-160,-134}})));
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
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  Fluid.HeatExchangers.Heater_T hea(
    redeclare final package Medium=MediumW,
    allowFlowReversal=false,
    m_flow_nominal=mHea_flow_nominal,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Ideal heater"
    annotation (Placement(transformation(extent={{-40,-190},{-20,-170}})));
  // Ceiling slab
  Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab slaCei(
    redeclare package Medium=MediumW,
    allowFlowReversal=false,
    layers=layCei,
    iLayPip=3,
    pipe=Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Ceiling_Wall_or_Capillary,
    disPip=0.2,
    nCir=4,
    A=AFlo,
    m_flow_nominal=mCoo_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true)
    "Slab for ceiling with embedded pipes"
    annotation (Placement(transformation(extent={{2,80},{22,100}})));
  Fluid.Sources.Boundary_ph prePre(
    redeclare package Medium=MediumW,
    nPorts=1,
    p(displayUnit="Pa")=300000)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{74,80},{54,100}})));
  Fluid.Sources.MassFlowSource_T masFloSouCoo(
    redeclare package Medium=MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1)
    "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{-38,80},{-18,100}})));
  Controls.OBC.CDL.Reals.Sources.Constant TSetRooCoo(
    k(final unit="K",
      displayUnit="degC")=299.15,
    y(final unit="K",
      displayUnit="degC")) "Room temperture set point for cooling"
    annotation (Placement(transformation(extent={{-180,106},{-160,126}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    realTrue=mCoo_flow_nominal)
    "Cooling water mass flow rate"
    annotation (Placement(transformation(extent={{-80,88},{-60,108}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFlo(
    surfaceName="Attic:LivingFloor")
    "Floor of the attic above the living room"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=270,origin={102,90})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction livFlo(surfaceName="Living:Floor")
    "Floor of the living room" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={100,-180})));

  Controls.OBC.RadiantSystems.Heating.HighMassSupplyTemperature_TRoom conHea(
      TSupSet_max=318.15)
    "Controller for radiant heating system" annotation (Placement(
        transformation(rotation=0, extent={{-140,-160},{-120,-140}})));
  Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum
    conCoo(TSupSet_min=289.15) "Controller for radiant cooling"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
initial equation
  // The floor area can be obtained from EnergyPlus, but it is a structural parameter used to
  // size the system and therefore we hard-code it here.
  assert(
    abs(
      AFlo-zon.AFlo) < 0.1,
    "Floor area AFlo differs from EnergyPlus floor area.");

equation
  connect(masFloSouCoo.ports[1],slaCei.port_a)
    annotation (Line(points={{-18,90},{2,90}},  color={0,127,255}));
  connect(prePre.ports[1],slaCei.port_b)
    annotation (Line(points={{54,90},{22,90}},  color={0,127,255}));
  connect(booToRea.y,masFloSouCoo.m_flow_in)
    annotation (Line(points={{-58,98},{-40,98}},                         color={0,0,127}));
  connect(attFlo.heaPorFro,slaCei.surf_a)
    annotation (Line(points={{102,100},{102,110},{16,110},{16,100}},color={191,0,0}));
  connect(slaCei.surf_b,attFlo.heaPorBac)
    annotation (Line(points={{16,80},{16,70},{102,70},{102,80.2}},    color={191,0,0}));
  connect(TSetRooHea.y, conHea.TRooSet) annotation (Line(points={{-158,-144},{
          -142,-144}},                         color={0,0,127}));
  connect(pum.y, conHea.yPum) annotation (Line(points={{-70,-168},{-70,-156},{
          -118,-156}},
                  color={0,0,127}));
  connect(pum.port_b,hea.port_a)
    annotation (Line(points={{-60,-180},{-40,-180}},color={0,127,255}));
  connect(hea.port_b,slaFlo.port_a)
    annotation (Line(points={{-20,-180},{0,-180}},color={0,127,255}));
  connect(livFlo.heaPorFro, slaFlo.surf_a) annotation (Line(points={{100,-170},
          {100,-160},{14,-160},{14,-170}},color={191,0,0}));
  connect(slaFlo.surf_b, livFlo.heaPorBac) annotation (Line(points={{14,-190},{
          14,-200},{100,-200},{100,-189.8}},
                                          color={191,0,0}));
  connect(zon.TAir, conHea.TRoo) annotation (Line(points={{41,18},{48,18},{48,-100},
          {-148,-100},{-148,-150},{-142,-150}},   color={0,0,127}));
  connect(slaFlo.port_b,pum.port_a)
    annotation (Line(points={{20,-180},{40,-180},{40,-220},{-100,-220},{-100,
          -180},{-80,-180}},                                                                   color={0,127,255}));
  connect(slaFlo.port_b,pre.ports[1])
    annotation (Line(points={{20,-180},{50,-180}},color={0,127,255}));
  connect(conHea.TSupSet, hea.TSet) annotation (Line(points={{-118,-144},{-50,
          -144},{-50,-172},{-42,-172}},
                                  color={0,0,127}));
  connect(conCoo.on, booToRea.u) annotation (Line(points={{-118,108},{-90,108},
          {-90,98},{-82,98}}, color={255,0,255}));
  connect(conCoo.TRooSet, TSetRooCoo.y)
    annotation (Line(points={{-142,116},{-158,116}}, color={0,0,127}));
  connect(zon.TAir, conCoo.TRoo) annotation (Line(points={{41,18},{48,18},{48,40},
          {-150,40},{-150,106},{-142,106}},     color={0,0,127}));
  connect(conCoo.phiRoo, zon.phi) annotation (Line(points={{-142,102},{-146,102},
          {-146,44},{52,44},{52,10},{41,10}}, color={0,0,127}));
  connect(conCoo.TSupSet, masFloSouCoo.T_in) annotation (Line(points={{-118,116},
          {-50,116},{-50,94},{-40,94}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Examples/SingleFamilyHouse/RadiantHeatingCooling_TRoom.mos" "Simulate and plot"),
    experiment(
      StartTime=7776000,
      StopTime=9504000,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
Model that uses EnergyPlus for the simulation of a building with one thermal zone
that has a radiant ceiling, used for cooling, and a radiant floor, used for heating.
The EnergyPlus model has one conditioned zone that is above ground. This conditioned zone
has an unconditioned attic.
The model is constructed by extending
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.HeatPumpRadiantHeatingGroundHeatTransfer\">
Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.HeatPumpRadiantHeatingGroundHeatTransfer</a>
and adding the radiant ceiling. For simplicity, this model provide heating with an idealized heater.
</p>
<p>
The next section explains how the radiant ceiling is configured.
</p>
<h4>Coupling of radiant ceiling to EnergyPlus model</h4>
<p>
The radiant ceiling is modeled in the instance <code>slaCei</code> at the top of the schematic model view,
using the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab</a>.
This instance models the heat transfer from the surface of the attic floor to the ceiling of the living room.
In this example, the construction is defined by the instance <code>layCei</code>.
(See the <a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide</a>
for how to configure a radiant slab.)
In this example, the surfaces <code>slaCei.surf_a</code> (upward-facing) and
<code>slaCei.surf_a</code> (downward-facing)
are connected to the instance <code>attFlo</code>.
Because <code>attFlo</code> models the <em>floor</em> of the attic, rather than the ceiling
of the living room,
the heat port <code>slaCei.surf_a</code> is connected to <code>attFlo.heaPorFro</code>, which is the
front-facing surface, e.g., the floor.
Similarly,  <code>slaCei.surf_b</code> is connected to <code>attFlo.heaPorBac</code>, which is the
back-facing surface, e.g., the ceiling of the living room.
</p>
<p>
The mass flow rate of the slab is constant if the cooling is operating.
A P controller computes the control signal to track a set point for the room temperature.
The controller uses a hysteresis to switch the mass flow rate on or off.
The control signal is also used to set the set point for the water supply temperature to the slab.
This temperature is limited by the dew point of the zone air to avoid condensation.
</p>
<p>
See also the model
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.RadiantHeatingCooling_TSurface\">
Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.RadiantHeatingCooling_TSurface</a>
which is controlled to track a set point for the surface temperature.
</p>
<h4>Coupling of radiant floor to EnergyPlus model</h4>
<p>
The radiant floor is modeled in the instance <code>slaFlo</code> at the bottom of the schematic model view,
using the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab</a>.
This instance models the heat transfer from surface of the floor to the lower surface of the slab.
In this example, the construction is defined by the instance <code>layFloSoi</code>.
(See the <a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide</a>
for how to configure a radiant slab.)
In this example, the surfaces <code>slaFlo.surf_a</code> and
<code>slaFlo.surf_b</code>
are connected to the instance
<code>flo</code>.
In EnergyPlus, the surface <code>flo.heaPorBac</code> is connected
to the boundary condition of the soil because this building has no basement.
</p>
<p>
Note that the floor construction is modeled with <i>2</i> m of soil because the soil temperature
in EnergyPlus is assumed to be undisturbed.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 1, 2022, by Michael Wetter:<br/>
Increased thickness of insulation of radiant slab and changed pipe spacing.
</li>
<li>
March 30, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-220,-260},{160,200}})),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}})));
end RadiantHeatingCooling_TRoom;