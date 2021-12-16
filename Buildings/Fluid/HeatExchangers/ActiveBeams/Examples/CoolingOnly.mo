within Buildings.Fluid.HeatExchangers.ActiveBeams.Examples;
model CoolingOnly
  extends Modelica.Icons.Example;

  package MediumA = Buildings.Media.Air "Medium model for air";

  package MediumW = Buildings.Media.Water "Medium model for water";

  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = MediumW,
    nPorts=1) "Sink for water"
    annotation (Placement(transformation(extent={{100,56},{80,76}})));
  Buildings.Fluid.Sources.MassFlowSource_T souAir(
    redeclare package Medium = MediumA,
    use_m_flow_in=false,
    m_flow=0.0792,
    nPorts=1,
    T=285.85) "Source for air"
    annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = MediumA,
    nPorts=1) "Sink for air"
    annotation (Placement(transformation(extent={{100,-110},{80,-90}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theConWal(G=200)
    "Thermal conductor for wall"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaFlo
    "Thermal loads"
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));
  Modelica.Blocks.Sources.Constant TSetCoo(k=273.15 + 25)
    "Set-point temperature"
    annotation (Placement(transformation(extent={{-110,-20},{-90,0}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TOut(T=301.15)
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  Buildings.Controls.Continuous.LimPID conPID(
    reverseActing=false,
    Td=0,
    k=0.5,
    Ti=70,
    yMax=0.094) "Controller"
         annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));
  Sources.MassFlowSource_T pum(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    nPorts=1,
    T=288.15) "Source for water"
    annotation (Placement(transformation(extent={{-22,56},{-2,76}})));
  Modelica.Blocks.Math.Gain gain(k=1200) "Gain thermal loads"
    annotation (Placement(transformation(extent={{-68,-70},{-48,-50}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTem
    "Room air temperature sensor"
    annotation (Placement(transformation(extent={{-20,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Sine sine(
    f=1/86400,
    amplitude=1,
    phase=-1.5707963267949) "Source for thermal loads"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    nPorts=2,
    redeclare package Medium = MediumA,
    m_flow_nominal=0.1,
    V=30,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15) "Air volume for room"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Fluid.HeatExchangers.ActiveBeams.Cooling beaCoo(
    redeclare package MediumWat = MediumW,
    redeclare package MediumAir = MediumA,
    redeclare
      Buildings.Fluid.HeatExchangers.ActiveBeams.Data.Trox.DID632A_nozzleH_length6ft_cooling perCoo,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Active beam"
    annotation (Placement(transformation(extent={{26,48},{54,72}})));
equation
  connect(TOut.port, theConWal.port_a)
    annotation (Line(points={{-90,-100},{-60,-100}}, color={191,0,0}));
  connect(gain.y, heaFlo.Q_flow)
    annotation (Line(points={{-47,-60},{-30,-60}}, color={0,0,127}));
  connect(TSetCoo.y, conPID.u_s)
    annotation (Line(points={{-89,-10},{-72,-10}}, color={0,0,127}));
  connect(senTem.T, conPID.u_m) annotation (Line(points={{-40,-30},{-50,-30},{-60,
          -30},{-60,-22}}, color={0,0,127}));
  connect(vol.ports[1], bou.ports[1]) annotation (Line(points={{58,-70},{60,-70},
          {60,-100},{80,-100}}, color={0,127,255}));
  connect(heaFlo.port, vol.heatPort)
    annotation (Line(points={{-10,-60},{20,-60},{50,-60}}, color={191,0,0}));
  connect(theConWal.port_b, vol.heatPort) annotation (Line(points={{-40,-100},{
          40,-100},{40,-60},{50,-60}}, color={191,0,0}));
  connect(senTem.port, vol.heatPort) annotation (Line(points={{-20,-30},{40,-30},
          {40,-60},{50,-60}}, color={191,0,0}));
  connect(sine.y, gain.u)
    annotation (Line(points={{-89,-60},{-89,-60},{-70,-60}}, color={0,0,127}));
  connect(beaCoo.watCoo_b, sin_1.ports[1]) annotation (Line(points={{54,66},{70,
          66},{80,66}},           color={0,127,255}));
  connect(beaCoo.heaPor, vol.heatPort) annotation (Line(points={{40,48},{40,48},
          {40,26},{40,-60},{50,-60}}, color={191,0,0}));
  connect(souAir.ports[1], beaCoo.air_a) annotation (Line(points={{80,20},{70,
          20},{70,54},{54,54}}, color={0,127,255}));
  connect(beaCoo.air_b, vol.ports[2]) annotation (Line(points={{26,54},{12,54},
          {12,-80},{62,-80},{62,-70}}, color={0,127,255}));
  connect(pum.ports[1], beaCoo.watCoo_a)
    annotation (Line(points={{-2,66},{12,66},{26,66}}, color={0,127,255}));
  connect(pum.m_flow_in, conPID.y) annotation (Line(points={{-24,74},{-40,74},{
          -40,-10},{-49,-10}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}})),experiment(Tolerance=1e-6, StopTime=172800),
            __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ActiveBeams/Examples/CoolingOnly.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-120,-120},{120,120}})),
     Documentation(info="<html>
<p>
This example tests the implementation of <a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.Cooling\">
Buildings.Fluid.HeatExchangers.ActiveBeams.Cooling</a>.
An air volume is maintained at a temperature below <i>25&deg;</i>C by a controller
that regulates the water flow rate in the active beam.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2019, by Jianjun Hu:<br/>
Replaced fluid source. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>
June 14, 2016, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 20, 2016, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingOnly;
