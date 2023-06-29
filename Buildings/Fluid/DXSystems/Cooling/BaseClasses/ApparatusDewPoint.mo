within Buildings.Fluid.DXSystems.Cooling.BaseClasses;
block ApparatusDewPoint "Calculates air properties at apparatus dew point"
  extends
    Buildings.Fluid.DXSystems.Cooling.BaseClasses.PartialSurfaceCondition;
  Modelica.Blocks.Interfaces.RealOutput hADP(
    nominal=40000,
    quantity="SpecificEnergy",
    unit="J/kg") "Specific enthalpy of air at apparatus dew point"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput XADP(
    min=0,
    max=1.0) "Humidity mass fraction of air at  apparatus dew point"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput TADP(
    quantity="ThermodynamicTemperature",
    unit="K",
    displayUnit="degC",
    start=283.15,
    min=233.15,
    max=373.15) "Dry bulb temperature of air at apparatus dew point"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
protected
  parameter Modelica.Units.SI.Temperature TSatMin=273.15 + 3
    "Minimum apparatus saturation temperature";
  parameter Modelica.Units.SI.MassFraction XSatMin=0.004667
    "Mass fraction at saturation of coil inlet conditions";
  parameter Modelica.Units.SI.SpecificEnthalpy hMin(fixed=false)
    "Minimum enthalpy of apparatus dew point";

initial equation
/*  XSatMin = Medium.Xsaturation(
        Medium.setState_pTX(p=p,
                            T=273.15+3,
                            X=cat(1,{XSatMin},{1-sum({XSatMin})})));
*/
  hMin = Medium.specificEnthalpy_pTX(
           p =  Medium.p_default,
           T =  TSatMin,
           X =  cat(1,{XSatMin},{1-sum({XSatMin})}));
equation
  hADP = Buildings.Utilities.Math.Functions.smoothMin(
    x1 = Buildings.Utilities.Math.Functions.smoothMax(
      x1=hEvaIn - delta_h,
      x2=hMin,
      deltaX=10),
    x2 = hEvaIn+100,
    deltaX=10);
  XADP = Buildings.Utilities.Psychrometrics.Functions.X_pW(p_w=Medium.saturationPressure(TADP), p=p);
  TADP= Medium.temperature(Medium.setState_phX(p=p, h=hADP, X=cat(1,{XADP},{1-sum({XADP})})));
 annotation(defaultComponentName="appDewPt",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Line(
          points={{68,74},{68,-72},{-72,-72}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{56,68},{54,56},{48,32},{38,12},{22,-8},{6,-22},{-12,-34},{
              -28,-40},{-46,-46},{-62,-50},{-66,-50}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-18,-36},{56,-8}},
          color={255,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{-20,-34},{-16,-38}},
          lineColor={255,0,0},
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-86,12},{-2,-50}},
          textColor={255,0,0},
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="ADP"),
        Ellipse(
          extent={{54,-6},{58,-10}},
          lineColor={255,0,0},
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
                               Documentation(info="<html>
<p>
This blocks outputs the state of the moist air at the dew point of the coil.
The bypass factor of the coil and the resulting enthalpy difference is
computed by its base class
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.PartialSurfaceCondition\">
Buildings.Fluid.DXSystems.Cooling.BaseClasses.PartialSurfaceCondition</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 21, 2012 by Michael Wetter:<br/>
Revised implementation and documentation.
</li>
<li>
July 4, 2012 by Kaustubh Phalak:<br/>
Updated to handle zero mass flow rate and freezing coil condition.
</li>
<li>
April 9, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"));
end ApparatusDewPoint;
