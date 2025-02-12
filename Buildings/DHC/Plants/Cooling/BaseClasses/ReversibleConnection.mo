within Buildings.DHC.Plants.Cooling.BaseClasses;
model ReversibleConnection
  "A connection that supports reversible flow with a pump and a valve"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final allowFlowReversal=true);

  parameter Modelica.Units.SI.MassFlowRate mTan_flow_nominal(min=0)
    "Nominal mass flow rate for CHW tank branch";
  parameter Modelica.Units.SI.PressureDifference dpPum_nominal
    "Nominal pressure difference for supply pump sizing";
  parameter Modelica.Units.SI.PressureDifference dpVal_nominal
    "Nominal pressure difference for return valve sizing";
  parameter Modelica.Units.SI.ThermodynamicTemperature T_start
    "Start temperature"
   annotation(Dialog(tab = "Initialization"));

  Modelica.Blocks.Interfaces.RealOutput PEle(
    final quantity="Power",
    final unit="W")
    "Estimated power consumption" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,50}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,60})));
  Modelica.Blocks.Interfaces.RealInput yPum(final unit="1")
    "Normalized speed signal for pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,70}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,60})));
  Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y pum(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final addPowerToMedium=false,
    final dp_nominal=dpPum_nominal) "Supply pump"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Fluid.FixedResistances.CheckValve cheVal(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=0.1*dpPum_nominal,
    final dpFixed_nominal=0) "Check valve"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent val(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mTan_flow_nominal,
    final dpValve_nominal=dpVal_nominal,
    y_start=0)
    "Valve that throttles CHW from the supply line to the tank"
    annotation (Placement(transformation(extent={{20,-40},{0,-20}})));
  Modelica.Blocks.Interfaces.RealInput yVal(final unit="1")
    "Normalized flow signal for valve" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-70}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-60})));

protected
  Buildings.Fluid.FixedResistances.Junction jun1(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=30,
    T_start=T_start,
    m_flow_nominal={-mTan_flow_nominal,m_flow_nominal,-m_flow_nominal},
    dp_nominal={0,0,0}) "Junction" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-70,0})));
  Buildings.Fluid.FixedResistances.Junction jun2(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=30,
    T_start=T_start,
    m_flow_nominal={-m_flow_nominal,-mTan_flow_nominal,m_flow_nominal},
    dp_nominal={0,0,0}) "Junction" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={70,0})));

equation
  connect(pum.port_b, jun2.port_1)
    annotation (Line(points={{20,50},{70,50},{70,10}}, color={0,127,255}));
  connect(jun2.port_3, port_b) annotation (Line(points={{80,-1.77636e-15},{90,-1.77636e-15},
          {90,0},{100,0}}, color={0,127,255}));
  connect(val.port_a, jun2.port_2)
    annotation (Line(points={{20,-30},{70,-30},{70,-10}}, color={0,127,255}));
  connect(jun1.port_3, port_a) annotation (Line(points={{-80,5.55112e-16},{-90,5.55112e-16},
          {-90,0},{-100,0}}, color={0,127,255}));
  connect(jun1.port_1, val.port_b)
    annotation (Line(points={{-70,-10},{-70,-30},{0,-30}}, color={0,127,255}));
  connect(pum.y, yPum)
    annotation (Line(points={{10,62},{10,70},{-110,70}}, color={0,0,127}));
  connect(yVal, val.y) annotation (Line(points={{-110,-70},{-20,-70},{-20,-10},{
          10,-10},{10,-18}}, color={0,0,127}));
  connect(pum.P, PEle) annotation (Line(points={{21,59},{90,59},{90,50},{110,50}},
        color={0,0,127}));
  connect(jun1.port_2, cheVal.port_a)
    annotation (Line(points={{-70,10},{-70,50},{-40,50}}, color={0,127,255}));
  connect(cheVal.port_b, pum.port_a)
    annotation (Line(points={{-20,50},{0,50}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This model implements a piping connection for reversible mass flow rate between the storage plant
and the district network.
</p>
</html>", revisions="<html>
<ul>
<li>
March 22, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"), defaultComponentName = "revCon", Icon(graphics={     Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-80,40},{80,-40}}, lineColor={28,108,200}),
        Line(points={{-100,0},{-80,0}},   color={28,108,200}),
        Ellipse(
          extent={{20,60},{60,20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,-40},{24,-30},{24,-50},{40,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,-40},{56,-30},{56,-50},{40,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{60,40},{40,60},{40,20},{60,40}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{80,0},{100,0}},     color={28,108,200}),
        Polygon(
          points={{-6,2},{2.74617e-16,-16},{-12,-16},{-6,2}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={2,44},
          rotation=-90),
        Line(points={{-14,50},{-54,50}}, color={0,127,255}),
        Line(points={{4,-30},{-36,-30}}, color={0,127,255}),
        Polygon(
          points={{-2,6},{16,0},{16,12},{-2,6}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={-52,-36},
          rotation=360)}));
end ReversibleConnection;
