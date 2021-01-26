within Buildings.Fluid.HeatExchangers.H_Example.DummyExample;
model UA_nominalFromOperatingCondition
  "This block is to calculate UA_nominal using operating conditions"
  replaceable package MediumA=Buildings.Media.Air;
  replaceable package MediumW=Buildings.Media.Water;

  parameter Modelica.SIunits.Temperature TAirIn = Modelica.SIunits.Conversions.from_degF(80);
  parameter Modelica.SIunits.Temperature TAirOut= Modelica.SIunits.Conversions.from_degF(53);
  parameter Modelica.SIunits.MassFraction wAirIn = 0.01765;
  Modelica.SIunits.MassFraction wAirOut;

  parameter Modelica.SIunits.Temperature TWatIn=Modelica.SIunits.Conversions.from_degF(42);
  parameter Modelica.SIunits.Temperature TWatOut=Modelica.SIunits.Conversions.from_degF(47.72);

  parameter Modelica.SIunits.MassFlowRate mAir_flow=2.646;
  parameter Modelica.SIunits.MassFlowRate mWat_flow=3.78;

  Modelica.SIunits.SpecificEnthalpy hAirIn;
  Modelica.SIunits.SpecificEnthalpy hAirOut;

  // calculates all thermodynamic properties based on inputs
  MediumA.ThermodynamicState staAir=MediumA.setState_phX(p=MediumA.p_default,h=MediumA.h_default,X=MediumA.X_default[1:MediumA.nXi]);
  MediumW.ThermodynamicState staWat=MediumW.setState_phX(p=MediumW.p_default,h=MediumW.h_default,X=MediumW.X_default[1:MediumW.nXi]);

  Modelica.SIunits.SpecificHeatCapacity cpAir=MediumA.specificHeatCapacityCp(staAir);
  Modelica.SIunits.SpecificHeatCapacity cpw=MediumW.specificHeatCapacityCp(staWat);
  Modelica.SIunits.SpecificHeatCapacity cpEff
    "Effective specific heat: change in enthalpy with respect to
     temperature along the saturation line at the local water
     temperature";

  Modelica.SIunits.SpecificEnthalpy hunit=1;
  Modelica.SIunits.Temperature Tunit=1;

  Buildings.Utilities.Psychrometrics.hSat_pTSat hsatTWatIn(p=MediumA.p_default,TSat=TWatIn);
  Buildings.Utilities.Psychrometrics.hSat_pTSat hsatTWatOut(p=MediumA.p_default,TSat=TWatOut);
  Modelica.SIunits.SpecificEnthalpy LMED;

  Modelica.SIunits.MassFlowRate UASta(min=0);
  output Modelica.SIunits.HeatFlowRate QTot_flow
    "Total heat flow from air to water stream";

  parameter Real r_nominal(
    min=0,
    max=1) = 2/3
    "Ratio between air-side and water-side convective heat transfer (hA-value) at nominal condition";

  output Modelica.SIunits.ThermalConductance UAAir(min=0,start=10)
  "Air side convective heat transfer coefficient, including fin resistance";
  output Modelica.SIunits.ThermalConductance UAWat(min=0,start=20)
  "Water side convective heat transfer coefficient";
  output Modelica.SIunits.ThermalConductance UA(fixed=false, min=0,start=1/(1/10+1/20))
    "UA is for the overall coil (i.e., both sides)";

equation

  hAirIn =MediumA.specificEnthalpy_pTX(p=MediumA.p_default,T=TAirIn,X={wAirIn,1-wAirIn});
  hAirOut=MediumA.specificEnthalpy_pTX(p=MediumA.p_default,T=TAirOut,X={wAirOut,1-wAirOut});

  mWat_flow*cpw*(TWatOut-TWatIn) = mAir_flow*(hAirIn-hAirOut);
  QTot_flow = mAir_flow*(hAirIn-hAirOut);// calculates wAirOut or Qtot
  // calculation of overall UAsta based on log mean enthalpy difference
  LMED=Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(hAirIn/hunit*Tunit,
                    hAirOut/hunit*Tunit,
                    hsatTWatIn.hSat/hunit*Tunit,
                    hsatTWatOut.hSat/hunit*Tunit)/Tunit*hunit; //Q: HX configuration?

  QTot_flow=LMED*UASta;
  cpEff= (hsatTWatOut.hSat-hsatTWatIn.hSat)/(TWatOut-TWatIn);
  UASta = (UAAir/cpAir)/(1 + (cpEff*UAAir)/(cpAir*UAWat));
  UAWat=UAAir/r_nominal;
  UA = 1/ (1/UAAir  + 1/ UAWat);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{100,-98},{-100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end UA_nominalFromOperatingCondition;
