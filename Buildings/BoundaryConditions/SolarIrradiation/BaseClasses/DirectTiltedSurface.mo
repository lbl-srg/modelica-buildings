within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses;
block DirectTiltedSurface "Direct solar irradiation on a tilted surface"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput incAng(
    quantity="Angle",
    unit="rad",
    displayUnit="deg") "Incidence angle of the sun beam on a tilted surface"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput HDirNor(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2") "Direct normal radiation"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput HDirTil(final quantity=
        "RadiantEnergyFluenceRate", final unit="W/m2")
    "Direct solar irradiation on a tilted surface"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  HDirTil =  max(0, Modelica.Math.cos(incAng)*HDirNor);
  annotation (
    defaultComponentName="HDirTil",
    Documentation(info="<html>
<p>
This component computes the direct solar irradiation on a tilted surface.
</p>
</html>", revisions="<html>
<ul>
<li>
April 27, 2018, by Michael Wetter:<br/>
Corrected <code>displayUnit</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/912\">IBPSA, issue 912</a>.
</li>
<li>
May 5, 2015, by Filip Jorissen:<br/>
Converted <code>algorithm</code> section into
<code>equation</code> section for easier differentiability.
</li>
<li>
May 24, 2010, by Wangda Zuo:<br/>
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
          extent={{-50,56},{-102,68}},
          textColor={0,0,127},
          textString="HDirNor"),
        Text(
          extent={{-54,-66},{-106,-54}},
          textColor={0,0,127},
          textString="incAng")}));
end DirectTiltedSurface;
