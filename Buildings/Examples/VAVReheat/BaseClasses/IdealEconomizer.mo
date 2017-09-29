within Buildings.Examples.VAVReheat.BaseClasses;
model IdealEconomizer
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Design chilled water supply flow";
  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) annotation (Placement(
        transformation(extent={{-120,-10},{-100,10}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,110})));

  Modelica.Fluid.Interfaces.FluidPort_a port_Ret(redeclare package Medium =
        Medium, m_flow(start=0, min=if allowFlowReversal then -Modelica.Constants.inf
           else 0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-70},{90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_Sup(redeclare package Medium =
        Medium, m_flow(start=0, max=if allowFlowReversal then +Modelica.Constants.inf
           else 0))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,50},{90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_Out(redeclare package Medium =
        Medium, m_flow(start=0, min=if allowFlowReversal then -Modelica.Constants.inf
           else 0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_Exh(redeclare package Medium =
        Medium, m_flow(start=0, max=if allowFlowReversal then +Modelica.Constants.inf
           else 0))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}})));

  Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare package Medium = Medium)
    "Mass flow rate sensor" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={60,60})));
  Fluid.Movers.BaseClasses.IdealSource preMasFlo(
    redeclare package Medium = Medium,
    control_m_flow=true,
    control_dp=false,
    m_flow_small=m_flow_nominal*1E-5,
    show_V_flow=false) "Prescribed mass flow rate for the bypass" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={20,0})));
  Modelica.Blocks.Math.Product pro "Product for mass flow rate computation"
    annotation (Placement(transformation(extent={{-20,18},{0,38}})));
  Modelica.Blocks.Sources.Constant one(final k=1) "Outputs one"
    annotation (Placement(transformation(extent={{-88,12},{-68,32}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-60,12},{-40,32}})));
equation
  connect(feedback.u1, one.y)
    annotation (Line(points={{-58,22},{-67,22}},
                                               color={0,0,127}));
  connect(y, feedback.u2)
    annotation (Line(points={{-110,0},{-50,0},{-50,14}},color={0,0,127}));
  connect(pro.y, preMasFlo.m_flow_in)
    annotation (Line(points={{1,28},{28,28},{28,-6}},    color={0,0,127}));
  connect(port_Ret, port_Exh)
    annotation (Line(points={{100,-60},{-100,-60}}, color={0,127,255}));
  connect(preMasFlo.port_a, port_Ret)
    annotation (Line(points={{20,-10},{20,-60},{100,-60}}, color={0,127,255}));
  connect(senMasFlo.port_b, port_Sup)
    annotation (Line(points={{70,60},{100,60}}, color={0,127,255}));
  connect(senMasFlo.port_a, port_Out)
    annotation (Line(points={{50,60},{-100,60}}, color={0,127,255}));
  connect(preMasFlo.port_b, senMasFlo.port_a)
    annotation (Line(points={{20,10},{20,60},{50,60}}, color={0,127,255}));
  connect(pro.u2, feedback.y)
    annotation (Line(points={{-22,22},{-41,22}}, color={0,0,127}));
  connect(pro.u1, senMasFlo.m_flow) annotation (Line(points={{-22,34},{-28,34},{
          -28,44},{60,44},{60,49}}, color={0,0,127}));
  annotation (Icon(graphics={   Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(
          points={{0,64},{0,100}}),
        Rectangle(
          extent={{-94,36},{90,24}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,-30},{96,-42}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,30},{6,-32}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-86,12},{-64,48},{-46,48},{-70,12},{-86,12}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{48,36},{70,30},{48,24},{48,36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{72,-30},{48,-36},{72,-42},{72,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{28,32},{48,28}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-74,-52},{-52,-16},{-34,-16},{-58,-52},{-74,-52}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-16},{2,20},{20,20},{-4,-16},{-20,-16}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,64},{0,34},{0,36}},
          color={0,0,255}),  Text(
          extent={{-48,-48},{50,-96}},
          lineColor={0,0,255},
          textString=
               "%name")}));
end IdealEconomizer;
