within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.SetPoints;
block BypassValvePosition
  "Block with sequences for calculating bypass valve position"

  parameter Integer nPum = 2
    "Number of pumps in the chilled water loop";

  parameter Real minPumSpe(
    final unit="1",
    displayUnit="1") = 0.1
    "Minimum pump speed";

  parameter Real dPumSpe(
    final unit="1",
    displayUnit="1") = 0.01
    "Value added to minimum pump speed to get upper hysteresis limit"
    annotation(Dialog(tab="Advanced"));

  parameter Real dPChiWatMax(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") = 50000
    "Maximum allowed differential pressure in the chilled water loop";

  parameter Real k(
    final unit="1",
    displayUnit="1") = 1
    "Gain of controller";

  parameter Real Ti(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 0.5
    "Time constant of integrator block"
    annotation(Dialog(enable = controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real Td(
    final unit="s",
    displayUnit="s",
    final quantity="Time",
    final min=0)=0.1
    "Time constant of derivative block"
    annotation(Dialog(enable = controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumSta[nPum]
    "Pump proven On signal"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
      iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatLoo(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Chilled water loop differential static pressure"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpe(
    final unit="1",
    displayUnit="1")
    "Pump speed"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yBypValPos(
    final unit="1",
    displayUnit="1")
    "Bypass valve position"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Real switch for regulating bypass valve position once all conditions are satisfied"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=minPumSpe + dPumSpe,
    final uHigh=minPumSpe + 2*dPumSpe)
    "Check if pump speed is at minimum"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Enable when pump speed is at minimum"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Regulate bypass valve position only when pump is enabled and at minimum speed"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Ensure bypass valve is open when no pumps are enabled and close it when any pump is enabled"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    "Constant real zero source"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=1)
    "Constant real one source"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    reverseActing=false)
    "PID controller for regulating differential pressure at or below max pressure setpoint"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=-dPChiWatMax,
    final k=1)
    "Find error in meaured differential pressure from maximum allowed value"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=0,
    final k=1/dPChiWatMax)
    "Normalize differential pressure error"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nPum)
    "Check if any chilled water pump is enabled"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

equation
  connect(uPumSta, mulOr.u[1:nPum]) annotation (Line(points={{-120,50},{-82,50}},
                             color={255,0,255}));

  connect(uPumSpe, hys.u)
    annotation (Line(points={{-120,0},{-92,0}}, color={0,0,127}));

  connect(hys.y, not1.u)
    annotation (Line(points={{-68,0},{-62,0}}, color={255,0,255}));

  connect(not1.y, and2.u2) annotation (Line(points={{-38,0},{-34,0},{-34,-8},{-22,
          -8}}, color={255,0,255}));

  connect(swi.y, yBypValPos)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));

  connect(mulOr.y, and2.u1) annotation (Line(points={{-58,50},{-30,50},{-30,0},{
          -22,0}}, color={255,0,255}));

  connect(mulOr.y, swi1.u2)
    annotation (Line(points={{-58,50},{18,50}}, color={255,0,255}));

  connect(con1.y, swi1.u3) annotation (Line(points={{2,30},{6,30},{6,42},{18,42}},
        color={0,0,127}));

  connect(con.y, swi1.u1) annotation (Line(points={{2,70},{10,70},{10,58},{18,58}},
        color={0,0,127}));

  connect(swi1.y, swi.u3) annotation (Line(points={{42,50},{54,50},{54,-8},{58,-8}},
        color={0,0,127}));

  connect(and2.y, swi.u2)
    annotation (Line(points={{2,0},{58,0}}, color={255,0,255}));

  connect(conPID.y, swi.u1) annotation (Line(points={{42,-50},{48,-50},{48,8},{
          58,8}}, color={0,0,127}));

  connect(con.y, conPID.u_s) annotation (Line(points={{2,70},{10,70},{10,-50},{
          18,-50}}, color={0,0,127}));

  connect(dpChiWatLoo, addPar.u)
    annotation (Line(points={{-120,-50},{-82,-50}}, color={0,0,127}));

  connect(addPar.y, addPar1.u)
    annotation (Line(points={{-58,-50},{-42,-50}}, color={0,0,127}));

  connect(addPar1.y, conPID.u_m) annotation (Line(points={{-18,-50},{-10,-50},{
          -10,-72},{30,-72},{30,-62}}, color={0,0,127}));

  connect(and2.y, conPID.trigger) annotation (Line(points={{2,0},{6,0},{6,-66},{
          24,-66},{24,-62}}, color={255,0,255}));
  annotation (defaultComponentName="bypValPos",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
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
          textString="sysOpeMod")}),
      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
      Documentation(info="<html>
        <p>
        Sequences for calculating pressure-relief bypass valve position in chilled beam systems.
        </p>
        <p>
        The block determines the bypass valve position setpoint <code>yBypValPos</code>
        based on the pump proven on status <code>uPumSta</code>, measured pump 
        speed <code>uPumSpe</code> and measured differential pressure across the
        demand loop <code>dpChiWatLoo</code>.
        </p>
        <p>
        The setpoint is calculated as follows:
        <ul>
        <li>
        when none of the pumps are proven on, the bypass valve is completely opened.
        </li>
        <li>
        when any of the pumps are proven on, the bypass valve is completely closed.
        </li>
        <li>
        when the pumps are proven on and are running at minimum speed, 
        <code>yBypValPos</code> is used to regulate <code>dpChiWatLoo</code> at 
        maximum allowed loop pressure <code>dPChiWatMax</code>.
        </li>
        </ul>
        </p>
        </html>", revisions="<html>
<ul>
<li>
June 16, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end BypassValvePosition;
