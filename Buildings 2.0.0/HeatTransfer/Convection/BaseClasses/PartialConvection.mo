within Buildings.HeatTransfer.Convection.BaseClasses;
partial model PartialConvection "Partial model for heat convection"
  extends Buildings.BaseClasses.BaseIcon;
  parameter Modelica.SIunits.Area A "Heat transfer area";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hFixed=3
    "Constant convection coefficient";
  Modelica.SIunits.HeatFlowRate Q_flow "Heat flow rate from solid -> fluid";
  Modelica.SIunits.HeatFlux q_flow "Convective heat flux from solid -> fluid";
  Modelica.SIunits.TemperatureDifference dT(start=0) "= solid.T - fluid.T";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a solid
                              annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b fluid
                              annotation (Placement(transformation(extent={{90,-10},
            {110,10}})));

  parameter Modelica.SIunits.Angle til(displayUnit="deg") "Surface tilt"
    annotation (Dialog(enable= not (conMod == Buildings.HeatTransfer.Types.InteriorConvection.fixed)));

protected
  final parameter Real cosTil=Modelica.Math.cos(til) "Cosine of window tilt";
  final parameter Real sinTil=Modelica.Math.sin(til) "Sine of window tilt";
  final parameter Boolean isCeiling = abs(sinTil) < 10E-10 and cosTil > 0
    "Flag, true if the surface is a ceiling";
  final parameter Boolean isFloor = abs(sinTil) < 10E-10 and cosTil < 0
    "Flag, true if the surface is a floor";

equation
  dT = solid.T - fluid.T;
  solid.Q_flow = Q_flow;
  fluid.Q_flow = -Q_flow;
  Q_flow = A*q_flow;
  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,80},{-60,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Text(
          extent={{-35,42},{-5,20}},
          lineColor={255,0,0},
          textString="Q_flow"),
        Line(points={{-60,20},{76,20}}, color={191,0,0}),
        Line(points={{-60,-20},{76,-20}}, color={191,0,0}),
        Line(points={{-34,80},{-34,-80}}, color={0,127,255}),
        Line(points={{6,80},{6,-80}}, color={0,127,255}),
        Line(points={{40,80},{40,-80}}, color={0,127,255}),
        Line(points={{76,80},{76,-80}}, color={0,127,255}),
        Line(points={{-34,-80},{-44,-60}}, color={0,127,255}),
        Line(points={{-34,-80},{-24,-60}}, color={0,127,255}),
        Line(points={{6,-80},{-4,-60}}, color={0,127,255}),
        Line(points={{6,-80},{16,-60}}, color={0,127,255}),
        Line(points={{40,-80},{30,-60}}, color={0,127,255}),
        Line(points={{40,-80},{50,-60}}, color={0,127,255}),
        Line(points={{76,-80},{66,-60}}, color={0,127,255}),
        Line(points={{76,-80},{86,-60}}, color={0,127,255}),
        Line(points={{56,-30},{76,-20}}, color={191,0,0}),
        Line(points={{56,-10},{76,-20}}, color={191,0,0}),
        Line(points={{56,10},{76,20}}, color={191,0,0}),
        Line(points={{56,30},{76,20}}, color={191,0,0})}),
    Documentation(info="<html>
Partial model for a convective heat transfer model.
</html>", revisions="<html>
<ul>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
March 8 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialConvection;
