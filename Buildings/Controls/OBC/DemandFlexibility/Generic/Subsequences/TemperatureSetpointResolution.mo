within Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences;
block TemperatureSetpointResolution
  "Temperature setpoint resolution"
  parameter Real TRes(unit="K")=0.5
    "temperature setpoint resolution";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTSet "setpoint command"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTSet
    "actual setpoint command" annotation (Placement(transformation(extent={{150,
            -20},{190,20}}), iconTransformation(extent={{150,-20},{190,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(k=293.15)
    annotation (Placement(transformation(extent={{-88,-60},{-68,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{-50,38},{-30,58}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1
    annotation (Placement(transformation(extent={{6,32},{26,52}})));
  Buildings.Controls.OBC.CDL.Reals.Round rou(n=0)
    annotation (Placement(transformation(extent={{46,32},{66,52}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    annotation (Placement(transformation(extent={{86,26},{106,46}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    annotation (Placement(transformation(extent={{118,-10},{138,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(k=TRes)
    annotation (Placement(transformation(extent={{-34,4},{-14,24}})));
equation
  connect(uTSet, sub.u1) annotation (Line(points={{-120,0},{-62,0},{-62,54},{-52,
          54}}, color={0,0,127}));
  connect(con.y, sub.u2)
    annotation (Line(points={{-66,-50},{-52,-50},{-52,42}}, color={0,0,127}));
  connect(sub.y, div1.u1) annotation (Line(points={{-28,48},{4,48}},
                     color={0,0,127}));
  connect(div1.y, rou.u)
    annotation (Line(points={{28,42},{44,42}},            color={0,0,127}));
  connect(rou.y, mul.u1) annotation (Line(points={{68,42},{84,42}},
                    color={0,0,127}));
  connect(add2.y, yTSet)
    annotation (Line(points={{140,0},{170,0}}, color={0,0,127}));
  connect(con1.y, div1.u2) annotation (Line(points={{-12,14},{-4,14},{-4,36},{4,
          36}},            color={0,0,127}));
  connect(con1.y, mul.u2) annotation (Line(points={{-12,14},{76,14},{76,30},{84,
          30}},      color={0,0,127}));
  connect(mul.y, add2.u1)
    annotation (Line(points={{108,36},{116,36},{116,6}}, color={0,0,127}));
  connect(con.y, add2.u2) annotation (Line(points={{-66,-50},{-52,-50},{-52,-6},
          {116,-6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{150,100}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{150,
            100}},
        grid={2,2})),
    Documentation(info="<html>
<p>This block adds resolution to a temperature setpoint, such that the temperature 
setpoint value can only fall into specific resolution intervals.</p>
<p>The input variable <code>uTSet</code> can take on any temperature 
value, and the output variable <code>yTSet</code> can only take specific 
temperature values from the resolution intervals. The parameter <code>TRes</code> 
specifies the temperature resolution interval, which can be <code>0.5K</code>, <code>1K</code>, etc. when using 
temperature in Kelvin or Celsius units, or <code>0.5556K</code>, <code>0.2778K</code>, etc. when using 
temperature in the Fehrenheit unit. The base temperature is <code>273.15 + 20 K</code>. The 
output variable <code>yTSet</code> is equal to an integer multiple of <code>TRes</code> 
plus the base temperature that is the closest value to <code>uTSet</code>.</p>
</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>

</ul>
</html>"));
end TemperatureSetpointResolution;
