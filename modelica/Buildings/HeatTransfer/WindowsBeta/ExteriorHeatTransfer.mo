within Buildings.HeatTransfer.WindowsBeta;
model ExteriorHeatTransfer
  "Model for heat convection at the exterior surface of a window that may have a shading device"
  extends BaseClasses.PartialConvection(final thisSideHasShade=haveExteriorShade);
  Modelica.Blocks.Interfaces.RealInput vWin "Wind speed"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-116,32},{-100,48}})));
  Buildings.HeatTransfer.WindowsBeta.BaseClasses.ExteriorConvectionCoefficient
    conCoeGla(                                          final A=AGla)
    "Model for the outside convective heat transfer coefficient of the glass"
    annotation (Placement(transformation(extent={{-84,40},{-64,60}})));
  Buildings.HeatTransfer.WindowsBeta.BaseClasses.ExteriorConvectionCoefficient
    conCoeFra(                                          final A=AFra)
    "Model for the outside convective heat transfer coefficient of the frame"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
 Radiosity.OutdoorRadiosity radOut(
   final A=AGla, F_sky=F_sky,
    linearize=linearize) "Outdoor radiosity"
    annotation (Placement(transformation(extent={{-72,-70},{-52,-50}})));
 Modelica.Blocks.Interfaces.RealInput f_clr(min=0, max=1)
    "Fraction of sky that is clear"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-116,-88},{-100,-72}})));
  parameter Real F_sky(min=0, max=1)
    "View factor from receiving surface to sky";
equation
  assert(-1E-10<F_sky and 1.00001 > F_sky,
         "View factor to sky is out of range. F_sky = " + realString(F_sky)
         + "\n   Check parameters.");

  connect(vWin, conCoeGla.v)
                           annotation (Line(
      points={{-120,40},{-90,40},{-90,50},{-86,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vWin, conCoeFra.v) annotation (Line(
      points={{-120,40},{-90,40},{-90,-70},{-22,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoeFra.GCon, conFra.Gc) annotation (Line(
      points={{1,-70},{40,-70},{40,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoeGla.GCon, proSha.u1) annotation (Line(
      points={{-63,50},{-56,50},{-56,36},{-52,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoeGla.GCon, proUns.u2) annotation (Line(
      points={{-63,50},{8,50},{8,74},{18,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radOut.f_clr,f_clr)  annotation (Line(
      points={{-74,-60},{-120,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radOut.JOut, radShaOut.JIn) annotation (Line(
      points={{-51,-60},{-46,-60},{-46,-34},{-41,-34}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(air, radOut.heatPort) annotation (Line(
      points={{-100,5.55112e-16},{-90,5.55112e-16},{-90,0},{-80,0},{-80,-54},{
          -72,-54}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Text(
          extent={{-94,48},{-52,32}},
          lineColor={0,0,127},
          textString="vWind"), Ellipse(
          extent={{-110,110},{-90,90}},
          lineColor={255,255,0},
          fillColor={255,213,170},
          fillPattern=FillPattern.Sphere),
        Text(
          extent={{-94,-72},{-52,-88}},
          lineColor={0,0,127},
          textString="f_clr")}),
           Documentation(info="<html>
<p>
Model for the convective heat transfer between a window shade, a window surface
and the room air.
This model is applicable for the outside-facing surface of a window system and 
can be used with the model
<a href=\"modelica://Buildings.HeatTransfer.WindowsBeta.Window\">
Buildings.HeatTransfer.WindowsBeta.Window</a>.
</p>
<p>
This model adds the convective heat transfer coefficient to its base model.
</p>
</html>", revisions="<html>
<ul>
<li>
October 25 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ExteriorHeatTransfer;
