within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting;
model FunctionalIcingFactor
  "Estimate the frosting supression using a function"
  extends BaseClasses.PartialIcingFactor;

  replaceable function icingFactor =
      Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.Functions.partialIcingFactor
    constrainedby
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.Functions.partialIcingFactor
    "Replaceable function to calculate current icing factor"
    annotation(choicesAllMatching=true);
protected
  Modelica.Blocks.Routing.RealPassThrough pasThrTEvaIn
    "Enable usage of bus variables in function call"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Modelica.Blocks.Routing.RealPassThrough pasThrTEvaOut
    "Enable usage of bus variables in function call"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Blocks.Routing.RealPassThrough pasThrMasFlowEva
    "Enable usage of bus variables in function call"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.RealExpression ice(
    final y=icingFactor(
      pasThrTEvaIn.y,
      pasThrTEvaOut.y,
      pasThrMasFlowEva.y)) "Icing factor"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(pasThrTEvaOut.u, sigBus.TEvaOutMea) annotation (Line(points={{-12,-30},
          {-54,-30},{-54,0},{-101,0}},
                            color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(pasThrTEvaIn.u, sigBus.TEvaInMea) annotation (Line(points={{-12,30},{-54,30},{
          -54,0},{-101,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(pasThrMasFlowEva.u, sigBus.mEvaMea_flow) annotation (Line(points={{-12,0},
          {-101,0}},        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ice.y, iceFac)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-151,147},{149,107}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name"),
        Ellipse(
          lineColor = {108,88,49},
          fillColor = {255,215,136},
          fillPattern = FillPattern.Solid,
          extent = {{-100,-100},{100,100}}),
        Text(
          textColor={108,88,49},
          extent={{-90.0,-90.0},{90.0,90.0}},
          textString="f")}),                                     Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
    <ul>
    <li>
    <>December 7, 2023, by Michael Wetter:<br/>
    Changed implementation to use graphical models.
    </li>
    <li>
    <i>November 26, 2018,</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Model using functional approaches for calculation of the icing factor.
  The replaceable function uses the inputs on the evaporator side to calculate
  the resulting icing factor.
</p>
<p>
  For more information, see the documentation of <a href=
  \"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle\">
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle</a>
</p>
</html>"));
end FunctionalIcingFactor;
