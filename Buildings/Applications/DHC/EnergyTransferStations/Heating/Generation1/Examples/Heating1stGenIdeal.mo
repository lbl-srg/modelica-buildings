within Buildings.Applications.DHC.EnergyTransferStations.Heating.Generation1.Examples;
model Heating1stGenIdeal
  "Example model for the ideal heating energy transfer station"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.WaterHighTemperature "Water medium";

  parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    MediumSte.enthalpyOfVaporization_sat(MediumSte.saturationState_p(pSte))
    "Nominal change in enthalpy";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/dh_nominal
    "Nominal mass flow rate";

  parameter Modelica.SIunits.AbsolutePressure pSte=1000000
    "Steam pressure";

  parameter Modelica.SIunits.Temperature TSte=
    MediumSte.saturationTemperature_p(pSte)
    "Steam temperature";

  // Building load
  parameter Real Q_flow_profile[:, :]= [0, 200E3; 6, 200E3; 6, 50E3; 18, 50E3; 18, 75E3; 24, 75E3]
    "Normalized time series heating load";
  parameter Modelica.SIunits.Power Q_flow_nominal= 200E3
    "Nominal heat flow rate";

  Buildings.Fluid.Sources.Boundary_pT watSin(redeclare package Medium =
    MediumWat,
    nPorts=1) "Water sink"
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Buildings.Fluid.Sources.Boundary_pT souSte(
    redeclare package Medium = MediumSte,
    p(displayUnit="Pa") = pSte,
    T=TSte,
    nPorts=1) "Steam source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Applications.DHC.EnergyTransferStations.Heating.Generation1.Heating1stGenIdeal ets(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    m_flow_nominal=m_flow_nominal,
    Q_flow_nominal=Q_flow_nominal,
    pSte_nominal=pSte) "Ideal heating energy transfer station"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.TimeTable QHea(table=Q_flow_profile,
    timeScale=3600) "Heating demand"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation
  connect(souSte.ports[1], ets.port_a)
    annotation (Line(points={{-60,0},{-10,0}}, color={0,127,255}));
  connect(ets.port_b, watSin.ports[1])
    annotation (Line(points={{10,0},{70,0}}, color={0,127,255}));
  connect(QHea.y, ets.Q_flow) annotation (Line(points={{-39,50},{-30,50},{-30,6},
          {-12,6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  experiment(Tolerance=1e-6, StopTime=8600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Heating/Generation1/Examples/Heating1stGenIdeal.mos"
        "Simulate and plot"));
end Heating1stGenIdeal;
