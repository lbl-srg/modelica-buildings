within Buildings.Experimental.RadiantControl.Alarms;
block SlabTempAlarm "Trigger alarm is slab temperature is a user-specified amount away from setpoint for a user-specified amount of time"

  parameter Real TiErr(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=14400  "Time threshhold slab temp must be out of range to trigger alarm";
  parameter Real TErr(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1.1 "Difference from slab temp setpoint required to trigger alarm";

  Controls.OBC.CDL.Continuous.Abs           abs
    "Absolute value of difference between slab setpoint and slab temp"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Controls.OBC.CDL.Continuous.GreaterEqual           greEqu
    "Test if error is above error threshold"
    annotation (Placement(transformation(extent={{-64,20},{-44,40}})));
  Controls.OBC.CDL.Logical.Not           not7
    "Zero out integral if error is below threshhold"
    annotation (Placement(transformation(extent={{-40,-82},{-20,-62}})));
  Controls.OBC.CDL.Continuous.Sources.Constant           ConZero(k=0)
    "Error integral- constant zero"
    annotation (Placement(transformation(extent={{-40,-42},{-20,-22}})));
  Controls.OBC.CDL.Continuous.Sources.Constant           ConOne(k=1)
    "Error integral- constant one"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Controls.OBC.CDL.Logical.Switch           swi
    "Switch integrated function from constant zero to constant one if error is above threshhold"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Controls.OBC.CDL.Continuous.GreaterEqual           greEqALARM
    "True if error has been greater than temperature threshold for more than time threshold, otherwise false"
    annotation (Placement(transformation(extent={{62,20},{82,40}})));
  Controls.OBC.CDL.Continuous.IntegratorWithReset           intWitRes(reset=
        Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
    "Find integral of how long error has been above threshold, reset to zero if error goes below 2 F threshhold"
    annotation (Placement(transformation(extent={{22,18},{42,38}})));
  Controls.OBC.CDL.Interfaces.RealInput slaTemError
    annotation (Placement(transformation(extent={{-160,10},{-120,50}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput slaTemAlarm
    annotation (Placement(transformation(extent={{100,10},{140,50}})));
  Modelica.Blocks.Sources.Constant TError(k=TErr)
    "Temperature amount slab temp must be out of range to trigger alarm, if error is sustained for specified time duration"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Sources.Constant TiError(k=TiErr)
    "Time slab temp must be out of range to trigger alarm, if error is greater than specified temperature threshhold"
    annotation (Placement(transformation(extent={{24,-100},{44,-80}})));
equation
  connect(intWitRes.y,greEqALARM. u1) annotation (Line(points={{44,28},{62,28},{
          62,30},{60,30}},                color={0,0,127}));
  connect(swi.y,intWitRes. u) annotation (Line(points={{2,30},{12,30},{12,28},{20,
          28}},                    color={0,0,127}));
  connect(not7.y,intWitRes. trigger) annotation (Line(points={{-18,-72},{32,-72},
          {32,16}},                       color={255,0,255}));
  connect(ConZero.y,swi. u3) annotation (Line(points={{-18,-32},{-18,-6},{-28,-6},
          {-28,22},{-22,22}}, color={0,0,127}));
  connect(greEqu.y,swi. u2)
    annotation (Line(points={{-42,30},{-22,30}},       color={255,0,255}));
  connect(greEqu.y,not7. u) annotation (Line(points={{-42,30},{-42,-72}},
                              color={255,0,255}));
  connect(abs.y,greEqu. u1) annotation (Line(points={{-78,30},{-66,30}},
                              color={0,0,127}));
  connect(ConOne.y,swi. u1) annotation (Line(points={{-18,90},{-18,76},{-22,76},
          {-22,38}},          color={0,0,127}));
  connect(TError.y, greEqu.u2) annotation (Line(points={{-79,-10},{-74,-10},{-74,
          22},{-66,22}}, color={0,0,127}));
  connect(TiError.y, greEqALARM.u2) annotation (Line(points={{45,-90},{58,-90},
          {58,22},{60,22}},color={0,0,127}));
  connect(greEqALARM.y, slaTemAlarm)
    annotation (Line(points={{84,30},{120,30}},  color={255,0,255}));
  connect(slaTemError, abs.u)
    annotation (Line(points={{-140,30},{-102,30}}, color={0,0,127}));
  annotation (defaultComponentName = "SlabTempAlarm",Documentation(info="<html>
<p>
This block is a slab temperature alarm, which will show true if slab has been a user-specified amount of of range for a user-specified amount of time.  
</p>
</html>"),Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-120,-100},{100,100}}), graphics={
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),  Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,-150},{150,-110}},
          lineColor={0,0,0},
          textString="duration=%duration"),
        Polygon(lineColor = {191,0,0},
                fillColor = {191,0,0},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{20,58},{100,-2},{20,-62},{20,58}}),
        Text(
        extent={{-86,90},{28,-88}},
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
        textString="A"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-120,-100},{100,100}})));
end SlabTempAlarm;
