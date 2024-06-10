within Buildings.Fluid.BaseClasses.VariableSpeedWheel;
model Latent "Enthalpy wheels"
  extends Sensible;
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput epsLatCor(
    final unit="1")
    "Latent heat exchanger effectiveness correction" annotation (Placement(
        transformation(extent={{100,-100},{140,-60}}), iconTransformation(
          extent={{100,-100},{140,-60}})));
equation
  epsLatCor = Buildings.Utilities.Math.Functions.smoothInterpolation(
                x=uSpe,
                xSup=per.latHeatExchangeEffectiveness.uSpe,
                ySup=per.latHeatExchangeEffectiveness.epsCor);

  annotation (
  defaultComponentName="latWhe",
  Documentation(info="<html>
<p>
This model calculates the power consumption, the sensible 
heat exchange effectiveness correction, and the latent 
heat exchange effectiveness correction of an enthalpy wheel. 
</p>
<p>
The calculation of the power consumption and the sensible 
heat exchange effectiveness correction can be refered to
<a href=\"modelica://Buildings.Fluid.BaseClasses.VariableSpeedWheel.Sensible\">
Buildings.Fluid.BaseClasses.VariableSpeedWheel.Sensible</a>.
</p>
<p>
The latent heat exchange effectiveness correction is calculated based 
on the cubic hermite spline of the latent heat exchange effectiveness 
correction curve in the performance dataset.
</p>
</html>", revisions="<html>
<ul>
<li>
May 28, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Latent;
