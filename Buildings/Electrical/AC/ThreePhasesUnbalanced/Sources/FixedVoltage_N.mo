within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources;
model FixedVoltage_N "Fixed voltage source with neutral cable"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.PartialSource_N;
  parameter Modelica.Units.SI.Frequency f(start=60) "Frequency of the source";
  parameter Modelica.Units.SI.Voltage V(start=480) "RMS voltage of the source";
  parameter Modelica.Units.SI.Angle phiSou=0 "Phase shift of the source";
  parameter Boolean potentialReference = true
    "Serve as potential root for the reference angle theta"
     annotation (Evaluate=true, Dialog(group="Reference Parameters"));
  parameter Boolean definiteReference = false
    "Serve as definite root for the reference angle theta"
     annotation (Evaluate=true, Dialog(group="Reference Parameters"));
  constant Modelica.Units.SI.Angle angle120=2*Modelica.Constants.pi/3
    "Phase shift between the phase voltages";
  OnePhase.Sources.FixedVoltage vPhase[3](
    each f=f,
    phiSou={phiSou, phiSou + angle120, phiSou + 2*angle120},
    potentialReference={potentialReference, potentialReference, potentialReference},
    definiteReference={definiteReference, false, false},
    each V=V/sqrt(3)) "Voltage sources on the three-phase"
             annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
equation

  connect(vPhase[1].terminal, terminal.phase[1]) annotation (Line(
      points={{-10,0},{20,0},{20,0.05},{100.05,0.05}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(vPhase[2].terminal, terminal.phase[2]) annotation (Line(
      points={{-10,0},{10,0},{10,0.05},{100.05,0.05}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(vPhase[3].terminal, terminal.phase[3]) annotation (Line(
      points={{-10,0},{45,0},{45,0.05},{100.05,0.05}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (
  defaultComponentName="sou",
 Icon(graphics={
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(
          points={{-34,0},{-14,40},{6,0},{26,-40},{46,0}},
          color={120,120,120},
          smooth=Smooth.Bezier),          Line(
          points={{-44,0},{-24,40},{-4,0},{16,-40},{36,0}},
          color={0,0,0},
          smooth=Smooth.Bezier),          Line(
          points={{-24,0},{-4,40},{16,0},{36,-40},{56,0}},
          color={215,215,215},
          smooth=Smooth.Bezier),
        Line(
          points={{60,0},{90,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-120,100},{120,60}},
          textColor={0,0,0},
          textString="%name"),
        Text(
          extent={{-120,-60},{120,-100}},
          textColor={0,0,0},
          textString="V = %V")}),
    Documentation(info="<html>
<p>
This is a constant voltage source, specifying the complex
voltage by the RMS voltage and the phase shift. The model has also
the neutral cable, connected to a ground reference by default.
</p>
<p>
The parameters <code>potentialReference</code> and <code>definiteReference</code>
are used to define if the source model should be selected as source for
the reference angles <code>theta</code> or not.
More information about overdetermined connectors can be found
in <a href=\"#Olsson2008\">Olsson Et Al. (2008)</a>.
</p>

<h4>References</h4>
<p>
<a name=\"Olsson2008\"/>
Hans Olsson, Martin Otter, Sven Erik Mattson and Hilding Elmqvist.<br/>
<a href=\"http://elib-v3.dlr.de/55892/1/otter2008-modelica-balanced-models.pdf\">
Balanced Models in Modelica 3.0 for Increased Model Quality</a>.<br/>
Proc. of the 7th Modelica Conference, Bielefeld, Germany, March 2008.
</p>
</html>", revisions="<html>
<ul>
<li>
February 26, 2016, by Michael Wetter:<br/>
Updated documentation for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/427\">issue 427</a>.
</li>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end FixedVoltage_N;
