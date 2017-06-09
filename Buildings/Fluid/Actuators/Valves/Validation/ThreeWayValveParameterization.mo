within Buildings.Fluid.Actuators.Valves.Validation;
model ThreeWayValveParameterization
  "Test model for parameterization of three-way valves"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium in the component";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.4
    "Design mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp_nominal = 4500
    "Design pressure drop";

  parameter Real Kv_SI = m_flow_nominal/sqrt(dp_nominal)
    "Flow coefficient for fully open valve in SI units, Kv=m_flow/sqrt(dp) [kg/s/(Pa)^(1/2)]";

  parameter Real Kv = Kv_SI/(rhoStd/3600/sqrt(1E5))
    "Kv (metric) flow coefficient [m3/h/(bar)^(1/2)]";
  parameter Real Cv = Kv_SI/(rhoStd*0.0631/1000/sqrt(6895))
    "Cv (US) flow coefficient [USG/min/(psi)^(1/2)]";
  parameter Modelica.SIunits.Area Av = Kv_SI/sqrt(rhoStd)
    "Av (metric) flow coefficient";

  parameter Modelica.SIunits.Density rhoStd=
   Medium.density_pTX(101325, 273.15+4, Medium.X_default)
   "Standard density";

  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valOPPoi(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    dpValve_nominal(displayUnit="kPa") = 4500,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
                           "Three way valve with operating point as parameter"
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));

  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valKv(
    redeclare package Medium = Medium,
    CvData=Buildings.Fluid.Types.CvTypes.Kv,
    m_flow_nominal=m_flow_nominal,
    Kv=Kv,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
                           "Three way valve with Kv-value as parameter"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valCv(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    CvData=Buildings.Fluid.Types.CvTypes.Cv,
    Cv=Cv,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
                           "Three way valve with Cv-value as parameter"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));

  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valAv(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    Av=Av,
    use_inputFilter=false,
    CvData=Buildings.Fluid.Types.CvTypes.Av,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Three way valve with Av-value as parameter"
    annotation (Placement(transformation(extent={{-10,-94},{10,-74}})));

  Buildings.Fluid.Sources.Boundary_pT sou1(
    redeclare package Medium = Medium,
    nPorts=4,
    use_p_in=false,
    p(displayUnit="Pa") = 300000 + 4500,
    T=293.15) "Boundary condition for flow source"
    annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=4,
    use_p_in=false,
    p=300000,
    T=293.15) "Boundary condition for flow sink"    annotation (Placement(
        transformation(extent={{120,-10},{100,10}})));
    Modelica.Blocks.Sources.Ramp y(
    duration=1,
    height=1,
    offset=0) "Control signal"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));

  Buildings.Fluid.Sensors.MassFlowRate senM_flowOpPoi(
    redeclare package Medium = Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Buildings.Fluid.Sensors.MassFlowRate senM_flowKv(
    redeclare package Medium = Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Fluid.Sensors.MassFlowRate senM_flowCv(
    redeclare package Medium = Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Fluid.Sensors.MassFlowRate senM_flowAv(redeclare package Medium =
        Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{20,-94},{40,-74}})));
  Buildings.Fluid.Sources.Boundary_pT sou3(
    redeclare package Medium = Medium,
    nPorts=4,
    use_p_in=false,
    p(displayUnit="Pa") = 300000 + 4500,
    T=293.15) "Boundary condition for flow source"
    annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));
equation
  connect(sou1.ports[1], valOPPoi.port_1) annotation (Line(points={{-48,33},{-32,
          33},{-32,90},{-10,90}}, color={0,127,255}));
  connect(sou1.ports[2], valKv.port_1) annotation (Line(points={{-48,31},{-42,31},
          {-42,30},{-10,30}}, color={0,127,255}));
  connect(sou1.ports[3], valCv.port_1) annotation (Line(points={{-48,29},{-32,29},
          {-32,-30},{-10,-30}}, color={0,127,255}));
  connect(sou1.ports[4], valAv.port_1) annotation (Line(points={{-48,27},{-32,27},
          {-32,-84},{-10,-84}}, color={0,127,255}));
  connect(sou3.ports[1], valOPPoi.port_3) annotation (Line(points={{-50,-7},{-20,
          -7},{-20,70},{0,70},{0,80}}, color={0,127,255}));
  connect(sou3.ports[2], valKv.port_3) annotation (Line(points={{-50,-9},{-20,-9},
          {-20,12},{0,12},{0,20}}, color={0,127,255}));
  connect(sou3.ports[3], valCv.port_3) annotation (Line(points={{-50,-11},{-20,-11},
          {-20,-48},{0,-48},{0,-40}}, color={0,127,255}));
  connect(sou3.ports[4], valAv.port_3) annotation (Line(points={{-50,-13},{-20,-13},
          {-20,-110},{0,-110},{0,-94}}, color={0,127,255}));
  connect(valOPPoi.port_2, senM_flowOpPoi.port_a)
    annotation (Line(points={{10,90},{20,90}}, color={0,127,255}));
  connect(valKv.port_2, senM_flowKv.port_a)
    annotation (Line(points={{10,30},{20,30}}, color={0,127,255}));
  connect(valCv.port_2, senM_flowCv.port_a)
    annotation (Line(points={{10,-30},{20,-30}}, color={0,127,255}));
  connect(valAv.port_2, senM_flowAv.port_a)
    annotation (Line(points={{10,-84},{20,-84}}, color={0,127,255}));
  connect(senM_flowOpPoi.port_b, sin.ports[1]) annotation (Line(points={{40,90},
          {52,90},{52,92},{90,92},{90,3},{100,3}}, color={0,127,255}));
  connect(senM_flowKv.port_b, sin.ports[2]) annotation (Line(points={{40,30},{76,
          30},{76,1},{100,1}}, color={0,127,255}));
  connect(senM_flowCv.port_b, sin.ports[3]) annotation (Line(points={{40,-30},{90,
          -30},{90,-1},{100,-1}}, color={0,127,255}));
  connect(senM_flowAv.port_b, sin.ports[4]) annotation (Line(points={{40,-84},{92,
          -84},{92,-3},{100,-3}}, color={0,127,255}));
  connect(y.y, valOPPoi.y) annotation (Line(points={{-59,110},{0,110},{0,102}},
                            color={0,0,127}));
  connect(y.y, valKv.y) annotation (Line(points={{-59,110},{-40,110},{-40,52},{0,
          52},{0,42}},
                   color={0,0,127}));
  connect(y.y, valCv.y) annotation (Line(points={{-59,110},{-40,110},{-40,0},{0,
          0},{0,-18}},
                    color={0,0,127}));
  connect(y.y, valAv.y) annotation (Line(points={{-59,110},{-40,110},{-40,-60},{
          0,-60},{0,-72}},
                         color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Valves/Validation/ThreeWayValveParameterization.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-100,-140},{140,140}})),
    Documentation(info="<html>
<p>
This model test the parameterization of three-way valves.
All valves are sized equally, but use different configuration options.
Therefore, the valves have all the same mass flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
June 7, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThreeWayValveParameterization;
