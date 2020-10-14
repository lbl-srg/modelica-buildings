within Buildings.Controls.OBC.FDE.DOAS;
block ExhaustFanController
  "This block manages start, stop, and speed of the exhaust fan."

  parameter Real bldgSPset(
   final unit="Pa",
   final quantity="PressureDifference")=15
    "Building static pressure set point";

    // ---inputs---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput supFanProof
    "True when supply fan is proven on"
      annotation (Placement(transformation(extent={{-142,34},{-102,74}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput bldgSP
    "Building static pressure"
      annotation (Placement(transformation(extent={{-142,-28},{-102,12}}),
        iconTransformation(extent={{-140,-84},{-100,-44}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput exhFanProof
    "True when exhaust fan is proven on."
      annotation (Placement(transformation(extent={{-142,-62},{-102,-22}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

     // ---outputs---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput exhFanStart
    "Command exhaust fan to start when true."
       annotation (Placement(transformation(extent={{102,34},{142,74}}),
         iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput exhFanSpeed
    "Exhaust fan speed command"
      annotation (Placement(transformation(extent={{102,-16},{142,24}}),
        iconTransformation(extent={{100,-80},{140,-40}})));


  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant bldgStaticSP(
    final k=bldgSPset)
    "Building static pressure set point."
        annotation (Placement(transformation(extent={{-40,2},{-20,22}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    final k=0.0000001,
    final Ti=0.00075,
    reverseAction=true)
    "Fan speed PI calculation."
      annotation (Placement(transformation(extent={{-6,2},{14,22}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Logical switch is true when fan status is proven."
    annotation (Placement(transformation(extent={{38,-6},{58,14}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con0(
    final k=0)
    "Real constant 0."
      annotation (Placement(transformation(extent={{-4,-74},{16,-54}})));


equation
  connect(exhFanStart, supFanProof)
    annotation (Line(points={{122,54},{-122,54}},   color={255,0,255}));
  connect(conPID.u_m, bldgSP)
    annotation (Line(points={{4,0},{4,-8},{-122,-8}},  color={0,0,127}));
  connect(con0.y, swi.u3)
    annotation (Line(points={{18,-64},{28,-64},{28,-4},{36,-4}},
        color={0,0,127}));
  connect(conPID.y, swi.u1)
    annotation (Line(points={{16,12},{36,12}}, color={0,0,127}));
  connect(swi.y, exhFanSpeed)
    annotation (Line(points={{60,4},{122,4}},   color={0,0,127}));
  connect(conPID.u_s, bldgStaticSP.y)
    annotation (Line(points={{-8,12},{-18,12}}, color={0,0,127}));
  connect(swi.u2, exhFanProof)
    annotation (Line(points={{36,4},{20,4},{20,-42},{-122,-42}},
      color={255,0,255}));
  annotation (defaultComponentName="EFcon",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(extent={{-100,100},{100,-100}},
            lineColor={179,151,128},
            radius=10,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,40},{14,-14}},
          lineColor={162,29,33},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
           Text(
            extent={{-90,180},{90,76}},
            lineColor={28,108,200},
            textStyle={TextStyle.Bold},
            textString="%name"),
        Ellipse(
          extent={{-26,40},{56,-42}},
          lineColor={162,29,33},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{4,12},{28,-12}},
          lineColor={162,29,33},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-54,54},{-10,52},{-50,52}},
          color={0,127,0},
          pattern=LinePattern.None),
        Line(
          points={{-52,50},{-2,48},{30,54},{-26,68},{134,70},{148,22},{152,42}},
          color={0,127,0},
          pattern=LinePattern.None),
        Line(
          points={{-68,72},{6,72}},
          color={0,127,0},
          pattern=LinePattern.None),
        Line(
          points={{-52,70},{6,66},{-28,66}},
          color={0,127,0},
          pattern=LinePattern.None),
        Line(
          points={{42,60},{36,54},{28,70},{42,62}},
          color={0,127,0},
          pattern=LinePattern.None),
        Text(
          extent={{52,-50},{102,-66}},
          lineColor={28,108,200},
          textString="Speed"),
        Text(
          extent={{52,70},{102,54}},
          lineColor={28,108,200},
          textString="Start"),
        Text(
          extent={{-96,68},{-46,52}},
          lineColor={28,108,200},
          textString="SF Proof"),
        Text(
          extent={{-102,6},{-52,-10}},
          lineColor={28,108,200},
          textString="Status"),
        Text(
          extent={{-96,-56},{-46,-72}},
          lineColor={28,108,200},
          textString="Bldg SP")}),
                                 Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
September 14, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>", info="<html>
<h4>Exhuast Fan Start/Stop.</h4>
<p>This block commands the exhaust fan to start 
(<code>exhFanStart</code>) when the supply fan is proven
(<code>supFanProof</code>) on.</p>
<h4>Building Static Pressure Control</h4>
<p>The exhaust fan speed 
(<code> exhFanSpeed</code>) is modulated to  maintain
the building static pressure (<code>bldgSP</code>) at
set point (<code>bldgSPset</code>) when the exhaust
fan is proven on (<code>exhFanProof</code>).
</p>
</html>"));
end ExhaustFanController;
