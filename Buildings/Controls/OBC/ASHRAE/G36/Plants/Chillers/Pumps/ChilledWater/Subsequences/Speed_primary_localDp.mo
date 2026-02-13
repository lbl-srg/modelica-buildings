within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences;
block Speed_primary_localDp
  "Pump speed control for primary-only plants where the remote DP sensor(s) is not hardwired to the plant controller, but a local DP sensor is hardwired"
  parameter Integer nPum = 2
    "Total number of chilled water pumps";
  parameter Real minPumSpe = 0.1 "Minimum pump speed";
  parameter Real maxPumSpe = 1 "Maximum pump speed";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Speed controller"));
  parameter Real k=1 "Gain of controller"
    annotation(Dialog(group="Speed controller"));
  parameter Real Ti(
    final unit="s",
    final quantity="Time")=0.5 "Time constant of integrator block"
      annotation(Dialog(group="Speed controller",
        enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
               controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(
    final unit="s",
    final quantity="Time")=0.1 "Time constant of derivative block"
      annotation (Dialog(group="Speed controller",
        enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
               controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat_local(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water differential static pressure from local sensor"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet_local(
    final quantity="PressureDifference",
    final unit="Pa",
    displayUnit="Pa")
    "Local differential pressure setpoint"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{-180,-90},{-140,-50}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatPumSpe(
    final min=minPumSpe,
    final max=maxPumSpe,
    final unit="1") "Chilled water pump speed"
    annotation (Placement(transformation(extent={{140,-90},{180,-50}}),
      iconTransformation(extent={{100,-20},{140,20}})));


  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.PIDWithEnable conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=1,
    final yMin=0,
    final y_reset=0) "Pump speed controller"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Reals.Line pumSpe "Pump speed"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pumSpe_min(
    final k=minPumSpe) "Minimum pump speed"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pumSpe_max(
    final k=maxPumSpe) "Maximum pump speed"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div "Normalized pressure difference"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(final nin=nPum)
    "Check if there is any pump enabled"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

equation
  connect(zer.y, pumSpe.x1)
    annotation (Line(points={{2,-40},{30,-40},{30,78},{38,78}},color={0,0,127}));
  connect(pumSpe_min.y, pumSpe.f1)
    annotation (Line(points={{2,100},{20,100},{20,74},{38,74}},  color={0,0,127}));
  connect(conPID.y, pumSpe.u) annotation (Line(points={{-38,40},{10,40},{10,70},
          {38,70}}, color={0,0,127}));
  connect(one.y, pumSpe.x2)
    annotation (Line(points={{-98,90},{-80,90},{-80,66},{38,66}}, color={0,0,127}));
  connect(pumSpe_max.y, pumSpe.f2)
    annotation (Line(points={{2,0},{20,0},{20,62},{38,62}}, color={0,0,127}));
  connect(dpChiWat_local, div.u1) annotation (Line(points={{-160,20},{-120,20},{
          -120,6},{-102,6}}, color={0,0,127}));
  connect(one.y, conPID.u_s) annotation (Line(points={{-98,90},{-80,90},{-80,40},
          {-62,40}}, color={0,0,127}));
  connect(div.y, conPID.u_m)
    annotation (Line(points={{-78,0},{-50,0},{-50,28}}, color={0,0,127}));
  connect(pumSpe.y, swi.u1)
    annotation (Line(points={{62,70},{80,70},{80,-62},{98,-62}},
      color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{2,-40},{30,-40},{30,-78},{98,-78}},
      color={0,0,127}));
  connect(swi.y, yChiWatPumSpe)
    annotation (Line(points={{122,-70},{160,-70}}, color={0,0,127}));
  connect(mulOr.y, swi.u2)
    annotation (Line(points={{-98,-70},{98,-70}},
      color={255,0,255}));
  connect(uChiWatPum, mulOr.u)
    annotation (Line(points={{-160,-70},{-122,-70}},color={255,0,255}));
  connect(mulOr.y, conPID.uEna) annotation (Line(points={{-98,-70},{-54,-70},{-54,
          28}}, color={255,0,255}));
  connect(dpChiWatSet_local, div.u2) annotation (Line(points={{-160,-20},{-120,-20},
          {-120,-6},{-102,-6}}, color={0,0,127}));
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
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,-48},{-44,-70}},
          textColor={255,0,255},
          textString="uChiWatPum"),
        Text(
          extent={{22,12},{98,-10}},
          textColor={0,0,127},
          textString="yChiWatPumSpe"),
        Text(
          extent={{-98,72},{-30,50}},
          textColor={0,0,127},
          textString="dpChiWat_local"),
        Text(
          extent={{-96,12},{-4,-12}},
          textColor={0,0,127},
          textString="dpChiWatSet_local")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
  Documentation(info="<html>
<p>
Block that controls speed of enabled chilled water pumps for primary-only plants where
the remote pressure differential (DP) sensor(s) is not hardwired to the plant controller,
but a local DP sensor is hardwired to the plant controller,
according to ASHRAE Guideline 36-2021,
section 5.20.6 Primary chilled water pumps, part 5.20.6.10, 5.20.6.11, and 5.20.6.12.
</p>
<ol>
<li>
Remote DP shall be maintained at setpoint <code>dpChiWatSet</code> by a reverse-acting
PID loop running in the controller to which the remote sensor is wired.
The loop output shall be a DP setpoint for the local primary loop DP sensor
hardwired to the plant controller. Reset local DP from <code>minLocDp</code>,
e.g., 5 psi (34473.8 Pa), at 0% loop output to <code>maxLocDp</code> at 100%
loop output.
</li>
<li>
When any pump is proven on, pump speed shall be controlled by a reverse-acting
PID loop, maintaining the local primary DP signal at the DP setpoint output
from the remote sensor control loop. All pumps receive the same speed signal.
PID loop output shall be mapped from the minimum pump speed (<code>minPumSpe</code>)
at 0% to the maximum pump speed (<code>maxPumSpe</code>) at 100%.
</li>
<li>
Where multiple remote DP sensors exist, a PID loop shall run for each sensor.
The DP setpoint for the local DP sensor shall be the highest DP setpoint output
from each of the remote loops.
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
end Speed_primary_localDp;
