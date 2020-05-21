within Buildings.Applications.DHC.Networks.Examples;
model Connection1stGen2PipeSections
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam.Steam (
     T_default=179.91+273.15) "Steam medium";
  package MediumWat = IBPSA.Media.WaterHighTemperature "Water medium";

  parameter Modelica.SIunits.AbsolutePressure pSte=1000000
    "Steam pressure";

  parameter Modelica.SIunits.Temperature TSte=
    MediumSte.saturationTemperature_p(pSte)
    "Steam temperature";

  parameter Modelica.SIunits.Power QBui_flow_nominal= 9000E3
    "Nominal heat flow rate";
  parameter Real QBui_flow_profile[:, :]= [0, 9000E3; 1, 9000E3]
    "Normalized time series heating load";
    //[0, 9000E3; 6, 9000E3; 6, 500E3; 18, 500E3; 18, 800E3; 24, 800E3]

  parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    MediumSte.enthalpyOfVaporization_sat(MediumSte.saturationState_p(pSte))
    "Nominal change in enthalpy";

  parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal = QBui_flow_nominal/dh_nominal
    "Nominal mass flow rate for building";

  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal = mBui_flow_nominal*2
    "Nominal mass flow rate for district";

  Buildings.Applications.DHC.Networks.Connection1stGen2PipeSections con(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
    mDis_flow_nominal=mDis_flow_nominal,
    mCon_flow_nominal=mBui_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    nSeg=3,
    thicknessInsSup=0.01,
    thicknessInsRet=0.01,
    lambdaIns=0.04,
    lengthDisSup=1000,
    lengthDisRet=1000)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Fluid.Sources.Boundary_pT watDisSin(redeclare package Medium = MediumWat,
      nPorts=1) "Water district sink"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Fluid.Sources.Boundary_pT steDisSin(
    redeclare package Medium = MediumSte,
    p=pSte,
    T=TSte,
    nPorts=1) "Steam district sink"
    annotation (Placement(transformation(extent={{80,0},{60,20}})));
  Fluid.Sources.MassFlowSource_T steDisSou(
    redeclare package Medium = MediumSte,
    m_flow=mDis_flow_nominal,
    T=TSte,
    nPorts=1) "Steam district source"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Fluid.Sources.MassFlowSource_T watDisSou(redeclare package Medium = MediumWat,
    m_flow=mDis_flow_nominal,
      T=TSte - 10,
    nPorts=1)      "Water district source"
    annotation (Placement(transformation(extent={{80,-30},{60,-10}})));

  Fluid.Sources.MassFlowSource_T steBldSin(
    redeclare package Medium = MediumSte,
    m_flow=-mBui_flow_nominal,
    T=TSte,
    nPorts=1) "Steam building sink"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Fluid.Sources.MassFlowSource_T watBldSou(
    redeclare package Medium = MediumWat,
    m_flow=mBui_flow_nominal,
    T=TSte,
    nPorts=1) "Water building source"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
equation
  connect(watDisSin.ports[1], con.port_bDisRet) annotation (Line(points={{-60,
          -20},{-20,-20},{-20,4},{0,4}}, color={0,127,255}));
  connect(con.port_bDisSup, steDisSin.ports[1])
    annotation (Line(points={{20,10},{60,10}}, color={0,127,255}));
  connect(watDisSou.ports[1], con.port_aDisRet) annotation (Line(points={{60,-20},
          {40,-20},{40,4},{20,4}}, color={0,127,255}));
  connect(con.port_aDisSup, steDisSou.ports[1])
    annotation (Line(points={{0,10},{-60,10}}, color={0,127,255}));
  connect(con.port_bCon, steBldSin.ports[1])
    annotation (Line(points={{10,20},{10,50},{0,50}}, color={0,127,255}));
  connect(watBldSou.ports[1], con.port_aCon)
    annotation (Line(points={{0,80},{16,80},{16,20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3600, __Dymola_Algorithm="Cvode"));
end Connection1stGen2PipeSections;
