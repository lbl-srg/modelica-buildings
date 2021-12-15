within Buildings.Obsolete.DistrictHeatingCooling.Examples.BaseClasses;
model SubStationBoundaryCondition
  "Model with boundary condition for the base case"
  extends Buildings.BaseClasses.BaseIcon;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching=true);
  parameter Modelica.Units.SI.TemperatureDifference dTApp(min=0) = 2
    "Approach temperature";
  parameter Boolean warmSide
    "Set to true if these are the boundary conditions for the warm side inlet";

  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC") "Outside temperature, used to set medium temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium)
    "Fluid port at fixed pressure and temperature"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPor
    "Heat port at fixed temperature"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));

  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=true) "Boundary condition"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem
    "Prescribed temperature"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Blocks.Math.Add add(k1=if warmSide then -1 else +1)
    annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
  Modelica.Blocks.Sources.Constant TAppr(k=dTApp) "Approach temperature"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(bou.ports[1], port_a)
    annotation (Line(points={{10,0},{56,0},{100,0}}, color={0,127,255}));
  connect(preTem.port, heaPor)
    annotation (Line(points={{10,-60},{100,-60}}, color={191,0,0}));
  connect(add.u2, TOut)
    annotation (Line(points={{-52,0},{-82,0},{-120,0}}, color={0,0,127}));
  connect(add.y, bou.T_in) annotation (Line(points={{-29,6},{-22,6},{-22,4},{-12,
          4}}, color={0,0,127}));
  connect(TAppr.y, add.u1) annotation (Line(points={{-59,50},{-56,50},{-56,12},{
          -52,12}}, color={0,0,127}));
  connect(add.y, preTem.T) annotation (Line(points={{-29,6},{-22,6},{-22,-60},{
          -12,-60}}, color={0,0,127}));
  annotation (Icon(graphics={
        Ellipse(
          extent={{-70,70},{64,-64}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,127,255}),
        Ellipse(
          extent={{-70,70},{64,-64}},
          lineColor={0,0,0},
          visible=warmSide,
          fillPattern=FillPattern.Sphere,
          fillColor={255,0,0})}), Documentation(info="<html>
<p>
This is a model for the boundary conditions of the heat pumps
in the base case. The model sets the leaving fluid temperature,
and the temperature of its heat port, to be equal to the input
signal <code>TOut</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 12, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SubStationBoundaryCondition;
