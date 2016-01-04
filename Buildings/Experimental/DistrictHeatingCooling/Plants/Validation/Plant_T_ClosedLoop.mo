within Buildings.Experimental.DistrictHeatingCooling.Plants.Validation;
model Plant_T_ClosedLoop
  "Validation model for plant with ideal temperature control"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water "Fluid in the pipes";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 10E3
    "Nominal heat flow rate, positive for heating, negative for cooling";

  parameter Modelica.SIunits.Temperature TSetHeaLea = 273.15+8
    "Set point for leaving fluid temperature warm supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Temperature TSetCooLea = 273.15+14
    "Set point for leaving fluid temperature cold supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=30000
    "Pressure difference at nominal flow rate"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.TemperatureDifference dT_nominal(
    min=0.5,
    displayUnit="K") = TSetCooLea-TSetHeaLea
    "Temperature difference between warm and cold pipe"
    annotation(Dialog(group="Design parameter"));

  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/4200/dT_nominal
    "Nominal mass flow rate";
  Ideal_T pla(
    redeclare package Medium = Medium,
    show_T=true,
    Q_flow_nominal=Q_flow_nominal,
    TSetHeaLea=TSetHeaLea,
    TSetCooLea=TSetCooLea) "Heating and cooling plant"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Fluid.Sources.Boundary_pT pre(
    redeclare package Medium = Medium,
    nPorts=1) "Pressure source"
                               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-62})));
  Fluid.MixingVolumes.MixingVolume vol(nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=0.25*3600*m_flow_nominal/1000)             annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-30})));
  Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Pulse pulse(period=86400, offset=-0.5)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Math.Gain Q_flow(k=-4200) "Heat input to volume"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Math.Gain m_flow(k=-m_flow_nominal) "Pump mass flow rate"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFlo
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
equation

  connect(pre.ports[1], pla.port_a) annotation (Line(points={{-60,-52},{-60,-52},
          {-60,0},{-50,0}},
                          color={0,127,255}));
  connect(pla.port_b, pum.port_a)
    annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));
  connect(pum.port_b, vol.ports[1]) annotation (Line(points={{10,0},{20,0},{32,0},
          {32,-28},{50,-28}}, color={0,127,255}));
  connect(vol.ports[2], pla.port_a) annotation (Line(points={{50,-32},{0,-32},{-56,
          -32},{-56,0},{-50,0}}, color={0,127,255}));
  connect(pulse.y, m_flow.u)
    annotation (Line(points={{-59,50},{-42,50}},          color={0,0,127}));
  connect(m_flow.y, Q_flow.u)
    annotation (Line(points={{-19,50},{18,50}}, color={0,0,127}));
  connect(heaFlo.Q_flow, Q_flow.y)
    annotation (Line(points={{60,50},{41,50}}, color={0,0,127}));
  connect(heaFlo.port, vol.heatPort) annotation (Line(points={{80,50},{90,50},{90,
          20},{60,20},{60,-20}}, color={191,0,0}));
  connect(m_flow.y, pum.m_flow_in)
    annotation (Line(points={{-19,50},{-0.2,50},{-0.2,12}}, color={0,0,127}));
  annotation(experiment(StopTime=864000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DistrictHeatingCooling/Plants/Validation/Plant_T_ClosedLoop.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model tests the ideal plant that takes the leaving water temperature setpoint as an input signal.
The plant is connected to a control volume to which heat is added or removed.
When heat is added, the pump is operated in the reverse flow, otherwise in forward flow.
This moves the water in the circuit through the plant in which it is heated or cooled to meet the
corresponding set point for the leaving water temperature.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 4, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end Plant_T_ClosedLoop;
