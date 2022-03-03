within Buildings.Experimental.DHC.Loads.Steam.BaseClasses;
model ValveSelfActing "Ideal pressure reducing valve for steam heating systems"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  parameter Modelica.Units.SI.Pressure pb_nominal(displayUnit="Pa", min=100)
    "Nominal outlet pressure" annotation (Dialog(group="Nominal condition"));

  Buildings.Fluid.Movers.BaseClasses.IdealSource ideSou(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final dp_start=pb_nominal,
    final m_flow_start=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final show_T=show_T,
    final control_m_flow=false,
    final control_dp=true) "Ideal source controlling dp"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.RealExpression pbSet(final y=pb_nominal)
    "Downstream pressure setpoint"
    annotation (Placement(transformation(extent={{-80,46},{-60,66}})));
  Modelica.Blocks.Math.Add add(k1=-1)
    "Calculating dp required"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Fluid.Sensors.Pressure pUp(redeclare final package Medium = Medium)
    "Pressure sensor"
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
equation
  connect(port_a, ideSou.port_a)
    annotation (Line(points={{-100,0},{0,0}}, color={0,127,255}));
  connect(ideSou.port_b, port_b)
    annotation (Line(points={{20,0},{100,0}}, color={0,127,255}));
  connect(pbSet.y, add.u1)
    annotation (Line(points={{-59,56},{-22,56}}, color={0,0,127}));
  connect(add.y, ideSou.dp_in)
    annotation (Line(points={{1,50},{16,50},{16,8}}, color={0,0,127}));
  connect(ideSou.port_a, pUp.port)
    annotation (Line(points={{0,0},{-60,0},{-60,20}}, color={0,127,255}));
  connect(pUp.p, add.u2) annotation (Line(points={{-49,30},{-28,30},{-28,44},{-22,
          44}}, color={0,0,127}));
  annotation (
    defaultComponentName="prv",
    Documentation(info="<html>
<p>
This is the model of self-acting control valve that automatically adjusts  
the diameter of valve  orifice to reduce the unregulated inlet pressure to a 
constant or reduced outlet pressure. 

</p>
<h4>Implementation</h4>
<p>
To simplify the complex relationships of the valve opening <code>(y_actual), 
m_flow</code> and <code>dp</code> for compressible medium (such as steam), 
this self-acting valve model is implemented using the fictitious pipe model 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.IdealSource\">
Buildings.Fluid.Movers.BaseClasses.IdealSource</a>, that is used as a base class
for a pressure source or to prescribe a mass flow rate. 

The model maintains the <code>dp</code> based on the user specified downstream pressure 
value <code>(pb_nominal)</code>. This model assues the <code>dp</code> 
across the valve to be independent of the <code>m_flow</code>.   

</p>
</html>", revisions="<html>
<ul>
<li>
March 2, 2022 by Saranya Anbarasu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-52,40},{68,-40}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-52,40},{68,-40}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-32,80},{30,34}},
          lineColor={0,0,0},
          fillColor={160,160,160},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,56},{34,8}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{0,0},{-76,60},{-76,-60},{0,0}},
          lineColor={0,0,0},
          fillColor=DynamicSelect({0,0,0}, y*{255,255,255}),
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,0},{76,60},{76,-60},{0,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-32,56},{30,56}}, color={0,0,0}),
        Line(points={{0,0},{0,56}}, color={0,0,0}),
        Line(points={{0,80},{0,100}}, color={0,0,0}),
        Line(points={{0,100},{56,100}}, color={0,0,0}),
        Line(points={{56,100},{0,0}}, color={0,0,0})}));
end ValveSelfActing;
