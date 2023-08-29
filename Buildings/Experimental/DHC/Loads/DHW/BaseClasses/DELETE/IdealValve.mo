within Buildings.Experimental.DHC.Loads.DHW.BaseClasses.DELETE;
model IdealValve "Ideal three-way valve"
  extends Modelica.Blocks.Icons.Block;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Design chilled water supply flow";
  parameter Boolean port_3_fraction = true "True for fraction of port 2 flow, False for fraction of m_flow_nominal";
  Modelica.Fluid.Interfaces.FluidPort_a port_1(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{50,88},
            {70,108}}), iconTransformation(extent={{50,88},{70,108}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_2(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{50,-108},
            {70,-88}}), iconTransformation(extent={{50,-108},{70,-88}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_3(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{90,-10},
            {110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) annotation (Placement(
        transformation(extent={{-120,-10},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        Medium, allowFlowReversal=false) "Mass flow rate sensor" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-40})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource preMasFlo(
    redeclare package Medium = Medium,
    control_m_flow=true,
    control_dp=false,
    m_flow_small=m_flow_nominal*1E-5,
    show_V_flow=false,
    allowFlowReversal=false) "Prescribed mass flow rate for the bypass"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,0})));
  Modelica.Blocks.Math.Product pro "Product for mass flow rate computation"
    annotation (Placement(transformation(extent={{-28,6},{-8,26}})));
  Modelica.Blocks.Sources.Constant one(final k=1) "Outputs one"
    annotation (Placement(transformation(extent={{-90,12},{-70,32}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-60,12},{-40,32}})));
  Modelica.Blocks.Logical.Switch fraSwi
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Modelica.Blocks.Sources.Constant con(final k=m_flow_nominal) "Constant"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Modelica.Blocks.Sources.BooleanConstant fra(k=port_3_fraction)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
equation
  connect(feedback.u1, one.y)
    annotation (Line(points={{-58,22},{-69,22}},
                                               color={0,0,127}));
  connect(y, feedback.u2)
    annotation (Line(points={{-110,0},{-50,0},{-50,14}},color={0,0,127}));
  connect(preMasFlo.port_a, port_3)
    annotation (Line(points={{60,-1.33227e-15},{80,-1.33227e-15},{80,0},{100,
          0}},                                   color={0,127,255}));
  connect(feedback.y, pro.u1)
    annotation (Line(points={{-41,22},{-30,22}},
                                               color={0,0,127}));
  connect(pro.y, preMasFlo.m_flow_in)
    annotation (Line(points={{-7,16},{56,16},{56,8}},    color={0,0,127}));
  connect(port_1, senMasFlo.port_a)
    annotation (Line(points={{60,98},{60,60},{4.44089e-16,60},{4.44089e-16,
          -30}},                                  color={0,127,255}));
  connect(senMasFlo.port_b, port_2)
    annotation (Line(points={{-4.44089e-16,-50},{0,-50},{0,-72},{60,-72},{60,
          -92},{60,-92},{60,-98},{60,-98}},      color={0,127,255}));
  connect(preMasFlo.port_b, senMasFlo.port_a) annotation (Line(points={{40,
          1.33227e-15},{4.44089e-16,1.33227e-15},{4.44089e-16,-30}},
                                  color={0,127,255}));
  connect(senMasFlo.m_flow, fraSwi.u1) annotation (Line(points={{-11,-40},{-60,-40},
          {-60,-12},{-42,-12}}, color={0,0,127}));
  connect(con.y, fraSwi.u3) annotation (Line(points={{-79,-60},{-62,-60},{-62,-28},
          {-42,-28}}, color={0,0,127}));
  connect(fraSwi.y, pro.u2) annotation (Line(points={{-19,-20},{-10,-20},{-10,0},
          {-40,0},{-40,10},{-30,10}}, color={0,0,127}));
  connect(fra.y, fraSwi.u2) annotation (Line(points={{-79,-30},{-70,-30},{-70,-20},
          {-42,-20}}, color={255,0,255}));
  annotation (
    Icon(
      graphics={
        Polygon(
          points={{60,0},{68,14},{52,14},{60,0}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{60,100},{60,-100}}, color={28,108,200}),
        Line(points={{102,0},{62,0}}, color={28,108,200}),
        Polygon(
          points={{60,0},{68,-14},{52,-14},{60,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{62,0},{-98,0}}, color={0,0,0}),
        Rectangle(
          visible=use_inputFilter,
          extent={{28,-10},{46,10}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{72,-8},{72,8},{60,0},{72,-8}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end IdealValve;
