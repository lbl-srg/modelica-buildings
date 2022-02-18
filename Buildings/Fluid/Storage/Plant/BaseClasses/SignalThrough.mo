within Buildings.Fluid.Storage.Plant.BaseClasses;
block SignalThrough "Signal passes through"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput u "Signal in" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0})));
  Modelica.Blocks.Interfaces.RealOutput y "Signal out" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
equation
  connect(u, y) annotation (Line(points={{-110,0},{110,0}}, color={0,0,127}));
  annotation (Icon(graphics={Line(points={{-100,0},{100,0}}, color={28,108,200})}),
      Documentation(info="<html>
Signal directly passes through from the input to the output.
This is used to replace conditionally-enabled blocks with a connection.
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end SignalThrough;
