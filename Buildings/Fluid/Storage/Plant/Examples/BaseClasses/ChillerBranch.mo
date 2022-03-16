within Buildings.Fluid.Storage.Plant.Examples.BaseClasses;
model ChillerBranch
  "A branch with a pump, a check valve, and a chiller"
  extends Interfaces.PartialTwoPortInterface;

  package MediumCDW = Buildings.Media.Water "Medium model for CDW";

  parameter Modelica.Units.SI.Temperature T_a_nominal=12+273.15
    "Nominal temperature of CHW supply";
  parameter Modelica.Units.SI.Temperature T_b_nominal=7+273.15
    "Nominal temperature of CHW return";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=500000
    "Nominal pressure difference";

  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium,
    per(pressure(dp=dp_nominal*{2,1.2,0}, V_flow=m_flow_nominal/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=true,
    addPowerToMedium=false,
    m_flow_start=0,
    T_start=T_a_nominal) "Primary CHW pump"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Fluid.FixedResistances.CheckValve cheVal(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) "Check valve with series resistance"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}}, rotation=0)));
  Buildings.Fluid.Chillers.ElectricEIR chi(
    redeclare final package Medium1 = MediumCDW,
    redeclare final package Medium2 = Medium,
    final dp1_nominal=0,
    final dp2_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p2_start=500000,
    T2_start=T_b_nominal,
    final per=perChi)
    "Water cooled chiller (ports indexed 1 are on condenser side)"
    annotation (Placement(transformation(extent={{40,0},{20,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onChi(k=true)
                               "Placeholder, chiller always on"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Modelica.Blocks.Sources.Constant set_TEvaLvg(k=T_b_nominal)
    "Evaporator leaving temperature setpoint" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-30})));
  Buildings.Fluid.Sources.MassFlowSource_T souCDW(
    redeclare package Medium = MediumCDW,
    m_flow=1.2*m_flow_nominal,
    T=305.15,
    nPorts=1) "Source representing CDW supply line" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,50})));
  Buildings.Fluid.Sources.Boundary_pT sinCDW(
    redeclare final package Medium = MediumCDW,
    final p=300000,
    final T=310.15,
    nPorts=1) "Sink representing CDW return line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={10,50})));
  Modelica.Blocks.Interfaces.RealInput mPumSet_flow
    "Primary pump mass flow rate setpoint" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,28}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40})));
  replaceable parameter
      Buildings.Fluid.Chillers.Data.ElectricEIR.Generic perChi(
    QEva_flow_nominal=-1E6,
    COP_nominal=3,
    PLRMax=1,
    PLRMinUnl=0.3,
    PLRMin=0.3,
    etaMotor=1,
    mEva_flow_nominal=0.7*m_flow_nominal,
    mCon_flow_nominal=1.2*perChi.mEva_flow_nominal,
    TEvaLvg_nominal=280.15,
    capFunT={1,0,0,0,0,0},
    EIRFunT={1,0,0,0,0,0},
    EIRFunPLR={1,0,0},
    TEvaLvgMin=276.15,
    TEvaLvgMax=288.15,
    TConEnt_nominal=310.15,
    TConEntMin=303.15,
    TConEntMax=333.15)
    "Chiller performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-40,60},{-20,80}})));
equation
  connect(port_a, pum.port_a)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(pum.port_b, cheVal.port_a)
    annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(port_b, port_b)
    annotation (Line(points={{100,0},{100,0}}, color={0,127,255}));
  connect(onChi.y, chi.on) annotation (Line(points={{42,-70},{56,-70},{56,13},{
          42,13}},
                color={255,0,255}));
  connect(set_TEvaLvg.y, chi.TSet) annotation (Line(points={{41,-30},{50,-30},{
          50,7},{42,7}},
                      color={0,0,127}));
  connect(pum.m_flow_in, mPumSet_flow)
    annotation (Line(points={{-70,12},{-70,28},{-110,28}}, color={0,0,127}));
  connect(souCDW.ports[1], chi.port_a1)
    annotation (Line(points={{50,40},{50,16},{40,16}}, color={0,127,255}));
  connect(sinCDW.ports[1], chi.port_b1)
    annotation (Line(points={{10,40},{10,16},{20,16}}, color={0,127,255}));
  connect(cheVal.port_b, chi.port_a2) annotation (Line(points={{-20,0},{12,0},{
          12,4},{20,4}}, color={0,127,255}));
  connect(chi.port_b2, port_b) annotation (Line(points={{40,4},{84,4},{84,0},{
          100,0}}, color={0,127,255}));
  annotation (Icon(graphics={
        Ellipse(extent={{-80,20},{-40,-20}}, lineColor={28,108,200}),
        Polygon(points={{-72,16},{-72,-16},{-40,0},{-72,16}}, lineColor={28,108,
              200}),
        Line(points={{-20,-20},{-20,20},{20,-20},{20,20}}, color={28,108,200}),
        Line(points={{-20,30},{20,30}}, color={28,108,200}),
        Polygon(
          points={{20,30},{10,34},{10,26},{20,30}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{40,20},{80,-20}}, lineColor={28,108,200}),
        Line(points={{48,16},{78,8}}, color={28,108,200}),
        Line(points={{48,-16},{78,-8}}, color={28,108,200}),
        Line(
          points={{-80,0},{-100,0}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{-20,0},{-40,0}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{40,0},{20,0}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{100,0},{80,0}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{-100,40},{-60,40},{-60,20}},
          color={28,108,200},
          pattern=LinePattern.Dash),
        Text(
          extent={{-100,40},{-40,60}},
          textColor={28,108,200},
          textString="m_flow")}));
end ChillerBranch;
