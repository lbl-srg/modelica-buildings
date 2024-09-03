within Buildings.Fluid.Actuators.Dampers.Validation;
model PressureIndependent
  "Test model for the pressure independent damper model"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air "Medium model for air";
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
     = 10 "Damper nominal pressure drop";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Damper nominal mass flow rate";
  Buildings.Fluid.Actuators.Dampers.Exponential damExp(
    redeclare final package Medium = Medium,
    use_inputFilter=false,
    final dpDamper_nominal=dp_nominal,
    final m_flow_nominal=m_flow_nominal)
    "Damper with exponential opening characteristics"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Modelica.Blocks.Sources.Ramp yRam(
    duration=0.3,
    offset=0,
    startTime=0.3,
    height=1) "Ramp up damper control signal"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare final package Medium = Medium,
    use_p_in=true,
    p(displayUnit="Pa") = 101335,
    T=293.15,
    nPorts=4) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium = Medium,
    nPorts=4) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{102,-10},{82,10}})));
  Buildings.Fluid.Actuators.Dampers.PressureIndependent damPreInd(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dp_nominal,
    use_inputFilter=false)
    "Pressure independent damper"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Exponential damExpPI(
    redeclare final package Medium = Medium,
    use_inputFilter=false,
    final dpDamper_nominal=dp_nominal,
    final m_flow_nominal=m_flow_nominal)
    "Damper with exponential opening characteristics"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Controls.Continuous.LimPID conPID(
    k=10,
    Ti=0.001,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Discharge flow rate controller"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium = Medium)
    "Discharge flow rate sensor"
    annotation (Placement(transformation(extent={{30,-70},{50,-90}})));
  Modelica.Blocks.Sources.Ramp yRam1(
    duration=0.3,
    offset=Medium.p_default - 20,
    startTime=0,
    height=40) "Ram up supply pressure"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Modelica.Blocks.Sources.Ramp yRam2(
    duration=0.3,
    offset=0,
    startTime=0.7,
    height=-40) "Ramp down supply pressure"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-52,30},{-32,50}})));
  Sensors.RelativePressure senRelPre(
    redeclare final package Medium = Medium)
    "Pressure drop sensor"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Math.Gain gain(final k=1/m_flow_nominal)
    "Normalize discharge flow rate"
    annotation (Placement(transformation(extent={{-20,-110},{-40,-90}})));
equation
  connect(damExp.port_a, sou.ports[1]) annotation (Line(points={{0,-40},{-20,-40},
          {-20,3},{-30,3}}, color={0,127,255}));
  connect(damExp.port_b, sin.ports[1]) annotation (Line(points={{20,-40},{60,
          -40},{60,3},{82,3}},
                          color={0,127,255}));
  connect(sou.ports[2], damPreInd.port_a) annotation (Line(points={{-30,1},{-20,
          1},{-20,0},{0,0}}, color={0,127,255}));
  connect(damPreInd.port_b, sin.ports[2])
    annotation (Line(points={{20,0},{48,0},{48,1},{82,1}}, color={0,127,255}));
  connect(yRam.y, damPreInd.y) annotation (Line(points={{1,80},{40,80},{40,20},{
          10,20},{10,12}}, color={0,0,127}));
  connect(damPreInd.y_actual, damExp.y) annotation (Line(points={{15,7},{40,7},{
          40,-20},{10,-20},{10,-28}}, color={0,0,127}));
  connect(damExpPI.port_b, senMasFlo.port_a)
    annotation (Line(points={{20,-80},{30,-80}}, color={0,127,255}));
  connect(senMasFlo.port_b, sin.ports[3]) annotation (Line(points={{50,-80},{68,
          -80},{68,-1},{82,-1}},             color={0,127,255}));
  connect(sou.ports[3], damExpPI.port_a) annotation (Line(points={{-30,-1},{-20,
          -1},{-20,-80},{0,-80}}, color={0,127,255}));
  connect(conPID.y, damExpPI.y)
    annotation (Line(points={{-49,-60},{10,-60},{10,-68}}, color={0,0,127}));
  connect(yRam.y, conPID.u_s) annotation (Line(points={{1,80},{40,80},{40,100},{
          -100,100},{-100,-60},{-72,-60}},
                                    color={0,0,127}));
  connect(yRam1.y, add.u1) annotation (Line(points={{-69,80},{-60,80},{-60,46},
          {-54,46}}, color={0,0,127}));
  connect(yRam2.y, add.u2) annotation (Line(points={{-69,40},{-60,40},{-60,34},
          {-54,34}}, color={0,0,127}));
  connect(add.y, sou.p_in) annotation (Line(points={{-31,40},{-26,40},{-26,20},{
          -60,20},{-60,8},{-52,8}},  color={0,0,127}));
  connect(sou.ports[4], senRelPre.port_a) annotation (Line(points={{-30,-3},{-20,
          -3},{-20,40},{0,40}}, color={0,127,255}));
  connect(senRelPre.port_b, sin.ports[4]) annotation (Line(points={{20,40},{60,
          40},{60,-3},{82,-3}},
                            color={0,127,255}));
  connect(senMasFlo.m_flow, gain.u)
    annotation (Line(points={{40,-91},{40,-100},{-18,-100}}, color={0,0,127}));
  connect(gain.y, conPID.u_m) annotation (Line(points={{-41,-100},{-60,-100},{-60,
          -72}}, color={0,0,127}));
    annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(
file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Dampers/Validation/PressureIndependent.mos"
"Simulate and plot"),
Documentation(info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.PressureIndependent\">
Buildings.Fluid.Actuators.Dampers.PressureIndependent</a>
by comparing it with
</p>
<ul>
<li>
an exponential damper model which opening is the one computed by the
pressure independent model, see <code>damExp</code>,
</li>
<li>
an exponential damper model which opening is computed by a PI controller
tracking the same discharge mass flow rate, see <code>damExpPI</code>.
</li>
</ul>
<p>
The simulation consists in exposing these three models to
<ol>
<li>
a first increase in the pressure drop at the damper boundaries, from negative
to positive values, with a zero input control signal,
</li>
<li>
a consecutive increase of input control signal, from zero to one, with a
constant pressure drop at the damper boundaries,
</li>
<li>
an eventual decrease in the pressure drop, from positive to negative values,
with an input control signal equal to one.
</li>
</ol>
<p>
One can notice a small variation of the computed damper opening in the last
transient around flow reversal.
This is because the expression of the flow coefficient as a function of the
mass flow rate and pressure drop is ill-defined near zero flow rate and
the damper opening value results from the regularization process.
</p>
</html>", revisions="<html>
<ul>
<li>
April 5, 2020 by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})));
end PressureIndependent;
