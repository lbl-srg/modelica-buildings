within Buildings.Fluid.HeatExchangers.H_Example.DummyExample;
function wAirOut_min_checkup
  "This code checks wAirOut to see whether there is an appratus temperature for the bypass method exisits under the given air inlet and outlet conditions"
  input Modelica.SIunits.Temperature TAirIn  "inlet air temperature";
  input Modelica.SIunits.Temperature TAirOut  "outlet air temperature";
  input Modelica.SIunits.MassFraction wAirIn  "absolute humidity at the air inlet";
  input Modelica.SIunits.MassFraction wAirOut "absolute humidity at the air oulet";

  output Modelica.SIunits.MassFraction wAirOutRe "modofied air outlet humidity";


  final parameter Modelica.SIunits.Temperature TAppMin=273.15+2 "minimal apparatus temperature for a non-frosting cooling coil (0 oC by default)";
protected
  Modelica.SIunits.PartialPressure pWat "partial water vapor pressure at the minimal apparatus temperature";
  Modelica.SIunits.MassFraction wSatTApp "absolute humidity at the minimal apparatus temperature";
  Modelica.SIunits.MassFraction wAirOutMin;

algorithm
  pWat:=Buildings.Utilities.Psychrometrics.Functions.pW_TDewPoi(T=TAppMin);
  wSatTApp:=Buildings.Utilities.Psychrometrics.Functions.X_pW(p_w=
    pWat,p=101325);

  wAirOutMin:=(wAirIn-wSatTApp)/(TAirIn-TAppMin)*(TAirOut -TAirIn) + wAirIn;
  wAirOutRe:=min( wAirOutMin, wAirOut);
end wAirOut_min_checkup;
