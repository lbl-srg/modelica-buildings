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
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration cfg=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow;
  parameter Modelica.SIunits.Temperature TWatOutNominal=
    Modelica.SIunits.Conversions.from_degF(44)
    "Guess for the water outlet temperature which is an iteration variable";

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
  Real dryFraFin(min=0, max=1, unit="1")
    "Final dry fraction of the coil";
  Real dryFra(min=0, max=1, unit="1", start=0.5)
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
  Real NtuWat
    "";
  Real NtuAir
    "";
  Real NtuDry
    "";
  Real CSta
    "";
  // - 100% wet coil
  Modelica.SIunits.HeatFlowRate QTotWet
    "Heat transferred 'air' to 'water' for a 100% wet coil";
  Modelica.SIunits.HeatFlowRate QSenWet
    "Heat transferred 'water' to 'air' for a 100% wet coil";
  Medium1.Temperature TWatOutWet
    "Water outlet temperature for a 100% wet coil";
  Medium2.Temperature TAirOutWet
    "Water outlet temperature for a 100% wet coil";
  Medium2.Temperature TSurAirInWet
    "Air-side coil temperature at outlet for a 100% wet coil";
  Modelica.SIunits.MassFlowRate masFloConWet
    "Mass flow of condensate for a 100% wet coil; a positive number or zero.";
  Modelica.SIunits.Temperature TConWet
    "Temperature of condensate for a 100% wet coil";
  // - Partially wet / Partially dry coil
  Modelica.SIunits.HeatFlowRate QSenDryPar
    "Sensible heat transferred from 'water' to 'air' for the dry part of
    a partially wet coil";
  Medium1.Temperature TWatOutPar
    "Water outlet temperature";
  Medium2.Temperature TWatX
    "Water temperature at the wet/dry transition";
  Medium2.Temperature TAirX
    "Air temperature at the wet/dry transition";
  Medium2.Temperature TAirOutPar
    "Air outlet temperature for a partially wet/dry coil";
  Modelica.SIunits.HeatFlowRate QTotWetPar
    "Total heat transferred from 'air' to 'water' for a partially wet coil";
  Modelica.SIunits.HeatFlowRate QSenWetPar
    "Sensible heat transferred from 'water' to 'air' for the wet part of
    a partially wet coil";
  Medium2.Temperature TSurAirInWetPar
    "The coil surface at the air inlet to the wet coil in a partially wet coil";
  Medium2.Temperature TSurAirOutPar
    "The coil surface at the air outlet from the dry section in a wet/dry coil";
  Modelica.SIunits.MassFlowRate masFloConPar
    "Mass flow of condensate in a wet/dry coil. A positive number for flow.";
  Modelica.SIunits.Temperature TConPar
    "Temperature of condensate in a wet/dry coil";
  constant Real DUMMY = 0
    "Used to 'switch off' the dry / wet coil calculation functions";

equation
  TAirInDewPoi = TDewPoi_pX.TDewPoi;
  (QSenDry, TWatOutDry, TAirOutDry, TSurAirOutDry,
    NtuWat, NtuAir, NtuDry, CSta) =
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
  // We are in the all-dry regime if:
  // - we are not cooling (i.e., we are heating (TWatIn >= TAirIn))
  // - the water inlet temperature is greater than the inlet air dew point
  //   since we can never cool the air stream to the water inlet temperature
  //   we know we can never condense
  // - the coil surface at outlet is greater than inlet air dew point
  //   since the coldest part of the coil will be at outlet and if it is not
  //   below the dew point, then we would not condense
  // - the inlet air dew point temperature is <= TDewPoiA, since TDewPoiA
  //   is the trigger point to start condensation
  // Note: by setting UA values to zero below, we "short circuit"
  // the following functions so, although we have the cost of calling
  // the function, there should be no iteration and no calculation.
  (QTotWet, QSenWet, TWatOutWet, TAirOutWet, TSurAirInWet,
    masFloConWet, TConWet) =
    Buildings.Fluid.HeatExchangers.BaseClasses.wetCoil(
      UAWat = if noEvent(TWatIn >= TAirIn
    or TWatIn > TAirInDewPoi
    or TSurAirOutDry > TAirInDewPoi
    or TAirInDewPoi <= TDewPoiA) then DUMMY else UAWat,
      masFloWat = masFloWat,
      cpWat = cpWat,
      TWatIn = TWatIn,
      TWatOutGuess = TWatOutWet,
      UAAir = if noEvent(TWatIn >= TAirIn
    or TWatIn > TAirInDewPoi
    or TSurAirOutDry > TAirInDewPoi
    or TAirInDewPoi <= TDewPoiA) then DUMMY else UAAir,
      masFloAir = masFloAir,
      cpAir = cpAir,
      TAirIn = TAirIn,
      pAir = pAir,
      wAirIn = wAirIn,
      hAirIn = hAirIn,
      cfg = cfg);
  // Find TDewPoiB, the incoming air dew point temperature that would put us
  // at the point where dryFra just becomes 0; i.e., 100% wet coil.
  (TAirIn - TDewPoiB) * UAAir = (TDewPoiB - TWatOutWet) * UAWat;
  // We are 100% wet if:
  // - the incoming air dew point is greater than or equal to the trigger
  //   dew point at dryFra = 0
  // - and we are not heating
  // The use of TAirInDewPoi below as the "then clause" is so the equation
  // below the two function calls "(TAirX - TAirInDewPoi) ..." will
  // gracefully degrade and still be true when we short circuit the following
  // code where we solve for the partially wet/ partially dry region.
  (QSenDryPar, TWatOutPar, TAirX, TSurAirOutPar) =
    Buildings.Fluid.HeatExchangers.BaseClasses.dryCoil(
      UAWat = if noEvent((TAirInDewPoi >= TDewPoiB and TWatIn < TAirIn) or TWatIn >= TAirIn
    or TWatIn > TAirInDewPoi
    or TSurAirOutDry > TAirInDewPoi
    or TAirInDewPoi <= TDewPoiA or TWatIn >= TAirIn)
              then DUMMY
              else UAWat * dryFra,
      masFloWat = masFloWat,
      cpWat = cpWat,
      TWatIn = if noEvent((TAirInDewPoi >= TDewPoiB and TWatIn < TAirIn) or TWatIn >= TAirIn
    or TWatIn > TAirInDewPoi
    or TSurAirOutDry > TAirInDewPoi
    or TAirInDewPoi <= TDewPoiA or TWatIn >= TAirIn)
               then TAirInDewPoi
               else TWatX,
      UAAir = if noEvent((TAirInDewPoi >= TDewPoiB and TWatIn < TAirIn) or TWatIn >= TAirIn
    or TWatIn > TAirInDewPoi
    or TSurAirOutDry > TAirInDewPoi
    or TAirInDewPoi <= TDewPoiA or TWatIn >= TAirIn)
              then DUMMY
              else UAAir * dryFra,
      masFloAir = masFloAir,
      cpAir = cpAir,
      TAirIn = if noEvent((TAirInDewPoi >= TDewPoiB and TWatIn < TAirIn) or TWatIn >= TAirIn
    or TWatIn > TAirInDewPoi
    or TSurAirOutDry > TAirInDewPoi
    or TAirInDewPoi <= TDewPoiA or TWatIn >= TAirIn)
               then TAirInDewPoi
               else TAirIn,
      cfg = cfg);
  (QTotWetPar, QSenWetPar, TWatX, TAirOutPar, TSurAirInWetPar,
    masFloConPar, TConPar) =
    Buildings.Fluid.HeatExchangers.BaseClasses.wetCoil(
      UAWat = if noEvent((TAirInDewPoi >= TDewPoiB and TWatIn < TAirIn) or TWatIn >= TAirIn
    or TWatIn > TAirInDewPoi
    or TSurAirOutDry > TAirInDewPoi
    or TAirInDewPoi <= TDewPoiA or TWatIn >= TAirIn)
              then DUMMY
              else UAWat * (1 - dryFra),
      masFloWat = masFloWat,
      cpWat = cpWat,
      TWatIn = if noEvent((TAirInDewPoi >= TDewPoiB and TWatIn < TAirIn) or TWatIn >= TAirIn
    or TWatIn > TAirInDewPoi
    or TSurAirOutDry > TAirInDewPoi
    or TAirInDewPoi <= TDewPoiA or TWatIn >= TAirIn)
               then TAirInDewPoi
               else TWatIn,
      TWatOutGuess = TWatX,
      UAAir = if noEvent((TAirInDewPoi >= TDewPoiB and TWatIn < TAirIn) or TWatIn >= TAirIn
    or TWatIn > TAirInDewPoi
    or TSurAirOutDry > TAirInDewPoi
    or TAirInDewPoi <= TDewPoiA or TWatIn >= TAirIn)
              then DUMMY
              else UAAir * (1 - dryFra),
      masFloAir = masFloAir,
      cpAir = cpAir,
      TAirIn = if noEvent((TAirInDewPoi >= TDewPoiB and TWatIn < TAirIn) or TWatIn >= TAirIn
    or TWatIn > TAirInDewPoi
    or TSurAirOutDry > TAirInDewPoi
    or TAirInDewPoi <= TDewPoiA or TWatIn >= TAirIn)
               then TAirInDewPoi
               else TAirX,
      pAir = pAir,
      wAirIn = wAirIn,
      hAirIn = if noEvent((TAirInDewPoi >= TDewPoiB and TWatIn < TAirIn) or TWatIn >= TAirIn
    or TWatIn > TAirInDewPoi
    or TSurAirOutDry > TAirInDewPoi
    or TAirInDewPoi <= TDewPoiA or TWatIn >= TAirIn)
               then DUMMY
               else
                 Medium2.specificEnthalpy_pTX(
                   p=pAir, T=TAirX, X={wAirIn, 1 - wAirIn}),
      cfg = cfg);
  (TAirX - TAirInDewPoi) * UAAir = (TAirInDewPoi - TWatX) * UAWat;
  if noEvent(TWatIn >= TAirIn
    or TWatIn > TAirInDewPoi
    or TSurAirOutDry > TAirInDewPoi
    or TAirInDewPoi <= TDewPoiA or dryFra >= 1) then
    dryFraFin = 1;
    QTot = -QSenDry;
    QSen = QSenDry;
    masFloCon = 0;
    TCon = TConWet;
  elseif noEvent((TAirInDewPoi >= TDewPoiB and TWatIn < TAirIn) or dryFra <= 0) then
    dryFraFin = 0;
    QTot = QTotWet;
    QSen = QSenWet;
    /*
    -(QTotWet - masFloConWet * Medium2.enthalpyOfVaporization(TConWet));
    */
    masFloCon = -masFloConWet;
    TCon = TConWet;
  else
    dryFraFin = dryFra;
    QTot = QTotWetPar + (-QSenDryPar);
    // Note: QSenDryPar is negative, thus the expression below adds the heat
    // transfers to estimate a sensible heat transfer amount
    QSen = QSenDryPar + QSenWetPar;
    /*
    QSenDryPar
    - (QTotWetPar - masFloConPar * Medium2.enthalpyOfVaporization(TConWet));
    */
    masFloCon = -masFloConPar;
    TCon = TConPar;
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
