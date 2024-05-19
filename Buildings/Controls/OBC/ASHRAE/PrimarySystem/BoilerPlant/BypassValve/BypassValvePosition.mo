within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.BypassValve;
block BypassValvePosition
  "Sequence for controlling minimum flow bypass valve position"

  parameter Integer nPum = 2
    "Number of pumps";

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType= Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";

  parameter Real k(
    final min=0,
    final unit="1",
    displayUnit="1") = 1
    "Gain of controller";

  parameter Real Ti(
    final min=0,
    final unit="s",
    displayUnit="s",
    final quantity="time") = 0.5
    "Time constant of integrator block";

  parameter Real Td(
    final min=0,
    final unit="s",
    displayUnit="s",
    final quantity="time") = 0.1
    "Time constant of derivative block";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumSta[nPum]
    "Input signals indicating pump statuses"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWat_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured hot-water flow-rate through primary circuit"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatMinSet_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Calculated hot water minimum flow setpoint through boilers"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMinBypValPos(
    final unit="1",
    displayUnit="1",
    final min=0)
    "Minimum bypass valve position for condensation control in non-condensing boilers"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yBypValPos(
    final unit="1",
    displayUnit="1",
    final min=0)
    "Bypass valve opening position"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Difference between measured flowrate and minimum flow setpoint"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nPum)
    "Block to detect if any of the pumps are proved ON"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));

  Buildings.Controls.OBC.CDL.Reals.Divide div
    "Normalize measured hot water flowrate"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=0)
    "Constant Real source"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

  Buildings.Controls.OBC.CDL.Reals.Max max
    "Ensure bypass valve position is greater than lower limit for condensation control"
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=1e-6)
    "Prevent division by zero"
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));

  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=1,
    final yMin=0,
    xi_start=1,
    reverseActing=false)
    "PID loop to regulate flow through primary loop using bypass valve"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Reset PID loop when it is activated"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

equation

  connect(mulOr.u[1:nPum], uPumSta) annotation (Line(points={{-72,0},{-120,0}},
                                  color={255,0,255}));

  connect(uMinBypValPos, max.u2) annotation (Line(points={{-120,-60},{50,-60},{50,
          -36},{68,-36}}, color={0,0,127}));
  connect(max.y, yBypValPos)
    annotation (Line(points={{92,-30},{120,-30}}, color={0,0,127}));
  connect(VHotWatMinSet_flow, addPar.u)
    annotation (Line(points={{-120,80},{-72,80}}, color={0,0,127}));
  connect(addPar.y, div.u2) annotation (Line(points={{-48,80},{-40,80},{-40,34},
          {-22,34}}, color={0,0,127}));
  connect(con.y, conPID.u_s)
    annotation (Line(points={{2,70},{18,70}},   color={0,0,127}));
  connect(div.y, conPID.u_m)
    annotation (Line(points={{2,40},{30,40},{30,58}},   color={0,0,127}));
  connect(mulOr.y, edg.u) annotation (Line(points={{-48,0},{-22,0}},
                    color={255,0,255}));
  connect(edg.y, conPID.trigger)
    annotation (Line(points={{2,0},{24,0},{24,58}}, color={255,0,255}));

  connect(conPID.y, max.u1) annotation (Line(points={{42,70},{50,70},{50,-24},{68,
          -24}}, color={0,0,127}));
  connect(sub2.y, div.u1) annotation (Line(points={{-48,40},{-28,40},{-28,46},{-22,
          46}}, color={0,0,127}));
  connect(VHotWatMinSet_flow,sub2. u1) annotation (Line(points={{-120,80},{-80,80},
          {-80,46},{-72,46}}, color={0,0,127}));
  connect(VHotWat_flow,sub2. u2) annotation (Line(points={{-120,40},{-80,40},{-80,
          34},{-72,34}}, color={0,0,127}));
annotation (defaultComponentName="bypValPos",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
    graphics={Rectangle(
                extent={{-100,100},{100,-100}},
                lineColor={28,108,200},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-70,20},{70,-20}},
                textColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.None,
                textString="bypValPos"),
              Text(
                extent={{-100,146},{100,108}},
                textColor={0,0,255},
                textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
    <p>
    Control sequence for bypass circuit valve position <code>yBypValPos</code>
    for boiler plant loop.
    </p>
    <ul>
    <li>
    The bypass valve is enabled when any of the hot-water supply pumps are proven on
    <code>uPumSta = true</code>, and disabled otherwise.
    </li>
    <li>
    When enabled, a PID control loop modulates the bypass valve to maintain
    a primary circuit flow rate of <code>VHotWatMinSet_flow</code>, calculated in class
    <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.MinimumFlowSetpoint\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.MinimumFlowSetpoint</a>.
    </li>
    <li>
    When all the pumps are not proved on <code>uPumSta = false</code>, the valve
    is fully opened.
    </li>
    <li>
    When a non-condensing boiler is enabled, the bypass valve position is set to the
    higher value between the signal generated by the PID loop, and the minimum valve
    position for condensation control <code>uMinBypValPos</code>.
    </li>
    </ul>
    </html>", revisions="<html>
    <ul>
    <li>
    August 17, 2020, by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end BypassValvePosition;
