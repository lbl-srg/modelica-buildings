within Buildings.Fluid.HeatExchangers.BaseClasses;
model DryWetCalcs2 "Second attempt to make drywet calcs faster"
  replaceable package Medium1 =
      Modelica.Media.Interfaces.PartialMedium
      "Medium 1 in the component"
      annotation (choicesAllMatching = true);
      /*
  replaceable package Medium2 =
      Modelica.Media.Interfaces.PartialCondensingGases
      "Medium 2 in the component"
      annotation (choicesAllMatching = true);
      */
  replaceable package Medium2 = Buildings.Media.Air;
  //replaceable package Medium2 = Modelica.Media.Interfaces.PartialMedium;

  // PARAMETERS
  parameter Modelica.SIunits.Temperature TWatOutNominal=
    Modelica.SIunits.Conversions.from_degF(44)
    "Guess for the water outlet temperature which is an iteration variable";
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration cfg=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow;

  // INPUTS
  // -- Water
  Modelica.Blocks.Interfaces.RealInput UAWat(
    final quantity="ThermalConductance", final unit="W/K")
    "product of heat transfer coefficient times area for \"water\" side"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}}),
        iconTransformation(extent={{-140,100},{-120,120}})));
  Modelica.Blocks.Interfaces.RealInput masFloWat(
    quantity="MassFlowRate", final unit="kg/s")
    "mass flow rate for water"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}}),
        iconTransformation(extent={{-140,80},{-120,100}})));
  Modelica.Blocks.Interfaces.RealInput cpWat(
    final quantity="SpecificHeatCapacity", final unit="J/(kg.K)")
    "inlet water temperature"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}}),
        iconTransformation(extent={{-140,60},{-120,80}})));
  Modelica.Blocks.Interfaces.RealInput TWatIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 0.0,
    start = 288.15,
    nominal = 300,
    displayUnit="degC")
    "inlet water temperature"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}}),
        iconTransformation(extent={{-140,40},{-120,60}})));

  // -- Air
  Modelica.Blocks.Interfaces.RealInput UAAir(
    final quantity="ThermalConductance", final unit="W/K")
    "product of heat transfer coefficient times area for \"air\" side"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}}),
        iconTransformation(extent={{-140,-120},{-120,-100}})));
  Modelica.Blocks.Interfaces.RealInput masFloAir(
    quantity="MassFlowRate", final unit="kg/s")
    "mass flow rate for air"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}}),
        iconTransformation(extent={{-140,-100},{-120,-80}})));
  Modelica.Blocks.Interfaces.RealInput cpAir(
    final quantity="SpecificHeatCapacity", final unit="J/(kg.K)")
    "inlet specific heat capacity (at constant pressure)"
    annotation (Placement(
        transformation(extent={{-140,-80},{-120,-60}}), iconTransformation(
          extent={{-140,-80},{-120,-60}})));
  Modelica.Blocks.Interfaces.RealInput TAirIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 0.0,
    start = 288.15,
    nominal = 300,
    displayUnit="degC")
    "inlet air temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}}),
        iconTransformation(extent={{-140,-60},{-120,-40}})));
  Modelica.Blocks.Interfaces.RealInput hAirIn(
    final quantity="SpecificEnergy", final unit="J/kg")
    "inlet air enthalpy"
    annotation (
      Placement(transformation(extent={{-140,-40},{-120,-20}}),
        iconTransformation(extent={{-140,-40},{-120,-20}})));
  Modelica.Blocks.Interfaces.RealInput pAir(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="bar",
    min=0.0,
    nominal = 1e5)
    "inlet air absolute pressure"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}}),
        iconTransformation(extent={{-140,-20},{-120,0}})));
  Modelica.Blocks.Interfaces.RealInput wAirIn(
    min=0,max=1)
    "humidity ratio of water at inlet (kg water/kg moist air)"
    annotation (
      Placement(transformation(extent={{-140,0},{-120,20}}), iconTransformation(
          extent={{-140,0},{-120,20}})));

  // OUTPUTS
  Modelica.Blocks.Interfaces.RealOutput QTot(
    final quantity="Power", final unit="W")
    "total heat transfer from air into water"
    annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,110}),                                    iconTransformation(
          extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,110})));
  Modelica.Blocks.Interfaces.RealOutput QSen(
    final quantity="Power", final unit="W")
    "sensible heat transfer from water into air"
    annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-110}),                                   iconTransformation(
          extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-110})));
  Modelica.Blocks.Interfaces.RealOutput masFloCon(
    quantity="MassFlowRate", final unit="kg/s")
    "mass flow of the condensate (positive is into the heat exchanger, negative
    is out; therefore, should always be negative or zero since we can't
    humidify, only dehumidify)"
    annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,-110}),                                  iconTransformation(
          extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,-110})));
  Modelica.Blocks.Interfaces.RealOutput TCon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 0.0,
    start = 288.15,
    nominal = 300,
    displayUnit="degC")
    "temperature of the condensate"
    annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,-110}),                                   iconTransformation(
          extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-110})));

  // COMPONENTS
  Buildings.Utilities.Psychrometrics.TDewPoi_pX TDewPoi_pX(
    p=pAir, XSat=wAirIn)
    annotation (Placement(transformation(extent={{60,-80},{120,-20}})));

  // VARIABLES
  Real dryFra(min=0, max=1, unit="1")
    "Dry fraction of the coil; note: this is an iteration variable and is
    not always accurate; use dryFraFin for final determination of the region";
  Medium2.Temperature TAirInDewPoi
    "Dew point temperature of incoming air";
  Medium2.Temperature TDewPoiA
    "Dew point at the 100% Dry to partial wet/partial dry interface
    (i.e., exactly where dryFra becomes 1)";
  Medium2.Temperature TDewPoiB
    "Dew point at the partial wet/partial dry to 100% wet interface
    (i.e., exactly where dryFra becomes 0)";
  // - 100% dry coil
  Modelica.SIunits.HeatFlowRate QSenDry
    "Heat transferred 'water' to 'air' for a 100% dry coil";
  Medium1.Temperature TWatOutDry
    "Water outlet temperature for a 100% dry coil";
  Medium2.Temperature TAirOutDry
    "Water outlet temperature for a 100% dry coil";
  Medium2.Temperature TSurAirOutDry
    "Air-side coil temperature at outlet for a 100% dry coil";
  // - 100% wet coil
  Modelica.SIunits.HeatFlowRate QTotWet
    "Heat transferred 'air' to 'water' for a 100% wet coil";
  Modelica.SIunits.HeatFlowRate QSenWet
    "Heat transferred 'water' to 'air' for a 100% wet coil";
  Medium1.Temperature TWatOutWet(start=TWatOutNominal)
    "Water outlet temperature for a 100% wet coil";
  Medium2.Temperature TAirOutWet
    "Water outlet temperature for a 100% wet coil";
  Modelica.SIunits.MassFlowRate masFloConWet
    "Mass flow of condensate for a 100% wet coil; a positive number or zero.";
  Modelica.SIunits.Temperature TConWet
    "Temperature of condensate for a 100% wet coil";
  Modelica.SIunits.AbsolutePressure pSatWatInWet
    "Saturation pressure of water vapor at inlet";
  Modelica.SIunits.MassFraction XAirSatInWet[2]
    "Mass fractions of components at inlet";
  Modelica.SIunits.MassFraction wAirOutWet
    "Mass fraction of water in air at outlet";
  Modelica.SIunits.SpecificEnthalpy hAirSatSurInWet
    "Specific enthalpy of saturated air at inlet at coil surface";
  Modelica.SIunits.SpecificEnthalpy hAirOutWet
    "Specific enthalpy of air outlet";
  Modelica.SIunits.SpecificEnthalpy hSurEffWet
    "Effective surface enthalpy; assumes coil surface is at a uniform
    temperature and enthalpy";
  Real NtuAirSta
    "Ntu for the air-side for 100% wet";
  Modelica.SIunits.Temperature TSurEffWet
    "Effective surface temperature of the coil";
  Modelica.SIunits.AbsolutePressure pSatOutWet
    "Saturation pressure at air outlet conditions";
  Modelica.SIunits.MassFraction XOutWet[2]
    "Mass fraction of air at outlet";
  constant Real DUMMY = 0
    "Used to 'switch off' the dry / wet coil calculation functions";

protected
  constant Integer watIdx = 1
    "Index of Water for Air medium";
  constant Integer othIdx = 2
    "Index of Other component of Air medium";
  constant Real phiSat = 1
    "Relative humidity at saturation";

equation
  TAirInDewPoi = TDewPoi_pX.TDewPoi;
  (QSenDry, TWatOutDry, TAirOutDry, TSurAirOutDry) =
    Buildings.Fluid.HeatExchangers.BaseClasses.dryCoil(
      UAWat = UAWat,
      masFloWat = masFloWat,
      cpWat = cpWat,
      TWatIn = TWatIn,
      UAAir = UAAir,
      masFloAir = masFloAir,
      cpAir = cpAir,
      TAirIn = TAirIn,
      cfg = cfg);
  // Find TDewPoiA, the incoming air dew point temperature that would put us
  // at the point where dryFra just becomes 1; i.e., 100% dry coil.
  (TAirOutDry - TDewPoiA) * UAAir = (TDewPoiA - TWatIn) * UAWat;
  pSatWatInWet =
    Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TWatIn);
  XAirSatInWet[watIdx] = Buildings.Utilities.Psychrometrics.Functions.X_pW(
    p_w=pSatWatInWet, p=pAir);
  XAirSatInWet[othIdx] =  1 - XAirSatInWet[watIdx];
  hAirSatSurInWet = Buildings.Media.Air.specificEnthalpy_pTX(
    p=pAir, T=TWatIn, X=XAirSatInWet);
  // Note: by setting UA values to zero below, we "short circuit"
  // the following functions so, although we have the cost of calling
  // the function, there should be no iteration and no calculation.
  (QTotWet, TWatOutWet) =
    Buildings.Fluid.HeatExchangers.BaseClasses.wetCoilInitial(
      UAWat = if noEvent(TWatIn >= TAirIn or TAirInDewPoi <= TDewPoiA) then DUMMY else UAWat,
      masFloWat = masFloWat,
      cpWat = cpWat,
      TWatIn = TWatIn,
      TWatOutGuess = TWatOutWet,
      UAAir = if noEvent(TWatIn >= TAirIn or TAirInDewPoi <= TDewPoiA) then DUMMY else UAAir,
      masFloAir = masFloAir,
      cpAir = cpAir,
      TAirIn = TAirIn,
      pAir = pAir,
      hAirIn = hAirIn,
      hAirSatSurIn = hAirSatSurInWet,
      cfg = cfg);
  hAirOutWet = hAirIn - (QTotWet / masFloAir);
  NtuAirSta = UAAir / (masFloAir * cpAir);
  hSurEffWet = hAirIn + (hAirOutWet - hAirIn) / (1 - exp(-NtuAirSta));
  // The effective surface temperature Ts,eff or TSurEff is the saturation
  // temperature at the value of an effective surface enthalpy, hs,eff or
  // hSurEff, which is given by the relation similar to that for temperature.
  TSurEffWet = Buildings.Utilities.Psychrometrics.Functions.TSat_ph(
    p=pAir, h=hSurEffWet);
  TAirOutWet = TSurEffWet + (TAirIn - TSurEffWet) * exp(-NtuAirSta);
  pSatOutWet = Buildings.Media.Air.saturationPressure(TAirOutWet);
  XOutWet[watIdx] = Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
    pSat=pSatOutWet, p=pAir, phi=phiSat);
  XOutWet[othIdx] = 1 - XOutWet[watIdx];
  wAirOutWet = XOutWet[watIdx];
  masFloConWet =  masFloAir * (wAirIn - wAirOutWet);
  QSenWet =
    -(QTotWet - (masFloCon * Buildings.Media.Air.enthalpyOfLiquid(TSurEffWet)));
  TConWet = TSurEffWet;
  // Find TDewPoiB, the incoming air dew point temperature that would put us
  // at the point where dryFra just becomes 0; i.e., 100% wet coil.
  (TAirIn - TDewPoiB) * UAAir = (TDewPoiB - TWatOutWet) * UAWat;
  if noEvent(TWatIn >= TAirIn or TAirInDewPoi <= TDewPoiA) then
    dryFra = 1;
    QTot = -QSenDry;
    QSen = QSenDry;
    masFloCon = 0;
    TCon = TConWet;
  elseif noEvent(TAirInDewPoi >= TDewPoiB) then
    dryFra = 0;
    QTot = QTotWet;
    QSen = QSenWet;
    masFloCon = -masFloConWet;
    TCon = TConWet;
  else
    dryFra = 0.5; // placeholder
    if noEvent(QTotWet > 0 and QTotWet > (-QSenDry)) then
      QTot = QTotWet;
      QSen = QSenWet;
      masFloCon = -masFloConWet;
      TCon = TConWet;
    else
      QTot = -QSenDry;
      QSen = QSenDry;
      masFloCon = 0;
      TCon = TConWet;
    end if;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},
            {140,120}}), graphics={
        Rectangle(
          extent={{-140,120},{140,-120}},
          lineColor={0,0,0},
          lineThickness=0.5,
          pattern=LinePattern.Dot,
          fillColor={236,236,236},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,40},{100,-40}},
          lineColor={28,108,200},
          fillColor={170,227,255},
          fillPattern=FillPattern.Forward),
        Text(
          extent={{24,36},{96,2}},
          textStyle={TextStyle.Bold},
          pattern=LinePattern.None,
          textString="WET",
          lineColor={0,0,0}),
        Line(
          points={{20,0},{120,0}},
          color={28,108,200},
          thickness=1,
          pattern=LinePattern.Dash),
        Ellipse(
          extent={{72,0},{66,-6}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{82,-4},{76,-10}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{96,0},{88,-8}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{64,-4},{58,-10}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{54,0},{48,-6}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{42,-4},{36,-10}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{32,0},{24,-8}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,40},{20,-40}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Forward),
        Text(
          extent={{-16,-4},{56,-38}},
          textStyle={TextStyle.Bold},
          textString="CALCS",
          pattern=LinePattern.None),
        Line(
          points={{-80,0},{20,0}},
          color={28,108,200},
          thickness=1,
          pattern=LinePattern.Dash),
        Text(
          extent={{-56,36},{16,2}},
          textStyle={TextStyle.Bold},
          textString="DRY",
          pattern=LinePattern.None),
        Text(
          extent={{-22,60},{58,40}},
          lineColor={28,108,200},
          fillColor={170,170,255},
          fillPattern=FillPattern.Forward,
          textString="Water",
          textStyle={TextStyle.Italic}),
        Text(
          extent={{-20,-40},{60,-60}},
          lineColor={28,108,200},
          fillColor={170,170,255},
          fillPattern=FillPattern.Forward,
          textString="Air",
          textStyle={TextStyle.Italic}),
        Text(
          extent={{-116,-104},{-116,-116}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="hA"),
        Text(
          extent={{-116,116},{-116,104}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="hA"),
        Text(
          extent={{-116,96},{-116,84}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="masFlo"),
        Text(
          extent={{-116,76},{-116,64}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="cp"),
        Text(
          extent={{-116,56},{-116,44}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="T_in"),
        Text(
          extent={{-116,-84},{-116,-96}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="masFlo"),
        Text(
          extent={{-116,-64},{-116,-76}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="cp"),
        Text(
          extent={{-116,-44},{-116,-56}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="T_in"),
        Text(
          extent={{-116,-24},{-116,-36}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="h_in"),
        Text(
          extent={{-116,-4},{-116,-16}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="p_in"),
        Text(
          extent={{-116,16},{-116,4}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="w_in"),
        Text(
          extent={{60,96},{60,84}},
          lineColor={28,108,200},
          textString="QTot"),
        Text(
          extent={{20,-84},{20,-96}},
          lineColor={28,108,200},
          textString="mCon"),
        Text(
          extent={{60,-84},{60,-96}},
          lineColor={28,108,200},
          textString="TCon"),
        Text(
          extent={{100,-84},{100,-96}},
          lineColor={28,108,200},
          textString="QSen")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,120}}),
        graphics={Text(
          extent={{-100,120},{-20,80}},
          lineColor={28,108,200},
          fillColor={170,227,255},
          fillPattern=FillPattern.Forward,
          horizontalAlignment=TextAlignment.Left,
          textString="Note: please see text file for explicit
connections; there are too many
connections to show graphically here")}));
end DryWetCalcs2;
