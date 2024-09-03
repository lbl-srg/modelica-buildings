within Buildings.Fluid.HeatExchangers.Examples;
model DryCoilDiscretizedPControl
  "Model that demonstrates use of a finite volume model of a heat exchanger without condensation and with feedback control"
  extends Modelica.Icons.Example;

  package Medium1 = Buildings.Media.Water "Medium model for water";
  package Medium2 = Buildings.Media.Air "Medium model for air";
  parameter Modelica.Units.SI.Temperature T_a1_nominal=60 + 273.15;
  parameter Modelica.Units.SI.Temperature T_b1_nominal=50 + 273.15;
  parameter Modelica.Units.SI.Temperature T_a2_nominal=20 + 273.15;
  parameter Modelica.Units.SI.Temperature T_b2_nominal=40 + 273.15;
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=5
    "Nominal mass flow rate medium 1";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=m1_flow_nominal*4200
      /1000*(T_a1_nominal - T_b1_nominal)/(T_b2_nominal - T_a2_nominal)
    "Nominal mass flow rate medium 2";

  Sources.MassFlowSource_T            sin_2(                       redeclare
      package Medium = Medium2,
    nPorts=1,
    m_flow=-10.5,
    T=303.15)             annotation (Placement(transformation(extent={{-52,10},
            {-32,30}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(                       redeclare
      package Medium = Medium2,
    nPorts=1,
    use_p_in=false,
    use_T_in=false,
    p(displayUnit="Pa") = 101625,
    T=T_a2_nominal)              annotation (Placement(transformation(extent={{140,10},
            {120,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(                       redeclare
      package Medium = Medium1,
    p=300000,
    T=293.15,
    use_p_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{140,50},
            {120,70}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    p=300000 + 9000,
    nPorts=1,
    use_T_in=false,
    T=T_a1_nominal)              annotation (Placement(transformation(extent={{-52,50},
            {-32,70}})));
    Modelica.Blocks.Sources.Ramp PSin_1(
    duration=60,
    height=5000,
    startTime=240,
    offset=300000)
                 annotation (Placement(transformation(extent={{140,90},{160,110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSen(redeclare package Medium =
        Medium2, m_flow_nominal=m2_flow_nominal)
                 annotation (Placement(transformation(extent={{40,10},{20,30}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium = Medium1,
    l=0.005,
    m_flow_nominal=m1_flow_nominal,
    use_inputFilter=false,
    dpFixed_nominal=2000 + 3000,
    dpValve_nominal=6000) "Valve model"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Modelica.Blocks.Sources.TimeTable TSet(table=[0,298.15; 600,298.15; 600,
        303.15; 1200,303.15; 1800,298.15; 2400,298.15; 2400,304.15])
    "Setpoint temperature"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Fluid.HeatExchangers.DryCoilDiscretized hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    show_T=true,
    nPipPar=1,
    nPipSeg=3,
    nReg=4,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    UA_nominal=m1_flow_nominal*4200*(T_a1_nominal-T_b1_nominal)/
      Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1_nominal,
        T_b1_nominal,
        T_a2_nominal,
        T_b2_nominal),
    dp1_nominal(displayUnit="Pa") = 0,
    dp2_nominal(displayUnit="Pa") = 300,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp1=true,
    from_dp2=true)       annotation (Placement(transformation(extent={{60,16},{
            80,36}})));
  Buildings.Fluid.Actuators.Motors.IdealMotor mot(tOpe=60) "Motor model"
    annotation (Placement(transformation(extent={{12,90},{32,110}})));
  Buildings.Controls.Continuous.LimPID con(
    k=1,
    Ti=60,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    Td=60) "Controller"               annotation (Placement(transformation(
          extent={{-20,90},{0,110}})));
equation
  connect(PSin_1.y, sin_1.p_in) annotation (Line(points={{161,100},{180,100},{
          180,68},{142,68}},
                         color={0,0,127}));
  connect(val.port_b, hex.port_a1)                   annotation (Line(points={{50,60},
          {52,60},{52,32},{60,32}},        color={0,127,255}));
  connect(sou_1.ports[1], val.port_a) annotation (Line(
      points={{-32,60},{30,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_2.ports[1], hex.port_a2) annotation (Line(
      points={{120,20},{80,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mot.y, val.y) annotation (Line(
      points={{33,100},{40,100},{40,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.port_b2, temSen.port_a) annotation (Line(
      points={{60,20},{40,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSet.y, con.u_s)
                         annotation (Line(
      points={{-59,100},{-22,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.T, con.u_m)
                           annotation (Line(
      points={{30,31},{30,40},{-10,40},{-10,88}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.y, mot.u)
                      annotation (Line(
      points={{1,100},{10,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.port_b1, sin_1.ports[1]) annotation (Line(
      points={{80,32},{100,32},{100,60},{120,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSen.port_b, sin_2.ports[1]) annotation (Line(
      points={{20,20},{-32,20}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{200,200}})),
experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/DryCoilDiscretizedPControl.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model demonstrates the use of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilDiscretized\">
Buildings.Fluid.HeatExchangers.DryCoilDiscretized</a>.
The valve on the water-side is regulated to track a setpoint temperature
for the air outlet.
</p>
<p>
Note that between the controller output and the valve is a model of a motor
that has hysteresis. The events generated by the motor model can lead to a
significantly higher computing time. In most applications, this level
of modeling detail is not justified.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
July 3, 2014, by Michael Wetter:<br/>
Changed pressure sink to mass flow rate sink to avoid an overdetermined
by consistent set of initial conditions.
</li>
<li>
March 1, 2013, by Michael Wetter:<br/>
Added nominal pressure drop for valve as
this parameter no longer has a default value.
</li>
</ul>
</html>"));
end DryCoilDiscretizedPControl;
