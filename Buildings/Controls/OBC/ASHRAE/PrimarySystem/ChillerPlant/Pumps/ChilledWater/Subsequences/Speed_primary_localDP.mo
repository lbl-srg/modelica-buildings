within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences;
block Speed_primary_localDP
  "Pump speed control for primary-only plants where the remote DP sensor(s) is not hardwired to the plant controller, but a local DP sensor is hardwired"
  parameter Integer nSen = 2
    "Total number of remote differential pressure sensors";
  parameter Integer nPum = 2
    "Total number of chilled water pumps";
  parameter Modelica.SIunits.PressureDifference minLocDp(
    final min=0,
    final displayUnit="Pa")=5*6894.75
    "Minimum chilled water loop local differential pressure setpoint";
  parameter Modelica.SIunits.PressureDifference maxLocDp(
    final min=0,
    final displayUnit="Pa")
    "Maximum chilled water loop local differential pressure setpoint";
  parameter Real minPumSpe = 0
    "Minimum pump speed";
  parameter Real maxPumSpe = 1
    "Maximum pump speed";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat_remote[nSen](
    each final unit="Pa",
    each final quantity="PressureDifference")
    "Chilled water differential static pressure from remote sensor"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-180,-120},{-140,-80}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat_local(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water differential static pressure from local sensor"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatPumSpe(
    final min=0,
    final max=1,
    final unit="1") "Chilled water pump speed"
    annotation (Placement(transformation(extent={{140,70},{160,90}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    final nout=nSen) "Replicate real input"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID[nSen](
    each final yMax=1,
    each final yMin=0,
    each final reverseAction=true,
    each final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    each final y_reset=0) "Pump speed controller"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax maxRemDP(final nin=nSen)
    "Highest output from differential pressure control loops"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=nSen)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID1(
    final yMax=1,
    final yMin=0,
    final reverseAction=true,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final y_reset=0) "Pump speed controller"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Line locDpSet
    "Local differential pressure setpoint"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant locDp_min(
    final k=minLocDp)
    "Minimum local differential pressure"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant locDp_max(
    final k=maxLocDp)
    "Maximum local differential pressure "
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant pumSpe_min(
    final k=minPumSpe) "Minimum pump speed"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant pumSpe_max(
    final k=maxPumSpe) "Maximum pump speed"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Line pumSpe "Pump speed"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[nPum] "Logical not"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nu=nPum) "Multiple logical and"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

equation
  connect(dpChiWat_remote, conPID.u_s)
    annotation (Line(points={{-160,-20},{-2,-20}}, color={0,0,127}));
  connect(conPID.y, maxRemDP.u)
    annotation (Line(points={{21,-20},{38,-20}}, color={0,0,127}));
  connect(booRep.y, conPID.trigger)
    annotation (Line(points={{-19,-60},{2,-60},{2,-32}}, color={255,0,255}));
  connect(dpChiWatSet, reaRep.u)
    annotation (Line(points={{-160,-100},{-122,-100}}, color={0,0,127}));
  connect(reaRep.y, conPID.u_m)
    annotation (Line(points={{-99,-100},{10,-100},{10,-32}}, color={0,0,127}));
  connect(maxRemDP.y, locDpSet.u)
    annotation (Line(points={{61,-20},{98,-20}}, color={0,0,127}));
  connect(zer.y, locDpSet.x1)
    annotation (Line(points={{81,20},{90,20},{90,-12},{98,-12}}, color={0,0,127}));
  connect(locDp_min.y, locDpSet.f1)
    annotation (Line(points={{61,-60},{70,-60},{70,-16},{98,-16}},
      color={0,0,127}));
  connect(one.y, locDpSet.x2)
    annotation (Line(points={{21,20},{40,20},{40,0},{80,0},{80,-24},{98,-24}},
      color={0,0,127}));
  connect(locDp_max.y, locDpSet.f2)
    annotation (Line(points={{61,-100},{80,-100},{80,-28},{98,-28}},
                                                                   color={0,0,127}));
  connect(dpChiWat_local, conPID1.u_s)
    annotation (Line(points={{-160,80},{-42,80}},color={0,0,127}));
  connect(locDpSet.y, conPID1.u_m)
    annotation (Line(points={{121,-20},{130,-20},{130,50},{-30,50},{-30,68}},
      color={0,0,127}));
  connect(zer.y, pumSpe.x1)
    annotation (Line(points={{81,20},{90,20},{90,88},{98,88}}, color={0,0,127}));
  connect(pumSpe_min.y, pumSpe.f1)
    annotation (Line(points={{61,120},{80,120},{80,84},{98,84}}, color={0,0,127}));
  connect(conPID1.y, pumSpe.u)
    annotation (Line(points={{-19,80},{98,80}}, color={0,0,127}));
  connect(one.y, pumSpe.x2)
    annotation (Line(points={{21,20},{40,20},{40,76},{98,76}}, color={0,0,127}));
  connect(pumSpe_max.y, pumSpe.f2)
    annotation (Line(points={{1,120},{20,120},{20,72},{98,72}}, color={0,0,127}));
  connect(pumSpe.y, yChiWatPumSpe)
    annotation (Line(points={{121,80},{150,80}}, color={0,0,127}));
  connect(uChiWatPum, not2.u)
    annotation (Line(points={{-160,-60},{-142,-60},{-142,-60},{-122,-60}},
      color={255,0,255}));
  connect(mulAnd.y, booRep.u)
    annotation (Line(points={{-58.3,-60},{-42,-60}}, color={255,0,255}));
  connect(mulAnd.y, conPID1.trigger)
    annotation (Line(points={{-58.3,-60},{-50,-60},{-50,40},{-38,40},
      {-38,68}}, color={255,0,255}));
  connect(not2.y, mulAnd.u)
    annotation (Line(points={{-99,-60},{-82,-60}}, color={255,0,255}));

annotation (
  defaultComponentName="chiPumSpe",
  Icon(graphics={
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
          extent={{-98,-28},{-44,-50}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiWatPum"),
        Text(
          extent={{-98,50},{-30,28}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWat_remote"),
        Text(
          extent={{22,12},{98,-10}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatPumSpe"),
        Text(
          extent={{-98,-68},{-34,-90}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWatSet"),
        Text(
          extent={{-98,92},{-30,70}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWat_local")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,140}})),
  Documentation(info="<html>
<p>
Block that enable and disable leading primary chilled water pump, for plants
with headered primary chilled water pumps, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.6 Primary chilled water pumps, part 5.2.6.7, 5.2.6.8 and 5.2.6.9.
</p>
<p>
1. Remote DP shall be maintained at setpoint <code>dpChiWatSet</code> by a reverse
acting PID loop running in the controller tp which the remote sensor is wired.
The loop output shall be a DP setpoint for the local primary loop DP sensor
hardwired to the plant controller. Reset local DP from <code>minLocDp</code>, 
e.g. 5 psi (34473.8 Pa), at 0% loop output to <code>maxLocDp</code> at 100%
loop output.
</p>
<p>
2. When any pump is proven on, pump speed shall be controlled by a reverse acting
PID loop maintaining the local primary DP signal at the DP setpoint output
from the remote sensor control loop. All pumps receive the same speed signal. 
PID loop output shall be mapped from minimum pump speed (<code>minPumSpe</code>) 
at 0% to maximum pump speed (<code>maxPumSpe</code>) at 100%.
</p>
<p>
3. Where multiple remote DP sensors exist, a PID loop shall run for each sensor.
The DP setpoint for the local DP sensor shall be the highest DP setpoint output
from each of the remote loops.
</p>
</html>", revisions="<html>
<ul>
<li>
January 28, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Speed_primary_localDP;
