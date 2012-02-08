within Buildings.HeatTransfer.Windows;
model ExteriorHeatTransfer
  "Model for heat convection at the exterior surface of a window that may have a shading device"
  extends BaseClasses.PartialConvection(final thisSideHasShade=haveExteriorShade);
  Modelica.Blocks.Interfaces.RealInput vWin "Wind speed"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-116,32},{-100,48}})));
  Buildings.HeatTransfer.Windows.BaseClasses.ExteriorConvectionCoefficient
    conCoeGla(                                          final A=AGla)
    "Model for the outside convective heat transfer coefficient of the glass"
    annotation (Placement(transformation(extent={{-84,40},{-64,60}})));
  Buildings.HeatTransfer.Windows.BaseClasses.ExteriorConvectionCoefficient
    conCoeFra(                                          final A=AFra)
    "Model for the outside convective heat transfer coefficient of the frame"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
 Radiosity.OutdoorRadiosity radOut(
   final A=AGla, vieFacSky=vieFacSky,
    linearize=linearizeRadiation) "Outdoor radiosity"
    annotation (Placement(transformation(extent={{-72,-72},{-52,-52}})));
  parameter Real vieFacSky(min=0, max=1)
    "View factor from receiving surface to sky";
  Modelica.Blocks.Interfaces.RealInput TBlaSky(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0) "Black body sky temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput TOut(final quantity="ThermodynamicTemperature",
                                            final unit = "K", min=0)
    "Outside temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-120,-92},{-100,-72}})));
equation
  assert(-1E-10<vieFacSky and 1.00001 > vieFacSky,
         "View factor to sky is out of range. vieFacSky = " + String(vieFacSky)
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
  connect(radOut.JOut, radShaOut.JIn) annotation (Line(
      points={{-51,-62},{-46,-62},{-46,-34},{-41,-34}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radOut.TBlaSky, TBlaSky) annotation (Line(
      points={{-74,-58},{-86,-58},{-86,-40},{-120,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radOut.TOut, TOut) annotation (Line(
      points={{-74,-66},{-86,-66},{-86,-80},{-120,-80}},
      color={0,0,127},
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
          extent={{-96,-70},{-66,-82}},
          lineColor={0,0,127},
          textString="TOut"),
        Text(
          extent={{-94,-34},{-54,-46}},
          lineColor={0,0,127},
          textString="TBlaSky")}),
defaultComponentName="extHeaTra",
           Documentation(info="<html>
<p>
Model for the convective heat transfer between a window shade, a window surface
and the room air.
This model is applicable for the outside-facing surface of a window system and 
can be used with the model
<a href=\"modelica://Buildings.HeatTransfer.Windows.Window\">
Buildings.HeatTransfer.Windows.Window</a>.
</p>
<p>
This model adds the convective heat transfer coefficient to its base model.
</p>
</html>", revisions="<html>
<ul>
<li>
February 8 2012, by Michael Wetter:<br>
Changed model to use new implementation of
<a href=\"modelica://Buildings.HeatTransfer.Radiosity.OutdoorRadiosity\">
Buildings.HeatTransfer.Radiosity.OutdoorRadiosity</a>.
This change leads to the use of the same equations for the radiative
heat transfer between window and ambient as is used for 
the opaque constructions.
</li>
<li>
October 25 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ExteriorHeatTransfer;
