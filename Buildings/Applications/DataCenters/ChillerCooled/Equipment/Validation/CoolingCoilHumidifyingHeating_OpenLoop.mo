within Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation;
model CoolingCoilHumidifyingHeating_OpenLoop
  "Model of a air handling unit that tests variable mass flow rates"
  extends Modelica.Icons.Example;
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation.BaseClasses.PartialAirHandlerMassFlow(
      sou_2(nPorts=1), relHum(k=0.5));
  parameter Modelica.SIunits.ThermalConductance UA_nominal=m2_flow_nominal*1006*(12-26)/
     Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1_nominal,
        T_b1_nominal,
        T_a2_nominal,
        T_b2_nominal)
    "Thermal conductance at nominal flow for sensible heat, used to compute time constant";
  parameter Real yValMin = 0.4 "Minimum position of water-side valves";

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.CoolingCoilHumidifyingHeating ahu(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    yValve_start=0,
    tauEleHea=1,
    tauHum=1,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    UA_nominal=UA_nominal,
    dpValve_nominal=6000,
    QHeaMax_flow=10000,
    mWatMax_flow=0.01,
    perFan(pressure(V_flow=m2_flow_nominal*{0,0.5,1}, dp=300*{1.2,1.12,1})),
    dp1_nominal=3000,
    dp2_nominal=200,
    yValSwi=yValMin+0.05)
    "Air handling unit"
    annotation (Placement(transformation(extent={{54,16},{74,36}})));

  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(
    redeclare package Medium = Medium2, m_flow_nominal=m2_flow_nominal)
    "Sensor for relative humidity"
    annotation (Placement(transformation(extent={{34,10},{14,30}})));
  Modelica.Blocks.Sources.Constant uVal(k=0.2)
    "Control signal for water valve"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Modelica.Blocks.Sources.Constant temSet(k=15 + 273.15)
    "Temperature setpoint "
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Modelica.Blocks.Sources.Constant XSet(k=0.01) "Mass fraction set point"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Modelica.Blocks.Sources.Constant uFan(k=1) "Control input for fan"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
equation
  connect(ahu.port_a2, sou_2.ports[1]) annotation (Line(
      points={{74,20},{120,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ahu.port_b2, senRelHum.port_a) annotation (Line(
      points={{54,20},{34,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(uVal.y, ahu.uVal) annotation (Line(points={{21,90},{46,90},{46,30},
          {53,30}}, color={0,0,127}));
  connect(uFan.y, ahu.uFan) annotation (Line(points={{21,-80},{48,-80},{48,22},{
          48,23},{53,23},{53,22}},
                   color={0,0,127}));
  connect(temSet.y, ahu.TSet) annotation (Line(points={{21,-20},{40,-20},{40,25},
          {53,25}}, color={0,0,127}));
  connect(XSet.y, ahu.XSet_w) annotation (Line(points={{21,-50},{44,-50},{44,28},
          {53,28},{53,27}},                               color={0,0,127}));
  connect(temSenAir2.port_a, senRelHum.port_b)
    annotation (Line(points={{0,20},{14,20}}, color={0,127,255}));
  connect(temSenWat1.port_b, ahu.port_a1) annotation (Line(points={{0,60},{20,
          60},{40,60},{40,32},{54,32}}, color={0,127,255}));
  connect(temSenWat2.port_a, ahu.port_b1) annotation (Line(points={{88,60},{80,
          60},{80,32},{74,32}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{200,200}})),
experiment(Tolerance=1E-6, StopTime=1000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Equipment/Validation/CoolingCoilHumidifyingHeating_OpenLoop.mos"
        "Simulate and PLot"),
Documentation(info="<html>
<p>
This model demonstrates the use of
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Equipment.CoolingCoilHumidifyingHeating\">
Buildings.Applications.DataCenters.ChillerCooled.Equipment.CoolingCoilHumidifyingHeating</a>
for different inlet conditions.
</p>
</html>", revisions="<html>
<ul>
<li>
April 11, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingCoilHumidifyingHeating_OpenLoop;
