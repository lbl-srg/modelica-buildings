within Buildings.Templates.Plants.Controls.HeatPumps;
block CapacityReduction
  "Calculate drop in heat pump capacity when operating conditions deviate from nominal conditions"
  parameter Real coeffCapRedFac[6]={0.465,3.91e-3,7.6e-5,4.94e-4,-8.24e-6,-2.4e-6}
    "Coefficients used to calculate the capacity reduction factor (Current default
    values were determined from a typical AWHP with positive displacement compressors.)";
  parameter Real TOut_nominal(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Nominal outdoor air temperature for the heat pump ratings";
  parameter Real THeaWatSup_nominal(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Nominal HW supply temperature for the heat pump ratings";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSup(
    final unit="K",
    displayUnit="degC")
    "HW supply temperature"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Capacity modifier"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Templates.Plants.Controls.HeatPumps.CapacityReductionCurve curCapRed(
    final coeffCapRedFac=coeffCapRedFac)
    "Calculate curve value at current conditions"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Templates.Plants.Controls.HeatPumps.CapacityReductionCurve curCapRed_nominal(
    final coeffCapRedFac=coeffCapRedFac)
    "Calculate curve value at nominal conditions"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conTOut_nominal(k=
        TOut_nominal) "Nominal outdoor air temperature signal"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conTHeaWatSup_nominal(k=
        THeaWatSup_nominal) "Nominal HW supply temperature signal"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Divide divMod
    "Calculate modifier for heat pump capacity at measured conditions"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(TOut, curCapRed.TOut) annotation (Line(points={{-120,60},{-60,60},{-60,
          34},{-42,34}}, color={0,0,127}));
  connect(curCapRed.THeaWatSup, THeaWatSup) annotation (Line(points={{-42,26},{-94,
          26},{-94,20},{-120,20}}, color={0,0,127}));
  connect(conTOut_nominal.y, curCapRed_nominal.TOut) annotation (Line(points={{-58,
          -20},{-50,-20},{-50,-36},{-42,-36}}, color={0,0,127}));
  connect(conTHeaWatSup_nominal.y, curCapRed_nominal.THeaWatSup) annotation (
      Line(points={{-58,-60},{-50,-60},{-50,-44},{-42,-44}}, color={0,0,127}));
  connect(curCapRed.y, divMod.u1) annotation (Line(points={{-18,30},{20,30},{20,
          6},{38,6}}, color={0,0,127}));
  connect(curCapRed_nominal.y, divMod.u2) annotation (Line(points={{-18,-40},{
          20,-40},{20,-6},{38,-6}}, color={0,0,127}));
  connect(divMod.y, y)
    annotation (Line(points={{62,0},{120,0}}, color={0,0,127}));
  annotation (defaultComponentName="capRed",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}), Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)),
        Documentation(
      info="<html>
<p>
This block computes the heat pump capacity modifier <code>y</code> that is then
used to determine the heat pump capacity at the measured conditions for outdoor
air temperature <code>TOut</code> and hot water supply temperature <code>THeaWatSup</code>.
</p>
<p>
The modifier is calculated as the ratio of the modifier curve value at the current
measured conditions to the value at the rated conditions <code>TOut_nominal</code>
and <code>THeaWatSup_nominal</code>.
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
end CapacityReduction;
