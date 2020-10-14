within Buildings.Controls.OBC.FDE.DOAS;
block erwTsim "ERW supply temperature simulator"

    parameter Real erwEff(
    final min=0,
    final max=1)=0.8
   "ERW efficiency parameter.";

       // ---inputs---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput bypDam
    "True when ERW bypass dampers are commanded open."
      annotation (Placement(transformation(extent={{-142,28},{-102,68}}),
        iconTransformation(extent={{-144,40},{-104,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput raT
    "Return air temperature sensor value."
      annotation (Placement(transformation(extent={{-142,-46},{-102,-6}}),
        iconTransformation(extent={{-144,-40},{-104,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput oaT
    "Outside air temperature value."
      annotation (Placement(transformation(extent={{-142,-78},{-102,-38}}),
        iconTransformation(extent={{-144,-80},{-104,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput erwStart
    "True when erwStart is on."
      annotation (Placement(transformation(extent={{-142,62},{-102,102}}),
        iconTransformation(extent={{-144,0},{-104,40}})));

       // ---outputs---
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput erwTsim
    "Simulated erw temperature value"
      annotation (Placement(transformation(extent={{108,46},{148,86}}),
        iconTransformation(extent={{104,-20},{144,20}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "False when erwStart is true."
      annotation (Placement(transformation(extent={{-78,72},{-58,92}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "If ERW has not started, bypass dampers are open, or RAT=OAT 
      then pass OAT as the erwT value."
      annotation (Placement(transformation(extent={{14,56},{34,76}})));
  Buildings.Controls.OBC.CDL.Continuous.Add sub1(
    final k2=-1)
    "Subtract outside air temperature from return air temperature."
      annotation (Placement(transformation(extent={{-88,-42},{-68,-22}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Absolute value of RAT-OAT"
      annotation (Placement(transformation(extent={{-50,-42},{-30,-22}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    "RAT/OAT delta x erwEff"
      annotation (Placement(transformation(extent={{-18,-48},{2,-28}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=erwEff)
      "ERW decimal efficiency"
        annotation (Placement(transformation(extent={{-50,-68},{-30,-48}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    annotation (Placement(transformation(extent={{-18,40},{2,60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant con0(
    final k=0)
      "Integer constant 0"
        annotation (Placement(transformation(extent={{-50,16},{-30,36}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final threshold=0)
      "True if RAT > OAT"
        annotation (Placement(transformation(extent={{-50,-14},{-30,6}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Logical switch selects OAT or calculated ERW value."
      annotation (Placement(transformation(extent={{76,56},{96,76}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{44,-86},{64,-66}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    "OAT+(|RAT-OAT|*erwEff)"
      annotation (Placement(transformation(extent={{10,-78},{30,-58}})));
  Buildings.Controls.OBC.CDL.Continuous.Add sub2(k2=-1)
    "OAT - (|RAT-OAT|*erwEff)"
      annotation (Placement(transformation(extent={{10,-104},{30,-84}})));

equation
  connect(not1.u, erwStart)
    annotation (Line(points={{-80,82},{-122,82}}, color={255,0,255}));
  connect(not1.y, or3.u1) annotation (Line(points={{-56,82},{-36,82},{-36,74},{12,
          74}}, color={255,0,255}));
  connect(or3.u2, bypDam) annotation (Line(points={{12,66},{-90,66},{-90,48},{-122,
          48}}, color={255,0,255}));
  connect(sub1.u1, raT)
    annotation (Line(points={{-90,-26},{-122,-26}}, color={0,0,127}));
  connect(sub1.u2, oaT) annotation (Line(points={{-90,-38},{-96,-38},{-96,-58},{
          -122,-58}}, color={0,0,127}));
  connect(sub1.y, abs.u)
    annotation (Line(points={{-66,-32},{-52,-32}}, color={0,0,127}));
  connect(abs.y, pro.u1)
    annotation (Line(points={{-28,-32},{-20,-32}}, color={0,0,127}));
  connect(con.y, pro.u2) annotation (Line(points={{-28,-58},{-24,-58},{-24,-44},
          {-20,-44}}, color={0,0,127}));
  connect(sub1.y, reaToInt.u) annotation (Line(points={{-66,-32},{-60,-32},{-60,
          50},{-52,50}}, color={0,0,127}));
  connect(reaToInt.y, intEqu.u1)
    annotation (Line(points={{-28,50},{-20,50}}, color={255,127,0}));
  connect(con0.y, intEqu.u2) annotation (Line(points={{-28,26},{-24,26},{-24,42},
          {-20,42}}, color={255,127,0}));
  connect(intEqu.y, or3.u3) annotation (Line(points={{4,50},{8,50},{8,58},{12,58}},
        color={255,0,255}));
  connect(sub1.y, greThr.u) annotation (Line(points={{-66,-32},{-60,-32},{-60,-4},
          {-52,-4}}, color={0,0,127}));
  connect(oaT, swi.u1) annotation (Line(points={{-122,-58},{-96,-58},{-96,98},{56,
          98},{56,74},{74,74}}, color={0,0,127}));
  connect(or3.y, swi.u2)
    annotation (Line(points={{36,66},{74,66}}, color={255,0,255}));
  connect(pro.y, add1.u1) annotation (Line(points={{4,-38},{6,-38},{6,-62},{8,-62}},
        color={0,0,127}));
  connect(pro.y, sub2.u2) annotation (Line(points={{4,-38},{6,-38},{6,-100},{8,-100}},
        color={0,0,127}));
  connect(oaT, add1.u2) annotation (Line(points={{-122,-58},{-58,-58},{-58,-74},
          {8,-74}}, color={0,0,127}));
  connect(oaT, sub2.u1) annotation (Line(points={{-122,-58},{-58,-58},{-58,-88},
          {8,-88}}, color={0,0,127}));
  connect(add1.y, swi1.u1)
    annotation (Line(points={{32,-68},{42,-68}}, color={0,0,127}));
  connect(sub2.y, swi1.u3) annotation (Line(points={{32,-94},{38,-94},{38,-84},{
          42,-84}}, color={0,0,127}));
  connect(greThr.y, swi1.u2) annotation (Line(points={{-28,-4},{34,-4},{34,-76},
          {42,-76}}, color={255,0,255}));
  connect(swi1.y, swi.u3) annotation (Line(points={{66,-76},{70,-76},{70,58},{74,
          58}}, color={0,0,127}));
  connect(swi.y, erwTsim)
    annotation (Line(points={{98,66},{128,66}}, color={0,0,127}));
  annotation (defaultComponentName="ERWtemp",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(extent={{-100,100},{100,-100}},
            lineColor={179,151,128},
            radius=10,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
           Text(
            extent={{-90,180},{90,76}},
            lineColor={28,108,200},
            textStyle={TextStyle.Bold},
            textString="%name"),
        Text(
          extent={{-50,0},{40,-60}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          textString="sim"),
        Text(
          extent={{-56,96},{52,-16}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          textString="erwT")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4>ERW Temperature Simulation</h4>
<p>This block simulates an energy recovery wheel leaving
supply air temperature using the model outside air temperature  
(<code>oaT</code>), model return air temperature 
(<code>raT</code>), bypass damper position 
(<code>bypDam</code>), and ERW start command 
(<code>erwStart</code>).
</p> 
</html>", revisions="<html>
<ul>
<li>
September 29, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>"));
end erwTsim;
