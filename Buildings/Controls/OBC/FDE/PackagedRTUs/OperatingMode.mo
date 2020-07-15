within Buildings.Controls.OBC.FDE.PackagedRTUs;
block OperatingMode "Determine occupied or setback operating mode"

  parameter Real TUpcntM(
    min=0.1,
    max=0.9,
    final unit="1")=0.15
    "Minimum decimal percentage of terminal unit requests required for mode change";

  // --- inputs ---
  input Buildings.Controls.OBC.CDL.Interfaces.BooleanInput occ
    "True when occupied mode is active"
    annotation (Placement(transformation(extent={{-140,62},{-100,102}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput occReq
    "Terminal unit occupancy requests"
    annotation (Placement(transformation(extent={{-140,32},{-100,72}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput TotalTU
    "Total number of terminal units"
    annotation (Placement(transformation(extent={{-140,2},{-100,42}})));
   Buildings.Controls.OBC.CDL.Interfaces.IntegerInput sbcReq
    "Terminal unit setback cooling requests"
    annotation (Placement(transformation(extent={{-140,-56},{-100,-16}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput sbhReq
    "Terminal unit setback heating requests" annotation (Placement(
        transformation(extent={{-140,-98},{-100,-58}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOcc
    "True when occupied mode is active"
    annotation (Placement(transformation(extent={{164,48},{204,88}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySBC
    "True when setback cooling mode is active"
    annotation (Placement(transformation(extent={{164,-48},{204,-8}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySBH
    "True when setback heating mode is active"
    annotation (Placement(transformation(extent={{164,-90},{204,-50}})));

  // --- outputs ---
  Buildings.Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{42,58},{62,78}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{114,-38},{134,-18}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{78,-20},{98,0}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    annotation (Placement(transformation(extent={{114,-80},{134,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Greater intGre
    annotation (Placement(transformation(extent={{6,42},{26,62}})));
  Buildings.Controls.OBC.CDL.Integers.Greater intGre1
    annotation (Placement(transformation(extent={{8,-46},{28,-26}})));
  Buildings.Controls.OBC.CDL.Integers.Greater intGre2
    annotation (Placement(transformation(extent={{8,-88},{28,-68}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{-94,12},{-74,32}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=TUpcntM)
    annotation (Placement(transformation(extent={{-66,12},{-46,32}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{-38,12},{-18,32}})));
equation
  connect(or2.u1,occ)  annotation (Line(points={{40,68},{34,68},{34,82},{-120,82}},
                      color={255,0,255}));
  connect(or2.y, yOcc)
    annotation (Line(points={{64,68},{184,68}},color={255,0,255}));
  connect(not1.y, and2.u1) annotation (Line(points={{100,-10},{106,-10},{106,
          -28},{112,-28}},
                     color={255,0,255}));
  connect(not1.u, yOcc) annotation (Line(points={{76,-10},{70,-10},{70,68},{184,
          68}},     color={255,0,255}));
  connect(and2.y, ySBC) annotation (Line(points={{136,-28},{184,-28}},
                           color={255,0,255}));
  connect(and1.u1, and2.u1) annotation (Line(points={{112,-70},{106,-70},{106,
          -28},{112,-28}},color={255,0,255}));
  connect(and1.y, ySBH)
    annotation (Line(points={{136,-70},{184,-70}},color={255,0,255}));
  connect(intGre.u1,occReq)
    annotation (Line(points={{4,52},{-120,52}},   color={255,127,0}));
  connect(intGre.y, or2.u2) annotation (Line(points={{28,52},{34,52},{34,60},{40,
          60}}, color={255,0,255}));
  connect(and2.u2, intGre1.y)
    annotation (Line(points={{112,-36},{30,-36}}, color={255,0,255}));
  connect(and1.u2, intGre2.y)
    annotation (Line(points={{112,-78},{30,-78}}, color={255,0,255}));
  connect(intGre1.u1,sbcReq)
    annotation (Line(points={{6,-36},{-120,-36}},   color={255,127,0}));
  connect(intGre2.u1,sbhReq)
    annotation (Line(points={{6,-78},{-120,-78}},   color={255,127,0}));
  connect(TotalTU, intToRea.u)
    annotation (Line(points={{-120,22},{-96,22}}, color={255,127,0}));
  connect(intToRea.y, gai.u)
    annotation (Line(points={{-72,22},{-68,22}}, color={0,0,127}));
  connect(gai.y, reaToInt.u)
    annotation (Line(points={{-44,22},{-40,22}}, color={0,0,127}));
  connect(intGre.u2, reaToInt.y) annotation (Line(points={{4,44},{-8,44},{-8,22},
          {-16,22}}, color={255,127,0}));
  connect(intGre1.u2, reaToInt.y) annotation (Line(points={{6,-44},{-8,-44},{-8,
          22},{-16,22}}, color={255,127,0}));
  connect(intGre2.u2, reaToInt.y) annotation (Line(points={{6,-86},{-8,-86},{-8,
          22},{-16,22}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {160,100}}),                                        graphics={
          Rectangle(extent={{-98,100},{160,-104}},lineColor={179,151,128},
          radius=20),
        Text(
          extent={{-38,104},{84,48}},
          lineColor={28,108,200},
          fillColor={179,151,128},
          fillPattern=FillPattern.Solid,
          textString="OperatingMode"),
        Text(
          extent={{-100,82},{-70,66}},
          lineColor={217,67,180},
          textString="Occ"),
        Text(
          extent={{-98,52},{-72,38}},
          lineColor={0,0,255},
          textString="OccReq"),
        Text(
          extent={{-96,20},{-72,6}},
          lineColor={0,0,255},
          textString="TotalTU"),
        Text(
          extent={{-96,-22},{-72,-36}},
          lineColor={0,0,255},
          textString="SBCreq"),
        Text(
          extent={{-96,-64},{-72,-76}},
          lineColor={0,0,255},
          textString="SBHreq"),
        Text(
          extent={{122,66},{152,50}},
          lineColor={217,67,180},
          textString="yOcc"),
        Text(
          extent={{124,-14},{154,-30}},
          lineColor={217,67,180},
          textString="ySBC"),
        Text(
          extent={{126,-56},{156,-72}},
          lineColor={217,67,180},
          textString="ySBH"),
        Ellipse(extent={{-18,54},{58,-20}}, lineColor={179,151,128},
          fillPattern=FillPattern.Sphere,
          fillColor={179,151,128}),
        Line(
          points={{20,52},{20,38}},
          color={179,151,128},
          smooth=Smooth.Bezier),
        Line(
          points={{20,-4},{20,-18}},
          color={179,151,128},
          smooth=Smooth.Bezier),
        Line(
          points={{0,7},{0,-7}},
          color={179,151,128},
          smooth=Smooth.Bezier,
          origin={-8,17},
          rotation=90),
        Line(
          points={{0,7},{0,-7}},
          color={179,151,128},
          smooth=Smooth.Bezier,
          origin={48,19},
          rotation=90),
        Ellipse(extent={{18,20},{22,16}}, lineColor={179,151,128},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,20},{44,52},{46,50},{22,18},{22,20},{20,20}},
          lineColor={179,151,128},
          smooth=Smooth.Bezier,
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{102,76},{114,-64}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{64,20},{96,16}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-54,18},{-22,14}},
          lineColor={162,29,33},
          fillColor={179,151,128},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{110,68},{160,66}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-70,86},{-58,-72}},
          lineColor={162,29,33},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-98,82},{-66,80}},
          lineColor={162,29,33},
          fillColor={179,151,128},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-98,52},{-66,50}},
          lineColor={162,29,33},
          fillColor={179,151,128},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-98,22},{-66,20}},
          lineColor={162,29,33},
          fillColor={179,151,128},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-98,-22},{-66,-24}},
          lineColor={162,29,33},
          fillColor={179,151,128},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-98,-64},{-66,-66}},
          lineColor={162,29,33},
          fillColor={179,151,128},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{110,-12},{160,-14}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{110,-54},{160,-56}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.HorizontalCylinder)}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{160,
            100}}), graphics={
        Rectangle(
          extent={{-100,98},{160,8}},
          lineColor={179,151,128},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Text(
          extent={{90,92},{154,78}},
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
          extent={{-100,4},{160,-94}},
          lineColor={179,151,128},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Text(
          extent={{-88,-6},{-24,-20}},
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
<p>Selection of the operating mode performed by the BAS and transmitted to the factory controller. </p>
<h4>Occupied Mode</h4>
<p>The normal occupied mode (<code>yOcc</code>) is selected when indicated by the RTU occupancy schedule (<code>Occ</code>) or when occupancy overrides from the terminal units (<code>OccReq</code>) exceed a percentage (<code>TUpcnt</code> default 15%) of the total number of terminal units (<code>TotalTU</code>).</p>
<h4>Setback Cooling Mode</h4>
<p>The setback cooling mode (<code>ySBC</code>) is selected when occupied mode is not active and setback cooling requests from the terminal units (<code>SBCreq</code>) exceed a percentage (<code>TUpcnt</code> default 15%) of the total number of terminal units (<code>TotalTU</code>).</p>
<h4>Setback Heating Mode</h4>
<p>The setback heating mode (<code>ySBH</code>) is selected when occupied mode is not active and setback heating requests from the terminal units (<code>SBHreq</code>) exceed a percentage (<code>TUpcnt</code> default 15%) of the total number of terminal units (<code>TotalTU</code>).</p>
</html>",
      revisions="<html>
<ul>
<li>June 4, 2020, by Henry Nickels:<br>Changed Real inputs to Integer type. </li>
<li>May 28, 2020, by Henry Nickels:<br>First implementation. </li>
</ul>
</html>"));
end OperatingMode;
