within Buildings.Experimental.DHC.Loads.HotWater;
model WaterDraw "A model for domestic water draws from fixture(s)"
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.MassFlowRate mTem_flow_nominal "Nominal tempered water flow rate to fixture";

  Modelica.Fluid.Interfaces.FluidPort_a port_tw(redeclare package Medium = Medium) "Port for tempered water supply"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Fluid.Sources.MassFlowSource_T sinTem(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Sink for tempered water supply"
    annotation (Placement(transformation(extent={{-46,-10},{-66,10}})));
  Modelica.Blocks.Math.Gain gaiDhw(k=-mTem_flow_nominal) "Gain for multiplying domestic hot water schedule"
    annotation (Placement(transformation(extent={{60,10},{40,30}})));
  Modelica.Blocks.Continuous.Integrator watCon(k=-1) "Integrated hot water consumption"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Modelica.Blocks.Interfaces.RealOutput MTem "Mass of tempered water consumed"
    annotation (Placement(transformation(extent={{100,-82},{120,-62}}),
        iconTransformation(extent={{100,-82},{120,-62}})));
  Modelica.Blocks.Interfaces.RealInput sch "Tempered water draw fraction"
    annotation (Placement(transformation(extent={{120,20},{100,40}}),
        iconTransformation(extent={{120,20},{100,40}})));
equation
  connect(gaiDhw.y,sinTem. m_flow_in) annotation (Line(points={{39,20},{-20,20},
          {-20,8},{-44,8}},      color={0,0,127}));
  connect(watCon.u,gaiDhw. y) annotation (Line(points={{38,-80},{20,-80},{20,20},
          {39,20}},       color={0,0,127}));
  connect(watCon.y,MTem)
    annotation (Line(points={{61,-80},{86,-80},{86,-72},{110,-72}},
                                                  color={0,0,127}));
  connect(sinTem.ports[1], port_tw)
    annotation (Line(points={{-66,0},{-100,0}}, color={0,127,255}));
  connect(sch, gaiDhw.u) annotation (Line(points={{110,30},{86,30},{86,20},{62,
          20}}, color={0,0,127}));
  annotation (preferredView="info",Documentation(info="<html>
<p>
This model is for connecting domestic hot water load schedules.
</p>
</html>", revisions="<html>
<ul>
<li>
October 20, 2022 by Dre Helmns:<br/>
Created load model.
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
