within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block ApparatusDryPoint "Calculates air properties at dry coil surface"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialSurfaceCondition;
  Modelica.Blocks.Interfaces.RealOutput TDry(
    quantity="Temperature",
    unit="K",
    displayUnit="degC",
    min=273.15,
    max=373.15) "Dry bulb temperature of air at dry coil condition"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  output Modelica.SIunits.SpecificEnthalpy hDry
    "Enthalpy of air at coil surface(i.e. at dry point)";
equation
  hDry = hIn-delta_h;
  TDry= Medium.temperature(Medium.setState_phX(
    p=p,
    h=hDry,
    X=cat(1,{XIn},{1-sum({XIn})}))) "XIn=XDry Assumption for dry coil";
 annotation(defaultComponentName="appDryPt",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Line(
          points={{76,68},{76,-78},{-64,-78}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{64,64},{62,52},{56,28},{46,8},{30,-12},{14,-26},{-4,-38},{-20,
              -44},{-38,-50},{-54,-54},{-58,-54}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{28,-30},{70,-30}},
          color={255,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{26,-28},{30,-32}},
          lineColor={255,0,0},
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{68,-28},{72,-32}},
          lineColor={255,0,0},
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
                                   Documentation(info="<html>
<p>
This block calculates bypass factor using a known value of UA/Cp of the coil. 
Bypass factor is a function of the current mass flow rate. 
Air properties at the dry point are determined using 
the bypass factor and the assumption of a dry coil 
i.e. X<sub>In</sub> = X<sub>Out</sub> = X<sub>Dry</sub> . 
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/DXCoils/BaseClasses/ApparatusDryPoint.png\" 
border=\"1\" width=\"507.2\" height=\"452.8\">
</p> 
Note: Dry point implies dry coil condition (and not dry air condition).
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0 Engineering Reference</a>, May 24, 2012.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 9, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"),
    Diagram(graphics));
end ApparatusDryPoint;
