within Buildings.Fluid.HeatExchangers.BaseClasses;
model WetCoilWetRegime
  "Fully wet coil model using esilon_C.mo function"
  constant Real cpEff0=2050 "Used for scaling";
  constant Real cpWat0=4200 "Used for scaling";
  parameter Real delta = 1E-3 "Small value used for smoothing";
  constant Modelica.SIunits.SpecificHeatCapacity cpDum=1
    "Dummy cp to eliminate the warning message of the unit mismatch when using the eps-NTU model for the wet coil";
  constant Modelica.SIunits.TemperatureDifference dTWat=0.1;
  parameter Real tau=6*60
    "Time constant for the state estimation: introduced to avoid the algebraic loop of the wet coil equations";

  // - water
  input Modelica.SIunits.ThermalConductance UAWat
    "UA for water side";
  input Modelica.SIunits.MassFlowRate mWat_flow
    "Mass flow rate for water";
  input Modelica.SIunits.MassFlowRate mWatNonZer_flow
    "None-zero Mass flow rate for water";
  input Modelica.SIunits.SpecificHeatCapacity cpWat
    "Specific heat capacity of water";
  input Modelica.SIunits.Temperature TWatIn
    "Water temperature at inlet";
  input Modelica.SIunits.MassFlowRate mWat_flow_nominal;
  // -- air
  input Modelica.SIunits.Pressure pAir
    "Pressure on air-side of coil";
  input Modelica.SIunits.ThermalConductance UAAir
    "UA for air side";
  input Modelica.SIunits.MassFlowRate mAir_flow
    "Mass flow rate of air";
  input Modelica.SIunits.MassFlowRate mAirNonZer_flow
    "None-zero Mass flow rate for water";
  input Modelica.SIunits.SpecificHeatCapacity cpAir
    "Specific heat capacity of moist air at constant pressure";
  input Modelica.SIunits.Temperature TAirIn
    "Temperature of air at inlet";
  input Modelica.SIunits.MassFraction X_wAirIn
    "Mass fraction of water in moist air at inlet";
  input Buildings.Fluid.Types.HeatExchangerFlowRegime cfg
    "The configuration of the heat exchanger";
  input Modelica.SIunits.MassFlowRate mAir_flow_nominal;

  Modelica.SIunits.SpecificEnthalpy hAirIn
    "Specific enthalpy of air at inlet conditions";
  Buildings.Utilities.Psychrometrics.hSat_pTSat hSatWatInM(p=pAir,TSat=TWatIn)
    "Model to calculate saturated specific enthalpy of air at water inlet temperature";
  Modelica.SIunits.SpecificEnthalpy hSatWatIn
    "Saturated specific enthalpy of air at water inlet temperature";

  Buildings.Utilities.Psychrometrics.hSat_pTSat hSatWatIn_dT_M(p=pAir,TSat=TWatIn+dTWat)
    "Model to calculate derivative of saturated specific enthalpy of air at water inlet temperature";
  Modelica.SIunits.SpecificHeatCapacity dhSatdTWatIn
   "Deriviative of saturated moist air enthalpy at water inlet temperature";
  Real NonZerDelWatTem
  "Regularization water temperature difference betwee inlet and outlet";


   Modelica.SIunits.SpecificEnthalpy hAirOut
    "Specific enthalpy of moist air at the air outlet";
  Buildings.Utilities.Psychrometrics.hSat_pTSat hSatWatOutM(p=pAir,TSat=TWatOutEst)
    "Model to calculate saturated specific enthalpy of air at water outlet temperature";
  Modelica.SIunits.SpecificEnthalpy hSatWatOut
    "Saturated specific enthalpy of air at water outlet temperature";

  Modelica.SIunits.Temperature TSurEff
   "Effective surface temperature of the coil to split sensible and latent heat from total heat transfer rate";

  Modelica.SIunits.SpecificEnthalpy hSatSurEff
  "Enthalpy of saturated moist air at the effective surface temperature";

  Buildings.Utilities.Psychrometrics.hSat_pTSat hSatSurEffM(p=pAir,TSat=TSurEff)
   "An object to calculate the saturated enthalpy of moist air at the coil surface temperature";
  Buildings.Utilities.Psychrometrics.hSat_pTSat hSatSurEffMinM(p=pAir,TSat=273.15+1)
  "An object to calculate a lower bound of the saturated enthalpy of moist 
  air at the coil surface temperature";

  Modelica.SIunits.SpecificHeatCapacity cpEff
    "Effective specific heat: change in enthalpy with respect to temperature
     along the saturation line at the local water temperature";


  Modelica.SIunits.MassFlowRate UASta
    "Overall mass transfer coefficient for dry coil";

  Real NTUAirSta(unit="1")
    "Number of transfer units for air-side only (NTU_a*)";

  Real epsSta(start=0.66, unit="1")
    "Effectiveness for heat exchanger (e*)";

  Modelica.SIunits.MassFlowRate CStaMin
   "Min of product of mass flow rates and specific heats; analogous to Cmin";

  Modelica.SIunits.MassFlowRate CStaMin_flow_nominal= min(
    mAir_flow_nominal,mWat_flow_nominal*cpEff0/cpWat0)
    "Analogus to CMin_flow_nominal, only for a regularization";
  Modelica.SIunits.MassFlowRate CStaMax_flow_nominal= max(
    mAir_flow_nominal,mWat_flow_nominal*cpEff0/cpWat0)
    "Analogus to CMax_flow_nominal, only for a regularization";
  Modelica.SIunits.MassFlowRate deltaCStaMin=delta*min(
    mAir_flow_nominal,mWat_flow_nominal*cpEff0/cpWat0)
    "Min of product of mass flow rates and specific heats, analogous to Cmin";
  Modelica.SIunits.Temperature TWatOutEst
    "State_estimation of Temperature of water at outlet";

  output Modelica.SIunits.HeatFlowRate QTot_flow
    "Total heat flow from water to air stream";
   output Modelica.SIunits.HeatFlowRate QSen_flow
    "Sensible heat flow from water to air stream";
  output Modelica.SIunits.Temperature TWatOut
    "Temperature at the water outlet";
  output Modelica.SIunits.Temperature TSurAirIn
    "Coil surface temperature at the air inlet";
  output Modelica.SIunits.Temperature TAirOut
    "Temperature at the air outlet";
initial equation
  TWatOutEst=0.5*(TWatIn+ TAirIn);

equation

  hAirIn=Buildings.Media.Air.specificEnthalpy_pTX(p=pAir,T=TAirIn,X={X_wAirIn,1-X_wAirIn});
  hSatWatIn=hSatWatInM.hSat;
  dhSatdTWatIn=(hSatWatIn_dT_M.hSat-hSatWatInM.hSat)/dTWat; // dTWat is a parameter
  hSatWatOut= hSatWatOutM.hSat;
  NonZerDelWatTem=Buildings.Utilities.Math.Functions.regNonZeroPower(x=TWatOutEst-TWatIn,n=1,delta=0.1);
  cpEff = Buildings.Utilities.Math.Functions.smoothMax(
  (hSatWatOut - hSatWatIn)/NonZerDelWatTem,
  dhSatdTWatIn,
  cpEff0*delta);

  CStaMin=Buildings.Utilities.Math.Functions.smoothMin(
  mAir_flow,
  mWat_flow*cpWat/cpEff,
  deltaCStaMin/4);

  UASta = (UAAir/cpAir)/(1 + (cpEff*UAAir)/(cpAir*UAWat));

  epsSta=epsilon_C(
  UA=UASta*cpDum,
  C1_flow=mWat_flow*cpWat/cpEff*cpDum,
  C2_flow=mAir_flow*cpDum,
  flowRegime=Integer(cfg),
  CMin_flow_nominal=CStaMin_flow_nominal*cpDum,
  CMax_flow_nominal=CStaMax_flow_nominal*cpDum,
  delta=delta);

  QTot_flow = epsSta*CStaMin*(hAirIn  - hSatWatIn);

  QTot_flow = mAir_flow*(hAirIn- hAirOut);
  QTot_flow = mWat_flow*cpWat*(TWatOut-TWatIn);

  NTUAirSta = UAAir/(mAir_flow*cpAir);

  hSatSurEff = Buildings.Utilities.Math.Functions.smoothMax(
    x1 = hSatSurEffMinM.hSat,
    x2 = hAirIn  +(hAirOut - hAirIn) / (1 - exp(-NTUAirSta)),
    deltaX = delta*1E4); // NTUAirSta is bounded as long as UAAir>0 due to the regularization of mAir_flow

  hSatSurEffM.hSat=hSatSurEff;
  TAirOut = TSurEff +(TAirIn  - TSurEff)*exp(-NTUAirSta);
  QSen_flow= Buildings.Utilities.Math.Functions.smoothMin(
    x1 = mAir_flow*cpAir*(TAirIn-TAirOut),
    x2 = QTot_flow,
    deltaX = delta*mWatNonZer_flow*cpWat0*5); // the last term is only for regularization with DTWater=5oC

  (TAirIn-TSurAirIn)*UAAir=(TSurAirIn-TWatOut)*UAWat;
  der(TWatOutEst)=-1/tau*TWatOutEst+1/tau*TWatOut;

annotation (Icon(graphics={
        Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={28,108,200},
        fillColor={170,213,255},
        fillPattern=FillPattern.Solid)}), Documentation(revisions="<html>
<ul>
<li>Jan 21, 2021, by Donghun Kim:<br/>First implementation of the fuzzy model. 
See 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/622\">
issue 622</a> 
for more information. 
</li>
</ul>
</html>", info="<html>
<p>
This model implements the calculation for a 100% wet coil. 
</p>
<p>
The equations from Braun (1988) and Mitchell and Braun (2012a and b),
which are essentially the extension of the <i>&epsilon;-NTU</i> approach to
simultaneous sensible and latent heat transfer, are utilized. 
</p>
<p>
The mathematical equations are analogous to that of the sensible heat exchanger.
However, the key distinction is from that the heat transfer is driven by an enthalpy difference
not by an temperature difference. This change in the driving potential results in re-defining 
capacitances and heat transfer coefficients accordinlgy.
</p>

<p>
The total heat transfer rate is expressed as
</p>
<p align=\"center\"> 
<i> Q<sub>tot</sub>=&epsilon;* C*<sub>min </sub>
(h<sub>air,in</sub>-h<sub>sat</sub>(T<sub>wat,in</sub>))</i>,
</p>
<p>
where <i>&epsilon;*=f(Cr*,NTU*)</i> and <i>f</i> is the same <i>&epsilon;-NTU</i> relationships
(depending on the heat exchanger configuration) for the sensible heat exchanger.
</p>
<p>
<i>h<sub>air,in</sub> </i> and <i>h<sub>sat</sub></i>(<i>T<sub>wat,in</sub></i>) are
the specific enthalpies of the incoming moist air and saturated moist air 
at the water inlet temperature.
</p>
<p>
The capacitances of water and air streams are defined as
</p>
<p align=\"center\"><i>C*<sub>air</sub>=m<sub>air</sub></i> and
<i>C*<sub>wat</sub>=m<sub>wat</sub>c<sub>p,wat</sub>/csat</i>,
</p>
<p>
where <i>csat</i> is an specific heat capacity, which indicates the sensitivity
of the enthalpy of the staturated moist air w.r.t. the temperature, and is defined
here as <i>csat=(h<sub>sat</sub>(T<sub>wat,out</sub>)-h<sub>sat</sub>(T<sub>wat,in</sub>))
/(T<sub>wat,out</sub>-T<sub>wat,in</sub>)</i>. 
</p>
<p>
The capacitance ratio and minimum capacitance are naturally defined as
</p>
<p align=\"center\"> <i>Cr*=min(C*<sub>air</sub>,C*<sub>wat</sub>)/max(C*<sub>air</sub>,C*<sub>wat</sub>)</i>
and <i>C*<sub>min</sub>=min(C*<sub>air</sub>,C*<sub>wat</sub>)</i>.
</p>
<p><br/>
The number of transfer unit for the wet-coil is defined as <i>NTU*=UA*/C*<sub>min</sub></i>, where 
</p>
<p align=\"center\">
<i>UA*=1/(1/(UA<sub>air</sub>/c<sub>p,air</sub>)+1/(UA<sub>wat</sub>/csat)</i>. 
</p>

<h4>References </h4>
<p>
Braun, James E. 1988.
&quot;Methodologies for the Design and Control of Central Cooling Plants&quot;.
PhD Thesis. University of Wisconsin - Madison.
Available
<a href=\"https://minds.wisconsin.edu/handle/1793/46694\">
online</a>.
</p>
<p>
Mitchell, John W., and James E. Braun. 2012a.
Principles of heating, ventilation, and air conditioning in buildings.
Hoboken, N.J.: Wiley. 
</p>
<p>
Mitchell, John W., and James E. Braun. 2012b.
&quot;Supplementary Material Chapter 2: Heat Exchangers for Cooling Applications&quot;.
Excerpt from Principles of heating, ventilation, and air conditioning in buildings.
Hoboken, N.J.: Wiley.
Available
<a href=\"http://bcs.wiley.com/he-bcs/Books?action=index&amp;itemId=0470624574&amp;bcsId=7185\">
online</a>.
</p>
</html>"));
end WetCoilWetRegime;
