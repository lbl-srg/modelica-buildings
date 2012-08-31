within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block ApparatusDewPoint
  "Calculates air properties at apparatus dew point (ADP) at existing air-flow conditions"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialSurfaceCondition;
  parameter Boolean linearize_psat=false
    "Set to true to linearize saturation pressure"
    annotation (Evaluate=true);
  parameter Boolean linearize_XADP=false
    "Set to true to linearize mass fraction"
    annotation (Evaluate=true);
  Modelica.Blocks.Interfaces.RealOutput hADP(
    nominal=40000,
    quantity="SpecificEnergy",
    unit="J/kg") "Specific enthalpy of air at ADP"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput XADP(
    min=0,
    max=1.0) "Humidity mass fraction of air at ADP"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput TADP(
    quantity="Temperature",
    unit="K",
    displayUnit="degC",
    min=233.15,
    max=373.15) "Dry bulb temperature of air at ADP"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));

protected
  constant Real k = 0.621964713077499 "Ratio of molar masses";
  constant Real phiADP = 1.0 "Realtive humidity at ADP";
  Modelica.SIunits.AbsolutePressure psat(
    min=0.278,
    start=1230) "Saturation pressure";

equation
  hADP = hIn -delta_h;
  //Solve Eq.1, 2 & 3 to get the values of TADP and XADP
//------------------------------------------------Eq.1--------------------------------------------------------//
  psat = if linearize_psat then 1252.393+83.933*(TADP-283.15) else Medium.saturationPressure(TADP);
//-------------------------------------------------Eq.2-------------------------------------------------------//
  XADP =if linearize_XADP then 0.007572544+6.19495*(10^(-6))*(psat-1228) else phiADP*k/(k*phiADP+p/psat-phiADP);
//-------------------------------------------------Eq.3-------------------------------------------------------//
  TADP= Medium.temperature(
    Medium.setState_phX(
      p=p,
      h=hADP,
      X=cat(1,{XADP},{1-sum({XADP})})));
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
          lineColor={255,0,0},
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
This block calculates bypass factor using the known value of UA/Cp of the coil. 
Bypass factor is a function of the current mass flow rate. 
The bypass factor is then used to determine air properties at the apparatus dew point. </p>
<p>
This block also provides an option for linearized calculation of saturation 
pressure and mass fraction at ADP. This linearization can speed up the calculation 
at the cost of accuracy. The linearized equations are Taylor series 
(using the first two terms) of the nonlinear equations. 
These equations provide reasonable accuracy within normal operation range. </p>
<p>
Saturation pressure is an exponential function of temperature. 
Therefore its linear equation provides reasonable accuracy within a limited range of 
temperatures. It calculates saturation pressure at ADP condition. 
Accuracy ranges with relative errors for the linear equation are as follows:   
<ul> TADP range (6 to 14 degC) :relative error within 2 percent</ul>
<ul> TADP range(4 to 20 degC):relative error within 10 percent</ul> </p>
<p>
Treating the mass fraction of air as a linear function of saturation pressure 
provides good results over a  large range. 
This linear function calculates the mass fraction value within 
1 percent relative error for saturation pressure range of 300 Pa to 4800 Pa. 
In terms of saturation temperature this range is from 0 degC to 34 degC. </p>
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0 Engineering Reference</a>, May 24, 2012.
</p>
<p>
Kruis, Nathanael. <i>Reconciling differences between Residential DX Cooling Coil models in DOE-2 and EnergyPlus.</i> 
Fourth National Conference of IBPSA-USA. New York: SimBuild, 2010. 134-141.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 4, 2012 by Kaustubh Phalak:<br>
Updated to handle zero mass flow rate and freezing coil condition. 
</li>
<li>
April 9, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"),
    Diagram(graphics));
end ApparatusDewPoint;
