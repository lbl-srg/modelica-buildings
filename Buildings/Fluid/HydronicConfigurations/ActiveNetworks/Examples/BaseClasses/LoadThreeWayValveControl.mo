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
        coordinateSystem(preserveAspectRatio=false)));
end LoadThreeWayValveControl;
