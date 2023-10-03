within Buildings.Fluid.Humidifiers.EvaporativeCoolers;
model IndirectWet "Indirect wet evaporative cooler"
  extends Buildings.Fluid.Interfaces.PartialFourPortParallel(
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=MediumRejected);

  replaceable package Medium1 = Modelica.Media.Interfaces.PartialMedium
    "Medium to be cooled"
    annotation (choices(
      choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
      choice(redeclare package Medium = Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (
        property_T=293.15,
        X_a=0.40) "Propylene glycol water, 40% mass fraction")));

  replaceable package MediumRejected = Modelica.Media.Interfaces.PartialMedium
    "Secondary Air stream to which heat is rejected to outdoor air"
    annotation (choices(
      choice(redeclare package Medium = Buildings.Media.Air "Moist air")));

  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Pressure drop at nominal mass flow rate";

  parameter Modelica.Units.SI.MassFlowRate mCool_flow_nominal
    "Cooled air nominal mass flow rate";

  parameter Modelica.Units.SI.MassFlowRate mReject_flow_nominal
    "Rejected air nominal mass flow rate";

  parameter Real maxEff(
    displayUnit="1")
    "Maximum efficiency of heat exchanger coil";

  parameter Real floRat(
    displayUnit="1")
    "Coil flow ratio";

  parameter Modelica.Units.SI.Time tau=30
    "Time constant at nominal flow rate (if energyDynamics <> SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTemDryCool(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=mCool_flow_nominal,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final T_start=298.15) "Primary fluid dry bulb temperature sensor"
    annotation (Placement(visible=true, transformation(
      origin={-80,20},
      extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort senTemWetCool(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=mCool_flow_nominal,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final TWetBul_start=296.15)
    "Primary fluid wet bulb temperature sensor"
    annotation (Placement(visible=true, transformation(
      origin={-50,20},
      extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFloCool(
    redeclare final package Medium=Medium1,
    final m_flow_nominal=mCool_flow_nominal)
    "Primary fluid volume flow rate sensor"
    annotation (Placement(visible=true, transformation(
      origin={-20,20},
      extent={{-10,-10},{10,10}})));

  Buildings.Fluid.FixedResistances.PressureDrop resCool(
    redeclare final package Medium = Medium1,
    final dp_nominal=dp_nominal,
    final m_flow_nominal=mCool_flow_nominal)
    "Primary fluid pressure drop"
    annotation (Placement(visible=true, transformation(
      origin={30,20},
      extent={{-10,-10},{10,10}})));

  Buildings.Fluid.MixingVolumes.MixingVolume volCool(
    redeclare package Medium = Medium1,
    final m_flow_nominal=mCool_flow_nominal,
    final V=mCool_flow_nominal*tau/rhoCool_default,
    nPorts=2)       
    "Mixing volume for primary fluid"
    annotation (Placement(visible=true,
      transformation(origin={80,40},
      extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.IndirectWetCalculations indWetCal(
    final maxEff=maxEff,
    final floRat=floRat)
    "Indirect wet evaporative cooling calculations"
    annotation (Placement(transformation(extent={{16,56},{40,80}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTemDryRej(
    redeclare final package Medium = MediumRejected,
    final m_flow_nominal=mReject_flow_nominal,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final T_start=298.15)
    "Secondary air dry bulb temperature sensor"
    annotation (Placement(visible=true, transformation(
      origin={-70,-60},
      extent={{-10,-10},{10,10}},
      rotation=0)));

  Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort senTemWetRej(
    redeclare final package Medium = MediumRejected,
    final m_flow_nominal=mReject_flow_nominal,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final TWetBul_start=296.15)
    "Secondary air wet bulb temperature sensor"
    annotation (Placement(visible=true, transformation(
      origin={-40,-60},
      extent={{-10,-10},{10,10}},
      rotation=0)));

  Buildings.Fluid.FixedResistances.PressureDrop resRej(
    redeclare package Medium = MediumRejected,
    final dp_nominal=10,
    final m_flow_nominal=mReject_flow_nominal)
    "Secondary air pressure drop"
    annotation (Placement(visible=true, transformation(
      origin={40,-60},
      extent={{-10,-10},{10,10}},
      rotation=0)));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFloRej(
    redeclare final package Medium = MediumRejected,
    final m_flow_nominal=mReject_flow_nominal)
    "Secondary air volume flow rate sensor"
    annotation (Placement(visible=true,
      transformation(
      origin={0,-60},
      extent={{-10,-10},{10,10}},
      rotation=0)));

  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem
    "Boundary condition enforcing calculated outlet air drybulb temperature"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

protected
  parameter Medium1.ThermodynamicState staCool_default=Medium1.setState_pTX(
    T=Medium1.T_default, p=Medium1.p_default, X=Medium1.X_default)
    "Default state of medium";

  parameter Modelica.Units.SI.Density rhoCool_default=Medium1.density(staCool_default)
    "Density, used to compute fluid volume";

  parameter Medium1.ThermodynamicState staReject_default=MediumRejected.setState_pTX(
    T=MediumRejected.T_default, p=MediumRejected.p_default, X=MediumRejected.X_default)
    "Default state of medium";

  parameter Modelica.Units.SI.Density rhoReject_default=Medium1.density(staReject_default)
    "Density, used to compute fluid volume";

equation
  connect(senTemDryCool.port_b, senTemWetCool.port_a)
    annotation (Line(points={{-70,20},{-60,20}}, color={0,127,255}));
  connect(senTemWetCool.port_b, senVolFloCool.port_a)
    annotation (Line(points={{-40,20},{-30,20}}));
  connect(senVolFloCool.port_b, resCool.port_a)
    annotation (Line(points={{-10,20},{20,20}},
                                              color={0,127,255}));
  connect(port_a1, senTemDryCool.port_a) annotation (Line(points={{-100,60},{-96,
          60},{-96,20},{-90,20}}, color={0,127,255}));
  connect(senTemDryCool.T, indWetCal.TDryBulPriIn)
    annotation (Line(points={{-80,31},{-80,78},{14,78}}, color={0,0,127}));
  connect(senTemWetCool.T, indWetCal.TWetBulPriIn)
    annotation (Line(points={{-50,31},{-50,74},{14,74}}, color={0,0,127}));
  connect(senTemDryRej.T, indWetCal.TDryBulSecIn)
    annotation (Line(points={{-70,-49},{-70,70},{14,70}}, color={0,0,127}));
  connect(senTemWetRej.T, indWetCal.TWetBulSecIn)
    annotation (Line(points={{-40,-49},{-40,66},{14,66}}, color={0,0,127}));
  connect(senVolFloCool.V_flow, indWetCal.VPri_flow)
    annotation (Line(points={{-20,31},{-20,62},{14,62}}, color={0,0,127}));
  connect(port_a2, senTemDryRej.port_a)
    annotation (Line(points={{-100,-60},{-80,-60}}, color={0,127,255}));
  connect(senTemDryRej.port_b, senTemWetRej.port_a)
    annotation (Line(points={{-60,-60},{-50,-60}}, color={0,127,255}));
  connect(senTemWetRej.port_b, senVolFloRej.port_a)
    annotation (Line(points={{-30,-60},{-10,-60}}, color={0,127,255}));
  connect(senVolFloRej.port_b, resRej.port_a)
    annotation (Line(points={{10,-60},{30,-60}}, color={0,127,255}));
  connect(senVolFloRej.V_flow, indWetCal.VSec_flow)
    annotation (Line(points={{0,-49},{0,58},{14,58}}, color={0,0,127}));
  connect(indWetCal.TDryBulPriOut, preTem.T) annotation (Line(points={{42,68},{
          50,68},{50,70},{58,70}}, color={0,0,127}));
  connect(preTem.port, volCool.heatPort) annotation (Line(points={{80,70},{90,70},
          {90,56},{60,56},{60,40},{70,40}}, color={191,0,0}));
  connect(resRej.port_b, port_b2)
    annotation (Line(points={{50,-60},{100,-60}}, color={0,127,255}));
  connect(resCool.port_b, volCool.ports[1])
    annotation (Line(points={{40,20},{78,20},{78,30}}, color={0,127,255}));
  connect(volCool.ports[2], port_b1) annotation (Line(points={{82,30},{82,30},{82,
          20},{98,20},{98,60},{100,60}}, color={0,127,255}));
  annotation (defaultComponentName = "indWetEva",
    Documentation(info="<html>
<p>Model for a indirect dry evaporative cooler.</p>
<p>This model consists of the following components:
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
</p>
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
</html>"), Icon(graphics={
                     Rectangle(lineColor = {0, 0, 255}, fillColor = {95, 95, 95}, pattern = LinePattern.None,
            fillPattern =                                                                                                   FillPattern.Solid, extent={{
              -70,60},{70,-60}}),                                                                                                                                                                                                        Text(textColor = {0, 0, 127}, extent={{
              -52,-60},{58,-120}},                                                                                                                                                                                                        textString = "m=%m_flow_nominal"), Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent={{
              -102,65},{98,56}}),                                                                                                                                                                                                        Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, points={{
              42,42},{54,34},{54,34},{42,28},{42,30},{50,34},{50,34},{42,40},{42,
              42}}),                                                                                                                                                                                                        Rectangle(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent={{
              58,-54},{54,52}}),                                                                                                                                                                                                        Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, points={{
              42,10},{54,2},{54,2},{42,-4},{42,-2},{50,2},{50,2},{42,8},{42,10}}),                                                                                                                                                                                                        Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, points={{
              42,-26},{54,-34},{54,-34},{42,-40},{42,-38},{50,-34},{50,-34},{42,
              -28},{42,-26}}),                                                                                                                                                                                                        Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent={{
              -100,-55},{100,-64}}),                                                                                                                                                                                                        Rectangle(lineColor = {0, 0, 255}, fillColor = {0, 62, 0}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent={{
              -70,68},{70,-66}})}));
end IndirectWet;
