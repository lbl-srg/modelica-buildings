within Buildings.Fluid.HeatExchangers.BaseClasses;
model DryWetCalcsFuzzy_V2_2_4
  "V2_2 starts with making an extension function while V2_2_2 doesn't relies on it."
  input Real Qfac;
  replaceable package Medium2 = Modelica.Media.Interfaces.PartialMedium
    "Medium 2 in the component"
    annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal(min=0)
    "Nominal mass flow rate for water"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal(min=0)
    "Nominal mass flow rate for air"
    annotation(Dialog(group = "Nominal condition"));

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
    "Total heat transfer from water into air, negative for cooling"
    annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,-20})));
  Modelica.Blocks.Interfaces.RealOutput QSen_flow(
    final quantity="Power",
    final unit="W")
    "Sensible heat transfer from water into air, negative for cooling"
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

  Modelica.SIunits.Temperature TAirInDewPoi
    "Dew point temperature of incoming air";

  Buildings.Utilities.Psychrometrics.pW_X pWIn(X_w=wAirIn,p_in=pAir);
  Buildings.Utilities.Psychrometrics.TDewPoi_pW TDewIn(p_w=pWIn.p_w);

  Modelica.SIunits.HeatFlowRate QLat_flow;

  //-- parameters for fuzzy logics
  Real mu_CoiIn_Col;
  Real mu_CoiOut_Col;
  Real mu_CoiIn_War;
  Real mu_CoiOut_War;
  Real mu_FW, mu_FD, mu_PW, w_FW, w_FD, w_PW;
//   final parameter Real SigA=20;
//   final parameter Real SigC=0.4;

  Real dryfra(min=1e-3,max=1-1e-3,start=0.2);
  Modelica.SIunits.Temperature TSurTra;
  //(start=0.5*(fullydry.TSurAirOut+fullywet.TSurAirIn));
  //(start=fullywet.TSurAirIn);
  //start=0.5*(fullydry.TSurAirOut+fullywet.TSurAirIn));
  Modelica.SIunits.HeatFlowRate parQTot_flow;
  Modelica.SIunits.HeatFlowRate parQSen_flow;

  Buildings.Fluid.HeatExchangers.BaseClasses.DryCalcsFuzzy_V2_2_2_1 fullydry(
  UAWat = UAWat,
  dryfra = 1,
  mWat_flow = mWat_flow,
  cpWat = cpWat,
  TWatIn = TWatIn,
  UAAir = UAAir,
  mAir_flow = mAir_flow,
  mWatNonZer_flow = mWatNonZer_flow,
  mAirNonZer_flow = mAirNonZer_flow,
  cpAir = cpAir,
  TAirIn = TAirIn,
  final cfg = cfg,
  mAir_flow_nominal=mAir_flow_nominal,
  mWat_flow_nominal=mWat_flow_nominal);

   //Buildings.Fluid.HeatExchangers.BaseClasses.WetcalcsFuzzy_V2_2_2 fullywet(
  Buildings.Fluid.HeatExchangers.BaseClasses.WetcalcsFuzzy_V2_2_4 fullywet(
   UAWat = UAWat,
  dryfra = 0,
  mWat_flow = mWat_flow,
  cpWat = cpWat,
  TWatIn = TWatIn,
  UAAir = UAAir,
  mAir_flow = mAir_flow,
  mWatNonZer_flow = mWatNonZer_flow,
  mAirNonZer_flow = mAirNonZer_flow,
  cpAir = cpAir,
  TAirIn = TAirIn,
  final cfg = cfg,
  mAir_flow_nominal=mAir_flow_nominal,
  mWat_flow_nominal=mWat_flow_nominal,
  pAir=pAir,wAirIn=wAirIn);

  Buildings.Fluid.HeatExchangers.BaseClasses.DryCalcsFuzzy_V2_2_2_1 pardry(
  UAWat = UAWat,
  dryfra = dryfra,
  mWat_flow = mWat_flow,
  cpWat = cpWat,
  TWatIn = TWatInParDry,
  UAAir = UAAir,
  mAir_flow = mAir_flow,
  mWatNonZer_flow = mWatNonZer_flow,
  mAirNonZer_flow = mAirNonZer_flow,
  cpAir = cpAir,
  TAirIn = TAirIn,
  final cfg = cfg,
  mAir_flow_nominal=mAir_flow_nominal,
  mWat_flow_nominal=mWat_flow_nominal);

   Modelica.SIunits.Temperature TWatOut(start=15+273.15)
   "Water temperature at the heat exchanger outlet";
   Buildings.Fluid.HeatExchangers.BaseClasses.WetcalcsFuzzy_V2_2_4 parwet(
   UAWat = UAWat,
   dryfra = dryfra,
   mWat_flow = mWat_flow,
   cpWat = cpWat,
   TWatIn = TWatIn,
   UAAir = UAAir,
   mAir_flow = mAir_flow,
   mWatNonZer_flow = mWatNonZer_flow,
   mAirNonZer_flow = mAirNonZer_flow,
   cpAir = cpAir,
   TAirIn = TAirInParWet,
   final cfg = cfg,
   mAir_flow_nominal=mAir_flow_nominal,
   mWat_flow_nominal=mWat_flow_nominal,
   pAir=pAir,wAirIn=wAirIn);

/*   Modelica.SIunits.Temperature TWatOut0(start=15+273.15);
  Buildings.Fluid.HeatExchangers.BaseClasses.WetcalcsFuzzy_V2_2_2_ parwet(
  UAWat = UAWat,
  dryfra = dryfra,
  mWat_flow = mWat_flow,
  cpWat = cpWat,
  TWatIn = TWatIn,
  UAAir = UAAir,
  mAir_flow = mAir_flow,
  mWatNonZer_flow = mWatNonZer_flow,
  mAirNonZer_flow = mAirNonZer_flow,
  cpAir = cpAir,
  TAirIn = TAirInParWet,
  final cfg = cfg,
  TWatOut0= TWatOut0,
  mAir_flow_nominal=mAir_flow_nominal,
  mWat_flow_nominal=mWat_flow_nominal,
  pAir=pAir,wAirIn=wAirIn); */

  Modelica.SIunits.Temperature TAirInParWet;
  Modelica.SIunits.Temperature TWatInParDry;


equation

  TAirInDewPoi =   TDewIn.T; //DK: added dew point temp at air outlet

  // Fuzzy modeling
//   mu_CoiIn_Col = sigmoid(x=fullywet.TSurAirIn-TAirInDewPoi,a=-SigA,c=SigC);
//   mu_CoiOut_Col= sigmoid(x=fullydry.TSurAirOut-TAirInDewPoi,a=-SigA,c=-SigC);
//   mu_CoiIn_War = sigmoid(x=fullywet.TSurAirIn-TAirInDewPoi,a=SigA,c=SigC);
//   mu_CoiOut_War= sigmoid(x=fullydry.TSurAirOut-TAirInDewPoi,a=SigA,c=-SigC);


  mu_CoiIn_Col= Buildings.Utilities.Math.Functions.spliceFunction(
  pos=0,neg=1,x=fullywet.TSurAirIn-TAirInDewPoi-0.3,deltax=0.1);
  mu_CoiOut_Col= Buildings.Utilities.Math.Functions.spliceFunction(
  pos=0,neg=1,x=fullydry.TSurAirOut-TAirInDewPoi+0.3,deltax=0.1);
  mu_CoiIn_War= Buildings.Utilities.Math.Functions.spliceFunction(
  pos=1,neg=0,x=fullywet.TSurAirIn-TAirInDewPoi-0.3,deltax=0.1);
  mu_CoiOut_War= Buildings.Utilities.Math.Functions.spliceFunction(
  pos=1,neg=0,x=fullydry.TSurAirOut-TAirInDewPoi+0.3,deltax=0.1);

  mu_FW=mu_CoiIn_Col;
  mu_FD=mu_CoiOut_War;
  mu_PW=mu_CoiIn_War*mu_CoiOut_Col;
  w_FW=mu_FW/(mu_FW+mu_FD+mu_PW);
  w_FD=mu_FD/(mu_FW+mu_FD+mu_PW);
  w_PW=mu_PW/(mu_FW+mu_FD+mu_PW);

     if noEvent(w_PW<=0) then // note w_PW is guranteed to be >=0, there fore this means w_PW==0. Then only two options left.
      TWatInParDry=TWatIn;
      TAirInParWet=TAirIn;
      dryfra  = if w_FD ==1 then 1-1E-3 else 1E-3;  // Used for only analysis purposes.

      TSurTra = TDewIn.T;
      parQTot_flow=0;
      parQSen_flow=0;
      TWatOut= if w_FD ==1 then fullydry.TWatOut else fullywet.TWatOut; // Used for only analysis purposes.
     else

     TWatInParDry=parwet.TWatOut;
     TAirInParWet=pardry.TAirOut;

     (pardry.TAirOut-TSurTra)*UAAir=(TSurTra-parwet.TWatOut)*UAWat;
     TDewIn.T = TSurTra;
     parQTot_flow=pardry.QTot_flow+parwet.QTot_flow;
     parQSen_flow=pardry.QTot_flow+parwet.QSen_flow;
     //TWatOut0=parwet.TWatOut;
     TWatOut=parwet.TWatOut;
  end if;


  QTot_flow= -(w_FW*fullywet.QTot_flow+w_FD*fullydry.QTot_flow+w_PW*parQTot_flow)*Qfac;
  QSen_flow= -(w_FW*fullywet.QSen_flow+w_FD*fullydry.QTot_flow+w_PW*parQSen_flow)*Qfac;
  QLat_flow=QTot_flow-QSen_flow;// DK
  mCon_flow=QLat_flow/Buildings.Utilities.Psychrometrics.Constants.h_fg*Qfac;
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
end DryWetCalcsFuzzy_V2_2_4;
