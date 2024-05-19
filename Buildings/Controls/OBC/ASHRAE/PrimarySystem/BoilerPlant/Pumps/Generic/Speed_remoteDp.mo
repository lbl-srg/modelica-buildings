within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic;
block Speed_remoteDp
  "Pump speed control for plants where the remote DP sensor(s) is hardwired to the plant controller"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType= Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Speed controller"));

  parameter Integer nSen = 2
    "Total number of remote differential pressure sensors";

  parameter Integer nPum = 2
    "Total number of hot water pumps";

  parameter Real minPumSpe = 0.1
    "Minimum pump speed";

  parameter Real maxPumSpe = 1
    "Maximum pump speed";

  parameter Real k=1
    "Gain of controller"
    annotation(Dialog(group="Speed controller"));

  parameter Real Ti(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.5
    "Time constant of integrator block"
    annotation(Dialog(group="Speed controller"));

  parameter Real Td(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Speed controller"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotWatPum[nPum]
    "Hot water pump status"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWat[nSen](
    final unit=fill("Pa", nSen),
    displayUnit=fill("Pa", nSen),
    final quantity=fill("PressureDifference", nSen))
    "Hot water differential static pressure"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWatSet(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Hot water differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatPumSpe(
    final min=minPumSpe,
    final max=maxPumSpe,
    final unit="1",
    displayUnit="1")
    "Hot water pump speed"
    annotation (Placement(transformation(extent={{120,80},{160,120}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.MultiMax maxLoo(
    final nin=nSen)
    "Maximum DP loop output"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Reals.Line pumSpe
    "Pump speed"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

protected
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPID[nSen](
    final controllerType=fill(controllerType, nSen),
    final k=fill(k, nSen),
    final Ti=fill(Ti, nSen),
    final Td=fill(Td, nSen),
    final yMax=fill(1,nSen),
    final yMin=fill(0,nSen))
    "PID controller for regulating remote differential pressure"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Reset PID loop when it is activated"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nPum)
    "Check if any hot water primary pumps are enabled"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=nSen)
    "Replicate real input"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nSen)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pumSpe_min(
    final k=minPumSpe)
    "Minimum pump speed"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pumSpe_max(
    final k=maxPumSpe)
    "Maximum pump speed"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));

  Buildings.Controls.OBC.CDL.Reals.Divide div[nSen]
    "Normalized pressure difference"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep1(
    final nout=nSen)
    "Replicate real input"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Logical switch"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));

equation
  connect(dpHotWatSet, reaRep.u)
    annotation (Line(points={{-140,-100},{-102,-100}}, color={0,0,127}));

  connect(zer.y, pumSpe.x1)
    annotation (Line(points={{2,80},{20,80},{20,68},{58,68}}, color={0,0,127}));

  connect(pumSpe_min.y, pumSpe.f1)
    annotation (Line(points={{-58,80},{-40,80},{-40,64},{58,64}}, color={0,0,127}));

  connect(one.y, pumSpe.x2)
    annotation (Line(points={{-58,40},{-40,40},{-40,56},{58,56}}, color={0,0,127}));

  connect(pumSpe_max.y, pumSpe.f2)
    annotation (Line(points={{2,40},{10,40},{10,52},{58,52}}, color={0,0,127}));

  connect(maxLoo.y, pumSpe.u)
    annotation (Line(points={{82,0},{100,0},{100,40},{40,40},{40,60},{58,60}},
      color={0,0,127}));

  connect(dpHotWat, div.u1)
    annotation (Line(points={{-140,-60},{-40,-60},{-40,-74},{-22,-74}},
      color={0,0,127}));

  connect(reaRep.y, div.u2)
    annotation (Line(points={{-78,-100},{-40,-100},{-40,-86},{-22,-86}},
      color={0,0,127}));

  connect(one.y, reaRep1.u)
    annotation (Line(points={{-58,40},{-40,40},{-40,0},{-22,0}},
      color={0,0,127}));

  connect(pumSpe.y, swi.u1)
    annotation (Line(points={{82,60},{100,60},{100,80},{60,80},{60,108},{78,108}},
      color={0,0,127}));

  connect(swi.y,yHotWatPumSpe)
    annotation (Line(points={{102,100},{140,100}}, color={0,0,127}));

  connect(uHotWatPum, mulOr.u[1:nPum]) annotation (Line(points={{-140,0},{-122,0},{
          -122,0},{-102,0}},       color={255,0,255}));
  connect(mulOr.y, swi.u2) annotation (Line(points={{-78,0},{-50,0},{-50,100},{78,
          100}}, color={255,0,255}));
  connect(mulOr.y, edg.u) annotation (Line(points={{-78,0},{-50,0},{-50,-40},{-42,
          -40}}, color={255,0,255}));
  connect(edg.y, booRep.u)
    annotation (Line(points={{-18,-40},{-12,-40}}, color={255,0,255}));
  connect(booRep.y, conPID.trigger)
    annotation (Line(points={{12,-40},{24,-40},{24,-12}}, color={255,0,255}));
  connect(reaRep1.y, conPID.u_s)
    annotation (Line(points={{2,0},{18,0}}, color={0,0,127}));
  connect(div.y, conPID.u_m)
    annotation (Line(points={{2,-80},{30,-80},{30,-12}}, color={0,0,127}));
  connect(conPID.y, maxLoo.u[1:nSen])
    annotation (Line(points={{42,0},{50,0},{50,0},{58,0}},   color={0,0,127}));
  connect(pumSpe_max.y, swi.u3) annotation (Line(points={{2,40},{10,40},{10,92},
          {78,92}}, color={0,0,127}));
annotation (
  defaultComponentName="hotPumSpe",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,150},{100,110}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,92},{-44,70}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHotWatPum"),
        Text(
          extent={{-98,10},{-44,-12}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpHotWat"),
        Text(
          extent={{22,12},{98,-10}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yHotWatPumSpe"),
        Text(
          extent={{-98,-68},{-34,-90}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpHotWatSet")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
  Documentation(info="<html>
<p>
Block that outputs hot water pump speed setpoint for plants with
headered, variable-speed pumps where the remote pressure differential sensor is
hardwired to the plant controller, according to ASHRAE RP-1711, March, 2020 draft, 
sections 5.3.6.5, 5.3.6.6, 5.3.7.5 and 5.3.7.6.
</p>
<ol>
<li>
When any hot water pump is proven on, <code>uHotWatPum = true</code>, 
pump speed will be controlled by a reverse acting PID loop maintaining the
differential pressure signal at a setpoint <code>dpHotWatSet</code>. All pumps
receive the same speed signal. PID loop output shall be mapped from minimum
pump speed (<code>minPumSpe</code>) at 0% to maximum pump speed
(<code>maxPumSpe</code>) at 100%.
</li>
<li>
Where multiple differential pressure sensors exist, a PID loop shall run for
each sensor. Hot water pumps shall be controlled to the maximum signal output
of all DP sensor loops.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 3, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end Speed_remoteDp;
