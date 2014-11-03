within Buildings.Fluid.FMI.Examples;
model MyFirstOrder
  "FMU declaration that contains inside an first order element"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real publicThirty = 30 "Public parameter for 30";
  final parameter Real finalPublicTwo=2 "Final public parameter for 2";
  final parameter Real finalPublicSixty=finalPublicTwo*publicThirty
    "Gain as a public parameter";
  parameter Real publicSixty=finalPublicTwo*publicThirty
    "Gain as a public parameter";
  constant Real constantTwo = 2 "Value 2";
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    T=finalPublicSixty,
    final k=finalPublicTwo,
    final initType=Modelica.Blocks.Types.Init.InitialState,
    y_start(start=3))
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

protected
  final parameter Real protectedTwo=2 "Gain as a protected parameter";
  Modelica.Blocks.Math.Gain protectedGain(k=protectedTwo) "Constant gain"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(u, firstOrder.u) annotation (Line(
      points={{-120,0},{-84,0},{-84,8.88178e-16},{-62,8.88178e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, protectedGain.u) annotation (Line(
      points={{-39,0},{-6,0},{-6,6.66134e-16},{18,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(protectedGain.y, y) annotation (Line(
      points={{41,6.66134e-16},{80,6.66134e-16},{80,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(
     preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end MyFirstOrder;
