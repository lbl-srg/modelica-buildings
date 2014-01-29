within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources;
model FixedVoltage

  Interfaces.Terminal_p terminal
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  parameter Modelica.SIunits.Frequency f(start=50) "Frequency of the source";
  parameter Modelica.SIunits.Voltage V(start=220) "RMS voltage of the source";
  parameter Modelica.SIunits.Angle Phi(start=0) "Phase shift of the source";
  parameter Boolean potentialReference = true "Serve as potential root"
     annotation (Evaluate=true, Dialog(group="Reference Parameters"));
  parameter Boolean definiteReference = false "Serve as definite root"
     annotation (Evaluate=true, Dialog(group="Reference Parameters"));
  parameter Modelica.SIunits.Angle angle120 = 2*Modelica.Constants.pi/3
    "Phase shift between the phase voltages";
  OnePhase.Sources.FixedVoltage Vphase[3](
    each f=f,
    each V=V,
    Phi={Phi, Phi + angle120, Phi + 2*angle120},
    potentialReference={potentialReference, potentialReference, potentialReference},
    definiteReference={definiteReference, false, false})
             annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Interfaces.Connection3to4_p connection3to4
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  OnePhase.Basics.Ground ground
    annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
equation
  Connections.branch(connection3to4.terminal4.phase[1].theta, connection3to4.terminal4.phase[4].theta);
  connection3to4.terminal4.phase[1].theta = connection3to4.terminal4.phase[4].theta;
  for i in 1:3 loop
    Connections.branch(connection3to4.terminal3.phase[i].theta, connection3to4.terminal4.phase[i].theta);
    connection3to4.terminal3.phase[i].theta = connection3to4.terminal4.phase[i].theta;
  end for;

  connect(connection3to4.terminal3, terminal) annotation (Line(
      points={{60,6.66134e-16},{80,6.66134e-16},{80,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Vphase[1].terminal, connection3to4.terminal4.phase[1]) annotation (Line(
      points={{-10,6.66134e-16},{20,6.66134e-16},{20,0},{40,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Vphase[2].terminal, connection3to4.terminal4.phase[2]) annotation (Line(
      points={{-10,6.66134e-16},{10,6.66134e-16},{10,0},{40,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Vphase[3].terminal, connection3to4.terminal4.phase[3]) annotation (Line(
      points={{-10,6.66134e-16},{40,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ground.terminal, connection3to4.terminal4.phase[4]) annotation (Line(
      points={{20,-40},{20,4.44089e-16},{40,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
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
          lineColor={0,120,120},
          textString="%name = %V")}));
end FixedVoltage;
