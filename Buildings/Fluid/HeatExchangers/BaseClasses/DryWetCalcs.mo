within Buildings.Fluid.HeatExchangers.BaseClasses;
model DryWetCalcs
  "Combines both dry and wet eff NTU calculations"

  replaceable package Medium1 = Modelica.Media.Interfaces.PartialMedium
    "Medium 1 in the component"
    annotation (choicesAllMatching = true);
  replaceable package Medium2 = Buildings.Media.Air
    "Medium 2 in the component"
    annotation (choicesAllMatching = true);

  parameter Buildings.Fluid.Types.HeatExchangerFlowRegime cfg=
    Buildings.Fluid.Types.HeatExchangerFlowRegime.CounterFlow;
  parameter Modelica.SIunits.Temperature TWatOutNominal=
    Modelica.SIunits.Conversions.from_degC(8.7333)
    "Guess for the water outlet temperature which is an iteration variable";

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

  Buildings.Utilities.Psychrometrics.TDewPoi_pW TDewPoi_pW(
    p_w=Buildings.Utilities.Psychrometrics.Functions.pW_X(X_w=wAirIn, p=pAir));
  Buildings.Utilities.Psychrometrics.hSat_pTSat hSat_pTSat(
    p=pAir, TSat=TWatIn);
  Buildings.Fluid.HeatExchangers.BaseClasses.DryCalcs dry(
    UAWat = UAWat,
    masFloWat = masFloWat,
    cpWat = cpWat,
    TWatIn = TWatIn,
    UAAir = UAAir,
    masFloAir = masFloAir,
    cpAir = cpAir,
    TAirIn = TAirIn,
    cfg = cfg);
  Buildings.Fluid.HeatExchangers.BaseClasses.WetCalcs wet(
    redeclare package Medium1 = Medium1,
    UAWat = if noEvent(TWatIn >= TAirIn or TAirInDewPoi <= TDewPoiA)
            then DUMMY
            else UAWat,
    masFloWat = masFloWat,
    cpWat = cpWat,
    TWatIn = TWatIn,
    TWatOutGuess = TWatOutWet,
    UAAir = if noEvent(TWatIn >= TAirIn or TAirInDewPoi <= TDewPoiA)
            then DUMMY
            else UAAir,
    masFloAir = masFloAir,
    cpAir = cpAir,
    TAirIn = TAirIn,
    pAir = pAir,
    wAirIn = wAirIn,
    hAirIn = hAirIn,
    hAirSatSurIn = hAirSatSurIn,
    cfg = cfg);
  Buildings.Fluid.HeatExchangers.BaseClasses.DryCalcs parDry(
    UAWat = if noEvent(TWatIn >= TAirIn or TAirInDewPoi >= TDewPoiB
              or TAirInDewPoi <= TDewPoiA)
            then DUMMY
            else UAWat * dryFra,
    masFloWat = masFloWat,
    cpWat = cpWat,
    TWatIn = if noEvent(TWatIn >= TAirIn or TAirInDewPoi >= TDewPoiB
              or TAirInDewPoi <= TDewPoiA)
             then TAirInDewPoi
             else TWatX,
    UAAir = if noEvent(TWatIn >= TAirIn or TAirInDewPoi >= TDewPoiB
              or TAirInDewPoi <= TDewPoiA)
            then DUMMY
            else UAAir * dryFra,
    masFloAir = masFloAir,
    cpAir = cpAir,
    TAirIn = if noEvent(TWatIn >= TAirIn or TAirInDewPoi >= TDewPoiB
              or TAirInDewPoi <= TDewPoiA)
             then TAirInDewPoi
             else TAirIn,
    cfg = cfg);
  Buildings.Fluid.HeatExchangers.BaseClasses.WetCalcs parWet(
    redeclare package Medium1 = Medium1,
    UAWat = if noEvent(TWatIn >= TAirIn or TAirInDewPoi >= TDewPoiB
              or TAirInDewPoi <= TDewPoiA)
            then DUMMY
            else UAWat * (1 - dryFra),
    masFloWat = masFloWat,
    cpWat = cpWat,
    TWatIn = if noEvent(TWatIn >= TAirIn or TAirInDewPoi >= TDewPoiB
               or TAirInDewPoi <= TDewPoiA)
             then TAirInDewPoi
             else TWatIn,
    TWatOutGuess = TWatX,
    UAAir = if noEvent(TWatIn >= TAirIn or TAirInDewPoi >= TDewPoiB
              or TAirInDewPoi <= TDewPoiA)
            then DUMMY
            else UAAir * (1 - dryFra),
    masFloAir = masFloAir,
    cpAir = cpAir,
    TAirIn = if noEvent(TWatIn >= TAirIn or TAirInDewPoi >= TDewPoiB
               or TAirInDewPoi <= TDewPoiA)
             then TAirInDewPoi
             else TAirX,
    pAir = pAir,
    wAirIn = wAirIn,
    hAirIn = if noEvent(TWatIn >= TAirIn or TAirInDewPoi >= TDewPoiB
               or TAirInDewPoi <= TDewPoiA)
             then DUMMY
             else Medium2.specificEnthalpy_pTX(
                    p=pAir, T=TAirX, X={wAirIn, 1 - wAirIn}),
    hAirSatSurIn = hAirSatSurIn,
    cfg = cfg)
    "Calculations for the wet part of the coil in a partially wet coil";

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
  // - Partially wet / Partially dry coil
  Modelica.SIunits.HeatFlowRate QSenDryPar
    "Sensible heat transferred from 'water' to 'air' for the dry part of
    a partially wet coil";
  Medium1.Temperature TWatOutPar
    "Water outlet temperature";
  Medium2.Temperature TWatX(start=TWatOutNominal)
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
  Modelica.SIunits.MassFlowRate masFloConPar
    "Mass flow of condensate in a wet/dry coil. A positive number for flow.";
  Modelica.SIunits.Temperature TConPar
    "Temperature of condensate in a wet/dry coil";
  constant Real DUMMY = 0
    "Used to 'switch off' the dry / wet coil calculation functions";
  Modelica.SIunits.SpecificEnthalpy hAirSatSurIn
    "Air enthalpy at coil surface at water inlet conditions; used in wet calcs";

equation
  TAirInDewPoi = TDewPoi_pW.T;
  hAirSatSurIn = hSat_pTSat.hSat;
  QSenDry = dry.Q;
  TWatOutDry = dry.TWatOut;
  TAirOutDry = dry.TAirOut;
  // Find TDewPoiA, the incoming air dew point temperature that would put us
  // at the point where dryFra just becomes 1; i.e., 100% dry coil.
  (TAirOutDry - TDewPoiA) * UAAir = (TDewPoiA - TWatIn) * UAWat;
  QTotWet = wet.QTot;
  QSenWet = wet.QSen;
  TWatOutWet = wet.TWatOut;
  TAirOutWet = wet.TAirOut;
  masFloConWet = wet.masFloCon;
  TConWet = wet.TCon;
  // Find TDewPoiB, the incoming air dew point temperature that would put us
  // at the point where dryFra just becomes 0; i.e., 100% wet coil.
  (TAirIn - TDewPoiB) * UAAir = (TDewPoiB - TWatOutWet) * UAWat;
  QSenDryPar = parDry.Q;
  TWatOutPar = parDry.TWatOut;
  TAirX = parDry.TAirOut;
  QTotWetPar = parWet.QTot;
  QSenWetPar = parWet.QSen;
  TWatX = parWet.TWatOut;
  TAirOutPar = parWet.TAirOut;
  masFloConPar = parWet.masFloCon;
  TConPar = parWet.TCon;
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
    (TAirX - TAirInDewPoi) * UAAir = (TAirInDewPoi - TWatX) * UAWat;
    QTot = QTotWetPar + (-QSenDryPar);
    QSen = QSenDryPar + QSenWetPar;
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
connections to show graphically here")}),
    Documentation(revisions="<html>
<ul>
<li>
March 17, 2017, by Michael O'Keefe:<br/>
First implementation. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/622\">
issue 622</a> for more information.
</li>
</ul>
</html>", info="<html>
<p>
This model implements the calculation for a (possibly) dry/wet coil.
Specifically, this model coordinates the 100% wet and 100% dry calculations to
represent partially wet coil physics.
</p>

<p>
Extensive documentation can be found in the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetEffectivenessNTU\">
WetEffectivenessNTU</a> model. 
</p>
</html>"));
end DryWetCalcs;
