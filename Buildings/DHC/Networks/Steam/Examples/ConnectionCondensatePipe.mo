within Buildings.DHC.Networks.Steam.Examples;
model ConnectionCondensatePipe "Example model for the steam heating connection block"
  extends Modelica.Icons.Example;

  package MediumSte = Buildings.Media.Steam "Steam medium";
  package MediumWat =
      Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water medium";

  parameter Modelica.Units.SI.AbsolutePressure pSat = 150000
    "Saturation pressure";
  parameter Modelica.Units.SI.Temperature TSat = MediumSte.saturationTemperature(pSat)
     "Saturation temperature";
  parameter Modelica.Units.SI.SpecificEnthalpy dh_nominal = MediumSte.specificEnthalpy(
  MediumSte.setState_pTX(p=pSat,T=TSat,X=MediumSte.X_default)) -
  MediumWat.specificEnthalpy(MediumWat.setState_pTX(p=pSat,T=TSat,X=MediumWat.X_default))
    "Nominal change in enthalpy due to vaporization";
  parameter Modelica.Units.SI.Power Q_flow_nominal = 200E3
    "Nominal heat flow rate";
  parameter Real QHeaLoa[:, :] = [0, 200E3; 6, 200E3; 6, 50E3; 18, 50E3; 18, 75E3; 24, 75E3]
    "Heating load profile for the building";
  parameter Modelica.Units.SI.PressureDifference dp_nominal = 6000
    "Pressure drop at nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = Q_flow_nominal/dh_nominal
    "Nominal mass flow rate";

  Modelica.Blocks.Sources.Ramp ram(duration=60, startTime=60) "Ramp signal"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Fluid.Sources.MassFlowSource_T souWat(
    redeclare package Medium = MediumWat,
    use_m_flow_in=true,
    nPorts=1)
    "Water source"
    annotation (Placement(transformation(extent={{80,-20},{60,0}})));
  Fluid.Sources.MassFlowSource_T souSte(
    redeclare package Medium = MediumSte,
    use_m_flow_in=true,
    nPorts=1)
    "Steam source"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumWat,
    p(displayUnit="Pa") = 101325,
    nPorts=1)
    "Water condensate sink"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Fluid.Sources.Boundary_pT sinSte(
    redeclare package Medium = MediumSte,
    p=pSat,
    T=TSat,
    nPorts=1)
    "Steam sink"
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Buildings.DHC.Networks.Steam.ConnectionCondensatePipe con(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
    mDis_flow_nominal=m_flow_nominal,
    mCon_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal=1500)
    "Connection block for steam systems"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

equation
  connect(con.port_bDisRet, sinWat.ports[1]) annotation (Line(points={{20,-36},
          {0,-36},{0,-70},{-20,-70}},
                                   color={0,127,255}));
  connect(con.port_bCon, sinSte.ports[1])
    annotation (Line(points={{30,-20},{30,30},{60,30}}, color={0,127,255}));
  connect(souSte.ports[1], con.port_aDisSup)
    annotation (Line(points={{-20,-30},{20,-30}}, color={0,127,255}));
  connect(souWat.ports[1], con.port_aCon)
    annotation (Line(points={{60,-10},{36,-10},{36,-20}}, color={0,127,255}));
  connect(ram.y, souSte.m_flow_in) annotation (Line(points={{-59,50},{-50,50},{
          -50,-22},{-42,-22}}, color={0,0,127}));
  connect(ram.y, souWat.m_flow_in) annotation (Line(points={{-59,50},{90,50},{
          90,-2},{82,-2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Networks/Steam/Examples/ConnectionCondensatePipe.mos"
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
This model demonstrates the performance of the
connection block for steam heating systems with a
ramp input for the mass flow rate at the building
interconnection.
</p>
</html>"));
end ConnectionCondensatePipe;
