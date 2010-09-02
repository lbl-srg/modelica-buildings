within Buildings.BoundaryConditions.SolarGeometry.BaseClasses;
block IncidenceAngle "The solar incidence angle on a tilted surface"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Modelica.SIunits.Angle aziAng(displayUnit="degree")
    "Surface azimuth. aziAng=-90 degree if surface outward unit normal points toward east; aziAng=0 if it points toward south";
  parameter Modelica.SIunits.Angle tilAng(displayUnit="degree")
    "Surface tilt. tilAng=90 degree for walls; tilAng=0 for ceilings";
  Modelica.Blocks.Interfaces.RealInput solHouAng(quantity="Angle", unit="rad")
    "Solar hour angle"
    annotation (Placement(transformation(extent={{-140,-68},{-100,-28}})));
  Modelica.Blocks.Interfaces.RealInput decAng(quantity="Angle", unit="rad")
    "Declination"
    annotation (Placement(transformation(extent={{-142,34},{-102,74}})));
  Modelica.Blocks.Interfaces.RealOutput incAng(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Incidence angle on a tilted surfce"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Real dec_c=Modelica.Math.cos(decAng);
  Real dec_s=Modelica.Math.sin(decAng);
  Real sol_c=Modelica.Math.cos(solHouAng);
  Real sol_s=Modelica.Math.sin(solHouAng);
  Real lat_c=Modelica.Math.cos(lat);
  Real lat_s=Modelica.Math.sin(lat);
equation
  incAng = Modelica.Math.cosh(Modelica.Math.cos(tilAng)*(dec_c*sol_c*lat_c +
    dec_s*lat_s) + Modelica.Math.sin(tilAng)*(Modelica.Math.sin(aziAng)*dec_c*
    sol_s + Modelica.Math.cos(aziAng)*(dec_c*sol_c*lat_s - dec_s*lat_c)));
  annotation (
    defaultComponentName="incAng",
    Documentation(info="<HTML>
<p>
This component computes the solar incidence angle on a tilted surface by using solar hour angle and declination angle as input.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
May 19, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-98,60},{-56,50}},
          lineColor={0,0,127},
          textString="decAng"),
        Text(
          extent={{-98,-42},{-42,-54}},
          lineColor={0,0,127},
          textString="solHouAng")}));
end IncidenceAngle;
