within Buildings.HeatTransfer;
package Sources "Thermal sources"
extends Modelica.Icons.SourcesPackage;


  model FixedTemperature "Fixed temperature boundary condition in Kelvin"

    parameter Modelica.SIunits.Temperature T "Fixed temperature at port";
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port annotation (Placement(transformation(extent={{90,
              -10},{110,10}}, rotation=0)));
  equation
    port.T = T;
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics={
          Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            lineColor={0,0,255}),
          Text(
            extent={{-150,-110},{150,-140}},
            lineColor={0,0,0},
            textString="T=%T"),
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
            points={{-52,0},{56,0}},
            color={191,0,0},
            thickness=0.5),
          Polygon(
            points={{50,-20},{50,20},{90,0},{50,-20}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid)}),
      Documentation(info="<HTML>
<p>
This model defines a fixed temperature T at its port in Kelvin,
i.e., it defines a fixed temperature as a boundary condition.
</p>
</HTML>
"),   Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics={
          Rectangle(
            extent={{-100,100},{100,-101}},
            lineColor={0,0,0},
            pattern=LinePattern.None,
            fillColor={159,159,223},
            fillPattern=FillPattern.Backward),
          Line(
            points={{-52,0},{56,0}},
            color={191,0,0},
            thickness=0.5),
          Text(
            extent={{0,0},{-100,-100}},
            lineColor={0,0,0},
            textString="K"),
          Polygon(
            points={{52,-20},{52,20},{90,0},{52,-20}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid)}));
  end FixedTemperature;


  model PrescribedTemperature
  "Variable temperature boundary condition in Kelvin"

    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port annotation (Placement(transformation(extent={{90,
              -10},{110,10}}, rotation=0)));
    Modelica.Blocks.Interfaces.RealInput T annotation (Placement(transformation(
            extent={{-140,-20},{-100,20}}, rotation=0)));
  equation
    port.T = T;
    annotation (
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
      Documentation(info="<HTML>
<p>
This model represents a variable temperature boundary condition.
The temperature in [K] is given as input signal <b>T</b>
to the model. The effect is that an instance of this model acts as
an infinite reservoir able to absorb or generate as much energy
as required to keep the temperature at the specified value.
</p>
</HTML>
"),   Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
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


  model FixedHeatFlow "Fixed heat flow boundary condition"
    parameter Modelica.SIunits.HeatFlowRate Q_flow
    "Fixed heat flow rate at port";
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port annotation (Placement(transformation(extent={{90,
              -10},{110,10}}, rotation=0)));
  equation
    port.Q_flow = -Q_flow;
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics={
          Text(
            extent={{-150,100},{150,60}},
            textString="%name",
            lineColor={0,0,255}),
          Text(
            extent={{-150,-55},{150,-85}},
            lineColor={0,0,0},
            textString="Q_flow=%Q_flow"),
          Line(
            points={{-100,-20},{48,-20}},
            color={191,0,0},
            thickness=0.5),
          Line(
            points={{-100,20},{46,20}},
            color={191,0,0},
            thickness=0.5),
          Polygon(
            points={{40,0},{40,40},{70,20},{40,0}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{40,-40},{40,0},{70,-20},{40,-40}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{70,40},{90,-40}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
              {100,100}}), graphics={
          Text(
            extent={{-100,40},{0,-36}},
            lineColor={0,0,0},
            textString="Q_flow=const."),
          Line(
            points={{-48,-20},{60,-20}},
            color={191,0,0},
            thickness=0.5),
          Line(
            points={{-48,20},{60,20}},
            color={191,0,0},
            thickness=0.5),
          Polygon(
            points={{60,0},{60,40},{90,20},{60,0}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{60,-40},{60,0},{90,-20},{60,-40}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid)}),
      Documentation(info="<HTML>
<p>
This model allows a specified amount of heat flow rate to be \"injected\"
into a thermal system at a given port.  The constant amount of heat
flow rate Q_flow is given as a parameter. The heat flows into the
component to which the component FixedHeatFlow is connected,
if parameter Q_flow is positive.
</p>
<p>
This model is identical to
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow</a>, except that
the parameters <code>alpha</code> and <code>T_ref</code> have
been deleted as these can cause division by zero in some fluid flow models.
</p>
</HTML>",revisions="<html>
<ul>
<li>
March 29 2011, by Michael Wetter:<br/>
First implementation based on <a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow</a>.
</li>
</ul>
</html>"));
  end FixedHeatFlow;


  model PrescribedHeatFlow "Prescribed heat flow boundary condition"
    Modelica.Blocks.Interfaces.RealInput Q_flow
          annotation (Placement(transformation(
          origin={-100,0},
          extent={{20,-20},{-20,20}},
          rotation=180)));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port annotation (Placement(transformation(extent={{90,
              -10},{110,10}}, rotation=0)));
  equation
    port.Q_flow = -Q_flow;
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics={
          Line(
            points={{-60,-20},{40,-20}},
            color={191,0,0},
            thickness=0.5),
          Line(
            points={{-60,20},{40,20}},
            color={191,0,0},
            thickness=0.5),
          Line(
            points={{-80,0},{-60,-20}},
            color={191,0,0},
            thickness=0.5),
          Line(
            points={{-80,0},{-60,20}},
            color={191,0,0},
            thickness=0.5),
          Polygon(
            points={{40,0},{40,40},{70,20},{40,0}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{40,-40},{40,0},{70,-20},{40,-40}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{70,40},{90,-40}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-150,100},{150,60}},
            textString="%name",
            lineColor={0,0,255})}),
      Documentation(info="<HTML>
<p>
This model allows a specified amount of heat flow rate to be \"injected\"
into a thermal system at a given port.  The amount of heat
is given by the input signal Q_flow into the model. The heat flows into the
component to which the component PrescribedHeatFlow is connected,
if the input signal is positive.
</p>
<p>
This model is identical to
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow</a>, except that
the parameters <code>alpha</code> and <code>T_ref</code> have
been deleted as these can cause division by zero in some fluid flow models.
</p>
</HTML>
",revisions="<html>
<ul>
<li>
March 29 2011, by Michael Wetter:<br/>
First implementation based on <a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow</a>.
</li>
</ul>
</html>"),   Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
              {100,100}}), graphics={
          Line(
            points={{-60,-20},{68,-20}},
            color={191,0,0},
            thickness=0.5),
          Line(
            points={{-60,20},{68,20}},
            color={191,0,0},
            thickness=0.5),
          Line(
            points={{-80,0},{-60,-20}},
            color={191,0,0},
            thickness=0.5),
          Line(
            points={{-80,0},{-60,20}},
            color={191,0,0},
            thickness=0.5),
          Polygon(
            points={{60,0},{60,40},{90,20},{60,0}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{60,-40},{60,0},{90,-20},{60,-40}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid)}));
  end PrescribedHeatFlow;


  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})),   Documentation(info="<html>
This package is identical to
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources\">
Modelica.Thermal.HeatTransfer.Sources</a>, except that
the parameters <code>alpha</code> and <code>T_ref</code> have
been deleted in the models
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow</a> and
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow</a>
 as these can cause division by zero in some fluid flow models.
</html>"));
end Sources;
