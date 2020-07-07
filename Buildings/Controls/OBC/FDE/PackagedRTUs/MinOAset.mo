within Buildings.Controls.OBC.FDE.PackagedRTUs;
block MinOAset "minimum outside air flow set point"
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{-20,-14},{0,6}})));
  input Buildings.Controls.OBC.CDL.Interfaces.BooleanInput Occ
    "true when RTU mode is occupied"
    annotation (Placement(transformation(extent={{-140,-24},{-100,16}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0)
    "set outside air flow set point to zero when not occupied mode"
    annotation (Placement(transformation(extent={{-86,12},{-66,32}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yminOAflowStpt(unit=
        "m3/s", quantity="VolumeFlowRate")
    "active outside air flow set point sent to factory controller"
    annotation (Placement(transformation(extent={{20,-24},{60,16}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minOAsetpoint(k=
        minOAset)
    annotation (Placement(transformation(extent={{-86,-50},{-66,-30}})));
  parameter Real minOAset(
  final unit="m3/s",
  final quantity="VolumeFlowRate")=0.8
  "minimum outside air flow set point";
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-64,-14},{-44,6}})));
equation
  connect(swi.u1, con.y) annotation (Line(points={{-22,4},{-38,4},{-38,22},{-64,
          22}},      color={0,0,127}));
  connect(swi.y, yminOAflowStpt)
    annotation (Line(points={{2,-4},{40,-4}}, color={0,0,127}));
  connect(minOAsetpoint.y, swi.u3) annotation (Line(points={{-64,-40},{-38,-40},
          {-38,-12},{-22,-12}},
                              color={0,0,127}));
  connect(swi.u2, not1.y)
    annotation (Line(points={{-22,-4},{-42,-4}}, color={255,0,255}));
  connect(not1.u, Occ)
    annotation (Line(points={{-66,-4},{-120,-4}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-60},{20,
            40}}), graphics={Rectangle(extent={{-100,40},{20,-60}},
            lineColor={179,151,128},
          radius=20),                Text(
          extent={{-60,-38},{-16,-66}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={179,151,128},
          fillPattern=FillPattern.Solid,
          textString="MinOAset"),
        Line(points={{-76,-12},{-60,-12},{-4,-12}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-76,-44},{-60,-44},{-4,-44}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-76,-12},{-74,-14},{-62,-28}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-76,-44},{-62,-28}}, color={179,151,128},
          thickness=0.5),
        Ellipse(extent={{-18,-26},{-14,-30}}, lineColor={179,151,128},
          lineThickness=0.5,
          fillColor={179,151,128},
          fillPattern=FillPattern.Solid),
        Line(points={{-14,-26},{-6,-16}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-26,-40},{-18,-30}}, color={179,151,128},
          thickness=0.5),
        Rectangle(extent={{-50,-14},{-46,-42}}, lineColor={179,151,128},
          lineThickness=0.5,
          fillColor={179,151,128},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-79.5,27.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-73.5,27.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-67.5,27.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-61.5,27.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-55.5,27.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-49.5,27.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-43.5,27.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-37.5,27.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-31.5,27.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-25.5,27.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-19.5,27.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-13.5,27.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-7.5,27.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-1.5,27.5},
          rotation=90),
        Rectangle(
          extent={{-1,42},{1,-42}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.HorizontalCylinder,
          origin={-40,35},
          rotation=90),
        Rectangle(
          extent={{-11,1},{11,-1}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-29,7},
          rotation=90),
        Line(points={{-30,18},{-34,8},{-30,8}}, color={179,151,128},
          thickness=0.5),
        Text(
          extent={{-100,4},{-78,-6}},
          lineColor={217,67,180},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={179,151,128},
          textString="Occ"),
        Text(
          extent={{-14,10},{18,-8}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={179,151,128},
          textString="yminOAflowStpt")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-60},
            {20,40}}), graphics={Rectangle(
          extent={{-100,40},{20,-60}},
          lineColor={179,151,128},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{-30,-26},{10,-54}},
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
point.",
          horizontalAlignment=TextAlignment.Left)}),
    Documentation(revisions="<html>
<ul>
<li>May 28, 2020, by Henry Nickels:<br>First implementation. </li>
</ul>
</html>",
      info="<html>
<p>If operating mode is occupied (<code>Occ</code>) select minimum outside air flow set point (<code>minOAflowStpt</code>), otherwise select zero flow set point. Decision made by the BAS and transmitted to the factory controller (<code>yminOAflowStpt</code>). </p>
</html>"));
end MinOAset;
