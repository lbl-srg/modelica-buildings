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

  parameter Modelica.SIunits.PressureDifference dpFixNom = 15000;
  parameter Modelica.SIunits.PressureDifference dpValNom = 10000;
  parameter Modelica.SIunits.PressureDifference dpTotNom = dpFixNom+dpValNom;

Buildings.Fluid.Sources.Boundary_pT sinW(
    nPorts=3,
    p(displayUnit="Pa"),
    redeclare package Medium = MediumW)
                               annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=0,
      origin={90,0})));

Buildings.Fluid.Sources.Boundary_pT souW(
    nPorts=3,
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
    duration=1,
    startTime=0)
    annotation (Placement(transformation(extent={{-120,58},{-100,78}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualLin
                 valLin(
    use_inputFilter=false,
    linearized=true,
    redeclare package Medium = MediumW,
    dpValve_nominal=dpValNom,
    dpFixed_nominal=dpFixNom,
    m_flow_nominal=mFloNomW,
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
equation
  connect(souW.ports[1], valLin.port_a) annotation (Line(points={{-102,2.66667},
          {-58,2.66667},{-58,0},{-14,0}},
                                 color={0,127,255}));
  connect(uVal.y, valLin.y) annotation (Line(points={{-99,68},{-52,68},{-52,12},
          {-4,12}}, color={0,0,127}));
  connect(souW.ports[2], valNoLin.port_a) annotation (Line(points={{-102,
          -2.22045e-16},{-57,-2.22045e-16},{-57,-50},{-12,-50}}, color={0,127,
          255}));
  connect(uVal.y, valNoLin.y) annotation (Line(points={{-99,68},{-52,68},{-52,-38},
          {-2,-38}}, color={0,0,127}));
  connect(valLin.port_b, sinW.ports[1])
    annotation (Line(points={{6,0},{44,0},{44,2.66667},{80,2.66667}},
                                                          color={0,127,255}));
  connect(valNoLin.port_b, sinW.ports[2]) annotation (Line(points={{8,-50},{44,
          -50},{44,-2.22045e-16},{80,-2.22045e-16}}, color={0,127,255}));
  connect(sinW.ports[3], valLinInvFlo.port_a) annotation (Line(points={{80,
          -2.66667},{42,-2.66667},{42,46},{6,46}}, color={0,127,255}));
  connect(valLinInvFlo.port_b, souW.ports[3]) annotation (Line(points={{-14,46},
          {-60,46},{-60,-2.66667},{-102,-2.66667}}, color={0,127,255}));
  connect(uVal.y, valLinInvFlo.y) annotation (Line(points={{-99,68},{-54,68},{-54,
          58},{-4,58}},     color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{120,120}})),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-100},{120,120}})),
    experiment(Tolerance=1e-6, StopTime=1.0),
    __Dymola_Commands(file=
        "Resources/Scripts/Dymola/Fluid/Actuators/Valves/Examples/TwoWayEqualLin.mos"
        "Simulate and plot"));
end TwoWayEqualLin;
