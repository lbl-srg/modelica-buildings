within Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic;
record Coil
  "Performance record for a DX Cooling Coil with one or multiple stages"
  extends Modelica.Icons.Record;

  final parameter Boolean sinStaOpe = nSta == 1
    "The data record is used for single speed operation"
    annotation(HideResult=true);

  parameter Integer nSta(
    final min=1)
    "Number of stages"
    annotation (Dialog(enable = not sinStaOpe));

  parameter Real minSpeRat(
    final min=0,
    final max=1)=0.2
    "Minimum speed ratio"
    annotation (Dialog(enable = not sinStaOpe));

  replaceable parameter
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage sta[nSta]
    "Data record for coil performance at each stage";

  parameter Modelica.Units.SI.MassFlowRate m_flow_small=0.0001*sta[nSta].nomVal.m_flow_nominal
    "Small mass flow rate for regularization near zero flow"
    annotation (Dialog(group="Minimum conditions"));

  /////////////////////////////////////////////////////////////////////////////////////
  // Data added for type compatibility, but not used for calculations in cooling coils
  final parameter Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostOperation
    defOpe=Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostOperation.resistive
    "Defrost operation type"
    annotation(HideResult=true);

  final parameter Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods
    defTri=Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.timed
    "Type of method used to calculate defrost time fraction"
    annotation(HideResult=true);

  final parameter Real tDefRun(
    final unit="1",
    displayUnit="1")=0
    "Time period fraction for which defrost cycle is run"
    annotation(HideResult=true);

  final parameter Modelica.Units.SI.ThermodynamicTemperature TDefLim=273.65
    "Maximum temperature at which defrost operation is activated"
    annotation(HideResult=true);

  final parameter Modelica.Units.SI.HeatFlowRate QDefResCap(min=0) = 0
    "Heating capacity of resistive defrost element"
    annotation(HideResult=true);

  final parameter Modelica.Units.SI.HeatFlowRate QCraCap(min=0) = 0
    "Crankcase heater capacity"
    annotation(HideResult=true);
//-----------------------------Performance curves-----------------------------//
  final parameter Real defEIRFunT[6] = fill(0,6)
    "Biquadratic coefficients for defrost capacity function of temperature"
    annotation(HideResult=true);

  final parameter Real PLFraFunPLR[:] = {1}
    "Quadratic/cubic equation for part load fraction as a function of part-load ratio"
    annotation(HideResult=true);
annotation (preferredView="info",
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>
This record declares the performance data for the air source DX cooling coil model.
The performance data are structured as follows:
</p>
<pre>
  nSta      - Number of stages. Set to 1 for single speed coil,
              2 for dual-speed (or dual stage coils), etc.
  minSpeRat - Minimum speed ratio, used only for variable speed coils.
  sta       - Array of records with one performance curve for each stage,
              as described below.
</pre>
<p>
Each element of the array <code>per</code> has the following data.
</p>
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
     TEvaIn_nominal    - Evaporator air inlet wet-bulb temperature at nominal conditions.
     TConIn_nominal    - Condenser air inlet temperature at nominal conditions
                         (for evaporative coils, use wet bulb, otherwise use dry bulb
                         temperature).
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
<p>
The data used to develop the performance curves
<code>capFunT</code> and
<code>EIRFunT</code> should represent performance when the
cooling coil is wet, i.e., the coil providing sensible cooling and at least some dehumidification.
Performance data when the cooling coil is dry
(i.e., not providing any dehumidification) should not be included when developing these modifier curves.
The DX coil model automatically detects and adjusts for dry coil conditions by evaluating
the performance curves for the wet bulb and dry bulb temperatures at the evaporator inlet,
and then selecting the corresponding performance.
The selection of the corresponding performance is described and implemented
in
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.DryWetSelector\">
Buildings.Fluid.DXSystems.Cooling.BaseClasses.DryWetSelector</a>.
</p>
<p>
The parameters <code>tWet</code> and <code>gamma</code> characterize the amount of
moisture that evaporates from the coil surface into the air stream when the coil is
wet and switched off. For an examplanation of the parameters, see
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.Evaporation\">
Buildings.Fluid.DXSystems.Cooling.BaseClasses.Evaporation</a>.
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
April 4, 2023, by Xing Lu and Karthik Devaprasad:<br/>
Updated record class name from <code>DXCoil</code> to <code>CoolingCoil</code>.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
September 25, 2012 by Michael Wetter:<br/>
Added documentation.
</li>
<li>
July 23, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end Coil;
