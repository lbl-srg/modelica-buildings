within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic;
block Speed_localDp
  "Pump speed control plants where the remote DP sensor(s) is not hardwired to the plant controller, but a local DP sensor is hardwired"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType= Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Speed controller"));

  parameter Integer nSen = 2
    "Total number of remote differential pressure sensors";

  parameter Integer nPum = 2
    "Total number of hot water pumps";

  parameter Real minLocDp(
    final min=0,
    displayUnit="Pa",
    final unit= "Pa",
    final quantity="PressureDifference")=5*6894.75
    "Minimum hot water loop local differential pressure setpoint";

  parameter Real maxLocDp(
    final min=minLocDp,
    displayUnit="Pa",
    final unit="Pa",
    final quantity="PressureDifference") = 15*6894.75
    "Maximum hot water loop local differential pressure setpoint";

  parameter Real minPumSpe(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=maxPumSpe) = 0.1
    "Minimum pump speed";

  parameter Real maxPumSpe(
    final unit="1",
    displayUnit="1",
    final min=minPumSpe,
    final max=1) = 1
    "Maximum pump speed";

  parameter Real k=1
    "Gain of controller"
    annotation(Dialog(group="Speed controller"));

  parameter Real Ti(
    final unit="s",
    final quantity="time",
    displayUnit="s")=0.5
    "Time constant of integrator block"
    annotation(Dialog(group="Speed controller"));

  parameter Real Td(
    final unit="s",
    final quantity="time",
    displayUnit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Speed controller"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotWatPum[nPum]
    "Hot water pump status"
    annotation (Placement(transformation(extent={{-180,-70},{-140,-30}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWat_local(
    final unit="Pa",
    final quantity="PressureDifference")
    "Hot water differential static pressure from local sensor"
    annotation (Placement(transformation(extent={{-180,70},{-140,110}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWat_remote[nSen](
    final unit=fill("Pa", nSen),
    final quantity=fill("PressureDifference", nSen),
    displayUnit=fill("Pa", nSen))
    "Hot water differential static pressure from remote sensor"
    annotation (Placement(transformation(extent={{-180,-110},{-140,-70}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWatSet(
    final unit="Pa",
    final quantity="PressureDifference",
    displayUnit="Pa")
    "Hot water differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-180,-140},{-140,-100}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatPumSpe(
    final min=minPumSpe,
    final max=maxPumSpe,
    final unit="1")
    "Hot water pump speed"
    annotation (Placement(transformation(extent={{140,70},{180,110}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.MultiMax maxRemDP(
    nin=nSen)
    "Highest output from differential pressure control loops"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Line locDpSet
    "Local differential pressure setpoint"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Speed_remoteDp hotPumSpe(
    controllerType=controllerType,
    final nSen=1,
    final nPum=nPum,
    final minPumSpe=minPumSpe,
    final maxPumSpe=maxPumSpe,
    final k=k,
    final Ti=Ti,
    final Td=Td)
    "Calculate pump speed based on pressure setpoint"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));

protected
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPID[nSen](
    final controllerType=fill(controllerType, nSen),
    final k=fill(k, nSen),
    final Ti=fill(Ti, nSen),
    final Td=fill(Td, nSen),
    final yMax=fill(1,nSen),
    final yMin=fill(0,nSen))
    "PID controller for regulating local differential pressure setpoint"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Reset PID loop when it is activated"
    annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nPum)
    "Check if any hot water pumps are enabled"
    annotation (Placement(transformation(extent={{-110,-60},{-90,-40}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=nSen)
    "Replicate real input"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nSen)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant locDp_min(
    final k=minLocDp)
    "Minimum local differential pressure"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant locDp_max(
    final k=maxLocDp)
    "Maximum local differential pressure "
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));

  Buildings.Controls.OBC.CDL.Reals.Divide div[nSen]
    "Normalized pressure difference"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep1(
    final nout=nSen)
    "Replicate real input"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

equation
  connect(dpHotWatSet, reaRep.u)
    annotation (Line(points={{-160,-120},{-122,-120}}, color={0,0,127}));

  connect(maxRemDP.y, locDpSet.u)
    annotation (Line(points={{62,-20},{98,-20}}, color={0,0,127}));

  connect(zer.y, locDpSet.x1)
    annotation (Line(points={{82,20},{90,20},{90,-12},{98,-12}}, color={0,0,127}));

  connect(locDp_min.y, locDpSet.f1)
    annotation (Line(points={{62,-60},{70,-60},{70,-16},{98,-16}},
      color={0,0,127}));

  connect(one.y, locDpSet.x2)
    annotation (Line(points={{-98,20},{40,20},{40,0},{80,0},{80,-24},{98,-24}},
      color={0,0,127}));

  connect(locDp_max.y, locDpSet.f2)
    annotation (Line(points={{62,-120},{80,-120},{80,-28},{98,-28}},
      color={0,0,127}));

  connect(dpHotWat_remote, div.u1)
    annotation (Line(points={{-160,-90},{-80,-90},{-80,-94},{-42,-94}},
      color={0,0,127}));

  connect(reaRep.y, div.u2)
    annotation (Line(points={{-98,-120},{-80,-120},{-80,-106},{-42,-106}},
      color={0,0,127}));

  connect(one.y, reaRep1.u)
    annotation (Line(points={{-98,20},{-90,20},{-90,0},{-82,0}}, color={0,0,127}));

  connect(hotPumSpe.yHotWatPumSpe, yHotWatPumSpe)
    annotation (Line(points={{82,90},{160,90}}, color={0,0,127}));
  connect(uHotWatPum, mulOr.u[1:nPum]) annotation (Line(points={{-160,-50},{-112,
          -50}},                     color={255,0,255}));
  connect(uHotWatPum, hotPumSpe.uHotWatPum) annotation (Line(points={{-160,-50},
          {-130,-50},{-130,98},{58,98}}, color={255,0,255}));
  connect(locDpSet.y, hotPumSpe.dpHotWatSet) annotation (Line(points={{122,-20},
          {130,-20},{130,72},{40,72},{40,82},{58,82}}, color={0,0,127}));
  connect(dpHotWat_local, hotPumSpe.dpHotWat[1])
    annotation (Line(points={{-160,90},{58,90}}, color={0,0,127}));

  connect(mulOr.y, edg.u)
    annotation (Line(points={{-88,-50},{-72,-50}}, color={255,0,255}));
  connect(edg.y, booRep.u)
    annotation (Line(points={{-48,-50},{-32,-50}}, color={255,0,255}));
  connect(booRep.y, conPID.trigger)
    annotation (Line(points={{-8,-50},{4,-50},{4,-32}}, color={255,0,255}));
  connect(div.y, conPID.u_m)
    annotation (Line(points={{-18,-100},{10,-100},{10,-32}}, color={0,0,127}));
  connect(reaRep1.y, conPID.u_s) annotation (Line(points={{-58,0},{-20,0},{-20,-20},
          {-2,-20}}, color={0,0,127}));
  connect(conPID.y, maxRemDP.u[1:nSen]) annotation (Line(points={{22,-20},{30,-20},
          {30,-20},{38,-20}}, color={0,0,127}));

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
          extent={{-98,52},{-44,30}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHotWatPum"),
        Text(
          extent={{-98,-30},{-30,-52}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpHotWat_remote"),
        Text(
          extent={{22,12},{98,-10}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yHotWatPumSpe"),
        Text(
          extent={{-98,-68},{-34,-90}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpHotWatSet"),
        Text(
          extent={{-98,92},{-30,70}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpHotWat_local")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
  Documentation(info="<html>
<p>
Block that controls speed of enabled hot water pumps for plants where
the remote pressure differential (DP) sensor(s) is not hardwired to the plant controller,
but a local DP sensor is hardwired to the plant controller, 
according to ASHRAE RP-1711, March, 2020 draft, sections 5.3.6.7, 5.3.6.8, 5.3.6.9,
5.3.7.7 , 5.3.7.8 and 5.3.7.9.
</p>
<ol>
<li>
Remote dP <code>dpHotWat_remote</code> shall be maintained at setpoint <code>dpHotWatSet</code>
by a reverse acting PID loop running in the controller to which the remote sensor is wired.
The loop output shall be a dP setpoint for the local dP sensor
hardwired to the plant controller. Reset local dP from <code>minLocDp</code>, 
e.g. 5 psi (34473.8 Pa), at 0% loop output to <code>maxLocDp</code> at 100%
loop output.
</li>
<li>
When any pump is proven on, pump speed shall be controlled by a reverse acting
PID loop maintaining the local dP <code>dpHotWat_local</code> at the DP setpoint output
from the remote sensor control loop. All pumps receive the same speed signal. 
PID loop output shall be mapped from minimum pump speed (<code>minPumSpe</code>) 
at 0% to maximum pump speed (<code>maxPumSpe</code>) at 100%.
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
August 3, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end Speed_localDp;
