model YorkCalc 
  "Cooling tower with variable speed using the York calculation for the approach temperature" 
  extends 
    Buildings.HeatExchangers.CoolingTowers.BaseClasses.PartialStaticTwoPortCoolingTower;
  annotation (Icon(
      Text(
        extent=[-56,14; 56,-106],
        style(
          color=7,
          rgbcolor={255,255,255},
          fillColor=58,
          rgbfillColor={0,127,0},
          fillPattern=1),
        string="York"),
      Text(
        extent=[-102,108; -68,70],
        style(color=74, rgbcolor={0,0,127}),
        string="yFan"),
      Rectangle(extent=[-100,82; -70,78], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=74,
          rgbfillColor={0,0,127}))),
                          Diagram,
    Documentation(info="<html>
<p>
Model for a steady state cooling tower with variable speed fan using the York calculation for the
aproach temperature.
</p>
<p>
Note that the air outlet temperature can take on values that are higher than
the water inlet temperature. The reason is that, for computational efficiency, the
model does not add humidity to the outlet air. So, the enthalpy difference between air inlet and
outlet leads to sensible heating of the air stream with no latent heat gain.
</p>
</html>", revisions="<html>
<ul>
<li>
May 16, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
 /*
COOLING TOWER:VARIABLE SPEED,
Big Tower1, !- Tower Name
Condenser 1 Inlet Node, !- Water Inlet Node Name
Condenser 1 Outlet Node, !- Water Outlet Node Name
YorkCalc, !- Tower Model Type
, !- Tower Model Coefficient Name
#25.5556, !- Design Inlet Air Wet-Bulb Temperature {C}
#3.8889, !- Design Approach Temperature {C}
#5.5556, !- Design Range Temperature {C}
#0.0015, !- Design Water Flow Rate {m3/s}
#1.6435, !- Design Air Flow Rate {m3/s}
275, !- Design Fan Power {W}
FanRatioCurve, !- Fan Power Ratio as a function of Air Flow Rate Ratio Curve Name
0.2, !- Minimum Air Flow Rate Ratio
0.125, !- Fraction of Tower Capacity in Free Convection Regime
450.0, !- Basin Heater Capacity {W/K}
4.5, !- Basin Heater Set Point Temperature {C}
BasinSchedule, !- Basin Heater Operating Schedule Name
SATURATED EXIT, !- Evaporation Loss Mode
, !- Evaporation Loss Factor
0.05, !- Makeup Water Usage due to Drift {%}
SCHEDULED RATE, !- Blowdown Calculation Mode
BlowDownSchedule, !- Schedule Name for Makeup Water Usage due to Blowdown
; !- Name of Water Storage Tank for Supply
 
*/
  
  parameter Modelica.SIunits.Temperature TAirInWB0 = 273.15+25.55 
    "Design inlet air wet bulb temperature" 
      annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TApp0 = 3.89 
    "Design apprach temperature" 
      annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TRan0 = 5.56 
    "Design range temperature (water in - water out)" 
      annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mWat0_flow = 0.15 
    "Design water flow rate" 
      annotation (Dialog(group="Nominal condition"));
/*  parameter Modelica.SIunits.MassFlowRate mAir0_flow = 0.164*1.2 
    "Design air flow rate" 
      annotation (Dialog(group="Nominal condition"));
*/
  parameter Real fraFreCon(min=0, max=1) = 0.125 
    "Fraction of tower capacity in free convection regime";
  
  Modelica.SIunits.Temperature TApp(min=0, nominal=1) "Approach temperature";
  Modelica.SIunits.Temperature TAppCor(min=0, nominal=1) 
    "Approach temperature based on manufacturer correlation";
  Modelica.SIunits.Temperature TAppFreCon(min=0, nominal=1) 
    "Approach temperature for free convection";
  
  Modelica.SIunits.Temperature TRan(nominal=1) "Range temperature";
  Modelica.SIunits.MassFraction FRWat 
    "Ratio actual over design water mass flow ratio";
  Modelica.SIunits.MassFraction FRAir 
    "Ratio actual over design air mass flow ratio";
protected 
  parameter Modelica.SIunits.MassFraction FRWat0(min=0, start=1, fixed=false) 
    "Ratio actual over design water mass flow ratio at nominal condition";
  parameter Modelica.SIunits.Temperature TWatIn0(fixed=false) 
    "Water inlet temperature at nominal condition";
  parameter Modelica.SIunits.Temperature TWatOut0(fixed=false) 
    "Water outlet temperature at nominal condition";
  parameter Modelica.SIunits.MassFlowRate mWatRef_flow(min=0, start=mWat0_flow, fixed=false) 
    "Reference water flow rate";
  
  Modelica.SIunits.Temperature dTMax(nominal=1) 
    "Maximum possible temperature difference";
  
public 
  Correlations.BoundsYorkCalc bou "Bounds for correlation";
  Modelica.Blocks.Interfaces.RealInput y(redeclare type SignalType = Real (min=
            0)) "Fan control signal"     annotation (extent=[-140,60; -100,100]);
initial equation 
  TWatOut0 = TAirInWB0 + TApp0;
  TRan0 = TWatIn0 - TWatOut0; // by definition of the range temp.
  TApp0 = Correlations.yorkCalc(TRan=TRan0, TWB=TAirInWB0,
                                FRWat=FRWat0, FRAir=1); // this will be solved for FRWat0
  mWatRef_flow = mWat0_flow/FRWat0;
equation 
  // range temperature
  TRan = medium_a.T - medium_b.T;
  // fractional mass flow rates
  FRWat = m_flow/mWatRef_flow;
  FRAir = y;
  
  TAppCor = Correlations.yorkCalc(TRan=TRan, TWB=TAir,
                                  FRWat=FRWat, FRAir=max(FRWat/bou.liqGasRat_max, FRAir));
  dTMax = TWatIn_degC - TAirIn_degC;
  TApp = TAppCor;
  TAppFreCon = (1-fraFreCon) * ( TWatIn_degC-TAirIn_degC)  + fraFreCon *
               Correlations.yorkCalc(TRan=TRan, TWB=TAir, FRWat=FRWat, FRAir=1);
  TWatOut_degC = TApp + TAirIn_degC;
end YorkCalc;
