within Buildings.Fluid.Humidifiers.EvaporativeCoolers;
model IndirectWet "Indirect wet evaporative cooler"
  extends Buildings.Fluid.Interfaces.PartialFourPortParallel;

  replaceable package Medium1 = Modelica.Media.Interfaces.PartialMedium
    "Medium to be cooled"
    annotation (choices(
      choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
      choice(redeclare package Medium = Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (
        property_T=293.15,
        X_a=0.40) "Propylene glycol water, 40% mass fraction")));

  replaceable package Medium2 = Modelica.Media.Interfaces.PartialMedium
    "Secondary Air stream to which heat is rejected to outdoor air"
    annotation (choices(
      choice(redeclare package Medium = Buildings.Media.Air "Moist air")));

  parameter Modelica.Units.SI.PressureDifference dp1_nominal
    "Pressure drop at nominal mass flow rate of medium being cooled";

  parameter Modelica.Units.SI.PressureDifference dp2_nominal
    "Pressure drop at nominal mass flow rate of medium rejected to outdoor air";

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal
    "Cooled air nominal mass flow rate";

  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal
    "Rejected air nominal mass flow rate";

  parameter Real maxEff(
    unit="1")
    "Maximum efficiency of heat exchanger coil";

  parameter Real floRat(
    unit="1")
    "Coil flow ratio of actual to maximum heat transfer";

  parameter Modelica.Units.SI.Time tau=30
    "Time constant at nominal flow rate (if energyDynamics <> SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTemDryPri(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final T_start=298.15)
    "Primary fluid dry bulb temperature sensor"
    annotation (Placement(transformation(origin={-80,20}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort senTemWetPri(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final TWetBul_start=296.15)
    "Primary fluid wet bulb temperature sensor"
    annotation (Placement(transformation(origin={-50,20}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFloPri(
    redeclare final package Medium=Medium1,
    final m_flow_nominal=m1_flow_nominal)
    "Primary fluid volume flow rate sensor"
    annotation (Placement(transformation(origin={-10,20}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.FixedResistances.PressureDrop resPri(
    redeclare final package Medium = Medium1,
    final dp_nominal=dp1_nominal,
    final m_flow_nominal=m1_flow_nominal)
    "Primary fluid pressure drop"
    annotation (Placement(transformation(origin={30,20}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.MixingVolumes.MixingVolume volPri(
    redeclare package Medium = Medium1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=m1_flow_nominal,
    final V=m1_flow_nominal*tau/rhoPri_default,
    nPorts=2)
    "Mixing volume for primary fluid"
    annotation (Placement(transformation(origin={80,40}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.IndirectWetCalculations indWetCal(
    final maxEff=maxEff,
    final floRat=floRat)
    "Indirect wet evaporative cooling calculations"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTemDrySec(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final T_start=298.15)
    "Secondary air dry bulb temperature sensor"
    annotation (Placement(transformation(origin={-64,-60},extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort senTemWetSec(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final TWetBul_start=296.15)
    "Secondary air wet bulb temperature sensor"
    annotation (Placement(transformation(origin={-30,-60},extent={{-10,-10},{10,10}})));

  Buildings.Fluid.FixedResistances.PressureDrop resSec(
    redeclare package Medium = Medium2,
    final dp_nominal=dp2_nominal,
    final m_flow_nominal=m2_flow_nominal)
    "Secondary air pressure drop"
    annotation (Placement(transformation(origin={40,-60}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFloSec(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal)
    "Secondary air volume flow rate sensor"
    annotation (Placement(transformation(origin={10,-60}, extent={{-10,-10},{10,10}})));

  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem
    "Boundary condition enforcing calculated outlet air drybulb temperature"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

protected
  parameter Medium1.ThermodynamicState staPri_default=Medium1.setState_pTX(
    T=Medium1.T_default, p=Medium1.p_default, X=Medium1.X_default)
    "Default state of medium";

  parameter Modelica.Units.SI.Density rhoPri_default=Medium1.density(staPri_default)
    "Density, used to compute fluid volume";

  parameter Medium1.ThermodynamicState staReject_default=Medium2.setState_pTX(
    T=Medium2.T_default, p=Medium2.p_default, X=Medium2.X_default)
    "Default state of medium";

  parameter Modelica.Units.SI.Density rhoReject_default=Medium1.density(staReject_default)
    "Density, used to compute fluid volume";

equation
  connect(senTemDryPri.port_b, senTemWetPri.port_a)
    annotation (Line(points={{-70,20},{-60,20}}, color={0,127,255}));
  connect(senTemWetPri.port_b, senVolFloPri.port_a)
    annotation (Line(points={{-40,20},{-20,20}}));
  connect(senVolFloPri.port_b, resPri.port_a)
    annotation (Line(points={{0,20},{20,20}},   color={0,127,255}));
  connect(port_a1, senTemDryPri.port_a) annotation (Line(points={{-100,60},{-94,
          60},{-94,20},{-90,20}}, color={0,127,255}));
  connect(senTemDryPri.T, indWetCal.TDryBulPriIn)
    annotation (Line(points={{-80,31},{-80,78.3333},{18.3333,78.3333}},
                                                         color={0,0,127}));
  connect(senTemWetPri.T, indWetCal.TWetBulPriIn)
    annotation (Line(points={{-50,31},{-50,75},{18.3333,75}},
                                                         color={0,0,127}));
  connect(senTemDrySec.T, indWetCal.TDryBulSecIn)
    annotation (Line(points={{-64,-49},{-64,71.6667},{18.3333,71.6667}},
                                                          color={0,0,127}));
  connect(senTemWetSec.T, indWetCal.TWetBulSecIn)
    annotation (Line(points={{-30,-49},{-30,68.3333},{18.3333,68.3333}},
                                                          color={0,0,127}));
  connect(senVolFloPri.V_flow, indWetCal.VPri_flow)
    annotation (Line(points={{-10,31},{-10,65},{18.3333,65}},
                                                         color={0,0,127}));
  connect(port_a2, senTemDrySec.port_a)
    annotation (Line(points={{-100,-60},{-74,-60}}, color={0,127,255}));
  connect(senTemDrySec.port_b, senTemWetSec.port_a)
    annotation (Line(points={{-54,-60},{-40,-60}}, color={0,127,255}));
  connect(senTemWetSec.port_b, senVolFloSec.port_a)
    annotation (Line(points={{-20,-60},{0,-60}},   color={0,127,255}));
  connect(senVolFloSec.port_b, resSec.port_a)
    annotation (Line(points={{20,-60},{30,-60}}, color={0,127,255}));
  connect(senVolFloSec.V_flow, indWetCal.VSec_flow)
    annotation (Line(points={{10,-49},{10,61.6667},{18.3333,61.6667}},
                                                        color={0,0,127}));
  connect(indWetCal.TDryBulPriOut, preTem.T) annotation (Line(points={{41.6667,
          70},{58,70}},            color={0,0,127}));
  connect(preTem.port, volPri.heatPort) annotation (Line(points={{80,70},{90,70},
          {90,56},{60,56},{60,40},{70,40}}, color={191,0,0}));
  connect(resSec.port_b, port_b2)
    annotation (Line(points={{50,-60},{100,-60}}, color={0,127,255}));
  connect(resPri.port_b, volPri.ports[1])
    annotation (Line(points={{40,20},{79,20},{79,30}}, color={0,127,255}));
  connect(volPri.ports[2], port_b1) annotation (Line(points={{81,30},{82,30},{82,
          20},{98,20},{98,60},{100,60}}, color={0,127,255}));

annotation (defaultComponentName = "indWetEva",
Documentation(info="<html>
<p>
Model for a indirect dry evaporative cooler.
</p>
<p>This model consists of the following components:
</p>
<ul>
<li>
Drybulb temperature sensor 
(<a href=\"modelica://Buildings.Fluid.Sensors.TemperatureTwoPort\">
Buildings.Fluid.Sensors.TemperatureTwoPort</a>), wetbulb temperature sensor 
(<a href=\"modelica://Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort\">
Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort</a>) and volume flowrate sensor 
(<a href=\"modelica://Buildings.Fluid.Sensors.VolumeFlowRate\">
Buildings.Fluid.Sensors.VolumeFlowRate</a>) for the primary and secondary fluid 
inlet.
</li>
<li>
Indirect wet evaporative cooling calculations for calculating primary outlet drybulb 
temperature (<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.IndirectWetCalculations\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.IndirectWetCalculations</a>).
</li>
<li>
Prescribed temperature block (<a href=\"modelica://Buildings.HeatTransfer.Sources.PrescribedTemperature\">
Buildings.HeatTransfer.Sources.PrescribedTemperature</a>) and mixing volume 
(<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>) for enforcing calculated outlet 
air temperature.
</li>
</ul>
<p>
Note: The model works correctly only when the ports a1 and a2 are used as inlet ports, 
and ports b1 and b2 are used as outlet ports, for the primary and secondary flow 
respectively. Also, the secondary air outlet conditions are currently not validated, 
and it is recommended that it be vented to an object acting as a sink, and without
connecting any downstream components to it.
</p>
</html>", revisions="<html>
<ul>
<li>
September 29, 2023 by Karthikeya Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
  Rectangle(lineColor = {0, 0, 255}, fillColor = {95, 95, 95}, pattern = LinePattern.None,
            fillPattern = FillPattern.Solid, extent={{-70,60},{70,-60}}),
  Text(textColor = {0, 0, 127}, extent={{-52,-60},{58,-120}}, textString = "m=%m_flow_nominal"),
  Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern = FillPattern.Solid, extent={{-102,65},{98,56}}),
  Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
          fillPattern = FillPattern.Solid,
          points={{42,42},{54,34},{54,34},{42,28},{42,30},{50,34},{50,34},{42,40},{42,42}}),
  Rectangle(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern = FillPattern.Solid, extent={{58,-54},{54,52}}),
  Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
          fillPattern = FillPattern.Solid,
          points={{42,10},{54,2},{54,2},{42,-4},{42,-2},{50,2},{50,2},{42,8},{42,10}}),
  Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
          fillPattern = FillPattern.Solid,
          points={{42,-26},{54,-34},{54,-34},{42,-40},{42,-38},{50,-34},{50,-34},{42,-28},{42,-26}}),
  Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern = FillPattern.Solid, extent={{-100,-55},{100,-64}}),
  Rectangle(lineColor = {0, 0, 255}, fillColor = {0, 62, 0}, pattern = LinePattern.None,
            fillPattern = FillPattern.Solid, extent={{ -70,68},{70,-66}})}));
end IndirectWet;
