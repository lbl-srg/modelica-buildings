within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block ResetMinBypass
  "Sequence for reset minimum chilled water flow setpoint"

  parameter Modelica.SIunits.Time aftByPasSetTim = 60
    "Time after setpoint achieved";
  parameter Real relFloDif=0.025
    "Hysteresis to check if flow achieves setpoint"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of resetting status of device before reset minimum flow setpoint"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaCha
    "Indicate if there is stage change"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VMinChiWat_setpoint(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Minimum chiller water flow setpoint"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMinBypRes
    "Minimum chilled water flow bypass setpoint reset status"
    annotation (Placement(transformation(extent={{160,60},{200,100}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=0.95 -relFloDif,
    final uHigh=0.95 + relFloDif)
    "Check if chiller water flow reached setpoint"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and1 "Logical and"
    annotation (Placement(transformation(extent={{120,70},{140,90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim "Time after achiving setpoint"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=aftByPasSetTim)
    "Check if it is 1 minute after new setpoint achieved"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div
    "Measured flow rate divided by its setpoint"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=1e-6, final k=1)
    "Add a small positive to avoid zero output"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg2
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

equation
  connect(uUpsDevSta, and2.u1)
    annotation (Line(points={{-180,80},{-82,80}}, color={255,0,255}));
  connect(uStaCha, and2.u2)
    annotation (Line(points={{-180,40},{-140,40},{-140,72},{-82,72}},
      color={255,0,255}));
  connect(tim.y, greEquThr.u)
    annotation (Line(points={{42,-40},{58,-40}}, color={0,0,127}));
  connect(and2.y, and1.u1)
    annotation (Line(points={{-58,80},{-50,80},{-50,88},{118,88}},
      color={255,0,255}));
  connect(and1.y,yMinBypRes)
    annotation (Line(points={{142,80},{180,80}}, color={255,0,255}));
  connect(uStaCha, not1.u)
    annotation (Line(points={{-180,40},{-140,40},{-140,20},{-122,20}},
      color={255,0,255}));
  connect(lat.y, and1.u2)
    annotation (Line(points={{82,40},{90,40},{90,80},{118,80}},
      color={255,0,255}));
  connect(greEquThr.y, and1.u3)
    annotation (Line(points={{82,-40},{100,-40},{100,72},{118,72}},
      color={255,0,255}));
  connect(VMinChiWat_setpoint, addPar.u)
    annotation (Line(points={{-180,-80},{-142,-80}}, color={0,0,127}));
  connect(VChiWat_flow, div.u1)
    annotation (Line(points={{-180,-20},{-140,-20},{-140,-34},{-122,-34}},
      color={0,0,127}));
  connect(div.y, hys.u)
    annotation (Line(points={{-98,-40},{-82,-40}}, color={0,0,127}));
  connect(not1.y, edg1.u)
    annotation (Line(points={{-98,20},{-82,20}}, color={255,0,255}));
  connect(edg1.y, lat.clr)
    annotation (Line(points={{-58,20},{40,20},{40,34},{58,34}},
      color={255,0,255}));
  connect(hys.y, and3.u1)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={255,0,255}));
  connect(and2.y, and3.u2)
    annotation (Line(points={{-58,80},{-50,80},{-50,-48},{-42,-48}},
      color={255,0,255}));
  connect(and3.y, tim.u)
    annotation (Line(points={{-18,-40},{18,-40}}, color={255,0,255}));
  connect(addPar.y, div.u2)
    annotation (Line(points={{-118,-80},{-100,-80},{-100,-60},{-140,-60},
      {-140,-46},{-122,-46}}, color={0,0,127}));
  connect(and3.y, edg2.u)
    annotation (Line(points={{-18,-40},{-10,-40},{-10,40},{-2,40}},
      color={255,0,255}));
  connect(edg2.y, lat.u)
    annotation (Line(points={{22,40},{58,40}}, color={255,0,255}));

annotation (
  defaultComponentName="minBypRes",
  Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{50,8},{98,-8}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yMinBypRes"),
        Text(
          extent={{-98,-32},{-50,-46}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VChiWat_flow"),
        Text(
          extent={{-98,-72},{-30,-88}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VMinChiWat_setpoint"),
        Text(
          extent={{-98,46},{-66,36}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaCha"),
      Text(
        extent={{-100,100},{100,-100}},
        lineColor={0,0,0},
        textString="S"),
        Text(
          extent={{-98,88},{-52,76}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uUpsDevSta")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-100},{160,100}})),
  Documentation(info="<html>
<p>
Block that generates minimum bypass flow reset status when there is 
stage-change command.
This development is based on ASHRAE RP-1711 Advanced Sequences of Operation for 
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft 6 on July 25, 
2019), section 5.2.4.15, item 2.
</p>
<p>
When there is stage-change command (<code>uStaCha</code> = true) and the upstream
device has finished its adjustment process (<code>uUpsDevSta</code> = true), 
like in the stage-up process the operating chillers have reduced the demand, 
check if the minimum chilled water flow rate <code>VChiWat_flow</code> has achieved 
its new set point <code>VMinChiWat_setpoint</code>. 
After new setpoint is achieved, wait for 1 minute (<code>byPasSetTim</code>) to 
allow loop to stabilize. It will then set <code>yMinBypRes</code> to true.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 17, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ResetMinBypass;
