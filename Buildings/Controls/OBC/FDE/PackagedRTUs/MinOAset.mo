within Buildings.Controls.OBC.FDE.PackagedRTUs;
block MinOAset
  "Calculates minimum outside air flow set point for packaged RTU controller"

 parameter Real minOAset(
  final unit="m3/s",
  final quantity="VolumeFlowRate")=0.8
  "Occupied mode minimum outside air flow set point";

 // ---input---
 Buildings.Controls.OBC.CDL.Interfaces.BooleanInput occ
   "Input true when RTU mode is occupied"
   annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  // ---output---
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinOAflowSet(
    unit="m3/s",
    quantity="VolumeFlowRate")
    "The active outside air flow set point sent to the factory controller"
    annotation (Placement(transformation(extent={{104,-20},{144,20}}),
        iconTransformation(extent={{104,-20},{144,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minOAsetpoint(
    k=minOAset) "Minimum outside air flow set point."
    annotation (Placement(transformation(extent={{-52,24},{-32,44}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    "Set the outside air flow set point to zero when not in occupied mode"
    annotation (Placement(transformation(extent={{-50,-48},{-30,-28}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Switch between minimum OA flow set point and 0 based on occupancy mode."
    annotation (Placement(transformation(extent={{4,-10},{24,10}})));

equation
  connect(yMinOAflowSet, yMinOAflowSet)
    annotation (Line(points={{124,0},{124,0}}, color={0,0,127}));
  connect(swi.y, yMinOAflowSet)
    annotation (Line(points={{26,0},{124,0}}, color={0,0,127}));
  connect(con.y, swi.u3)
    annotation (Line(points={{-28,-38},{-20,-38},{-20,-8},
          {2,-8}}, color={0,0,127}));
  connect(minOAsetpoint.y, swi.u1)
    annotation (Line(points={{-30,34},{-20,34},{
          -20,8},{2,8}}, color={0,0,127}));
  connect(occ, swi.u2)
    annotation (Line(points={{-120,0},{2,0}}, color={255,0,255}));
  annotation (defaultComponentName="MinOAset",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={179,151,128},
          radius=20,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                     Text(
          extent={{-22,124},{22,96}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={179,151,128},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Line(points={{-42,18},{-26,18},{30,18}},    color={179,151,128},
          thickness=0.5),
        Line(points={{-42,-14},{-26,-14},{30,-14}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-42,18},{-40,16},{-28,2}},     color={179,151,128},
          thickness=0.5),
        Line(points={{-42,-14},{-28,2}},   color={179,151,128},
          thickness=0.5),
        Ellipse(extent={{16,4},{20,0}},       lineColor={179,151,128},
          lineThickness=0.5,
          fillColor={179,151,128},
          fillPattern=FillPattern.Solid),
        Line(points={{20,4},{28,14}},     color={179,151,128},
          thickness=0.5),
        Line(points={{8,-10},{16,0}},      color={179,151,128},
          thickness=0.5),
        Rectangle(extent={{-16,16},{-12,-12}},  lineColor={179,151,128},
          lineThickness=0.5,
          fillColor={179,151,128},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,6},{-76,-4}},
          lineColor={217,67,180},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={179,151,128},
          textString="Occ"),
        Text(
          extent={{50,14},{96,-12}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={179,151,128},
          textString="yminOAflowStpt")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={179,151,128},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{24,-30},{64,-58}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="When the unit is in occupied
mode the fixed minimum
outside air flow value is
passed to the RTU set point.
When the unit is not in occupied
mode a value of 0 is passed
for the outside air flow set
point.",  horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{-14,12},{-2,10}},
          lineColor={162,29,33},
          textString="true"),
        Text(
          extent={{-12,-10},{0,-12}},
          lineColor={162,29,33},
          textString="false")}),
    Documentation(revisions="<html>
<ul>
<li>May 28, 2020, by Henry Nickels:<br>First implementation. </li>
</ul>
</html>",
      info="<html>
<p>If operating mode is occupied 
(<code>Occ</code>) select minimum outside air flow set point 
(<code>minOAflowStpt</code>), otherwise select zero flow set point. Decision made by the BAS 
and transmitted to the factory controller 
(<code>yminOAflowStpt</code>). </p>
</html>"));
end MinOAset;
