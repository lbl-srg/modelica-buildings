within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial block PartialCoilCapacity
  "Calculates performance curve value at given temperature and mass flow rate"
  extends Modelica.Blocks.Icons.Block;

  constant Boolean use_mCon_flow
    "Set to true to enable connector for the condenser mass flow rate";

  Modelica.Blocks.Interfaces.IntegerInput stage(final min=0)
    "Stage of coil, or 0/1 for variable-speed coil"
    annotation (Placement(transformation(extent={{-124,88},{-100,112}}),
        iconTransformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput TConIn(
    quantity="ThermodynamicTemperature",
    unit="K",
    displayUnit="degC") "Temperature of air entering the condenser coil "
     annotation (Placement(transformation(extent={{-120,38},{-100,58}})));
  Modelica.Blocks.Interfaces.RealInput m_flow(
    quantity="MassFlowRate",
    unit="kg/s") "Air mass flow rate at the evaporator"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput TEvaIn(
    quantity="ThermodynamicTemperature",
    unit="K",
    displayUnit="degC")
    "Temperature of air entering the evaporator (wet bulb for wet coil and dry bulb for dry coil)"
    annotation (Placement(transformation(extent={{-120,-58},{-100,-38}})));
  Modelica.Blocks.Interfaces.RealInput mCon_flow(
    quantity="MassFlowRate",
    unit="kg/s") if use_mCon_flow "Water mass flow rate at the condenser"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));

  parameter Integer nSta(min=1)
    "Number of coil stages (not counting the off stage)"
    annotation(Evaluate=true);

  replaceable parameter
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage sta[nSta]
     constrainedby
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage
     "Performance data for this stage";
  output Real[nSta] ff(each min=0)
    "Air flow fraction: ratio of actual air flow rate by rated mass flow rate";

  Modelica.Blocks.Interfaces.RealOutput Q_flow[nSta](
    each max=0,
    each unit="W") "Total cooling capacity"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Modelica.Blocks.Interfaces.RealOutput EIR[nSta](each min=0)
    "Energy Input Ratio"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));

//------------------------------Cooling capacity---------------------------------//
  Real cap_T[nSta](each min=0, each nominal=1, each start=1)
    "Cooling capacity modification factor as a function of temperature";
  Real cap_FF[nSta](each min=0, each nominal=1, each start=1)
    "Cooling capacity modification factor as a function of flow fraction";

//----------------------------Energy Input Ratio---------------------------------//
  Real EIR_T[nSta](each min=0, each nominal=1, each start=1)
    "EIR modification factor as a function of temperature";
  Real EIR_FF[nSta](each min=0, each nominal=1, each start=1)
    "EIR modification factor as a function of flow fraction";
  Real corFac[nSta](each min=0, each max=1, each nominal=1, each start=1)
    "Correction factor that is one inside the valid flow fraction, and attains zero below the valid flow fraction";

protected
  final parameter Modelica.Units.SI.MassFlowRate m_flow_small=1E-4*sta[nSta].nomVal.m_flow_nominal
    "Small mass flow rate for regularization";

  Boolean checkBoundsTEva[nSta]
    "Flag, used to check for out of bounds data";
  Boolean checkBoundsTCon[nSta]
    "Flag, used to check for out of bounds data";

initial algorithm
  // Verify correctness of performance curves, and write warning if error is bigger than 10%
   for iSta in 1:nSta loop
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.warnIfPerformanceOutOfBounds(
      Buildings.Utilities.Math.Functions.biquadratic(
        a=sta[iSta].perCur.capFunT,
        x1=Modelica.Units.Conversions.to_degC(sta[iSta].nomVal.TEvaIn_nominal),
        x2=Modelica.Units.Conversions.to_degC(sta[iSta].nomVal.TConIn_nominal)),
      msg="Capacity as a function of temperature ",
      curveName="sta[" + String(iSta) + "].perCur.capFunT");

     Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.warnIfPerformanceOutOfBounds(
       Buildings.Fluid.Utilities.extendedPolynomial(
         x=1,
         c=sta[iSta].perCur.capFunFF,
         xMin=sta[iSta].perCur.ffMin,
         xMax=sta[iSta].perCur.ffMax),
         msg="Capacity as a function of normalized mass flow rate ",
         curveName="sta[" + String(iSta) + "].perCur.capFunFF");

    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.warnIfPerformanceOutOfBounds(
      Buildings.Utilities.Math.Functions.biquadratic(
        a=sta[iSta].perCur.EIRFunT,
        x1=Modelica.Units.Conversions.to_degC(sta[iSta].nomVal.TEvaIn_nominal),
        x2=Modelica.Units.Conversions.to_degC(sta[iSta].nomVal.TConIn_nominal)),
      msg="EIR as a function of temperature ",
      curveName="sta[" + String(iSta) + "].perCur.EIRFunT");

    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.warnIfPerformanceOutOfBounds(
       Buildings.Fluid.Utilities.extendedPolynomial(
         x=1,
         c=sta[iSta].perCur.EIRFunFF,
         xMin=sta[iSta].perCur.ffMin,
         xMax=sta[iSta].perCur.ffMax),
         msg="EIR as a function of normalized mass flow rate ",
         curveName="sta[" + String(iSta) + "].perCur.EIRFunFF");
   end for;

  checkBoundsTEva := fill(true, nSta);
  checkBoundsTCon := fill(true, nSta);

equation
    // Modelica requires to evaluate the when() block for each element in iSta=1...nSta.
    // But we only want to check the stage that is currently running.
    // Hence, the test starts with stage == iSta.
    for iSta in 1:nSta loop
   // Check whether data are outside of bounds
      when ( stage == iSta and pre(checkBoundsTEva[stage])) then
      assert(
        not (TEvaIn > sta[stage].perCur.TEvaInMax or TEvaIn < sta[stage].perCur.TEvaInMin),
        "*** Warning: Evaporator temperature TEvaIn is out of bounds in DX coil model at time = "
           + String(time) + ".
    stage     = " + String(iSta) + "
    TEvaInMin = " + String(sta[iSta].perCur.TEvaInMin) + " Kelvin (" + String(
          Modelica.Units.Conversions.to_degC(sta[iSta].perCur.TEvaInMin)) + " degC)
    TEvaIn    = " + String(TEvaIn) + " Kelvin (" + String(
          Modelica.Units.Conversions.to_degC(TEvaIn)) + " degC)
    TEvaInMax = " + String(sta[iSta].perCur.TEvaInMax) + " Kelvin (" + String(
          Modelica.Units.Conversions.to_degC(sta[iSta].perCur.TEvaInMax)) + " degC)
    Extrapolation can introduce large errors.
    This warning will only be reported once for each stage.",
        level=AssertionLevel.warning);
        checkBoundsTEva[iSta] = false;
      end when;
      when ( stage == iSta and pre(checkBoundsTCon[stage])) then
      assert(
        not (TConIn > sta[stage].perCur.TConInMax or TConIn < sta[stage].perCur.TConInMin),
        "*** Warning: Condenser temperature TConIn is out of bounds in DX coil model at time = "
           + String(time) + ".
    stage     = " + String(iSta) + "
    TConInMin = " + String(sta[iSta].perCur.TConInMin) + " Kelvin (" + String(
          Modelica.Units.Conversions.to_degC(sta[iSta].perCur.TConInMin)) + " degC)
    TConIn    = " + String(TConIn) + " Kelvin (" + String(
          Modelica.Units.Conversions.to_degC(TConIn)) + " degC)
    TConInMax = " + String(sta[iSta].perCur.TConInMax) + " Kelvin (" + String(
          Modelica.Units.Conversions.to_degC(sta[iSta].perCur.TConInMax)) + " degC)
    Extrapolation can introduce large errors.
    This warning will only be reported once for each stage.",
        level=AssertionLevel.warning);
        checkBoundsTCon[iSta] = false;
      end when;
    end for;

if stage > 0 then
    for iSta in 1:nSta loop

    // Compute performance
    ff[iSta]=Buildings.Utilities.Math.Functions.smoothMax(
      x1=m_flow,
      x2=m_flow_small,
      deltaX=m_flow_small/10)/sta[iSta].nomVal.m_flow_nominal;
  //-------------------------Cooling capacity modifiers----------------------------//
    // Compute the DX coil capacity fractions, using a biquadratic curve.
    // Since the regression for capacity can have negative values
    // (for unreasonable temperatures), we constrain its return value to be
    // non-negative.
    cap_T[iSta] =Buildings.Utilities.Math.Functions.smoothMax(
        x1=Buildings.Utilities.Math.Functions.biquadratic(
          a=sta[iSta].perCur.capFunT,
          x1=Modelica.Units.Conversions.to_degC(TEvaIn),
          x2=Modelica.Units.Conversions.to_degC(TConIn)),
        x2=0.001,
        deltaX=0.0001)
        "Cooling capacity modification factor as function of temperature";
    cap_FF[iSta] = Buildings.Fluid.Utilities.extendedPolynomial(
      x=ff[iSta],
      c=sta[iSta].perCur.capFunFF,
      xMin=sta[iSta].perCur.ffMin,
      xMax=sta[iSta].perCur.ffMax);
    //-----------------------Energy Input Ratio modifiers--------------------------//
    EIR_T[iSta] =Buildings.Utilities.Math.Functions.smoothMax(
        x1=Buildings.Utilities.Math.Functions.biquadratic(
          a=sta[iSta].perCur.EIRFunT,
          x1=Modelica.Units.Conversions.to_degC(TEvaIn),
          x2=Modelica.Units.Conversions.to_degC(TConIn)),
        x2=0.001,
        deltaX=0.0001);
    EIR_FF[iSta] = Buildings.Fluid.Utilities.extendedPolynomial(
       x=ff[iSta],
       c=sta[iSta].perCur.EIRFunFF,
       xMin=sta[iSta].perCur.ffMin,
       xMax=sta[iSta].perCur.ffMax)
        "Cooling capacity modification factor as function of flow fraction";
    //------------ Correction factor for flow rate outside of validity of data ---//
    corFac[iSta] =Buildings.Utilities.Math.Functions.smoothHeaviside(
       x=ff[iSta] - sta[iSta].perCur.ffMin/4,
       delta=max(Modelica.Constants.eps, sta[iSta].perCur.ffMin/8));

    end for;
  else //cooling coil off
   ff     = fill(0, nSta);
   cap_T  = fill(0, nSta);
   cap_FF = fill(0, nSta);
   EIR_T  = fill(0, nSta);
   EIR_FF = fill(0, nSta);
   corFac = fill(0, nSta);
  end if;
   annotation (
    defaultComponentName="cooCap",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={
        Text(
          extent={{-100,100},{100,-100}},
          textColor={0,0,255},
          textStyle={TextStyle.Italic},
          textString="f(T,m)")}),
          Documentation(info="<html>
<h4>Cooling capacity modifiers</h4>
<p>
There are two cooling capacity modifier functions: The function
<i>cap<sub>&theta;</sub></i> accounts for a performance change due to different temperatures at the condenser and evaporator and the function
cap<sub>FF </sub> accounts for a performance change due to different air flow rates at the evaporator,
relative to the nominal condition.
These cooling capacity modifiers are multiplied with nominal cooling capacity
to obtain the cooling capacity of the coil at given inlet temperatures and mass flow rate.
See<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilCapacityAirSource\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilCapacityAirSource</a>.
<p>
The temperature dependent cooling capacity modifier function is</p>
<p align=\"center\" style=\"font-style:italic;\" >
  cap<sub>&theta;</sub>(&theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>) = a<sub>1</sub> + a<sub>2</sub> &theta;<sub>e,in</sub>
+ a<sub>3</sub> &theta;<sub>e,in</sub> <sup>2</sup> + a<sub>4</sub> &theta;<sub>c,in</sub> +
a<sub>5</sub> &theta;<sub>c,in</sub> <sup>2</sup> + a<sub>6</sub> &theta;<sub>e,in</sub> &theta;<sub>c,in</sub>,
</p>
<p>
where the six coefficients are obtained from the coil performance data record.
</p>
<p>
The flow fraction dependent cooling capacity modifier function is a polynomial
with the normalized mass flow rate <i>ff</i> (flow fraction) at the evaporator as the time dependent variable.
The normalized mass flow rate is defined as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  ff = m&#775; &frasl;  m&#775;<sub>nom</sub>,
</p>
<p>
where
<i>m&#775;</i> is the mass flow rate at the evaporator and
<i>m&#775;<sub>nom</sub></i> is the nominal mass flow rate.
If the coil has multiple stages, then the nominal mass flow rate of the respective stage is used.
Hence,
</p>
<p align=\"center\" style=\"font-style:italic;\">
  cap<sub>FF</sub>(ff) = b<sub>1</sub> + b<sub>2</sub> ff + b<sub>3</sub> ff<sup>2</sup>
+ b<sub>4</sub>ff<sup>3</sup> + ...
</p>
<p>
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

<h4>Energy Input Ratio (EIR) modifiers</h4>
<p>
The Energy Input Ratio (<i>EIR</i>) is the inverse of the Coefficient of Performance (<i>COP</i>).
Similar to the cooling rate, the EIR of the coil is the product of a function
that takes into account changes in condenser and evaporator inlet temperatures,
and changes in mass flow rate.
</p>
<p>
As for the cooling rate,
<i>EIR<sub>&theta;</sub>(&sdot;, &sdot;)</i> is
</p>
<p align=\"center\" style=\"font-style:italic;\">
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
</p>
<p align=\"center\" style=\"font-style:italic;\">
  EIR<sub>FF</sub>(ff) = d<sub>1</sub> + d<sub>2</sub> ff + d<sub>3</sub> ff<sup>2</sup>
+ d<sub>4</sub>ff<sup>3</sup> + ...
</p>
<h4>Obtaining the polynomial coefficients</h4>
<p>
The package
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Examples.PerformanceCurves\">
Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Examples.PerformanceCurves</a>
contains performance curves.
Alternatively, users can enter their own performance curves by
making an instance of a curve in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Examples.PerformanceCurves\">
Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Examples.PerformanceCurves</a>
and specifying custom coefficients for the above polynomials.
The polynomial coefficients can be obtained by doing a curve fit that fits the
polynomials to a set of data.
The site
<a href=\"http://www.scipy.org/Cookbook/FittingData\">
http://www.scipy.org/Cookbook/FittingData</a>
shows examples for how to fit data.
If a coil has multiple stages, then the fit need to be done for each stage.
For variable frequency coils, multiple fits need to be done for user selected
compressor speeds. For intermediate speeds, the performance data will be interpolated
by the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.VariableSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.VariableSpeed</a>.
</p>
<p>
The table below shows the polynomials explained above,
the name of the polynomial coefficients in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Examples.PerformanceCurves\">
Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Examples.PerformanceCurves</a>
and the independent parameters against which the data need to be fitted.
</p>
  <table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr>
      <th>Modelica name of coefficient in data record</th>
      <th>Polynomial of the above info section</th>
       <th>Parameters for curve fit</th>
    </tr>
    <tr>
      <td><code>capFunT</code></td>
      <td><i>
        cap<sub>&theta;</sub>(&theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>) = a<sub>1</sub> + a<sub>2</sub> &theta;<sub>e,in</sub>
+ a<sub>3</sub> &theta;<sub>e,in</sub> <sup>2</sup> + a<sub>4</sub> &theta;<sub>c,in</sub> +
a<sub>5</sub> &theta;<sub>c,in</sub> <sup>2</sup> + a<sub>6</sub> &theta;<sub>e,in</sub> &theta;<sub>c,in</sub>
        </i></td>
        <td><i>
        cap<sub>&theta;</sub>, &theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>
        </i></td>
    </tr>
    <tr>
      <td><code>capFunFF</code></td>
      <td><i>
        cap<sub>FF</sub>(ff) = b<sub>1</sub> + b<sub>2</sub> ff + b<sub>3</sub> ff<sup>2</sup>
        + b<sub>4</sub>ff<sup>3</sup> + ...
        </i></td>
        <td><i>
        cap<sub>FF</sub>, ff
        </i></td>
    </tr>
    <tr>
      <td><code>EIRFunT</code></td>
      <td><i>
        EIR<sub>&theta;</sub>(&theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>) = a<sub>1</sub> + a<sub>2</sub> &theta;<sub>e,in</sub>
+ a<sub>3</sub> &theta;<sub>e,in</sub> <sup>2</sup> + a<sub>4</sub> &theta;<sub>c,in</sub> +
a<sub>5</sub> &theta;<sub>c,in</sub> <sup>2</sup> + a<sub>6</sub> &theta;<sub>e,in</sub> &theta;<sub>c,in</sub>
        </i></td>
        <td><i>
        EIR<sub>&theta;</sub>, &theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>
        </i></td>
    </tr>
    <tr>
      <td><code>EIRFunFF</code></td>
      <td><i>
        EIR<sub>FF</sub>(ff) = b<sub>1</sub> + b<sub>2</sub> ff + b<sub>3</sub> ff<sup>2</sup>
        + b<sub>4</sub>ff<sup>3</sup> + ...
        </i></td>
        <td><i>
        EIR<sub>FF</sub>, ff
        </i></td>
    </tr>
  </table>

<p>
Note that for the above polynomials, the units for temperature is degree Celsius and not Kelvins.
</p>
<h4>Implementation</h4>
<p>
A parameter of the performance curve is the range of mass flow fraction <i>ff</i> for
which the data are valid.
Below this range, this model reduces the cooling capacity and the energy input ratio
so that both are zero if <i>ff &lt; ff<sub>min</sub>/4</i>, where
<i>ff<sub>min</sub></i> is the minimum flow fraction for which the performance curves are valid.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 5, 2023, by Xing Lu:<br/>
Changed class name from <code>PartialCoolingCapacity</code> to
<code>PartialCoilCapacity</code>.
</li>
<li>
November 8, 2022, by Michael Wetter:<br/>
Corrected calculation of performance which used the wrong upper bound.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/3146\">issue 3146</a>.
</li>
<li>
October 21, 2019, by Michael Wetter:<br/>
Ensured that transition interval for computation of <code>corFac</code> is non-zero.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1202\">issue 1202</a>.
</li>
<li>
February 27, 2017 by Yangyang Fu:<br/>
Revised the documentation.
</li>
<li>
December 18, 2012 by Michael Wetter:<br/>
Added warning if the evaporator or condenser inlet temperature of the current stage
cross the minimum and maximum allowed values.
</li>
<li>
September 20, 2012 by Michael Wetter:<br/>
Revised model and documentation.
</li>
<li>
May 18, 2012 by Kaustubh Phalak:<br/>
Combined cooling capacity and EIR modifier function together to avoid repeatation of same variable calculations.
Added heaviside function.
</li>
<li>
April 20, 2012 by Michael Wetter:<br/>
Added unit conversion directly to function calls to avoid doing
the conversion when the coil is switched off.
</li>
<li>
April 6, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"));
end PartialCoilCapacity;
