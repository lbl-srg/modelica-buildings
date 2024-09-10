within Buildings.Fluid.Movers.Validation;
model PumpCurveConstruction
  "Validation model that tests that the pump curve is properly extrapolated to V=0 and dp=0"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate at zero pump head";
  parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal=m_flow_nominal/1000
    "Nominal mass flow rate at zero pump head";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=10000
    "Nominal pump head at zero mass flow rate";

  Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    use_inputFilter=false,
    dpValve_nominal=dp_nominal/1000,
    from_dp=false) "Valve with very small pressure drop if fully open"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    nPorts=8,
    p=101325,
    T=293.15) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-82,4},{-62,24}})));

  Buildings.Fluid.Movers.SpeedControlled_y pum(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_riseTime=false,
    per(pressure(V_flow={0,0.5*V_flow_nominal,V_flow_nominal}, dp={dp_nominal,
            0.5*dp_nominal,0})),
    inputType=Buildings.Fluid.Types.InputType.Constant)
    "Pump with 3 data points for the pressure flow relation"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));

  Buildings.Fluid.Movers.SpeedControlled_y pum_dp(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_riseTime=false,
    per(pressure(V_flow={0.5*V_flow_nominal,0.75*V_flow_nominal,V_flow_nominal},
          dp={0.5*dp_nominal,0.25*dp_nominal,0})),
    inputType=Buildings.Fluid.Types.InputType.Constant)
    "Pump with 2 data points for the pressure flow relation, with data at dp=0"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  Buildings.Fluid.Movers.SpeedControlled_y pum_m_flow(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_riseTime=false,
    per(pressure(V_flow={0,0.25*V_flow_nominal,0.5*V_flow_nominal}, dp={
            dp_nominal,0.75*dp_nominal,0.5*dp_nominal})),
    inputType=Buildings.Fluid.Types.InputType.Constant)
    "Pump with 2 data points for the pressure flow relation, with data at m_flow=0"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  Buildings.Fluid.Movers.SpeedControlled_y pum_no(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_riseTime=false,
    per(pressure(V_flow={0.25*V_flow_nominal,0.5*V_flow_nominal,0.75*
            V_flow_nominal}, dp={0.75*dp_nominal,0.5*dp_nominal,0.25*dp_nominal})),
    inputType=Buildings.Fluid.Types.InputType.Constant)
    "Pump with 2 data points for the pressure flow relation, with no data at m_flow=0 and dp=0"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

  Modelica.Blocks.Sources.Ramp yVal(
    duration=1,
    offset=1,
    height=-0.99) "Input signal for valve"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));

  Actuators.Valves.TwoWayLinear val2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    use_inputFilter=false,
    dpValve_nominal=dp_nominal/1000,
    from_dp=false) "Valve with very small pressure drop if fully open"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Actuators.Valves.TwoWayLinear val3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    use_inputFilter=false,
    dpValve_nominal=dp_nominal/1000,
    from_dp=false) "Valve with very small pressure drop if fully open"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));

  Actuators.Valves.TwoWayLinear val4(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    use_inputFilter=false,
    dpValve_nominal=dp_nominal/1000,
    from_dp=false) "Valve with very small pressure drop if fully open"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));

equation
  connect(pum.port_a, val1.port_b) annotation (Line(
      points={{40,80},{0,80}},
      color={0,127,255}));
  connect(val1.port_a, sou.ports[1]) annotation (Line(
      points={{-20,80},{-40,80},{-40,17.5},{-62,17.5}},
      color={0,127,255}));
  connect(yVal.y, val1.y) annotation (Line(
      points={{-39,100},{-10,100},{-10,92}},
      color={0,0,127}));
  connect(pum_dp.port_a, val2.port_b) annotation (Line(
      points={{40,30},{0,30}},
      color={0,127,255}));
  connect(pum_m_flow.port_a, val3.port_b) annotation (Line(
      points={{40,-20},{0,-20}},
      color={0,127,255}));
  connect(sou.ports[2], val2.port_a) annotation (Line(
      points={{-62,16.5},{-38,16.5},{-38,30},{-20,30}},
      color={0,127,255}));
  connect(val3.port_a, sou.ports[3]) annotation (Line(
      points={{-20,-20},{-38,-20},{-38,15.5},{-62,15.5}},
      color={0,127,255}));
  connect(yVal.y, val2.y) annotation (Line(
      points={{-39,100},{-32,100},{-32,56},{-10,56},{-10,42}},
      color={0,0,127}));
  connect(yVal.y, val3.y) annotation (Line(
      points={{-39,100},{-32,100},{-32,4},{-10,4},{-10,-8}},
      color={0,0,127}));

  connect(val4.port_a, sou.ports[4]) annotation (Line(
      points={{-20,-60},{-40,-60},{-40,14.5},{-62,14.5}},
      color={0,127,255}));
  connect(val4.port_b, pum_no.port_a) annotation (Line(
      points={{0,-60},{40,-60}},
      color={0,127,255}));
  connect(yVal.y, val4.y) annotation (Line(
      points={{-39,100},{-32,100},{-32,-40},{-10,-40},{-10,-48}},
      color={0,0,127}));
  connect(pum_no.port_b, sou.ports[5]) annotation (Line(
      points={{60,-60},{68,-60},{68,-80},{-42,-80},{-42,13.5},{-62,13.5}},
      color={0,127,255}));
  connect(pum_m_flow.port_b, sou.ports[6]) annotation (Line(
      points={{60,-20},{68,-20},{72,-20},{72,-84},{-44,-84},{-44,12.5},{-62,
          12.5}},
      color={0,127,255}));
  connect(pum_dp.port_b, sou.ports[7]) annotation (Line(
      points={{60,30},{76,30},{76,-88},{-46,-88},{-46,11.5},{-62,11.5}},
      color={0,127,255}));
  connect(pum.port_b, sou.ports[8]) annotation (Line(
      points={{60,80},{80,80},{80,-92},{-48,-92},{-48,10.5},{-62,10.5}},
      color={0,127,255}));
  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Validation/PumpCurveConstruction.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests whether the construction of the pump curve is correct implemented
for the cases where no data point is given at zero head, zero mass flow rate, or both.
</p>
<p>
Each pump is identical, but different points on the pump curve are specified.
However, the pump curves are linear and hence, because the pump curves are linearly
extrapolated, all four pumps need to give the same flow rate.
</p>
<h4>Implementation</h4>
<p>
The pump curves are such that the protected parameter <code>curve</code>
of the pumps have different values. This then tests the correct extrapolation.
</p>
</html>", revisions="<html>
<ul>
<li>
December 6, 2016, by Michael Wetter:<br/>
Relaxed input signal to allow simulation if bounds on min and max values are checked in Dymola.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/606\">#606</a>.
</li>
<li>February 20, 2016, by Ruben Baetens:<br/>
Removal of <code>dynamicBalance</code> as parameter for <code>massDynamics</code> and <code>energyDynamics</code>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
January 7, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,120}},
          preserveAspectRatio=false), graphics),
    Icon(coordinateSystem(extent={{-100,-100},{100,120}})));
end PumpCurveConstruction;
