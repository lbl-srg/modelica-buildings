within Buildings.Fluid.FMI.Validation;
model HeaterFan_noReverseFlow
  "Heater and fan in series, model configured to not allow flow reversal"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model";

  final parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)";

  parameter Boolean use_p_in = false
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=Q_flow_nominal/1000/10
    "Nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="Pa")=2000
    "Pressure";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 1000
    "Heat flow rate at u=1, positive for heating";

  ExportContainers.Examples.FMUs.Fan floMac(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    final allowFlowReversal=allowFlowReversal,
    use_p_in=use_p_in) "Flow machine with pressure raise as an input"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  ExportContainers.Examples.FMUs.HeaterCooler_u hea(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    Q_flow_nominal=Q_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    use_p_in=use_p_in) "Heater"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Modelica.Blocks.Sources.Constant dp(k=1000) "Pressure raise of fan"
    annotation (Placement(transformation(extent={{22,40},{42,60}})));

  Modelica.Blocks.Sources.Constant uHea(k=0.2) "Control signal for heater"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  Source_T sou(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    use_p_in=use_p_in) "Source for mass flow rate and pressure"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Modelica.Blocks.Sources.Constant m_flow(k=m_flow_nominal) "Mass flow rate"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Modelica.Blocks.Sources.Constant pIn(k=100000) "Inlet pressure"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Modelica.Blocks.Sources.Constant TIn(k=293.15) "Inlet temperature"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Modelica.Blocks.Sources.Constant X_w_in(k=0.01) "Inlet mass fraction"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Modelica.Blocks.Sources.Constant C[Medium.nC](each k=0.01) if
     Medium.nC > 0 "Trace substances for forward flow"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
equation
  connect(uHea.y, hea.u) annotation (Line(
      points={{1,50},{10,50},{10,6},{18,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp.y, floMac.dp_in) annotation (Line(
      points={{43,50},{50,50},{50,6},{58,6},{58,6.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.outlet, hea.inlet) annotation (Line(
      points={{1,0},{19,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(hea.outlet, floMac.inlet) annotation (Line(
      points={{41,0},{59,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(m_flow.y, sou.m_flow_in) annotation (Line(
      points={{-39,70},{-28,70},{-28,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.p_in, pIn.y) annotation (Line(
      points={{-22,4.8},{-26,4.8},{-26,6},{-32,6},{-32,40},{-39,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn.y, sou.T_in) annotation (Line(
      points={{-39,10},{-34,10},{-34,0},{-22,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(C.y, sou.C_in) annotation (Line(
      points={{-39,-60},{-28,-60},{-28,-10},{-22,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(X_w_in.y, sou.X_w_in) annotation (Line(
      points={{-39,-20},{-30,-20},{-30,-5},{-22,-5}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation(Documentation(info="<html>
<p>
This example demonstrates how to configure a model with a heater
and a fan that causes a pressure rise in the air stream.
The model is identical with
<a href=\"modelica://Buildings.Fluid.FMI.Validation.HeaterFan\">
Buildings.Fluid.FMI.Validation.HeaterFan</a>
except that reverse flow is not allowed due to the parameter
<code>allowFlowReversal=false</code>.
Consequently, the connectors for the fluid properties for the reverse flow
are removed, and the blocks on the right hand side of the model
<a href=\"modelica://Buildings.Fluid.FMI.Validation.HeaterFan\">
Buildings.Fluid.FMI.Validation.HeaterFan</a>
have been deleted.
</p>
</html>", revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
November 8, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Validation/HeaterFan_noReverseFlow.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=1.0));
end HeaterFan_noReverseFlow;
