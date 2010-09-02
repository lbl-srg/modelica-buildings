within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses;
block DirectSolarIrradiationTiltedSurface
  "Direct solar irradiation on a tilted surface"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput zenAng(
    quantity="Angle",
    unit="rad",
    displayUnit="degree") "Zenith angle of the sun beam"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput incAng(
    quantity="Angle",
    unit="rad",
    displayUnit="degree") "Incidence angle of the sun beam on a tilted surface"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput HDifHor(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2")
    "Diffuse horizontal solar radiation"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput HGloHor(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2") "Global horizontal radiation"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput HDirTil(final quantity=
        "RadiantEnergyFluenceRate", final unit="W/m2")
    "Direct solar irradiation on a tilted surfce"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  HDirTil = Modelica.Math.cos(incAng)*(HGloHor - HDifHor)/Modelica.Math.cos(
    zenAng);
  annotation (
    defaultComponentName="HDirTil",
    Documentation(info="<HTML>
<p>
This component computes the direct solar irradiation on a tilted surface.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
May 24, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-48,56},{-100,68}},
          lineColor={0,0,127},
          textString="HGloHor"),
        Text(
          extent={{-50,14},{-102,26}},
          lineColor={0,0,127},
          textString="HDifHor"),
        Text(
          extent={{-52,-66},{-104,-54}},
          lineColor={0,0,127},
          textString="zenAng"),
        Text(
          extent={{-54,-26},{-106,-14}},
          lineColor={0,0,127},
          textString="incAng")}));
end DirectSolarIrradiationTiltedSurface;
