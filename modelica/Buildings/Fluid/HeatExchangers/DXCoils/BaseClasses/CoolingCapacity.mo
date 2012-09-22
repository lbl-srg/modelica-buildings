within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block CoolingCapacity
  "Calculates cooling capacity at given temperature and flow fraction"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  //Performance curve variables
  Modelica.Blocks.Interfaces.IntegerInput stage
    "Stage of coil, or 0/1 for variable-speed coil"
    annotation (Placement(transformation(extent={{-124,88},{-100,112}}),
        iconTransformation(extent={{-120,90},{-100,110}})));
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
  Modelica.Blocks.Interfaces.RealInput TEvaIn(
    quantity="Temperature",
    unit="K",
    displayUnit="degC")
    "Temperature of air entering the evaporator coil  (Wet bulb for wet coil and drybulb for dry coil)"
    annotation (Placement(transformation(extent={{-120,-58},{-100,-38}})));
  parameter Integer nSta(min=1)
    "Number of coil stages (not counting the off stage)"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate m_flow_small
    "Small mass flow rate for regularization";
  parameter Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.Generic per[nSta]
    "Performance data";
  output Real[nSta] ff(each min=0)
    "Air flow fraction: ratio of actual air flow rate by rated mass flwo rate";
  Modelica.Blocks.Interfaces.RealOutput Q_flow[nSta](
    each max=0,
    each unit="W") "Total cooling capacity"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput EIR[nSta] "Energy Input Ratio"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
//----------------------------Performance curves---------------------------------//
//------------------------------Cooling capacity---------------------------------//
  output Real cap_T[nSta](each min=0, each nominal=1, each start=1)
    "Cooling capacity modification factor as function of temperature";
  output Real cap_FF[nSta](each min=0, each nominal=1, each start=1)
    "Cooling capacity modification factor as function of flow fraction";
//----------------------------Energy Input Ratio---------------------------------//
  output Real EIR_T[nSta](each min=0, each nominal=1, each start=1)
    "EIR modification factor as function of temperature";
  output Real EIR_FF[nSta](each min=0, each nominal=1, each start=1)
    "EIR modification factor as function of flow fraction";
protected
  Real cap_FF_below[nSta](each min=0, each nominal=1, each start=1)
    "Cooling capacity modification factor as function of flow fraction below minimum value of ff";
  Real cap_FF_valid[nSta](each min=0, each nominal=1, each start=1)
    "Cooling capacity modification factor as function of flow fraction";
  Real heav[nSta](each min=0, each max=1, each nominal=0.5, each start=0.5)
    "Smooth Heaviside function value";
  parameter Real heavUpLimit[nSta](
     each min=0, each max=1)=
       {Buildings.Utilities.Math.Functions.polynomial(
       x=per[iSta].perCur.ffRanCap[1],
       a=per[iSta].perCur.capFunFF) for iSta in 1:nSta}
    "Heaviside function max value";
algorithm
  if stage > 0 then
    for iSta in 1:nSta loop
    ff[iSta]:=Buildings.Utilities.Math.Functions.smoothMax(
      x1=m_flow,
      x2=m_flow_small,
      deltaX=m_flow_small/10)/per[iSta].nomVal.m_flow_nominal;
  //-------------------------Cooling capacity modifiers----------------------------//
    // Compute the DX coil capacity fractions, using a biquadratic curve.
    // Since the regression for capacity can have negative values
    // (for unreasonable temperatures), we constrain its return value to be
    // non-negative. This prevents the solver to pick the unrealistic solution.
    cap_T[iSta] :=Buildings.Utilities.Math.Functions.smoothMax(
      x1=Buildings.Utilities.Math.Functions.biquadratic(
        a=per[iSta].perCur.capFunT,
        x1=Modelica.SIunits.Conversions.to_degC(TEvaIn),
        x2=Modelica.SIunits.Conversions.to_degC(TConIn)),
      x2=0.00,
      deltaX=0.01)
        "Fixme: this can be negative. Cooling capacity modification factor as function of temperature";
    cap_FF_valid[iSta] :=Buildings.Utilities.Math.Functions.polynomial(
      x=ff[iSta],
      a=per[iSta].perCur.capFunFF) "Cooling capacity modification factor as function of flow fraction 
      in user specified (valid) range";
    heav[iSta] :=Buildings.Utilities.Math.Functions.smoothHeaviside(
       x=ff[iSta] - (per[iSta].perCur.ffRanCap[1])/2,
       delta=(per[iSta].perCur.ffRanCap[1])/2);
    cap_FF_below[iSta] :=heavUpLimit[iSta]*heav[iSta] "Cooling capacity modification factor as function of 
      flow fraction below minimum value of ff";
    cap_FF[iSta]:=Buildings.Utilities.Math.Functions.spliceFunction(
      pos=cap_FF_valid[iSta],
      neg=cap_FF_below[iSta],
      x=ff[iSta] - per[iSta].perCur.ffRanCap[1],
      deltax=0.01)
        "For smooth transition from heaviside function to user defined curvefit";
  //-----------------------Energy Input Ratio modifiers--------------------------//
    EIR_T[iSta] :=Buildings.Utilities.Math.Functions.smoothMax(
      x1=Buildings.Utilities.Math.Functions.biquadratic(
        a=per[iSta].perCur.EIRFunT,
        x1=Modelica.SIunits.Conversions.to_degC(TEvaIn),
        x2=Modelica.SIunits.Conversions.to_degC(TConIn)),
      x2=0.0,
      deltaX=0.01)
        "fixme: this can attain negative values. Cooling capacity modification factor as function of temperature";
    EIR_FF[iSta] :=Buildings.Utilities.Math.Functions.polynomial(
       x=ff[iSta],
       a=per[iSta].perCur.EIRFunFF)
        "Cooling capacity modification factor as function of flow fraction";
    Q_flow[iSta] := cap_T[iSta]*cap_FF[iSta]*per[iSta].nomVal.Q_flow_nominal;
    EIR[iSta]    := EIR_T[iSta]*EIR_FF[iSta]/per[iSta].nomVal.COP_nominal;
    end for;
  else //cooling coil off
   ff    :=        fill(0, nSta);
   cap_T :=        fill(0, nSta);
   cap_FF :=       fill(0, nSta);
   EIR_T :=        fill(0, nSta);
   EIR_FF :=       fill(0, nSta);
   cap_FF_valid := fill(0, nSta);
   heav :=         fill(0, nSta);
   cap_FF_below := fill(0, nSta);
   Q_flow :=       fill(0, nSta);
   EIR :=          fill(0, nSta);
  end if;
   annotation (
    defaultComponentName="cooCap",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={
        Text(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          textStyle={TextStyle.Italic},
          textString="f(T,m)")}),
          Documentation(info="<html>
<h4>
Cooling capacity modifiers
</h4>
<p>There are two cooling capacity modifier functions: The function
<i>cap<sub>&theta;</sub></i> accounts for a performance change due to different
air temperatures and the function
cap<sub>FF </sub> accounts for a performance change due to different air flow rates,
relative to the nominal condition.
These cooling capacity modifiers are multiplied with nominal cooling capacity 
to obtain the cooling capacity of the coil at given inlet temperatures and mass flow rate as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Q&#775;(&theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>, ff) = cap<sub>&theta;</sub>(&theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>)
            cap<sub>FF</sub>(ff) Q&#775;<sub>nom</sub>,
</p>
<p>
where
<i>&theta;<sub>e,in</sub></i> is the evaporator inlet temperature and 
<i>&theta;<sub>c,in</sub></i> is the condenser inlet temperature in degrees Celsius.
<i>&theta;<sub>e,in</sub></i> is the dry-bulb temperature if the coil is dry, 
or the wet-bulb temperature if the coil is wet.
</p>
<p>
The temperature dependent cooling capacity modifier function is
<p align=\"center\" style=\"font-style:italic;\" >
  cap<sub>&theta;</sub>(&theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>) = a<sub>1</sub> + a<sub>2</sub> &theta;<sub>e,in</sub> 
+ a<sub>3</sub> &theta;<sub>e,in</sub> <sup>2</sup> + a<sub>4</sub> &theta;<sub>c,in</sub> + 
a<sub>5</sub> &theta;<sub>c,in</sub> <sup>2</sup> + a<sub>6</sub> &theta;<sub>e,in</sub> &theta;<sub>c,in</sub>,
</p>
<p>
where the six coefficients are obtained from the coil performance data record.
<p>
The flow fraction dependent cooling capacity modifier function is a polynomial 
with the normalized mass flow rate <i>ff</i> (flow fraction) as the time dependent variable.
The normalized mass flow rate is defined as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  ff = m&#775; &frasl;  m&#775;<sub>nom</sub>,
</p>
<p>
where 
<i>m&#775;</i> is the mass flow rate and
<i>m&#775;<sub>nom</sub></i> is the nominal mass flow rate.
If the coil has multiple stages, then the nominal mass flow rate of the respective stage is used.
Hence,
</p>
<p align=\"center\" style=\"font-style:italic;\">
  cap<sub>FF</sub>(ff) = b<sub>1</sub> + b<sub>2</sub> ff + b<sub>3</sub> ff<sup>2</sup> 
+ b<sub>4</sub>ff<sup>3</sup> + ...
</p>
The coefficients of the equation are obtained from the coil performance data record.
</p>
<p>
It is important to specify limits of the flow fraction to ensure validity of the 
<i>cap<sub>FF</sub>(&sdot;)</i> function 
in performance record. A non-zero value of 
<i>cap<sub>FF</sub>(0)</i> will lead to an infinite large change in fluid temperatures because
<i>Q&#775; &ne; 0</i> but 
<i>m&#775; = 0</i>.
Hence, when <i>m&#775; &ne; 0</i> is below the valid range of the flow modifier function,
the coil capacity will be reduced and set to zero near <i>m&#775; = 0</i>.
</p>
<p>
<h4>Energy Input Ratio (EIR) modifiers</h4>
<p>
The Energy Input Ratio (<i>EIR</i>) is the inverse of the Coefficient of Performance (<i>COP</i>).
Similar to the cooling rate, the EIR of the coil is the product of a function
that takes into account changes in condenser and evaporator inlet temperatures,
and changes in mass flow rate.
The EIR is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  EIR(&theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>, ff) = EIR<sub>&theta;</sub>(&theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>)
           EIR<sub>FF</sub>(ff) &frasl; COP<sub>nominal</sub>
</p>
As for the cooling rate, 
<i>EIR<sub>&theta;</sub>(&sdot;, &sdot;)</i> is
<p align=\"center\" style=\"font-style:italic;\" >
  EIR<sub>&theta;</sub>(&theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>) = c<sub>1</sub> + c<sub>2</sub> &theta;<sub>e,in</sub> 
+ c<sub>3</sub> &theta;<sub>e,in</sub> <sup>2</sup> + c<sub>4</sub> &theta;<sub>c,in</sub> + 
c<sub>5</sub> &theta;<sub>c,in</sub> <sup>2</sup> + c<sub>6</sub> &theta;<sub>e,in</sub> &theta;<sub>c,in</sub>.
</p>
<p>
where the six coefficients are obtained from the coil performance data record, and
<i>&theta;<sub>e,in</sub></i> is the dry-bulb temperature if the coil is dry, or
the wet-bulb temperature otherwise.
</p>
<p>
Similar to the cooling ratio, the change in EIR due to a change in air mass flow rate
is 
<p align=\"center\" style=\"font-style:italic;\">
  EIR<sub>FF</sub>(ff) = d<sub>1</sub> + d<sub>2</sub> ff + d<sub>3</sub> ff<sup>2</sup> 
+ d<sub>4</sub>ff<sup>3</sup> + ...
</p>
<p>
Note that at zero air mass flow rate, the function 
<i>EIR<sub>FF</sub>(&sdot;)</i>
does not need to attain zero because if the compressor is still running, it will consume electrical power.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 19, 2012 by Michael Wetter:<br>
Revised documentation.
</li>
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
