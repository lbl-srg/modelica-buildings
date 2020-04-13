within Buildings.Fluid.HeatExchangers.BaseClasses;
model DryCalcsFuzzy_V2_2_2
  "Added \"if dryfra==-1, then give dummy\" from V2_2"

  // - water
  input Modelica.SIunits.ThermalConductance UAWat
    "UA for water side";
  input Real dryfra(min=0, max=1)
    "Fraction of heat exchanger to which UA is to be applied";
  input Modelica.SIunits.MassFlowRate mWat_flow
    "Mass flow rate for water";
  input Modelica.SIunits.MassFlowRate mWatNonZer_flow(min=Modelica.Constants.eps)
    "Mass flow rate for water, bounded away from zero";

  input Modelica.SIunits.SpecificHeatCapacity cpWat
    "Specific heat capacity of water";
  input Modelica.SIunits.Temperature TWatIn
    "Water temperature at inlet";
  // -- air
  input Modelica.SIunits.ThermalConductance UAAir
    "UA for air side";
  input Modelica.SIunits.MassFlowRate mAir_flow(min=Modelica.Constants.eps)
    "Mass flow rate of air";
  input Modelica.SIunits.MassFlowRate mAirNonZer_flow(min=Modelica.Constants.eps)
    "Mass flow rate for air, bounded away from zero";

  input Modelica.SIunits.SpecificHeatCapacity cpAir
    "Specific heat capacity of moist air at constant pressure";
  input Modelica.SIunits.Temperature TAirIn
    "Temperature of air at inlet";
  // -- misc.
  input Buildings.Fluid.Types.HeatExchangerFlowRegime cfg
    "The flow regime of the heat exchanger";

  output Modelica.SIunits.HeatFlowRate QTot_flow
    "Heat transferred from water to air";
  output Modelica.SIunits.Temperature TWatOut
    "Temperature of water at outlet";
  output Modelica.SIunits.Temperature TAirOut
    "Temperature of air at the outlet";

  output Real eps(min=0, max=1, unit="1")
    "Effectiveness for heat exchanger";
  Modelica.SIunits.ThermalConductance CWat_flow
    "Capacitance rate of water";
  Modelica.SIunits.ThermalConductance CAir_flow
    "Capacitance rate of air";
  Modelica.SIunits.ThermalConductance CMin_flow
    "Minimum capacity rate";
  Modelica.SIunits.ThermalConductance CMax_flow
    "Maximum capacity rate";

  Real Z(unit="1")
    "capacitance rate ratio (C*)";
  output Modelica.SIunits.ThermalConductance UA
    "Overall heat transfer coefficient";
  output Real NTU
    "Dry coil number of transfer units";

  output Modelica.SIunits.Temperature TSurAirOut
    "Surface Temperature at air outlet";
  input Real delta = 1E-3 "Small value used for smoothing";
  input Modelica.SIunits.MassFlowRate mAir_flow_nominal;
  input Modelica.SIunits.MassFlowRate mWat_flow_nominal;

//protected
  Modelica.SIunits.ThermalConductance deltaCMin
    "Small number for capacity flow rate";
  Modelica.SIunits.ThermalConductance deltaCMax
    "Small number for capacity flow rate";
  output Modelica.SIunits.ThermalConductance CMinNonZer_flow
    "Non-zero minimum capacity rate";
  Modelica.SIunits.ThermalConductance CMaxNonZer_flow
    "Non-zero maximum capacity rate";
  Real dryfraNonZero;
  Real gai(min=0, max=1)
    "Gain used to force UA to zero for very small flow rates";

equation
  if (dryfra<=-1) then
    dryfraNonZero=-1;
    deltaCMin=-1;
    deltaCMax=-1;
    CWat_flow=-1;
    CAir_flow=-1;
    CMin_flow=-1;
    CMax_flow=-1;
    CMinNonZer_flow=-1;
    CMaxNonZer_flow=-1;
    UA=-1;
    Z=-1;
    gai=-1;
    NTU=-1;
    eps=-1;
    QTot_flow=-1;
    TWatOut=-1;
    TAirOut=-1;
    TSurAirOut=-1;

  else
    dryfraNonZero = Buildings.Utilities.Math.Functions.spliceFunction(
      pos = dryfra,
      neg = delta,
      x =   dryfra-delta,
      deltax = delta/2);

    deltaCMin = delta*min(mAir_flow_nominal*cpAir,mWat_flow_nominal*cpWat);
    deltaCMax = delta*max(mAir_flow_nominal*cpAir,mWat_flow_nominal*cpWat);

    CWat_flow = mWat_flow*cpWat;
    CAir_flow = mAir_flow*cpAir;
    //CMin_flow = min(CWat_flow, CAir_flow);
    CMin_flow =Buildings.Utilities.Math.Functions.smoothMin(
      CAir_flow,
      CWat_flow,
      deltaCMin/4);
    //CMax_flow = max(CWat_flow, CAir_flow);
    CMax_flow =Buildings.Utilities.Math.Functions.smoothMax(
      CAir_flow,
      CWat_flow,
      deltaCMax/4);

  //   CMinNonZer_flow = min(mWatNonZer_flow*cpWat, mAirNonZer_flow*cpAir);
  //   CMaxNonZer_flow = max(mWatNonZer_flow*cpWat, mAirNonZer_flow*cpAir);

    CMinNonZer_flow=Buildings.Utilities.Math.Functions.smoothMax(
      CMin_flow,
      deltaCMin,
      deltaCMin/4);
    CMaxNonZer_flow =Buildings.Utilities.Math.Functions.smoothMax(
      CMax_flow,
      deltaCMax,
      deltaCMax/4);

    UA = 1/ (1 / UAAir + 1 / UAWat) "UA is for the overall coil (i.e., both sides)";
    Z = CMin_flow/CMaxNonZer_flow   "Braun 1988 eq 4.1.10";
    gai = Buildings.Utilities.Math.Functions.spliceFunction(
              pos=1,
              neg=0,
              x=CMin_flow-deltaCMin,
              deltax=deltaCMin/2);
    if (gai>=0) and (gai<=0) then
      NTU = 0;
      eps = 1; // around zero flow, eps=Q/(CMin*dT) should be one
    else
      //gai =1;
      NTU =gai*dryfraNonZero*UA/CMinNonZer_flow;
      eps = gai*Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ(
                    NTU=NTU,
                    Z=Z,
                    flowRegime=Integer(cfg));
    end if;
    // Use CMin to compute Q_flow
    QTot_flow = eps*CMin_flow*(TAirIn-TWatIn)
        "Note: positive heat transfer is air to water";
    // fixme: the next two equations are only valid if CWat >= CAir,
    // but this is not true if the water flow is small
  //   TAirOut = TAirIn + eps*(TWatIn - TAirIn)
  //       "Braun 1988 eq 4.1.8";
  //   TWatOut = TWatIn + Z*(TAirIn - TAirOut)
  //       "Braun 1988 eq 4.1.9";

    TAirOut=TAirIn-QTot_flow/(mAirNonZer_flow*cpAir);
    TWatOut=TWatIn+QTot_flow/(mWatNonZer_flow*cpWat);

    (TAirOut-TSurAirOut)*UAAir=(TSurAirOut-TWatIn)*UAWat;
  end if;


  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
April 14, 2017, by Michael Wetter:<br/>
Changed sign of heat transfer so that sensible and total heat transfer
have the same sign.
</li>
<li>
March 17, 2017, by Michael O'Keefe:<br/>
First implementation. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/622\">
issue 622</a> for more information.
</li>
</ul>
</html>", info="<html>
<p>
This model implements the calculation for a 100% dry coil.
</p>

<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.WetEffectivenessNTU</a> for documentation.
</p>
</html>"));
end DryCalcsFuzzy_V2_2_2;
