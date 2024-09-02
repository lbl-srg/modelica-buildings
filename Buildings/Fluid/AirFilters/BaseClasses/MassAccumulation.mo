within Buildings.Fluid.AirFilters.BaseClasses;
model MassAccumulation
  "Component that mimics the accumulation of the contaminants"
  parameter Integer nin(
    min=1)=1
    "Number of input connections";
  parameter Buildings.Fluid.AirFilters.BaseClasses.Data.Generic per
    "Record with performance dat"
    annotation (Placement(transformation(extent={{20,62},{40,82}})));
  parameter Real mCon_reset(
    final min = 0)
    "Initial contaminant mass of the filter after replacement";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mCon_flow[nin](
    each final unit="kg/s")
    "Contaminant mass flow rate"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRep
    "Replacing the filter when trigger becomes true"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mCon(
    final unit = "kg")
    "Mass of the contaminant captured by the filter"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes
    "Calculate the mass of contaminant"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=mCon_reset)
    "Constant"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica.Blocks.Logical.Greater greater
    "Check if the filter is full"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
     final k=per.mCon_nominal)
    "Constant"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    message="In " + getInstanceName() + ": The filter needs to be replaced.")
    "Warning message when the filter is full"
    annotation (Placement(transformation(extent={{72,40},{92,60}})));

  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(nin=nin) "Summation of the inputs"
    annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
equation
  connect(intWitRes.y, mCon)
    annotation (Line(points={{12,0},{120,0}}, color={0,0,127}));
  connect(con.y, intWitRes.y_reset_in)
    annotation (Line(points={{-58,-20},{-20,-20}, {-20,-8},{-12,-8}}, color={0,0,127}));
  connect(intWitRes.trigger, uRep)
    annotation (Line(points={{0,-12},{0,-60},{-120,-60}}, color={255,0,255}));
  connect(assMes.u, greater.y)
    annotation (Line(points={{70,50},{61,50}}, color={255,0,255}));
  connect(greater.u2, intWitRes.y)
    annotation (Line(points={{38,42},{20,42},{20,0},{12,0}}, color={0,0,127}));
  connect(con1.y, greater.u1)
    annotation (Line(points={{2,50},{38,50}}, color={0,0,127}));

  connect(mulSum.y, intWitRes.u)
    annotation (Line(points={{-30,0},{-12,0}}, color={0,0,127}));
  connect(mulSum.u, mCon_flow)
    annotation (Line(points={{-54,0},{-120,0}}, color={0,0,127}));
annotation (defaultComponentName="masAcc",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
     Rectangle(extent={{-100,100},{100,-100}}, lineColor={28,108,200},
               fillColor={255,255,255}, fillPattern=FillPattern.Solid),
     Text(extent={{-100,140},{100,100}}, textColor={0,0,255}, textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This model mimics the process for a filter to capture the contaminants.
The mass of the contaminants, <code>mCon</code>, increases by time.
However, when the input signal <code>uRep</code> changes from <code>false</code>
to <code>true</code>, <code>mCon</code> is reinitialized to a constant, <code>mCon_reset</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end MassAccumulation;
