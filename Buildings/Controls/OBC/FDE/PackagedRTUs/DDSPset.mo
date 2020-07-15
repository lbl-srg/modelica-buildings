within Buildings.Controls.OBC.FDE.PackagedRTUs;
block DDSPset
  "Down duct static pressure set point calculation based on terminal unit damper position"
 parameter Real minDDSPset(
   min=0,
   final unit="Pa",
   final quantity="PressureDifference")=1.25e-3
  "Minimum down duct static pressure reset value"
  annotation (Dialog(group="DDSP range"));

 parameter Real maxDDSPset(
   min=0,
   final unit="Pa",
   final quantity="PressureDifference")=5e-3
  "Maximum down duct static pressure reset value"
  annotation (Dialog(group="DDSP range"));

 parameter Real DamSet(
   min=0,
   max=1,
   final unit="1")=0.9
   "DDSP terminal damper percent open set point";

  // --- input---
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mostOpenDam
    "Most open damper position of all terminal units"
    annotation (Placement(transformation(extent={{-138,-16},{-98,24}})));

  // ---output---
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDDSPset(
    final unit="Pa",
    final displayUnit="bar",
    final quantity="Pressure")
    "Calculated down duct static pressure set point"
    annotation (Placement(transformation(extent={{40,4},{80,44}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.0000001,
    Ti=0.0025,
    yMax=1,
    yMin=0,
    reverseAction=true,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Disabled)
    "calculate reset value based on most open terminal unit damper position "
    annotation (Placement(transformation(extent={{-50,14},{-30,34}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    annotation (Placement(transformation(extent={{-4,14},{16,34}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X1(k=0)
    "linear conversion constant (min)"
    annotation (Placement(transformation(extent={{-50,72},{-30,92}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X2(k=1)
    "linear conversion constant (max)"
    annotation (Placement(transformation(extent={{-50,-28},{-30,-8}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant DamSetpt(
    k=DamSet)
    "The terminal unit damper percent open set point"
    annotation (Placement(transformation(extent={{-88,14},{-68,34}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxDDSPsetpt(
    k=maxDDSPset)
    "maximum allowable set point reset value"
    annotation (Placement(transformation(extent={{-86,-50},{-66,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minDDSPsetpt(k=
        minDDSPset) "minimum reset value"
    annotation (Placement(transformation(extent={{-88,46},{-68,66}})));

equation
  connect(conPID.u_m, mostOpenDam)
    annotation (Line(points={{-40,12},{-40,4},{-118,4}}, color={0,0,127}));
  connect(conPID.y, lin.u)
    annotation (Line(points={{-28,24},{-6,24}}, color={0,0,127}));
  connect(X1.y, lin.x1) annotation (Line(points={{-28,82},{-12,82},{-12,32},
          {-6,32}}, color={0,0,127}));
  connect(X2.y, lin.x2) annotation (Line(points={{-28,-18},{-20,-18},{-20,
          20},{-6,20}}, color={0,0,127}));
  connect(lin.y, yDDSPset)
    annotation (Line(points={{18,24},{60,24}}, color={0,0,127}));
  connect(conPID.u_s, DamSetpt.y)
    annotation (Line(points={{-52,24},{-66,24}}, color={0,0,127}));
  connect(lin.f2, maxDDSPsetpt.y) annotation (Line(points={{-6,16},{-12,16},
          {-12,-40},{-64,-40}}, color={0,0,127}));
  connect(minDDSPsetpt.y, lin.f1) annotation (Line(points={{-66,56},{-20,56},
          {-20,28},{-6,28}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-60},{40,
            100}}), graphics={
        Rectangle(extent={{-94,98},{32,-58}}, lineColor={179,151,128},
          radius=20),                                                  Text(
          extent={{-48,-30},{-2,-58}},
          lineColor={28,108,200},
          fillColor={179,151,128},
          fillPattern=FillPattern.Solid,
          textString="DDSPset"),
        Line(points={{-36,20},{-26,10}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-36,4},{-26,-6}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-26,10},{-36,4}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-26,-6},{-36,-12}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-36,20},{-20,20},{6,20}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-36,-12},{-20,-12},{6,-12}}, color={179,151,128},
          thickness=0.5),
        Line(points={{6,20},{8,18},{20,4}}, color={179,151,128},
          thickness=0.5),
        Line(points={{6,-12},{20,4}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-46,20},{-36,10}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-46,4},{-36,-6}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-36,10},{-46,4}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-36,-6},{-46,-12}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-46,20},{-74,20},{-80,20}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-46,-12},{-74,-12},{-80,-12}}, color={179,151,128},
          thickness=0.5),
        Rectangle(extent={{-24,30},{-2,22}}, lineColor={179,151,128},
          lineThickness=0.5,
          fillColor={179,151,128},
          fillPattern=FillPattern.Solid),
        Line(points={{-18,22},{-18,12}}, color={179,151,128},
          thickness=0.5),
        Line(points={{-2,28},{4,28}}, color={179,151,128},
          thickness=0.5),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-69.5,79.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-63.5,79.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-57.5,79.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-51.5,79.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-45.5,79.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-39.5,79.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-33.5,79.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-27.5,79.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-21.5,79.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-15.5,79.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-9.5,79.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-3.5,79.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={2.5,79.5},
          rotation=90),
        Rectangle(
          extent={{-7.5,0.5},{7.5,-0.5}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={8.5,79.5},
          rotation=90),
        Rectangle(
          extent={{-1,42},{1,-42}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.HorizontalCylinder,
          origin={-30,87},
          rotation=90),
        Rectangle(
          extent={{-18,1},{18,-1}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-47,50},
          rotation=90),
        Line(points={{22,-8},{1.95996e-38,-3.20085e-22},{4,-8}},
                                                  color={179,151,128},
          origin={-56,46},
          rotation=90,
          thickness=0.5),
        Text(
          extent={{10,32},{38,18}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={179,151,128},
          textString="yDDSPstpt"),
        Text(
          extent={{-90,10},{-52,-2}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={179,151,128},
          textString="mostOpenDam")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-60},
            {40,100}}), graphics={Rectangle(
          extent={{-100,100},{40,-60}},
          lineColor={179,151,128},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{-6,2},{34,-26}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="The down duct static pressure
set point is reset between
minimum and maximum allowable
values to keep the most open
terminal unit damper at
90 percent open.")}),
    Documentation(info="<html>
<p>Calculation of the down duct static pressure set point performed by the BAS and transmitted to the factory controller. </p>
<h4>Down Duct Static Pressure Set Point Reset</h4>
<p>This algorithm is intended to reset the down duct static pressure set point (<code>yDDSPstpt</code>) to maintain the most open terminal unit damper position (<code>mostOpenDam</code>) at 90&percnt; open (i.e. The terminal unit air flow set point is satisfied with its primary air damper 90&percnt; open). The down duct static pressure set point is reset between minimum (<code>minDDSPset</code>) and maximum (<code>maxDDSPset</code>) values determined by TAB. </p>
</html>", revisions="<html>
<ul>
<li>May 29, 2020, by Henry Nickels:<br>Internalize min and max setpoints as parameters.</li>
<li>May 27, 2020, by Henry Nickels:<br>First implementation.</li>
</ul>
</html>"));
end DDSPset;
