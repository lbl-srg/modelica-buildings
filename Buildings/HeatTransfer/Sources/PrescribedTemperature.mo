within Buildings.HeatTransfer.Sources;
model PrescribedTemperature "Variable temperature boundary condition in Kelvin"

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port annotation (Placement(transformation(extent={{90,
            -10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput T annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}})));
equation
  port.T = T;
  annotation (
    defaultComponentName="preTem",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={159,159,223},
          fillPattern=FillPattern.Backward),
        Line(
          points={{-102,0},{64,0}},
          color={191,0,0},
          thickness=0.5),
        Text(
          extent={{0,0},{-100,-100}},
          lineColor={0,0,0},
          textString="K"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Polygon(
          points={{50,-20},{50,20},{90,0},{50,-20}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This model represents a variable temperature boundary condition.
The temperature in [K] is given as input signal <b>T</b>
to the model. The effect is that an instance of this model acts as
an infinite reservoir able to absorb or generate as much energy
as required to keep the temperature at the specified value.
</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={159,159,223},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{0,0},{-100,-100}},
          lineColor={0,0,0},
          textString="K"),
        Line(
          points={{-102,0},{64,0}},
          color={191,0,0},
          thickness=0.5),
        Polygon(
          points={{52,-20},{52,20},{90,0},{52,-20}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}));
end PrescribedTemperature;
