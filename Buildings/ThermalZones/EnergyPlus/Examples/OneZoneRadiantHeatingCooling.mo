within Buildings.ThermalZones.EnergyPlus.Examples;
model OneZoneRadiantHeatingCooling
  "Example model with one thermal zone with a radiant floor"
  extends Validation.ThermalZone.OneZone(m_flow_nominal=VRoo*1.2*0.3/3600);
  package MediumW = Buildings.Media.Water "Water medium";

  final parameter Modelica.SIunits.Area AFlo = zon.AFlo "Floor area";
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal=5000
    "Nominal heat flow rate for heating";
  parameter Modelica.SIunits.MassFlowRate mHea_flow_nominal=QHea_flow_nominal/4200
      /10 "Design water mass flow rate for heating";

  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal=5000
    "Nominal heat flow rate for cooling";
  parameter Modelica.SIunits.MassFlowRate mCoo_flow_nominal=QCoo_flow_nominal/4200/5
    "Design water mass flow rate for heating";

  parameter HeatTransfer.Data.OpaqueConstructions.Generic layFlo(nLay=3,
      material={
        Buildings.HeatTransfer.Data.Solids.Concrete(x=0.08),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.05),
        Buildings.HeatTransfer.Data.Solids.Concrete(x=0.2)})
    "Material layers from surface a to b (8cm concrete, 5 cm insulation, 20 cm concrete)"
    annotation (Placement(transformation(extent={{-20,-240},{0,-220}})));

   parameter HeatTransfer.Data.Solids.Generic soil(
    x=2,
    k=1.3,
    c=800,
    d=1500) "Soil properties"
    annotation (Placement(transformation(extent={{40,-308},{60,-288}})));

  Buildings.ThermalZones.EnergyPlus.ZoneSurface livFlo(surfaceName="Living:Floor")
    "Surface of living room floor"
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));
  Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab slaFlo(
    redeclare package Medium = MediumW,
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
    show_T=true) "Slab for floor with embedded pipes, connected to soil"
    annotation (Placement(transformation(extent={{0,-270},{20,-250}})));
  Fluid.Sources.Boundary_ph pre(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 300000) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{72,-270},{52,-250}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaLivFlo "Surface heat flow rate"
    annotation (Placement(transformation(extent={{98,-184},{118,-164}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSurLivFlo
    "Surface temperature for floor of living room"
    annotation (Placement(transformation(extent={{20,-190},{40,-170}})));
  Controls.OBC.CDL.Continuous.PID conHea(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    k=2,
    Ti(displayUnit="min") = 3600) "Controller for heating"
    annotation (Placement(transformation(extent={{-200,-140},{-180,-120}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHea(k(
      final unit="K",
      displayUnit="degC") = 293.15, y(final unit="K", displayUnit="degC"))
    "Room temperture set point for heating"
    annotation (Placement(transformation(extent={{-240,-140},{-220,-120}})));
  Fluid.Movers.SpeedControlled_y pum(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per(
      pressure(V_flow=2*{0,mHea_flow_nominal}/1000, dp=2*{14000,0}),
      speed_nominal,
      constantSpeed,
      speeds),
    inputType=Buildings.Fluid.Types.InputType.Continuous) "Pump"
    annotation (Placement(transformation(extent={{-80,-270},{-60,-250}})));
  Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare final package Medium = MediumW,
    allowFlowReversal=false,
    m_flow_nominal=mHea_flow_nominal,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=QHea_flow_nominal) "Ideal heater"
    annotation (Placement(transformation(extent={{-40,-270},{-20,-250}})));
  HeatTransfer.Conduction.SingleLayer soi(
    A=AFlo,
    material=soil,
    steadyStateInitial=true,
    stateAtSurface_a=false,
    stateAtSurface_b=false,
    T_a_start=283.15,
    T_b_start=283.75) "2m deep soil (per definition on p.4 of ASHRAE 140-2007)"
    annotation (Placement(transformation(
        extent={{12.5,-12.5},{-7.5,7.5}},
        rotation=-90,
        origin={16.5,-299.5})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TSoi(T=293.15)
    "Boundary condition for construction" annotation (Placement(transformation(
          extent={{0,0},{20,20}}, origin={-32,-330})));
  Controls.OBC.CDL.Continuous.Hysteresis hysHea(uLow=0.1, uHigh=0.2)
    "Hysteresis to switch system on and off"
    annotation (Placement(transformation(extent={{-160,-140},{-140,-120}})));
  Controls.OBC.CDL.Logical.Switch swiBoi "Switch for boiler"
    annotation (Placement(transformation(extent={{-120,-180},{-100,-160}})));
  Controls.OBC.CDL.Logical.Switch swiPum "Switch for pump"
    annotation (Placement(transformation(extent={{-120,-210},{-100,-190}})));
  Controls.OBC.CDL.Continuous.Sources.Constant on(k=1)
    "On signal"
    annotation (Placement(transformation(extent={{-200,-220},{-180,-200}})));
  Controls.OBC.CDL.Continuous.Sources.Constant off(k=0) "Off signal"
    annotation (Placement(transformation(extent={{-200,-188},{-180,-168}})));
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

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSurAttFlo
    "Surface temperature of floor of attic"
    annotation (Placement(transformation(extent={{40,160},{60,180}})));
  ZoneSurface attFlo(surfaceName="Attic:LivingFloor") "Surface of attic"
    annotation (Placement(transformation(extent={{80,160},{100,180}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaAttFlo
    "Surface heat flow rate for floor of attic"
    annotation (Placement(transformation(extent={{118,166},{138,186}})));
  Fluid.Sources.Boundary_ph pre1(
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
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSurLivCei
    "Surface temperature of ceiling in living room"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  ZoneSurface livCei(surfaceName="Living:Ceiling")
    "Surface of living room ceiling"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaLivCei
    "Surface heat flow rate for ceiling of living room"
    annotation (Placement(transformation(extent={{118,86},{138,106}})));
  Controls.OBC.CDL.Continuous.Max TSupCoo "Cooling water supply temperature"
    annotation (Placement(transformation(extent={{-150,74},{-130,94}})));
  Controls.OBC.CDL.Psychrometrics.WetBulb_TDryBulPhi wetBul
    "Wet bulb temperature, used to avoid condensation"
    annotation (Placement(transformation(extent={{-190,50},{-170,70}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysCoo(uLow=0.1, uHigh=0.2)
    "Hysteresis to switch system on and off"
    annotation (Placement(transformation(extent={{-190,130},{-170,150}})));
  Controls.OBC.CDL.Continuous.PID conCoo(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    k=2,
    Ti(displayUnit="min") = 3600,
    reverseActing=false)
                        "Controller for cooling"
    annotation (Placement(transformation(extent={{-270,130},{-250,150}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCoo(k(
      final unit="K",
      displayUnit="degC") = 299.15, y(final unit="K", displayUnit="degC"))
    "Room temperture set point for heating"
    annotation (Placement(transformation(extent={{-302,130},{-282,150}})));
  Controls.OBC.CDL.Continuous.Gain dTCoo(k=-8)
    "Cooling supply water temperature difference relative to air temperature"
    annotation (Placement(transformation(extent={{-230,100},{-210,120}})));
  Controls.OBC.CDL.Continuous.Add TSupNoDP
    "Set point for supply water without any dew point control"
    annotation (Placement(transformation(extent={{-190,80},{-170,100}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea(realTrue=
        mCoo_flow_nominal) "Cooling water mass flow rate"
    annotation (Placement(transformation(extent={{-150,130},{-130,150}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic layCei(nLay=4,
      material={Buildings.HeatTransfer.Data.Solids.Concrete(x=0.08),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.05),
        Buildings.HeatTransfer.Data.Solids.Concrete(x=0.18),
        Buildings.HeatTransfer.Data.Solids.Concrete(x=0.02)})
    "Material layers from surface a to b (8cm concrete, 5 cm insulation, 18+2 cm concrete)"
    annotation (Placement(transformation(extent={{-60,146},{-40,166}})));
equation
  connect(slaFlo.port_b, pre.ports[1])
    annotation (Line(points={{20,-260},{52,-260}}, color={0,127,255}));
  connect(livFlo.Q_flow, preHeaLivFlo.Q_flow)
    annotation (Line(points={{82,-174},{98,-174}}, color={0,0,127}));
  connect(preHeaLivFlo.port, slaFlo.surf_a) annotation (Line(points={{118,-174},
          {124,-174},{124,-200},{14,-200},{14,-250}}, color={191,0,0}));
  connect(TSurLivFlo.port, slaFlo.surf_a)
    annotation (Line(points={{20,-180},{14,-180},{14,-250}}, color={191,0,0}));
  connect(zon.TAir, conHea.u_m) annotation (Line(points={{41,18},{48,18},{48,
          -152},{-190,-152},{-190,-142}},                       color={0,0,127}));
  connect(TSetRooHea.y, conHea.u_s)
    annotation (Line(points={{-218,-130},{-202,-130}},
                                                     color={0,0,127}));
  connect(hea.port_b, slaFlo.port_a)
    annotation (Line(points={{-20,-260},{0,-260}}, color={0,127,255}));
  connect(pum.port_b, hea.port_a)
    annotation (Line(points={{-60,-260},{-40,-260}}, color={0,127,255}));
  connect(pum.port_a, slaFlo.port_b) annotation (Line(points={{-80,-260},{-90,
          -260},{-90,-280},{40,-280},{40,-260},{20,-260}},
                                                     color={0,127,255}));
  connect(TSurLivFlo.T, livFlo.T)
    annotation (Line(points={{40,-180},{58,-180}}, color={0,0,127}));
  connect(TSoi.port, soi.port_a) annotation (Line(points={{-12,-320},{14,-320},
          {14,-312}},color={191,0,0}));
  connect(soi.port_b, slaFlo.surf_b)
    annotation (Line(points={{14,-292},{14,-270}}, color={191,0,0}));
  connect(conHea.y, hysHea.u)
    annotation (Line(points={{-178,-130},{-162,-130}}, color={0,0,127}));
  connect(swiBoi.u1, conHea.y) annotation (Line(points={{-122,-162},{-168,-162},
          {-168,-130},{-178,-130}},color={0,0,127}));
  connect(swiBoi.y, hea.u) annotation (Line(points={{-98,-170},{-52,-170},{-52,
          -254},{-42,-254}},
                       color={0,0,127}));
  connect(off.y, swiPum.u3) annotation (Line(points={{-178,-178},{-140,-178},{-140,
          -208},{-122,-208}}, color={0,0,127}));
  connect(off.y, swiBoi.u3) annotation (Line(points={{-178,-178},{-122,-178}},
                              color={0,0,127}));
  connect(on.y, swiPum.u1) annotation (Line(points={{-178,-210},{-134,-210},{-134,
          -192},{-122,-192}}, color={0,0,127}));
  connect(pum.y, swiPum.y) annotation (Line(points={{-70,-248},{-70,-200},{-98,
          -200}},
        color={0,0,127}));
  connect(hysHea.y, swiPum.u2) annotation (Line(points={{-138,-130},{-130,-130},
          {-130,-200},{-122,-200}}, color={255,0,255}));
  connect(hysHea.y, swiBoi.u2) annotation (Line(points={{-138,-130},{-130,-130},
          {-130,-170},{-122,-170}}, color={255,0,255}));
  connect(masFloSouCoo.ports[1], slaCei.port_a)
    annotation (Line(points={{-68,130},{-40,130}}, color={0,127,255}));
  connect(pre1.ports[1], slaCei.port_b)
    annotation (Line(points={{2,130},{-20,130}},  color={0,127,255}));
  connect(slaCei.surf_a, TSurAttFlo.port)
    annotation (Line(points={{-26,140},{-26,170},{40,170}},  color={191,0,0}));
  connect(TSurAttFlo.T, attFlo.T)
    annotation (Line(points={{60,170},{78,170}},color={0,0,127}));
  connect(attFlo.Q_flow, preHeaAttFlo.Q_flow)
    annotation (Line(points={{102,176},{118,176}},
                                                 color={0,0,127}));
  connect(preHeaAttFlo.port, slaCei.surf_a) annotation (Line(points={{138,176},{
          148,176},{148,152},{-26,152},{-26,140}},
                                              color={191,0,0}));
  connect(slaCei.surf_b, TSurLivCei.port)
    annotation (Line(points={{-26,120},{-26,90},{40,90}},  color={191,0,0}));
  connect(TSurLivCei.T, livCei.T)
    annotation (Line(points={{60,90},{78,90}},color={0,0,127}));
  connect(livCei.Q_flow, preHeaLivCei.Q_flow)
    annotation (Line(points={{102,96},{118,96}},
                                               color={0,0,127}));
  connect(preHeaLivCei.port, slaCei.surf_b) annotation (Line(points={{138,96},{150,
          96},{150,110},{-26,110},{-26,120}},color={191,0,0}));
  connect(conCoo.y, dTCoo.u) annotation (Line(points={{-248,140},{-240,140},{
          -240,110},{-232,110}},
                            color={0,0,127}));
  connect(dTCoo.y, TSupNoDP.u1) annotation (Line(points={{-208,110},{-200,110},
          {-200,96},{-192,96}},color={0,0,127}));
  connect(TSupNoDP.u2, zon.TAir) annotation (Line(points={{-192,84},{-260,84},{
          -260,40},{48,40},{48,18},{41,18}},
                                        color={0,0,127}));
  connect(TSupNoDP.y, TSupCoo.u1) annotation (Line(points={{-168,90},{-152,90}},
                                 color={0,0,127}));
  connect(wetBul.TWetBul, TSupCoo.u2) annotation (Line(points={{-168,60},{-160,
          60},{-160,78},{-152,78}},
                                color={0,0,127}));
  connect(TSupCoo.y, masFloSouCoo.T_in) annotation (Line(points={{-128,84},{
          -120,84},{-120,134},{-90,134}},
                                      color={0,0,127}));
  connect(hysCoo.y, booToRea.u) annotation (Line(points={{-168,140},{-152,140}},
                                 color={255,0,255}));
  connect(booToRea.y, masFloSouCoo.m_flow_in)
    annotation (Line(points={{-128,140},{-110,140},{-110,138},{-90,138}},
                                                    color={0,0,127}));
  connect(wetBul.TDryBul, zon.TAir) annotation (Line(points={{-192,66},{-260,66},
          {-260,40},{48,40},{48,18},{41,18}}, color={0,0,127}));
  connect(zon.TAir, conCoo.u_m) annotation (Line(points={{41,18},{48,18},{48,40},
          {-260,40},{-260,128}}, color={0,0,127}));
  connect(zon.phi, wetBul.phi) annotation (Line(points={{41,10},{52,10},{52,46},
          {-210,46},{-210,54},{-192,54}}, color={0,0,127}));
  connect(TSetRooCoo.y, conCoo.u_s)
    annotation (Line(points={{-280,140},{-272,140}}, color={0,0,127}));
  connect(conCoo.y, hysCoo.u)
    annotation (Line(points={{-248,140},{-192,140}}, color={0,0,127}));
  annotation (
      __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/OneZoneRadiantHeatingCooling.mos" "Simulate and plot"),
  experiment(
      StartTime=7776000,
      StopTime=9504000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
Documentation(info="<html>
<p>
Model that uses EnergyPlus for the simulation of the building which has one thermal zone,
and sets the floor surface temperature to the value computed by a radiant slab model.
</p>
<p>
The radiant slab is part of a simple hydronic loop to which heat is added
in order to maintain a room temperature that is near or above the heating
setpoint temperature.
A P controller sets the heating input into the water loop, and switches are used to switch
the heater and the pump on and off.
</p>
<h4>Coupling of radiant ceiling to EnergyPlus model</h4>
<p>
The radiant ceiling is modelled in the instance <code>slaCei</code> at the top of the schematic model view,
using the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab</a>.
This instance models the heat transfer from surface of the attic floor to the ceiling of the living room.
In this example, the construction is defined by the instance <code>layCei</code>.
(See the <a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide</a>
for how to configure a radiant slab.)
In this example, the surface <code>slaCei.surf_a</code> is connected to the instance
<code>attFlo</code>, which is the floor of the attic zone in EnergyPlus.
This connection is made by measuring the surface temperture, sending this as an input to
<code>attFlo</code>, and setting the heat flow rate at the surface from the instance <code>attFlo</code>
to the surface <code>slaCei.surf_a</code>.
Similarly, the surface <code>slaCei.surf_a</code> is connected to <code>livCei</code>, which
is the living room's ceiling.
</p>
<p>
The mass flow rate of the slab is constant if the cooling is operating.
A P controller computes the control signal, and using a hysteresis, the mass flow rate is switched on or off.
The control signal is also used to set the set point for the water supply temperature to the slab.
This temperature is limited by the dew point of the zone air to avoid any condensation.
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
end OneZoneRadiantHeatingCooling;
