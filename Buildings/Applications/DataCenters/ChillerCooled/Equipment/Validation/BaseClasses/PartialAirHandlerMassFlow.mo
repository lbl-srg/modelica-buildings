within Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation.BaseClasses;
partial model PartialAirHandlerMassFlow
  "Partial model for testing air handler at variable mass flowrate"

  package Medium1 = Buildings.Media.Water "Medium model for water";
  package Medium2 = Buildings.Media.Air "Medium model for air";
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal(min=0)=2.9
    "Nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal(min=0)=3.3
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Temperature T_a1_nominal=6 + 273.15
    "Nominal water inlet temperature";
  parameter Modelica.SIunits.Temperature T_b1_nominal=11 + 273.15
    "Nominal water outlet temperature";
  parameter Modelica.SIunits.Temperature T_a2_nominal=26 + 273.15
    "Nominal air inlet temperature";
  parameter Modelica.SIunits.Temperature T_b2_nominal=12 + 273.15
    "Nominal air outlet temperature";

  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    T=T_a2_nominal,
    nPorts=1)
    "Sink for air"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    T=T_a2_nominal,
    X={0.02,1 - 0.02},
    use_T_in=true,
    use_X_in=true)
    "Source for air"
    annotation (Placement(transformation(
          extent={{140,10},{120,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T sin_1(
    redeclare package Medium = Medium1,
    T=T_a1_nominal,
    use_m_flow_in=true,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{150,50},{130,70}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    use_T_in=false,
    T=T_a1_nominal,
    nPorts=1)
    "Sink for water"
    annotation (Placement(transformation(extent={{-62,50},{-42,70}})));
  Modelica.Blocks.Sources.Constant relHum(k=0.8) "Relative humidity"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi(use_p_in=false)
    annotation (Placement(transformation(extent={{150,-42},{170,-22}})));
  Modelica.Blocks.Sources.Constant temSou_2(k=T_a2_nominal)
    "Temperature boundary condition"
    annotation (Placement(transformation(extent={{100,-38},{120,-18}})));
  Modelica.Blocks.Math.Gain mWat_flow(k=-m1_flow_nominal)
    "Water mass flow rate"
    annotation (Placement(transformation(extent={{-42,100},{-22,120}})));
  Modelica.Blocks.Sources.TimeTable mWatGai(
    table=[0,1; 3600*0.1,1; 3600*0.2,0.1; 3600*0.3,0.1])
    "Gain for water mass flow rate"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSenWat1(
    redeclare package Medium = Medium1,
    m_flow_nominal=m2_flow_nominal)
    "Temperature sensor for water"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSenWat2(
    redeclare package Medium = Medium1,
    m_flow_nominal=m2_flow_nominal)
    "Temperature sensor for water"
    annotation (Placement(transformation(extent={{88,50},{108,70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSenAir2(
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal)
    "Temperature for air"
    annotation (Placement(transformation(extent={{0,10},{-20,30}})));
equation
  connect(x_pTphi.X, sou_2.X_in) annotation (Line(
      points={{171,-32},{178,-32},{178,-34},{186,-34},{186,16},{142,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(relHum.y, x_pTphi.phi) annotation (Line(
      points={{121,-60},{136,-60},{136,-38},{148,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSou_2.y, x_pTphi.T) annotation (Line(
      points={{121,-28},{134,-28},{134,-32},{148,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSou_2.y, sou_2.T_in) annotation (Line(
      points={{121,-28},{134,-28},{134,0},{160,0},{160,24},{142,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWatGai.y, mWat_flow.u) annotation (Line(
      points={{-59,110},{-44,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWat_flow.y, sin_1.m_flow_in) annotation (Line(
      points={{-21,110},{160,110},{160,68},{150,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSenWat1.port_a, sou_1.ports[1])
    annotation (Line(points={{-20,60},{-42,60}}, color={0,127,255}));
  connect(temSenAir2.port_b, sin_2.ports[1])
    annotation (Line(points={{-20,20},{-30,20},{-40,20}}, color={0,127,255}));
  connect(temSenWat2.port_b, sin_1.ports[1])
    annotation (Line(points={{108,60},{119,60},{130,60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -100},{200,180}})),
            Diagram(coordinateSystem(preserveAspectRatio=false,
             extent={{-120,-100},{200,180}})),
    Documentation(revisions="<html>
<ul>
<li>
May 10, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Partial model for testing the air handling unit model with given control signals.</p>
</html>"));
end PartialAirHandlerMassFlow;
