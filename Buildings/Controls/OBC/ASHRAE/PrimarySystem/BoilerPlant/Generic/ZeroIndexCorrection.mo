within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic;
block ZeroIndexCorrection
  "Block to pass the correct capacity details when index signal is zero, while avoiding assert errors"

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uInd
    "Index signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCap(
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Capacity signal"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIndMod
    "Modified index value to avoid assert errors"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCapMod(
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Modified capacity value"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if the index signal is zero"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntZer(
    final k=0)
    "Constant zero integer signal"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=0,
    final realFalse=1)
    "Pass a zero multiplication signal to the capacity modfier"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt
    "Add one to the index value when it is zero"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Pass an integer one signal to the index modifier"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Multiply the capacity value by zero when the index signal is zero"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

equation
  connect(uInd, intEqu.u1)
    annotation (Line(points={{-120,40},{-42,40}}, color={255,127,0}));
  connect(conIntZer.y, intEqu.u2) annotation (Line(points={{-58,10},{-50,10},{-50,
          32},{-42,32}}, color={255,127,0}));
  connect(intEqu.y, booToRea.u) annotation (Line(points={{-18,40},{-10,40},{-10,
          20},{-2,20}}, color={255,0,255}));
  connect(uInd, addInt.u1) annotation (Line(points={{-120,40},{-80,40},{-80,86},
          {38,86}}, color={255,127,0}));
  connect(intEqu.y, booToInt1.u) annotation (Line(points={{-18,40},{-10,40},{-10,
          60},{-2,60}}, color={255,0,255}));
  connect(booToInt1.y, addInt.u2) annotation (Line(points={{22,60},{30,60},{30,74},
          {38,74}}, color={255,127,0}));
  connect(addInt.y, yIndMod) annotation (Line(points={{62,80},{80,80},{80,40},{120,
          40}}, color={255,127,0}));
  connect(mul.y, yCapMod)
    annotation (Line(points={{62,-40},{120,-40}}, color={0,0,127}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{22,20},{30,20},{30,-34},
          {38,-34}}, color={0,0,127}));
  connect(uCap, mul.u2) annotation (Line(points={{-120,-40},{30,-40},{30,-46},{38,
          -46}}, color={0,0,127}));
  annotation (defaultComponentName="zerStaIndCor",
    Icon(coordinateSystem(preserveAspectRatio=false),
      graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-110,140},{110,100}},
          textColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
      <p>
      This block has been iomplemented to overcome the zero-index errors being 
      reported in the block 
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Capacities\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Capacities</a>.
      The current staging setpoint logic uses an index value of 0 to represent the 
      block being turned off. This is resulting in errors reported in the instances
      of the
      <a href=\"modelica://Buildings.Controls.OBC.CDL.Routing.RealExtractor\">
      RealExtractor</a> block.
      </p>
      <p>
      To overcome, this the block accepts input signals <code>uInd</code> for the
      current index value, and <code>uCap</code> for the current capacity signal. 
      It outputs a modified index signal <code>yIndMod</code> and a modified 
      capacity signal <code>yCapMod</code>.
      <ul>
      <li>
      <code>yIndMod</code> is set to 1 and <code>yCapMod</code> is set to zero 
      when <code>uInd</code> is zero.
      </li>
      <li>
      <code>yIndMod</code> is set to <code>uInd</code> and <code>yCapMod</code> is
      set to <code>uCap</code> when <code>uInd</code> is not zero.
      </li>
      </ul>
      </p>
      <p>
      For an example of usage, check the
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Capacities\">
      Capacities</a> block.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      April 3, 2023, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"),
    experiment(Tolerance=1e-6));
end ZeroIndexCorrection;
