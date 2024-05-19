within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences;
block Speed_flow
  "Pump speed control for primary-secondary plants where flowrate sensors are available in the hot water circuit"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType= Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Speed controller"));

  parameter Boolean use_priSecSen = true
    "True: Use flowrate sensor in primary and secondary circuits for regulation;
    False: Use flowrate sensor in decoupler for regulation";

  parameter Integer nPum = 2
    "Total number of hot water pumps";

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

  parameter Real k(
    final unit="1",
    displayUnit="1")=1
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

  parameter Real VHotWat_flow_nominal(
    final min=1e-6,
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")=0.5
    "Total plant design hot water flow rate";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotWatPum[nPum]
    "Hot water pump status"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatPri_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") if use_priSecSen
    "Measured hot water flow rate through primary circuit"
    annotation (Placement(transformation(extent={{-160,-50},{-120,-10}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatSec_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") if use_priSecSen
    "Measured hot water flow rate through secondary circuit"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatDec_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") if not use_priSecSen
    "Measured hot water flow rate through decoupler"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatPumSpe(
    final min=minPumSpe,
    final max=maxPumSpe,
    final unit="1",
    displayUnit="1")
    "Hot water pump speed"
    annotation (Placement(transformation(extent={{120,80},{160,120}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=1,
    final yMin=0)
    "PID loop to regulate flow through decoupler leg"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Reset PID loop when it is activated"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Line pumSpe
    "Pump speed"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub2 if use_priSecSen
    "Compare measured flowrate in primary and secondary loops"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Divide div if use_priSecSen
    "Normalize flow-rate value"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nPum)
    "Check if any hot water primary pumps are enabled"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pumSpe_min(
    final k=minPumSpe)
    "Minimum pump speed"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pumSpe_max(
    final k=maxPumSpe)
    "Maximum pump speed"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Logical switch"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=1e-6) if use_priSecSen
    "Ensure divisor is non-zero"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=1/VHotWat_flow_nominal) if not use_priSecSen
    "Normalize flowrate"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));

equation
  connect(zer.y, pumSpe.x1)
    annotation (Line(points={{-58,90},{-30,90},{-30,68},{58,68}},
                                                              color={0,0,127}));

  connect(pumSpe_min.y, pumSpe.f1)
    annotation (Line(points={{-58,60},{-40,60},{-40,64},{58,64}}, color={0,0,127}));

  connect(one.y, pumSpe.x2)
    annotation (Line(points={{-58,30},{-40,30},{-40,56},{58,56}}, color={0,0,127}));

  connect(pumSpe_max.y, pumSpe.f2)
    annotation (Line(points={{2,40},{20,40},{20,52},{58,52}}, color={0,0,127}));

  connect(pumSpe.y, swi.u1)
    annotation (Line(points={{82,60},{100,60},{100,80},{60,80},{60,108},{78,108}},
      color={0,0,127}));

  connect(zer.y, swi.u3)
    annotation (Line(points={{-58,90},{-30,90},{-30,92},{78,92}},
      color={0,0,127}));

  connect(swi.y,yHotWatPumSpe)
    annotation (Line(points={{102,100},{140,100}}, color={0,0,127}));

  connect(uHotWatPum, mulOr.u[1:nPum]) annotation (Line(points={{-140,0},{-122,0},{
          -122,0},{-102,0}},       color={255,0,255}));
  connect(mulOr.y, swi.u2) annotation (Line(points={{-78,0},{-50,0},{-50,100},{78,
          100}}, color={255,0,255}));
  connect(VHotWatPri_flow,sub2. u1) annotation (Line(points={{-140,-30},{-110,-30},
          {-110,-34},{-102,-34}}, color={0,0,127}));
  connect(VHotWatSec_flow,sub2. u2) annotation (Line(points={{-140,-60},{-106,-60},
          {-106,-46},{-102,-46}}, color={0,0,127}));
  connect(sub2.y, div.u1) annotation (Line(points={{-78,-40},{-70,-40},{-70,-64},
          {-62,-64}}, color={0,0,127}));
  connect(addPar.y, div.u2) annotation (Line(points={{-78,-70},{-70,-70},{-70,-76},
          {-62,-76}}, color={0,0,127}));
  connect(VHotWatPri_flow, addPar.u) annotation (Line(points={{-140,-30},{-110,-30},
          {-110,-70},{-102,-70}}, color={0,0,127}));

  connect(VHotWatDec_flow, gai.u)
    annotation (Line(points={{-140,-100},{-62,-100}}, color={0,0,127}));
  connect(zer.y, conPID.u_s) annotation (Line(points={{-58,90},{-30,90},{-30,0},
          {18,0}}, color={0,0,127}));
  connect(mulOr.y, edg.u) annotation (Line(points={{-78,0},{-50,0},{-50,-20},{
          -42,-20}}, color={255,0,255}));
  connect(edg.y, conPID.trigger)
    annotation (Line(points={{-18,-20},{24,-20},{24,-12}}, color={255,0,255}));
  connect(div.y, conPID.u_m)
    annotation (Line(points={{-38,-70},{30,-70},{30,-12}}, color={0,0,127}));
  connect(gai.y, conPID.u_m)
    annotation (Line(points={{-38,-100},{30,-100},{30,-12}}, color={0,0,127}));
  connect(conPID.y, pumSpe.u)
    annotation (Line(points={{42,0},{50,0},{50,60},{58,60}}, color={0,0,127}));
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
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
Documentation(info="<html>
<p>
Block that outputs hot water pump speed setpoint for primary-secondary plants with
variable-speed primary pumps with flow sensors present in the primary and secondary
loops, or in the decoupler, according to ASHRAE RP-1711, March, 2020 draft, 
sections 5.3.6.12 and 5.3.6.13.
</p>
<p>
When any hot water pump is proven on, <code>uHotWatPum = true</code>, 
pump speed<code>yHotWatPumSpe</code> will be controlled by a reverse acting PID
loop maintaining the flowrate through the decoupler at zero. PID loop output 
shall be mapped from minimum pump speed (<code>minPumSpe</code>) at 0% to maximum
pump speed(<code>maxPumSpe</code>) at 100%.
</p>
<ol>
<li>
When the plant has flowrate sensors in the primary and secondary loops,
<code>use_priSecSen = true</code>, the measured flowrate in primary
loop <code>VHotWatPri_flow</code> and the measured flowrate in secondary loop
<code>VHotWatSec_flow</code> is used to calculate the flow through the decoupler
(<code>VHotWatPri_flow - VHotWatSec_flow</code>) and generate the control signal.
</li>
<li>
When the plant has a flowrate sensor in the decoupler, 
<code>use_priSecSen = false</code>, the measured flowrate through the
decoupler is used to calculate the control signal.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 4, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end Speed_flow;
