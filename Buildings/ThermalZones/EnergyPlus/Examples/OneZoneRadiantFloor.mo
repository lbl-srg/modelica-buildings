within Buildings.ThermalZones.EnergyPlus.Examples;
model OneZoneRadiantFloor
  "Example model with one thermal zone with a radiant floor"
  extends Validation.ThermalZone.OneZone(m_flow_nominal=VRoo*1.2*0.3/3600);
  package MediumW = Buildings.Media.Water "Water medium";

  final parameter Modelica.SIunits.Area AFlo = zon.AFlo "Floor area";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 3000 "Nominal heat flow rate";
  parameter Modelica.SIunits.MassFlowRate mW_flow_nominal = Q_flow_nominal /4200/10
    "Design water mass flow rate";
  Buildings.ThermalZones.EnergyPlus.ZoneSurface flo(surfaceName="Living:Floor")
    "Floor surface of living room"
    annotation (Placement(transformation(extent={{58,-130},{78,-110}})));
  Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab sla3(
    redeclare package Medium = MediumW,
    layers=layers,
    iLayPip=1,
    pipe=Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    disPip=0.4,
    nCir=3,
    A=AFlo,
    m_flow_nominal=mW_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    show_T=true)  "Slabe with embedded pipes"
    annotation (Placement(transformation(extent={{0,-180},{20,-160}})));
  Fluid.Sources.Boundary_ph pre(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 300000) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{100,-180},{80,-160}})));
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
    annotation (Placement(transformation(extent={{118,-182},{138,-162}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo "Surface heat flow rate"
    annotation (Placement(transformation(extent={{98,-124},{118,-104}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSur
    "Surface temperature"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Controls.OBC.CDL.Continuous.PID conHea(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.25,
    Ti(displayUnit="min") = 1800)
            "Controller for heating"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHea(k(
      final unit="K",
      displayUnit="degC") = 293.15, y(final unit="K", displayUnit="degC"))
    "Room temperture set point for heating"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
  Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=mW_flow_nominal,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    nominalValuesDefineDefaultPressureCurve=true) "Pump"
    annotation (Placement(transformation(extent={{-82,-180},{-62,-160}})));
  Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare final package Medium = MediumW,
    m_flow_nominal=mW_flow_nominal,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q_flow_nominal)
    "Ideal heater"
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));
equation
  connect(sla3.port_b, pre.ports[1])
    annotation (Line(points={{20,-170},{80,-170}}, color={0,127,255}));
  connect(flo.Q_flow, preHeaFlo.Q_flow)
    annotation (Line(points={{80,-114},{98,-114}},color={0,0,127}));
  connect(preHeaFlo.port, sla3.surf_a) annotation (Line(points={{118,-114},{126,
          -114},{126,-140},{14,-140},{14,-160}},
                                           color={191,0,0}));
  connect(TSur.port, sla3.surf_a)
    annotation (Line(points={{20,-120},{14,-120},{14,-160}}, color={191,0,0}));
  connect(zon.TAir, conHea.u_m) annotation (Line(points={{41,18},{60,18},{60,
          -100},{-132,-100},{-132,-152},{-70,-152},{-70,-142}}, color={0,0,127}));
  connect(TSetRooHea.y, conHea.u_s)
    annotation (Line(points={{-98,-130},{-82,-130}}, color={0,0,127}));
  connect(hea.port_b, sla3.port_a)
    annotation (Line(points={{-20,-170},{0,-170}}, color={0,127,255}));
  connect(pum.port_b, hea.port_a)
    annotation (Line(points={{-62,-170},{-40,-170}}, color={0,127,255}));
  connect(pum.port_a, sla3.port_b) annotation (Line(points={{-82,-170},{-92,-170},
          {-92,-190},{30,-190},{30,-170},{20,-170}}, color={0,127,255}));
  connect(conHea.y, hea.u) annotation (Line(points={{-58,-130},{-52,-130},{-52,-164},
          {-42,-164}}, color={0,0,127}));
  connect(TSur.T, flo.T)
    annotation (Line(points={{40,-120},{56,-120}}, color={0,0,127}));
  annotation (
      __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/OneZoneRadiantFloor.mos" "Simulate and plot"),
  experiment(
      StopTime=432000,
      Tolerance=1e-06),
Documentation(info="<html>
<p>
Model that uses EnergyPlus and sets the floor surface temperature to the value
computed by a radiant slab model.
</p>
<p>
The radiant slab is part of a simple hydronic loop to which heat is added
in order to maintain a room temperature that is near or above the heating
setpoint temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
March 16, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-200},{160,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end OneZoneRadiantFloor;
