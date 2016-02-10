within Buildings.Fluid.Examples;
model SimpleHouse
  "Illustrative example of a simple heating, ventilation and room model"
  extends Modelica.Icons.Example;

  package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;

  parameter Modelica.SIunits.Area A_wall = 100 "Wall area";
  parameter Modelica.SIunits.Volume V_zone = A_wall*3 "Wall area";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=3*rad.m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp_nominal=200
    "Pressure drop at nominal mass flow rate";
  parameter Boolean allowFlowReversal=false
    "= false because flow will not reverse in these circuits";

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor walCap(C=10*A_wall*0.1
        *1000*1000, T(fixed=true)) "Thermal mass of walls"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={142,20})));
  MixingVolumes.MixingVolume zone(
    redeclare package Medium = MediumAir,
    V=V_zone,
    nPorts=2,
    m_flow_nominal=0.01,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Very based zone air model"
    annotation (Placement(transformation(extent={{102,120},{82,140}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor convRes(R=1/2/A_wall)
    "Thermal resistance for convective heat transfer with h=2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={132,50})));
  HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumWater,
    Q_flow_nominal=3000,
    T_a_nominal=273.15 + 70,
    T_b_nominal=273.15 + 50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=allowFlowReversal) "Radiator"
    annotation (Placement(transformation(extent={{104,-96},{124,-76}})));

  Sources.Boundary_pT bouAir(redeclare package Medium = MediumAir, nPorts=2,
    T=273.15 + 10) "Air boundary with constant temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,120})));
  Sources.Boundary_pT bouWat(redeclare package Medium = MediumWater, nPorts=1)
    "Pressure bound for water circuit" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={44,-54})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data reader"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  BoundaryConditions.WeatherData.Bus weaBus1 "Weather data bus"
    annotation (Placement(transformation(extent={{-130,10},{-110,30}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor wallRes(R=0.25/
        A_wall/0.04) "Thermal resistor for wall: 25 cm of rockwool"
    annotation (Placement(transformation(extent={{66,20},{86,40}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature Tout
    "Exterior temperature boundary condition"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = MediumWater,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    Q_flow_nominal=5000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{44,-96},{64,-76}})));

  Movers.FlowControlled_m_flow                 pump2(
    redeclare package Medium = MediumWater,
    filteredSpeed=false,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{80,-158},{60,-138}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemZonAir
    "Zone air temperature sensor"
    annotation (Placement(transformation(extent={{32,150},{12,170}})));
  Actuators.Dampers.VAVBoxExponential vavDam(
    redeclare package Medium = MediumAir,
    m_flow_nominal=0.01,
    dp_nominal=dp_nominal,
    from_dp=true) "Damper" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={0,100})));

  Movers.FlowControlled_dp                 fan2(
    redeclare package Medium = MediumAir,
    m_flow_nominal=0.01,
    dp_nominal=dp_nominal,
    filteredSpeed=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Constant head fan"  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,100})));
  Modelica.Blocks.Logical.Hysteresis hysAir(uLow=273.15 + 24, uHigh=273.15 + 22)
    "Hysteresis controller for ventilation"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal "Boolean to real"
    annotation (Placement(transformation(extent={{-50,80},{-30,100}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow window
    "Very simple window model"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  HeatExchangers.ConstantEffectiveness hexRec(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumAir,
    m1_flow_nominal=0.01,
    m2_flow_nominal=0.01,
    eps=0.85,
    dp1_nominal=0,
    dp2_nominal=0) "Heat exchanger for heat recuperation"
    annotation (Placement(transformation(extent={{78,94},{48,126}})));
  Modelica.Blocks.Logical.Hysteresis hysRad(uLow=273.15 + 20, uHigh=273.15 + 22)
    "Hysteresis controller for radiator"
    annotation (Placement(transformation(extent={{-74,-84},{-54,-64}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Boolean to real"
    annotation (Placement(transformation(extent={{-16,-84},{4,-64}})));
  Modelica.Blocks.Logical.Not not1
    "negation for enabling heating when temperatur is low"
    annotation (Placement(transformation(extent={{-46,-84},{-26,-64}})));
  Modelica.Blocks.Sources.Constant const_m_flow(k=m_flow_nominal)
    "Constant mass flow rate"
    annotation (Placement(transformation(extent={{-4,-134},{16,-114}})));
  Modelica.Blocks.Sources.Constant const_dp(k=200) "Pressure head"
    annotation (Placement(transformation(extent={{-22,130},{-2,150}})));

equation
  connect(convRes.port_b, walCap.port)
    annotation (Line(points={{132,40},{132,40},{132,20}},    color={191,0,0}));
  connect(convRes.port_a, zone.heatPort) annotation (Line(points={{132,60},{132,
          130},{102,130}},           color={191,0,0}));
  connect(weaDat.weaBus, weaBus1) annotation (Line(
      points={{-180,20},{-180,20},{-120,20}},
      color={255,204,51},
      thickness=0.5));
  connect(wallRes.port_b, walCap.port) annotation (Line(points={{86,30},{132,30},
          {132,22},{132,22},{132,22},{132,22},{132,20},{132,20}},
                                color={191,0,0}));
  connect(Tout.T, weaBus1.TDryBul)
    annotation (Line(points={{-22,30},{-120,30},{-120,20}}, color={0,0,127}));
  connect(Tout.port, wallRes.port_a)
    annotation (Line(points={{0,30},{0,30},{66,30}}, color={191,0,0}));
  connect(hea.port_b, rad.port_a) annotation (Line(points={{64,-86},{84,-86},{104,
          -86}},      color={0,127,255}));
  connect(bouWat.ports[1], hea.port_a) annotation (Line(points={{44,-64},{44,
          -64},{44,-86}},
                      color={0,127,255}));
  connect(rad.port_b, pump2.port_a) annotation (Line(points={{124,-86},{144,-86},
          {144,-148},{80,-148}}, color={0,127,255}));
  connect(senTemZonAir.port, zone.heatPort) annotation (Line(points={{32,160},{32,
          160},{112,160},{112,130},{104,130},{102,130}},
                                     color={191,0,0}));
  connect(vavDam.port_b, fan2.port_a)
    annotation (Line(points={{10,100},{10,100},{20,100}}, color={0,127,255}));
  connect(vavDam.port_a, bouAir.ports[2]) annotation (Line(points={{-10,100},{
          -10,100},{-20,100},{-20,118},{-28,118},{-28,118},{-40,118}},
                               color={0,127,255}));
  connect(hysAir.y, booleanToReal.u)
    annotation (Line(points={{-59,90},{-59,90},{-52,90}}, color={255,0,255}));
  connect(booleanToReal.y, vavDam.y)
    annotation (Line(points={{-29,90},{0,90},{0,88}}, color={0,0,127}));
  connect(window.port, walCap.port) annotation (Line(points={{0,0},{132,0},{132,
          16},{132,20}}, color={191,0,0}));
  connect(window.Q_flow, weaBus1.HGloHor)
    annotation (Line(points={{-20,0},{-120,0},{-120,20}}, color={0,0,127}));
  connect(bouAir.ports[1], hexRec.port_b1) annotation (Line(points={{-40,122},{
          -40,119.6},{48,119.6}},
                              color={0,127,255}));
  connect(hexRec.port_a1, zone.ports[1]) annotation (Line(points={{78,119.6},{85,
          119.6},{85,120},{94,120}},      color={0,127,255}));
  connect(fan2.port_b, hexRec.port_a2) annotation (Line(points={{40,100},{44,100},
          {44,100.4},{48,100.4}}, color={0,127,255}));
  connect(hexRec.port_b2, zone.ports[2]) annotation (Line(points={{78,100.4},{90,
          100.4},{90,120}}, color={0,127,255}));
  connect(rad.heatPortCon, zone.heatPort) annotation (Line(points={{112,-78.8},{
          112,-78.8},{112,96},{112,130},{102,130}},   color={191,0,0}));
  connect(rad.heatPortRad, walCap.port) annotation (Line(points={{116,-78.8},{
          118,-78.8},{118,-20},{118,-20},{118,0},{132,0},{132,20}},
                                                   color={191,0,0}));
  connect(hysAir.u, senTemZonAir.T) annotation (Line(points={{-82,90},{-90,90},{
          -90,160},{12,160}}, color={0,0,127}));
  connect(hysRad.u, hysAir.u) annotation (Line(points={{-76,-74},{-90,-74},{-90,
          90},{-82,90}}, color={0,0,127}));
  connect(not1.y, booleanToReal1.u) annotation (Line(points={{-25,-74},{-22,-74},
          {-18,-74}},  color={255,0,255}));
  connect(not1.u, hysRad.y) annotation (Line(points={{-48,-74},{-52,-74},{-53,-74}},
                  color={255,0,255}));
  connect(booleanToReal1.y, hea.u)
    annotation (Line(points={{5,-74},{42,-74},{42,-80}},    color={0,0,127}));
  connect(hea.port_a, pump2.port_b) annotation (Line(points={{44,-86},{28,-86},{
          28,-88},{28,-140},{28,-148},{60,-148}},   color={0,127,255}));
  connect(const_m_flow.y, pump2.m_flow_in) annotation (Line(points={{17,-124},{70.2,
          -124},{70.2,-136}}, color={0,0,127}));
  connect(const_dp.y, fan2.dp_in) annotation (Line(points={{-1,140},{29.8,140},{
          29.8,112}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -220},{200,200}}), graphics={
        Rectangle(
          extent={{-222,68},{28,-22}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-220,-40},{176,-168}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-220,180},{160,78}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-144,154},{-210,172}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Ventilation"),
        Rectangle(
          extent={{48,68},{162,-22}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{106,48},{40,66}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Wall"),
        Text(
          extent={{-148,-66},{-214,-48}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Heating"),
        Text(
          extent={{-118,42},{-214,64}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Weather inputs")}),
    experiment(StopTime=1e+06),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/404\">#404</a>.
</li>
<li>
September 19, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model contains a simple model of a house
with a heating system, ventilation and weather boundary conditions.
It servers as a demonstration case of how the <code>Buildings</code> library can be used.
This model was demonstrated at the joint Annex 60 meeting in Leuven on 18 September 2015.
</p>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Examples/SimpleHouse.mos"
        "Simulate and plot"));
end SimpleHouse;
