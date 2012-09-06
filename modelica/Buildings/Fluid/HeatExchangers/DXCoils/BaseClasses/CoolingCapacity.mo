within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block CoolingCapacity
  "Calculates cooling capacity at given temperature and flow fraction"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  //Performance curve variables
  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput TConIn(
    quantity="Temperature",
    unit="K",
    displayUnit="degC") "Temperature of air entering the condenser coil "
     annotation (Placement(transformation(extent={{-120,38},{-100,58}})));
  Modelica.Blocks.Interfaces.RealInput m_flow(
    quantity="MassFlowRate",
    unit="kg/s")
    "Air mass flow rate flowing through the DX Coil at given instant"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput TIn(
    quantity="Temperature",
    unit="K",
    displayUnit="degC") "Temperature of air entering the cooling coil 
    (Wet bulb for wet coil and drybulb for dry coil)"
    annotation (Placement(transformation(extent={{-120,-58},{-100,-38}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_small
    "Small mass flow rate in case of no-flow condition";
  parameter Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.Generic per
    "Performance data";
  parameter Real capFunT[:]=per.perCur.capFunT
    "Biquadratic coefficients for capFunT"
    annotation (Dialog(group="Curve coefficients"));
  parameter Real capFunFF[:]=per.perCur.capFunFF
    "Biquadratic coefficients for capFunFF"
    annotation (Dialog(group="Curve coefficients"));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(
    max=0)=per.nomVal.Q_flow_nominal
    "Nominal/rated total cooling capacity (negative number)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal= per.nomVal.m_flow_nominal
    "Nominal/rated air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Real EIRFunT[:]=per.perCur.EIRFunT
    "Biquadratic coefficients for EIRFunT"
    annotation (Dialog(group="Curve coefficients"));
  parameter Real EIRFunFF[:]=per.perCur.EIRFunFF
    "Biquadratic coefficients for EIRFunFF"
    annotation (Dialog(group="Curve coefficients"));
  parameter Real COP_nominal = per.nomVal.COP_nominal
    "Nominal/rated coefficient of performance"
    annotation (Dialog(group="Nominal condition"));
  output Real ff( min=0)
    "Air flow fraction: ratio of actual air flow rate by rated mass flwo rate";
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    max=0,
    unit="W") "Total cooling capacity"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput EIR "Energy Input Ratio"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
//----------------------------Performance curves---------------------------------//
//------------------------------Cooling capacity---------------------------------//
  output Real cap_T(min=0, nominal=1, start=1)
    "Cooling capacity modification factor as function of temperature";
  output Real cap_FF(min=0, nominal=1, start=1)
    "Cooling capacity modification factor as function of flow fraction";
//----------------------------Energy Input Ratio---------------------------------//
  output Real EIR_T(min=0, nominal=1, start=1)
    "EIR modification factor as function of temperature";
  output Real EIR_FF(min=0, nominal=1, start=1)
    "EIR modification factor as function of flow fraction";
protected
  Real cap_FF_below(min=0, nominal=1, start=1)
    "Cooling capacity modification factor as function of flow fraction below minimum value of ff";
  Real cap_FF_valid(min=0, nominal=1, start=1)
    "Cooling capacity modification factor as function of flow fraction";
  Real heav( min=0, max=1, nominal=0.5, start=0.5)
    "Smooth Heaviside function value";
  Real heavUpLimit(min=0, max=1, nominal=0.8, start=0.8)
    "Heaviside function max value";
algorithm
  // fixme: deltaX must be scaled with nominal (or small) mass flow rate
  ff:=Buildings.Utilities.Math.Functions.smoothMax(
    x1=m_flow,
    x2=m_flow_small,
    deltaX=0.01)/m_flow_nominal;
  if on then
  //-------------------------Cooling capacity modifiers----------------------------//
    // Compute the DX coil capacity fractions, using a biquadratic curve.
    // Since the regression for capacity can have negative values
    // (for unreasonable temperatures),we constrain its return value to be
    // non-negative. This prevents the solver to pick the unrealistic solution.
    cap_T :=Buildings.Utilities.Math.Functions.smoothMax(
      x1=Buildings.Utilities.Math.Functions.biquadratic(
        a=capFunT,
        x1=Modelica.SIunits.Conversions.to_degC(TIn),
        x2=Modelica.SIunits.Conversions.to_degC(TConIn)),
      x2=0.00,
      deltaX=0.01)
      "Cooling capacity modification factor as function of temperature";
    cap_FF_valid :=Buildings.Utilities.Math.Functions.polynomial(x=ff, a=
      capFunFF) "Cooling capacity modification factor as function of flow fraction 
      in user specified (valid) range";
    heavUpLimit :=Buildings.Utilities.Math.Functions.polynomial(x=per.perCur.ffRanCap[
      1], a=capFunFF);
    heav :=Buildings.Utilities.Math.Functions.smoothHeaviside(x=ff - (per.perCur.ffRanCap[
      1])/2, delta=(per.perCur.ffRanCap[1])/2);
    cap_FF_below :=heavUpLimit*heav
      "Cooling capacity modification factor as function of flow fraction below minimum value of ff";
    cap_FF:=Buildings.Utilities.Math.Functions.spliceFunction(
      pos=cap_FF_valid,
      neg=cap_FF_below,
      x=ff - per.perCur.ffRanCap[1],
      deltax=0.01)
      "For smooth transition from heaviside function to user defined curvefit";
  //-----------------------Energy Input Ratio modifiers--------------------------//
    EIR_T :=Buildings.Utilities.Math.Functions.smoothMax(
      x1=Buildings.Utilities.Math.Functions.biquadratic(
        a=EIRFunT,
        x1=Modelica.SIunits.Conversions.to_degC(TIn),
        x2=Modelica.SIunits.Conversions.to_degC(TConIn)),
      x2=0.0,
      deltaX=0.01)
      "Cooling capacity modification factor as function of temperature";
    EIR_FF :=Buildings.Utilities.Math.Functions.polynomial(x=ff, a=EIRFunFF)
      "Cooling capacity modification factor as function of flow fraction";
  else //cooling coil off
   cap_T:=0;
   cap_FF:=0;
   EIR_T :=0;
   EIR_FF :=0;
   cap_FF_valid:=0;
   heavUpLimit:=0;
   heav:=0;
   cap_FF_below:=0;
  end if;
//    Q_flow :=Buildings.Utilities.Math.Functions.smoothMin(
//     x1=cap_T*cap_FF*Q_flow_nominal,
//     x2=0.0000001*Q_flow_nominal,
//     deltaX=0.01)
//     "To avoid zero divided by zero condition (in further calculations) at zero mass flow rate";
  Q_flow :=cap_T*cap_FF*Q_flow_nominal;
  EIR :=EIR_T*EIR_FF/COP_nominal;
   annotation (
    defaultComponentName="cooCap",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          textStyle={TextStyle.Italic},
          textString="f(T,m)")}),
          Documentation(info="<html>
<h4>
Cooling capacity modifiers
</h4>
<p>There are two cooling capacity modifier functions. 
One is a function of air temperatures, the other is a function of flow rate.</p>
<p>
The temperature dependent cooling capacity modifier is based on 
the time dependent variables <i>T<sub> In</sub></i> and <i>T<sub>c In</sub></i>. 
TIn is either the dry-bulb or wet-bulb temperature depending 
on dry or wet coil condition. It is calculated using the following biquadratic equation.
</p>
<p align=\"center\" style=\"font-style:italic;\" >

  cap<sub>T</sub> = a<sub> 1</sub> + b<sub> 1</sub> * T<sub> In</sub> 
+ c<sub> 1</sub> * T<sub> In</sub> <sup>2</sup> + d<sub> 1</sub> * T<sub>ConIn</sub> + 
e<sub> 1</sub> * T<sub>ConIn</sub> <sup>2</sup> + f<sub> 1</sub> * T<sub> In</sub> * T<sub>ConIn</sub>

</p>
<p>
The six coefficients of the equation are entered as an array in performance data record. 
The output of the function (i.e. temperature based cooling capacity modifier) 
is used to calculate operating cooling capacity at a specific entering air temperature 
by multiplying it with the rated cooling capacity. </p>
<p>
The flow fraction dependent cooling capacity modifier function is a quadratic (or cubic) 
equation with <i>ff</i> (flow fraction) as the time dependent variable.
</p>
<p align=\"center\" style=\"font-style:italic;\">
  cap<sub>FF</sub> = a'<sub> 1</sub> + b'<sub> 1</sub> * ff + c'<sub> 1</sub> ff <sup>2</sup> 
+ d'<sub> 1</sub> ff <sup>3</sup> 
</p>
<p>
where, 
<p align=\"center\" style=\"font-style:italic;\">
  ff = (Air mass flow rate / Nominal mass flow rate)
</p>
</p>
<p>
The coefficients of the equation are entered as array 
<i>[a'<sub> 1</sub> b'<sub> 1</sub> c'<sub> 1</sub> d'<sub> 1</sub>]</i>. <br>

It is important to specify limits of flow fraction to ensure validity of the cap<sub>FF</sub> function 
in performance record. A non-zero value of cap<sub>FF</sub> at 'ff = 0' will lead to unrealistic 
temperatures during no-flow conditions. When the result of the cap<sub>FF</sub> function 
is below the lower limit this block will use the smooth Heaviside function to 
connect the lower point of cap<sub>FF</sub> with the origin. <br>
cap<sub>FF</sub> is used to calculate operating cooling capacity at a specific  
air flow fraction by multiplying it with the rated total cooling capacity. 
</p>
<p>
These cooling capacity modifiers are then multiplied with nominal cooling capacity 
to get cooling capacity of the coil at a given inlet temperature and mass flow rate.
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Q<sub>flow</sub> = cap<sub> T </sub> * cap<sub> FF </sub> * Q <sub>flow nominal</sub>
</p>
<h4>Energy Input Ratio (EIR) modifiers</h4>
<p>
Energy Input Ratio (<i>EIR</i>) is the inverse of the Coefficient of Performance (<i>COP</i>).
The model uses two different modifying functions to account for variations in EIR 
with changes in inlet temperatures and flow rate.<br> 
The temperature dependant <i>EIR</i> modifier function is a biquadratic equation using 
<i>T<sub>In</sub></i> and <i>T<sub>cIn</sub></i> as time dependent variables. <br>
<i>T<sub>In</sub></i> is the inlet dry-bulb temperature 
when the coil is dry and inlet wet-bulb temperature when the coil is wet.</p>
<p align=\"center\" style=\"font-style:italic;\" >

  EIR<sub>T</sub>(T) = a<sub> 2</sub> + b<sub> 2</sub> * T<sub>In</sub> + 
c<sub> 2</sub> * T<sub>In</sub> <sup>2</sup> + d<sub> 2</sub> * T<sub>ConIn</sub> 
+ e<sub> 2</sub> * T<sub>ConIn</sub> <sup>2</sup> + f<sub> 2</sub> * T<sub>In</sub> * T<sub>ConIn</sub>

</p>
<p>
The six coefficients of the equation are entered as array. 
The output of the function (i.e. Temperature based EIR<sub>T</sub>) is used to calculate 
Energy Input Ratio at a specific entering air temperature by multiplying it with the rated EIR.
</p>
<p>
The flow fraction dependent <i>EIR</i> modifier function is a quadratic (or cubic) equation 
with <i>ff</i> (flow fraction) as the time dependent variable. 
</p>
<p align=\"center\" style=\"font-style:italic;\">
  EIR<sub>FF</sub>(ff) = a'<sub> 2</sub> + b'<sub> 2</sub> * ff 
+ c'<sub> 2</sub> ff <sup>2</sup> + d'<sub> 2</sub> ff <sup>3</sup> 
</p>
<p>
where, 
<p align=\"center\" style=\"font-style:italic;\">
  ff = (Air mass flow rate / Nominal mass flow rate)
</p>
Note: At zero air mass flow rate value of EIR_FF is not set to zero (unlike cap<sub>FF</sub>) because
at zero air mass flow rate, if the compressor of the unit is still running, it will consume electrical power.
</p>
<p>
The coefficients of the equation are entered as array 
<i>[a'<sub> 2</sub> b'<sub> 2</sub> c'<sub> 2</sub> d'<sub> 2</sub>]</i>. <br>
<i>EIR<sub> FF </sub></i> is used to calculate EIR at specific mass flow rate of air by multiplying it 
with the rated <i>EIR</i> .
</p>
<p>
Multiplication of <i>EIR</i> modifiers are then divided by nominal <i>COP</i> to get <i>EIR</i> 
of the coil at given air inlet temperatures and mass flow rate.
</p>
<p align=\"center\" style=\"font-style:italic;\">
  EIR = EIR<sub>T</sub> * EIR<sub>FF</sub> / COP<sub>nominal</sub>
</p>

<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0 Engineering Reference</a>, May 24, 2012.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 18, 2012 by Kaustubh Phalak:<br>
Combined cooling capacity and EIR modifier function together to avoid repeatation of same variable calculations.
Added heaviside function. 
</li>
<li>
April 20, 2012 by Michael Wetter:<br>
Added unit conversion directly to function calls to avoid doing
the conversion when the coil is switched off.
</li>
<li>
April 6, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"),
    Diagram(graphics));
end CoolingCapacity;
