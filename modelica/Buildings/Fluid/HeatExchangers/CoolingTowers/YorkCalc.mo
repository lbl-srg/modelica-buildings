within Buildings.Fluid.HeatExchangers.CoolingTowers;
model YorkCalc
  "Cooling tower with variable speed using the York calculation for the approach temperature"
  extends Fluid.Interfaces.PartialStaticTwoPortHeatMassTransfer(sensibleOnly=true,
  final show_T = true);
  extends Buildings.BaseClasses.BaseIcon;

  parameter Modelica.SIunits.Temperature TAirInWB_nominal = 273.15+25.55
    "Design inlet air wet bulb temperature"
      annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.TemperatureDifference TApp_nominal(displayUnit="K") = 3.89
    "Design approach temperature"
      annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.TemperatureDifference TRan_nominal(displayUnit="K") = 5.56
    "Design range temperature (water in - water out)"
      annotation (Dialog(group="Nominal condition"));
  parameter Real fraPFan_nominal(unit="W/(kg/s)") = 275/0.15
    "Fan power divived by water mass flow rate at design condition";
  parameter Modelica.SIunits.Power PFan_nominal = fraPFan_nominal*m_flow_nominal
    "Fan power";
  replaceable function fanRelPow =
    Buildings.Fluid.Movers.BaseClasses.Characteristics.polynomialEfficiency (
       r_V_nominal = {0.1,   0.3,   0.6,   1},
       eta_nominal = {0.1^3, 0.3^3, 0.6^3, 1}) constrainedby
    Buildings.Fluid.Movers.BaseClasses.Characteristics.baseEfficiency
    "Fan relative power consumption as a function of control signal, fanParLoaEff=P(y)/P(y=1)"
    annotation(choicesAllMatching=true);
  parameter Real yMin(min=0.01, max=1) = 0.3
    "Minimum control signal until fan is switched off (used for smoothing between forced and free convection regime)";
  parameter Real fraFreCon(min=0, max=1) = 0.125
    "Fraction of tower capacity in free convection regime";

  Modelica.Blocks.Interfaces.RealInput TAir(min=0, unit="K")
    "Entering air wet bulb temperature"
     annotation (Placement(transformation(
          extent={{-140,20},{-100,60}}, rotation=0)));

  Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.BoundsYorkCalc bou
    "Bounds for correlation";
  Modelica.Blocks.Interfaces.RealInput y "Fan control signal"
     annotation (Placement(transformation(
          extent={{-140,60},{-100,100}}, rotation=0)));

  Modelica.SIunits.TemperatureDifference TAppAct(min=0, nominal=1, displayUnit="K")
    "Actual approach temperature";

  Modelica.SIunits.TemperatureDifference TRan(nominal=1, displayUnit="K")
    "Range temperature";
  Modelica.SIunits.MassFraction FRWat
    "Ratio actual over design water mass flow ratio";
  Modelica.SIunits.MassFraction FRAir
    "Ratio actual over design air mass flow ratio";
  Modelica.SIunits.Power PFan "Fan power";
protected
  parameter Modelica.SIunits.MassFraction FRWat0(min=0, start=1, fixed=false)
    "Ratio actual over design water mass flow ratio at nominal condition";
  parameter Modelica.SIunits.Temperature TWatIn0(fixed=false)
    "Water inlet temperature at nominal condition";
  parameter Modelica.SIunits.Temperature TWatOut_nominal(fixed=false)
    "Water outlet temperature at nominal condition";
  parameter Modelica.SIunits.MassFlowRate mRef_flow(min=0, start=m_flow_nominal, fixed=false)
    "Reference water flow rate";

  Modelica.SIunits.TemperatureDifference dTMax(nominal=1, displayUnit="K")
    "Maximum possible temperature difference";
  Modelica.SIunits.TemperatureDifference TAppCor(min=0, nominal=1, displayUnit="K")
    "Approach temperature for forced convection";
  Modelica.SIunits.TemperatureDifference TAppFreCon(min=0, nominal=1, displayUnit="K")
    "Approach temperature for free convection";
initial equation
  TWatOut_nominal = TAirInWB_nominal + TApp_nominal;
  TRan_nominal = TWatIn0 - TWatOut_nominal; // by definition of the range temp.
  TApp_nominal = Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.yorkCalc(
                   TRan=TRan_nominal, TWetBul=TAirInWB_nominal,
                   FRWat=FRWat0, FRAir=1); // this will be solved for FRWat0
  mRef_flow = m_flow_nominal/FRWat0;
  // Check validity of relative fan power consumption at y=yMin and y=1
  assert(fanRelPow(r_V=yMin)>-1E-4, "The fan relative power consumption must be negative for y=0."
  + "\n   Obtained fanRelPow(0) = " + realString(fanRelPow(r_V=yMin))
  + "\n   You need to choose a different function for fanRelPow.");
  assert(abs(1-fanRelPow(r_V=1))<1E-4, "The fan relative power consumption must be one for y=1."
  + "\n   Obtained fanRelPow(1) = " + realString(fanRelPow(r_V=1))
  + "\n   You need to choose a different function for fanRelPow."
  + "\n   To increase the fan power, change fraPFan_nominal or PFan_nominal.");
equation
  // Range temperature
  TRan = Medium.temperature(sta_a) - Medium.temperature(sta_b);
  // Fractional mass flow rates
  FRWat = m_flow/mRef_flow;
  FRAir = y;

  TAppCor = Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.yorkCalc(
               TRan=TRan, TWetBul=TAir,
               FRWat=FRWat, FRAir=max(FRWat/bou.liqGasRat_max, FRAir));
  dTMax = Medium.temperature(sta_a) - TAir;
  TAppFreCon = (1-fraFreCon) * dTMax  + fraFreCon *
               Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.yorkCalc(
                   TRan=TRan, TWetBul=TAir, FRWat=FRWat, FRAir=1);

  // Actual approach temperature and fan power consumption,
  // which depends on forced vs. free convection.
  // The transition is for y in [yMin-yMin/10, yMin]
  [TAppAct, PFan] = Buildings.Utilities.Math.Functions.spliceFunction(
                                                 pos=[TAppCor, fanRelPow(r_V=y) * PFan_nominal],
                                                 neg=[TAppFreCon, 0],
                                                 x=y-yMin+yMin/20,
                                                 deltax=yMin/20);
  Medium.temperature(sta_b) = TAppAct + TAir;

  // No mass added or remomved from water stream
  mXi_flow     = zeros(Medium.nXi);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          extent={{-102,110},{-68,72}},
          lineColor={0,0,127},
          textString="yFan"),
        Rectangle(
          extent={{-100,82},{-70,78}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,86},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-104,70},{-70,32}},
          lineColor={0,0,127},
          textString="TWB"),
        Rectangle(
          extent={{-100,41},{-70,38}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,5},{101,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-56,12},{56,-108}},
          lineColor={255,255,255},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          textString="York")}),
                          Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}),
                                  graphics),
    Documentation(info="<html>
<p>
Model for a steady state cooling tower with variable speed fan using the York calculation for the
approach temperature at off-design conditions.
</p>
<h4>Thermal performance</h4>
<p>
To compute the thermal performance, this model takes as parameters 
the approach temperature, the range temperature and the inlet air wet bulb temperature 
at the design condition. Since the design mass flow rate (of the chiller condenser loop)
is also a parameter, these parameters define the rejected heat.<br/>
For off-design conditions, the model uses the actual range temperature and a polynomial 
to compute the approach temperature for free convection and for forced convection, i.e.,
with the fan operating. The polynomial is valid for a York cooling tower.
If the fan input signal <code>y</code> is below the minimum fan revolution <code>yMin</code>,
then the cooling tower operates in free convection mode, otherwise it operates in
the forced convection mode.
For numerical reasons, this transition occurs in the range of <code>y &isin; [0.9*yMin, yMin]</code>.
</p>
<h4>Fan power consumption</h4>
<p>
The fan power consumption at the design condition can be specified as follows:
<ul>
<li>
The parameter <code>fraPFan_nominal</code> can be used to specify at the 
nominal conditions the fan power divided by the water flow rate. The default value is 
<i>275</i> Watts for a water flow rate of <i>0.15</i> kg/s. 
</i>
<li>
The parameter <code>PFan_nominal</code> can be set to the fan power at nominal conditions.
If a user does not set this parameter, then the fan power will be
<code>PFan_nominal = fraPFan_nominal * m_flow_nominal</code>, where <code>m_flow_nominal</code>
is the nominal water flow rate.
</li>
</ul>
</p>
<p>
In the forced convection mode, the actual fan power is 
computed as <code>PFan=fanRelPow(y) * PFan_nominal</code>, where
the default value for the fan relative power consumption at part load is
<code>fanRelPow(y)=y^3</code>.
In the free convection mode, the fan power consumption is zero.
For numerical reasons, the transition of fan power from the part load mode
to zero power consumption in the free convection mode occurs in the range 
<code>y &isin; [0.9*yMin, yMin]</code>.
<br/>
To change the function for fan relative power consumption at part load in the forced convection mode, 
tuples of fan control signal and relative power consumption can be specified.
</p>
<h4>Comparison the the cooling tower model of EnergyPlus</h4>
<p> 
This model is similar to the model <oode>Cooling Tower:Variable Speed</code> that
is implemented in the EnergyPlus building energy simulation program version 6.0.
The main differences are
<ol>
<li>
Not implemented are the basin heater power consumption, and
the make-up water usage.
</li>
<li>
The model has no built-in control to switch individual cells of the tower on or off.
To switch cells on or off, use multiple instances of this model, and use your own
control law to compute the input signal <code>y</code>.
</p>
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 2.0.0 Engineering Reference</a>, April 9, 2007.
</p>
</html>", revisions="<html>
<ul>
<li>
March 8, 2011, by Michael Wetter:<br>
Removed base class and unused variables.
</li>
<li>
February 25, 2011, by Michael Wetter:<br>
Revised implementation to facilitate scaling the model to different nominal sizes.
Removed parameter <code>mWat_flow_nominal</code> since it is equal to <code>m_flow_nominal</code>,
which is the water flow rate from the chiller condenser loop.
</li>
<li>
May 16, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end YorkCalc;
