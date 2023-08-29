within Buildings.Experimental.DHC.Loads.DHW.DELETE;
model AnnualScheduleDHWLoad
  "A model with an annual schedule of domestic water draws"
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.MassFlowRate mDhw_flow_nominal "Nominal doemstic hot water flow rate";

  Modelica.Fluid.Interfaces.FluidPort_a port_tw(redeclare package Medium = Medium) "Port for tempered water supply"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Fluid.Sources.MassFlowSource_T sinDhw(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Sink for domestic hot water supply"
    annotation (Placement(transformation(extent={{-46,-10},{-66,10}})));
  Modelica.Blocks.Math.Gain gaiDhw(k=-mDhw_flow_nominal) "Gain for multiplying domestic hot water schedule"
    annotation (Placement(transformation(extent={{60,10},{40,30}})));
  Modelica.Blocks.Sources.CombiTimeTable schDhw(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Heating/DHW/DHW_SingleApartment.mos"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic) "Domestic hot water fraction schedule"
    annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Modelica.Blocks.Continuous.Integrator watCon(k=-1) "Integrated hot water consumption"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Modelica.Blocks.Interfaces.RealOutput mDhw "Total hot water consumption"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
        iconTransformation(extent={{100,-60},{120,-40}})));
equation
  connect(gaiDhw.y,sinDhw. m_flow_in) annotation (Line(points={{39,20},{-20,20},
          {-20,8},{-44,8}},      color={0,0,127}));
  connect(watCon.u,gaiDhw. y) annotation (Line(points={{38,-80},{20,-80},{20,20},
          {39,20}},       color={0,0,127}));
  connect(watCon.y, mDhw)
    annotation (Line(points={{61,-80},{110,-80}}, color={0,0,127}));
  connect(sinDhw.ports[1], port_tw)
    annotation (Line(points={{-66,0},{-100,0}}, color={0,127,255}));
  connect(schDhw.y[1], gaiDhw.u)
    annotation (Line(points={{79,20},{62,20}}, color={0,0,127}));
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
          points={{-47.728,58.2054},{-65.772,38.1027},{-65.772,-4.6152},{-40,
              -37.2823},{-14.228,-4.6152},{-14.228,38.1027},{-32.272,58.2054},{
              -40,73.2823},{-47.728,58.2054}},
          lineColor={28,108,200},
          lineThickness=0.5,
          smooth=Smooth.Bezier,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-7.728,38.2054},{-25.772,18.1027},{-25.772,-24.6152},{0,
              -57.282},{25.772,-24.6152},{25.772,18.1027},{7.728,38.2054},{0,
              53.2823},{-7.728,38.2054}},
          lineColor={28,108,200},
          lineThickness=0.5,
          smooth=Smooth.Bezier,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{32.272,18.2054},{14.228,-1.8973},{14.228,-44.615},{40,
              -77.282},{65.772,-44.615},{65.772,-1.8973},{47.728,18.2054},{40,
              33.2823},{32.272,18.2054}},
          lineColor={28,108,200},
          lineThickness=0.5,
          smooth=Smooth.Bezier,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
      Text(
          extent={{-147,139},{153,99}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AnnualScheduleDHWLoad;
