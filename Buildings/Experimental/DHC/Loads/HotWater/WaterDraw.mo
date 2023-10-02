within Buildings.Experimental.DHC.Loads.HotWater;
model WaterDraw "A model for hot water draws from fixture(s)"
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.MassFlowRate mHot_flow_nominal "Nominal hot water flow rate to fixture";

  Modelica.Fluid.Interfaces.FluidPort_a port_hot(
    redeclare package Medium = Medium) "Port for hot water supply to fixture"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Fluid.Sources.MassFlowSource_T sinHot(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Sink for hot water supply"
    annotation (Placement(transformation(extent={{-46,-10},{-66,10}})));
  Modelica.Blocks.Math.Gain gaiDhw(final k=-mHot_flow_nominal) "Gain for multiplying domestic hot water schedule"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,60})));
  Modelica.Blocks.Interfaces.RealInput yHotWat(final min=0, final unit="1")
    "Hot water to fixture draw fraction" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,60}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,60})));
equation
  connect(yHotWat, gaiDhw.u)
    annotation (Line(points={{-110,60},{-82,60}}, color={0,0,127}));
  connect(port_hot, sinHot.ports[1])
    annotation (Line(points={{-100,0},{-66,0}}, color={0,127,255}));
  connect(sinHot.m_flow_in, gaiDhw.y) annotation (Line(points={{-44,8},{-20,8},{
          -20,60},{-59,60}}, color={0,0,127}));
  annotation (
  defaultComponentName="watDra",
  Documentation(info="<html>
<p>
This model implements a hot water sink, representing one or several fixtures.
</p>
<p>
Input to the model is the flow rate of hot water draw, specified as an input fraction 
of a nominal value.
</p>
</html>", revisions="<html>
<ul>
<li>
September 11, 2023 by David Blum:<br/>
Updated for release.
</li>
<li>
October 20, 2022 by Dre Helmns:<br/>
Initial Implementation.
</li>
</ul>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Polygon(
          points={{-7.728,38.2054},{-25.772,18.1027},{-25.772,-24.6152},{0,
              -57.2823},{25.772,-24.6152},{25.772,18.1027},{7.728,38.2054},{0,
              53.2823},{-7.728,38.2054}},
          lineColor={28,108,200},
          lineThickness=0.5,
          smooth=Smooth.Bezier,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-70,70},{70,-70}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=1),
      Text(
          extent={{-147,143},{153,103}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WaterDraw;
