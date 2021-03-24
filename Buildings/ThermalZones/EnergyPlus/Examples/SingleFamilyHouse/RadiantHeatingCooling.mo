within Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse;
model RadiantHeatingCooling
  "Example model with one thermal zone with a radiant floor"
  extends Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.RadiantHeatingWithGroundHeatTransfer;

  package MediumW = Buildings.Media.Water "Water medium";

  constant Modelica.SIunits.Area AFlo = 185.8 "Floor area";
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal=5000
    "Nominal heat flow rate for heating";
  parameter Modelica.SIunits.MassFlowRate mHea_flow_nominal=QHea_flow_nominal/4200
      /10 "Design water mass flow rate for heating";

  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal=-5000
    "Nominal heat flow rate for cooling";
  parameter Modelica.SIunits.MassFlowRate mCoo_flow_nominal=-QCoo_flow_nominal/4200/5
    "Design water mass flow rate for heating";

  parameter HeatTransfer.Data.OpaqueConstructions.Generic layCei(nLay=4,
      material={Buildings.HeatTransfer.Data.Solids.Concrete(x=0.08),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.05),
        Buildings.HeatTransfer.Data.Solids.Concrete(x=0.18),
        Buildings.HeatTransfer.Data.Solids.Concrete(x=0.02)})
    "Material layers from surface a to b (8cm concrete, 5 cm insulation, 18+2 cm concrete)"
    annotation (Placement(transformation(extent={{-60,146},{-40,166}})));

  Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab slaCei(
    redeclare package Medium = MediumW,
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
    show_T=true) "Slab for ceiling with embedded pipes"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));

  Fluid.Sources.Boundary_ph prePre(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 300000) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{22,120},{2,140}})));
  Fluid.Sources.MassFlowSource_T masFloSouCoo(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{-88,120},{-68,140}})));
  Controls.OBC.CDL.Continuous.Max TSupCoo "Cooling water supply temperature"
    annotation (Placement(transformation(extent={{-150,74},{-130,94}})));
  Controls.OBC.CDL.Psychrometrics.DewPoint_TDryBulPhi dewPoi
    "Dew point temperature, used to avoid condensation"
    annotation (Placement(transformation(extent={{-190,50},{-170,70}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysCoo(uLow=0.1, uHigh=0.2)
    "Hysteresis to switch system on and off"
    annotation (Placement(transformation(extent={{-190,130},{-170,150}})));
  Controls.OBC.CDL.Continuous.PID conCoo(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    k=2,
    Ti(displayUnit="min") = 3600,
    reverseActing=false) "Controller for cooling"
    annotation (Placement(transformation(extent={{-270,130},{-250,150}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCoo(k(
      final unit="K",
      displayUnit="degC") = 299.15, y(final unit="K", displayUnit="degC"))
    "Room temperture set point for heating"
    annotation (Placement(transformation(extent={{-300,130},{-280,150}})));
  Controls.OBC.CDL.Continuous.Product dTCoo
    "Cooling supply water temperature reset"
    annotation (Placement(transformation(extent={{-230,100},{-210,120}})));
  Controls.OBC.CDL.Continuous.Add TSupNoDP
    "Set point for supply water without any dew point control"
    annotation (Placement(transformation(extent={{-190,80},{-170,100}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    realTrue=mCoo_flow_nominal) "Cooling water mass flow rate"
    annotation (Placement(transformation(extent={{-150,130},{-130,150}})));

  Controls.OBC.CDL.Continuous.Sources.Constant TSupMin(k(
      final unit="K",
      displayUnit="degC") = 289.15, y(final unit="K", displayUnit="degC"))
    "Minimum cooling supply water temperature"
    annotation (Placement(transformation(extent={{-300,60},{-280,80}})));
  Controls.OBC.CDL.Continuous.Sources.Constant dTCooMax(k=-8)
    "Cooling maximum dT"
    annotation (Placement(transformation(extent={{-300,94},{-280,114}})));
  Controls.OBC.CDL.Continuous.Add TSupMax(k1=-1)
    "Maximum supply water temperature"
    annotation (Placement(transformation(extent={{-230,70},{-210,90}})));
  OpaqueConstruction attFlo(surfaceName="Attic:LivingFloor")
    "Floor of the attic above the living room" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,130})));

equation
  connect(masFloSouCoo.ports[1], slaCei.port_a)
    annotation (Line(points={{-68,130},{-40,130}}, color={0,127,255}));
  connect(prePre.ports[1], slaCei.port_b)
    annotation (Line(points={{2,130},{-20,130}}, color={0,127,255}));
  connect(TSupNoDP.y, TSupCoo.u1) annotation (Line(points={{-168,90},{-152,90}},
                                 color={0,0,127}));
  connect(TSupCoo.y, masFloSouCoo.T_in) annotation (Line(points={{-128,84},{-120,
          84},{-120,134},{-90,134}},  color={0,0,127}));
  connect(hysCoo.y, booToRea.u) annotation (Line(points={{-168,140},{-152,140}},
                                 color={255,0,255}));
  connect(booToRea.y, masFloSouCoo.m_flow_in)
    annotation (Line(points={{-128,140},{-110,140},{-110,138},{-90,138}},
                                                    color={0,0,127}));
  connect(dewPoi.TDryBul, zon.TAir) annotation (Line(points={{-192,66},{-260,66},
          {-260,40},{48,40},{48,18},{41,18}}, color={0,0,127}));
  connect(zon.TAir, conCoo.u_m) annotation (Line(points={{41,18},{48,18},{48,40},
          {-260,40},{-260,128}}, color={0,0,127}));
  connect(zon.phi,dewPoi. phi) annotation (Line(points={{41,10},{52,10},{52,46},
          {-210,46},{-210,54},{-192,54}}, color={0,0,127}));
  connect(TSetRooCoo.y, conCoo.u_s)
    annotation (Line(points={{-278,140},{-272,140}}, color={0,0,127}));
  connect(conCoo.y, hysCoo.u)
    annotation (Line(points={{-248,140},{-192,140}}, color={0,0,127}));
  connect(dTCoo.u2, dTCooMax.y)
    annotation (Line(points={{-232,104},{-278,104}}, color={0,0,127}));
  connect(TSupMax.u1, dTCooMax.y) annotation (Line(points={{-232,86},{-256,86},
          {-256,104},{-278,104}}, color={0,0,127}));
  connect(TSupMax.u2, TSupMin.y) annotation (Line(points={{-232,74},{-256,74},{
          -256,70},{-278,70}}, color={0,0,127}));
  connect(TSupMax.y, TSupNoDP.u2) annotation (Line(points={{-208,80},{-200,80},
          {-200,84},{-192,84}}, color={0,0,127}));
  connect(dTCoo.y, TSupNoDP.u1) annotation (Line(points={{-208,110},{-200,110},
          {-200,96},{-192,96}}, color={0,0,127}));
  connect(dTCoo.u1, conCoo.y) annotation (Line(points={{-232,116},{-240,116},{
          -240,140},{-248,140}}, color={0,0,127}));
  connect(TSupCoo.u2, dewPoi.TDewPoi) annotation (Line(points={{-152,78},{-162,78},
          {-162,60},{-168,60}}, color={0,0,127}));
  connect(attFlo.heaPorFro, slaCei.surf_a) annotation (Line(points={{50,140},{
          50,148},{-26,148},{-26,140}}, color={191,0,0}));
  connect(slaCei.surf_b,attFlo. heaPorBac) annotation (Line(points={{-26,120},{
          -26,110},{50,110},{50,120.2}}, color={191,0,0}));
  annotation (
      __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/SingleFamilyHouse/RadiantHeatingCooling.mos" "Simulate and plot"),
  experiment(
      StartTime=7776000,
      StopTime=9504000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
Documentation(info="<html>
<p>
Model that uses EnergyPlus for the simulation of a building with one thermal zone
that has a radiant ceiling, used for cooling, and a radiant floor, used for heating.
The EnergyPlus model has one conditioned zone that is above ground. This conditioned zone
has an unconditioned attic.
The model is constructed by extending
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.RadiantHeatingWithGroundHeatTransfer\">
Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.RadiantHeatingWithGroundHeatTransfer</a>
and adding the radiant ceiling.
</p>
<p>
The next section explains how the radiant ceiling is configured.
</p>
<h4>Coupling of radiant ceiling to EnergyPlus model</h4>
<p>
The radiant ceiling is modelled in the instance <code>slaCei</code> at the top of the schematic model view,
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
Because <code>attFlo</code> models the <emph>floor</emph> of the attic, rather than the ceiling
of the living room,
the heat port <code>slaCei.surf_a</code> is connected to <code>attFlo.heaPorFro</code>, which is the
front-facing surface, e.g., the floor.
Similarly,  <code>slaCei.surf_b</code> is connected to <code>attFlo.heaPorBac</code>, which is the
back-facing surface, e.g., the ceiling of the living room.
</p>
<p>
The mass flow rate of the slab is constant if the cooling is operating.
A P controller computes the control signal, and using a hysteresis, the mass flow rate is switched on or off.
The control signal is also used to set the set point for the water supply temperature to the slab.
This temperature is limited by the dew point of the zone air to avoid condensation.
</p>
<h4>Coupling of radiant floor to EnergyPlus model</h4>
<p>
The radiant floor is modelled in the instance <code>slaFlo</code> at the bottom of the schematic model view,
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
</html>", revisions="<html>
<ul>
<li>
March 16, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-320,-340},{160,200}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end RadiantHeatingCooling;
