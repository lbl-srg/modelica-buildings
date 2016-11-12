within Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces;
model WyeToWyeGround
  "This model represent a connection between wye to wye grounded"

  Terminal_n wye "Terminal Y" annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Terminal_n wyeg "Terminal Y with ground connection" annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  Connection3to3Ground_n connection3to4
    "Adapter between Termina3 and Terminal4"
    annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));
  Buildings.Electrical.AC.OnePhase.Basics.Ground ground "Ground reference"
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
equation
  connect(wye, connection3to4.terminal3)
    annotation (Line(points={{-100,0},{-60,0}},         color={0,120,120}));
  connect(connection3to4.terminal4, wyeg) annotation (Line(points={{-40,0},{28,0},
          {100,0}},           color={0,120,120}));
  connect(connection3to4.ground4, ground.terminal) annotation (Line(points={{-40.6,
          -6},{-20,-6},{-20,-20}}, color={0,120,120}));
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
February 26, 2016, by Michael Wetter:<br/>
Replaced <code>connection3to4</code> with new model.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
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
