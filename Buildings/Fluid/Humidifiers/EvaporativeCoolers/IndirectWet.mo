within Buildings.Fluid.Humidifiers.EvaporativeCoolers;
model IndirectWet "Indirect wet evaporative cooler"
  extends Buildings.Fluid.Interfaces.PartialFourPortParallel(
    redeclare final package Medium1=MediumPri,
    redeclare final package Medium2=MediumSec);

  replaceable package MediumPri =
    Modelica.Media.Interfaces.PartialMedium
    "Medium 1 in the component"
    annotation (choices(
      choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
      choice(redeclare package Medium = Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
          Buildings.Media.Antifreeze.PropyleneGlycolWater (
        property_T=293.15,
        X_a=0.40)
        "Propylene glycol water, 40% mass fraction")));

  replaceable package MediumSec =
    Modelica.Media.Interfaces.PartialMedium
    "Medium 2 in the component"
    annotation (choices(
      choice(redeclare package Medium = Buildings.Media.Air "Moist air")));

  parameter Modelica.Units.SI.PressureDifference dp_nominal=10
    "Pressure drop at nominal mass flow rate";

  parameter Modelica.Units.SI.MassFlowRate mPri_flow_nominal
    "Primary nominal mass flow rate";

  parameter Modelica.Units.SI.MassFlowRate mSec_flow_nominal
    "Secondary nominal mass flow rate";

  parameter Real maxEff(
    displayUnit="1")
    "Maximum efficiency of heat exchanger coil";

  parameter Real floRat(
    displayUnit="1")
    "Coil flow ratio";

  parameter Modelica.Units.SI.Time tau=30
    "Time constant at nominal flow rate (if energyDynamics <> SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));

  Sensors.TemperatureTwoPort senTemDryPri(
    redeclare final package Medium = MediumPri,
    m_flow_nominal=mPri_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=298.15)
    "Primary air dry bulb temperature sensor"
    annotation (Placement(visible=true, transformation(
      origin={-80,20},
      extent={{-10,-10},{10,10}})));

  Sensors.TemperatureWetBulbTwoPort senTemWetPri(
    redeclare final package Medium = MediumPri,
    m_flow_nominal=mPri_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    TWetBul_start=296.15)
    "Primary air wet bulb temperature sensor"
    annotation (Placement(visible=true, transformation(
      origin={-50,20},
      extent={{-10,-10},{10,10}})));

  Sensors.VolumeFlowRate senVolFloPri(
    redeclare final package Medium=MediumPri,
    m_flow_nominal=mPri_flow_nominal)
    "Primary air volume flow rate sensor"
    annotation (Placement(visible=true, transformation(
      origin={-20,20},
      extent={{-10,-10},{10,10}})));

  FixedResistances.PressureDrop resPri(
    redeclare final package Medium = MediumPri,
    dp_nominal=dp_nominal,
    m_flow_nominal=mPri_flow_nominal)
    "Primary air pressure drop"
    annotation (Placement(visible=true, transformation(
      origin={30,20},
      extent={{-10,-10},{10,10}})));

  MixingVolumes.MixingVolumeMoistAir volPri(
    redeclare package Medium = MediumPri,
    m_flow_nominal=mPri_flow_nominal,
    V=mPri_flow_nominal*tau/rho_default,
    nPorts=2)
    "Moist air mixing volume for primary air"
    annotation (Placement(visible=true,
      transformation(origin={80,40},
      extent={{-10,-10},{10,10}})));

  Baseclasses.IndirectWetCalculations indWetCal(maxEff=maxEff, floRat=floRat)
    annotation (Placement(transformation(extent={{16,56},{40,80}})));

  Sensors.TemperatureTwoPort senTemDrySec(
    redeclare final package Medium = MediumSec,
    m_flow_nominal=mSec_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=298.15) "Secondary air dry bulb temperature sensor" annotation (
      Placement(visible=true, transformation(
        origin={-70,-60},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  Sensors.TemperatureWetBulbTwoPort senTemWetSec(
    redeclare final package Medium = MediumSec,
    m_flow_nominal=mSec_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    TWetBul_start=296.15) "Secondary air wet bulb temperature sensor"
    annotation (Placement(visible=true, transformation(
        origin={-40,-60},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  FixedResistances.PressureDrop resSec(
    redeclare package Medium = MediumSec,
    dp_nominal=10,
    m_flow_nominal=mSec_flow_nominal) "Secondary air pressure drop" annotation (
     Placement(visible=true, transformation(
        origin={40,-60},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  Sensors.VolumeFlowRate senVolFloSec(redeclare final package Medium =
        MediumSec, m_flow_nominal=mSec_flow_nominal)
    "Secondary air volume flow rate sensor" annotation (Placement(visible=true,
        transformation(
        origin={0,-60},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  HeatTransfer.Sources.PrescribedTemperature preTem
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

protected
  parameter MediumPri.ThermodynamicState sta_default=MediumPri.setState_pTX(
    T=MediumPri.T_default, p=MediumPri.p_default, X=MediumPri.X_default)
    "Default state of medium";

  parameter Modelica.Units.SI.Density rho_default=MediumPri.density(sta_default)
    "Density, used to compute fluid volume";

equation
  connect(senTemDryPri.port_b, senTemWetPri.port_a)
    annotation (Line(points={{-70,20},{-60,20}}, color={0,127,255}));
  connect(senTemWetPri.port_b, senVolFloPri.port_a)
    annotation (Line(points={{-40,20},{-30,20}}));
  connect(resPri.port_b, volPri.ports[1])
    annotation (Line(points={{40,20},{78,20},{78,30}}, color={0,127,255}));
  connect(senVolFloPri.port_b, resPri.port_a)
    annotation (Line(points={{-10,20},{20,20}},
                                              color={0,127,255}));
  connect(port_a1, senTemDryPri.port_a) annotation (Line(points={{-100,60},{-96,
          60},{-96,20},{-90,20}}, color={0,127,255}));
  connect(volPri.ports[2], port_b1) annotation (Line(points={{82,30},{84,30},{84,
          20},{100,20},{100,60}}, color={0,127,255}));
  connect(senTemDryPri.T, indWetCal.TDryBulPriIn)
    annotation (Line(points={{-80,31},{-80,78},{14,78}}, color={0,0,127}));
  connect(senTemWetPri.T, indWetCal.TWetBulPriIn)
    annotation (Line(points={{-50,31},{-50,74},{14,74}}, color={0,0,127}));
  connect(senTemDrySec.T, indWetCal.TDryBulSecIn)
    annotation (Line(points={{-70,-49},{-70,70},{14,70}}, color={0,0,127}));
  connect(senTemWetSec.T, indWetCal.TWetBulSecIn)
    annotation (Line(points={{-40,-49},{-40,66},{14,66}}, color={0,0,127}));
  connect(senVolFloPri.V_flow, indWetCal.VPri_flow)
    annotation (Line(points={{-20,31},{-20,62},{14,62}}, color={0,0,127}));
  connect(port_a2, senTemDrySec.port_a)
    annotation (Line(points={{-100,-60},{-80,-60}}, color={0,127,255}));
  connect(senTemDrySec.port_b, senTemWetSec.port_a)
    annotation (Line(points={{-60,-60},{-50,-60}}, color={0,127,255}));
  connect(resSec.port_b, port_b2)
    annotation (Line(points={{50,-60},{100,-60}}, color={0,127,255}));
  connect(senTemWetSec.port_b, senVolFloSec.port_a)
    annotation (Line(points={{-30,-60},{-10,-60}}, color={0,127,255}));
  connect(senVolFloSec.port_b, resSec.port_a)
    annotation (Line(points={{10,-60},{30,-60}}, color={0,127,255}));
  connect(senVolFloSec.V_flow, indWetCal.VSec_flow)
    annotation (Line(points={{0,-49},{0,58},{14,58}}, color={0,0,127}));
  connect(indWetCal.TDryBulPriOut, preTem.T) annotation (Line(points={{42,68},{
          50,68},{50,70},{58,70}}, color={0,0,127}));
  connect(preTem.port, volPri.heatPort) annotation (Line(points={{80,70},{90,70},
          {90,56},{60,56},{60,40},{70,40}}, color={191,0,0}));
  annotation (
    Documentation, Icon(graphics={
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
