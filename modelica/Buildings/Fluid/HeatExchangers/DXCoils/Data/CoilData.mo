within Buildings.Fluid.HeatExchangers.DXCoils.Data;
record CoilData "Performance record for DX Cooling Coil"
  extends Modelica.Icons.Record;
  parameter Integer nSta(min=1) "Number of stages"
    annotation (Evaluate = true,
                Dialog(enable = not sinStaOpe));
  parameter Real minSpeRat( min=0,max=1)=0.2 "Minimum speed ratio"
    annotation (Evaluate = true,
                Dialog(enable = not sinStaOpe));
  final parameter Boolean sinStaOpe = nSta == 1
    "The data record is used for single speed operation"
    annotation(Evaluate=true, HideResult=true);

  parameter Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.Generic
    per[nSta] "Data record for coil performance"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_small = 0.0001*per[1].nomVal.m_flow_nominal
    "Small mass flow rate for regularization near zero flow"
    annotation (Dialog(group="Minimum conditions"));
annotation (preferedView="info",
defaultComponentName="datCoi", Documentation(info="<html>
<p>
This record declares the performance data for the DX cooling coil model.
The performance data are structured as follows:
</p>
<p>
<pre>
  nSta      - Number of stages. Set to 1 for single speed coil, 
              2 for dual-speed (or dual stage coils), etc.
  minSpeRat - Minimum speed ratio, used only for variable speed coils.
  per       - Array of records with one performance curve for each stage.
</pre>
</p>
<p>
Each element of the array <code>per</code> has the following data.
</p>
<p>
<pre>
  spe       - Rotational speed for the respective stage.
              (This is only used for variable speed coils to interpolate for 
              intermediate speeds).
  nomVal    - Nominal performance values for the respective stage. Data of the
              nomVal record are
     Q_flow_nominal - Total rate of cooling at nominal conditions.
     COP_nominal    - Coefficient of performance at nominal conditions.
     SHR_nominal    - Sensible heat ratio at nominal conditions.

     m_flow_nominal - Evaporator air mass flow rate at nominal conditions.
     TIn_nominal    - Evaporator air inlet temperature at nominal conditions.
     phiIn_nominal  - Relative humidity at evaporator inlet at nominal conditions.
     p_nominal      - Atmospheric pressure at nominal conditions.
     
     tWet           - Time until moisture drips from coil when coil is switched on
     gamma          - Ratio of evaporation heat transfer divided by latent
                      heat transfer at nominal condition.

  per       - Array of records with one performance curve for the respective 
              stage of the coil. That is, the performance curves will be used
              in conjunction with the nominal values defined in the record spe.
     capFunT  - Coefficients of biquadratic polynomial for cooling capacity 
                as a function of temperature.
     capFunFF - Polynomial coefficients for cooling capacity 
                as a function of the mass flow fraction.
     EIRFunT  - Coefficients of biquadratic polynomial for EIR as a function of temperature.
     EIRFunFF - Polynomial coefficients for EIR
                as a function of the mass flow fraction.
     TConInRan - Minimum and maximum condenser air inlet temperatures 
                 for which the performance curves are valid.
                 Outside this range, they will be linearly extrapolated.
     TEvaInRan - Minimum and maximum evaporator air inlet temperatures 
                 for which the performance curves are valid.
                 Outside this range, they will be linearly extrapolated.
     ffRan     - Minimum and maximum air mass flow fraction (relative to m_flow_nominal)
                 for which the performance curves are valid.
                 Outside this range, they will be linearly extrapolated.      
</pre>
</p>
<p>
The parameters <code>tWet</code> and <code>gamma</code> characterize the amount of
moisture that evaporates from the coil surface into the air stream when the coil is 
wet and switched off. For an examplanation of the parameters, see
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Evaporation\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Evaporation</a>.
</p>
<p>
There can be an arbitrary number of polynomial coefficients for the record
<code>capFunFF</code> and <code>EIRFunFF</code>.
However, if a coil has multiple stages, then each stage must declare the
same amount of polynomial coefficients. For example, if a 
quadratic function is used for stage one, then stage two must also use 
a quadratic function.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 25, 2012 by Michael Wetter:<br>
Added documentation.
</li>
<li>
July 23, 2012 by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"));
end CoilData;
