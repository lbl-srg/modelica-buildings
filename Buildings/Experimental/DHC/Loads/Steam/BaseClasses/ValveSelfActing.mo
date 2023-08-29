within Buildings.Experimental.DHC.Loads.Steam.BaseClasses;
model ValveSelfActing "Ideal pressure reducing valve for steam heating systems"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final allowFlowReversal=false);
  parameter Modelica.Units.SI.Pressure pb_nominal(
    displayUnit="Pa",
    min=101325)
    "Nominal outlet pressure"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dp_start(displayUnit="Pa")=pb_nominal
    "Guess value of dp = port_a.p - port_b.p"
    annotation (Dialog(tab="Advanced"));

  Buildings.Fluid.Sensors.Pressure pUp(redeclare final package Medium = Medium)
    "Pressure sensor"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Utilities.Math.SmoothMax dpSet(final deltaX=0.5) "Pressure drop setpoint"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

protected
  Buildings.Fluid.Movers.BaseClasses.IdealSource ideSou(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final dp_start=dp_start,
    m_flow_start=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final show_T=show_T,
    final control_m_flow=false,
    final control_dp=true) "Ideal source controlling dp"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.RealExpression pbSet(final y=pb_nominal)
    "Downstream pressure setpoint"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(final k=0) "Zero"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dpReq "Calculating dp required"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

equation
  assert(dpReq.y > 0, "pb_nominal is set higher than the upstream pressure in "
  + getInstanceName() + ", which results in a negative pressure drop. 
  This is not typical of real systems and should be verified.", AssertionLevel.warning);

  connect(ideSou.port_b, port_b)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(pUp.port, ideSou.port_a)
    annotation (Line(points={{-80,50},{-80,0},{40,0}}, color={0,127,255}));
  connect(zer.y, dpSet.u1) annotation (Line(points={{-38,80},{12,80},{12,56},{
          18,56}},
                color={0,0,127}));
  connect(dpSet.y, ideSou.dp_in)
    annotation (Line(points={{41,50},{56,50},{56,8}}, color={0,0,127}));
  connect(port_a, ideSou.port_a)
    annotation (Line(points={{-100,0},{40,0}}, color={0,127,255}));
  connect(pUp.p, dpReq.u1) annotation (Line(points={{-69,60},{-28,60},{-28,56},{
          -22,56}}, color={0,0,127}));
  connect(pbSet.y, dpReq.u2) annotation (Line(points={{-39,40},{-28,40},{-28,44},
          {-22,44}}, color={0,0,127}));
  connect(dpReq.y, dpSet.u2) annotation (Line(points={{2,50},{10,50},{10,44},{
          18,44}}, color={0,0,127}));
    annotation (
    defaultComponentName="prv",
    Documentation(info="<html>
<p>
This is the model of self-acting control valve that automatically adjusts  
the diameter of valve  orifice to reduce the unregulated inlet pressure to a 
constant, reduced outlet pressure. 
</p>
<h4>Implementation</h4>
<p>
To simplify the complex relationships of the valve opening (<code>y_actual</code>), 
mass flow rate (<code>m_flow</code>), and change in pressure (<code>dp</code>) 
for compressible medium (such as steam), this model is implemented using an ideal source 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.IdealSource\">
Buildings.Fluid.Movers.BaseClasses.IdealSource</a>, that allows the pressure drop 
to be prescribed independently of mass flow rate. 
</p>
<p>
The model maintains <code>dp</code> based on the user specified downstream pressure 
value (<code>pb_nominal</code>), except for instances where the upstream pressure 
falls below <code>pb_nominal</code>. In these instances, the valve exibits no 
pressure drop (<code>dpSet = 0</code>) and asserts a warning. 
This model assumes that <code>dp</code> across the valve is independent of 
<code>m_flow</code>. This generally leads to a simplier set of equations.
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
          fillColor=DynamicSelect({0,0,0}, max(0, min(1, dpSet.y/pb_nominal))*{255,255,255}),
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
