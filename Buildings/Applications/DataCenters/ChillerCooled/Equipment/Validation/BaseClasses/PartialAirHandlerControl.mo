within Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation.BaseClasses;
partial model PartialAirHandlerControl
  "Partial model for testing air hanlders with temperature and humidity control"
  package Medium1 = Buildings.Media.Water "Medium model for water";
  package Medium2 = Buildings.Media.Air "Medium model for air";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(min=0) = 2.9
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(min=0) = 3.3
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.Temperature T_a1_nominal=6 + 273.15
    "Nominal water inlet temperature";
  parameter Modelica.Units.SI.Temperature T_b1_nominal=11 + 273.15
    "Nominal water outlet temperature";
  parameter Modelica.Units.SI.Temperature T_a2_nominal=26 + 273.15
    "Nominal air inlet temperature";
  parameter Modelica.Units.SI.Temperature T_b2_nominal=12 + 273.15
    "Nominal air outlet temperature";

  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    nPorts=1,
    use_p_in=false,
    p(displayUnit="Pa"),
    T=303.15)
    "Sink for water"
     annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    X={0.02,1 - 0.02},
    use_T_in=true,
    use_X_in=true,
    p(displayUnit="Pa"))
    "Source for water"
    annotation (Placement(transformation(
          extent={{174,0},{154,20}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    nPorts=1,
    use_p_in=false,
    p=300000,
    T=293.15)
    "Sink for air"
      annotation (Placement(transformation(extent={{174,40},{154,60}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    use_T_in=true,
    p=300000 + 12000,
    nPorts=1)
    "Sink for air"
    annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_2(
    from_dp=true,
    redeclare package Medium = Medium2,
    dp_nominal=100,
    m_flow_nominal=m2_flow_nominal)
    "Flow resistance"
    annotation (Placement(transformation(extent={{-88,0},{-108,20}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_1(
    from_dp=true,
    redeclare package Medium = Medium1,
    dp_nominal=3000,
    m_flow_nominal=m1_flow_nominal)
    "Flow resistance"
    annotation (Placement(transformation(extent={{124,40},{144,60}})));
  Modelica.Blocks.Sources.Constant  TSet(
    k(unit="K")=289.15)
    "Setpoint temperature"
    annotation (Placement(transformation(extent={{-70,80},
            {-50,100}})));
  Modelica.Blocks.Sources.Constant relHum(k=0.8)
    "Relative humidity"
    annotation (Placement(transformation(extent={{134,-80},{154,-60}})));
  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi(use_p_in=false)
    annotation (Placement(transformation(extent={{184,-52},{204,-32}})));
  Modelica.Blocks.Sources.Constant temSou_2(k=T_a2_nominal)
    "Temperature boundary for source 2"
    annotation (Placement(transformation(extent={{134,-48},{154,-28}})));
  Modelica.Blocks.Sources.Step TWat(
    offset=T_a1_nominal,
    height=3,
    startTime=1500)
   "Water temperature"
    annotation (Placement(transformation(extent={{-110,44},{-90,64}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort masFra(
    redeclare package Medium = Medium2, m_flow_nominal=m2_flow_nominal)
    "Sensor for mass fraction"
    annotation (Placement(transformation(extent={{-54,0},{-74,20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSenWat1(
    redeclare package Medium = Medium1, m_flow_nominal=m2_flow_nominal)
    "Temperature sensor for water"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSenAir2(
    redeclare package Medium = Medium2, m_flow_nominal=m2_flow_nominal)
    "Temperature for air"
    annotation (Placement(transformation(extent={{-26,0},{-46,20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSenWat2(
    redeclare package Medium = Medium1, m_flow_nominal=m2_flow_nominal)
    "Temperature for water"
    annotation (Placement(transformation(extent={{96,40},{116,60}})));
equation
  connect(sin_1.ports[1],res_1. port_b) annotation (Line(
      points={{154,50},{144,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_2.ports[1],res_2. port_b) annotation (Line(
      points={{-120,10},{-108,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(x_pTphi.X,sou_2. X_in) annotation (Line(
      points={{205,-42},{212,-42},{212,-44},{220,-44},{220,6},{176,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(relHum.y, x_pTphi.phi) annotation (Line(
      points={{155,-70},{170,-70},{170,-48},{182,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSou_2.y, x_pTphi.T) annotation (Line(
      points={{155,-38},{168,-38},{168,-42},{182,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSou_2.y, sou_2.T_in) annotation (Line(
      points={{155,-38},{168,-38},{168,-10},{194,-10},{194,14},{176,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TWat.y,sou_1. T_in) annotation (Line(
      points={{-89,54},{-72,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masFra.port_b, res_2.port_a)
    annotation (Line(points={{-74,10},{-88,10}}, color={0,127,255}));
  connect(temSenWat1.port_a, sou_1.ports[1])
    annotation (Line(points={{-40,50},{-45,50},{-50,50}}, color={0,127,255}));
  connect(temSenAir2.port_b, masFra.port_a)
    annotation (Line(points={{-46,10},{-50,10},{-54,10}}, color={0,127,255}));
  connect(temSenWat2.port_b, res_1.port_a)
    annotation (Line(points={{116,50},{120,50},{124,50}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -100},{220,120}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{220,
            120}})),
    Documentation(info="<html>
<p>Partial model for testing temperature and humidity control in air handling units.</p>
</html>", revisions="<html>
<ul>
<li>
May 10, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialAirHandlerControl;
