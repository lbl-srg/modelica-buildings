within Buildings.Fluid.FMI.Conversion.Validation;
model InletToAir1
  "Validation model for inlet to Buildings.Media.Air conversion without trace substances"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Air "Medium model";
    parameter Boolean use_p_in = false
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);
  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  Modelica.Blocks.Sources.Constant m_flow(k=0.2) "Mass flow rate"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.Constant T(k=295.13) "Room temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Fluid.FMI.Conversion.InletToAir conAir(redeclare package Medium =
        Medium) "Converter for air"
    annotation (Placement(transformation(extent={{42,0},{22,20}})));

  Source_T sou(
    redeclare package Medium = Medium,
    use_p_in=use_p_in,
    allowFlowReversal = allowFlowReversal)
    "Source for mass flow rate and pressure"
    annotation (Placement(transformation(extent={{-18,0},{2,20}})));
  Modelica.Blocks.Sources.Constant pIn(k=100000) "Inlet pressure"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Constant X_w_in(k=0.01) "Inlet mass fraction"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Constant C[Medium.nC](each k=0.01) if
     Medium.nC > 0 "Trace substances for forward flow"
    annotation (Placement(transformation(extent={{-80,-86},{-60,-66}})));
equation
  connect(m_flow.y, sou.m_flow_in) annotation (Line(points={{-59,80},{-34,80},{-34,
          20},{-20,20}}, color={0,0,127}));
  connect(sou.outlet, conAir.inlet)
    annotation (Line(points={{3,10},{10,10},{21,10}}, color={0,0,255}));
  connect(sou.T_in, T.y) annotation (Line(points={{-20,10},{-36,10},{-36,0},{-59,
          0}},  color={0,0,127}));
  connect(pIn.y, sou.p_in) annotation (Line(points={{-59,40},{-38,40},{-38,14.8},
          {-20,14.8}}, color={0,0,127}));
  connect(X_w_in.y, sou.X_w_in) annotation (Line(points={{-59,-40},{-38,-40},{-38,
          5},{-20,5}}, color={0,0,127}));
  connect(C.y, sou.C_in) annotation (Line(points={{-59,-76},{-44,-76},{-28,-76},
          {-28,0},{-20,0}}, color={0,0,127}));
annotation (
    Documentation(info="<html>
<p>
This example validates the conversion model
<a href=\"modelica://Buildings.Fluid.FMI.Conversion.InletToAir\">
Buildings.Fluid.FMI.Conversion.InletToAir</a>. The medium used is  
<a href=\"modelica://Buildings.Media.Air\">Buildings.Media.Air</a>
without trace substances.
</p>
</html>", revisions="<html>
<ul>
<li>
April 28, 2016 by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Conversion/Validation/InletToAir1.mos"
        "Simulate and plot"));
end InletToAir1;
