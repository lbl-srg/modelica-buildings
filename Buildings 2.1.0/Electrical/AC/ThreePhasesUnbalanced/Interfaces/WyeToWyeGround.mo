within Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces;
model WyeToWyeGround
  "This model represent a connection between wye to wye grounded"

  Terminal_n wye "Terminal Y" annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Terminal_n wyeg "Terminal Y with ground connection" annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  Connection3to4_n connection3to4 "Adapter between Termina3 and Terminal4"
    annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));
  Buildings.Electrical.AC.OnePhase.Basics.Ground ground "Ground reference"
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
equation

  Connections.branch(wye.phase[1].theta, connection3to4.terminal4.phase[4].theta);
  wye.phase[1].theta = connection3to4.terminal4.phase[4].theta;

  for i in 1:3 loop
    Connections.branch(wye.phase[i].theta, wyeg.phase[i].theta);
    wye.phase[i].theta = wyeg.phase[i].theta;
  end for;

  connect(wye, connection3to4.terminal3) annotation (Line(
      points={{-100,0},{-60,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(connection3to4.terminal4.phase[1], wyeg.phase[1]) annotation (Line(
      points={{-40,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(connection3to4.terminal4.phase[2], wyeg.phase[2]) annotation (Line(
      points={{-40,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(connection3to4.terminal4.phase[3], wyeg.phase[3]) annotation (Line(
      points={{-40,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(connection3to4.terminal4.phase[4], ground.terminal) annotation (Line(
      points={{-40,0},{-20,0},{-20,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (
  defaultComponentName="y2yg",
 Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{0,40},{0,0},{-30,-30}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{0,0},{30,-30}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{0,0},{0,-40}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.25),
        Line(
          points={{-8,-40},{8,-40}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.25),
        Line(
          points={{-6,-42},{6,-42}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.25),
        Line(
          points={{-4,-44},{4,-44}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.25)}),
    Documentation(revisions="<html>
<ul>
<li>
October 9, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
June 5, 2014, by Marco Bonvini:<br/>
Added model.
</li>
</ul>
</html>", info="<html>
<p>
Adapter from wye (Y) to wye grounded (Yg) connector.
A three-phase unbalanced connector has three AC single phase
connectors. Each AC single phase connector contains a the phase voltage,
which is measured
between the phase and the neutral. This model assures that the voltage of the neutral
cable is equal to zero.
</p>
</html>"));
end WyeToWyeGround;
