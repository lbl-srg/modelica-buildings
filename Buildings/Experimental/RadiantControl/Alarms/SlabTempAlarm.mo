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
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Controls.OBC.CDL.Continuous.GreaterEqual           greEqu
    "Test if error is above error threshold"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Controls.OBC.CDL.Logical.Not           not7
    "Zero out integral if error is below threshhold"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Controls.OBC.CDL.Continuous.Sources.Constant           ConZero(k=0)
    "Error integral- constant zero"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Controls.OBC.CDL.Continuous.Sources.Constant           ConOne(k=1)
    "Error integral- constant one"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Controls.OBC.CDL.Logical.Switch           swi
    "Switch integrated function from constant zero to constant one if error is above threshhold"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Controls.OBC.CDL.Continuous.GreaterEqual           greEqALARM
    "True if error has been greater than temperature threshold for more than time threshold, otherwise false"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Controls.OBC.CDL.Continuous.IntegratorWithReset           intWitRes(reset=
        Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
    "Find integral of how long error has been above threshold, reset to zero if error goes below 2 F threshhold"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Controls.OBC.CDL.Interfaces.RealInput slaTemError
    annotation (Placement(transformation(extent={{-220,10},{-180,50}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput slaTemAlarm
    annotation (Placement(transformation(extent={{160,10},{200,50}})));
  Modelica.Blocks.Sources.Constant TError(k=TErr)
    "Temperature amount slab temp must be out of range to trigger alarm, if error is sustained for specified time duration"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Modelica.Blocks.Sources.Constant TiError(k=TiErr)
    "Time slab temp must be out of range to trigger alarm, if error is greater than specified temperature threshhold"
    annotation (Placement(transformation(extent={{38,-62},{58,-42}})));
equation
  connect(intWitRes.y,greEqALARM. u1) annotation (Line(points={{62,30},{78,30}},
                                          color={0,0,127}));
  connect(swi.y,intWitRes. u) annotation (Line(points={{22,30},{38,30}},
                                   color={0,0,127}));
  connect(not7.y,intWitRes. trigger) annotation (Line(points={{-18,-30},{50,-30},
          {50,18}},                       color={255,0,255}));
  connect(ConZero.y,swi. u3) annotation (Line(points={{-18,10},{-4,10},{-4,22},{
          -2,22}},            color={0,0,127}));
  connect(greEqu.y,swi. u2)
    annotation (Line(points={{-58,30},{-2,30}},        color={255,0,255}));
  connect(greEqu.y,not7. u) annotation (Line(points={{-58,30},{-58,-30},{-42,-30}},
                              color={255,0,255}));
  connect(abs.y,greEqu. u1) annotation (Line(points={{-98,30},{-82,30}},
                              color={0,0,127}));
  connect(ConOne.y,swi. u1) annotation (Line(points={{-18,50},{-2,50},{-2,38}},
                              color={0,0,127}));
  connect(TError.y, greEqu.u2) annotation (Line(points={{-99,-10},{-94,-10},{-94,
          22},{-82,22}}, color={0,0,127}));
  connect(TiError.y, greEqALARM.u2) annotation (Line(points={{59,-52},{68,-52},{
          68,22},{78,22}}, color={0,0,127}));
  connect(greEqALARM.y, slaTemAlarm)
    annotation (Line(points={{102,30},{180,30}}, color={255,0,255}));
  connect(slaTemError, abs.u)
    annotation (Line(points={{-200,30},{-122,30}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This block is a slab temperature alarm, which will show true if slab has been a user-specified amount of of range for a user-specified amount of time.  
</p>
</html>"),Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
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
          extent={{-180,-100},{160,100}})));
end SlabTempAlarm;
