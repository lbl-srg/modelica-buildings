within Buildings.HeatTransfer.Windows;
model InteriorHeatTransfer
  "Model for heat convection at the interior surface of a window that may have a shading device"
  extends BaseClasses.PartialConvection(final thisSideHasShade=haveInteriorShade);
  Buildings.HeatTransfer.Windows.BaseClasses.InteriorConvectionCoefficient
    conCoeGla(                                          final A=AGla)
    "Model for the inside convective heat transfer coefficient of the glass"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Buildings.HeatTransfer.Windows.BaseClasses.InteriorConvectionCoefficient
    conCoeFra(                                          final A=AFra)
    "Model for the inside convective heat transfer coefficient of the frame"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

  Interfaces.RadiosityInflow JInRoo "Incoming radiosity of window construction"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Interfaces.RadiosityOutflow JOutRoo
    "Outgoing radiosity of window construction"
    annotation (Placement(transformation(extent={{-94,-50},{-114,-30}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a sha if
      windowHasShade "Heat port to shade"
    annotation (Placement(transformation(extent={{-42,-110},{-22,-90}})));
protected
  Modelica.Blocks.Math.Sum sumJ(nin=if windowHasShade then 2 else 1)
    "Sum of radiosity fom glass to outside"
    annotation (Placement(transformation(extent={{20,20},{0,40}})));
equation
  connect(conCoeFra.GCon, conFra.Gc) annotation (Line(
      points={{1,-70},{40,-70},{40,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoeGla.GCon, proUns.u2) annotation (Line(
      points={{-69,50},{8,50},{8,74},{18,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoeGla.GCon, proSha.u1) annotation (Line(
      points={{-69,50},{-56,50},{-56,36},{-52,36}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(JInRoo, radShaOut.JIn) annotation (Line(
      points={{-100,-80},{-72,-80},{-72,-34},{-41,-34}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(shade.sha, sha) annotation (Line(
      points={{7.4,-29.8},{7.4,-84},{-32,-84},{-32,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(JInUns, sumJ.u[1]) annotation (Line(
      points={{110,60},{32,60},{32,30},{22,30}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(shade.JOut_air, sumJ.u[2]) annotation (Line(
      points={{-1,-28},{-8,-28},{-8,14},{32,14},{32,30},{22,30}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(sumJ.y, JOutRoo) annotation (Line(
      points={{-1,30},{-14,30},{-14,-8},{-86,-8},{-86,-40},{-104,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
defaultComponentName="intHeaTra",
Documentation(info="<html>
<p>
Model for the convective heat transfer between a window shade, a window surface
and the room air.
This model is applicable for the room-facing surface of a window system and 
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
June 27, 2013, by Michael Wetter:<br/>
Changed model because the outflowing radiosity has been changed to be a non-negative quantity.
See track issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>.
</li>
<li>
October 25 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics));
end InteriorHeatTransfer;
