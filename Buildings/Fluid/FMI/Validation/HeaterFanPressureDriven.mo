within Buildings.Fluid.FMI.Validation;
model HeaterFanPressureDriven
  "Heater and fan in series, model configured to allow flow reversal and pressure driven flow rate"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=Q_flow_nominal/1000/10
    "Nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="Pa")=2000
    "Pressure";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 1000
    "Heat flow rate at u=1, positive for heating";

  constant Boolean use_p_in = true
    "Set to true, as this model computes the mass flow rate based on the pressure drop"
    annotation(Evaluate=true);

  ExportContainers.Examples.FMUs.Fan floMac(
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    use_p_in=use_p_in) "Flow machine with pressure raise as an input"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  ExportContainers.Examples.FMUs.HeaterCooler_u hea(
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    Q_flow_nominal=Q_flow_nominal,
    use_p_in=use_p_in) "Heater"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Modelica.Blocks.Sources.Constant dp(k=dp_nominal) "Pressure raise of fan"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  Modelica.Blocks.Sources.Constant uHea(k=0.2) "Control signal for heater"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  Source_T sou(redeclare package Medium = Medium, use_p_in=use_p_in)
    "Source for mass flow rate and pressure"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Sink_T sin(redeclare package Medium = Medium, use_p_in=use_p_in)
    "Sink for flow rate, and source for backflow properties"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));

  Modelica.Blocks.Sources.Constant m_flow(k=m_flow_nominal) "Mass flow rate"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Modelica.Blocks.Sources.Constant pIn(k=100000) "Inlet pressure"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));

  Modelica.Blocks.Sources.Constant TIn(k=293.15) "Inlet temperature"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Modelica.Blocks.Sources.Constant X_w_in(k=0.01) "Inlet mass fraction"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  Modelica.Blocks.Sources.Constant TBac(k=303.15)
    "Temperature of backward flow"
    annotation (Placement(transformation(extent={{120,40},{100,60}})));

  Modelica.Blocks.Sources.Constant X_w_bac(k=0.015)
    "Moisture mass fraction for back flow"
    annotation (Placement(transformation(extent={{120,-10},{100,10}})));

  Modelica.Blocks.Sources.Constant CBac[Medium.nC](each k=0.01) if
     Medium.nC > 0 "Trace substances for back flow"
    annotation (Placement(transformation(extent={{120,-60},{100,-40}})));

  Modelica.Blocks.Sources.Constant C[Medium.nC](each k=0.01) if
     Medium.nC > 0 "Trace substances for forward flow"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Modelica.Blocks.Math.InverseBlockConstraints invBloCon
    "Block to set up residual function for nonlinear system of equation for pressure drop and mass flow rate"
    annotation (Placement(transformation(extent={{-20,-84},{20,-60}})));
equation
  connect(uHea.y, hea.u) annotation (Line(
      points={{-39,50},{-30,50},{-30,6},{-22,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp.y, floMac.dp_in) annotation (Line(
      points={{1,50},{10,50},{10,6},{18,6},{18,6.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.outlet, hea.inlet) annotation (Line(
      points={{-39,0},{-21,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(hea.outlet, floMac.inlet) annotation (Line(
      points={{1,0},{19,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sin.inlet, floMac.outlet) annotation (Line(
      points={{59,0},{41,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sin.T_in, TBac.y) annotation (Line(
      points={{82,8},{92,8},{92,50},{99,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(CBac.y, sin.C_in) annotation (Line(
      points={{99,-50},{92,-50},{92,-2},{82,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.p_in, pIn.y) annotation (Line(
      points={{-62,4.8},{-66,4.8},{-66,6},{-72,6},{-72,40},{-79,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn.y, sou.T_in) annotation (Line(
      points={{-79,10},{-74,10},{-74,0},{-62,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(C.y, sou.C_in) annotation (Line(
      points={{-79,-60},{-68,-60},{-68,-10},{-62,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pIn.y, invBloCon.u1) annotation (Line(
      points={{-79,40},{-72,40},{-72,-72},{-22,-72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sin.p, invBloCon.u2) annotation (Line(
      points={{82,-8},{86,-8},{86,-92},{0,-92},{0,-72},{-16,-72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(invBloCon.y1, sou.m_flow_in) annotation (Line(
      points={{21,-72},{50,-72},{50,70},{-68,70},{-68,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(X_w_in.y, sou.X_w_in) annotation (Line(
      points={{-79,-20},{-74,-20},{-74,-5},{-62,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(X_w_bac.y, sin.X_w_in) annotation (Line(
      points={{99,0},{92,0},{92,3},{82,3}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -100},{140,100}}), graphics), Documentation(info="<html>
<p>
This example demonstrates how to configure a model with a heater
and a fan that causes a pressure rise in the air stream.
The fan increases the pressure of the medium,
and it also computes how much power is needed for this pressure rise,
which is an input to the fan model.
</p>
<p>
The component <code>invBloCon</code> at the bottom of the model sets up
an equality constraint on the pressure between the sink and the source.
It also outputs a signal for the mass flow rate. Hence, this component is
used to declare how to break the algebraic loop in this signal flow diagram.
For a model with prescribed mass flow rate, see
<a href=\"modelica://Buildings.Fluid.FMI.Validation.HeaterFan\">
Buildings.Fluid.FMI.Validation.HeaterFan</a>.
</p>
<p>
For this example, the models are not exported as FMUs. However, the
thermofluid flow models are wrapped using input/output blocks.
</p>
</html>", revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/404\">#404</a>.
</li>
<li>
November 8, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Validation/HeaterFanPressureDriven.mos"
        "Simulate and plot"),
    experiment(StopTime=1));
end HeaterFanPressureDriven;
