within Buildings.Experimental.OpenBuildingControl.CDL.Interfaces;
partial block SISO
  "Single Input Single Output continuous control block"

  RealInput u "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  annotation (Icon(graphics={      Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
        Documentation(info="<html>
<p>
Block has one continuous Real input and one continuous Real output signal.
</p>
</html>", revisions="<html>
<ul>
<li>
March 23, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end SISO;
