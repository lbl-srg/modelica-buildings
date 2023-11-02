within Buildings.Experimental.DHC.Networks.BaseClasses;
partial model PartialDistribution
  "Partial model for distribution network"
  extends Buildings.Experimental.DHC.Networks.BaseClasses.PartialDistribution2Medium(
    redeclare final package MediumSup=Medium,
    redeclare final package MediumRet=Medium);
  replaceable package Medium=Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation (choices(
      choice(redeclare package Medium=Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
        property_T=293.15,X_a=0.40) "Propylene glycol water, 40% mass fraction")));
  annotation (
    defaultComponentName="dis",
    Documentation(
      info="
<html>
<p>
Partial model to be used for modeling various distribution networks e.g. 
one-pipe or two-pipe hydraulic distribution.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 28, 2022, by Kathryn Hinkelman:<br/>
Refactored to extend shared two medium base class.
</li>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-100},{200,100}}),
      graphics={
        Text(
          extent={{-149,-104},{151,-144}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-200,-100},{200,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})));
end PartialDistribution;
