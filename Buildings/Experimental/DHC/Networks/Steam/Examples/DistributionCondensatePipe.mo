within Buildings.Experimental.DHC.Networks.Steam.Examples;
model DistributionCondensatePipe
  "Example model for the steam heating distribution network"
  extends Modelica.Icons.Example;

  package MediumSte = Buildings.Media.Steam "Steam medium";
  package MediumWat =
    Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water medium";

  parameter Modelica.Units.SI.AbsolutePressure pSat=150000
    "Saturation pressure";
  parameter Modelica.Units.SI.Temperature TSat=
     MediumSte.saturationTemperature(pSat)
     "Saturation temperature";
  parameter Modelica.Units.SI.SpecificEnthalpy dh_nominal=
    MediumSte.specificEnthalpy(MediumSte.setState_pTX(
        p=pSat,
        T=TSat,
        X=MediumSte.X_default)) -
      MediumWat.specificEnthalpy(MediumWat.setState_pTX(
        p=pSat,
        T=TSat,
        X=MediumWat.X_default))
    "Nominal change in enthalpy due to vaporization";
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
    Q1_flow_nominal/dh_nominal
    "Nominal mass flow rate, building 1";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=
    Q2_flow_nominal/dh_nominal
    "Nominal mass flow rate, building 2";

  Buildings.Fluid.Sources.Boundary_pT souSte(
    redeclare package Medium = MediumSte,
    p=pSat,
    T=TSat,
    nPorts=1)
    "Steam source"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumWat,
    p(displayUnit="Pa") = 101325,
    nPorts=1)
    "Water condensate sink"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Experimental.DHC.Networks.Steam.DistributionCondensatePipe dis(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
    nCon=2,
    mDis_flow_nominal=m1_flow_nominal + m2_flow_nominal,
    mCon_flow_nominal={m1_flow_nominal,m2_flow_nominal},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-20,0},{20,20}})));
  Buildings.Experimental.DHC.Loads.Steam.BuildingTimeSeriesAtETS bui[2](
    redeclare package MediumSte = MediumSte,
    redeclare package MediumWat = MediumWat,
    each pSte_nominal=pSat,
    each TSte_nominal=TSat,
    each dh_nominal=dh_nominal,
    Q_flow_nominal={Q1_flow_nominal,Q2_flow_nominal},
    each dp_nominal=dp_nominal,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    QHeaLoa={QHeaLoa1,QHeaLoa2},
    each timeScale(displayUnit="s") = 3600)
    "Building vector consisting of 2 buildings"
    annotation (Placement(transformation(extent={{60,40},{40,60}})));

equation
  connect(souSte.ports[1], dis.port_aDisSup)
    annotation (Line(points={{-60,10},{-20,10}}, color={0,127,255}));
  connect(sinWat.ports[1], dis.port_bDisRet) annotation (Line(points={{-60,-30},
          {-40,-30},{-40,4},{-20,4}},   color={0,127,255}));
  connect(dis.ports_bCon, bui.port_a)
    annotation (Line(points={{-12,20},{-12,50},{40,50}}, color={0,127,255}));
  connect(bui.port_b, dis.ports_aCon)
    annotation (Line(points={{40,44},{12,44},{12,20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, Tolerance=1e-6),
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Networks/Steam/Examples/DistributionCondensatePipe.mos"
      "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
March 2, 2022, by Kathryn Hinkelman:<br/>
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
