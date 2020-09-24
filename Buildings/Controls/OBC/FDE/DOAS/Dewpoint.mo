within Buildings.Controls.OBC.FDE.DOAS;
block Dewpoint
  "Calculates dewpoint temperature from Tdb and relative humidity."

    // ---inputs---
  Buildings.Controls.OBC.CDL.Interfaces.RealInput relHum(
    final min=0,
    final max=100)
    "Relative humidity sensor"
      annotation (Placement(transformation(extent={{-142,52},{-102,92}}),
        iconTransformation(extent={{-142,40},{-102,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dbT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")
    "Dry bulb temperature sensor."
      annotation (Placement(transformation(extent={{-142,12},{-102,52}}),
        iconTransformation(extent={{-142,-80},{-102,-40}})));

    // ---outputs---
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")
    "Dewpoint temperature"
      annotation (Placement(transformation(extent={{102,-96},{142,-56}}),
        iconTransformation(extent={{102,-20},{142,20}})));


  Buildings.Controls.OBC.CDL.Continuous.Log log
    "Calculate natural log of input value."
    annotation (Placement(transformation(extent={{-32,56},{-12,76}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div
  "Divide relHum by 100."
    annotation (Placement(transformation(extent={{-62,56},{-42,76}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con100(
    final k=100)
    "Real constant 100"
      annotation (Placement(transformation(extent={{-92,46},{-72,66}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    "Calculate the product of dry bulb temperature (degC) and 17.27"
    annotation (Placement(transformation(extent={{-30,16},{-10,36}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1727(
    final k=17.27)
    "Real constant 17.27"
      annotation (Placement(transformation(extent={{-62,-10},{-42,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Add dry bulb temperature (degC) and 237.3"
    annotation (Placement(transformation(extent={{-30,-34},{-10,-14}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2373(
    final k=237.3)
    "Real constant 237.3"
      annotation (Placement(transformation(extent={{-62,-52},{-42,-32}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div1
    "Output first input divided by second input."
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    "Add two values."
    annotation (Placement(transformation(extent={{30,16},{50,36}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div2
    "Output first input divided by second input"
    annotation (Placement(transformation(extent={{62,10},{82,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro1
    "Output product of two inputs"
    annotation (Placement(transformation(extent={{4,-46},{24,-26}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div3
    "Output first input divided by second input"
    annotation (Placement(transformation(extent={{60,-52},{80,-32}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3
    "Output the sum of two inputs"
    annotation (Placement(transformation(extent={{32,-80},{52,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=1)
    "Real constant 1"
      annotation (Placement(transformation(extent={{4,-72},{24,-52}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4(
    final k2=-1)
    "Subtract 273.15 from dry bulb temperature."
    annotation (Placement(transformation(extent={{-92,16},{-72,36}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con27315(
    final k=273.15)
    "Real constant 273.15"
    annotation (Placement(transformation(extent={{-92,-14},{-72,6}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add5
    "Add 273.15 to the final value to output dew point temperature in K"
    annotation (Placement(transformation(extent={{70,-86},{90,-66}})));
equation
  connect(div.u1, relHum)
    annotation (Line(points={{-64,72},{-122,72}}, color={0,0,127}));
  connect(div.u2, con100.y)
    annotation (Line(points={{-64,60},{-68,60},{-68,56},{-70,56}},
      color={0,0,127}));
  connect(div.y, log.u)
    annotation (Line(points={{-40,66},{-34,66}}, color={0,0,127}));
  connect(con1727.y, pro.u2)
    annotation (Line(points={{-40,0},{-36,0},{-36,20},{-32,20}},
      color={0,0,127}));
  connect(con2373.y, add2.u2)
    annotation (Line(points={{-40,-42},{-36,-42},{-36,-30},{-32,-30}},
      color={0,0,127}));
  connect(pro.y, div1.u1)
    annotation (Line(points={{-8,26},{-2,26}},  color={0,0,127}));
  connect(add2.y, div1.u2)
    annotation (Line(points={{-8,-24},{-6,-24},{-6,14},{-2,14}},
      color={0,0,127}));
  connect(div1.y, add1.u2)
    annotation (Line(points={{22,20},{28,20}}, color={0,0,127}));
  connect(log.y, add1.u1)
    annotation (Line(points={{-10,66},{24,66},{24,32},{28,32}},
      color={0,0,127}));
  connect(add1.y, div2.u1)
    annotation (Line(points={{52,26},{60,26}}, color={0,0,127}));
  connect(con1727.y, div2.u2)
    annotation (Line(points={{-40,0},{54,0},{54,14},{60,14}},
      color={0,0,127}));
  connect(div2.y, pro1.u1)
    annotation (Line(points={{84,20},{82,20},{82,-6},{-2,-6},{-2,-30},{2,-30}},
      color={0,0,127}));
  connect(con2373.y, pro1.u2)
    annotation (Line(points={{-40,-42},{2,-42}},  color={0,0,127}));
  connect(pro1.y, div3.u1)
    annotation (Line(points={{26,-36},{58,-36}}, color={0,0,127}));
  connect(div2.y, add3.u2)
    annotation (Line(points={{84,20},{82,20},{82,-6},{-2,-6},{-2,-76},{30,-76}},
        color={0,0,127}));
  connect(add3.u1, con1.y)
    annotation (Line(points={{30,-64},{28,-64},{28,-62},{26,-62}},
      color={0,0,127}));
  connect(add3.y, div3.u2)
    annotation (Line(points={{54,-70},{56,-70},{56,-48},{58,-48}},
      color={0,0,127}));
  connect(con27315.y, add4.u2)
    annotation (Line(points={{-70,-4},{-70,14},{-98,14},{-98,20},{-94,20}},
      color={0,0,127}));
  connect(dbT, add4.u1)
    annotation (Line(points={{-122,32},{-94,32}}, color={0,0,127}));
  connect(add4.y, pro.u1)
    annotation (Line(points={{-70,26},{-52,26},{-52,32},{-32,32}},
      color={0,0,127}));
  connect(add4.y, add2.u1)
    annotation (Line(points={{-70,26},{-64,26},{-64,-18},{-32,-18}},
      color={0,0,127}));
  connect(add5.y, dpT)
    annotation (Line(points={{92,-76},{122,-76}}, color={0,0,127}));
  connect(div3.y, add5.u1)
    annotation (Line(points={{82,-42},{86,-42},{86,-60},{64,-60},{64,-70},{68,-70}},
      color={0,0,127}));
  connect(con27315.y, add5.u2)
    annotation (Line(points={{-70,-4},{-70,-68},{-22,-68},{-22,-82},{68,-82}},
      color={0,0,127}));
  annotation (defaultComponentName="Dewpt",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
           Text(
            extent={{-90,180},{90,76}},
            lineColor={28,108,200},
            textStyle={TextStyle.Bold},
            textString="%name"),
            Rectangle(extent={{-100,100},{100,-100}},
            lineColor={179,151,128},
            radius=10,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
        Text(
          extent={{-60,66},{28,-30}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Text(
          extent={{-28,0},{62,-60}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          textString="dp"),
        Text(
          extent={{-96,74},{-58,46}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          textString="relHum"),
        Text(
          extent={{-96,-50},{-66,-70}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          textString="dbT"),
        Text(
          extent={{64,12},{98,-12}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          textString="%dpT")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
September 16, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>", info="<html>
<h4>Dewpoint Temperature Calculation</h4>
<p>This block calculates dewpoint 
(<code>dpT</code>) using a reduced formula that only
requires dry bulb temperature 
(<code>dbT</code>) and relative humidity 
(<code>relHum</code>) inputs.
</p> 
</html>"));
end Dewpoint;
