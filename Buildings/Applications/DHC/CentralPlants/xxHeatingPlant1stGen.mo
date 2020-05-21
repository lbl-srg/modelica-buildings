within Buildings.Applications.DHC.CentralPlants;
model xxHeatingPlant1stGen "First generation district heating plant"

  replaceable package Medium_a =
      IBPSA.Media.Steam.Interfaces.PartialPureSubstanceWithSat
    "Medium model for port_a (inlet)";
  replaceable package Medium_b =
      IBPSA.Media.Steam.Interfaces.PartialPureSubstanceWithSat
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

  parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate mPla_flow_small(min=0) = 1E-4*abs(mPla_flow_nominal)
      "Small mass flow rate for regularization of zero flow";

  // Boiler efficiency curve parameters
  parameter Buildings.Fluid.Types.EfficiencyCurves effCur
    "Curve used to compute the efficiency";
  parameter Real a[:] "Coefficients for efficiency curve";

  // Diagnostics
   parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  Medium_a.ThermodynamicState sta_a=
      Medium_a.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow))) if show_T
    "Medium properties in port_a";

  Medium_b.ThermodynamicState sta_b=
      Medium_b.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow))) if show_T
    "Medium properties in port_b";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium_a)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium_b)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Fluid.Boilers.SteamBoilerTwoPort boi(redeclare package Medium_a =
        Medium_a, redeclare package Medium_b = Medium_b,
    m_flow_nominal=mPla_flow_nominal,
    show_T=show_T,
    Q_flow_nominal=QPla_flow_nominal,
    pOut_nominal=pOut_nominal,
    effCur=effCur,
    a=a,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue())
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) "Part load ratio"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W",
    displayUnit="kW") "Total heat transfer rate of boiler"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
  Fluid.FixedResistances.PressureDrop dp(
    redeclare package Medium = Medium_a,
    m_flow_nominal=mPla_flow_nominal,
    show_T=show_T,
    dp_nominal(displayUnit="Pa") = dp_nominal)
                                  "Pressure drop in pipe network"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
equation
  connect(boi.y, y) annotation (Line(points={{49,9},{40,9},{40,70},{-120,70}},
        color={0,0,127}));
  connect(boi.port_b, port_b) annotation (Line(points={{70,0},{100,0}},
                 color={0,127,255}));
  connect(boi.Q_flow, Q_flow) annotation (Line(points={{71,9},{71,8},{80,8},{80,
          80},{110,80}},     color={0,0,127}));
  connect(dp.port_b, boi.port_a)
    annotation (Line(points={{30,0},{40,0},{40,0},{50,0}}, color={0,127,255}));
  connect(dp.port_a, port_a) annotation (Line(points={{10,0},{-20,0},{-20,-60},
          {100,-60}}, color={0,127,255}));
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
end xxHeatingPlant1stGen;
