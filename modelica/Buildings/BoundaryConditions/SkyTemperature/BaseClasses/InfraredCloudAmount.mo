within Buildings.BoundaryConditions.SkyTemperature.BaseClasses;
block InfraredCloudAmount "Infared Cloud Amount"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput nTol "Total sky cover"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput nOpa "Opaque sky cover"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput celHei(
    final quantity="Length",
    final unit="m",
    displayUnit="m") "Ceiling height"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput infCloAmo "Infared cloud amount"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Modelica.SIunits.Length Hth "Height of high clouds above sea level";

equation
  //The java code has checked and converted ceiling height data if they were missing.

  Hth = Buildings.Utilities.Math.Functions.smoothMax(
    celHei,
    8000.0,
    100);
  infCloAmo = nOpa*Modelica.Math.exp(celHei/8200.0) + 0.4*(nTol - nOpa)*
    Modelica.Math.exp(Hth/8200.0);
  annotation (
    defaultComponentName="infClo",
    Documentation(info="<HTML>
<p>
This component computes the amount of infared cloud.
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
          extent={{-96,78},{-66,44}},
          lineColor={0,0,127},
          textString="nTol"),
        Text(
          extent={{-100,22},{-52,-22}},
          lineColor={0,0,127},
          textString="celHei"),
        Text(
          extent={{-100,-38},{-62,-80}},
          lineColor={0,0,127},
          textString="nOpa"),
        Bitmap(
          extent={{-46,56},{70,-52}},
          fileName="modelica://Buildings/Images/BoundaryConditions/SkyTemperature/BaseClasses/Cloud.jpg")}));
end InfraredCloudAmount;
