within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block ApparatusDryPoint "Calculates air properties at dry coil surface"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialSurfaceCondition;
  Modelica.Blocks.Interfaces.RealOutput TDry(
    quantity="ThermodynamicTemperature",
    unit="K",
    displayUnit="degC",
    min=253.15,
    max=373.15) "Dry bulb temperature of air at dry coil condition"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  output Modelica.Units.SI.SpecificEnthalpy hDry
    "Enthalpy of air at coil surface";
protected
  Modelica.Units.SI.MassFraction XEvaInVec[Medium.nX]
    "Mass fraction of air inlet condition";
  Modelica.Units.SI.Temperature TADP(start=283.15)
    "Apparatus dew point temperature";
  Modelica.Units.SI.SpecificEnthalpy hMin
    "Minimum enthalpy of apparatus dew point";
equation
  XEvaInVec =cat(1,{XEvaIn},{1-sum({XEvaIn})});

  XEvaIn = Buildings.Utilities.Psychrometrics.Functions.X_pW(
     p_w=Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid(TADP), p=p);

  hMin = Medium.specificEnthalpy(Medium.setState_pTX(p=p, T=TADP, X=XEvaInVec));

  hDry = Buildings.Utilities.Math.Functions.smoothMin(
    x1 = Buildings.Utilities.Math.Functions.smoothMax(
      x1=hEvaIn - delta_h,
      x2=hMin,
      deltaX=10),
    x2 = hEvaIn+100,
    deltaX=10);

  TDry= Medium.temperature(Medium.setState_phX(p=p, h=hDry, X=XEvaInVec))
    "XEvaIn=XDry assumption for dry coil";

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
This blocks outputs the state of the moist air at of the coil, assuming no condensation occurs.
The bypass factor of the coil and the resulting enthalpy difference is
computed by its base class
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialSurfaceCondition\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialSurfaceCondition</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 21, 2012 by Michael Wetter:<br/>
Revised implementation and documentation.
</li>
<li>
April 9, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"));
end ApparatusDryPoint;
