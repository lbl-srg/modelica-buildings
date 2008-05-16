model YorkCalc 
  "Cooling tower with variable speed using the York calculation for the approach temperatureCooling tower with fixed approach temperature based on wet bulb temperature" 
  extends 
    Buildings.HeatExchangers.CoolingTowers.BaseClasses.PartialStaticFourPortCoolingTower;
  annotation (Icon(
      Text(
        extent=[-70,34; 42,-86],
        style(
          color=7,
          rgbcolor={255,255,255},
          fillColor=58,
          rgbfillColor={0,127,0},
          fillPattern=1),
        string="York")),  Diagram);
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
  parameter Modelica.SIunits.MassFlowRate mWat0_flow = 0.0015*1000 
    "Design air flow rate" 
      annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mAir0_flow = 1.64*1.2 
    "Design air flow rate" 
      annotation (Dialog(group="Nominal condition"));
  
  Modelica.SIunits.Temperature TApp(min=0, nominal=1) "Approach temperature";
  Modelica.SIunits.Temperature TRan(nominal=1) "Range temperature";
  Modelica.SIunits.Temperature TAirInWB(start=273.15+20) 
    "Air wet-bulb inlet temperature";
  Modelica.SIunits.CelsiusTemperature TAirInWB_degC 
    "Air wet-bulb inlet temperature";
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
  
  Utilities.Psychrometrics.WetBulbTemperature wetBulMod(redeclare package 
      Medium = Medium_2, p(start=101325)) 
    "Model to compute wet bulb temperature" 
    annotation (extent=[-56,50; -36,70]);
initial equation 
  mWatRef_flow = mWat0_flow/FRWat0;
  
  TWatOut0 = TAirInWB0 + TApp0;
  TRan0 = TWatIn0 - TWatOut0; // by definition of the range temp.
  TApp0 = Correlations.yorkCalc(TRan=TRan0, TWB=TAirInWB0,
                                FRWat=FRWat0, FRAir=1); // this will be solved for FRWat0
  
equation 
  // compute wet bulb temperature
  wetBulMod.dryBul.h  = medium_a2.h;
  wetBulMod.dryBul.p  = medium_a2.p;
  wetBulMod.dryBul.Xi = medium_a2.Xi;
  TAirInWB = wetBulMod.TWetBul;
  TAirInWB_degC = Modelica.SIunits.Conversions.to_degC(TAirInWB);
  TWatOut_degC = TApp + TAirInWB_degC;
  
  TRan = medium_a1.T - medium_b1.T;
  FRWat = m_flow_1/mWatRef_flow;
  FRAir = m_flow_2/mAir0_flow;
  
  // At small air flow temperature, the approach temperature may become so large
  // that the water outlet temperature is higher than the water inlet temperature
  TApp = min(TWatIn_degC - TAirInWB_degC,
         Correlations.yorkCalc(TRan=TRan, TWB=TAirInWB,
                                FRWat=FRWat, FRAir=FRAir));
  
end YorkCalc;
