within Buildings.Controls.OBC.ChilledBeams.SetPoints;
block OperatingMode
  "Block with sequences for picking system operating mode"

  parameter Integer nSchRow = 4
    "Number of rows in schedule table";

  parameter Real schTab[nSchRow,2] = [0,1; 6,1; 18,1; 24,1]
    "Table defining schedule for enabling plant";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDetOcc
    "Detected occupancy"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeMod
    "System operating mode signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable enaSch(
    final table=schTab,
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final timeScale=3600)
    "Table defining when occupancy is expected"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Pass signal for occupied mode if zone is occupied; Else pass signal for unoccupiedScheduled or unoccupiedUnscheduled"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

protected
  parameter Integer modInt[3]={Buildings.Controls.OBC.ChilledBeams.Types.OperationModes.occupied,
      Buildings.Controls.OBC.ChilledBeams.Types.OperationModes.unoccupiedScheduled,
      Buildings.Controls.OBC.ChilledBeams.Types.OperationModes.unoccupiedUnscheduled}
    "Array of integer constants associated with each mode";

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(final k=Buildings.Controls.OBC.ChilledBeams.Types.OperationModes.occupied)
    "Constant integer for occupied mode"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Pass signal for unoccupiedScheduled if schedule indicates non-occupancy; Else pass unoccupiedUnscheduled"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=Buildings.Controls.OBC.ChilledBeams.Types.OperationModes.unoccupiedScheduled)
    "Constant integer for unoccupiedScheduled mode"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=Buildings.Controls.OBC.ChilledBeams.Types.OperationModes.unoccupiedUnscheduled)
    "Constant integer for unoccupiedUnscheduled mode"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=0.5)
    "Convert Real signal to Boolean"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

equation
  connect(enaSch.y[1],greThr. u)
    annotation (Line(points={{-68,-50},{-62,-50}},     color={0,0,127}));
  connect(conInt.y, intSwi.u1) annotation (Line(points={{2,30},{50,30},{50,8},{58,
          8}},      color={255,127,0}));
  connect(conInt1.y, intSwi1.u1) annotation (Line(points={{2,-20},{10,-20},{10,-42},
          {18,-42}},     color={255,127,0}));
  connect(conInt2.y, intSwi1.u3) annotation (Line(points={{2,-80},{10,-80},{10,-58},
          {18,-58}},   color={255,127,0}));
  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{42,-50},{50,-50},{50,-8},
          {58,-8}}, color={255,127,0}));
  connect(intSwi.y, yOpeMod) annotation (Line(points={{82,0},{120,0}},
               color={255,127,0}));
  connect(greThr.y, not1.u)
    annotation (Line(points={{-38,-50},{-32,-50}},
                                                 color={255,0,255}));
  connect(not1.y, intSwi1.u2)
    annotation (Line(points={{-8,-50},{18,-50}}, color={255,0,255}));
  connect(uDetOcc, intSwi.u2)
    annotation (Line(points={{-120,0},{58,0}},   color={255,0,255}));
  annotation (defaultComponentName="opeMod",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
            Text(
              extent={{-100,150},{100,110}},
              lineColor={0,0,255},
              textString="%name"),
            Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={28,108,200},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-50,20},{50,-20}},
              lineColor={28,108,200},
              fillColor={255,255,255},
              fillPattern=FillPattern.None,
          textString="sysOpeMod"),
        Text(
          extent={{-98,8},{-62,-8}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uDetOcc"),
        Text(
          extent={{60,8},{98,-10}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yOpeMod")}),                               Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
        Documentation(info="<html>
        <p>
        Sequences for calculating system operating mode in chilled beam systems.
        </p>
        <p>
        The block determines the system operating mode setpoint <code>yOpeMod</code>
        using the detected occupancy signal from the zones <code>uDetOcc</code> 
        and the expected occupancy schedule <code>schTab</code>.
        </p>
        <p>
        The operating mode setpoint and the enable signals based on the inputs 
        are as follows:
        <br>
        <table summary=\"allowedConfigurations\" border=\"1\">
          <thead>
            <tr>
              <th>Detected occupancy</th>
              <th>Expected occupancy schedule</th>
              <th>System operating mode</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Occupied</td>
              <td>-</td>
              <td>1</td>
            </tr>
            <tr>
              <td>Unoccupied</td>
              <td>Unoccupied</td>
              <td>2</td>
            </tr>
            <tr>
              <td>Unoccupied</td>
              <td>Occupied</td>
              <td>3</td>
            </tr>
          </tbody>
        </table>
        </p>
        </html>", revisions="<html>
<ul>
<li>
June 16, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end OperatingMode;
