within Buildings.Fluid.Boilers.Examples;
model BoilerPolynomialClosedLoop "Boiler with closed loop control"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Water "Medium model";
 parameter Modelica.SIunits.Power Q_flow_nominal = 20000 "Nominal power";
 parameter Modelica.SIunits.Temperature dT_nominal = 20
    "Nominal temperature difference";
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/dT_nominal/4200
    "Nominal mass flow rate";

  Buildings.Fluid.Boilers.BoilerPolynomial boi(
    a={0.9},
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    Q_flow_nominal=Q_flow_nominal,
    redeclare package Medium = Medium,
    dp_nominal=20000,
    m_flow_nominal=m_flow_nominal,
    fue=Buildings.Fluid.Data.Fuels.HeatingOilLowerHeatingValue(),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15) "Boiler"
    annotation (Placement(transformation(extent={{40,-110},{20,-90}})));
  Modelica.Blocks.Logical.OnOffController onOffController(bandwidth=20)
    annotation (Placement(transformation(extent={{-130,-80},{-110,-60}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-92,-80},{-72,-60}})));
  Actuators.Valves.ThreeWayEqualPercentageLinear val(
    redeclare package Medium = Medium,
    l={0.01,0.01},
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=6000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,40})));
  Movers.FlowControlled_m_flow pumLoa(
    redeclare package Medium = Medium,
    m_flow_nominal=2*m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump for heating load" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110})));
  Movers.FlowControlled_m_flow pumBoi(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump for boiler loop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-20})));
  Modelica.Blocks.Sources.Constant m_flow_pum(k=m_flow_nominal)
    "Mass flow rate of pump"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica.Blocks.Sources.Constant TSetBoi(k=273.15 + 70)
    "Temperature setpoint for boiler"
    annotation (Placement(transformation(extent={{-170,-74},{-150,-54}})));
  Controls.Continuous.LimPID conPID(
    Td=1,
    k=0.5,
    Ti=100)
          annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Constant TSetHea(k=273.15 + 40)
    "Temperature setpoint for heating load"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Fluid.FixedResistances.Junction spl(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,2,1},
    dp_nominal={0,0,200},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Splitter/mixer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,70})));
  Buildings.Fluid.FixedResistances.Junction spl1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal={0,0,100},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Splitter/mixer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,10})));
  Buildings.Fluid.FixedResistances.Junction spl2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=0*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Splitter/mixer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,10})));
  Buildings.Fluid.FixedResistances.Junction spl3(
    redeclare package Medium = Medium,
    dp_nominal=0*{1,1,1},
    m_flow_nominal=m_flow_nominal*{2,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Splitter/mixer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,70})));
  Storage.ExpansionVessel exp(redeclare package Medium = Medium, V_start=1)
    annotation (Placement(transformation(extent={{104,-80},{124,-60}})));
  Buildings.Fluid.FixedResistances.Junction spl4(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=0*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Splitter/mixer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,40})));
  MixingVolumes.MixingVolume vol(
    nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=2*m_flow_nominal,
    V=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
         annotation (Placement(transformation(extent={{40,162},{60,182}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=0.1
        *Q_flow_nominal/(40 - 20))
    annotation (Placement(transformation(extent={{-80,162},{-60,182}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TBou(T=293.15)
    "Fixed temperature boundary condition"
    annotation (Placement(transformation(extent={{-120,162},{-100,182}})));
  Modelica.Blocks.Math.Gain gain(k=2)
    "Multiply the mass flow rate as this circuit has a smaller temperature difference"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TVol
    "Sensor for volume temperature"
    annotation (Placement(transformation(extent={{-60,120},{-80,140}})));
equation
  connect(onOffController.y, booleanToReal.u) annotation (Line(
      points={{-109,-70},{-94,-70}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(boi.port_b, pumBoi.port_a)
                                   annotation (Line(
      points={{20,-100},{-1.12703e-16,-100},{-1.12703e-16,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi.T, onOffController.u) annotation (Line(
      points={{19,-92},{-140,-92},{-140,-76},{-132,-76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conPID.y, val.y) annotation (Line(
      points={{-59,40},{-12,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetHea.y, conPID.u_s) annotation (Line(
      points={{-99,40},{-82,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetBoi.y, onOffController.reference) annotation (Line(
      points={{-149,-64},{-132,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(val.port_2, spl.port_1) annotation (Line(
      points={{1.1119e-15,50},{0,54},{9.99197e-16,56},{-1.12703e-16,56},{
          -1.12703e-16,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl.port_2, pumLoa.port_a) annotation (Line(
      points={{1.1119e-15,80},{0,86},{9.99197e-16,90},{-1.12703e-16,90},{
          -1.12703e-16,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumBoi.port_b, spl1.port_1) annotation (Line(
      points={{1.1119e-15,-10},{0,-8},{9.99197e-16,-6},{-1.12703e-16,-6},{
          -1.12703e-16,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl1.port_2, val.port_1) annotation (Line(
      points={{1.1119e-15,20},{0,24},{9.99197e-16,26},{-1.12703e-16,26},{
          -1.12703e-16,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl2.port_2, boi.port_a) annotation (Line(
      points={{80,1.22125e-15},{80,-100},{40,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi.port_a, exp.port_a) annotation (Line(
      points={{40,-100},{114,-100},{114,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl3.port_2, spl4.port_1) annotation (Line(
      points={{80,60},{80,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl4.port_2, spl2.port_1) annotation (Line(
      points={{80,30},{80,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl4.port_3, val.port_3) annotation (Line(
      points={{70,40},{10,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(booleanToReal.y, boi.y) annotation (Line(
      points={{-71,-70},{56,-70},{56,-92},{42,-92}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow_pum.y, pumBoi.m_flow_in) annotation (Line(
      points={{-59,-20},{-12,-20},{-12,-20.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol.ports[1], spl3.port_1) annotation (Line(
      points={{48,162},{80,162},{80,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TBou.port, thermalConductor.port_a) annotation (Line(
      points={{-100,172},{-80,172}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, vol.heatPort) annotation (Line(
      points={{-60,172},{40,172}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gain.y, pumLoa.m_flow_in) annotation (Line(
      points={{-19,110},{-13.6,110},{-13.6,109.8},{-12,109.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow_pum.y, gain.u) annotation (Line(
      points={{-59,-20},{-52,-20},{-52,110},{-42,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TVol.port, vol.heatPort) annotation (Line(
      points={{-60,130},{-28,130},{-28,172},{40,172}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TVol.T, conPID.u_m) annotation (Line(
      points={{-80,130},{-130,130},{-130,10},{-70,10},{-70,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumLoa.port_b, vol.ports[2]) annotation (Line(
      points={{1.1119e-15,120},{1.1119e-15,162},{52,162}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl.port_3, spl3.port_3) annotation (Line(
      points={{10,70},{70,70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl1.port_3, spl2.port_3) annotation (Line(
      points={{10,10},{70,10}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-200},
            {200,200}})),
             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/Examples/BoilerPolynomialClosedLoop.mos"
        "Simulate and plot"),
    experiment(
      StopTime=14400,
      Tolerance=1e-6),
    Documentation(info="<html>
<p>
This model illustrates how to use a boiler model
with closed loop control.
The controller modulates the boiler temperature between
60&deg;C and 80&deg;C.
A three-way valve mixes recirculated water with boiler water
to regulate the temperature of the volume at a constant temperature
of 40&deg;C.
There is also a bypass in the boiler loop to ensure circulation when the
valve position is such that it only recirculates water from the load.
The bypass between valve and pump mixes recirculated water, thereby
allowing the valve to work over a larger operating range.
The expansion vessel near the boiler is used to set a reference pressure,
and it is used to accommodate for the thermal expansion of the water.
</p>
</html>", revisions="<html>
<ul>
<li>
March 1, 2016, by Michael Wetter:<br/>
Removed parameter <code>dynamicBalance</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/484\">#484</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
October 6, 2014, by Michael Wetter:<br/>
Corrected wrong value of <code>m_flow_nominal</code> for <code>spl3</code>.
</li>
<li>
March 25, 2014, by Michael Wetter:<br/>
Updated model with new expansion vessel.
</li>
<li>
March 1, 2013, by Michael Wetter:<br/>
Added nominal pressure drop for valve as
this parameter no longer has a default value.
</li>
<li>
November 1, 2011 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BoilerPolynomialClosedLoop;
