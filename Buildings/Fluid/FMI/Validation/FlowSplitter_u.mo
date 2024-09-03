within Buildings.Fluid.FMI.Validation;
model FlowSplitter_u "Flow splitter"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";

  parameter Boolean use_p_in = false
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);
  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Blocks.Sources.Constant uSpl(k=1.0) "Control signal for heater"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  Source_T sou(
    redeclare package Medium = Medium,
    use_p_in=use_p_in,
    allowFlowReversal = allowFlowReversal)
    "Source for mass flow rate and pressure"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Modelica.Blocks.Sources.Constant m_flow(k=m_flow_nominal*3) "Mass flow rate"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Modelica.Blocks.Sources.Constant pIn(k=100000) "Inlet pressure"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Modelica.Blocks.Sources.Constant TIn(k=293.15) "Inlet temperature"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Modelica.Blocks.Sources.Constant X_w_in(k=0.01) "Inlet mass fraction"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Modelica.Blocks.Sources.Constant C[Medium.nC](each k=0.01)
  if Medium.nC > 0 "Trace substances for forward flow"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  ExportContainers.Examples.FMUs.FlowSplitter_u floSpl(
    redeclare package Medium = Medium,
    use_p_in=use_p_in,
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
equation
  connect(m_flow.y, sou.m_flow_in) annotation (Line(
      points={{-59,70},{-38,70},{-38,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.p_in, pIn.y) annotation (Line(
      points={{-22,4.8},{-34,4.8},{-34,6},{-40,6},{-40,40},{-59,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn.y, sou.T_in) annotation (Line(
      points={{-59,10},{-44,10},{-44,0},{-22,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(C.y, sou.C_in) annotation (Line(
      points={{-59,-50},{-38,-50},{-38,-10},{-22,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(X_w_in.y, sou.X_w_in) annotation (Line(
      points={{-59,-20},{-40,-20},{-40,-5},{-22,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(floSpl.inlet, sou.outlet) annotation (Line(
      points={{49,0},{1,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(floSpl.u[1], uSpl.y) annotation (Line(
      points={{49,8},{20,8},{20,50},{1,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(floSpl.u[2], uSpl.y) annotation (Line(
      points={{49,8},{20,8},{20,50},{1,50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -100},{140,100}}), graphics), Documentation(info="<html>
<p>
This example demonstrates how to configure a model with a flow splitter.
</p>
<p>
For this example, the model is not exported as an FMU. However, the
thermofluid flow models are wrapped using input/output blocks.
</p>
</html>", revisions="<html>
<ul>
<li>
July 28, 2015, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Validation/FlowSplitter_u.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=1.0));
end FlowSplitter_u;
