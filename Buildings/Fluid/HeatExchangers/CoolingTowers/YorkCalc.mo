within Buildings.Fluid.HeatExchangers.CoolingTowers;
model YorkCalc
  "Cooling tower with variable speed using the York calculation for the approach temperature"
  extends
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTowerVariableSpeed(
    TWatIn_nominal(fixed=false),
    TWatOut_nominal(fixed=false),
    fanRelPowDer(each fixed=false));

  parameter Modelica.Units.SI.TemperatureDifference TApp_nominal(displayUnit=
        "K") = 3.89 "Design approach temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.TemperatureDifference TRan_nominal(displayUnit=
        "K") = 5.56 "Design range temperature (water in - water out)"
    annotation (Dialog(group="Nominal condition"));

  Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.BoundsYorkCalc bou
    "Bounds for correlation";

  Modelica.Units.SI.TemperatureDifference TRan(displayUnit="K") = T_a - T_b
    "Range temperature";
  Modelica.Units.SI.TemperatureDifference TAppAct(displayUnit="K")=
    Buildings.Utilities.Math.Functions.spliceFunction(
    pos=TAppCor,
    neg=TAppFreCon,
    x=y - yMin + yMin/20,
    deltax=yMin/20) "Approach temperature difference";
  Modelica.Units.SI.MassFraction FRWat=m_flow/mWat_flow_nominal
    "Ratio actual over design water mass flow ratio";
  Modelica.Units.SI.MassFraction FRAir=y
    "Ratio actual over design air mass flow ratio";

protected
  package Water =  Buildings.Media.Water "Medium package for water";
  parameter Real FRWat0(min=0, start=1, fixed=false)
    "Ratio actual over design water mass flow ratio at nominal condition";
  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal(
    min=0,
    start=m_flow_nominal,
    fixed=false) "Nominal water mass flow rate";

  Modelica.Units.SI.TemperatureDifference dTMax(displayUnit="K") = T_a - TAir
    "Maximum possible temperature difference";
  Modelica.Units.SI.TemperatureDifference TAppCor(
    min=0,
    displayUnit="K")=
    Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.yorkCalc(
    TRan=TRan,
    TWetBul=TAir,
    FRWat=FRWat,
    FRAir=Buildings.Utilities.Math.Functions.smoothMax(
      x1=FRWat/bou.liqGasRat_max,
      x2=FRAir,
      deltaX=0.01)) "Approach temperature for forced convection";
  Modelica.Units.SI.TemperatureDifference TAppFreCon(
    min=0,
    displayUnit="K") = (1 - fraFreCon)*dTMax + fraFreCon*
    Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.yorkCalc(
    TRan=TRan,
    TWetBul=TAir,
    FRWat=FRWat,
    FRAir=1) "Approach temperature for free convection";

  Modelica.Units.SI.Temperature T_a "Temperature in port_a";
  Modelica.Units.SI.Temperature T_b "Temperature in port_b";

  Modelica.Blocks.Sources.RealExpression QWat_flow(
    y = m_flow*(
      Medium.specificEnthalpy(Medium.setState_pTX(
        p=port_b.p,
        T=TAir + TAppAct,
        X=inStream(port_b.Xi_outflow))) -
      inStream(port_a.h_outflow)))
    "Heat input into water"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
initial equation
  TWatOut_nominal = TAirInWB_nominal + TApp_nominal;
  TRan_nominal = TWatIn_nominal - TWatOut_nominal; // by definition of the range temp.
  TApp_nominal = Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.yorkCalc(
                   TRan=TRan_nominal, TWetBul=TAirInWB_nominal,
                   FRWat=FRWat0, FRAir=1); // this will be solved for FRWat0
  mWat_flow_nominal = m_flow_nominal/FRWat0;

  // Derivatives for spline that interpolates the fan relative power
  fanRelPowDer = Buildings.Utilities.Math.Functions.splineDerivatives(
            x=fanRelPow.r_V,
            y=fanRelPow.r_P,
            ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(x=fanRelPow.r_P,
                                                                              strict=false));

  // Check that a medium is used that has the same definition of enthalpy vs. temperature.
  // This is needed because below, T_a=Water.temperature needed to be hard-coded to use
  // Water.* instead of Medium.* in the function calls due to a bug in OpenModelica.
  assert(abs(Medium.specificEnthalpy_pTX(p=101325, T=273.15, X=Medium.X_default) -
             Water.specificEnthalpy_pTX(p=101325, T=273.15, X=Medium.X_default)) < 1E-5 and
         abs(Medium.specificEnthalpy_pTX(p=101325, T=293.15, X=Medium.X_default) -
             Water.specificEnthalpy_pTX(p=101325, T=293.15, X=Medium.X_default)) < 1E-5,
         "The selected medium has an enthalpy computation that is not consistent
  with the one in Buildings.Media.Water
  Use a different medium, such as Buildings.Media.Water.");
equation
  // States at the inlet and outlet

  if allowFlowReversal then
    if homotopyInitialization then
      T_a=Water.temperature(Water.setState_phX(p=port_a.p,
                                 h=homotopy(actual=actualStream(port_a.h_outflow),
                                            simplified=inStream(port_a.h_outflow)),
                                 X=homotopy(actual=actualStream(port_a.Xi_outflow),
                                            simplified=inStream(port_a.Xi_outflow))));
      T_b=Water.temperature(Water.setState_phX(p=port_b.p,
                                 h=homotopy(actual=actualStream(port_b.h_outflow),
                                            simplified=port_b.h_outflow),
                                 X=homotopy(actual=actualStream(port_b.Xi_outflow),
                                            simplified=port_b.Xi_outflow)));

    else
      T_a=Water.temperature(Water.setState_phX(p=port_a.p,
                                 h=actualStream(port_a.h_outflow),
                                 X=actualStream(port_a.Xi_outflow)));
      T_b=Water.temperature(Water.setState_phX(p=port_b.p,
                                 h=actualStream(port_b.h_outflow),
                                 X=actualStream(port_b.Xi_outflow)));
    end if; // homotopyInitialization

  else // reverse flow not allowed
    T_a=Water.temperature(Water.setState_phX(p=port_a.p,
                               h=inStream(port_a.h_outflow),
                               X=inStream(port_a.Xi_outflow)));
    T_b=Water.temperature(Water.setState_phX(p=port_b.p,
                               h=inStream(port_b.h_outflow),
                               X=inStream(port_b.Xi_outflow)));
  end if;

  connect(QWat_flow.y, preHea.Q_flow)
    annotation (Line(points={{-59,-60},{-40,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          extent={{-104,70},{-70,32}},
          textColor={0,0,127},
          textString="TWB"),
        Text(
          extent={{-50,4},{42,-110}},
          textColor={255,255,255},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          textString="York"),
        Rectangle(
          extent={{-100,81},{-70,78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{70,56},{82,52}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{78,54},{82,80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{64,114},{98,76}},
          textColor={0,0,127},
          textString="PFan"),
        Ellipse(
          extent={{0,62},{54,50}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-54,62},{0,50}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{78,82},{100,78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,100},{-86,84}},
          textColor={0,0,127},
          textString="y")}),
Documentation(info="<html>
<p>
Model for a steady-state or dynamic cooling tower with variable speed fan using the York calculation for the
approach temperature at off-design conditions.
</p>
<h4>Thermal performance</h4>
<p>
To compute the thermal performance, this model takes as parameters
the approach temperature, the range temperature and the inlet air wet bulb temperature
at the design condition. Since the design mass flow rate (of the chiller condenser loop)
is also a parameter, these parameters define the rejected heat.
</p>
<p>
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
</p>
<ul>
<li>
The parameter <code>fraPFan_nominal</code> can be used to specify at the
nominal conditions the fan power divided by the water flow rate. The default value is
<i>275</i> Watts for a water flow rate of <i>0.15</i> kg/s.
</li>
<li>
The parameter <code>PFan_nominal</code> can be set to the fan power at nominal conditions.
If a user does not set this parameter, then the fan power will be
<code>PFan_nominal = fraPFan_nominal * m_flow_nominal</code>, where <code>m_flow_nominal</code>
is the nominal water flow rate.
</li>
</ul>
<p>
In the forced convection mode, the actual fan power is
computed as <code>PFan=fanRelPow(y) * PFan_nominal</code>, where
the default value for the fan relative power consumption at part load is
<code>fanRelPow(y)=y<sup>3</sup></code>.
In the free convection mode, the fan power consumption is zero.
For numerical reasons, the transition of fan power from the part load mode
to zero power consumption in the free convection mode occurs in the range
<code>y &isin; [0.9*yMin, yMin]</code>.
<br/>
To change the fan relative power consumption at part load in the forced convection mode,
points of fan controls signal and associated relative power consumption can be specified.
In between these points, the values are interpolated using cubic splines.
</p>
<h4>Comparison the cooling tower model of EnergyPlus</h4>
<p>
This model is similar to the model <code>Cooling Tower:Variable Speed</code> that
is implemented in the EnergyPlus building energy simulation program version 6.0.
The main differences are
</p>
<ol>
<li>
Not implemented are the basin heater power consumption, and
the make-up water usage.
</li>
<li>
The model has no built-in control to switch individual cells of the tower on or off.
To switch cells on or off, use multiple instances of this model, and use your own
control law to compute the input signal <code>y</code>.
</li>
</ol>
<h4>Assumptions and limitations</h4>
<p>
This model requires a medium that has the same computation of the enthalpy as
<a href=\"modelica://Buildings.Media.Water\">
Buildings.Media.Water</a>,
which computes
</p>
<p align=\"center\" style=\"font-style:italic;\">
 h = c<sub>p</sub> (T-T<sub>0</sub>),
</p>
<p>
where
<i>h</i> is the enthalpy,
<i>c<sub>p</sub> = 4184</i> J/(kg K) is the specific heat capacity,
<i>T</i> is the temperature in Kelvin and
<i>T<sub>0</sub> = 273.15</i> Kelvin.
If this is not the case, the simulation will stop with an error message.
The reason for this limitation is that as of January 2015, OpenModelica
failed to translate the model if <code>Medium.temperature()</code> is used
instead of
<code>Water.temperature()</code>.
</p>
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 2.0.0 Engineering Reference</a>, April 9, 2007.
</p>
</html>", revisions="<html>
<ul>
<li>
August 26, 2021, by Baptiste Ravache:<br/>
Renamed parameter TWatIn0 to TWatIn_nominal.
</li>
<li>
January 16, 2020, by Michael Wetter:<br/>
Refactored model to avoid mixing textual equations and connect statements.
</li>
<li>
December, 22, 2019, by Kathryn Hinkelman:<br/>
Corrected fan power consumption.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1691\">
issue 1691</a>.
</li>
<li>
November 3, 2016, by Michael Wetter:<br/>
Corrected wrong type for <code>FRWat0</code>, as this variable
can take on values that are bigger than <i>1</i>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/567\">issue 567</a>.
</li>
<li>
January 2, 2015, by Michael Wetter:<br/>
Replaced <code>Medium.temperature()</code> with
<code>Water.temperature()</code> in order for the model
to work with OpenModelica.
Added an <code>assert</code> that stops the simulation if
an incompatible medium is used.
</li>
<li>
November 13, 2014, by Michael Wetter:<br/>
Added missing <code>each</code> keyword for <code>fanRelPowDer</code>.
Added regularization in computation of <code>TAppCor</code>.
Removed intermediate states with temperatures.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
October 9, 2013, by Michael Wetter:<br/>
Simplified the implementation for the situation if
<code>allowReverseFlow=false</code>.
Avoided the use of the conditionally enabled variables <code>sta_a</code> and
<code>sta_b</code> as this was not proper use of the Modelica syntax.
</li>
<li>
September 29, 2011, by Michael Wetter:<br/>
Revised model to use cubic spline interpolation instead of a polynomial.
</li>
<li>
July 12, 2011, by Michael Wetter:<br/>
Introduced common base class for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc\">Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc</a>
and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach\">Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach</a>
so that they can be used as replaceable models.
</li>
<li>
May 12, 2011, by Michael Wetter:<br/>
Added binding equations for <code>Q_flow</code> and <code>mXi_flow</code>.
</li>
<li>
March 8, 2011, by Michael Wetter:<br/>
Removed base class and unused variables.
</li>
<li>
February 25, 2011, by Michael Wetter:<br/>
Revised implementation to facilitate scaling the model to different nominal sizes.
Removed parameter <code>mWat_flow_nominal</code> since it is equal to <code>m_flow_nominal</code>,
which is the water flow rate from the chiller condenser loop.
</li>
<li>
May 16, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end YorkCalc;
