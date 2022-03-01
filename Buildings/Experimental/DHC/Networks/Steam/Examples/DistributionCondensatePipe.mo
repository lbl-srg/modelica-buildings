within Buildings.Experimental.DHC.Networks.Steam.Examples;
model DistributionCondensatePipe
  "Example model for the steam heating distribution network"
  extends Modelica.Icons.Example;
  package MediumSte = Buildings.Media.Steam "Steam vapor medium";
  package MediumWat = Buildings.Media.Water "Liquid water medium";

  parameter Modelica.Units.SI.AbsolutePressure pSat=150000
    "Saturation pressure";
  parameter Modelica.Units.SI.Temperature TSat=
     MediumSte.saturationTemperature(pSat)
     "Saturation temperature";
  parameter Modelica.Units.SI.SpecificEnthalpy dhVapStd=
    MediumSte.specificEnthalpy(MediumSte.setState_pTX(
        p=pSat,
        T=TSat,
        X=MediumSte.X_default)) -
      MediumWat.specificEnthalpy(MediumWat.setState_pTX(
        p=pSat,
        T=TSat,
        X=MediumWat.X_default))
    "Standard change in enthalpy due to vaporization";
  parameter Modelica.Units.SI.Power Q1_flow_nominal=200E3
    "Nominal heat flow rate, building 1";
  parameter Modelica.Units.SI.Power Q2_flow_nominal=300E3
    "Nominal heat flow rate, building 2";
  parameter Real QHeaLoa1[:, :]= [0, 200E3; 6, 200E3; 6, 50E3; 18, 50E3; 18, 75E3; 24, 75E3]
    "Heating load profile for the building 1";
  parameter Real QHeaLoa2[:, :]= [0, 100E3; 6, 200E3; 6, 200E3; 10, 300E3; 18, 300E3; 24, 100E3]
    "Heating load profile for the building 2";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=6000
    "Pressure drop at nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=
    Q1_flow_nominal/dhVapStd
    "Nominal mass flow rate, building 1";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=
    Q2_flow_nominal/dhVapStd
    "Nominal mass flow rate, building 2";
  Buildings.Experimental.DHC.Networks.Steam.DistributionCondensatePipe dis(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
    nCon=2,
    mDis_flow_nominal=m1_flow_nominal + m2_flow_nominal,
    mCon_flow_nominal={m1_flow_nominal,m2_flow_nominal})
    annotation (Placement(transformation(extent={{20,-40},{60,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(redeclare package Medium =
        MediumWat,
    p(displayUnit="Pa") = 101325,
                   nPorts=1) "Water condensate sink"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Fluid.Sources.Boundary_pT sinSte(
    redeclare package Medium = MediumSte,
    p=pSat,
    T=TSat,
    nPorts=2) "Steam sink"
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Fluid.Sources.MassFlowSource_T souWat(
    redeclare package Medium = MediumWat,
    use_m_flow_in=true,
    T=TSat - 5,
    nPorts=2) "Water source"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Fluid.Sources.MassFlowSource_T souSte(
    redeclare package Medium = MediumSte,
    use_m_flow_in=true,
    T=TSat,
    nPorts=1) "Steam source"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Sources.Ramp ram(duration=60, startTime=60) "Ramp signal"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation
  connect(sinWat.ports[1], dis.port_bDisRet) annotation (Line(points={{-20,-70},
          {0,-70},{0,-36},{20,-36}},    color={0,127,255}));
  connect(dis.ports_bCon, sinSte.ports[1:2]) annotation (Line(points={{28,-20},
          {28,30},{60,30},{60,28}}, color={0,127,255}));
  connect(souSte.ports[1], dis.port_aDisSup)
    annotation (Line(points={{-20,-30},{20,-30}}, color={0,127,255}));
  connect(souWat.ports[1:2], dis.ports_aCon)
    annotation (Line(points={{60,-2},{52,-2},{52,-20}}, color={0,127,255}));
  connect(ram.y, souSte.m_flow_in) annotation (Line(points={{-59,70},{-50,70},{
          -50,-22},{-42,-22}}, color={0,0,127}));
  connect(ram.y, souWat.m_flow_in) annotation (Line(points={{-59,70},{90,70},{
          90,8},{82,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, Tolerance=1e-6, __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="modelica://DES/Resources/Scripts/Dymola/Heating/Networks/Examples/DistributionCondensatePipe.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
December 7, 2021 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model demonstrates the performance of the distribution 
network block for steam heating systems with two connected 
buildings with unique heating load profiles.
</p>
</html>"));
end DistributionCondensatePipe;
