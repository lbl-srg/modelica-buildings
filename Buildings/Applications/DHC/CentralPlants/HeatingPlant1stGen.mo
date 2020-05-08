within Buildings.Applications.DHC.CentralPlants;
model HeatingPlant1stGen "First generation district heating plant"

  replaceable package Medium_a =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium model for port_a (inlet)";
  replaceable package Medium_b =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium model for port_b (outlet)";

  // Nominal Conditions
  parameter Modelica.SIunits.MassFlowRate mPla_flow_nominal
    "Nominal mass flow rate of plant"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Power QPla_flow_nominal
    "Nominal heating power of plant"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.AbsolutePressure pOut_nominal
    "Nominal pressure of boiler"
    annotation(Dialog(group = "Nominal condition"));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium_a)
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium_b)
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Buildings.Fluid.Boilers.SteamBoilerTwoPort boi(redeclare package Medium_a =
        Medium_a, redeclare package Medium_b = Medium_b,
    m_flow_nominal=mPla_flow_nominal,
    Q_flow_nominal=QPla_flow_nominal,
    pOut_nominal=pOut_nominal,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue())
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) "Part load ratio"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));

  Modelica.Blocks.Sources.RealExpression mMax_flow(y=mPla_flow_nominal)
    "Maximum (nominal) mass flow rate"
    annotation (Placement(transformation(extent={{-90,4},{-70,24}})));
  Modelica.Blocks.Math.Product mAct_flow "Actual mass flow rate"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W",
    displayUnit="kW") "Total heat transfer rate of boiler"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
protected
  Buildings.Fluid.Movers.FlowControlled_m_flow  pum(
    redeclare final package Medium = Medium_a,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=false,
    final m_flow_nominal=mPla_flow_nominal,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    nominalValuesDefineDefaultPressureCurve=true,
    final use_inputFilter=false) "Pump"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
equation
  connect(mMax_flow.y, mAct_flow.u2)
    annotation (Line(points={{-69,14},{-62,14}}, color={0,0,127}));
  connect(y, mAct_flow.u1) annotation (Line(points={{-120,70},{-70,70},{-70,26},
          {-62,26}}, color={0,0,127}));
  connect(mAct_flow.y, pum.m_flow_in)
    annotation (Line(points={{-39,20},{-10,20},{-10,-28}},color={0,0,127}));
  connect(boi.y, y) annotation (Line(points={{19,-31},{10,-31},{10,70},{-120,70}},
        color={0,0,127}));
  connect(port_a, pum.port_a) annotation (Line(points={{100,40},{-30,40},{-30,-40},
          {-20,-40}},
                    color={0,127,255}));
  connect(pum.port_b, boi.port_a)
    annotation (Line(points={{0,-40},{20,-40}},
                                            color={0,127,255}));
  connect(boi.port_b, port_b) annotation (Line(points={{40,-40},{100,-40}},
                 color={0,127,255}));
  connect(boi.Q_flow, Q_flow) annotation (Line(points={{41,-31},{41,-32},{60,-32},
          {60,80},{110,80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Polygon(
          points={{-62,-14},{-62,-14}},
          lineColor={238,46,47},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{80,-60},{-80,-60},{-80,60},{-60,60},{-60,0},{-40,0},{-40,20},
              {0,0},{0,20},{40,0},{40,20},{80,0},{80,-60}},
          lineColor={95,95,95},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{46,-38},{58,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{62,-38},{74,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{62,-54},{74,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{46,-54},{58,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{22,-54},{34,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{6,-54},{18,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{6,-38},{18,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{22,-38},{34,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-18,-54},{-6,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-34,-54},{-22,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-34,-38},{-22,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-18,-38},{-6,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end HeatingPlant1stGen;
