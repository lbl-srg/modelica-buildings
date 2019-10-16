within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences;
block Speed_primary_remoteDp
  "Pump speed control for primary-only plants where the remote DP sensor(s) is hardwired to the plant controller"
  parameter Integer nSen = 2
    "Total number of remote differential pressure sensors";
  parameter Integer nPum = 2
    "Total number of chilled water pumps";
  parameter Real minPumSpe = 0.1 "Minimum pump speed";
  parameter Real maxPumSpe = 1  "Maximum pump speed";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Speed controller"));
  parameter Real k=1 "Gain of controller"
    annotation(Dialog(group="Speed controller"));
  parameter Modelica.SIunits.Time Ti=0.5 "Time constant of integrator block"
    annotation(Dialog(group="Speed controller"));
  parameter Modelica.SIunits.Time Td=0.1 "Time constant of derivative block"
    annotation (Dialog(group="Speed controller",
      enable=
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat[nSen](
    final unit=fill("Pa", nSen),
    final quantity=fill("PressureDifference", nSen))
    "Chilled water differential static pressure"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatPumSpe(
    final min=minPumSpe,
    final max=maxPumSpe,
    final unit="1") "Chilled water pump speed"
    annotation (Placement(transformation(extent={{120,80},{160,120}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMax maxLoo(
    final nin=nSen) "Maximum DP loop output"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Line pumSpe "Pump speed"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID[nSen](
    final controllerType=fill(controllerType, nSen),
    final k=fill(k, nSen),
    final Ti=fill(Ti, nSen),
    final Td=fill(Td, nSen),
    final yMax=fill(1, nSen),
    final yMin=fill(0, nSen),
    final reverseAction=fill(true, nSen),
    final reset=fill(Buildings.Controls.OBC.CDL.Types.Reset.Parameter, nSen),
    final y_reset=fill(0, nSen)) "Pump speed controller"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    final nout=nSen) "Replicate real input"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=nSen)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant pumSpe_min(
    final k=minPumSpe) "Minimum pump speed"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant pumSpe_max(
    final k=maxPumSpe) "Maximum pump speed"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[nPum] "Logical not"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nu=nPum) "Multiple logical and"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div[nSen]
    "Normalized pressure difference"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep1(
    final nout=nSen) "Replicate real input"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not pumOn
    "Check if there is any pump is ON"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

equation
  connect(conPID.y, maxLoo.u)
    annotation (Line(points={{42,0},{58,0}}, color={0,0,127}));
  connect(booRep.y, conPID.trigger)
    annotation (Line(points={{2,-40},{22,-40},{22,-12}}, color={255,0,255}));
  connect(dpChiWatSet, reaRep.u)
    annotation (Line(points={{-140,-100},{-102,-100}}, color={0,0,127}));
  connect(zer.y, pumSpe.x1)
    annotation (Line(points={{2,80},{20,80},{20,68},{58,68}}, color={0,0,127}));
  connect(pumSpe_min.y, pumSpe.f1)
    annotation (Line(points={{-58,80},{-40,80},{-40,64},{58,64}}, color={0,0,127}));
  connect(one.y, pumSpe.x2)
    annotation (Line(points={{-58,40},{-40,40},{-40,56},{58,56}}, color={0,0,127}));
  connect(pumSpe_max.y, pumSpe.f2)
    annotation (Line(points={{2,40},{20,40},{20,52},{58,52}}, color={0,0,127}));
  connect(maxLoo.y, pumSpe.u)
    annotation (Line(points={{82,0},{100,0},{100,40},{40,40},{40,60},{58,60}},
      color={0,0,127}));
  connect(not2.y,mulAnd. u)
    annotation (Line(points={{-78,0},{-60,0},{-60,-20},{-110,-20},{-110,-40},
      {-102,-40}}, color={255,0,255}));
  connect(uChiWatPum, not2.u)
    annotation (Line(points={{-140,0},{-102,0}}, color={255,0,255}));
  connect(dpChiWat, div.u1)
    annotation (Line(points={{-140,-60},{-40,-60},{-40,-74},{-22,-74}},
      color={0,0,127}));
  connect(reaRep.y, div.u2)
    annotation (Line(points={{-78,-100},{-40,-100},{-40,-86},{-22,-86}},
      color={0,0,127}));
  connect(div.y, conPID.u_m)
    annotation (Line(points={{2,-80},{30,-80},{30,-12}}, color={0,0,127}));
  connect(one.y, reaRep1.u)
    annotation (Line(points={{-58,40},{-40,40},{-40,0},{-22,0}},
      color={0,0,127}));
  connect(reaRep1.y, conPID.u_s)
    annotation (Line(points={{2,0},{18,0}}, color={0,0,127}));
  connect(mulAnd.y, pumOn.u)
    annotation (Line(points={{-78,-40},{-62,-40}},   color={255,0,255}));
  connect(pumOn.y, booRep.u)
    annotation (Line(points={{-38,-40},{-22,-40}}, color={255,0,255}));
  connect(pumOn.y, swi.u2)
    annotation (Line(points={{-38,-40},{-30,-40},{-30,100},{78,100}},
      color={255,0,255}));
  connect(pumSpe.y, swi.u1)
    annotation (Line(points={{82,60},{100,60},{100,80},{60,80},{60,108},{78,108}},
      color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{2,80},{20,80},{20,92},{78,92}},
      color={0,0,127}));
  connect(swi.y, yChiWatPumSpe)
    annotation (Line(points={{102,100},{140,100}}, color={0,0,127}));

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
          extent={{-98,92},{-44,70}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiWatPum"),
        Text(
          extent={{-98,10},{-44,-12}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWat"),
        Text(
          extent={{22,12},{98,-10}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatPumSpe"),
        Text(
          extent={{-98,-68},{-34,-90}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWatSet")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
  Documentation(info="<html>
<p>
Block that output chilled water pump speed setpoint for primary-only plants where
the remote pressure differential sensor is hardwired to the plant controller, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 6 on July 25, 2019), 
section 5.2.6 Primary chilled water pumps, part 5.2.6.7 and 5.2.6.8.
</p>
<ol>
<li>
When any chilled water pump is proven on, <code>uChiWatPum</code> = true, 
pump speed will be controlled by a reverse acting PID loop maintaining the
differential pressure signal at a setpoint <code>dpChiWatSet</code>. All pumps
receive the same speed signal. PID loop output shall be mapped from minimum
pump speed (<code>minPumSpe</code>) at 0% to maximum pump speed
(<code>maxPumSpe</code>) at 100%.
</li>
<li>
Where multiple differential pressure sensors exist, a PID loop shall run for
each sensor. Chilled water pumps shall be controlled to the maximum signal output
of all DP sensor loops.
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
end Speed_primary_remoteDp;
