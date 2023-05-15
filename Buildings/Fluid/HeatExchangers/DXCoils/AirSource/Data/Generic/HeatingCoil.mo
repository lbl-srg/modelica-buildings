within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic;
record HeatingCoil
  "Performance record for a DX Heating Coil with one or multiple stages"
  extends Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.CoilHeatTransfer(
    final is_cooCoi=false);

  parameter Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation
    defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation.resistive
    "Defrost operation type";

  parameter Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostTimeMethods
    defTri=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostTimeMethods.timed
    "Type of method used to calculate defrost time fraction";

  parameter Real tDefRun(
    final unit="1",
    displayUnit="1")=0.166
    "Time period fraction for which defrost cycle is run"
    annotation(Dialog(enable = defTri==Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostTimeMethods.timed));

  parameter Modelica.Units.SI.ThermodynamicTemperature TDefLim=273.65
    "Maximum temperature at which defrost operation is activated";

  parameter Modelica.Units.SI.HeatFlowRate QDefResCap(min=0)
    "Heating capacity of resistive defrost element"
    annotation(Dialog(enable = defOpe==Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation.resistive));

  parameter Modelica.Units.SI.HeatFlowRate QCraCap(min=0)
    "Crankcase heater capacity";
//-----------------------------Performance curves-----------------------------//
  parameter Real defEIRFunT[6] = fill(0,6)
    "Biquadratic coefficients for defrost capacity function of temperature"
    annotation (Dialog(enable = defOpe==Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation.reverseCycle));

  parameter Real PLFraFunPLR[:] = {1}
    "Quadratic/cubic equation for part load fraction as a function of part-load ratio";

annotation (preferredView="info",
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>
This record declares the performance data for the air source DX heating coil model.
The performance data are structured as follows:
</p>
<p>
It consists of the following fields:
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
  spe    - Rotational speed for the respective stage.
           (This is only used for variable speed coils to interpolate for 
           intermediate speeds).
  nomVal - Nominal performance values for the respective stage. Data of the
           nomVal record are:<br/>
    Q_flow_nominal - Total rate of heat transfer at nominal conditions.
    COP_nominal    - Coefficient of performance at nominal conditions.
    m_flow_nominal - Evaporator air mass flow rate at nominal conditions.
    TEvaIn_nominal - Evaporator air inlet wet-bulb temperature at nominal conditions.
    TConIn_nominal - Condenser air inlet temperature at nominal conditions
                     (for evaporative coils, use wet bulb, otherwise use dry bulb
                     temperature).
    phiIn_nominal  - Relative humidity at evaporator inlet at nominal conditions.
    p_nominal      - Atmospheric pressure at nominal conditions.
    per            - Array of records with one performance curve for the respective
                     stage of the coil. That is, the performance curves will be used
                     in conjunction with the nominal values defined in the record <code>spe</code>:<br/>
                     
      capFunT   - Coefficients of biquadratic polynomial for heating capacity
                  as a function of temperature.
      capFunFF  - Polynomial coefficients for heating capacity as a function of 
                  the mass flow fraction.
      EIRFunT   - Coefficients of biquadratic polynomial for EIR as a function 
                  of temperature.
      EIRFunFF  - Polynomial coefficients for EIR as a function of the mass flow
                  fraction.
      TConInRan - Minimum and maximum condenser air inlet temperatures for which 
                  the performance curves are valid.
                  Outside this range, they will be linearly extrapolated.
      TEvaInRan - Minimum and maximum evaporator air inlet temperatures for which 
                  the performance curves are valid.
                  Outside this range, they will be linearly extrapolated.
      ffRan     - Minimum and maximum air mass flow fraction (relative to m_flow_nominal)
                  for which the performance curves are valid.
                  Outside this range, they will be linearly extrapolated.
                  </pre>
<p>
There can be an arbitrary number of polynomial coefficients for the record
<code>capFunFF</code> and <code>EIRFunFF</code>.
However, if a coil has multiple stages, then each stage must declare the
same amount of polynomial coefficients. For example, if a
quadratic function is used for stage one, then stage two must also use
a quadratic function.
</p>
<p>
It also contains settings and performance curves for defrost operation and overall 
performance modifiers:
</p>
<pre>
  defEIRFunT  - Coefficients of biquadratic polynomial for EIR for defrost as a 
                function of temperature.
  PLFraFunPLR - Coefficients of polynomial for part-load fraction as a function
                of part-load ratio.
  defOpe      - Defrost operation type.
  QDefResCap  - Capacity of heating element on outdoor coil (used for resistive defrost).  
  QCraCap     - Capacity of crankcase heater.
  defTri      - Defrost time fraction calculation method.
  tDefRun     - Fraction of time for which defrost is run if timed fraction calculation is used.
  TDefLim     - Maximum temperature at which the defrost operation may be run.
</pre>
</html>",
revisions="<html>
<ul>
<li>
March 31, 2023 by Karthik Devaprasad and Xing Lu:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatingCoil;
