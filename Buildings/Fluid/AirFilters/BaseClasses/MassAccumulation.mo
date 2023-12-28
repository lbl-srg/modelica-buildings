within Buildings.Fluid.AirFilters.BaseClasses;
model MassAccumulation
  "Component that mimics the accumulation of the contaminants"
  parameter Real mCon_nominal
  "contaminant held capacity of the filter";
  parameter Real mCon_reset
  "initial contaminant mass of the filter";
  Modelica.Blocks.Interfaces.BooleanInput triRep
    "replacing the filter when trigger becomes true"
     annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,-60}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-62})));
  Modelica.Blocks.Interfaces.RealInput mCon_flow(
    final unit = "kg/s")
    "The contaminant mass flow rate"
    annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,60}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,60})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mCon(
    final unit = "kg")
    "mass of the contaminant held by the filter"
    annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent={
            {100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes
    "calculates the mass of contaminant"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(k=mCon_reset)
    "constant"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica.Blocks.Logical.Greater greater
    "check if the filter is full"
    annotation (Placement(transformation(extent={{40,-48},{60,-28}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(k=mCon_nominal)
    "constant"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message="*** Warning in " +
        getInstanceName() + ":the filter needs to be replaced")
    "Error message when the filter is full, i.e., the mass held by the filter is larger than its capacity"
    annotation (Placement(transformation(extent={{72,-48},{92,-28}})));
equation
  connect(intWitRes.u, mCon_flow) annotation (Line(points={{-12,0},{-40,0},{-40,
          60},{-120,60}}, color={0,0,127}));
  connect(intWitRes.y, mCon)
    annotation (Line(points={{12,0},{120,0}},               color={0,0,127}));
  connect(con.y, intWitRes.y_reset_in) annotation (Line(points={{-58,-20},{-20,-20},
          {-20,-8},{-12,-8}},color={0,0,127}));
  connect(intWitRes.trigger, triRep)
    annotation (Line(points={{0,-12},{0,-60},{-120,-60}}, color={255,0,255}));
  connect(assMes.u, greater.y)
    annotation (Line(points={{70,-38},{61,-38}}, color={255,0,255}));
  connect(greater.u2, intWitRes.y) annotation (Line(points={{38,-46},{20,-46},{20,
          0},{12,0}}, color={0,0,127}));
  connect(con1.y, greater.u1) annotation (Line(points={{22,50},{30,50},{30,-38},
          {38,-38}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-153,-102},{147,-142}},
          textColor={0,0,255},
          textString="%name")}),
          Diagram(coordinateSystem(
          preserveAspectRatio=false)),
          defaultComponentName="masAcc",
    Documentation(info="<html>
<p>
This model mimics the process for a filter to capture the contaminants.
The mass of the contaminants, <code>mCon</code>, increases by time.
However, when the input signal <code>triRep</code> changes from <i>false</i>
to <i>true</i>, <code>mCon</code> is reinitialized to a constant <code>mCon_reset</code>.
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
