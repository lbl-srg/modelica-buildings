within Buildings.Obsolete.DistrictHeatingCooling.Plants.Validation;
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
  Obsolete.DistrictHeatingCooling.Plants.Ideal_T pla(
    redeclare package Medium = Medium,
    show_T=true,
    m_flow_nominal=m_flow_nominal) "Heating and cooling plant"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Fluid.Sources.Boundary_pT pre(
    redeclare package Medium = Medium,
    nPorts=1) "Pressure source"
                               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-62})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=0.25*3600*m_flow_nominal/1000)             annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-2})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Pulse pulse(period=86400, offset=-0.5)
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Math.Gain Q_flow(k=-4200) "Heat input to volume"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Blocks.Math.Gain m_flow(k=-m_flow_nominal) "Pump mass flow rate"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFlo
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{58,70},{78,90}})));
  Modelica.Blocks.Continuous.Integrator ECoo(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    u(unit="W"),
    y(unit="J")) "Cooling energy"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Modelica.Blocks.Continuous.Integrator EHea(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    u(unit="W"),
    y(unit="J")) "Heating energy"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
protected
  Modelica.Blocks.Sources.Constant TSetH(k=273.15 + 12)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Blocks.Sources.Constant TSetC(k=273.15 + 16)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));

equation

  connect(pre.ports[1], pla.port_a) annotation (Line(points={{-60,-52},{-60,-52},
          {-60,0},{-50,0}},
                          color={0,127,255}));
  connect(pla.port_b, pum.port_a)
    annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));
  connect(pum.port_b, vol.ports[1]) annotation (Line(points={{10,0},{20,0},{32,
          0},{32,1.77636e-15},{50,1.77636e-15}},
                              color={0,127,255}));
  connect(vol.ports[2], pla.port_a) annotation (Line(points={{50,-4},{50,-4},{
          40,-4},{40,-4},{40,-4},{40,-20},{-60,-20},{-60,0},{-50,0}},
                                 color={0,127,255}));
  connect(pulse.y, m_flow.u)
    annotation (Line(points={{-59,80},{-42,80}},          color={0,0,127}));
  connect(m_flow.y, Q_flow.u)
    annotation (Line(points={{-19,80},{18,80}}, color={0,0,127}));
  connect(heaFlo.Q_flow, Q_flow.y)
    annotation (Line(points={{58,80},{58,80},{41,80}},
                                               color={0,0,127}));
  connect(heaFlo.port, vol.heatPort) annotation (Line(points={{78,80},{90,80},{
          90,20},{60,20},{60,8}},color={191,0,0}));
  connect(m_flow.y, pum.m_flow_in)
    annotation (Line(points={{-19,80},{0,80},{0,12}},       color={0,0,127}));
  connect(TSetC.y, pla.TSetCoo) annotation (Line(points={{-69,10},{-62,10},{-62,
          4},{-52,4}}, color={0,0,127}));
  connect(pla.TSetHea, TSetH.y) annotation (Line(points={{-52,8},{-60,8},{-60,40},
          {-69,40}}, color={0,0,127}));
  connect(pla.QCoo_flow, ECoo.u) annotation (Line(points={{-29,4},{-24,4},{-20,
          4},{-20,-80},{18,-80}}, color={0,0,127}));
  connect(pla.QHea_flow, EHea.u) annotation (Line(points={{-29,6},{-22,6},{-12,
          6},{-12,-40},{18,-40}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-6, StopTime=172800),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/DistrictHeatingCooling/Plants/Validation/Plant_T_ClosedLoop.mos"
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
June 22, 2017, by Thierry S. Nouidui:<br/>
Reformulated the example for JModelica verification.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/816\">issue 816</a>.
</li>
<li>
January 4, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Plant_T_ClosedLoop;
