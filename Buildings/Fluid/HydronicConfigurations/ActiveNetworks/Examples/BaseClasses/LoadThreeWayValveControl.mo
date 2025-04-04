within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses;
model LoadThreeWayValveControl
  "Model of a load on hydronic circuit with flow rate modulation by three-way valve"
  extends PartialLoadValveControl(
    redeclare HydronicConfigurations.ActiveNetworks.Diversion con);

  annotation (
  defaultComponentName="loa",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          origin={60,-10},
          rotation=90,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          origin={50,0},
          rotation=0,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,0},{-80,-70},{60,-70},{60,-20}},
          color={0,0,0},
          thickness=0.5)}),
  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a model of a thermal load on a hydronic circuit that
is composed of
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.Load\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.Load</a>
and a diversion circuit with a three-way valve 
that is used to modulate the flow rate through the load component.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end LoadThreeWayValveControl;
