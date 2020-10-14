within Buildings.Controls.OBC.FDE.DOAS;
block DehumMode
  "This block calculates when dehumidification mode is active."

  parameter Real dehumSet(
    final min=0,
    final max=100)=60
   "Dehumidification set point.";

  parameter Real dehumDelay(
    final unit="s",
    final quantity="Time")=600
    "Minimum delay after RH falls below set point before turning dehum off.";

  parameter Real minRun(
    final unit="s",
    final quantity="Time")=120
    "Minimum supply fan proof delay before allowing dehum mode.";

    // ---inputs---
  Buildings.Controls.OBC.CDL.Interfaces.RealInput retHum(
    final unit="1",
    final min=0,
    final max=100)
    "Return air relative humidity sensor."
      annotation (Placement(transformation(extent={{-142,-20},{-102,20}}),
        iconTransformation(extent={{-142,-20},{-102,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput supFanProof
    "True when supply fan is proven on"
      annotation (Placement(transformation(extent={{-142,18},{-102,58}}),
        iconTransformation(extent={{-142,52},{-102,92}})));

    // ---outputs---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput dehumMode
    "True when dehumidification mode is active."
      annotation (Placement(transformation(extent={{102,-12},{142,28}}),
        iconTransformation(extent={{102,-20},{142,20}})));


  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Latches true when retHum > dehumSet; resets when 
      retHum < dehumSet for dehumDelay time"
    annotation (Placement(transformation(extent={{22,-10},{42,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre
    "True when return humidity > set point"
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les
    "True when return humidity < set point"
    annotation (Placement(transformation(extent={{-44,-42},{-24,-22}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conDset(
    final k=dehumSet)
    "Dehumidification set point"
      annotation (Placement(transformation(extent={{-88,-50},{-68,-30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    delayTime=dehumDelay)
      "Minimum dehumidification time before disable when below set point."
        annotation (Placement(transformation(extent={{-14,-42},{6,-22}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical AND; true when minimum fan runtime is met and 
      return humidity set point conditions are met."
    annotation (Placement(transformation(extent={{58,-2},{78,18}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay minimumRun(
    delayTime=minRun,
    delayOnInit=true)
      "Minimum supply fan runtime before enabling dehum mode."
        annotation (Placement(transformation(extent={{-44,28},{-24,48}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay init_delay(
    final delayTime=5,
    final delayOnInit=true)
    "Delays the initial trigger for latch to correctly capture true state 
      when CDL starts with humidity above set point."
    annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
equation
  connect(retHum, gre.u1)
    annotation (Line(points={{-122,0},{-46,0}}, color={0,0,127}));
  connect(retHum, les.u1)
    annotation (Line(points={{-122,0},{-56,0},{-56,-32},{-46,-32}},
      color={0,0,127}));
  connect(conDset.y, les.u2)
    annotation (Line(points={{-66,-40},{-46,-40}}, color={0,0,127}));
  connect(conDset.y, gre.u2)
    annotation (Line(points={{-66,-40},{-60,-40},{-60,-8},{-46,-8}},
      color={0,0,127}));
  connect(les.y, truDel.u)
    annotation (Line(points={{-22,-32},{-16,-32}}, color={255,0,255}));
  connect(truDel.y, lat.clr)
    annotation (Line(points={{8,-32},{14,-32},{14,-6},{20,-6}},
      color={255,0,255}));
  connect(lat.y, and2.u2)
    annotation (Line(points={{44,0},{56,0}}, color={255,0,255}));
  connect(dehumMode, dehumMode)
    annotation (Line(points={{122,8},{122,8}}, color={255,0,255}));
  connect(and2.y, dehumMode)
    annotation (Line(points={{80,8},{122,8}}, color={255,0,255}));
  connect(supFanProof, minimumRun.u)
    annotation (Line(points={{-122,38},{-46,38}}, color={255,0,255}));
  connect(minimumRun.y, and2.u1)
    annotation (Line(points={{-22,38},{48,38},{48,8},{56,8}},
      color={255,0,255}));
  connect(gre.y, init_delay.u)
    annotation (Line(points={{-22,0},{-16,0}}, color={255,0,255}));
  connect(init_delay.y, lat.u)
    annotation (Line(points={{8,0},{20,0}}, color={255,0,255}));
  annotation (defaultComponentName="DehumMod",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
           Text(
            extent={{-90,180},{90,76}},
            lineColor={28,108,200},
            textStyle={TextStyle.Bold},
            textString="%name"),
            Rectangle(extent={{-100,100},{100,-100}},
            lineColor={179,151,128},
            radius=10,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
        Text(
          extent={{42,10},{96,-8}},
          lineColor={28,108,200},
          textString="dehumMode"),
        Text(
          extent={{-100,8},{-56,-6}},
          lineColor={28,108,200},
          textString="retHum"),
        Rectangle(
          extent={{4,60},{8,-2}},
          lineColor={28,108,200},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{4,-2},{8,-64}},
          lineColor={244,125,35},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-2,42},{36,30}},
          lineColor={28,108,200},
          textString="On"),
        Text(
          extent={{-2,-38},{36,-50}},
          lineColor={28,108,200},
          textString="Off"),
        Text(
          extent={{-36,4},{2,-8}},
          lineColor={28,108,200},
          textString="%dehumSet"),
        Text(
          extent={{-96,80},{-52,66}},
          lineColor={28,108,200},
          textString="supFanProof")}),
                                     Diagram(coordinateSystem(
          preserveAspectRatio=false)),
    Documentation(info="<html>
<h4>Dehumidification Mode</h4>
<p>This block enables dehumidification mode
(<code>dehumMode</code>) when the supply air fan is proven
(<code>supFanProof</code>) for a minimum runtime 
(<code>minRun</code>) and return air humidity
(<code>retHum</code>) is above set point 
(<code>dehumSet</code>).
Dehumidification mode is disabled when return air humidity 
falls below set point for a minimum delay period 
(<code>dehumDelay</code>).</p> 
</html>", revisions="<html>
<ul>
<li>
September 15, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>"));
end DehumMode;
