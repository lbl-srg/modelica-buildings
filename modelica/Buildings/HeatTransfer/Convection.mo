within Buildings.HeatTransfer;
model Convection "Model for a convective heat transfer"
  extends Buildings.BaseClasses.BaseIcon;
  parameter Buildings.RoomsBeta.Types.ConvectionModel conMod=
    Buildings.RoomsBeta.Types.ConvectionModel.Fixed
    "Convective heat transfer model"
  annotation(Evaluate=true);
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hFixed=3
    "Constant convection coefficient"
    annotation (Dialog(enable=(conMod == Buildings.RoomsBeta.Types.ConvectionModel.fixed)));
  parameter Modelica.SIunits.Angle til(displayUnit="deg") "Surface tilt"
    annotation (Dialog(enable= not (conMod == Buildings.RoomsBeta.Types.ConvectionModel.fixed)));

  parameter Modelica.SIunits.Area A "Heat transfer area";

  Modelica.SIunits.HeatFlux q_flow "Convective heat flux from solid -> fluid";
  Modelica.SIunits.HeatFlowRate Q_flow "Heat flow rate from solid -> fluid";
  Modelica.SIunits.TemperatureDifference dT(start=0) "= solid.T - fluid.T";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a solid
                              annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}},      rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b fluid
                              annotation (Placement(transformation(extent={{90,-10},
            {110,10}},         rotation=0)));
protected
  final parameter Real cosTil=Modelica.Math.cos(til) "Cosine of window tilt"
    annotation (Evaluate=true);
  final parameter Real sinTil=Modelica.Math.sin(til) "Sine of window tilt"
    annotation (Evaluate=true);
  final parameter Boolean isCeiling = abs(sinTil) < 10E-10 and cosTil > 0
    "Flag, true if the surface is a ceiling"
    annotation (Evaluate=true);
  final parameter Boolean isFloor = abs(sinTil) < 10E-10 and cosTil < 0
    "Flag, true if the surface is a floor"
    annotation (Evaluate=true);

equation
  dT = solid.T - fluid.T;
  solid.Q_flow = Q_flow;
  fluid.Q_flow = -Q_flow;
  if (conMod == Buildings.RoomsBeta.Types.ConvectionModel.Fixed) then
    q_flow = hFixed * dT;
  else
    // Even if hCon is a step function with a step at zero,
    // the product hCon*dT is differentiable at zero with
    // a continuous first derivative
    if isCeiling then
       q_flow = Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.ceiling(dT=dT);
    elseif isFloor then
       q_flow = Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.floor(dT=dT);
    else
       q_flow = Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.wall(dT=dT);
    end if;
  end if;
  Q_flow = A*q_flow;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),       graphics), Icon(coordinateSystem(
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
This is a model for a convective heat transfer.
The model can be configured to use various functions
from the package
<a href=\"modelica://Buildings.HeatTransfer.Functions.ConvectiveHeatFlux\">
Buildings.HeatTransfer.Functions.ConvectiveHeatFlux</a>
to compute the convective heat transfer.
</html>", revisions="<html>
<ul>
<li>
March 10 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Convection;
