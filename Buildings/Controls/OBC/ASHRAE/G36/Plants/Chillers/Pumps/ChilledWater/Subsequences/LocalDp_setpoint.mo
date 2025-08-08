within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences;
block LocalDp_setpoint
  "Pump speed control for primary-only plants where the remote DP sensor(s) is not hardwired to the plant controller, but a local DP sensor is hardwired"
  parameter Integer nSen = 2
    "Total number of remote differential pressure sensors";
  parameter Integer nPum = 2
    "Total number of chilled water pumps";
  parameter Real minLocDp(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=0)=5*6894.75
    "Minimum chilled water loop local differential pressure setpoint";
  parameter Real maxLocDp(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=minLocDp) = 15*6894.75
    "Maximum chilled water loop local differential pressure setpoint";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Pressure controller"));
  parameter Real k=1 "Gain of controller"
    annotation(Dialog(group="Pressure controller"));
  parameter Real Ti(
    final unit="s",
    final quantity="Time")=0.5 "Time constant of integrator block"
      annotation(Dialog(group="Pressure controller"));
  parameter Real Td(
    final unit="s",
    final quantity="Time")=0.1 "Time constant of derivative block"
      annotation (Dialog(group="Pressure controller",
      enable=
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat_remote[nSen](
    final unit=fill("Pa", nSen),
    final quantity=fill("PressureDifference", nSen))
    "Chilled water differential static pressure from remote sensor"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet_remote[nSen](
    final unit=fill("Pa", nSen),
    final quantity=fill("PressureDifference",nSen))
    "Chilled water differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-180,-100},{-140,-60}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpChiWatPumSet_local(
    final quantity="PressureDifference",
    final unit="Pa",
    displayUnit="Pa")
    "Local differential pressure setpoint"
    annotation (Placement(transformation(extent={{140,0},{180,40}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.MultiMax maxRemDP(
    final nin=nSen)
    "Highest output from differential pressure control loops"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Reals.Line locDpSet
    "Local differential pressure setpoint"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.PIDWithEnable conPID[nSen](
    final controllerType=fill(controllerType, nSen),
    final k=fill(k, nSen),
    final Ti=fill(Ti, nSen),
    final Td=fill(Td, nSen),
    final yMax=fill(1, nSen),
    final yMin=fill(0, nSen),
    final y_reset=fill(0, nSen)) "Differential pressure controller"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));

protected
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nSen)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant locDp_min(
    final k=minLocDp)
    "Minimum local differential pressure"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant locDp_max(
    final k=maxLocDp)
    "Maximum local differential pressure "
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div[nSen]
    "Normalized pressure difference"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep1(
    final nout=nSen) "Replicate real input"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(final nin=nPum)
    "Check if there is any pump enabled"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

equation
  connect(conPID.y, maxRemDP.u)
    annotation (Line(points={{2,20},{18,20}},  color={0,0,127}));
  connect(maxRemDP.y, locDpSet.u)
    annotation (Line(points={{42,20},{98,20}}, color={0,0,127}));
  connect(zer.y, locDpSet.x1)
    annotation (Line(points={{82,80},{90,80},{90,28},{98,28}}, color={0,0,127}));
  connect(locDp_min.y, locDpSet.f1)
    annotation (Line(points={{42,-20},{70,-20},{70,24},{98,24}},
      color={0,0,127}));
  connect(one.y, locDpSet.x2)
    annotation (Line(points={{-98,60},{80,60},{80,16},{98,16}},
      color={0,0,127}));
  connect(locDp_max.y, locDpSet.f2)
    annotation (Line(points={{42,-60},{80,-60},{80,12},{98,12}},
      color={0,0,127}));
  connect(dpChiWat_remote, div.u1)
    annotation (Line(points={{-160,-40},{-80,-40},{-80,-54},{-62,-54}},
      color={0,0,127}));
  connect(one.y, reaRep1.u)
    annotation (Line(points={{-98,60},{-90,60},{-90,40},{-82,40}}, color={0,0,127}));
  connect(reaRep1.y, conPID.u_s)
    annotation (Line(points={{-58,40},{-40,40},{-40,20},{-22,20}},color={0,0,127}));
  connect(div.y, conPID.u_m)
    annotation (Line(points={{-38,-60},{-10,-60},{-10,8}},   color={0,0,127}));
  connect(mulOr.y, booRep.u)
    annotation (Line(points={{-98,0},{-82,0}},     color={255,0,255}));
  connect(uChiWatPum, mulOr.u)
    annotation (Line(points={{-160,0},{-122,0}},    color={255,0,255}));
  connect(dpChiWatSet_remote, div.u2) annotation (Line(points={{-160,-80},{-80,-80},
          {-80,-66},{-62,-66}},         color={0,0,127}));
  connect(locDpSet.y, dpChiWatPumSet_local)
    annotation (Line(points={{122,20},{160,20}},   color={0,0,127}));
  connect(booRep.y, conPID.uEna)
    annotation (Line(points={{-58,0},{-14,0},{-14,8}},   color={255,0,255}));
annotation (
  defaultComponentName="locDpSet",
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
          extent={{-98,72},{-44,50}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiWatPum"),
        Text(
          extent={{-98,10},{-30,-12}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWat_remote"),
        Text(
          extent={{-98,-38},{-20,-62}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWatSet_remote"),
        Text(
          extent={{6,14},{98,-10}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWatPumSet_local")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,120}})),
  Documentation(info="<html>
<p>
Block that calculates the local DP setpoint for the local primary loop DP sensor
hardwired to the plant controller. It is applicable for the primary-only plants where
the remote pressure differential (DP) sensor(s) is not hardwired to the plant controller,
but a local DP sensor is hardwired to the plant controller,
according to ASHRAE Guideline36-2021,
section 5.20.6 Primary chilled water pumps, part 5.20.6.10.
</p>
<ol>
<li>
Remote DP shall be maintained at setpoint <code>dpChiWatSet</code> by a reverse
acting PID loop running in the controller to which the remote sensor is wired.
The loop output shall be a DP setpoint for the local primary loop DP sensor
hardwired to the plant controller. Reset local DP from <code>minLocDp</code>,
e.g. 5 psi (34473.8 Pa), at 0% loop output to <code>maxLocDp</code> at 100%
loop output.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 1, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end LocalDp_setpoint;
