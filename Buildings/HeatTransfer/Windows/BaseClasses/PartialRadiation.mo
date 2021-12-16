within Buildings.HeatTransfer.Windows.BaseClasses;
partial block PartialRadiation
  "Partial model for variables and data used in radiation calculation"
  extends Modelica.Blocks.Icons.Block;
  extends Buildings.HeatTransfer.Windows.BaseClasses.RadiationBaseData;

  ////////////////// Parameters that are not used by RadiationData
  parameter Boolean haveExteriorShade
    "Set to true if window has an exterior shade";
  parameter Boolean haveInteriorShade
    "Set to true if window has an interior shade";
  parameter Modelica.Units.SI.Area AWin "Area of window";

  ////////////////// Derived parameters
  final parameter Boolean haveShade=haveExteriorShade or haveInteriorShade
    "Set to true if window has a shade" annotation (Evaluate=true);
  final parameter Buildings.HeatTransfer.Windows.BaseClasses.RadiationData
    radDat(
    final N=N,
    final tauGlaSol=tauGlaSol,
    final rhoGlaSol_a=rhoGlaSol_a,
    final rhoGlaSol_b=rhoGlaSol_b,
    final xGla=xGla,
    final tauShaSol_a=tauShaSol_a,
    final tauShaSol_b=tauShaSol_b,
    final rhoShaSol_a=rhoShaSol_a,
    final rhoShaSol_b=rhoShaSol_b)
    "Optical properties of window for different irradiation angles" annotation (
     Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Interfaces.RealInput uSha(min=0, max=1) if haveShade
    "Control signal for shading (0: unshaded; 1: fully shaded)" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120}),iconTransformation(
        extent={{-16,-16},{16,16}},
        rotation=90,
        origin={-2,-116})));
  Modelica.Blocks.Interfaces.RealInput HDif(quantity="RadiantEnergyFluenceRate",
      unit="W/m2") "Diffussive solar radiation" annotation (Placement(
        transformation(extent={{-140,60},{-100,100}}),iconTransformation(extent=
           {{-130,65},{-100,95}})));
  Modelica.Blocks.Interfaces.RealInput incAng(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Incident angle" annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-130,-25},
            {-100,5}})));
  Modelica.Blocks.Interfaces.RealInput HDir(quantity="RadiantEnergyFluenceRate",
      unit="W/m2") "Direct solar radiation" annotation (Placement(
        transformation(extent={{-140,20},{-100,60}}),iconTransformation(extent=
            {{-130,25},{-100,55}})));

protected
  Modelica.Blocks.Interfaces.RealInput uSha_internal(min=0, max=1)
    "Control signal for shading (0: unshaded; 1: fully shaded)";
initial equation
  /* Current model assumes that the window only has either an interior or exterior shade.
     Warn user if it has an interior and exterior shade.
     Allowing both shades at the same time would require rewriting part of the model. */
  assert(not (haveExteriorShade and haveInteriorShade),
    "Window radiation model does not support an exterior and interior shade at the same time.");
equation
  // Connect statement for conditionally removed connector uSha
  connect(uSha, uSha_internal);
  if (not haveShade) then
    uSha_internal = 0;
  end if;
  annotation (
    Documentation(info="<html>
The model calculates solar absorbance on the window.
The calculations follow the description in Wetter (2004), Appendix A.4.3.

<h4>References</h4>
<ul>
<li>
Michael Wetter.<br/>
<a href=\"http://simulationresearch.lbl.gov/wetter/download/mwdiss.pdf\">
Simulation-based Building Energy Optimization</a>.<br/>
Dissertation. University of California at Berkeley. 2004.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
December 12, 2011, by Wangda Zuo:<br/>
Add glass thickness as a parameter for radDat. It is needed by the claculation of property for uncoated glass.
</li>
<li>
February 2, 2010, by Michael Wetter:<br/>
Made connector <code>uSha</code> a conditional connector.
</li>
<li>
December 16, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{-92,0},{-62,-20}},
          textColor={0,0,127},
          textString="incAng"),
        Text(
          extent={{-94,84},{-70,70}},
          textColor={0,0,127},
          textString="HDif"),
        Text(
          extent={{-96,42},{-62,30}},
          textColor={0,0,127},
          textString="HDir"),
        Text(
          extent={{-32,-82},{22,-94}},
          textColor={0,0,127},
          textString="uSha"),
        Polygon(
          points={{-46,66},{-46,-10},{-6,-50},{-6,22},{-46,66}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{18,64},{18,-12},{58,-52},{58,20},{18,64}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-28,2},{-18,10},{-8,0},{2,10},{12,0},{22,10},{32,-2},{40,4},
              {34,4},{38,-2},{40,4},{38,4}},
          color={255,128,0},
          smooth=Smooth.None),
        Polygon(
          points={{38,-2},{34,4},{40,4},{38,-2}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{38,-4},{46,-14},{58,-4},{66,-14},{66,-14},{76,-4},{86,-16},{
              94,-10},{88,-10},{92,-16},{94,-10},{92,-10}},
          color={255,128,0},
          smooth=Smooth.None),
        Polygon(
          points={{92,-16},{88,-10},{94,-10},{92,-16}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-26,8},{-30,14},{-24,14},{-26,8}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,20},{-72,10},{-60,20},{-52,10},{-52,10},{-42,20},{-32,8},
              {-24,14},{-30,14},{-26,8},{-24,14},{-26,14}},
          color={255,128,0},
          smooth=Smooth.None)}));
end PartialRadiation;
