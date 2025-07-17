within Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses;
model SpeedCorrectionLatent "Enthalpy wheels"
  extends Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.SpeedCorrectionSensible;
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput epsLatCor(
    final unit="1")
    "Latent heat exchanger effectiveness correction"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
protected
  parameter Real[size(per.latEff.uSpe, 1)] dEpsLatCor(each fixed=false, each final unit="1")
    "Derivatives at the support points for latent heat exchanger effectiveness correction";

initial equation
  dEpsLatCor = Buildings.Utilities.Math.Functions.splineDerivatives(
    x=per.latEff.uSpe,
    y=per.latEff.epsCor,
    ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(per.latEff.epsCor, strict=false));
equation
  epsLatCor = Buildings.Utilities.Math.Functions.interpolate(
                u=uSpe,
                xd=per.latEff.uSpe,
                yd=per.latEff.epsCor,
                d=dEpsLatCor)
                "Calculate the latent heat exchanger effectiveness correction";

  annotation (
  defaultComponentName="speCor",
  Documentation(info="<html>
<p>
This model calculates the power consumption, the sensible
heat exchange effectiveness correction, and the latent
heat exchange effectiveness correction of an enthalpy wheel
when it is in different rotational speed.
</p>
<p>
The calculation of the power consumption and the sensible
heat exchange effectiveness correction is described in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.SpeedCorrectionSensible\">
Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.SpeedCorrectionSensible</a>.
</p>
<p>
The latent heat exchange effectiveness correction is calculated using
a cubic hermite spline interpolation of the latent heat exchange
effectiveness dataset (see
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Characteristics.HeatExchangerEffectiveness\">
Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Characteristics.HeatExchangerEffectiveness</a>).
</p>
</html>", revisions="<html>
<ul>
<li>
July 9, 2025, by Michael Wetter:<br/>
Refactored implementation to avoid repetitive calculation of derivatives for spline interpolation.
</li>
<li>
May 28, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Line(points={{10,86},{4,74}}, color={0,140,72},
          thickness=0.5),
        Line(points={{-26,50},{10,86},{-2,78},{10,86}}, color={0,140,72},
          thickness=0.5),
        Ellipse(extent={{-42,64},{52,-58}}, lineColor={0,140,72},
          lineThickness=0.5)}));
end SpeedCorrectionLatent;
