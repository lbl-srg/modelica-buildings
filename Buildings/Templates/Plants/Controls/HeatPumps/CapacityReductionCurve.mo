within Buildings.Templates.Plants.Controls.HeatPumps;
block CapacityReductionCurve
  "Calculate heat pump capacity reduction with deviation from nominal ratings"
  parameter Real coeffCapRedFac[6]={0.465,3.91e-3,7.6e-5,4.94e-4,-8.24e-6,-2.4e-6}
    "Coefficients used to calculate the capacity reduction factor (Current default
    values are from ASHRAE G36.)";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "HW supply temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Calculate curve value at input temperatures"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mulTOut
    "Compute square of outdoor air temperature"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mulTHeaWatSup
    "Compute square of HW supply water temperature"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSumCapRedFac(
    final k=coeffCapRedFac,
    final nin=6)
    "Calculate value of polynomial curve"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=1)
    "Constant Real signal source"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mulTOutSup
    "Compute multiple of outdoor air temperature and supply water temperature"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.UnitConversions.To_degF to_degF
    "Convert outdoor air temperature to Fahrenheit"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.UnitConversions.To_degF to_degF1
    "Convert HW supply temperature to Fahrenheit"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
equation
  connect(mulSumCapRedFac.y, y)
    annotation (Line(points={{62,0},{120,0}}, color={0,0,127}));
  connect(TOut, to_degF.u)
    annotation (Line(points={{-120,60},{-82,60}}, color={0,0,127}));
  connect(THeaWatSup, to_degF1.u)
    annotation (Line(points={{-120,-60},{-82,-60}}, color={0,0,127}));
  connect(con.y, mulSumCapRedFac.u[1]) annotation (Line(points={{-18,80},{28,80},
          {28,-0.833333},{38,-0.833333}}, color={0,0,127}));
  connect(to_degF.y, mulSumCapRedFac.u[2]) annotation (Line(points={{-58,60},{
          28,60},{28,-0.5},{38,-0.5}}, color={0,0,127}));
  connect(to_degF.y, mulTOut.u1) annotation (Line(points={{-58,60},{-50,60},{
          -50,36},{-42,36}}, color={0,0,127}));
  connect(to_degF.y, mulTOut.u2) annotation (Line(points={{-58,60},{-50,60},{
          -50,24},{-42,24}}, color={0,0,127}));
  connect(mulTOut.y, mulSumCapRedFac.u[3]) annotation (Line(points={{-18,30},{
          28,30},{28,-0.166667},{38,-0.166667}}, color={0,0,127}));
  connect(to_degF1.y, mulSumCapRedFac.u[4]) annotation (Line(points={{-58,-60},
          {-50,-60},{-50,4},{28,4},{28,0.166667},{38,0.166667}}, color={0,0,127}));
  connect(to_degF1.y, mulTHeaWatSup.u1) annotation (Line(points={{-58,-60},{-50,
          -60},{-50,-64},{-42,-64}}, color={0,0,127}));
  connect(to_degF1.y, mulTHeaWatSup.u2) annotation (Line(points={{-58,-60},{-50,
          -60},{-50,-76},{-42,-76}}, color={0,0,127}));
  connect(mulTHeaWatSup.y, mulSumCapRedFac.u[5]) annotation (Line(points={{-18,
          -70},{34,-70},{34,0.5},{38,0.5}}, color={0,0,127}));
  connect(to_degF.y, mulTOutSup.u1) annotation (Line(points={{-58,60},{-50,60},
          {-50,6},{-2,6},{-2,-4}}, color={0,0,127}));
  connect(to_degF1.y, mulTOutSup.u2) annotation (Line(points={{-58,-60},{-50,
          -60},{-50,-22},{-2,-22},{-2,-16}}, color={0,0,127}));
  connect(mulTOutSup.y, mulSumCapRedFac.u[6]) annotation (Line(points={{22,-10},
          {30,-10},{30,0.833333},{38,0.833333}}, color={0,0,127}));
  annotation (defaultComponentName="curCapRed",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        Documentation(
      info="<html>
<p>
This block computes the heat pump capacity modification factor <code>y</code> at
a given outdoor air temperature <code>TOut</code> and hot water supply temperature
<code>THeaWatSup</code>.
</p>
<p>
The curve coefficients have been calculated for temperatures measured in Fahrenheit
and have been directly adapted from Addendum L of ASHRAE Guideline 36.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 31, 2026, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end CapacityReductionCurve;
