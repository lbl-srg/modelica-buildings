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
  parameter Modelica.SIunits.HeatFlowRate QHea_nominal = 700
    "Nominal capacity of heating system";
  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal=QHea_nominal/10/4200
    "Nominal mass flow rate for water loop";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal=V_zone*2*1.2/3600
    "Nominal mass flow rate for air loop";

  parameter Modelica.SIunits.PressureDifference dpAir_nominal=200
    "Pressure drop at nominal mass flow rate for air loop";
  parameter Boolean allowFlowReversal=false
    "= false because flow will not reverse in these circuits";

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor walCap(
                    T(fixed=true), C=10*A_wall*0.05*1000*1000)
                                   "Thermal mass of walls"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={142,-8})));
  MixingVolumes.MixingVolume zone(
    redeclare package Medium = MediumAir,
    V=V_zone,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mAir_flow_nominal,
    massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    "Very based zone air model"
    annotation (Placement(transformation(extent={{102,140},{82,160}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor convRes(R=1/2/A_wall)
    "Thermal resistance for convective heat transfer with h=2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={132,22})));
  HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumWater,
    T_a_nominal=273.15 + 50,
    T_b_nominal=273.15 + 40,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=allowFlowReversal,
    Q_flow_nominal=QHea_nominal)                  "Radiator"
    annotation (Placement(transformation(extent={{104,-116},{124,-96}})));

  Sources.Boundary_pT bouAir(redeclare package Medium = MediumAir, nPorts=2,
    use_T_in=true) "Air boundary with constant temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-112,140})));
  Sources.Boundary_pT bouWat(redeclare package Medium = MediumWater, nPorts=1)
    "Pressure bound for water circuit" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-8,-170})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-200,-18},{-180,2}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-162,-18},{-142,2}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor wallRes(R=0.25/
        A_wall/0.04) "Thermal resistor for wall: 25 cm of rockwool"
    annotation (Placement(transformation(extent={{66,-10},{86,10}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature Tout
    "Exterior temperature boundary condition"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  HeatExchangers.HeaterCooler_u heaWat(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal,
    dp_nominal=5000,
    Q_flow_nominal=QHea_nominal) "Heater for water circuit"
    annotation (Placement(transformation(extent={{44,-116},{64,-96}})));

  Movers.FlowControlled_m_flow pump(
    redeclare package Medium = MediumWater,
    use_inputFilter=false,
    m_flow_nominal=mWat_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal,
    nominalValuesDefineDefaultPressureCurve=true,
    inputType=Buildings.Fluid.Types.InputType.Stages,
    massFlowRates=mWat_flow_nominal*{1}) "Pump"
    annotation (Placement(transformation(extent={{80,-180},{60,-160}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemZonAir
    "Zone air temperature sensor"
    annotation (Placement(transformation(extent={{80,170},{60,190}})));
  Actuators.Dampers.VAVBoxExponential vavDam(
    redeclare package Medium = MediumAir,
    dp_nominal=dpAir_nominal,
    from_dp=true,
    m_flow_nominal=mAir_flow_nominal) "Damper" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        origin={72,120})));

  Movers.FlowControlled_dp fan(
    redeclare package Medium = MediumAir,
    dp_nominal=dpAir_nominal,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mAir_flow_nominal,
    show_T=true) "Constant head fan" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-22,120})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow window
    "Very simple window model"
    annotation (Placement(transformation(extent={{-20,-36},{0,-16}})));
  HeatExchangers.ConstantEffectiveness hexRec(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumAir,
    dp1_nominal=0,
    dp2_nominal=0,
    m1_flow_nominal=mAir_flow_nominal,
    m2_flow_nominal=mAir_flow_nominal,
    eps=0.85)      "Heat exchanger for heat recuperation"
    annotation (Placement(transformation(extent={{-54,114},{-84,146}})));
  Modelica.Blocks.Logical.Hysteresis hysRad(uLow=273.15 + 20, uHigh=273.15 + 22)
    "Hysteresis controller for radiator"
    annotation (Placement(transformation(extent={{-74,-110},{-54,-90}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Boolean to real"
    annotation (Placement(transformation(extent={{-16,-110},{4,-90}})));
  Modelica.Blocks.Logical.Not not1
    "negation for enabling heating when temperatur is low"
    annotation (Placement(transformation(extent={{-46,-110},{-26,-90}})));
  Modelica.Blocks.Sources.Constant const_dp(k=dpAir_nominal) "Pressure head"
    annotation (Placement(transformation(extent={{-52,150},{-32,170}})));

  Modelica.Blocks.Math.Gain gaiWin(k=A_win*g_win)
    "Gain for window solar transmittance and area as HGloHor is in W/m2"
    annotation (Placement(transformation(extent={{-60,-36},{-40,-16}})));
  Modelica.Blocks.Math.BooleanToInteger booleanToInt "Boolean to integer"
    annotation (Placement(transformation(extent={{-16,-144},{4,-124}})));
  Controls.Continuous.LimPID conDam(controllerType=Modelica.Blocks.Types.SimpleController.P,
      yMin=0.1) "Controller for damper"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Modelica.Blocks.Sources.Constant TSetRoo(k=273.15 + 24)
    "Room temperature set point for air system"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  HeatExchangers.SensibleCooler_T cooAir(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=0,
    redeclare package Medium = MediumAir) "Cooling for supply air"
    annotation (Placement(transformation(extent={{30,110},{50,130}})));
  Modelica.Blocks.Sources.Constant TSupAirCoo(k=273.15 + 20)
    "Cooling setpoint for supply air"
    annotation (Placement(transformation(extent={{-12,150},{8,170}})));
equation
  connect(convRes.port_b, walCap.port)
    annotation (Line(points={{132,12},{132,12},{132,-8}},    color={191,0,0}));
  connect(convRes.port_a, zone.heatPort) annotation (Line(points={{132,32},{132,
          150},{102,150}},           color={191,0,0}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-180,-8},{-180,-8},{-152,-8}},
      color={255,204,51},
      thickness=0.5));
  connect(wallRes.port_b, walCap.port) annotation (Line(points={{86,0},{132,0},{
          132,-6},{132,-8}},    color={191,0,0}));
  connect(Tout.T, weaBus.TDryBul)
    annotation (Line(points={{-22,0},{-152,0},{-152,-8}}, color={0,0,127}));
  connect(Tout.port, wallRes.port_a)
    annotation (Line(points={{0,0},{0,0},{66,0}},    color={191,0,0}));
  connect(heaWat.port_b, rad.port_a) annotation (Line(points={{64,-106},{84,-106},
          {104,-106}}, color={0,127,255}));
  connect(bouWat.ports[1], heaWat.port_a) annotation (Line(points={{2,-170},{40,
          -170},{40,-106},{44,-106}}, color={0,127,255}));
  connect(rad.port_b, pump.port_a) annotation (Line(points={{124,-106},{130,-106},
          {130,-170},{80,-170}}, color={0,127,255}));
  connect(senTemZonAir.port, zone.heatPort) annotation (Line(points={{80,180},{80,
          180},{112,180},{112,150},{102,150}},
                                     color={191,0,0}));
  connect(window.port, walCap.port) annotation (Line(points={{0,-26},{132,-26},{
          132,-12},{132,-8}},
                         color={191,0,0}));
  connect(bouAir.ports[1], hexRec.port_b1) annotation (Line(points={{-102,142},{
          -102,139.6},{-84,139.6}},
                              color={0,127,255}));
  connect(hexRec.port_a1, zone.ports[1]) annotation (Line(points={{-54,139.6},{85,
          139.6},{85,140},{94,140}},      color={0,127,255}));
  connect(rad.heatPortCon, zone.heatPort) annotation (Line(points={{112,-98.8},{
          112,-98.8},{112,48},{112,150},{102,150}},   color={191,0,0}));
  connect(rad.heatPortRad, walCap.port) annotation (Line(points={{116,-98.8},{116,
          -98.8},{116,-70},{116,-26},{132,-26},{132,-8}},
                                                   color={191,0,0}));
  connect(not1.y, booleanToReal1.u) annotation (Line(points={{-25,-100},{-22,-100},
          {-18,-100}}, color={255,0,255}));
  connect(not1.u, hysRad.y) annotation (Line(points={{-48,-100},{-52,-100},{-53,
          -100}}, color={255,0,255}));
  connect(booleanToReal1.y, heaWat.u) annotation (Line(points={{5,-100},{16,-100},
          {26,-100},{42,-100}}, color={0,0,127}));
  connect(heaWat.port_a, pump.port_b) annotation (Line(points={{44,-106},{40,-106},
          {40,-112},{40,-170},{60,-170}}, color={0,127,255}));
  connect(const_dp.y, fan.dp_in) annotation (Line(points={{-31,160},{-22,160},{-22,
          132},{-22.2,132}},                         color={0,0,127}));
  connect(gaiWin.y, window.Q_flow) annotation (Line(points={{-39,-26},{-34,-26},
          {-30,-26},{-20,-26}}, color={0,0,127}));
  connect(gaiWin.u, weaBus.HGloHor) annotation (Line(points={{-62,-26},{-90,-26},
          {-152,-26},{-152,-8}}, color={0,0,127}));
  connect(booleanToInt.u, not1.y) annotation (Line(points={{-18,-134},{-22,-134},
          {-22,-100},{-25,-100}}, color={255,0,255}));
  connect(booleanToInt.y, pump.stage) annotation (Line(points={{5,-134},{32,-134},
          {70,-134},{70,-158}}, color={255,127,0}));
  connect(bouAir.ports[2], hexRec.port_a2) annotation (Line(points={{-102,138},{
          -102,142},{-90,142},{-90,120.4},{-84,120.4}}, color={0,127,255}));
  connect(hexRec.port_b2, fan.port_a) annotation (Line(points={{-54,120.4},{-44,
          120.4},{-44,120},{-32,120}}, color={0,127,255}));
  connect(vavDam.port_b, zone.ports[2])
    annotation (Line(points={{82,120},{90,120},{90,140}}, color={0,127,255}));
  connect(senTemZonAir.T, hysRad.u) annotation (Line(points={{60,180},{60,180},{
          -132,180},{-132,-100},{-76,-100}},  color={0,0,127}));
  connect(senTemZonAir.T,conDam. u_s) annotation (Line(points={{60,180},{60,180},
          {-132,180},{-132,90},{-62,90},{-22,90}},
                                          color={0,0,127}));
  connect(conDam.y, vavDam.y) annotation (Line(points={{1,90},{26,90},{72,90},{72,
          108}},color={0,0,127}));
  connect(TSetRoo.y,conDam. u_m) annotation (Line(points={{-39,70},{-40,70},{-36,
          70},{-40,70},{-10,70},{-10,78}},
                         color={0,0,127}));
  connect(fan.port_b, cooAir.port_a)
    annotation (Line(points={{-12,120},{30,120}}, color={0,127,255}));
  connect(cooAir.port_b, vavDam.port_a)
    annotation (Line(points={{50,120},{50,120},{62,120}}, color={0,127,255}));
  connect(TSupAirCoo.y, cooAir.TSet) annotation (Line(points={{9,160},{20,160},{
          20,128},{28,128}}, color={0,0,127}));
  connect(bouAir.T_in, weaBus.TDryBul) annotation (Line(points={{-124,144},{
          -152,144},{-152,-8}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -220},{200,220}}), graphics={
        Rectangle(
          extent={{-222,200},{180,50}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-220,-60},{180,-200}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-220,40},{20,-48}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-78,182},{-212,198}},
          lineColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Cooling and ventilation"),
        Rectangle(
          extent={{40,40},{180,-46}},
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
          extent={{-154,20},{-212,38}},
          lineColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Weather")}),
    experiment(Tolerance=1e-06, StopTime=3.1536e+07),
    Documentation(revisions="<html>
<ul>
<li>
May 8, 2017, by Michael Wetter:<br/>
Updated heater model.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">
Buildings, #763</a>.
</li>
<li>
November 10, 2016, by Michael Wetter:<br/>
Connected supply air temperature to outdoor air temperature,
added cooling to supply air,
changed capacity of heating system, switched heating pump off when heater is off,
and added proportional controller for the air damper.<br/>
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/584\">#584</a>.
</li>
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
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/429\">#429</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
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
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Examples/SimpleHouse.mos"
        "Simulate and plot"));
end SimpleHouse;
