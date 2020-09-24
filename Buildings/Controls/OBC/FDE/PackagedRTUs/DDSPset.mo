within Buildings.Controls.OBC.FDE.PackagedRTUs;
block DDSPset
  "Down duct static pressure set point calculation based on terminal unit damper position"

 parameter Real minDDSPset(
   min=0,
   final unit="Pa",
   final displayUnit="bar",
   final quantity="PressureDifference")=125
  "Minimum down duct static pressure reset value"
  annotation (Dialog(group="DDSP range"));

 parameter Real maxDDSPset(
   min=0,
   final unit="Pa",
   final displayUnit="bar",
   final quantity="PressureDifference")=500
  "Maximum down duct static pressure reset value"
  annotation (Dialog(group="DDSP range"));

 parameter Real DamSet(
   min=0,
   max=1,
   final unit="1")=0.9
   "DDSP terminal damper percent open set point";

  // --- input---
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mostOpenDam(
    min=0,
    max=1,
    final unit="1")
    "Most open damper position of all terminal units"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));

  // ---output---
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDDSPset(
    final unit="Pa",
    final displayUnit="bar",
    final quantity="Pressure")
    "Calculated down duct static pressure set point."
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.0000001,
    Ti=0.0025,
    yMax=1,
    yMin=0,
    reverseAction=true,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Disabled)
    "Calculate reset value based on most open terminal unit damper position."
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Linear reset of DDSP set point as PID output varies to meet most 
      open damper set point."
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X1(
    final k=0)
    "Linear conversion constant (min)."
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X2(
    final k=1)
    "Linear conversion constant (max)."
    annotation (Placement(transformation(extent={{-50,-54},{-30,-34}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant DamSetpt(
    final k=DamSet)
    "The terminal unit damper percent open set point."
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxDDSPsetpt(
    final k=maxDDSPset)
    "Maximum allowable set point reset value."
    annotation (Placement(transformation(extent={{-50,-92},{-30,-72}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minDDSPsetpt(
    final k=minDDSPset)
    "Minimum reset value."
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));

equation
  connect(conPID.u_m, mostOpenDam)
    annotation (Line(points={{-40,-12},{-40,-20},{-90.5469,-20},{-120,-20}},
                                                         color={0,0,127}));
  connect(conPID.y, lin.u)
    annotation (Line(points={{-28,0},{44,0}},   color={0,0,127}));
  connect(X1.y, lin.x1)
    annotation (Line(points={{-28,80},{-14,80},{-14,8},{44,8}},
                    color={0,0,127}));
  connect(X2.y, lin.x2)
    annotation (Line(points={{-28,-44},{-18,-44},{-18,-4},{
          44,-4}},      color={0,0,127}));
  connect(lin.y, yDDSPset)
    annotation (Line(points={{68,0},{120,0}},  color={0,0,127}));
  connect(conPID.u_s, DamSetpt.y)
    annotation (Line(points={{-52,0},{-66,0}},   color={0,0,127}));
  connect(lin.f2, maxDDSPsetpt.y)
    annotation (Line(points={{44,-8},{-14,-8},{
          -14,-82},{-28,-82}},  color={0,0,127}));
  connect(minDDSPsetpt.y, lin.f1)
    annotation (Line(points={{-28,40},{-20,40},{-20,
          4},{44,4}},        color={0,0,127}));
  annotation (defaultComponentName="DDSPset",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(extent={{-100,100},{100,-100}},
                                              lineColor={179,151,128},
          radius=20,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),                              Text(
          extent={{-20,126},{26,98}},
          lineColor={28,108,200},
          fillColor={179,151,128},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Line(points={{0,6},{10,-4}},     color={179,151,128},
          thickness=0.5),
        Line(points={{0,-10},{10,-20}}, color={179,151,128},
          thickness=0.5),
        Line(points={{10,-4},{0,-10}},  color={179,151,128},
          thickness=0.5),
        Line(points={{10,-20},{0,-26}},   color={179,151,128},
          thickness=0.5),
        Line(points={{0,6},{16,6},{42,6}},      color={179,151,128},
          thickness=0.5),
        Line(points={{0,-26},{16,-26},{42,-26}},   color={179,151,128},
          thickness=0.5),
        Line(points={{42,6},{44,4},{56,-10}},
                                            color={179,151,128},
          thickness=0.5),
        Line(points={{42,-26},{56,-10}},
                                      color={179,151,128},
          thickness=0.5),
        Line(points={{-10,6},{0,-4}},    color={179,151,128},
          thickness=0.5),
        Line(points={{-10,-10},{0,-20}},color={179,151,128},
          thickness=0.5),
        Line(points={{0,-4},{-10,-10}}, color={179,151,128},
          thickness=0.5),
        Line(points={{0,-20},{-10,-26}},  color={179,151,128},
          thickness=0.5),
        Line(points={{-10,6},{-38,6},{-44,6}},    color={179,151,128},
          thickness=0.5),
        Line(points={{-10,-26},{-38,-26},{-44,-26}}, color={179,151,128},
          thickness=0.5),
        Rectangle(extent={{12,16},{34,8}},   lineColor={179,151,128},
          lineThickness=0.5,
          fillColor={179,151,128},
          fillPattern=FillPattern.Solid),
        Line(points={{18,8},{18,-2}},    color={179,151,128},
          thickness=0.5),
        Line(points={{34,14},{40,14}},color={179,151,128},
          thickness=0.5),
        Text(
          extent={{68,8},{96,-6}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={179,151,128},
          textString="yDDSPstpt"),
        Text(
          extent={{-96,-14},{-58,-26}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={179,151,128},
          textString="mostOpenDam")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={179,151,128},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{42,-18},{78,-46}},
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
<p>Calculation of the down duct static pressure set point performed 
by the BAS and transmitted to the factory controller. </p>
<h4>Down Duct Static Pressure Set Point Reset</h4>
<p>This algorithm is intended to reset the down duct static pressure set point 
(<code>yDDSPstpt</code>) to maintain the most open
 terminal unit damper position 
(<code>mostOpenDam</code>) at 90% open (i.e. The terminal unit air flow set point is satisfied
 with its primary air damper 90% open). The down duct static pressure
 set point is reset between minimum 
(<code>minDDSPset</code>) and maximum 
(<code>maxDDSPset</code>) values determined by TAB. </p>
</html>", revisions="<html>
<ul>
<li>May 29, 2020, by Henry Nickels:<br>Internalize min and max setpoints as parameters.</li>
<li>May 27, 2020, by Henry Nickels:<br>First implementation.</li>
</ul>
</html>"));
end DDSPset;
