within Buildings.Examples;
model SimpleHouse
  "Illustrative example of a simple heating, ventilation and room model"
  extends Modelica.Icons.Example;

  package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;

  parameter Modelica.Units.SI.Area AWall=100 "Wall area";
  parameter Modelica.Units.SI.Area AWin=5 "Window area";
  parameter Real gWin(min=0, max=1, unit="1") = 0.3 "Solar heat gain coefficient of window";
  parameter Modelica.Units.SI.Volume VZone=AWall*3 "Wall area";
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=700
    "Nominal capacity of heating system";
  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal=QHea_flow_nominal/
      10/4200 "Nominal mass flow rate for water loop";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=VZone*2*1.2/3600
    "Nominal mass flow rate for air loop";

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal=200
    "Pressure drop at nominal mass flow rate for air loop";
  parameter Boolean allowFlowReversal=false
    "= false because flow will not reverse in these circuits";

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor walCap(
    T(fixed=true),
    C=10*AWall*0.05*1000*1000)
    "Thermal mass of walls"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={170,0})));
  Fluid.MixingVolumes.MixingVolume zon(
    redeclare package Medium = MediumAir,
    V=VZone,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mAir_flow_nominal,
    massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    "Very based zone air model"
    annotation (Placement(transformation(extent={{160,50},{180,30}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor conRes(R=1/2/AWall)
    "Thermal resistance for convective heat transfer with h=2" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={110,20})));
  Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumWater,
    T_a_nominal=273.15 + 50,
    T_b_nominal=273.15 + 40,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=allowFlowReversal,
    Q_flow_nominal=QHea_flow_nominal)
                                 "Radiator"
    annotation (Placement(transformation(extent={{120,-140},{140,-120}})));

  Fluid.Sources.Boundary_pT bouAir(
    redeclare package Medium = MediumAir,
    nPorts=2,
    use_T_in=true) "Air boundary with constant temperature" annotation (
      Placement(transformation(extent={{-10,-10},{10,10}}, origin={-110,140})));
  Fluid.Sources.Boundary_pT bouWat(redeclare package Medium = MediumWater,
      nPorts=1) "Pressure bound for water circuit" annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={20,-180})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}}),
        iconTransformation(extent={{-160,-10},{-140,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor walRes(R=0.25/AWall/
        0.04) "Thermal resistor for wall: 25 cm of rockwool"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TOut
    "Exterior temperature boundary condition"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Fluid.HeatExchangers.HeaterCooler_u heaWat(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal,
    dp_nominal=5000,
    Q_flow_nominal=QHea_flow_nominal)
                                 "Heater for water circuit"
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));

  Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = MediumWater,
    use_inputFilter=false,
    m_flow_nominal=mWat_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal,
    nominalValuesDefineDefaultPressureCurve=true,
    inputType=Buildings.Fluid.Types.InputType.Stages,
    massFlowRates=mWat_flow_nominal*{1}) "Pump"
    annotation (Placement(transformation(extent={{140,-190},{120,-170}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemZonAir
    "Zone air temperature sensor"
    annotation (Placement(transformation(extent={{120,170},{100,190}})));
  Fluid.Actuators.Dampers.Exponential vavDam(
    redeclare package Medium = MediumAir,
    from_dp=true,
    m_flow_nominal=mAir_flow_nominal,
    dpDamper_nominal=10,
    dpFixed_nominal=dpAir_nominal - 10) "Damper" annotation (Placement(
        transformation(extent={{-10,10},{10,-10}}, origin={110,130})));

  Fluid.Movers.FlowControlled_dp fan(
    redeclare package Medium = MediumAir,
    dp_nominal=dpAir_nominal,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mAir_flow_nominal,
    show_T=true) "Constant head fan" annotation (Placement(transformation(
          extent={{-10,10},{10,-10}}, origin={-10,130})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow win
    "Very simple window model"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Fluid.HeatExchangers.ConstantEffectiveness hexRec(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumAir,
    dp1_nominal=0,
    dp2_nominal=0,
    m1_flow_nominal=mAir_flow_nominal,
    m2_flow_nominal=mAir_flow_nominal,
    eps=0.85) "Heat exchanger for heat recuperation"
    annotation (Placement(transformation(extent={{-61,124},{-91,156}})));
  Modelica.Blocks.Logical.Hysteresis hysRad(uLow=273.15 + 20, uHigh=273.15 + 22)
    "Hysteresis controller for radiator"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Modelica.Blocks.Logical.Not not1
    "negation for enabling heating when temperatur is low"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Modelica.Blocks.Math.BooleanToReal booToRea "Boolean to real"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Modelica.Blocks.Sources.Constant con_dp(k=dpAir_nominal) "Pressure head"
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));

  Modelica.Blocks.Math.Gain gaiWin(k=AWin*gWin)
    "Gain for window solar transmittance and area as HGloHor is in W/m2"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Modelica.Blocks.Math.BooleanToInteger booToInt "Boolean to integer"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
  Controls.Continuous.LimPID conDam(
      controllerType=Modelica.Blocks.Types.SimpleController.P,
      yMin=0.25) "Controller for damper"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));
  Modelica.Blocks.Sources.Constant TSetRoo(k=273.15 + 24)
    "Room temperature set point for air system"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Fluid.HeatExchangers.SensibleCooler_T cooAir(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=0,
    redeclare package Medium = MediumAir) "Cooling for supply air"
    annotation (Placement(transformation(extent={{48,140},{68,120}})));
  Modelica.Blocks.Sources.Constant TSupAirCoo(k=273.15 + 20)
    "Cooling setpoint for supply air"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TFanInl(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=mAir_flow_nominal,
    tau=0) "Temperature at fan inlet"
    annotation (Placement(transformation(extent={{-50,120},{-30,140}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TFanOut(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=mAir_flow_nominal,
    tau=0) "Temperature at fan outlet"
    annotation (Placement(transformation(extent={{6,120},{26,140}})));
equation
  connect(conRes.port_a, zon.heatPort)
    annotation (Line(points={{110,30},{110,40},{160,40}},   color={191,0,0}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-160,0},{-130,0}},
      color={255,204,51},
      thickness=0.5));
  connect(walRes.port_b, walCap.port) annotation (Line(points={{80,0},{122,0},{122,
          1.77636e-15},{160,1.77636e-15}},
                         color={191,0,0}));
  connect(TOut.T, weaBus.TDryBul)
    annotation (Line(points={{-82,0},{-106,0},{-106,0.05},{-129.95,0.05}},
                                                          color={0,0,127}));
  connect(TOut.port, walRes.port_a)
    annotation (Line(points={{-60,0},{60,0}},     color={191,0,0}));
  connect(heaWat.port_b, rad.port_a) annotation (Line(points={{80,-130},{120,-130}},
                       color={0,127,255}));
  connect(bouWat.ports[1], heaWat.port_a) annotation (Line(points={{30,-180},{42,
          -180},{42,-130},{60,-130}}, color={0,127,255}));
  connect(rad.port_b, pum.port_a) annotation (Line(points={{140,-130},{150,-130},
          {150,-180},{140,-180}},color={0,127,255}));
  connect(senTemZonAir.port, zon.heatPort) annotation (Line(points={{120,180},{160,
          180},{160,40}},                      color={191,0,0}));
  connect(bouAir.ports[1], hexRec.port_b1) annotation (Line(points={{-100,139},{
          -100,162},{-91,162},{-91,149.6}},
                              color={0,127,255}));
  connect(rad.heatPortCon, zon.heatPort) annotation (Line(points={{128,-122.8},{
          128,40},{160,40}},                    color={191,0,0}));
  connect(not1.y, booToRea.u) annotation (Line(points={{-19,-110},{-2,-110}},
                  color={255,0,255}));
  connect(not1.u, hysRad.y) annotation (Line(points={{-42,-110},{-59,-110}},
                  color={255,0,255}));
  connect(booToRea.y, heaWat.u) annotation (Line(points={{21,-110},{40,-110},{40,
          -124},{58,-124}}, color={0,0,127}));
  connect(heaWat.port_a, pum.port_b) annotation (Line(points={{60,-130},{42,-130},
          {42,-180},{120,-180}},          color={0,127,255}));
  connect(con_dp.y, fan.dp_in) annotation (Line(points={{-29,100},{-10,100},{-10,
          118}},           color={0,0,127}));
  connect(gaiWin.y, win.Q_flow) annotation (Line(points={{41,-40},{60,-40}},
                           color={0,0,127}));
  connect(gaiWin.u, weaBus.HGloHor) annotation (Line(points={{18,-40},{-129.95,-40},
          {-129.95,0.05}},       color={0,0,127}));
  connect(booToInt.u, not1.y) annotation (Line(points={{-2,-150},{-11,-150},{-11,
          -110},{-19,-110}}, color={255,0,255}));
  connect(booToInt.y, pum.stage) annotation (Line(points={{21,-150},{130,-150},{
          130,-168}},       color={255,127,0}));
  connect(vavDam.port_b, zon.ports[1])
    annotation (Line(points={{120,130},{140,130},{140,50},{169,50}},
                                                          color={0,127,255}));
  connect(senTemZonAir.T, hysRad.u) annotation (Line(points={{99,180},{-209.25,180},
          {-209.25,-110},{-82,-110}},         color={0,0,127}));
  connect(senTemZonAir.T,conDam. u_s) annotation (Line(points={{99,180},{74,180},
          {74,100},{78,100}},             color={0,0,127}));
  connect(conDam.y, vavDam.y) annotation (Line(points={{101,100},{110,100},{110,
          118}},color={0,0,127}));
  connect(TSetRoo.y,conDam. u_m) annotation (Line(points={{61,100},{70,100},{70,
          82},{90,82},{90,88}},
                         color={0,0,127}));
  connect(cooAir.port_b, vavDam.port_a)
    annotation (Line(points={{68,130},{100,130}},         color={0,127,255}));
  connect(TSupAirCoo.y, cooAir.TSet) annotation (Line(points={{21,100},{34,100},
          {34,122},{46,122}},color={0,0,127}));
  connect(bouAir.T_in, weaBus.TDryBul) annotation (Line(points={{-122,144},{-129.95,
          144},{-129.95,0.05}}, color={0,0,127}));
  connect(bouAir.ports[2], hexRec.port_a2) annotation (Line(points={{-100,141},{
          -100,118},{-91,118},{-91,130.4}},
                                    color={0,127,255}));
  connect(hexRec.port_a1, zon.ports[2]) annotation (Line(points={{-61,149.6},{138,
          149.6},{138,50},{171,50}},
                            color={0,127,255}));
  connect(conRes.port_b, walCap.port) annotation (Line(points={{110,10},{110,0},
          {122,0},{122,1.77636e-15},{160,1.77636e-15}}, color={191,0,0}));
  connect(win.port, walCap.port) annotation (Line(points={{80,-40},{110,-40},{110,
          0},{132,0},{132,1.77636e-15},{160,1.77636e-15}}, color={191,0,0}));
  connect(rad.heatPortRad, walCap.port) annotation (Line(points={{132,-122.8},{132,
          1.77636e-15},{160,1.77636e-15}}, color={191,0,0}));
  connect(hexRec.port_b2, TFanInl.port_a) annotation (Line(points={{-61,130.4},{
          -60,130},{-50,130}}, color={0,127,255}));
  connect(TFanInl.port_b, fan.port_a)
    annotation (Line(points={{-30,130},{-20,130}}, color={0,127,255}));
  connect(fan.port_b, TFanOut.port_a)
    annotation (Line(points={{0,130},{6,130}}, color={0,127,255}));
  connect(TFanOut.port_b, cooAir.port_a)
    annotation (Line(points={{26,130},{48,130}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,
            -220},{220,220}}), graphics={
        Rectangle(
          extent={{-200,200},{200,80}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-200,-80.25},{200,-199.75}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-199.75,60},{-20.25,-60}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-63,182},{-197,198}},
          textColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Cooling and ventilation"),
        Rectangle(
          extent={{0,60},{200,-60}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{64.5,40.5},{-4.5,59.5}},
          textColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Building"),
        Text(
          extent={{-137,-99},{-203,-81}},
          textColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Heating"),
        Text(
          extent={{-141,41},{-199,59}},
          textColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Weather")}),
    experiment(Tolerance=1e-06, StopTime=3.1536e+07),
    Documentation(revisions="<html>
<ul>
<li>
August 5, 2024, by Hongxiang Fu:<br/>
Added two-port temperature sensors to replace <code>sta_?.T</code>
in reference results. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1913\">IBPSA #1913</a>.
</li>
<li>
September 15, 2023, by Jelger Jansen:<br/>
Move the example model to <a href=\"modelica://Buildings.Examples\">Buildings.Examples</a>, 
update the information section, and revise lay-out.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1791\">IBPSA, #1791</a>.
</li>
<li>
June 15, 2022, by Hongxiang Fu:<br/>
Changed <code>conDam.yMin</code> from 0.1 to 0.25.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1624\">IBPSA, #1624</a>.
</li>
<li>
May 8, 2017, by Michael Wetter:<br/>
Updated heater model.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">IBPSA, #763</a>.
</li>
<li>
November 10, 2016, by Michael Wetter:<br/>
Connected supply air temperature to outdoor air temperature,
added cooling to supply air,
changed capacity of heating system, switched heating pump off when heater is off,
and added proportional controller for the air damper.<br/>
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/584\">IBPSA, #584</a>.
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
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/429\">IBPSA, #429</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">IBPSA, #404</a>.
</li>
<li>
September 19, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model contains a simple model of a house
with a heating system, ventilation, and weather boundary conditions.
It serves as a demonstration case of how the <code>Buildings</code> library can be used.
</p>
<p>
A step-by-step tutorial on how to build up this model can be found in
<a href=\"modelica://Buildings.Examples.Tutorial.SimpleHouse\">
Buildings.Examples.Tutorial.SimpleHouse</a>.
There are however some minor differences between this model and the models in the tutorial:
</p>
<ul>
<li>
Different numerical values are used for almost all model parameters.
</li>
<li>
The solar irradiation (in <i>W/m<sup>2</sup></i>) is calculated as
the global horizontal irradiation multiplied with a solar heat gain coefficient
instead of the direct normal irradiation.
</li>
<li>
The ventilation system is equiped with a cooler that sets the temperature
of the air flow entering the zone equal to a constant value of <i>20°C</i>.
</li>
<li>
The damper in the ventilation system is operated by
a proportional-controller instead of a hysteresis controller.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/SimpleHouse.mos"
        "Simulate and plot"));
end SimpleHouse;
