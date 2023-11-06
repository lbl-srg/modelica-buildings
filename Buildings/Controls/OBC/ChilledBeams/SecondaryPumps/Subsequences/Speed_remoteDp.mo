within Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Subsequences;
block Speed_remoteDp
  "Pump speed control for chilled beam systems where the remote DP sensor(s) is hardwired to the controller"

  parameter Integer nSen(min=1)
    "Total number of remote differential pressure sensors";

  parameter Integer nPum(min=1)
    "Total number of chilled water pumps";

  parameter Real minPumSpe = 0.1
    "Minimum pump speed";

  parameter Real maxPumSpe = 1
    "Maximum pump speed";

  parameter Real k=1
    "Gain of controller"
    annotation(Dialog(group="Speed controller"));

  parameter Real Ti(
    final quantity="Time",
    final unit="s",
    displayUnit="s") = 0.5
    "Time constant of integrator block"
    annotation(Dialog(group="Speed controller",
      enable = controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real Td(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Speed controller",
      enable = controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType = Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Controller type for pump speed control"
    annotation (Dialog(group="Speed controller"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat[nSen](
    final unit=fill("Pa", nSen),
    displayUnit=fill("Pa", nSen),
    final quantity=fill("PressureDifference", nSen))
    "Chilled water differential static pressure"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Chilled water differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatPumSpe(
    final min=minPumSpe,
    final max=maxPumSpe,
    final unit="1",
    displayUnit="1")
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.MultiMax maxLoo(
    final nin=nSen)
    "Maximum DP loop output"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Reals.Line pumSpe
    "Convert PI signal into linear transformation between minimum and maximum pump speed"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPID[nSen](
    controllerType=fill(controllerType, nSen),
    k=fill(k, nSen),
    Ti=fill(Ti, nSen),
    Td=fill(Td, nSen),
    final yMax=fill(1,nSen),
    final yMin=fill(0,nSen),
    xi_start=fill(1,nSen))
    "PID controller for regulating remote differential pressure"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Reset PID loop when the pump system is enabled"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nPum)
    "Check if any chilled water pumps are enabled"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=nSen)
    "Replicate real input"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

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
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));

  Buildings.Controls.OBC.CDL.Reals.Divide div[nSen]
    "Normalized pressure difference"
    annotation (Placement(transformation(extent={{0,-76},{20,-56}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep1(
    final nout=nSen)
    "Replicate real input"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Logical switch"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));

  Buildings.Controls.OBC.CDL.Reals.Max guaDivZer
    "Ensure zero setpoint does not cause division by zero"
    annotation (Placement(transformation(extent={{-70,-100},{-50,-80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant smaPre(
    final k(final unit="Pa") = 1)
    "Constant for small pressure, used to avoid division by zero. Set to 1 Pa as default as set point is usually in the order of 1 kPa"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));

equation

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

  connect(dpChiWat, div.u1)
    annotation (Line(points={{-140,0},{-100,0},{-100,-60},{-2,-60}},
      color={0,0,127}));

  connect(one.y, reaRep1.u)
    annotation (Line(points={{-58,40},{-40,40},{-40,0},{-22,0}},
      color={0,0,127}));

  connect(pumSpe.y, swi.u1)
    annotation (Line(points={{82,60},{100,60},{100,80},{60,80},{60,108},{78,108}},
      color={0,0,127}));

  connect(swi.y,yChiWatPumSpe)
    annotation (Line(points={{102,100},{110,100},{110,0},{140,0}},
                                                   color={0,0,127}));

  connect(uChiWatPum, mulOr.u[1:nPum]) annotation (Line(points={{-140,100},{-90,
          100},{-90,0},{-82,0}},   color={255,0,255}));
  connect(mulOr.y, swi.u2) annotation (Line(points={{-58,0},{-50,0},{-50,100},{78,
          100}}, color={255,0,255}));
  connect(mulOr.y, edg.u) annotation (Line(points={{-58,0},{-50,0},{-50,-40},{-42,
          -40}}, color={255,0,255}));
  connect(edg.y, booRep.u)
    annotation (Line(points={{-18,-40},{-12,-40}}, color={255,0,255}));
  connect(booRep.y, conPID.trigger)
    annotation (Line(points={{12,-40},{24,-40},{24,-12}}, color={255,0,255}));
  connect(reaRep1.y, conPID.u_s)
    annotation (Line(points={{2,0},{18,0}}, color={0,0,127}));
  connect(div.y, conPID.u_m)
    annotation (Line(points={{22,-66},{30,-66},{30,-12}},color={0,0,127}));
  connect(conPID.y, maxLoo.u[1:nSen])
    annotation (Line(points={{42,0},{50,0},{50,0},{58,0}},   color={0,0,127}));
  connect(reaRep.y, div.u2) annotation (Line(points={{-18,-90},{-10,-90},{-10,-72},
          {-2,-72}},       color={0,0,127}));
  connect(guaDivZer.y, reaRep.u)
    annotation (Line(points={{-48,-90},{-42,-90}}, color={0,0,127}));
  connect(guaDivZer.u1, smaPre.y) annotation (Line(points={{-72,-84},{-82,-84},{
          -82,-80},{-88,-80}}, color={0,0,127}));
  connect(guaDivZer.u2, dpChiWatSet) annotation (Line(points={{-72,-96},{-84,-96},
          {-84,-100},{-140,-100}}, color={0,0,127}));
  connect(pumSpe_min.y, swi.u3) annotation (Line(points={{-58,80},{-40,80},{-40,
          92},{78,92}}, color={0,0,127}));
annotation (
  defaultComponentName="chiPumSpe",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
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
          textString="dpChiWat"),
        Text(
          extent={{-92,-66},{-58,-94}},
          textColor={0,0,127},
          textString="dpChiWatSet"),
        Text(
          extent={{-92,100},{-46,58}},
          textColor={255,85,255},
          textString="uChiWatPum"),
        Text(
          extent={{44,18},{92,-16}},
          textColor={0,0,127},
          textString="yChiWatPum")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
  Documentation(info="<html>
<p>
Block that outputs chilled water pump speed setpoint for chilled beam systems with
variable-speed pumps where the remote pressure differential sensor is
hardwired to the system controller.
</p>
<ol>
<li>
When any chilled water pump is proven on, <code>uChiWatPum = true</code>, 
pump speed will be controlled by a reverse acting PID loop maintaining the
differential pressure signal at a setpoint <code>dpChiWatSet</code>. All pumps
receive the same speed signal. PID loop output shall be mapped from minimum
pump speed <code>minPumSpe</code> at 0% to maximum pump speed
<code>maxPumSpe</code> at 100%.
</li>
<li>
Where multiple differential pressure sensors exist, a PID loop shall run for
each sensor. Chilled water pumps shall be controlled by the maximum signal output
of all DP sensor loops.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 8, 2022, by Michael Wetter:<br/>
Set minimum attribute for parameter, and removed default value.
</li>
<li>
June 9, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end Speed_remoteDp;
