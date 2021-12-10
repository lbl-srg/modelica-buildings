within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses;
block SkyClearness "Sky clearness"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Interfaces.RealInput zen(
    quantity="Angle",
    unit="rad",
    displayUnit="degreeC") "Zenith angle of the sun beam"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput HDifHor(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2")
    "Horizontal diffuse solar radiation"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput HDirNor(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2")
    "Horizontal global solar radiation"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput skyCle
    "Sky clearness. skyCle=1: overast sky; skyCle=8: clear sky"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  // Set hSmall so that hSmall + deltaX < 1E-4. See info section.
protected
  constant Modelica.Units.SI.Irradiance hSmall=0.5e-4
    "Small radiation for regularization";
  constant Modelica.Units.SI.Irradiance deltaX=hSmall/2
    "Small radiation for regularization";
  constant Real k = 5.534e-6*(180/Modelica.Constants.pi)^3 "Constant factor";
  Real tmp1 "Intermediate variable";
  Modelica.Units.SI.Irradiance HDifHorBou
    "Diffuse horizontal irradiation, bounded away from zero";
equation
  tmp1 =  k*zen^3;
  HDifHorBou = Buildings.Utilities.Math.Functions.smoothMax(
                 x1 = HDifHor,
                 x2 = hSmall,
                 deltaX = deltaX);
  // In the Buildings library, HDirNor is always larger than 1E-4
  // (minus some small undershoot due to regularization. Hence,
  // it makes no sense to simplify the equation for
  // HDirNor < Modelica.Constants.small.
  skyCle = Buildings.Utilities.Math.Functions.smoothLimit(
        x = ((HDirNor+HDifHorBou)/HDifHorBou + tmp1)/(1 + tmp1),
        l = 1,
        u = 8,
        deltaX = 0.01);

  annotation (
    defaultComponentName="skyCle",
    Documentation(info="<html>
<p>
This component computes the sky clearness.
</p>
<h4>Implementation</h4>
<p>
In the <code>Buildings</code> library, <code>HGloHor</code>
is always larger than <i>1E-4</i>,
minus some small undershoot due to regularization. Hence,
the implementation is not simplified for
<code>HGloHor &lt; Modelica.Constants.small</code>.
</p>
<p>
The function call
<code>Buildings.Utilities.Math.Functions.smoothMax</code>
is such that the regularization is usually not triggered.
</p>
</html>", revisions="<html>
<ul>
<li>
September 6, 2021, by Ettore Zanetti:<br/>
Changed <code>lat</code> from being a parameter to an input from weather bus.<br/>
Changed input connector <code>HGloHor</code> to <code>HDirHor</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
May 2, 2021, by Ettore Zanetti:<br/>
Corrected expression for sky clearness.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">issue 1477</a>.
</li>
<li>
September 23, 2016, by Michael Wetter:<br/>
Changed <code>deltaX</code> from <code>0.1</code> to <code>0.01</code>,
and also optimized the code.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/521\">issue 521</a>.
</li>
<li>
May 5, 2015, by Michael Wetter:<br/>
Introduced constant <code>k</code> to reduce number of operations.
</li>
<li>
May 5, 2015, by Filip Jorissen:<br/>
Converted <code>algorithm</code> section into
<code>equation</code> section for easier differentiability.
</li>
<li>
July 07, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-48,-6},{-100,6}},
          textColor={0,0,127},
          textString="HDifHor"),
        Text(
          extent={{-48,54},{-100,66}},
          textColor={0,0,127},
          textString="HGloHor"),
        Text(
          extent={{-48,-66},{-100,-54}},
          textColor={0,0,127},
          textString="zen")}));
end SkyClearness;
