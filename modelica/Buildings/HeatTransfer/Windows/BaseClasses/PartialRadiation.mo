within Buildings.HeatTransfer.Windows.BaseClasses;
partial block PartialRadiation
  "Partial model for variables and data used in radiation calculation"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  extends Buildings.HeatTransfer.Windows.BaseClasses.RadiationBaseData;

  ////////////////// Parameters that are not used by RadiationData
  parameter Boolean haveExteriorShade
    "Set to true if window has an exterior shade";
  parameter Boolean haveInteriorShade
    "Set to true if window has an interior shade";
  parameter Modelica.SIunits.Area AWin "Area of window";

  ////////////////// Derived parameters
  final parameter Boolean haveShade=haveExteriorShade or haveInteriorShade
    "Set to true if window has a shade" annotation (Evaluate=true);
  parameter Buildings.HeatTransfer.Windows.BaseClasses.RadiationData radDat(
    final N=N,
    final tauGlaSW=tauGlaSW,
    final rhoGlaSW_a=rhoGlaSW_a,
    final rhoGlaSW_b=rhoGlaSW_b,
    final tauShaSW_a=tauShaSW_a,
    final tauShaSW_b=tauShaSW_b,
    final rhoShaSW_a=rhoShaSW_a,
    final rhoShaSW_b=rhoShaSW_b)
    "Optical properties of window for different irradiation angles" annotation
    (Evaluate=true, Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Interfaces.RealInput uSha(min=0, max=1)
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
        transformation(extent={{-140,60},{-100,100}}),iconTransformation(extent
          ={{-130,65},{-100,95}})));
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

equation
  /* Current model assumes that the window only has either interior or exterior shading.
     Warn user if it has both interior and exterior shading working at the same time. 
     By adjusting the calcualtaion of coefficents, it is possible to allow both shading at the same time*/
  assert(not (haveExteriorShade and haveInteriorShade and uSha > 0),
    "Window radiation model does not support exterior and interior shade at the same time.");

  annotation (
    Documentation(info="<html>
The model calculates short-wave absorbance on the window. 
The calculations follow the description in Wetter (2004), Appendix A.4.3.

<h4>References</h4>
<ul>
<li>
Michael Wetter.<br>
<a href=\"http://simulationresearch.lbl.gov/wetter/download/mwdiss.pdf\">
Simulation-based Building Energy Optimization</a>.<br>
Dissertation. University of California at Berkeley. 2004.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
December 16, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(graphics),
    Icon(graphics={
        Text(
          extent={{-94,10},{-34,-32}},
          lineColor={0,0,127},
          textString="incAng"),
        Text(
          extent={{-100,90},{-50,68}},
          lineColor={0,0,127},
          textString="HDif"),
        Text(
          extent={{-100,52},{-44,28}},
          lineColor={0,0,127},
          textString="HDir"),
        Text(
          extent={{-32,-80},{22,-96}},
          lineColor={0,0,127},
          textString="uSha")}));
end PartialRadiation;
