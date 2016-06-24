within Buildings.Fluid.HeatExchangers.ActiveBeams.Validation;
model NumberOfBeams
  extends Modelica.Icons.Example;

  package MediumA = Buildings.Media.Air "Medium model for air";

  package MediumW = Buildings.Media.Water "Medium model for water";

  parameter Integer nBeams = 10 "Number of beams";

  Buildings.Fluid.Sources.FixedBoundary sin_1(
    redeclare package Medium = MediumW,
    nPorts=2) "Sink for chilled water"
    annotation (Placement(transformation(extent={{80,70},{60,90}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou_3(
    redeclare package Medium = MediumA,
    use_m_flow_in=false,
    nPorts=1,
    m_flow=0.0792,
    T=285.85) "Source for air" annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Buildings.Fluid.Sources.FixedBoundary sin_3(
    redeclare package Medium = MediumA,
    nPorts=2)
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Fluid.Sources.FixedBoundary sou_1(
    redeclare package Medium = MediumW,
    nPorts=2,
    T=288.15) "Source for chilled water"
    annotation (Placement(transformation(extent={{-120,68},{-100,88}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = MediumW,
    m_flow_nominal=0.094,
    addPowerToMedium=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Pump for hot water"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Fluid.Sources.FixedBoundary sou_2(
    redeclare package Medium = MediumW,
    nPorts=2,
    T=320.95) "Source for hot water" annotation (Placement(transformation(extent={{-120,28},{-100,48}})));
  Buildings.Fluid.Sources.FixedBoundary sin_2(
    redeclare package Medium = MediumW,
    nPorts=2) "Sink for hot water"
    annotation (Placement(transformation(extent={{80,30},{60,50}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum1(
    redeclare package Medium = MediumW,
    m_flow_nominal=0.094,
    addPowerToMedium=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Pump for chilled water"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Fluid.HeatExchangers.ActiveBeams.CoolingAndHeating beaCooHea(
    redeclare package MediumWat = MediumW,
    redeclare package MediumAir = MediumA,
    redeclare
      Buildings.Fluid.HeatExchangers.ActiveBeams.Data.Trox.DID632A_nozzleH_lenght6ft_cooling perCoo,
    redeclare
      Buildings.Fluid.HeatExchangers.ActiveBeams.Data.Trox.DID632A_nozzleH_lenght6ft_heating perHea,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    nBeams=1) "Active beam"
    annotation (Placement(transformation(extent={{-14,28},{14,52}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature "Room temperature"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));

  Buildings.Fluid.Sources.MassFlowSource_T sou_4(
    redeclare package Medium = MediumA,
    use_m_flow_in=false,
    nPorts=1,
    m_flow=0.0792*10,
    T=285.85) "Source for air" annotation (Placement(transformation(extent={{80,-130},{60,-110}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum2(
    redeclare package Medium = MediumW,
    m_flow_nominal=0.094,
    addPowerToMedium=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Pump for hot water"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum3(
    redeclare package Medium = MediumW,
    m_flow_nominal=0.094,
    addPowerToMedium=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Pump for chilled water"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Buildings.Fluid.HeatExchangers.ActiveBeams.CoolingAndHeating beaCooHea1(
    redeclare package MediumWat = MediumW,
    redeclare package MediumAir = MediumA,
    redeclare
      Buildings.Fluid.HeatExchangers.ActiveBeams.Data.Trox.DID632A_nozzleH_lenght6ft_cooling perCoo,
    redeclare
      Buildings.Fluid.HeatExchangers.ActiveBeams.Data.Trox.DID632A_nozzleH_lenght6ft_heating perHea,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    nBeams=nBeams) "Active beam"
    annotation (Placement(transformation(extent={{-14,-92},{14,-68}})));
  Modelica.Blocks.Sources.Step step(
    height=-0.094,
    offset=0.094,
    startTime=2000) "chilled water mass flow rate"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Modelica.Blocks.Sources.Step step1(
    height=0.094,
    startTime=3000)
    "Hot water mass flow rate"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Modelica.Blocks.Sources.Step step2(
    height=0.094*nBeams,
    startTime=3000) "Hot water mass flow rate"
    annotation (Placement(transformation(extent={{-180,-70},{-160,-50}})));
  Modelica.Blocks.Sources.Step step3(
    height=-0.094*nBeams,
    offset=0.094*nBeams,
    startTime=2000) "Chilled water mass flow rate"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Modelica.Blocks.Sources.Step step4(
    offset=273.15 + 25,
    height=-5,
    startTime=2500) "Room air temperature variation"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
equation
  connect(sou_2.ports[1], pum.port_a)
    annotation (Line(points={{-100,40},{-80,40},{-60,40}}, color={0,127,255}));
  connect(pum1.port_a, sou_1.ports[1])
    annotation (Line(points={{-60,80},{-80,80},{-100,80}}, color={0,127,255}));
  connect(pum1.port_b, beaCooHea.watCoo_a) annotation (Line(points={{-40,80},{-32,
          80},{-20,80},{-20,46},{-14,46}},color={0,127,255}));
  connect(beaCooHea.watCoo_b, sin_1.ports[1]) annotation (Line(points={{14,46},{
          20,46},{20,82},{60,82}}, color={0,127,255}));
  connect(sin_2.ports[1], beaCooHea.watHea_b)
    annotation (Line(points={{60,42},{60,40},{14,40}}, color={0,127,255}));
  connect(beaCooHea.watHea_a, pum.port_b)
    annotation (Line(points={{-14,40},{-27,40},{-40,40}}, color={0,127,255}));
  connect(sou_3.ports[1], beaCooHea.air_a) annotation (Line(points={{60,0},{20,0},
          {20,34},{14,34}}, color={0,127,255}));
  connect(sin_3.ports[1], beaCooHea.air_b) annotation (Line(points={{-100,2},{-64,
          2},{-20,2},{-20,34},{-14,34}}, color={0,127,255}));
  connect(pum3.port_b, beaCooHea1.watCoo_a) annotation (Line(points={{-40,-40},{
          -32,-40},{-20,-40},{-20,-74},{-14,-74}}, color={0,127,255}));
  connect(beaCooHea1.watHea_a, pum2.port_b) annotation (Line(points={{-14,-80},{
          -27,-80},{-40,-80}}, color={0,127,255}));
  connect(sou_4.ports[1], beaCooHea1.air_a) annotation (Line(points={{60,-120},{
          20,-120},{20,-86},{14,-86}}, color={0,127,255}));
  connect(pum3.port_a, sou_1.ports[2]) annotation (Line(points={{-60,-40},{-70,-40},
          {-70,76},{-100,76}}, color={0,127,255}));
  connect(pum2.port_a, sou_2.ports[2]) annotation (Line(points={{-60,-80},{-80,-80},
          {-80,36},{-100,36}}, color={0,127,255}));
  connect(beaCooHea1.air_b, sin_3.ports[2]) annotation (Line(points={{-14,-86},{
          -20,-86},{-20,-108},{-90,-108},{-90,-2},{-100,-2}}, color={0,127,255}));
  connect(beaCooHea1.watCoo_b, sin_1.ports[2]) annotation (Line(points={{14,-74},
          {28,-74},{28,78},{60,78}}, color={0,127,255}));
  connect(beaCooHea1.watHea_b, sin_2.ports[2]) annotation (Line(points={{14,-80},
          {28,-80},{40,-80},{40,38},{60,38}}, color={0,127,255}));
  connect(step.y, pum1.m_flow_in) annotation (Line(points={{-159,100},{-108,100},
          {-50.2,100},{-50.2,92}}, color={0,0,127}));
  connect(step1.y, pum.m_flow_in) annotation (Line(points={{-159,60},{-110,60},{
          -50.2,60},{-50.2,52}}, color={0,0,127}));
  connect(step3.y, pum3.m_flow_in) annotation (Line(points={{-159,-20},{-104,-20},
          {-50.2,-20},{-50.2,-28}}, color={0,0,127}));
  connect(step2.y, pum2.m_flow_in) annotation (Line(points={{-159,-60},{-104,-60},
          {-50.2,-60},{-50.2,-68}}, color={0,0,127}));
  connect(step4.y, prescribedTemperature.T)
    annotation (Line(points={{-99,-150},{-62,-150}}, color={0,0,127}));
  connect(prescribedTemperature.port, beaCooHea1.heaPor) annotation (Line(
        points={{-40,-150},{-20,-150},{0,-150},{0,-92}}, color={191,0,0}));
  connect(beaCooHea.heaPor, prescribedTemperature.port) annotation (Line(points=
         {{0,28},{0,28},{0,-10},{0,-40},{50,-40},{50,-150},{-40,-150}}, color={191,
          0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -180},{120,120}})),experiment(StopTime=5000),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ActiveBeams/Validation/NumberOfBeams.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
     Documentation(info="<html>
<p>
This model validates the scaling of the heat tranfer and pressure drop for
<code>nBeams &gt; 1</code>.
</p>
<p>
It uses two instances of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.CoolingAndHeating\">
Buildings.Fluid.HeatExchangers.ActiveBeams.CoolingAndHeating</a>,
one with
<code>nBeams = 1</code> and one with
<code>nBeams = 10</code>.
</p>
</html>", revisions="<html>
<ul>
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
end NumberOfBeams;
