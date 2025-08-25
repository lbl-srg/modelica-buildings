within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
block TableData2DLoadDep
  "Calculation of capacity, heat flow rate and power based on load-dependent 2D table data"
   extends Modelica.Blocks.Icons.Block;

  type TypeOfSystem = Integer(final min = 1, final max = 3)
  annotation(choices(
    choice = 1 "Chiller",
    choice = 2 "Heat recovery chiller with built-in switchover",
    choice = 3 "Heat pump"));
  parameter TypeOfSystem typ
    annotation(Evaluate=true);
  parameter Boolean use_TLoaLvgForCtl=true
    "Set to true for leaving temperature control, false for entering temperature control"
    annotation (Evaluate=true);
  parameter Boolean use_TEvaOutForTab
    "=true to use evaporator outlet temperature for table data, false for inlet";
  parameter Boolean use_TConOutForTab
    "=true to use condenser outlet temperature for table data, false for inlet";
  parameter Real scaFac(unit="1")=1
    "Scaling factor for interpolated heat flow rate and power";
  parameter Modelica.Units.SI.DimensionlessRatio PLRSup[:](each final min=0)
    "PLR values at which heat flow rate and power data are provided";
  final parameter Modelica.Units.SI.DimensionlessRatio PLRUnl_min=min(PLRSup)
    "Minimum PLR before false loading the compressor";
  parameter Modelica.Units.SI.DimensionlessRatio PLRCyc_min(
    final max=PLRUnl_min,
    final min=0)=min(PLRSup)
    "Minimum PLR before cycling off the last compressor";
  parameter Modelica.Units.SI.Power P_min(final min=0)=0
    "Minimum power when system is enabled with compressor cycled off";
  final parameter Integer nPLR=size(PLRSup, 1)
    "Number of PLR support points"
    annotation (Evaluate=true);
  parameter String fileName
    "File where performance data are stored"
    annotation (Dialog(loadSelector(filter=
      "Text files (*.txt);;MATLAB MAT-files (*.mat)",caption=
      "Open file in which table is present")));
  final parameter Modelica.Blocks.Types.Smoothness smoothness=
    Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation";
  final parameter Modelica.Blocks.Types.Extrapolation extrapolation=
    Modelica.Blocks.Types.Extrapolation.HoldLastPoint
    "Extrapolation of data outside the definition range";
  parameter String tabNamQ[nPLR]={"q@" + String(p,
    format=".2f") for p in PLRSor}
    "Table names with heat flow rate data"
    annotation (Evaluate=true,
    Dialog(tab="Advanced"));
  parameter String tabNamP[nPLR]={"p@" + String(p,
    format=".2f") for p in PLRSor}
    "Table names with power data"
    annotation (Evaluate=true,
    Dialog(tab="Advanced"));
  parameter Modelica.Units.SI.Temperature TLoa_nominal
    "Load side fluid temperature — Entering or leaving depending on use_T*OutForTab"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TAmb_nominal
    "Ambient side fluid temperature — Entering or leaving depending on use_T*OutForTab"
    annotation (Dialog(group="Nominal condition"));
  // OMC and OCT require getTable2DValueNoDer2() to be called in initial equation section.
  // Binding equations yield incorrect results but no error!
  final parameter Modelica.Units.SI.Power PInt_nominal[nPLR](each fixed=false)
    "Power interpolated at nominal conditions, at each PLR – Unscaled";
  final parameter Modelica.Units.SI.HeatFlowRate QInt_flow_nominal[nPLR](each fixed=false)
    "Heat flow rate interpolated at nominal conditions, at each PLR – Unscaled";
  final parameter Modelica.Units.SI.Power P_nominal=
    Modelica.Math.Vectors.interpolate(PLRSor, PInt_nominal, 1)
    "Power interpolated at nominal conditions, at PLR=1 – Unscaled";
  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=
    Modelica.Math.Vectors.interpolate(PLRSor, QInt_flow_nominal, 1)
    "Heat flow rate interpolated at nominal conditions, at PLR=1 – Unscaled";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput coo if typ==2
    "Switchover signal: true for cooling, false for heating"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TLoaEnt(
    final unit="K",
    displayUnit="degC")
    "Entering fluid temperature on load side"
    annotation (Placement(transformation(extent={{-140,-48},{-100,-8}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAmbEnt(
    final unit="K",
    displayUnit="degC") "Entering fluid temperature on ambient side"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K",
    displayUnit="degC")
    "Temperature setpoint"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TLoaLvg(
    final unit="K",
    displayUnit="degC")
    "Leaving fluid temperature on load side"
    annotation (Placement(transformation(extent={{-140,-68},{-100,-28}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mLoa_flow(
    final unit="kg/s")
    "Fluid mass flow rate on load side"
    annotation (Placement(transformation(extent={{-140,-88},{-100,-48}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(
    final unit="W")
    "Input power"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PLR(
    final unit="1")
    "Compressor part load ratio to meet the load (within capacity)"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow(
    final unit="J/s")
    "Heat flow rate"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAmbLvg(
    final unit="K",
    displayUnit="degC") "Leaving fluid temperature on ambient side"
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yMea(
    final unit="1")
    "Capacity limiting signal yielded by internal safety logic"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cpLoa(
    final unit="J/(kg.K)")
    "Specific heat capacity of fluid on load side"
    annotation (Placement(transformation(extent={{-140,-108},{-100,-68}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
protected
  final parameter Real PLRSor[nPLR]=Modelica.Math.Vectors.sort(PLRSup)
    "PLR values in increasing order";
  final parameter Real PLRSorWith0[nPLR + 1]=cat(1, {0}, PLRSor)
    "PLR values in increasing order";
  final parameter Real PLR_max=PLRSor[nPLR]
    "Maximum PLR";
  final parameter Modelica.Blocks.Types.ExternalCombiTable2D tabQ[nPLR]=
    Modelica.Blocks.Types.ExternalCombiTable2D(
      tableName=tabNamQ,
      fileName=fill(fileName, nPLR),
      table=fill(fill(0.0, 1, 2), nPLR),
      smoothness=fill(smoothness, nPLR),
      extrapolation=fill(extrapolation, nPLR),
      verboseRead=fill(false, nPLR))
    "External table objects for heat flow interpolation";
  final parameter Modelica.Blocks.Types.ExternalCombiTable2D tabP[nPLR]=
    Modelica.Blocks.Types.ExternalCombiTable2D(
      tableName=tabNamP,
      fileName=fill(fileName, nPLR),
      table=fill(fill(0.0, 1, 2), nPLR),
      smoothness=fill(smoothness, nPLR),
      extrapolation=fill(extrapolation, nPLR),
      verboseRead=fill(false, nPLR))
    "External table objects for power interpolation";
  Modelica.Units.SI.HeatFlowRate QSet_flow
    "Cooling or heating load";
  Modelica.Units.SI.HeatFlowRate QSwiSet_flow(
    start=0,
    final min=0)
    "Heating load – Used for HRC in heating mode";
  Modelica.Units.SI.HeatFlowRate QInt_flow[nPLR]
    "Capacity at PLR support points";
  Modelica.Units.SI.Power PInt[nPLR]
    "Input power at PLR support points";
  Real PLR1(
    start=0,
    final min=0,
    final max=PLR_max)
    "Machine part load ratio";
  // For HRC the same data table is used for both cooling and heating,
  // and the block is necessarily used with chiller data.
  // So the first interpolation variable TLoaTab is always the evaporator temperature,
  // which is either TLoa(Ent|Lvg) or TAmb(Ent|Lvg) depending on the operating mode.
  Modelica.Units.SI.Temperature TLoaTab=if typ==2 then (if coo_internal then
    (if use_TEvaOutForTab then TLoaLvg else TLoaEnt)
    else (if use_TEvaOutForTab then TAmbLvg else TAmbEnt))
    elseif typ==1 then (if use_TEvaOutForTab then TLoaLvg else TLoaEnt)
    else (if use_TConOutForTab then TLoaLvg else TLoaEnt)
    "Fluid temperature on load side used for table data interpolation";
  Modelica.Units.SI.Temperature TAmbTab=if typ == 2 then (if coo_internal then (
    if use_TConOutForTab then TAmbLvg else TAmbEnt) else (if
    use_TConOutForTab then TLoaLvg else TLoaEnt)) elseif typ == 1 then (if
    use_TConOutForTab then TAmbLvg else TAmbEnt) else (if use_TEvaOutForTab
     then TAmbLvg else TAmbEnt)
    "Fluid temperature on ambient side used for table data interpolation";
  Modelica.Units.SI.Temperature TLoaCtl=if use_TLoaLvgForCtl then TLoaEnt else TLoaLvg
    "Fluid temperature used for load calculation (Delta-T with setpoint)";
  Real sigLoa=if use_TLoaLvgForCtl then 1 else - 1
    "Sign of Delta-T used for load calculation";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput coo_internal;
initial equation
  PInt_nominal = Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
    tabP, fill(TLoa_nominal, nPLR), fill(TAmb_nominal, nPLR));
  QInt_flow_nominal = Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
    tabQ, fill(TLoa_nominal, nPLR), fill(TAmb_nominal, nPLR));
equation
  if typ==2 then
    connect(coo, coo_internal);
  else
    if typ==1 then
      coo_internal=true;
    else
      coo_internal=false;
    end if;
  end if;
  if on then
    QSet_flow=if typ==2 and (not coo_internal) then P - QSwiSet_flow
    elseif typ==1 or typ==2 and coo_internal then
      min(0, sigLoa *(TSet - TLoaCtl) * cpLoa * mLoa_flow)
    else max(0, sigLoa *(TSet - TLoaCtl) * cpLoa * mLoa_flow);
    QSwiSet_flow=if typ==2 and (not coo_internal) then
      max(0, sigLoa *(TSet - TLoaCtl) * cpLoa * mLoa_flow)
      else 0;
    QInt_flow=scaFac * Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
      tabQ, fill(TLoaTab, nPLR), fill(TAmbTab, nPLR));
    PLR1=min(PLR_max, Modelica.Math.Vectors.interpolate(
      abs(cat(1, {0}, QInt_flow)),
      cat(1, {0}, PLRSor),
      abs(QSet_flow)));
    PLR=if PLR1 < PLRUnl_min and PLR1 > PLRCyc_min then PLRUnl_min else PLR1;
    // Actual input and output accounting for equipement internal safeties
    Q_flow=Modelica.Math.Vectors.interpolate(
      cat(1, {0}, PLRSor),
      cat(1, {0}, QInt_flow),
      yMea);
    PInt=scaFac * Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
      tabP, fill(TLoaTab, nPLR), fill(TAmbTab, nPLR));
    P=if PLRCyc_min < PLRSor[1] then
      Modelica.Math.Vectors.interpolate(
        cat(1, {0, PLRCyc_min}, PLRSor),
        cat(1, {P_min, PInt[1]}, PInt),
        yMea) else
      Modelica.Math.Vectors.interpolate(
        cat(1, {0}, PLRSor),
        cat(1, {P_min}, PInt),
        yMea);
  else
    QSet_flow=0;
    QSwiSet_flow=0;
    QInt_flow=fill(0, nPLR);
    PLR1=0;
    PLR=0;
    Q_flow=0;
    PInt=fill(0, nPLR);
    P=0;
  end if;
  annotation (
    Documentation(
      info="<html>
<p>
This block implements two core features for some chiller and heat pump models
within <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible\">
Buildings.Fluid.HeatPumps.ModularReversible</a> and
<a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible\">
Buildings.Fluid.Chillers.ModularReversible</a>.
</p>
<ul>
<li>
<b>Ideal controls</b>: The heating or cooling load is calculated based on the block
inputs. The block returns the required part load ratio <code>PLR</code>
to meet the load, within system capacity.<sup>1</sup>
</li>
<li>
<b>Capacity and power calculation</b>: The capacity and power are interpolated
from user-provided data along the load side fluid temperature,
the ambient side fluid temperature
and the part load ratio <code>yMea</code> provided as input.<sup>2</sup>
</li>
</ul>
<p>
<sup>1</sup> The part load ratio is defined as the ratio of the actual heating
(or cooling) heat flow rate to the maximum capacity of the heat pump (or chiller)
at the given load-side and ambient-side fluid temperatures.
It is dimensionless and bounded by <code>0</code> and <code>max(PLRSup)</code>, where
the upper bound is typically equal to <code>1</code> (unless there are some
capacity margins at design conditions that need to be accounted for).
In this block, the part load ratio is used as a proxy variable
for the actual capacity modulation observable.
For systems with VFDs, this is the compressor speed.
For systems with on/off compressors, this is the capacity of the enabled
compressors divided by the total capacity.
When meeting the load by cycling on and off a single compressor,
this is the time fraction the compressor is enabled.
In all cases, the algorithm assumes continuous operation and only approximates
the performance on a time average.
Finally, note that while the part load ratio is used for generalization purposes,
either the part load ratio or the actual capacity modulation observable
(e.g., the normalized compressor speed) may be used to map the performance data.
The only requirement is that this variable be normalized, as the algorithm assumes
it equals <code>1</code> at design (selection) conditions.
</p>
<p>
<sup>2</sup> The reason why the part load ratio is both calculated (<code>PLR</code>)
and exposed as an input (<code>yMea</code>) is to allow for modeling internal safeties
that can limit operation.
If no safeties are modeled, a direct feedback of <code>PLR</code> to
<code>yMea</code> can be used.
</p>
<h4>Capacity and power calculation</h4>
<p>
When the machine is enabled (input signal <code>on</code> is true)
the capacity and power are calculated by partitioning the PLR values
into three domains, as illustrated in Figure&nbsp;1.
</p>
<ol>
<li><b>Normal capacity modulation</b><br>
This domain corresponds to the capacity range where the machine adapts to the
load without false loading or cycling on and off the last operating compressor.
Depending on the technology, this is achieved for example by modulating
the compressor speed, throttling the inlet guide vanes
or staging a varying number of compressors.
In this domain, both the machine PLR and the compressor PLR vary.
The capacity and power are linearly interpolated
based on the performance data provided in an external file, which
syntax is specified in the following section.
The interpolation is carried out along three variables: the
load-side fluid temperature, the ambient-side fluid temperature
and the part load ratio.
Note that no extrapolation is performed.
The capacity and power are limited by the minimum or maximum values
provided in the performance data file.
</li>
<li><b>Compressor false loading</b><br>
This domain corresponds to the capacity range where the machine adapts to the
load by false loading the compressor.
For a chiller, this is achieved by bypassing hot gas directly to the evaporator.
In this domain, the machine PLR varies while the compressor PLR stays
roughly the same.
The input power is considered equal to the interpolated value at
<code>TLoa</code>, <code>TAmb</code>, <code>min(PLRSup)</code>.
This domain may not exist if the parameter <code>PLRCyc_min</code> is
equal to <code>min(PLRSup)</code>, which is the default setting.
</li>
<li><b>Last operating compressor cycling</b><br>
This domain corresponds to the capacity range where the last
operating compressor cycles on and off.
In this domain, the capacity is linearly interpolated between
<code>0</code> and the value at <code>TLoa</code>, <code>TAmb</code>, <code>min(PLRSup)</code>,
while the power is linearly interpolated between
<code>P_min</code> and the value at <code>TLoa</code>, <code>TAmb</code>,
<code>min(PLRSup)</code>, where <code>P_min</code> corresponds
to the remaining power when the machine is enabled and all compressors are disabled.
</li>
</ol>
<p>
<img src=\"modelica://Buildings/Resources/Images/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/TableData2DLoadDep.png\"
border=\"1\" alt=\"Input power as a function of the part load ratio.\"/>
</p>
<p><i>Figure 1. Input power as a function of the part load ratio.</i></p>
<h4>Performance data file</h4>
<p>
The performance data are read from an external ASCII file that must meet
the requirements specified in the documentation of
<a href=\"modelica://Modelica.Blocks.Tables.CombiTable2Ds\">
Modelica.Blocks.Tables.CombiTable2Ds</a>.
</p>
<p>
In addition, this file must contain at least two 2D-tables that provide the maximum
heating (resp. minimum cooling) heat flow rate and the input power
of the heat pump (resp. chiller) at <i>100&nbsp;&percnt;</i>
PLR.
Each row of these tables corresponds to a value of the load-side
fluid temperature, each column corresponds to a value of the
ambient-side fluid temperature.
This could be either the leaving temperature if <code>use_T*OutForTab</code>
is true, or the entering temperature if <code>use_T*OutForTab</code>
is false.
The load and ambient temperatures must cover the whole operating domain,
knowing that the model only performs interpolation and no extrapolation
of the capacity and power along these variables.
</p>
<p>
The table providing the capacity values must be named <code>q@X.XX</code>
where <code>X.XX</code> is the PLR value formatted with exactly
2 decimal places (<code>\"%.2f\"</code>).
Similarly, the table providing the power values must be named
<code>p@X.XX</code>.
</p>
<p>
Here is an example of chiller data (\"-----\" is not part of the file content):
</p>
<blockquote><pre>
-----------------------------------------------------
#1
double q@1.00(5,5)                    # Cooling heat flow rate at 100 % PLR
0 292.0 297.4 302.8 308.2             # CW temperatures as column headers
280.4 -493241 -555900 -495611 -312372 # Each row provides the capacity at a given CHW temperature
282.2 -470560 -578165 -562822 -424529
284.1 -418413 -573462 -605561 -514711
285.9 -342290 -542284 -619329 -573426
double p@1.00(5, 5)                   # Input power at 100 % PLR
0 292.0 297.4 302.8 308.2             # CW temperatures as column headers
280.4 60430 80413 80830 55530         # Each row provides the input power at a given CHW temperature
282.2 54399 80278 89151 73950
284.1 45251 76017 92822 87633
285.9 34546 68567 91833 95401
-----------------------------------------------------
</pre></blockquote>
<p>
In addition, for machines that have capacity modulation other than
cycling on and off a single compressor, the whole range of <b>normal
capacity modulation</b> must be covered by providing similar 2D-tables
at different PLR values.
The lowest PLR value will be considered as the minimum PLR value
before false loading the compressor.
If the machine has no hot gas bypass (<code>PLRCyc_min = min(PLRSup)</code>)
this will correspond to the minimum PLR value before cycling the
last operating compressor.
</p>
<p>
All the PLR values used in the performance data file must be specified
in the array parameter <code>PLRSup[:]</code>.
</p>
<h4>Compressor cycling</h4>
<p>
Compressor cycling is not explicitly modeled.
Instead, the model assumes continuous operation from <code>0</code> to <code>max(PLRSup)</code>.
The only effect of cycling taken into account is the impact of the remaining power
<code>P_min</code> when the machine is enabled and the last operating
compressor is cycled off.
Studies on chillers and heat pumps show that this is the main driver of
efficiency loss due to cycling (Rivière, 2004).
When a compressor is staged on, energy losses occur due to the overcoming of the
refrigerant pressure equalization and the heat exchanger temperature conditioning.
However, a large part of these losses is recovered when staging off the compressor,
unless the machine is disconnected from the load when compressors are disabled.
This disconnection does not happen when staging multiple compressors,
and the research shows no significant performance degradation when a
chiller cycles between different stages without completely shutting down.
And even when disabling the last operating compressor, most plant
controls require continuous operation of the primary pumps when
the chillers or heat pumps are enabled.
The European Standard for performance rating of chillers and heat pumps
at part load conditions (CEN, 2022) states that the performance degradation due to
the pressure equalization effect when the unit restarts can be considered
as negligible for hydronic systems.
The only effect that will impact the coefficient of performance
when cycling is the remaining power input when the compressor is switching off.
If this remaining power is not measured, the Standard prescribes a default
value of <i>10&nbsp;&percnt;</i> of the effective power input measured
during continuous operation at part load.
</p>
<h4>Heat recovery chillers</h4>
<p>
Heat recovery chillers can be modeled with this block.
In this case, the same chiller performance data file is used for
both cooling and heating operation.
The model assumes that all dissipated heat from the compressor
is recovered by the refrigerant. This assumption enables computing
the heating capacity as the sum of the cooling capacity and the input power.
</p>
<p>
When configured to represent a heat recovery chiller, this block uses an
additional input connector <code>coo</code> which must be true when
cooling mode is enabled, and false when heating mode is enabled.
The load side input variables must externally be connected to the
evaporator side variables in cooling mode, and to the condenser side
variables in heating mode.
The output connector <code>Q_flow</code> is always the
<i>cooling</i> heat flow rate, whatever the operating mode.
The heating heat flow rate in heating mode can be computed
externally as <code>P-Q_flow</code>.
</p>
<h4>Ideal controls</h4>
<p>
The block implements ideal controls by solving for the part load ratio
required to meet the load (more precisely the minimum between the load
and the actual capacity for the current load and ambient temperatures).
This is done by interpolating the PLR values along the heat flow rate values
for a given load.
</p>
<p>
The load is calculated based on the load side variables and the temperature
setpoint provided as inputs. The setpoint either represents a leaving (supply)
temperature setpoint if <code>use_TLoaLvgForCtl</code> is true (default setting)
or the entering (return) temperature if <code>use_TLoaLvgForCtl</code> is false.
</p>
<p>
The required PLR value is returned as an output while the actual heat flow rate
and power are calculated using the PLR value <code>yMea</code> provided as input,
which allows limiting the required PLR to account for equipment internal safeties.
</p>
<h4>References</h4>
<ul>
<li>
CEN, 2022. European Standard EN&nbsp;14825:2022&nbsp;E.
Air conditioners, liquid chilling packages and heat pumps,
with electrically driven compressors, for space heating and cooling,
commercial and process cooling - Testing and rating at part load conditions
and calculation of seasonal performance.
</li>
<li>Rivière, P. (2004). Performances saisonnières des groupes de production d’eau glaçée
[Seasonal performance of liquid chillers].
École Nationale Supérieure des Mines de Paris. [In French].
<a href=\"https://pastel.hal.science/pastel-00001483\">https://pastel.hal.science/pastel-00001483</a>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
March 21, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end TableData2DLoadDep;
