within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources;
model FixedVoltage_N "Fixed voltage source with neutral cable"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.PartialSource_N;
  parameter Modelica.SIunits.Frequency f(start = 60) "Frequency of the source";
  parameter Modelica.SIunits.Voltage V(start = 480) "RMS voltage of the source";
  parameter Modelica.SIunits.Angle phiSou = 0 "Phase shift of the source";
  parameter Boolean potentialReference = true "Serve as potential root"
     annotation (Evaluate=true, Dialog(group="Reference Parameters"));
  parameter Boolean definiteReference = false "Serve as definite root"
     annotation (Evaluate=true, Dialog(group="Reference Parameters"));
  constant Modelica.SIunits.Angle angle120 = 2*Modelica.Constants.pi/3
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
      points={{-10,6.66134e-16},{20,6.66134e-16},{20,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(vPhase[2].terminal, terminal.phase[2]) annotation (Line(
      points={{-10,6.66134e-16},{10,6.66134e-16},{10,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(vPhase[3].terminal, terminal.phase[3]) annotation (Line(
      points={{-10,6.66134e-16},{100,6.66134e-16}},
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
          lineColor={0,0,0},
          textString="%name"),
        Text(
          extent={{-120,-60},{120,-100}},
          lineColor={0,0,0},
          textString="V = %V")}),
    Documentation(info="<html>
<p>
This is a constant voltage source, specifying the complex
voltage by the RMS voltage and the phase shift. The model has also
the neutral cable, connected to a ground reference by default.
</p>
<p>
Explain, or provide a link to an explanation, for the parameters *Reference.
</p>
</html>", revisions="<html>
<ul>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end FixedVoltage_N;
