within Buildings.Fluid.AirFilters.BaseClasses;
model MassAccumulation
  "Mass of the contaminants capatured by the filter"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nConSub(
    final min=1)=1
    "Total number of contaminant substance types";
  parameter Modelica.Units.SI.Mass mCon_max
    "Maximum mass of the contaminant that can be captured by the filter";
  parameter Modelica.Units.SI.Mass mCon_start(final min=0)
    "Initial contaminant mass of the filter after replacement";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mCon_flow[nConSub](
    each final unit="kg/s")
    "Contaminant mass flow rate"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRep
    "Switch to true to replace the filter and reset the accumulation"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yRep
    "True if the filter is full and should be replaced"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mCon(
    final unit = "kg")
    "Mass of the contaminant captured by the filter"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes(
    final k=1,
    final y_start=mCon_start)
    "Calculate the mass of contaminant"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=mCon_start)
    "Constant"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Greater notFul(final h=0.05*mCon_max)
    "Check if the filter is full"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(final k=mCon_max)
    "Constant"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="In " + getInstanceName() + ": The filter needs to be replaced.")
    "Warning message when the filter is full"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(
    final nin=nConSub) "Summation of the inputs"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not ful "Check if the filter is full"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Edge for triggering filter reset"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
equation
  connect(intWitRes.y, mCon)
    annotation (Line(points={{2,0},{120,0}},  color={0,0,127}));
  connect(con.y, intWitRes.y_reset_in)
    annotation (Line(points={{-58,-40},{-40,-40},{-40,-8},{-22,-8}}, color={0,0,127}));
  connect(assMes.u, notFul.y)
    annotation (Line(points={{58,50},{42,50}}, color={255,0,255}));
  connect(notFul.u2, intWitRes.y)
    annotation (Line(points={{18,42},{10,42},{10,0},{2,0}}, color={0,0,127}));
  connect(con1.y, notFul.u1)
    annotation (Line(points={{-18,50},{18,50}}, color={0,0,127}));
  connect(mulSum.y, intWitRes.u)
    annotation (Line(points={{-58,0},{-22,0}}, color={0,0,127}));
  connect(mulSum.u, mCon_flow)
    annotation (Line(points={{-82,0},{-120,0}}, color={0,0,127}));
  connect(notFul.y, ful.u) annotation (Line(points={{42,50},{50,50},{50,80},{58,
          80}}, color={255,0,255}));
  connect(ful.y, yRep)
    annotation (Line(points={{82,80},{120,80}}, color={255,0,255}));
  connect(edg.u,uRep)
    annotation (Line(points={{-62,-80},{-120,-80}}, color={255,0,255}));
  connect(edg.y, intWitRes.trigger) annotation (Line(points={{-38,-80},{-10,-80},
          {-10,-12}}, color={255,0,255}));
annotation (defaultComponentName="masAcc",
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This model mimics the process for a filter to capture the contaminants.
The mass of the contaminants, <code>mCon</code>, increases over time.
However, when the input signal <code>uRep</code> changes from <code>false</code>
to <code>true</code>, <code>mCon</code> is reset to <code>mCon_start</code>.
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
