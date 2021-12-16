within Buildings.HeatTransfer.Windows.BaseClasses;
partial model PartialWindowBoundaryCondition
  "Partial model for heat convection or radiation between a possibly shaded window that can be outside or inside the room"
  parameter Modelica.Units.SI.Area A "Heat transfer area of frame and window";
  parameter Real fFra "Fraction of window frame divided by total window area";
  final parameter Modelica.Units.SI.Area AFra=fFra*A "Frame area";
  final parameter Modelica.Units.SI.Area AGla=A - AFra "Glass area";

  parameter Boolean haveExteriorShade
    "Set to true if window has exterior shade (at surface a)"
    annotation (Dialog(group="Shading"));
  parameter Boolean haveInteriorShade
    "Set to true if window has interior shade (at surface b)"
    annotation (Dialog(group="Shading"));

  final parameter Boolean haveShade = haveExteriorShade or haveInteriorShade
    "Set to true if window system has a shade"
    annotation (Dialog(group="Shading"), Evaluate=true);
  parameter Boolean thisSideHasShade
    "Set to true if this side of the model has a shade"
    annotation (Dialog(group="Shading"), Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput uSha if haveShade
    "Input connector, used to scale the surface area to take into account an operable shading device, 0: unshaded; 1: fully shaded"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-116,72},{-100,88}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a air
    "Port that connects to the air (room or outside)"        annotation (Placement(transformation(extent={{-110,-10},
            {-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b glaUns
    "Heat port that connects to unshaded part of glass"
      annotation (Placement(transformation(extent={{90,10},{110,30}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b glaSha if haveShade
    "Heat port that connects to shaded part of glass"
    annotation (Placement(transformation(extent={{90,-30},{110,-10}})));

protected
  Modelica.Blocks.Math.Product proSha if haveShade
    "Product for shaded part of window"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  ShadingSignal shaSig(final haveShade=haveShade)
    "Conversion for shading signal"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a frame
    "Heat port at window frame"  annotation (Placement(transformation(extent={{60,-110},
            {80,-90}})));
initial equation
  assert(( thisSideHasShade and haveShade)  or (not thisSideHasShade),
    "Parameters \"thisSideHasShade\" and \"haveShade\" are not consistent. Check parameters");

equation
   connect(uSha, shaSig.u)
                       annotation (Line(
      points={{-120,80},{-92,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(proSha.u2, shaSig.y) annotation (Line(
      points={{-52,24},{-60,24},{-60,80},{-69,80}},
      color={0,0,127},
      smooth=Smooth.None));

    annotation (Dialog(group="Shading"),
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,2},{84,-2}},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-94,88},{-86,74}},
          textColor={0,0,127},
          textString="u"),              Text(
        extent={{-160,144},{140,104}},
        textString="%name",
        textColor={0,0,255}),
        Polygon(
          points={{-20,48},{-20,40},{20,52},{20,60},{-20,48}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,8},{-20,0},{20,12},{20,20},{-20,8}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,28},{-20,20},{20,32},{20,40},{-20,28}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-32},{-20,-40},{20,-28},{20,-20},{-20,-32}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-12},{-20,-20},{20,-8},{20,0},{-20,-12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-72},{-20,-80},{20,-68},{20,-60},{-20,-72}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-52},{-20,-60},{20,-48},{20,-40},{-20,-52}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,94},{2,-86}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{56,72},{84,-74}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{56,-74},{84,-90}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,86},{84,72}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Partial model for boundary conditions for convection and radiation for a window surface with or without shade,
that is outside or inside the room.
</p>
<p>
This allows using the model as a base class for windows with inside shade, outside shade, or no shade.
</p>
</html>", revisions="<html>
<ul>
<li>
March 2, 2015, by Michael Wetter:<br/>
Refactored model to allow a temperature dependent convective heat transfer
on the room side.
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/52\">52</a>.
</li>
<li>
August 25 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialWindowBoundaryCondition;
