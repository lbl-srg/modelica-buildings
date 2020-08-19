within Buildings.Applications.DHC.CentralPlants.Heating.Generation1;
model HeatingPlantIdeal
  "An ideal first generation district heating plant with one boiler"

  replaceable package Medium_a =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model (liquid state) for port_a (inlet)";
  replaceable package Medium_b =
      IBPSA.Media.Interfaces.PartialPureSubstanceWithSat
    "Medium model (vapor state) for port_b (outlet)";

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
  final parameter Modelica.SIunits.Temperature TOut_nominal=
    Medium_b.saturationTemperature_p(pOut_nominal)
    "Nominal temperature of boiler";

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
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    Q_flow_nominal=QPla_flow_nominal,
    pOut_nominal=pOut_nominal,
    effCur=effCur,
    a=a,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue())
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W",
    displayUnit="kW") "Total heat transfer rate of boiler"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp(
    redeclare package Medium = Medium_a,
    m_flow_nominal=mPla_flow_nominal,
    show_T=show_T,
    dp_nominal(displayUnit="Pa") = dp_nominal)
                                  "Pressure drop in pipe network"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sensors.MassFlowRate mSen_flow(redeclare package Medium = Medium_a)
    annotation (Placement(transformation(extent={{32,-70},{12,-50}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort hSen_b(redeclare package
      Medium =
        Medium_b, m_flow_nominal=mPla_flow_nominal)
    "Specific enthalpy sensor, medium b"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort hSen_a(redeclare package
      Medium =
        Medium_a, m_flow_nominal=mPla_flow_nominal)
    "Specific enthalpy sensor, medium a"
    annotation (Placement(transformation(extent={{70,-70},{50,-50}})));
  Modelica.Blocks.Math.Add dh(k2=-1) "Change in enthalpy"
    annotation (Placement(transformation(extent={{30,-34},{10,-14}})));
  Modelica.Blocks.Math.Product QMea_flow "Measured heat flow rate"
    annotation (Placement(transformation(extent={{0,-40},{-20,-20}})));
  Modelica.Blocks.Math.Gain PLR(k=1/QPla_flow_nominal)
    "Measured part load ratio"
    annotation (Placement(transformation(extent={{-32,-40},{-52,-20}})));
  Buildings.Fluid.Sources.Boundary_pT exp(
    redeclare package Medium = Medium_b,
    p=pOut_nominal,
    T=TOut_nominal,
    nPorts=1) "Expansion boundary"
    annotation (Placement(transformation(extent={{10,20},{30,40}})));
  Modelica.Blocks.Interfaces.RealOutput EHea(
    final quantity="HeatFlow",
    final unit="J",
    displayUnit="kWh") "Total heating energy" annotation (Placement(
        transformation(extent={{100,40},{120,60}}), iconTransformation(extent={
            {100,40},{120,60}})));
  Modelica.Blocks.Continuous.Integrator IntEHea(y(unit="J"))
    "Integrator for heating energy of building"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
equation
  connect(dp.port_b, boi.port_a)
    annotation (Line(points={{-60,0},{-40,0}},             color={0,127,255}));
  connect(hSen_b.h_out, dh.u1) annotation (Line(points={{60,11},{60,20},{40,20},
          {40,-18},{32,-18}}, color={0,0,127}));
  connect(hSen_a.h_out, dh.u2)
    annotation (Line(points={{60,-49},{60,-30},{32,-30}}, color={0,0,127}));
  connect(mSen_flow.m_flow, QMea_flow.u2)
    annotation (Line(points={{22,-49},{22,-36},{2,-36}}, color={0,0,127}));
  connect(dh.y, QMea_flow.u1)
    annotation (Line(points={{9,-24},{2,-24}}, color={0,0,127}));
  connect(QMea_flow.y, PLR.u)
    annotation (Line(points={{-21,-30},{-30,-30}}, color={0,0,127}));
  connect(boi.port_b, hSen_b.port_a)
    annotation (Line(points={{-20,0},{50,0}}, color={0,127,255}));
  connect(hSen_b.port_b, port_b)
    annotation (Line(points={{70,0},{100,0}}, color={0,127,255}));
  connect(port_a, hSen_a.port_a)
    annotation (Line(points={{100,-60},{70,-60}}, color={0,127,255}));
  connect(hSen_a.port_b, mSen_flow.port_a)
    annotation (Line(points={{50,-60},{32,-60}}, color={0,127,255}));
  connect(mSen_flow.port_b, dp.port_a) annotation (Line(points={{12,-60},{-90,-60},
          {-90,0},{-80,0}}, color={0,127,255}));
  connect(PLR.y, boi.y) annotation (Line(points={{-53,-30},{-86,-30},{-86,9},{-41,
          9}}, color={0,0,127}));
  connect(exp.ports[1], boi.port_b) annotation (Line(points={{30,30},{34,30},{34,
          0},{-20,0}}, color={0,127,255}));
  connect(IntEHea.u, boi.Q_flow)
    annotation (Line(points={{58,50},{0,50},{0,9},{-19,9}}, color={0,0,127}));
  connect(boi.Q_flow, Q_flow)
    annotation (Line(points={{-19,9},{0,9},{0,80},{110,80}}, color={0,0,127}));
  connect(IntEHea.y, EHea)
    annotation (Line(points={{81,50},{110,50}}, color={0,0,127}));
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
end HeatingPlantIdeal;
