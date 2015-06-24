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
  Modelica.Blocks.Interfaces.RealInput HGloHor(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2")
    "Horizontal global solar radiation"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput skyCle
    "Sky clearness. skyCle=1: overast sky; skyCle=8: clear sky"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  constant Real k = 5.534e-6*(180/Modelica.Constants.pi)^3 "Constant factor";
  Real tmp1 "Intermediate variable";
equation
  tmp1 =  k*zen^3;

  skyCle =  smooth(1,
    if (HGloHor < Modelica.Constants.small)
      then
        1
      else
       Buildings.Utilities.Math.Functions.smoothLimit(
        x=  (HGloHor/Buildings.Utilities.Math.Functions.smoothMax(
                       x1=  HDifHor,
                       x2=  1e-4,
                       deltaX=  1e-5) + tmp1)/(1 + tmp1),
        l=  1,
        u=  8,
        deltaX=  0.1));
  annotation (
    defaultComponentName="skyCle",
    Documentation(info="<html>
<p>
This component computes the sky clearness.
</p>
</html>", revisions="<html>
<ul>
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
          lineColor={0,0,255}),
        Text(
          extent={{-48,-6},{-100,6}},
          lineColor={0,0,127},
          textString="HDifHor"),
        Text(
          extent={{-48,54},{-100,66}},
          lineColor={0,0,127},
          textString="HGloHor"),
        Text(
          extent={{-48,-66},{-100,-54}},
          lineColor={0,0,127},
          textString="zen")}));
end SkyClearness;
