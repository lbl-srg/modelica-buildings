within Buildings.ThermalZones.EnergyPlus.Examples;
model OneZoneRadiantFloor
  "Example model with one thermal zone with a radiant floor"
  extends Validation.ThermalZone.OneZone(m_flow_nominal=VRoo*1.2*0.3/3600);
  package MediumW = Buildings.Media.Water "Water medium";

  final parameter Modelica.SIunits.Area AFlo = zon.AFlo "Floor area";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 5000 "Nominal heat flow rate";
  parameter Modelica.SIunits.MassFlowRate mW_flow_nominal = Q_flow_nominal /4200/10
    "Design water mass flow rate";

  parameter HeatTransfer.Data.OpaqueConstructions.Generic layers(nLay=3,
      material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.08,
        k=1.13,
        c=1000,
        d=1400,
        nSta=5),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.05,
        k=0.04,
        c=1400,
        d=10),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.2,
        k=1.8,
        c=1100,
        d=2400)})
    "Material layers from surface a to b (8cm concrete, 5 cm insulation, 20 cm reinforced concrete)"
    annotation (Placement(transformation(extent={{30,-236},{50,-216}})));

   parameter HeatTransfer.Data.Solids.Generic soil(
    x=2,
    k=1.3,
    c=800,
    d=1500) "Soil properties"
    annotation (Placement(transformation(extent={{40,-298},{60,-278}})));

  Buildings.ThermalZones.EnergyPlus.ZoneSurface flo(surfaceName="Living:Floor")
    "Floor surface of living room"
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));
  Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab sla(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    layers=layers,
    iLayPip=1,
    pipe=Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    disPip=0.2,
    nCir=3,
    A=AFlo,
    m_flow_nominal=mW_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    show_T=true) "Slab with embedded pipes"
    annotation (Placement(transformation(extent={{0,-250},{20,-230}})));
  Fluid.Sources.Boundary_ph pre(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 300000) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{100,-250},{80,-230}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo "Surface heat flow rate"
    annotation (Placement(transformation(extent={{98,-184},{118,-164}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSur
    "Surface temperature"
    annotation (Placement(transformation(extent={{20,-190},{40,-170}})));
  Controls.OBC.CDL.Continuous.PID conHea(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    k=2,
    Ti(displayUnit="min") = 3600)
            "Controller for heating"
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
      pressure(
        V_flow=2*{0,mW_flow_nominal}/1000,
        dp = 2*{14000,0}),
      speed_nominal,
      constantSpeed,
      speeds),
    inputType=Buildings.Fluid.Types.InputType.Continuous) "Pump"
    annotation (Placement(transformation(extent={{-80,-250},{-60,-230}})));
  Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare final package Medium = MediumW,
    allowFlowReversal=false,
    m_flow_nominal=mW_flow_nominal,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q_flow_nominal)
    "Ideal heater"
    annotation (Placement(transformation(extent={{-40,-250},{-20,-230}})));
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
        origin={16.5,-289.5})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TSoi(T=293.15)
    "Boundary condition for construction" annotation (Placement(transformation(
          extent={{0,0},{20,20}}, origin={-32,-320})));
  Controls.OBC.CDL.Continuous.Hysteresis hys(
    uLow=0.1,
    uHigh=0.2)
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
equation
  connect(sla.port_b, pre.ports[1])
    annotation (Line(points={{20,-240},{80,-240}}, color={0,127,255}));
  connect(flo.Q_flow, preHeaFlo.Q_flow)
    annotation (Line(points={{82,-174},{98,-174}},color={0,0,127}));
  connect(preHeaFlo.port, sla.surf_a) annotation (Line(points={{118,-174},{124,-174},
          {124,-200},{14,-200},{14,-230}}, color={191,0,0}));
  connect(TSur.port, sla.surf_a)
    annotation (Line(points={{20,-180},{14,-180},{14,-230}}, color={191,0,0}));
  connect(zon.TAir, conHea.u_m) annotation (Line(points={{41,18},{48,18},{48,-104},
          {-88,-104},{-88,-152},{-190,-152},{-190,-142}},       color={0,0,127}));
  connect(TSetRooHea.y, conHea.u_s)
    annotation (Line(points={{-218,-130},{-202,-130}},
                                                     color={0,0,127}));
  connect(hea.port_b, sla.port_a)
    annotation (Line(points={{-20,-240},{0,-240}}, color={0,127,255}));
  connect(pum.port_b, hea.port_a)
    annotation (Line(points={{-60,-240},{-40,-240}}, color={0,127,255}));
  connect(pum.port_a, sla.port_b) annotation (Line(points={{-80,-240},{-90,-240},
          {-90,-260},{60,-260},{60,-240},{20,-240}}, color={0,127,255}));
  connect(TSur.T, flo.T)
    annotation (Line(points={{40,-180},{58,-180}}, color={0,0,127}));
  connect(TSoi.port, soi.port_a) annotation (Line(points={{-12,-310},{14,-310},{
          14,-302}}, color={191,0,0}));
  connect(soi.port_b, sla.surf_b)
    annotation (Line(points={{14,-282},{14,-250}}, color={191,0,0}));
  connect(conHea.y, hys.u)
    annotation (Line(points={{-178,-130},{-162,-130}}, color={0,0,127}));
  connect(swiBoi.u1, conHea.y) annotation (Line(points={{-122,-162},{-168,-162},
          {-168,-130},{-178,-130}},color={0,0,127}));
  connect(swiBoi.y, hea.u) annotation (Line(points={{-98,-170},{-52,-170},{-52,-234},
          {-42,-234}}, color={0,0,127}));
  connect(off.y, swiPum.u3) annotation (Line(points={{-178,-178},{-140,-178},{-140,
          -208},{-122,-208}}, color={0,0,127}));
  connect(off.y, swiBoi.u3) annotation (Line(points={{-178,-178},{-122,-178}},
                              color={0,0,127}));
  connect(on.y, swiPum.u1) annotation (Line(points={{-178,-210},{-134,-210},{-134,
          -192},{-122,-192}}, color={0,0,127}));
  connect(pum.y, swiPum.y) annotation (Line(points={{-70,-228},{-70,-200},{-98,-200}},
        color={0,0,127}));
  connect(hys.y, swiPum.u2) annotation (Line(points={{-138,-130},{-130,-130},{-130,
          -200},{-122,-200}}, color={255,0,255}));
  connect(hys.y, swiBoi.u2) annotation (Line(points={{-138,-130},{-130,-130},{-130,
          -170},{-122,-170}}, color={255,0,255}));
  annotation (
      __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/OneZoneRadiantFloor.mos" "Simulate and plot"),
  experiment(
      StopTime=31536000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
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
</html>", revisions="<html>
<ul>
<li>
March 16, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-260,-340},{160,40}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end OneZoneRadiantFloor;
