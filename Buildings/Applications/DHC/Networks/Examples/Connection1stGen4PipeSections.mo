within Buildings.Applications.DHC.Networks.Examples;
model Connection1stGen4PipeSections
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam (
     T_default=179.91+273.15) "Steam medium";
  package MediumWat = IBPSA.Media.WaterHighTemperature "Water medium";

  parameter Modelica.SIunits.AbsolutePressure pSte=1000000
    "Steam pressure";

  parameter Modelica.SIunits.Temperature TSte=
    MediumSte.saturationTemperature_p(pSte)
    "Steam temperature";

  parameter Modelica.SIunits.Power QBui_flow_nominal= 9000E3
    "Nominal heat flow rate";
  parameter Real QBui1_flow_profile[:, :]= [0, 9000E3; 6, 9000E3; 6, 500E3; 18, 500E3; 18, 800E3; 24, 800E3]
    "Building 1 load profile ";
  parameter Real QBui2_flow_profile[:, :]= [0, 4500E3; 6, 4500E3; 6, 9000E3; 12, 9000E3; 18, 1000E3; 24, 1000E3]
    "Building 2 load profile ";
    //[0, 9000E3; 6, 9000E3; 6, 500E3; 18, 500E3; 18, 800E3; 24, 800E3]

  parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    MediumSte.enthalpyOfVaporization_sat(MediumSte.saturationState_p(pSte))
    "Nominal change in enthalpy";

  parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal = QBui_flow_nominal/dh_nominal
    "Nominal mass flow rate for building";

  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal = mBui_flow_nominal*2
    "Nominal mass flow rate for district";

  Buildings.Applications.DHC.Networks.Connection1stGen4PipeSections con(
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
    lengthDisRet=1000,
    lengthConSup=1000,
    lengthConRet=1000,
    p_start=pSte,
    T_start=TSte)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,10})));
  Buildings.Fluid.Sources.Boundary_pT watDisSin(redeclare package Medium = MediumWat,
      nPorts=1) "Water district sink"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Applications.DHC.Examples.Heating.Generation1.BaseClasses.BuildingTimeSeriesHeating
    bld1(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    QHeaLoa=QBui1_flow_profile,
    Q_flow_nominal=QBui_flow_nominal,
    pSte_nominal=pSte,
    timeScale=3600)    "Building"
    annotation (Placement(transformation(extent={{-40,6},{-20,26}})));

  Buildings.Fluid.Sources.Boundary_pT steDisSou(
    redeclare package Medium = MediumSte,
    p=pSte,
    T=TSte,
    nPorts=1) "Steam district source"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Applications.DHC.Examples.Heating.Generation1.BaseClasses.BuildingTimeSeriesHeating
    bld2(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    QHeaLoa=QBui2_flow_profile,
    Q_flow_nominal=QBui_flow_nominal,
    pSte_nominal=pSte,
    timeScale=3600)    "Building"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation
  connect(watDisSin.ports[1], con.port_bDisRet) annotation (Line(points={{-20,-60},
          {16,-60},{16,0}},              color={0,127,255}));
  connect(con.port_bCon, bld1.port_a)
    annotation (Line(points={{0,10},{-20,10}}, color={0,127,255}));
  connect(bld1.port_b, con.port_aCon)
    annotation (Line(points={{-20,16},{0,16}}, color={0,127,255}));
  connect(steDisSou.ports[1], con.port_aDisSup)
    annotation (Line(points={{-20,-30},{10,-30},{10,0}}, color={0,127,255}));
  connect(con.port_bDisSup, bld2.port_a)
    annotation (Line(points={{10,20},{10,44},{-20,44}}, color={0,127,255}));
  connect(con.port_aDisRet, bld2.port_b)
    annotation (Line(points={{16,20},{16,50},{-20,50}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/Networks/Examples/Connection1stGen4PipeSections.mos"
    "Simulate and plot"),
  experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end Connection1stGen4PipeSections;
