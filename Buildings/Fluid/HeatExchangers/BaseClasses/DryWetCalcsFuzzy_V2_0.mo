within Buildings.Fluid.HeatExchangers.BaseClasses;
model DryWetCalcsFuzzy_V2_0
  "Fuzzy logic for mode swtiching between dry, wet, partially wet cooling coil"

  replaceable package Medium2 = Modelica.Media.Interfaces.PartialMedium
    "Medium 2 in the component"
    annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal(min=0)
    "Nominal mass flow rate for water"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal(min=0)
    "Nominal mass flow rate for air"
    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.Temperature TWatOut_init=283.15
    "Guess value for the water outlet temperature which is an iteration variable";

  input Buildings.Fluid.Types.HeatExchangerFlowRegime cfg=
    Buildings.Fluid.Types.HeatExchangerFlowRegime.CounterFlow;

  // -- Water
  Modelica.Blocks.Interfaces.RealInput UAWat(
    final quantity="ThermalConductance",
    final unit="W/K")
    "Product of heat transfer coefficient times area for \"water\" side"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}}),
        iconTransformation(extent={{-160,100},{-140,120}})));
  Modelica.Blocks.Interfaces.RealInput mWat_flow(
    quantity="MassFlowRate",
    min = 0,
    final unit="kg/s")
    "Mass flow rate for water"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}}),
        iconTransformation(extent={{-160,80},{-140,100}})));
  Modelica.Blocks.Interfaces.RealInput cpWat(
    final quantity="SpecificHeatCapacity",
    final unit="J/(kg.K)")
    "Inlet water temperature"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}}),
        iconTransformation(extent={{-160,60},{-140,80}})));
  Modelica.Blocks.Interfaces.RealInput TWatIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 200,
    start = 288.15,
    nominal = 300,
    displayUnit="degC")
    "Inlet water temperature"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}}),
        iconTransformation(extent={{-160,40},{-140,60}})));
  // -- Air
  Modelica.Blocks.Interfaces.RealInput UAAir(
    final quantity="ThermalConductance",
    final unit="W/K")
    "Product of heat transfer coefficient times area for air side"
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}}),
        iconTransformation(extent={{-160,-120},{-140,-100}})));
  Modelica.Blocks.Interfaces.RealInput mAir_flow(
    quantity="MassFlowRate",
    min = 0,
    final unit="kg/s")
    "Mass flow rate for air"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}}),
        iconTransformation(extent={{-160,-100},{-140,-80}})));
  Modelica.Blocks.Interfaces.RealInput cpAir(
    final quantity="SpecificHeatCapacity",
    final unit="J/(kg.K)")
    "Inlet specific heat capacity (at constant pressure)"
    annotation (Placement(
        transformation(extent={{-160,-80},{-140,-60}}), iconTransformation(
          extent={{-160,-80},{-140,-60}})));
  Modelica.Blocks.Interfaces.RealInput TAirIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 200,
    start = 288.15,
    nominal = 300,
    displayUnit="degC")
    "Inlet air temperature"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}}),
        iconTransformation(extent={{-160,-60},{-140,-40}})));
  Modelica.Blocks.Interfaces.RealInput hAirIn(
    final quantity="SpecificEnergy",
    final unit="J/kg")
    "Inlet air enthalpy"
    annotation (
      Placement(transformation(extent={{-160,-40},{-140,-20}}),
        iconTransformation(extent={{-160,-40},{-140,-20}})));
  Modelica.Blocks.Interfaces.RealInput pAir(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="bar",
    min=70000,
    nominal = 1e5)
    "Inlet air absolute pressure"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}}),
        iconTransformation(extent={{-160,-20},{-140,0}})));
  Modelica.Blocks.Interfaces.RealInput wAirIn(
    min=0,
    max=1,
    unit="1")
    "Humidity ratio of water at inlet (kg water/kg moist air)"
    annotation (
      Placement(transformation(extent={{-160,0},{-140,20}}), iconTransformation(
          extent={{-160,0},{-140,20}})));

  Modelica.Blocks.Interfaces.RealOutput QTot_flow(
    final quantity="Power",
    final unit="W")
    "Total heat transfer from air into water"
    annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,-20})));
  Modelica.Blocks.Interfaces.RealOutput QSen_flow(
    final quantity="Power",
    final unit="W")
    "Sensible heat transfer from water into air"
    annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,-60})));
  Modelica.Blocks.Interfaces.RealOutput mCon_flow(
    quantity="MassFlowRate",
    final unit="kg/s")
    "Mass flow of the condensate, negative for dehumidification"
    annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,-100})));

  Modelica.SIunits.MassFlowRate mAirNonZer_flow(min=Modelica.Constants.eps)=
    Buildings.Utilities.Math.Functions.smoothMax(
      x1=mAir_flow,
      x2=1E-3       *mAir_flow_nominal,
      deltaX=0.25E-3*mAir_flow_nominal)
    "Mass flow rate of air";
  Modelica.SIunits.MassFlowRate mWatNonZer_flow(min=Modelica.Constants.eps)=
    Buildings.Utilities.Math.Functions.smoothMax(
      x1=mWat_flow,
      x2=1E-3       *mWat_flow_nominal,
      deltaX=0.25E-3*mWat_flow_nominal)
    "Mass flow rate of water";

  Buildings.Utilities.Psychrometrics.TDewPoi_pW TDewPoi_pW(
    final p_w=Buildings.Utilities.Psychrometrics.Functions.pW_X(
      X_w=wAirIn,
      p=pAir))
    "Dew point model";
  Buildings.Utilities.Psychrometrics.hSat_pTSat hSat_pTSat(
      final p=pAir,
      final TSat=TWatIn)
    "Enthalpy at saturation";

  Buildings.Fluid.HeatExchangers.BaseClasses.DryCalcs dry(
    final UAWat = UAWat,
    final fraHex = 1,
    final mWat_flow = mWat_flow,
    final cpWat = cpWat,
    final TWatIn = TWatIn,
    final UAAir = UAAir,
    final mAir_flow = mAir_flow,
    final mWatNonZer_flow = mWatNonZer_flow,
    final mAirNonZer_flow = mAirNonZer_flow,
    final cpAir = cpAir,
    final TAirIn = TAirIn,
    final cfg = cfg);
  Buildings.Fluid.HeatExchangers.BaseClasses.WetCalcs wet(
    final UAWat = UAWat,
    final fraHex = 1,
    final mWat_flow = mWat_flow,
    final cpWat = cpWat,
    final TWatIn = TWatIn,
    final TWatOutGuess = TWatOutWet,
    final UAAir = UAAir,
    final mAir_flow = mAir_flow,
    final mWatNonZer_flow = mWatNonZer_flow,
    final mAirNonZer_flow = mAirNonZer_flow,
    final cpAir = cpAir,
    final TAirIn = TAirIn,
    final pAir = pAir,
    final wAirIn = wAirIn,
    final hAirIn = hAirIn,
    final hAirSatSurIn = hAirSatSurIn,
    final cfg = cfg)
    "Calculations for wet coil";

  Buildings.Fluid.HeatExchangers.BaseClasses.DryCalcs parDry(
    final UAWat = UAWat,
    final fraHex = dryFra,
    final mWat_flow = mWat_flow,
    final cpWat = cpWat,
    final TWatIn = TWatX "if isSensible then TAirInDewPoi else TWatX",
    final UAAir = UAAir,
    final mAir_flow = mAir_flow,
    final mWatNonZer_flow = mWatNonZer_flow,
    final mAirNonZer_flow = mAirNonZer_flow,
    final cpAir = cpAir,
    final TAirIn = TAirIn "if isSensible then TAirInDewPoi else TAirIn",
    final cfg = cfg)
    "Calculations for partially dry coil";

  Buildings.Fluid.HeatExchangers.BaseClasses.WetCalcs parWet(
    final UAWat = UAWat,
    final fraHex= 1-dryFra,
    final mWat_flow = mWat_flow,
    final cpWat = cpWat,
    final TWatIn = TWatIn "if isSensible then TAirInDewPoi else TWatIn",
    final TWatOutGuess = TWatX,
    final UAAir = UAAir "if isSensible then DUMMY else UAAir",
    final mAir_flow = mAir_flow,
    final mWatNonZer_flow = mWatNonZer_flow,
    final mAirNonZer_flow = mAirNonZer_flow,
    final cpAir = cpAir,
    final TAirIn = TAirX "if isSensible then TAirInDewPoi else TAirX",
    final pAir = pAir,
    final wAirIn = wAirIn                               "wAirIn",
    final hAirIn = Medium2.specificEnthalpy_pTX(p=pAir, T=TAirX, X={wAirIn, 1 - wAirIn}) "if isSensible then DUMMY else Medium2.specificEnthalpy_pTX(p=pAir, T=TAirX, X={wAirIn, 1 - wAirIn})",
    final hAirSatSurIn = hAirSatSurIn,
    final cfg = cfg)
    "Calculations for the wet part of the coil in a partially wet coil";
   Real dryFra(min=0, max=1, final unit="1", start=0.5)
     "Dry fraction of the coil; note: this is an iteration variable and is
     not always accurate; use dryFraFin for final determination of the region";

  Modelica.SIunits.Temperature TAirInDewPoi
    "Dew point temperature of incoming air";
  Modelica.SIunits.Temperature TWatOutWet(start=TWatOut_init)
    "Water outlet temperature for a 100% wet coil";
  Modelica.SIunits.Temperature TAirOutWet
    "Water outlet temperature for a 100% wet coil";
  Modelica.SIunits.Temperature TWatX(start=TWatOut_init)
    "Water temperature at the wet/dry transition";
  Modelica.SIunits.Temperature TAirX
   "Air temperature at the wet/dry transition";
  Modelica.SIunits.SpecificEnthalpy hAirSatSurIn
    "Air enthalpy at coil surface at water inlet conditions; used in wet calcs";

  Buildings.Utilities.Psychrometrics.TDewPoi_pW TDewPoi_AirOut_pW(
    final p_w=Buildings.Utilities.Psychrometrics.Functions.pW_X(
      X_w=wet.wAirOut,
      p=pAir)); // DK: creat model instantce
  Modelica.SIunits.Temperature TAirOutDewPoi
    "Dew point temprature at air outlet";
  Real mu_CoiIn_Col;
  Real mu_CoiOut_Col;
  Real mu_CoiIn_War;
  Real mu_CoiOut_War;
  Real mu_FW, mu_FD, mu_PW, w_FW, w_FD, w_PW;
  final parameter Real TraRei=1;

equation

  TAirInDewPoi = TDewPoi_pW.T;
  TAirOutDewPoi = TDewPoi_AirOut_pW.T; //DK: added dew point temp at air outlet
  hAirSatSurIn = hSat_pTSat.hSat;
  TWatOutWet = wet.TWatOut;
  TAirOutWet = wet.TAirOut;

  TAirX = parDry.TAirOut;
  TWatX = parWet.TWatOut;

  if noEvent(wet.TWatOut <= TAirInDewPoi) then
    dryFra = 0;
  elseif noEvent(TWatIn >= TAirOutDewPoi) then
    dryFra = 1;
  else
    (TAirX - TAirInDewPoi) * UAAir = (TAirInDewPoi - TWatX) * UAWat;
  end if;

  // Fuzzy modeling
  mu_CoiIn_Col = sigmoid(x=wet.TWatOut-TAirInDewPoi,a=-1*TraRei,c=0);
  mu_CoiOut_Col= sigmoid(x=TWatIn-TAirOutDewPoi,a=-1*TraRei,c=0);
  mu_CoiIn_War = sigmoid(x=wet.TWatOut-TAirInDewPoi,a=TraRei,c=0);
  mu_CoiOut_War= sigmoid(x=TWatIn-TAirOutDewPoi,a=TraRei,c=0);
  mu_FW=mu_CoiIn_Col;
  mu_FD=mu_CoiOut_War;
  mu_PW=mu_CoiIn_War*mu_CoiOut_Col;
  w_FW=mu_FW/(mu_FW+mu_FD+mu_PW);
  w_FD=mu_FD/(mu_FW+mu_FD+mu_PW);
  w_PW=mu_PW/(mu_FW+mu_FD+mu_PW);

  QTot_flow=w_FW*wet.QTot_flow+w_FD*dry.Q_flow+w_PW*(parWet.QTot_flow + parDry.Q_flow);
  QSen_flow=w_FW*wet.QSen_flow+w_FD*dry.Q_flow+w_PW*(parWet.QSen_flow + parDry.Q_flow);
  mCon_flow=w_FW*(-wet.mCon_flow)+w_FD*0+w_PW*(-parWet.mCon_flow);

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
          extent={{120,-12},{120,-24}},
          lineColor={28,108,200},
          textString="QTot_flow"),
        Text(
          extent={{104,-94},{104,-106}},
          lineColor={28,108,200},
          textString="mCon_flow"),
        Text(
          extent={{118,-52},{118,-64}},
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
April 19, 2017, by Michael Wetter:<br/>
Renamed variables for consistency.
</li>
<li>
April 14, 2017, by Michael Wetter:<br/>
Changed sign of heat transfer so that sensible and total heat transfer
have the same sign.<br/>
Removed condensate temperature which is no longer needed.
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
This model implements the calculation for a (possibly) dry/wet coil.
Specifically, this model coordinates the 100% wet and 100% dry calculations to
represent partially wet coil physics.
</p>

<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.WetEffectivenessNTU</a> for documentation.
</p>
</html>"));
end DryWetCalcsFuzzy_V2_0;
