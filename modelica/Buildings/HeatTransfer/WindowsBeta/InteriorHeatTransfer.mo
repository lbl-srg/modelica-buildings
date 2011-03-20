within Buildings.HeatTransfer.WindowsBeta;
model InteriorHeatTransfer
  "Model for heat convection at the interior surface of a window that may have a shading device"
  extends BaseClasses.PartialConvection(final thisSideHasShade=haveInteriorShade);
  Buildings.HeatTransfer.WindowsBeta.BaseClasses.InteriorConvectionCoefficient
    conCoeGla(                                          final A=AGla)
    "Model for the inside convective heat transfer coefficient of the glass"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Buildings.HeatTransfer.WindowsBeta.BaseClasses.InteriorConvectionCoefficient
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
  connect(JInUns, JOutRoo) annotation (Line(
      points={{110,60},{20,60},{20,4},{-76,4},{-76,-40},{-104,-40}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(shade.JOut_air, JOutRoo) annotation (Line(
      points={{-1,-28},{-8,-28},{-8,-54},{-68,-54},{-68,-40},{-104,-40}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(shade.sha, sha) annotation (Line(
      points={{7.4,-29.8},{7.4,-84},{-32,-84},{-32,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
defaultComponentName="intHeaTra",
Documentation(info="<html>
<p>
Model for the convective heat transfer between a window shade, a window surface
and the room air.
This model is applicable for the room-facing surface of a window system and 
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
</html>"),
    Icon(graphics));
end InteriorHeatTransfer;
