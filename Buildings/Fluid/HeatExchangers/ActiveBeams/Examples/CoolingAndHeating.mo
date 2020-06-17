within Buildings.Fluid.HeatExchangers.ActiveBeams.Examples;
model CoolingAndHeating
  extends Modelica.Icons.Example;

  package MediumA = Buildings.Media.Air "Medium model for air";

  package MediumW = Buildings.Media.Water "Medium model for water";

  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = MediumW,
    nPorts=1) "Sink chilled water"
    annotation (Placement(transformation(extent={{100,90},{80,110}})));
  Buildings.Fluid.Sources.MassFlowSource_T souAir(
    redeclare package Medium = MediumA,
    m_flow=0.0792,
    use_m_flow_in=false,
    nPorts=1,
    T=285.85) "Source air"
    annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = MediumA,
    nPorts=1) "Sink air"
    annotation (Placement(transformation(extent={{100,-110},{80,-90}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theConWal(G=200)
    "Thermal conductor for wall"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaFlo
    "Thermal loads"
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));
  Modelica.Blocks.Sources.Constant TSetHea(k=273.15 + 22)
    "Heating set-point temperature"
    annotation (Placement(transformation(extent={{-110,-20},{-90,0}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TOut(T=301.15)
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  Buildings.Controls.Continuous.LimPID conHea(
    yMax=0.094,
    Td=0,
    Ti=100,
    k=0.1)
    "Controller for heating"
         annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));
  Sources.MassFlowSource_T pumCoo(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    nPorts=1,
    T=288.15) "Source chilled water"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Modelica.Blocks.Math.Gain gain(k=1200) "Gain for thermal loads"
    annotation (Placement(transformation(extent={{-68,-70},{-48,-50}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTem
    "Room air temperature sensor"
    annotation (Placement(transformation(extent={{-20,-40},{-40,-20}})));
  Sources.MassFlowSource_T pumHea(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    nPorts=1,
    T=320.95) "Source hot water"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = MediumW,
    nPorts=1) "Sink hot water"
    annotation (Placement(transformation(extent={{100,50},{80,70}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1/86400,
    amplitude=1,
    phase=-1.5707963267949) "Source for thermal loads"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(nPorts=2,
    redeclare package Medium = MediumA,
    m_flow_nominal=0.1,
    V=30,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Air volume for room"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Modelica.Blocks.Sources.Constant TSetCoo(k=273.15 + 25)
    "Cooling set-point temperature"
    annotation (Placement(transformation(extent={{-110,20},{-90,40}})));
  Buildings.Controls.Continuous.LimPID conCoo(
    yMax=0.094,
    reverseActing=false,
    Td=0,
    k=0.5,
    Ti=70)
    "Controller for cooling"
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));

  Buildings.Fluid.HeatExchangers.ActiveBeams.CoolingAndHeating beaCooHea(
    redeclare package MediumWat = MediumW,
    redeclare package MediumAir = MediumA,
    redeclare
      Buildings.Fluid.HeatExchangers.ActiveBeams.Data.Trox.DID632A_nozzleH_length6ft_cooling perCoo,
    redeclare
      Buildings.Fluid.HeatExchangers.ActiveBeams.Data.Trox.DID632A_nozzleH_length6ft_heating perHea,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Active Beam"
    annotation (Placement(transformation(extent={{26,48},{54,72}})));
equation
  connect(TOut.port, theConWal.port_a)
    annotation (Line(points={{-90,-100},{-60,-100}}, color={191,0,0}));
  connect(gain.y, heaFlo.Q_flow)
    annotation (Line(points={{-47,-60},{-30,-60}}, color={0,0,127}));
  connect(senTem.T,conHea. u_m) annotation (Line(points={{-40,-30},{-50,-30},{-60,
          -30},{-60,-22}}, color={0,0,127}));
  connect(sine.y, gain.u)
    annotation (Line(points={{-89,-60},{-70,-60}}, color={0,0,127}));
  connect(bou.ports[1], vol.ports[1]) annotation (Line(points={{80,-100},{58,
          -100},{58,-70}}, color={0,127,255}));
  connect(theConWal.port_b, vol.heatPort) annotation (Line(points={{-40,-100},{
          -2,-100},{40,-100},{40,-60},{50,-60}}, color={191,0,0}));
  connect(heaFlo.port, vol.heatPort)
    annotation (Line(points={{-10,-60},{20,-60},{50,-60}}, color={191,0,0}));
  connect(senTem.port, vol.heatPort) annotation (Line(points={{-20,-30},{40,-30},
          {40,-60},{50,-60}}, color={191,0,0}));
  connect(TSetHea.y, conHea.u_s) annotation (Line(points={{-89,-10},{-80.5,-10},
          {-72,-10}}, color={0,0,127}));
  connect(TSetCoo.y, conCoo.u_s)
    annotation (Line(points={{-89,30},{-72,30}}, color={0,0,127}));
  connect(conCoo.u_m, senTem.T) annotation (Line(points={{-60,18},{-60,10},{-80,
          10},{-80,-30},{-40,-30}}, color={0,0,127}));
  connect(beaCooHea.watCoo_b, sin_1.ports[1]) annotation (Line(points={{54,66},
          {60,66},{60,100},{80,100}}, color={0,127,255}));
  connect(sin_2.ports[1], beaCooHea.watHea_b)
    annotation (Line(points={{80,60},{68,60},{54,60}}, color={0,127,255}));
  connect(souAir.ports[1], beaCooHea.air_a) annotation (Line(points={{80,20},{
          60,20},{60,54},{54,54}}, color={0,127,255}));
  connect(beaCooHea.air_b, vol.ports[2]) annotation (Line(points={{26,54},{20,
          54},{20,-80},{62,-80},{62,-70}}, color={0,127,255}));
  connect(beaCooHea.heaPor, vol.heatPort) annotation (Line(points={{40,48},{40,
          48},{40,16},{40,-60},{50,-60}}, color={191,0,0}));
  connect(conCoo.y, pumCoo.m_flow_in) annotation (Line(points={{-49,30},{-40,30},
          {-40,108},{-22,108}}, color={0,0,127}));
  connect(conHea.y, pumHea.m_flow_in) annotation (Line(points={{-49,-10},{-32,
          -10},{-32,68},{-22,68}}, color={0,0,127}));
  connect(pumCoo.ports[1], beaCooHea.watCoo_a) annotation (Line(points={{0,100},
          {12,100},{20,100},{20,66},{26,66}}, color={0,127,255}));
  connect(pumHea.ports[1], beaCooHea.watHea_a)
    annotation (Line(points={{0,60},{13,60},{26,60}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}})),experiment(Tolerance=1e-6, StopTime=172800),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ActiveBeams/Examples/CoolingAndHeating.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-120,-120},{120,120}})),
     Documentation(info="<html>
<p>
This example tests the implementation of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.CoolingAndHeating\">
Buildings.Fluid.HeatExchangers.ActiveBeams.CoolingAndHeating</a>
for both heating and cooling mode. An air volume is maintained at a temperature between <i>22&deg;</i>C and
<i>25&deg;</i>C by two controllers that regulate the water flow rate in the active beam.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2019, by Jianjun Hu:<br/>
Replaced fluid source. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>
June 25, 2016, by Michael Wetter:<br/>
Changed medium start temperature to avoid conflicting
start values of the same precedence in Dymola 2016.
See
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/485\">
issue 485</a>.
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
end CoolingAndHeating;
