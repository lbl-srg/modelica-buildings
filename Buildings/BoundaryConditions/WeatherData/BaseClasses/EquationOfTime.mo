within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block EquationOfTime "Equation of time"
  extends PartialConvertTime;
  Modelica.Blocks.Interfaces.RealInput nDay(
    quantity="Time",
    unit="s")
    "Zero-based day number in seconds (January 1=0, January 2=86400)"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput eqnTim(
    final quantity="Time",
    final unit="s",
    displayUnit="min") "Equation of time"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Real Bt "Intermediate variable";
equation
  modTimAux = nDay;
  Bt = Modelica.Constants.pi*((calTimAux + 86400)/86400 - 81)/182
    "Our unit is s instead of day in (A.4.2b)";
  eqnTim = 60*(9.87*Modelica.Math.sin(2*Bt) - 7.53*Modelica.Math.cos(Bt) - 1.5*
    Modelica.Math.sin(Bt)) "Our unit is s instead of min in (A.4.2a)";
  annotation (
    defaultComponentName="eqnTim",
    Documentation(info="<html>
<p>
This component computes the difference between solar noon and noon of local civil time.
</p>
</html>", revisions="<html>
<ul>
<li>
March 27, 2023, by Ettore Zanetti:<br/>
Updated to use partial class for conversion from simulation time to calendar time.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1716\">IBPSA #1716</a>.
</li>
<li>
May 13, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-58,38},{38,-24}},
          textColor={0,0,255},
          textString="t"),
        Text(
          extent={{-6,4},{52,-24}},
          textColor={0,0,255},
          textString="equ")}));
end EquationOfTime;
