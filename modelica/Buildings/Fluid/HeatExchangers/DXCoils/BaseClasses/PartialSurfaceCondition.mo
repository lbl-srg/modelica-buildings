within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial block PartialSurfaceCondition
  "Partial block for apparatus dew and dry point calculation"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.EssentialParameters;
  // fixme: this model should have an boolean parameter that determines whether
  // performance need to be interpolated between stages. For the multi-stage
  // coil, no interpolation is needed
  parameter Modelica.SIunits.MassFlowRate m_flow_small = datCoi.m_flow_small
    "Small mass flow rate in case of no-flow condition";
  parameter Modelica.SIunits.AngularVelocity maxSpe(displayUnit="1/min")= datCoi.per[nSpe].spe
    "Maximum rotational speed";
  Modelica.Blocks.Interfaces.RealInput speRat "Speed index"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}}, rotation=
            0)));
  Modelica.Blocks.Interfaces.RealInput Q_flow(
    quantity="Power",
    unit="W") "Cooling capacity of the coil"
   annotation (Placement(transformation(extent={{-120,29},{-100,49}})));
  Modelica.Blocks.Interfaces.RealInput m_flow(
    quantity="MassFlowRate",
    unit="kg/s")
    "Air mass flow rate flowing through the DX Coil at given instant"
   annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput p(
    quantity="Pressure",
    unit="Pa") "Pressure at coil"
  annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput XIn "Inlet air mass fraction"
  annotation (Placement(transformation(extent={{-120,-60},{-100,-40}},
                                                                    rotation=
            0)));                         //(start=0.005, min=0, max=1.0)
  Modelica.Blocks.Interfaces.RealInput hIn(
    quantity="SpecificEnergy",
    unit="J/kg") "Specific enthalpy of air at inlet of DX Coil"
  annotation (Placement(transformation(extent={{-120,-90},{-100,-70}},rotation=
            0)));
  output Real bypass(
    start=0.25,
    min=0,
    max=1.0) "Bypass factor";
  output Modelica.SIunits.MassFlowRate m_flow_nonzero
    "Minimum flow rate in case of no-flow condition";
  output Modelica.SIunits.SpecificEnthalpy delta_h(
    start=40000,
    min=0.0)
    "Enthalpy required to be removed from the inlet air to attain apparatus dry point condition";
  output Real uACp(
    min=0,
    fixed=false) "UA/Cp of coil";
  output Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm spe
    "Rotational speed. Fixme. Do not use rpm!!!";
  constant Real uACpLowSpe=0.000001 "Minimum Value for uACp";
public
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.UACp uacp[nSpe](final
      per=datCoi.per.nomVal, redeclare final package Medium = Medium)
    "Calculates UA/Cp of the coil"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  //To handle no-flow condtion
  m_flow_nonzero=Buildings.Utilities.Math.Functions.smoothMax(
    x1=m_flow,
    x2=m_flow_small,
    deltaX=0.01*m_flow_small);
  spe=speRat*maxSpe;
  // fixme: deltaX must be scaled with UACp
  uACp=Buildings.Utilities.Math.Functions.smoothMax(
     x1=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.speedShift(
       spe=spe,
       speSet=datCoi.per.spe,
       u=uacp.uACp),
     x2=uACpLowSpe,
     deltaX=0.001);
  //Bypass factor is a function of current mass flow rate
  bypass = (Modelica.Constants.e)^(-1 * uACp / m_flow_nonzero);
  //With known value for bypass factor, enthalpy of air
  //at coil apparatus dew/dry point can be calculated at current condition.
  //'delta_h' value is restricted below hIn to avoid the freezing condition (of wet coil) and
  // also to handle the zero (or extremely low) mass flow rate condition.

  // fixme: deltaX must be scaled with hIn
  delta_h=Buildings.Utilities.Math.Functions.smoothMin(
    x1=-1*(Q_flow / m_flow_nonzero) / (1 - bypass),
    x2=0.999*hIn,
    deltaX=0.0001);
  annotation (Documentation(info="<html>
<p>
This partial block provides initial calculations for 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDewPoint\"> 
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDewPoint</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDryPoint\"> 
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDryPoint</a>.
</p>
<p>
This block calculates the UA/Cp value of the coil and interpolates between different 
speed ratios using the  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.speedShift\"> 
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.speedShift</a> function.
If the speed ratio falls below the minimum speed of the data set the 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.speedShift\"> 
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.speedShift</a> function 
smoothly connects to the origin (i.e. UA/Cp=0 at Speed ratio=0 condition).
This avoids linear extrapolation of UA/Cp below the minimum speed of the data set
which might lead to a negative value of UA/Cp and an unrealistic value of bypass factor. 
</p>
</html>",
revisions="<html>
<ul>
<li>
August 24, 2012, by Michael Wetter:<br>
Moved function from 
<code>Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses</code>
to 
<code>Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions</code>
because the package 
<code>Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses</code>
already contains a block called 
<code>SpeedShift</code> which gives a clash in file names on file systems
that do not distinguish between upper and lower case letters.
</li>
<li>
August 1, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"));
end PartialSurfaceCondition;
