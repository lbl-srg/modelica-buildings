within Buildings.Fluid.Examples;
model SimpleHouse
  "Illustrative example of a simple heating, ventilation and room model"
  extends Modelica.Icons.Example;

  package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;

  parameter Modelica.SIunits.Area A_wall = 100 "Wall area";
  parameter Modelica.SIunits.Area A_win = 5 "Window area";
  parameter Real g_win(min=0, max=1, unit="1") = 0.3 "Solar heat gain coefficient of window";
  parameter Modelica.SIunits.Volume V_zone = A_wall*3 "Wall area";
  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal=3*rad.m_flow_nominal
    "Nominal mass flow rate for water loop";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal=V_zone*5*1.2/3600
    "Nominal mass flow rate for air loop";

  parameter Modelica.SIunits.PressureDifference dpAir_nominal=200
    "Pressure drop at nominal mass flow rate for air loop";
  parameter Boolean allowFlowReversal=false
    "= false because flow will not reverse in these circuits";

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor walCap(C=10*A_wall*0.1
        *1000*1000, T(fixed=true)) "Thermal mass of walls"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={142,-8})));
  MixingVolumes.MixingVolume zone(
    redeclare package Medium = MediumAir,
    V=V_zone,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mAir_flow_nominal)
    "Very based zone air model"
    annotation (Placement(transformation(extent={{102,120},{82,140}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor convRes(R=1/2/A_wall)
    "Thermal resistance for convective heat transfer with h=2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={132,22})));
  HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumWater,
    Q_flow_nominal=3000,
    T_a_nominal=273.15 + 70,
    T_b_nominal=273.15 + 50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=allowFlowReversal) "Radiator"
    annotation (Placement(transformation(extent={{104,-116},{124,-96}})));

  Sources.Boundary_pT bouAir(redeclare package Medium = MediumAir, nPorts=2,
    T=273.15 + 10) "Air boundary with constant temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,120})));
  Sources.Boundary_pT bouWat(redeclare package Medium = MediumWater, nPorts=1)
    "Pressure bound for water circuit" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-52,-170})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data reader"
    annotation (Placement(transformation(extent={{-200,-18},{-180,2}})));
  BoundaryConditions.WeatherData.Bus weaBus1 "Weather data bus"
    annotation (Placement(transformation(extent={{-130,-18},{-110,2}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor wallRes(R=0.25/
        A_wall/0.04) "Thermal resistor for wall: 25 cm of rockwool"
    annotation (Placement(transformation(extent={{66,-10},{86,10}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature Tout
    "Exterior temperature boundary condition"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dp_nominal=1000,
    Q_flow_nominal=5000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{44,-116},{64,-96}})));

  Movers.FlowControlled_m_flow pump2(
    redeclare package Medium = MediumWater,
    filteredSpeed=false,
    m_flow_nominal=mWat_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal,
    nominalValuesDefineDefaultPressureCurve=true)
    annotation (Placement(transformation(extent={{80,-180},{60,-160}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemZonAir
    "Zone air temperature sensor"
    annotation (Placement(transformation(extent={{32,150},{12,170}})));
  Actuators.Dampers.VAVBoxExponential vavDam(
    redeclare package Medium = MediumAir,
    dp_nominal=dpAir_nominal,
    from_dp=true,
    m_flow_nominal=mAir_flow_nominal) "Damper" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={0,100})));

  Movers.FlowControlled_dp fan2(
    redeclare package Medium = MediumAir,
    dp_nominal=dpAir_nominal,
    filteredSpeed=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mAir_flow_nominal) "Constant head fan" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,100})));
  Modelica.Blocks.Logical.Hysteresis hysAir(uLow=273.15 + 22, uHigh=273.15 + 24)
    "Hysteresis controller for ventilation"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal(realTrue=0, realFalse=1)
    "Boolean to real"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow window
    "Very simple window model"
    annotation (Placement(transformation(extent={{-20,-36},{0,-16}})));
  HeatExchangers.ConstantEffectiveness hexRec(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumAir,
    eps=0.85,
    dp1_nominal=0,
    dp2_nominal=0,
    m1_flow_nominal=mAir_flow_nominal,
    m2_flow_nominal=mAir_flow_nominal)
                   "Heat exchanger for heat recuperation"
    annotation (Placement(transformation(extent={{78,94},{48,126}})));
  Modelica.Blocks.Logical.Hysteresis hysRad(uLow=273.15 + 20, uHigh=273.15 + 22)
    "Hysteresis controller for radiator"
    annotation (Placement(transformation(extent={{-74,-110},{-54,-90}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Boolean to real"
    annotation (Placement(transformation(extent={{-16,-110},{4,-90}})));
  Modelica.Blocks.Logical.Not not1
    "negation for enabling heating when temperatur is low"
    annotation (Placement(transformation(extent={{-46,-110},{-26,-90}})));
  Modelica.Blocks.Sources.Constant const_m_flow(k=mWat_flow_nominal)
    "Constant mass flow rate"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
  Modelica.Blocks.Sources.Constant const_dp(k=200) "Pressure head"
    annotation (Placement(transformation(extent={{-22,130},{-2,150}})));

  Modelica.Blocks.Math.Gain gaiWin(k=A_win*g_win)
    "Gain for window solar transmittance and area as HGloHor is in W/m2"
    annotation (Placement(transformation(extent={{-60,-36},{-40,-16}})));
equation
  connect(convRes.port_b, walCap.port)
    annotation (Line(points={{132,12},{132,12},{132,-8}},    color={191,0,0}));
  connect(convRes.port_a, zone.heatPort) annotation (Line(points={{132,32},{132,
          130},{102,130}},           color={191,0,0}));
  connect(weaDat.weaBus, weaBus1) annotation (Line(
      points={{-180,-8},{-180,-8},{-120,-8}},
      color={255,204,51},
      thickness=0.5));
  connect(wallRes.port_b, walCap.port) annotation (Line(points={{86,0},{132,0},{
          132,-6},{132,-8}},    color={191,0,0}));
  connect(Tout.T, weaBus1.TDryBul)
    annotation (Line(points={{-22,0},{-120,0},{-120,-8}},   color={0,0,127}));
  connect(Tout.port, wallRes.port_a)
    annotation (Line(points={{0,0},{0,0},{66,0}},    color={191,0,0}));
  connect(hea.port_b, rad.port_a) annotation (Line(points={{64,-106},{84,-106},{
          104,-106}}, color={0,127,255}));
  connect(bouWat.ports[1], hea.port_a) annotation (Line(points={{-42,-170},{40,-170},
          {40,-106},{44,-106},{44,-106}},
                      color={0,127,255}));
  connect(rad.port_b, pump2.port_a) annotation (Line(points={{124,-106},{130,-106},
          {130,-170},{80,-170}}, color={0,127,255}));
  connect(senTemZonAir.port, zone.heatPort) annotation (Line(points={{32,160},{32,
          160},{112,160},{112,130},{104,130},{102,130}},
                                     color={191,0,0}));
  connect(vavDam.port_b, fan2.port_a)
    annotation (Line(points={{10,100},{10,100},{20,100}}, color={0,127,255}));
  connect(vavDam.port_a, bouAir.ports[2]) annotation (Line(points={{-10,100},{-10,
          100},{-20,100},{-20,118},{-28,118},{-40,118}},
                               color={0,127,255}));
  connect(hysAir.y, booleanToReal.u)
    annotation (Line(points={{-59,80},{-59,80},{-52,80}}, color={255,0,255}));
  connect(booleanToReal.y, vavDam.y)
    annotation (Line(points={{-29,80},{0,80},{0,88}}, color={0,0,127}));
  connect(window.port, walCap.port) annotation (Line(points={{0,-26},{132,-26},{
          132,-12},{132,-8}},
                         color={191,0,0}));
  connect(bouAir.ports[1], hexRec.port_b1) annotation (Line(points={{-40,122},{
          -40,119.6},{48,119.6}},
                              color={0,127,255}));
  connect(hexRec.port_a1, zone.ports[1]) annotation (Line(points={{78,119.6},{85,
          119.6},{85,120},{94,120}},      color={0,127,255}));
  connect(fan2.port_b, hexRec.port_a2) annotation (Line(points={{40,100},{44,100},
          {44,100.4},{48,100.4}}, color={0,127,255}));
  connect(hexRec.port_b2, zone.ports[2]) annotation (Line(points={{78,100.4},{90,
          100.4},{90,120}}, color={0,127,255}));
  connect(rad.heatPortCon, zone.heatPort) annotation (Line(points={{112,-98.8},{
          112,-98.8},{112,48},{112,130},{102,130}},   color={191,0,0}));
  connect(rad.heatPortRad, walCap.port) annotation (Line(points={{116,-98.8},{116,
          -98.8},{116,-70},{116,-26},{132,-26},{132,-8}},
                                                   color={191,0,0}));
  connect(hysAir.u, senTemZonAir.T) annotation (Line(points={{-82,80},{-90,80},{
          -90,160},{12,160}}, color={0,0,127}));
  connect(hysRad.u, hysAir.u) annotation (Line(points={{-76,-100},{-90,-100},{-90,
          80},{-82,80}}, color={0,0,127}));
  connect(not1.y, booleanToReal1.u) annotation (Line(points={{-25,-100},{-22,-100},
          {-18,-100}}, color={255,0,255}));
  connect(not1.u, hysRad.y) annotation (Line(points={{-48,-100},{-52,-100},{-53,
          -100}}, color={255,0,255}));
  connect(booleanToReal1.y, hea.u)
    annotation (Line(points={{5,-100},{16,-100},{26,-100},{42,-100}},
                                                            color={0,0,127}));
  connect(hea.port_a, pump2.port_b) annotation (Line(points={{44,-106},{40,-106},
          {40,-112},{40,-170},{60,-170}},           color={0,127,255}));
  connect(const_m_flow.y, pump2.m_flow_in) annotation (Line(points={{21,-150},{70.2,
          -150},{70.2,-158}}, color={0,0,127}));
  connect(const_dp.y, fan2.dp_in) annotation (Line(points={{-1,140},{29.8,140},{
          29.8,112}}, color={0,0,127}));
  connect(gaiWin.y, window.Q_flow) annotation (Line(points={{-39,-26},{-34,-26},
          {-30,-26},{-20,-26}}, color={0,0,127}));
  connect(gaiWin.u, weaBus1.HGloHor) annotation (Line(points={{-62,-26},{-90,-26},
          {-120,-26},{-120,-8}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -220},{200,200}}), graphics={
        Rectangle(
          extent={{-220,40},{20,-40}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-220,-60},{180,-200}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-220,180},{180,60}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-144,154},{-210,172}},
          lineColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Ventilation"),
        Rectangle(
          extent={{40,40},{180,-40}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{98,20},{32,38}},
          lineColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Wall"),
        Text(
          extent={{-148,-86},{-214,-68}},
          lineColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Heating"),
        Text(
          extent={{-118,18},{-214,40}},
          lineColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Weather inputs")}),
    experiment(StopTime=1e+06),
    Documentation(revisions="<html>
<ul>
<li>
September 9, 2016, by Michael Wetter:<br/>
Corrected error in window model, as the solar heat gain was
not multiplied with the window area. Dymola 2017 reported this
error due to mismatching units of <code>W/m2</code> and <code>W</code>.
</li>
<li>
June 23, 2016, by Michael Wetter:<br/>
Changed graphical annotation.
</li>
<li>
March 11, 2016, by Michael Wetter:<br/>
Corrected wrong limits for <code>hysAir</code> so that
<code>uLow &lt; uHigh</code>.
This is
for <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/429\">#429</a>.
</li>
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
</p>
<p>
This model was demonstrated at the joint Annex 60 and
IBPSA-NVL meeting in Leuven on 18 September 2015.
</p>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Examples/SimpleHouse.mos"
        "Simulate and plot"));
end SimpleHouse;
