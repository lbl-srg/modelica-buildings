within Buildings.Fluid.HeatExchangers.BaseClasses;
model WetCoilUARated
  "This model calculates overall heat transfer coefficient, i.e., UA-value, from a rated condition for a cooling coil. 
  Specify a rated condition either in fully-dry or fully-wet coil regime. Avoid that on partially-wet regime."
  replaceable package MediumA=Buildings.Media.Air;
  replaceable package MediumW=Buildings.Media.Water;

  parameter Boolean use_UA_nominal = false
    "Set to true to specify UA_nominal, or to false to use nominal conditions"
    annotation (Evaluate=true,
                Dialog(group="Nominal thermal performance"));
  parameter Modelica.SIunits.Temperature TAirIn
    "Air inlet temperature at a rated condition";
  parameter Modelica.SIunits.Temperature TAirOut
    "Air outlet temperature  at a rated condition";
  parameter Modelica.SIunits.MassFraction wAirIn
    "Absolute humidity of inlet air at a rated condition";
  parameter Modelica.SIunits.Temperature TWatIn
    "Water inlet temperature at a rated condition";
  parameter Modelica.SIunits.Temperature TWatOut
    "Water outlet temperature at a rated condition";
  parameter Modelica.SIunits.MassFlowRate mAir_flow
    "Air mass flow rate at a rated condition";
  parameter Modelica.SIunits.MassFlowRate mWat_flow
    "Water mass flow rate at a rated condition";
  parameter Modelica.SIunits.ThermalConductance UA
    "UA is for the overall coil (i.e., both sides)";
  parameter Real r_nominal(min=0, max=1)
    "Ratio between air-side and water-side convective heat transfer at nominal condition";
protected
  constant Modelica.SIunits.SpecificEnthalpy hfg=
    Buildings.Utilities.Psychrometrics.Constants.h_fg;
  parameter Modelica.SIunits.MassFraction wAirOut(fixed=false)
    "Absolute humidity of outgoing air at a rated condition";
  parameter Modelica.SIunits.SpecificEnthalpy hAirIn(fixed=false)
    "Enthalpy of incoming moist air at a rated condition";
  parameter Modelica.SIunits.SpecificEnthalpy hAirOut(fixed=false)
    "Enthalpy of outgoing moist air at a rated condition";

  // calculates all thermodynamic properties based on inputs
  parameter MediumA.ThermodynamicState staAir=MediumA.setState_phX(
    p=MediumA.p_default,h=MediumA.h_default,X=MediumA.X_default[1:MediumA.nXi]);
  parameter MediumW.ThermodynamicState staWat=MediumW.setState_phX(
    p=MediumW.p_default,h=MediumW.h_default,X=MediumW.X_default[1:MediumW.nXi]);

  parameter Modelica.SIunits.SpecificHeatCapacity cpAir=
    MediumA.specificHeatCapacityCp(staAir);
  parameter Modelica.SIunits.SpecificHeatCapacity cpw=
    MediumW.specificHeatCapacityCp(staWat);
  parameter Modelica.SIunits.SpecificHeatCapacity cpEff(fixed=false, min= 0)
    "Effective specific heat: change in saturated moist air enthalpy with respect to
    temperature along the saturation line between inlet and outlet water temperatures";

  constant Modelica.SIunits.SpecificEnthalpy hunit=1;
  constant Modelica.SIunits.Temperature Tunit=1;
  constant Modelica.SIunits.SpecificHeatCapacity cpunit=1;

  Modelica.SIunits.AbsolutePressure pSatTWatIn=
    Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TWatIn)
    "Saturation pressure of water at the water inlet temperature";
  Modelica.SIunits.MassFraction wSatTWatIn=
    Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat=pSatTWatIn, p=MediumA.p_default, phi=1)
    "Absolute humidity of the moist air at the water inlet temperature";
  Modelica.SIunits.SpecificEnthalpy hSatTWatIn=
    Buildings.Media.Air.specificEnthalpy_pTX(
      p=MediumA.p_default, T=TWatIn, X={wSatTWatIn,1-wSatTWatIn})
    "Enthalpy of saturated moist air at the water inlet temperature";

  Modelica.SIunits.AbsolutePressure pSatTWatOut=
    Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TWatOut)
    "Saturation pressure of water at the water oulet temperature";
  Modelica.SIunits.MassFraction wSatTWatOut=
    Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat=pSatTWatOut, p=MediumA.p_default, phi=1)
    "Absolute humidity of the moist air at the water oulet temperature";
  Modelica.SIunits.SpecificEnthalpy hSatTWatOut=
    Buildings.Media.Air.specificEnthalpy_pTX(
      p=MediumA.p_default, T=TWatOut, X={wSatTWatOut,1-wSatTWatOut})
    "Enthalpy of saturated moist air at the water oulet temperature";

  parameter Modelica.SIunits.SpecificEnthalpy LMED(fixed=false)
    "Log mean enthalpy difference";

  parameter Modelica.SIunits.MassFlowRate UASta(fixed=false, min=0)
    "Overall heat transfer coefficient for enthalpy difference";
  parameter Modelica.SIunits.HeatFlowRate QTot_flow=mWat_flow*cpw*(TWatOut-TWatIn)
    "Total heat flow from air to water stream";

  parameter Modelica.SIunits.ThermalConductance UAAir(min=0,start=10,fixed=false)
  "Air side convective heat transfer coefficient, including fin resistance";
  parameter Modelica.SIunits.ThermalConductance UAWat(min=0,start=20,fixed=false)
  "Water side convective heat transfer coefficient";

  parameter Boolean IsFulDry(fixed=false);
  parameter Boolean IsFulWet(fixed=false);
  parameter Boolean IsParWet(fixed=false);

initial equation

  if not use_UA_nominal then
    assert(TAirOut<TAirIn and TWatOut>TWatIn and TWatIn<TAirIn,
      "The rated condition is not for a cooling coil. " +
      "For a heating coil, use other heat exchanger models.");

    hAirIn=MediumA.specificEnthalpy_pTX(
      p=MediumA.p_default, T=TAirIn, X={wAirIn, 1-wAirIn});
    hAirOut=MediumA.specificEnthalpy_pTX(
      p=MediumA.p_default, T=TAirOut, X={wAirOut, 1-wAirOut});

    QTot_flow = mAir_flow*(hAirIn-hAirOut);

    IsFulDry=(wSatTWatIn>=wAirIn);
    IsFulWet=(wSatTWatOut<=wAirIn);
    IsParWet= (not IsFulDry) and (not IsFulWet);

    assert(not IsParWet,
      "Partially dry nominal condition is not allowed at this moment. " +
      "Specify either fully-dry or fully-wet nominal condition");

    if IsFulDry then
      LMED=Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        TAirIn,
        TAirOut,
        TWatIn,
        TWatOut)/Tunit*hunit; // The value of LMED calculated from this equation is used as that of LMTD.
      QTot_flow=LMED*UASta; // The value of UASta calculated from this equation is used as that of UA.
      cpEff= Modelica.Constants.inf*cpunit; // cpEff is not used for fully-dry
      UA= UASta*cpunit;
    else //fully wet
      // calculation of overall UAsta based on log mean enthalpy difference
      LMED=Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        hAirIn/hunit*Tunit,
        hAirOut/hunit*Tunit,
        hSatTWatIn/hunit*Tunit,
        hSatTWatOut/hunit*Tunit)/Tunit*hunit;
      QTot_flow=LMED*UASta;
      cpEff= (hSatTWatOut-hSatTWatIn)/(TWatOut-TWatIn);
      UASta = (UAAir/cpAir)/(1 + (cpEff*UAAir)/(cpAir*UAWat));
    end if;
  else
    TAirIn=MediumA.T_default;
    TAirOut=MediumA.T_default;
    wAirIn=MediumA.X_default[1];
    wAirOut=MediumA.X_default[1];
    TWatIn=MediumA.T_default;
    TWatOut=MediumA.T_default;
    hAirIn=MediumA.h_default;
    hAirOut=MediumA.h_default;
    IsFulDry=false;
    IsFulWet=false;
    IsParWet=false;
    LMED=hunit;
    QTot_flow=LMED*UASta;
    cpEff= Modelica.Constants.inf*cpunit;
  end if;

  UAWat=UAAir/r_nominal;
  UA = 1/ (1/UAAir  + 1/ UAWat);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={
        Rectangle(
        extent={{100,-98},{-100,100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
end WetCoilUARated;
