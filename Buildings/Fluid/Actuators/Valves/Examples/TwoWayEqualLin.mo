within Buildings.Fluid.Actuators.Valves.Examples;
model TwoWayEqualLin
  extends Modelica.Icons.Example;
  import MediumW = Buildings.Media.Water;
  import MediumA = Buildings.Media.Air;

  parameter Modelica.SIunits.MassFlowRate mFloNomA = 1;
  parameter Modelica.SIunits.Temperature tEntNomA = 30 + 273.15;
  parameter Modelica.SIunits.MassFraction wEntNomA = 0.010;
  parameter Modelica.SIunits.Temperature tLvgNomA = 13 + 273.15;
  parameter Modelica.SIunits.MassFraction wLvgNomA = 0.0093;
  parameter Modelica.SIunits.Temperature tEntNomW = 7 + 273.15;
  parameter Modelica.SIunits.Temperature tLvgNomW = 12 + 273.15;
  parameter Modelica.SIunits.SpecificEnthalpy hEntNomA = MediumA.enthalpyOfGas(
    tEntNomA, {wEntNomA});
  parameter Modelica.SIunits.SpecificEnthalpy hLvgNomA = MediumA.enthalpyOfGas(
    tLvgNomA, {wLvgNomA});
  parameter Modelica.SIunits.HeatFlowRate qFloNom = mFloNomA * (
    hEntNomA-hLvgNomA);
  parameter Modelica.SIunits.ThermalConductance uANom = qFloNom /
   Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
    T_a1=tEntNomA,
    T_b1=tLvgNomA,
    T_a2=tEntNomW,
    T_b2=tLvgNomW);
  parameter Modelica.SIunits.MassFlowRate mFloNomW = qFloNom /
   (4186 * (tLvgNomW - tEntNomW));

  parameter Real f = 0.6;
  parameter Real acoef = abs(f * (tEntNomW - tLvgNomW) / (tEntNomW - tEntNomA));

  parameter Modelica.SIunits.PressureDifference dpFixNom = 15000;
  parameter Modelica.SIunits.PressureDifference dpValNom = 10000;
  parameter Modelica.SIunits.PressureDifference dpTotNom = dpFixNom+dpValNom;

Buildings.Fluid.Sources.Boundary_pT sinW(
    nPorts=6,
    p(displayUnit="Pa"),
    redeclare package Medium = MediumW)
                               annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=0,
      origin={110,0})));

Buildings.Fluid.Sources.Boundary_pT souW(
    nPorts=6,
    use_p_in=false,
    use_T_in=false,
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = MediumW.p_default + dpTotNom,
    T=tEntNomW)
            annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-112,0})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uVal(height=1,
    startTime=0,
    duration=20)
    annotation (Placement(transformation(extent={{-120,58},{-100,78}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualLin
                 valLin(
    use_inputFilter=false,
    linearized=true,
    redeclare package Medium = MediumW,
    dpValve_nominal=dpValNom,
    m_flow_nominal=mFloNomW,
    dpFixed_nominal=dpFixNom,
    fitMod="None")
    annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualLin valNoLin(
    use_inputFilter=false,
    linearized=false,
    redeclare package Medium = MediumW,
    dpValve_nominal=dpValNom,
    dpFixed_nominal=dpFixNom,
    m_flow_nominal=mFloNomW,
    fitMod="None")
    annotation (Placement(transformation(extent={{-12,-60},{8,-40}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualLin valLinInvFlo(
    use_inputFilter=false,
    linearized=true,
    redeclare package Medium = MediumW,
    m_flow_nominal=mFloNomW,
    dpValve_nominal=dpValNom,
    dpFixed_nominal=dpFixNom,
    fitMod="None")
    annotation (Placement(transformation(extent={{6,36},{-14,56}})));
Sources.Boundary_pT sinA(
    nPorts=2,
    redeclare package Medium = MediumA,
    p(displayUnit="Pa")) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-112,-154})));
  Sources.MassFlowSource_T                 boundary(
    redeclare package Medium = MediumA,
    m_flow=mFloNomA,
    T=tEntNomA,
    nPorts=2,
    X={wEntNomA,1 - wEntNomA})
    annotation (Placement(transformation(extent={{120,-164},{100,-144}})));
HeatExchangers.DryCoilEffectivenessNTU coiLin(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=mFloNomW,
    m2_flow_nominal=mFloNomA,
    dp2_nominal=100,
    show_T=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1UnmixedStream2Mixed,
    Q_flow_nominal=qFloNom,
    T_a1_nominal=tEntNomW,
    T_a2_nominal=tEntNomA,
    dp1_nominal=0)
    annotation (Placement(transformation(extent={{-12,-122},{8,-102}})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualLin valLinCoi(
    use_inputFilter=false,
    linearized=true,
    redeclare package Medium = MediumW,
    dpValve_nominal=dpValNom,
    dpFixed_nominal=dpFixNom,
    m_flow_nominal=mFloNomW,
    fitMod="a coefficient",
    a=acoef)
            annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
HeatExchangers.DryCoilEffectivenessNTU coiEqu(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=mFloNomW,
    m2_flow_nominal=mFloNomA,
    dp2_nominal=100,
    show_T=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1UnmixedStream2Mixed,
    Q_flow_nominal=qFloNom,
    T_a1_nominal=tEntNomW,
    T_a2_nominal=tEntNomA,
    dp1_nominal=0)
    annotation (Placement(transformation(extent={{-12,-160},{8,-140}})));

  TwoWayEqualPercentage                           valEquCoi(
    use_inputFilter=false,
    redeclare package Medium = MediumW,
    dpValve_nominal=dpValNom,
    dpFixed_nominal=dpFixNom,
    m_flow_nominal=mFloNomW,
    linearized=false)
    annotation (Placement(transformation(extent={{20,-146},{40,-126}})));
  TwoWayEqualPercentage valEqu(
    m_flow_nominal=mFloNomW,
    dpValve_nominal=dpValNom,
    use_inputFilter=false,
    dpFixed_nominal=dpFixNom,
    redeclare package Medium = MediumW)
    annotation (Placement(transformation(extent={{-14,78},{6,98}})));
equation
  connect(souW.ports[1], valLin.port_a) annotation (Line(points={{-102,3.33333},
          {-58,3.33333},{-58,0},{-14,0}},
                                 color={0,127,255}));
  connect(uVal.y, valLin.y) annotation (Line(points={{-99,68},{-52,68},{-52,12},
          {-4,12}}, color={0,0,127}));
  connect(souW.ports[2], valNoLin.port_a) annotation (Line(points={{-102,2},{
          -57,2},{-57,-50},{-12,-50}},                           color={0,127,
          255}));
  connect(uVal.y, valNoLin.y) annotation (Line(points={{-99,68},{-52,68},{-52,-38},
          {-2,-38}}, color={0,0,127}));
  connect(valLin.port_b, sinW.ports[1])
    annotation (Line(points={{6,0},{44,0},{44,3.33333},{100,3.33333}},
                                                          color={0,127,255}));
  connect(valNoLin.port_b, sinW.ports[2]) annotation (Line(points={{8,-50},{44,
          -50},{44,2},{100,2}},                      color={0,127,255}));
  connect(sinW.ports[3], valLinInvFlo.port_a) annotation (Line(points={{100,
          0.666667},{42,0.666667},{42,46},{6,46}}, color={0,127,255}));
  connect(valLinInvFlo.port_b, souW.ports[3]) annotation (Line(points={{-14,46},
          {-60,46},{-60,0.666667},{-102,0.666667}}, color={0,127,255}));
  connect(uVal.y, valLinInvFlo.y) annotation (Line(points={{-99,68},{-54,68},{-54,
          58},{-4,58}},     color={0,0,127}));
  connect(valLinCoi.port_b, sinW.ports[4]) annotation (Line(points={{40,-80},{
          60,-80},{60,-0.666667},{100,-0.666667}},
                                        color={0,127,255}));
  connect(uVal.y, valLinCoi.y) annotation (Line(points={{-99,68},{-52,68},{-52,
          -68},{30,-68}}, color={0,0,127}));
  connect(boundary.ports[1], coiLin.port_a2) annotation (Line(points={{100,-152},
          {44,-152},{44,-118},{8,-118}}, color={0,127,255}));
  connect(coiLin.port_b2, sinA.ports[1]) annotation (Line(points={{-12,-118},{-58,
          -118},{-58,-152},{-102,-152}}, color={0,127,255}));
  connect(souW.ports[4], coiLin.port_a1) annotation (Line(points={{-102,-0.666667},
          {-58,-0.666667},{-58,-106},{-12,-106}}, color={0,127,255}));
  connect(coiLin.port_b1, valLinCoi.port_a) annotation (Line(points={{8,-106},{
          14,-106},{14,-80},{20,-80}}, color={0,127,255}));
  connect(coiEqu.port_b1, valEquCoi.port_a) annotation (Line(points={{8,-144},{
          14,-144},{14,-136},{20,-136}}, color={0,127,255}));
  connect(valEquCoi.port_b, sinW.ports[5]) annotation (Line(points={{40,-136},{
          60,-136},{60,-2},{100,-2}},    color={0,127,255}));
  connect(souW.ports[5], coiEqu.port_a1) annotation (Line(points={{-102,-2},{-56,
          -2},{-56,-144},{-12,-144}}, color={0,127,255}));
  connect(boundary.ports[2], coiEqu.port_a2)
    annotation (Line(points={{100,-156},{8,-156}}, color={0,127,255}));
  connect(coiEqu.port_b2, sinA.ports[2])
    annotation (Line(points={{-12,-156},{-102,-156}}, color={0,127,255}));
  connect(uVal.y, valEquCoi.y) annotation (Line(points={{-99,68},{-52,68},{-52,
          -124},{30,-124}}, color={0,0,127}));
  connect(uVal.y, valEqu.y) annotation (Line(points={{-99,68},{-50,68},{-50,100},
          {-4,100}}, color={0,0,127}));
  connect(souW.ports[6], valEqu.port_a) annotation (Line(points={{-102,-3.33333},
          {-58,-3.33333},{-58,88},{-14,88}}, color={0,127,255}));
  connect(valEqu.port_b, sinW.ports[6]) annotation (Line(points={{6,88},{44,88},
          {44,-3.33333},{100,-3.33333}},color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-180},{120,100}})),
    experiment(Tolerance=1e-6, StopTime=1.0),
    __Dymola_Commands(file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Valves/Examples/TwoWayEqualLin.mos"
        "Simulate and plot"));
end TwoWayEqualLin;
