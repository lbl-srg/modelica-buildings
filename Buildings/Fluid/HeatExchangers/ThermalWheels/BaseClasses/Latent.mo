within Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses;
model Latent "Enthalpy wheels"
  extends Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Sensible;
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput epsLatCor(
    final unit="1")
    "Latent heat exchanger effectiveness correction" annotation (Placement(
        transformation(extent={{100,-100},{140,-60}}), iconTransformation(
          extent={{100,-100},{140,-60}})));
equation
  epsLatCor = Buildings.Utilities.Math.Functions.smoothInterpolation(
                x=uSpe,
                xSup=per.latHeatExchangeEffectiveness.uSpe,
                ySup=per.latHeatExchangeEffectiveness.epsCor)
                "Calculate the latent heat exchanger effectiveness correction";

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
heat exchange effectiveness correction is described in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Sensible\"> 
Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Sensible</a>.
</p>
<p>
The latent heat exchange effectiveness correction is calculated using
the cubic hermite spline interpolation of the latent heat exchange 
effectiveness dataset (see 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Characteristics.HeatExchangerEffectiveness\">
Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Characteristics.HeatExchangerEffectiveness</a>).
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
