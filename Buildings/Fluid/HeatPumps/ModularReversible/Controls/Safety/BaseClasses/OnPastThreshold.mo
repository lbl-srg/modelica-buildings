within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses;
block OnPastThreshold
  "Returns true if the device stays on for longer than a threshold time"
  extends Modelica.Blocks.Interfaces.BooleanSISO;

  parameter Modelica.Units.SI.Time minOnTime
    "Minimal time the device is turned on or off";
  Modelica.Blocks.Logical.Timer runTim
    "Counts the seconds the heat pump is locked still"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold runTimGreMin(final threshold=
        minOnTime) "Checks if the on-time is greater than the minimal on-time"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(runTimGreMin.y, y)
    annotation (Line(points={{41,0},{110,0}}, color={255,0,255}));
  connect(u,runTim. u) annotation (
    Line(points={{-120,0},{-42,0}}, color={255,0,255}));
  connect(runTim.y, runTimGreMin.u)
    annotation (Line(points={{-19,0},{18,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={
      Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Ellipse(extent={{-80,80},{80,-80}}, lineColor={160,160,164}),
        Line(points={{0,80},{0,60}}, color={160,160,164}),
        Line(points={{80,0},{60,0}}, color={160,160,164}),
        Line(points={{0,-80},{0,-60}}, color={160,160,164}),
        Line(points={{-80,0},{-60,0}}, color={160,160,164}),
        Line(points={{37,70},{26,50}}, color={160,160,164}),
        Line(points={{70,38},{49,26}}, color={160,160,164}),
        Line(points={{71,-37},{52,-27}}, color={160,160,164}),
        Line(points={{39,-70},{29,-51}}, color={160,160,164}),
        Line(points={{-39,-70},{-29,-52}}, color={160,160,164}),
        Line(points={{-71,-37},{-50,-26}}, color={160,160,164}),
        Line(points={{-71,37},{-54,28}}, color={160,160,164}),
        Line(points={{-38,70},{-28,51}}, color={160,160,164}),
        Line(
          points={{0,0},{-50,50}},
          thickness=0.5),
        Line(
          points={{0,0},{40,0}},
          thickness=0.5)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
  This block delays a true signal and only returns true
  if the device stays on (true) for longer than a threshold time.
  If the device is switched off before the threshold time,
  this block continues returning false.
</p>
<p>
  This block is used to check the mimimal on- or off-time of a device.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Renaming according to Buildings guideline (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end OnPastThreshold;
