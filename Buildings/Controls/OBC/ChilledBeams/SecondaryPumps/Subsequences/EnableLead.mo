within Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Subsequences;
block EnableLead
  "Sequence to enable or disable the lead pump of chilled beam systems"

  parameter Integer nVal(min=1)
    "Number of chilled water control valves on chilled beam manifolds";

  parameter Real valPosClo(
    final unit="1",
    displayUnit="1") = 0.05
    "Valve position at which it is deemed to be closed";

  parameter Real valPosOpe(
    final unit="1",
    displayUnit="1") = 0.1
    "Valve position at which it is deemed to be open";

  parameter Real valOpeThr(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 30
    "Minimum threshold time for which a valve has to be open to enable lead pump";

  parameter Real valCloThr(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 60
    "Minimum threshold time for which all valves have to be closed to disable lead pump";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uValPos[nVal](
    final unit=fill("1", nVal),
    displayUnit=fill("1", nVal))
    "Valve positions for chilled beam manifolds"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLea
    "Lead pump status"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys[nVal](
    final uLow=fill(valPosClo, nVal),
    final uHigh=fill(valPosOpe, nVal))
    "Determine if valves are opened or closed"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=valOpeThr)
    "Determine if valves have continuously been open for threshold time"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nVal)
    "Determine if any pumps are opened"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Enable or disable lead pump based on status of control valves"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1(
    final t=valCloThr)
    "Determine if valves have continuously been closed for threshold time"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));

equation
  connect(uValPos, hys.u)
    annotation (Line(points={{-120,0},{-82,0}}, color={0,0,127}));

  connect(mulOr.y, tim.u) annotation (Line(points={{-28,0},{-20,0},{-20,20},{-2,
          20}}, color={255,0,255}));

  connect(tim.passed, lat.u) annotation (Line(points={{22,12},{50,12},{50,0},{58,
          0}}, color={255,0,255}));

  connect(tim1.u, not1.y)
    annotation (Line(points={{18,-30},{12,-30}}, color={255,0,255}));

  connect(mulOr.y, not1.u) annotation (Line(points={{-28,0},{-20,0},{-20,-30},{-12,
          -30}}, color={255,0,255}));

  connect(tim1.passed, lat.clr) annotation (Line(points={{42,-38},{50,-38},{50,-6},
          {58,-6}}, color={255,0,255}));

  connect(lat.y, yLea)
    annotation (Line(points={{82,0},{120,0}}, color={255,0,255}));

  connect(hys.y, mulOr.u[1:nVal]) annotation (Line(points={{-58,0},{-56,0},{-56,0},
          {-52,0}},        color={255,0,255}));
annotation (
  defaultComponentName="enaLeaPum",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-92,14},{-58,-14}},
          textColor={0,0,127},
          textString="uValPos"),
        Text(
          extent={{66,12},{90,-12}},
          textColor={255,85,255},
          textString="yLea")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
  <p>
  Block that enables and disables lead pump for chilled water beam 
  systems.
  </p>
  <p>
  <ul>
  <li>
  The lead pump shall be enabled <code>yLea = true</code> when
  any of the chilled beam control valves are continuously open 
  (<code>uValPos &gt; valPosOpe</code>) for <code>valOpeThr</code>
  time.
  </li>
  <li>
  The lead pump shall be disabled when all the chilled beam control valves
  are continuously closed (<code>uValPos &lt; valPosClo</code>) for <code>valCloThr</code>
  time.
  </li>
  </ul>
  </p>
  </html>", revisions="<html>
<ul>
<li>
August 8, 2022, by Michael Wetter:<br/>
Set minimum attribute for parameter, and removed default value.
</li>
<li>
June 07, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableLead;
