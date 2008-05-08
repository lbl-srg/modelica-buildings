model CoolTools "Cooling tower with variable speed" 
  extends Buildings.Fluids.Interfaces.PartialStaticFourPortHeatMassTransfer;
  extends Buildings.BaseClasses.BaseIcon;
  annotation (Icon(
      Rectangle(extent=[-100,-55; 101,-65], style(
          pattern=0,
          fillColor=58,
          rgbfillColor={0,127,0})),
      Text(
        extent=[-62,-38; -20,-74],
        string="air",
        style(
          color=7,
          rgbcolor={255,255,255},
          fillColor=58,
          rgbfillColor={0,127,0},
          fillPattern=1)),
      Text(
        extent=[-64,98; 0,26],
        style(
          color=7,
          rgbcolor={255,255,255},
          fillColor=58,
          rgbfillColor={0,127,0},
          fillPattern=1),
        string="water")), Diagram);
/*  Modelica.Blocks.Interfaces.RealInput TDb(redeclare type SignalType = 
        Modelica.SIunits.Temperature) "inlet air drybulb temperature" 
    annotation (extent=[-140,60; -100,100]);
  Modelica.Blocks.Interfaces.RealInput TWb(redeclare type SignalType = 
        Modelica.SIunits.Temperature) "inlet air wetbulb temperature" 
    annotation (extent=[-140,20; -100,60]);
*/
 /*
COOLING TOWER:VARIABLE SPEED,
Big Tower1, !- Tower Name
Condenser 1 Inlet Node, !- Water Inlet Node Name
Condenser 1 Outlet Node, !- Water Outlet Node Name
YorkCalc, !- Tower Model Type
, !- Tower Model Coefficient Name
25.5556, !- Design Inlet Air Wet-Bulb Temperature {C}
3.8889, !- Design Approach Temperature {C}
5.5556, !- Design Range Temperature {C}
0.0015, !- Design Water Flow Rate {m3/s}
1.6435, !- Design Air Flow Rate {m3/s}
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
  Modelica.SIunits.Temperature TWatIn(start=273.15+35) 
    "Water inlet temperature";
  Modelica.SIunits.Temperature TWatOut(start=273.15+28) 
    "Water outlet temperature";
  Modelica.SIunits.Temperature TAirIn(start=273.15+25) 
    "Air dry-bulb inlet temperature";
  Modelica.SIunits.Temperature TAirOut(start=273.15+30) 
    "Air dry-bulb outlet temperature";
  Modelica.SIunits.Temperature TAirInWB(start=273.15+20) 
    "Air wet-bulb inlet temperature";
  
  Modelica.SIunits.Temperature TApp(min=-20, start=2) "Approach temperature";
  Utilities.Psychrometrics.WetBulbTemperature wetBulMod(redeclare package 
      Medium = Medium_2, p(start=101325)) 
    "Model to compute wet bulb temperature" 
    annotation (extent=[-56,50; -36,70]);
equation 
  TWatIn  = medium_a1.T;
  TWatOut = medium_b1.T;
  TAirIn  = medium_a2.T;
  TAirOut = medium_b2.T;
  
  // compute wet bulb temperature
  // this does not converge. Try to use a simpler medium implementation,
  // or to add a state
  wetBulMod.dryBul.h  = medium_a2.h;
  wetBulMod.dryBul.p  = 101325;//medium_a2.p;
  wetBulMod.dryBul.Xi = medium_a2.Xi;
  TAirInWB = wetBulMod.TWetBul;
  
  TApp    = TWatOut - TAirInWB;
  Q_flow_1 = 1E-8*((medium_a1.T+medium_b1.T)-(medium_a2.T+medium_b2.T))/2; // for testing only
  Q_flow_1 + Q_flow_2 = 0;
  
  mXi_flow_1 = zeros(Medium_1.nXi); // no mass added or removed (sensible heat only)
  mXi_flow_2 = zeros(Medium_2.nXi); // no mass added or removed (sensible heat only)
  
  dp_1 = 0;
  dp_2 = 0;
  
end CoolTools;
