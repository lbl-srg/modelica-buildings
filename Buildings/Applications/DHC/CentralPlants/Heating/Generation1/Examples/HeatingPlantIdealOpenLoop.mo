within Buildings.Applications.DHC.CentralPlants.Heating.Generation1.Examples;
model HeatingPlantIdealOpenLoop
  "Example model for the first generation heating plant"
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

  // Plant load
  parameter Real Q_flow_profile[:, :]= [0, 9000E3; 6, 9000E3; 6, 500E3; 18, 500E3; 18, 800E3; 24, 800E3]
    "Normalized time series heating load";
  parameter Modelica.SIunits.Power Q_flow_nominal= 9000E3
    "Nominal heat flow rate";

  HeatingPlantIdeal pla(
    redeclare package Medium_a = MediumWat,
    redeclare package Medium_b = MediumSte,
    mPla_flow_nominal=m_flow_nominal,
    QPla_flow_nominal=Q_flow_nominal,
    pOut_nominal=pSte,
    dp_nominal=6000,
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    a={0.9},
    show_T=true) "Heating plant"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    height=m_flow_nominal,
    duration(displayUnit="h") = 3600,
    startTime(displayUnit="h") = 3600)
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Fluid.Sources.Boundary_pT steSin(
    redeclare package Medium = MediumSte,
    p=pSte,
    nPorts=1) "Steam sink"
    annotation (Placement(transformation(extent={{90,0},{70,20}})));
  Fluid.Sources.Boundary_pT watSou(redeclare package Medium = MediumWat, nPorts=
       1) "Water source"
    annotation (Placement(transformation(extent={{90,-60},{70,-40}})));
  Fluid.FixedResistances.Pipe pip(
    redeclare package Medium = MediumSte,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    p_start=pSte,
    T_start=TSte,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    nSeg=1,
    thicknessIns=0.01,
    lambdaIns=0.04,
    length=100)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
protected
  Fluid.Movers.FlowControlled_m_flow            pum(
    redeclare final package Medium = MediumWat,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=false,
    final m_flow_nominal=m_flow_nominal,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    final use_inputFilter=false) "Pump"
    annotation (Placement(transformation(extent={{60,-60},{40,-40}})));
equation
  connect(watSou.ports[1], pum.port_a)
    annotation (Line(points={{70,-50},{60,-50}}, color={0,127,255}));
  connect(pum.port_b, pla.port_a) annotation (Line(points={{40,-50},{-20,-50},{
          -20,4},{-40,4}},
                         color={0,127,255}));
  connect(pla.port_b, pip.port_a)
    annotation (Line(points={{-40,10},{40,10}}, color={0,127,255}));
  connect(pip.port_b, steSin.ports[1])
    annotation (Line(points={{60,10},{70,10}}, color={0,127,255}));
  connect(m_flow.y, pum.m_flow_in)
    annotation (Line(points={{21,-20},{50,-20},{50,-38}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/CentralPlants/Heating/Generation1/Examples/HeatingPlantIdealOpenLoop.mos"
    "Simulate and plot"),
  experiment(
    StartTime=0,
    StopTime=10800,
    Tolerance=1e-06));
end HeatingPlantIdealOpenLoop;
