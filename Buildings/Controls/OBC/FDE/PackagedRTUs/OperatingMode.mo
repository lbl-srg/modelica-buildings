within Buildings.Controls.OBC.FDE.PackagedRTUs;
block OperatingMode
  "Determine occupied or setback operating mode"

  parameter Real TUpcntM(
    min=0.1,
    max=0.9,
    final unit="1")=0.15
    "Minimum decimal percentage of terminal unit requests required for mode change";

  // --- inputs ---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput occ
    "True when occupied mode is active"
    annotation (Placement(transformation(extent={{-160,48},{-120,88}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput occReq
    "Terminal unit occupancy requests"
    annotation (Placement(transformation(extent={{-160,10},{-120,50}}),
        iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput TotalTU
    "Total number of terminal units"
    annotation (Placement(transformation(extent={{-160,-30},{-120,10}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

   Buildings.Controls.OBC.CDL.Interfaces.IntegerInput sbcReq
    "Terminal unit setback cooling requests"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput sbhReq
    "Terminal unit setback heating requests"
    annotation (Placement(transformation(extent={{-160,-98},{-120,-58}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  // --- outputs ---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOcc
    "True when occupied mode is active"
    annotation (Placement(transformation(extent={{140,34},{180,74}}),
        iconTransformation(extent={{100,34},{140,74}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySBC
    "True when setback cooling mode is active"
    annotation (Placement(transformation(extent={{140,-48},{180,-8}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySBH
    "True when setback heating mode is active"
    annotation (Placement(transformation(extent={{140,-90},{180,-50}}),
        iconTransformation(extent={{100,-70},{140,-30}})));


  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Logical OR"
    annotation (Placement(transformation(extent={{22,58},{42,78}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical AND"
    annotation (Placement(transformation(extent={{94,-38},{114,-18}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical NOT"
    annotation (Placement(transformation(extent={{58,-20},{78,0}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Logical AND"
    annotation (Placement(transformation(extent={{94,-80},{114,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Greater intGre
    "True if greater than set point."
    annotation (Placement(transformation(extent={{-14,20},{6,40}})));
  Buildings.Controls.OBC.CDL.Integers.Greater intGre1
    "True if greater than set point."
    annotation (Placement(transformation(extent={{-12,-50},{8,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Greater intGre2
    "True if greater than set point."
    annotation (Placement(transformation(extent={{-12,-88},{8,-68}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert Integer to Real value."
    annotation (Placement(transformation(extent={{-112,-20},{-92,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(
    final k=TUpcntM)
    "Multiply input with fixed gain value."
    annotation (Placement(transformation(extent={{-84,-20},{-64,0}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert Real value to Integer"
    annotation (Placement(transformation(extent={{-56,-20},{-36,0}})));

equation
  connect(or2.u1,occ)
  annotation (Line(points={{20,68},{-140,68}},color={255,0,255}));
  connect(or2.y, yOcc)
    annotation (Line(points={{44,68},{50,68},{50,54},{160,54}},
     color={255,0,255}));
  connect(not1.y, and2.u1)
    annotation (Line(points={{80,-10},{86,-10},{86,-28},{92,-28}},
      color={255,0,255}));
  connect(not1.u, yOcc)
    annotation (Line(points={{56,-10},{50,-10},{50,54},{160,54}},
      color={255,0,255}));
  connect(and2.y, ySBC)
    annotation (Line(points={{116,-28},{160,-28}},
       color={255,0,255}));
  connect(and1.u1, and2.u1)
    annotation (Line(points={{92,-70},{86,-70},{86,-28},{92,-28}},
      color={255,0,255}));
  connect(and1.y, ySBH)
    annotation (Line(points={{116,-70},{160,-70}},color={255,0,255}));
  connect(intGre.u1,occReq)
    annotation (Line(points={{-16,30},{-140,30}}, color={255,127,0}));
  connect(intGre.y, or2.u2)
    annotation (Line(points={{8,30},{14,30},{14,60},{20,60}},
      color={255,0,255}));
  connect(and2.u2, intGre1.y)
    annotation (Line(points={{92,-36},{52,-36},{52,-40},{10,-40}},
      color={255,0,255}));
  connect(and1.u2, intGre2.y)
    annotation (Line(points={{92,-78},{10,-78}},  color={255,0,255}));
  connect(intGre1.u1,sbcReq)
    annotation (Line(points={{-14,-40},{-140,-40}}, color={255,127,0}));
  connect(intGre2.u1,sbhReq)
    annotation (Line(points={{-14,-78},{-140,-78}}, color={255,127,0}));
  connect(TotalTU, intToRea.u)
    annotation (Line(points={{-140,-10},{-134,-10},{-134,-12},{-128,-12},
      {-128,-10},{-114,-10}},
        color={255,127,0}));
  connect(intToRea.y, gai.u)
    annotation (Line(points={{-90,-10},{-86,-10}},
         color={0,0,127}));
  connect(gai.y, reaToInt.u)
    annotation (Line(points={{-62,-10},{-58,-10}},
         color={0,0,127}));
  connect(intGre.u2, reaToInt.y)
    annotation (Line(points={{-16,22},{-28,22},{-28,-10},{-34,-10}},
         color={255,127,0}));
  connect(intGre1.u2, reaToInt.y)
    annotation (Line(points={{-14,-48},{-28,-48},{-28,-10},{-34,-10}},
          color={255,127,0}));
  connect(intGre2.u2, reaToInt.y)
    annotation (Line(points={{-14,-86},{-28,-86},{-28,-10},{-34,-10}},
          color={255,127,0}));
  annotation (defaultComponentName="OpMode",
         Icon(coordinateSystem(preserveAspectRatio=false,
           extent={{-100,-100},{100,100}}),
           graphics={
          Rectangle(extent={{-100,100},{100,-100}},
              lineColor={179,151,128},
          radius=20,
          fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
        Text(
          extent={{-54,150},{68,94}},
          lineColor={28,108,200},
          fillColor={179,151,128},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-98,66},{-72,52}},
          lineColor={217,67,180},
          textString="Occ"),
        Text(
          extent={{-96,36},{-70,22}},
          lineColor={0,0,255},
          textString="OccReq"),
        Text(
          extent={{-96,6},{-72,-8}},
          lineColor={0,0,255},
          textString="TotalTU"),
        Text(
          extent={{-96,-24},{-72,-38}},
          lineColor={0,0,255},
          textString="SBCreq"),
        Text(
          extent={{-96,-54},{-72,-66}},
          lineColor={0,0,255},
          textString="SBHreq"),
        Text(
          extent={{62,62},{92,46}},
          lineColor={217,67,180},
          textString="yOcc"),
        Text(
          extent={{64,8},{94,-8}},
          lineColor={217,67,180},
          textString="ySBC"),
        Text(
          extent={{66,-40},{96,-56}},
          lineColor={217,67,180},
          textString="ySBH"),
        Ellipse(extent={{-38,36},{38,-38}}, lineColor={179,151,128},
          fillPattern=FillPattern.Sphere,
          fillColor={179,151,128}),
        Line(
          points={{0,34},{0,20}},
          color={179,151,128},
          smooth=Smooth.Bezier),
        Line(
          points={{0,-22},{0,-36}},
          color={179,151,128},
          smooth=Smooth.Bezier),
        Line(
          points={{0,7},{0,-7}},
          color={179,151,128},
          smooth=Smooth.Bezier,
          origin={-28,-1},
          rotation=90),
        Line(
          points={{0,7},{0,-7}},
          color={179,151,128},
          smooth=Smooth.Bezier,
          origin={28,1},
          rotation=90),
        Ellipse(extent={{-2,2},{2,-2}},   lineColor={179,151,128},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,2},{24,34},{26,32},{2,0},{2,2},{0,2}},
          lineColor={179,151,128},
          smooth=Smooth.Bezier,
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(preserveAspectRatio=false,
        extent={{-120,-100},{140,
            100}}), graphics={
        Rectangle(
          extent={{-120,98},{140,8}},
          lineColor={179,151,128},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Text(
          extent={{70,92},{134,78}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Pass through occupancy signal or force
occupied mode when total number of
terminal unit occupancy requests exceed
calculated percentage of terminal units.",
          horizontalAlignment=TextAlignment.Left),
        Rectangle(
          extent={{-120,4},{140,-94}},
          lineColor={179,151,128},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Text(
          extent={{-112,-50},{-48,-64}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="When not in occupied mode allow
setback cooling or setback heating
mode to be active when respective
number of terminal unit setback
cooling or heating requests exceed
calculated percentage of terminal units.")}),
    Documentation(info="<html>
<p>Selection of the operating mode performed by the BAS
 and transmitted to the factory controller. </p>
<h4>Occupied Mode</h4>
<p>The normal occupied mode 
(<code>yOcc</code>) is selected when indicated by the RTU occupancy schedule 
(<code>Occ</code>) or when occupancy overrides from the terminal units 
(<code>OccReq</code>) exceed a percentage 
(<code>TUpcnt</code> default 15%) of the total number
 of terminal units (<code>TotalTU</code>).</p>
<h4>Setback Cooling Mode</h4>
<p>The setback cooling mode 
(<code>ySBC</code>) is selected when occupied mode is not active and 
setback cooling requests from the terminal units 
(<code>SBCreq</code>) exceed a percentage 
(<code>TUpcnt</code> default 15%) of the total number of terminal units 
(<code>TotalTU</code>).</p>
<h4>Setback Heating Mode</h4>
<p>The setback heating mode (<code>ySBH</code>) is selected when occupied mode is 
not active and setback heating requests from the terminal units 
(<code>SBHreq</code>) exceed a percentage 
(<code>TUpcnt</code> default 15%) of the total number of terminal units 
(<code>TotalTU</code>).</p>
</html>",
      revisions="<html>
<ul>
<li>June 4, 2020, by Henry Nickels:<br/>
Changed Real inputs to Integer type. 
</li>
<li>May 28, 2020, by Henry Nickels:<br/>
First implementation. 
</li>
</ul>
</html>"));
end OperatingMode;
