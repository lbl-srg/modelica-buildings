within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging;
package Generic "Generic chiller staging sequences"
  extends Modelica.Icons.Package;

  block Capacities "Returns nominal capacities at current and one lower stage"

    parameter Integer numSta = 2
    "Highest chiller stage";

    parameter Modelica.SIunits.Power staNomCap[numSta + 1] = {small, 5e5, 1e6}
    "Nominal capacity at all chiller stages, starting with 0 stage";

    parameter Real min_plr1(final unit="1") = 0.1
    "Minimum part load ratio for the first stage";

    Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta "Chiller stage"
      annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
          iconTransformation(extent={{-140,-20},{-100,20}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySta(
      final unit="W",
      final quantity="Power") "Nominal capacity of the current stage"
      annotation (
        Placement(transformation(extent={{160,30},{180,50}}), iconTransformation(
            extent={{100,30},{120,50}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yLowSta(
      final unit="W",
      final quantity="Power") "Nominal capacity of the first lower stage"
      annotation (Placement(transformation(extent={{160,-30},{180,-10}}),
          iconTransformation(extent={{100,-50},{120,-30}})));

  //protected
    parameter Real small = 0.001
    "Small number to avoid division with zero";

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staCap[numSta + 1](
      final k=staNomCap)
      "Array of chiller stage nominal capacities starting with stage 0"
      annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant staLow(final k=1)
      "One stage lower"
      annotation (Placement(transformation(extent={{-150,-70},{-130,-50}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage0(final k=1)
      "Index at Stage 0"
      annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

    Buildings.Controls.OBC.CDL.Utilities.Assert staExc(
      final message="The provided chiller stage is not within the number of stages available")
      annotation (Placement(transformation(extent={{20,60},{40,80}})));

    CDL.Continuous.LessThreshold lesThr(
      final threshold=-0.5) "Less than threshold"
      annotation (Placement(transformation(extent={{-20,60},{0,80}})));

    CDL.Integers.Equal intEqu "Equal stage 1"
      annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

    Buildings.Controls.OBC.CDL.Continuous.Product pro "Product"
      annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

    CDL.Routing.RealExtractor extStaCap(
      final outOfRangeValue=-1,
      final nin=numSta + 1)
      "Extracts the nominal capacity at the current stage"
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

    CDL.Routing.RealExtractor extStaLowCap(
      final outOfRangeValue=-1,
      final nin=numSta + 1)
      "Extracts the nominal capacity of one stage lower than the current stage"
      annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

    CDL.Integers.Max maxInt "Maximum"
      annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

    CDL.Continuous.Sources.Constant minPlrSta1(
      final k=min_plr1)
      "Minimum part load ratio of the first stage"
      annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

    CDL.Logical.Switch swi "Switch"
      annotation (Placement(transformation(extent={{102,-30},{122,-10}})));

    CDL.Integers.Add addInt
      "Aligns indexes (stage starts with 0, indexes with 1)"
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  equation
    connect(extStaCap.y, lesThr.u) annotation (Line(points={{-39,70},{-22,70}},
       color={0,0,127}));
    connect(staExc.u, lesThr.y)
      annotation (Line(points={{18,70},{1,70}}, color={255,0,255}));
    connect(staCap.y,extStaCap. u)
      annotation (Line(points={{-79,70},{-62,70}}, color={0,0,127}));
    connect(staCap.y, extStaLowCap.u) annotation (Line(points={{-79,70},{-70,70},
            {-70,20},{-40,20},{-40,0},{-22,0}},
                                    color={0,0,127}));
    connect(staLow.y, intEqu.u2) annotation (Line(points={{-129,-60},{20,-60},{
            20,-28},{38,-28}},
                             color={255,127,0}));
    connect(stage0.y,maxInt. u2) annotation (Line(points={{-79,-80},{-70,-80},{-70,
            -46},{-62,-46}},        color={255,127,0}));
    connect(maxInt.y, extStaLowCap.index) annotation (Line(points={{-39,-40},{-10,
            -40},{-10,-12}},color={255,127,0}));
    connect(extStaCap.y, ySta) annotation (Line(points={{-39,70},{-30,70},{-30,40},
            {170,40}},                   color={0,0,127}));
    connect(pro.u2, minPlrSta1.y) annotation (Line(points={{38,-66},{30,-66},{30,-80},
            {21,-80}},       color={0,0,127}));
    connect(intEqu.y, swi.u2)
      annotation (Line(points={{61,-20},{100,-20}}, color={255,0,255}));
    connect(pro.y, swi.u1) annotation (Line(points={{61,-60},{86,-60},{86,-12},{100,
            -12}},    color={0,0,127}));
    connect(extStaCap.y, pro.u1) annotation (Line(points={{-39,70},{-30,70},{-30,-54},
            {38,-54}},     color={0,0,127}));
    connect(extStaLowCap.y, swi.u3) annotation (Line(points={{1,0},{80,0},{80,-28},
            {100,-28}},     color={0,0,127}));
    connect(swi.y, yLowSta) annotation (Line(points={{123,-20},{170,-20}},
                        color={0,0,127}));
    connect(uSta, intEqu.u1) annotation (Line(points={{-180,0},{-60,0},{-60,-20},
            {38,-20}},color={255,127,0}));
    connect(uSta, maxInt.u1) annotation (Line(points={{-180,0},{-110,0},{-110,
            -34},{-62,-34}}, color={255,127,0}));
    connect(addInt.y, extStaCap.index) annotation (Line(points={{-79,30},{-50,
            30},{-50,58}}, color={255,127,0}));
    connect(uSta, addInt.u1) annotation (Line(points={{-180,0},{-130,0},{-130,
            36},{-102,36}}, color={255,127,0}));
    connect(staLow.y, addInt.u2) annotation (Line(points={{-129,-60},{-120,-60},
            {-120,24},{-102,24}}, color={255,127,0}));
    annotation (defaultComponentName = "staCap",
          Icon(graphics={
          Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Text(
            extent={{-120,146},{100,108}},
            lineColor={0,0,255},
            textString="%name")}),
                            Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-160,-100},{160,100}})),
  Documentation(info="<html>
<p>
Based on the current chiller stage and nominal stage capacities returns the
nominal capacity of the current and one lower stage for the purpose of 
calculating the operative part load ratio (OPLR). 
</p>
</html>",
  revisions="<html>
<ul>
<li>
January 13, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Capacities;

  block CapacityRequirement
    "Cooling capacity requirement"

    parameter Modelica.SIunits.Density water_density = 1000 "Water density";

    parameter Modelica.SIunits.SpecificHeatCapacity water_spec_heat = 4184
    "Specific heat capacity of water";

    parameter Modelica.SIunits.Time avePer = 5*60
    "Period for the rolling average";

    Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
      final unit="K",
      final quantity="ThermodynamicTemperature")
      "Chilled water supply temperature setpoint"
      annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-120,40},{-100,60}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
      final unit="K",
      final quantity="ThermodynamicTemperature")
      "Chilled water return temperature"
      annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
      final quantity="VolumeFlowRate",
      final unit="m3/s") "Measured chilled water flow rate"
      annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-120,-60},{-100,-40}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
      final quantity="Power",
      final unit="W") "Chilled water cooling capacity requirement"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant density(
      final k=water_density)
      "Water density"
      annotation (Placement(transformation(extent={{-80,-32},{-60,-12}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant speHeaCap(
      final k=water_spec_heat)
      "Specific heat capacity of water"
      annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minLim(
      final k=0)
      "Minimum capacity requirement limit"
      annotation (Placement(transformation(extent={{20,50},{40,70}})));

    Buildings.Controls.OBC.CDL.Continuous.Add add2(
      final k1=-1) "Adder"
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

    Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(
      final delta=avePer)
      "Moving average"
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));

    Buildings.Controls.OBC.CDL.Continuous.Product pro "Product"
      annotation (Placement(transformation(extent={{30,-10},{50,10}})));

    Buildings.Controls.OBC.CDL.Continuous.Product pro1 "Product"
      annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

    Buildings.Controls.OBC.CDL.Continuous.Product pro2 "Product"
      annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

    Buildings.Controls.OBC.CDL.Continuous.Max max "Maximum of two inputs"
      annotation (Placement(transformation(extent={{60,40},{80,60}})));

  equation
    connect(TChiWatRet, add2.u2) annotation (Line(points={{-120,20},{-60,20},{-60,
            24},{-42,24}}, color={0,0,127}));
    connect(add2.u1, TChiWatSupSet) annotation (Line(points={{-42,36},{-60,36},{-60,
            80},{-120,80}}, color={0,0,127}));
    connect(add2.y, pro.u1) annotation (Line(points={{-19,30},{-10,30},{-10,6},{28,
            6}}, color={0,0,127}));
    connect(pro.y, movMea.u)
      annotation (Line(points={{51,0},{58,0}}, color={0,0,127}));
    connect(speHeaCap.y, pro1.u2) annotation (Line(points={{-59,-70},{-50,-70},{-50,
            -66},{-42,-66}}, color={0,0,127}));
    connect(pro1.y, pro2.u2) annotation (Line(points={{-19,-60},{-10,-60},{-10,-36},
            {-2,-36}}, color={0,0,127}));
    connect(pro.u2, pro2.y) annotation (Line(points={{28,-6},{24,-6},{24,-30},{21,
            -30}}, color={0,0,127}));
    connect(pro1.u1, density.y) annotation (Line(points={{-42,-54},{-50,-54},{-50,
            -22},{-59,-22}}, color={0,0,127}));
    connect(VChiWat_flow, pro2.u1) annotation (Line(points={{-120,-50},{-80,-50},{
            -80,-40},{-20,-40},{-20,-24},{-2,-24}}, color={0,0,127}));
    connect(max.u1, minLim.y) annotation (Line(points={{58,56},{50,56},{50,60},{41,
            60}}, color={0,0,127}));
    connect(movMea.y, max.u2) annotation (Line(points={{81,0},{82,0},{82,30},{50,30},
            {50,44},{58,44}}, color={0,0,127}));
    connect(max.y, y) annotation (Line(points={{81,50},{90,50},{90,0},{110,0}},
          color={0,0,127}));
    annotation (defaultComponentName = "capReq",
          Icon(graphics={
          Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Text(
            extent={{-120,146},{100,108}},
            lineColor={0,0,255},
            textString="%name")}), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Calculates cooling capacity requirement based on the measured chilled water return temperature
(CHWRT), <code>TChiWatRet<\code>, calculated chilled water supply temperature setpoint (CHWST setpoint),
<code>TChiWatSupSet<\code>, and the measured chilled water flow, <code>VChiWat_flow<\code>.
<li>
The calculation is according to OBC Chilled Water Plant Sequence of Operation document, section 3.2.4.3. 
</li>
</p>
</html>",
  revisions="<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
  end CapacityRequirement;

  block ChillerdTRef "Calculate actual partial load ratio and current chiller LIFT"

    parameter Integer cooDegDay65 = 948
      "Cooling degree-days base 18.33 degC (65 degF)"
      annotation(Dialog(group="Design conditions"));
    parameter Integer wetBulCooDegDay55 = 1094
      "Webbulb cooling degree-days base 12.78 degC (55 degF)"
      annotation(Dialog(group="Design conditions"));
    parameter Modelica.SIunits.Temperature TWetBul_nominal
      "Design wetbulb temperature"
      annotation(Dialog(group="Design conditions"));
    parameter Modelica.SIunits.TemperatureDifference APPROACH_nominal
      "Design tower leaving water temperature minus design wetbulb temperature"
      annotation(Dialog(group="Design conditions"));
    parameter Real cooTowEff
      "Tower efficiency per ASHRAE standard 90.1, gpm/hp"
      annotation(Dialog(group="Design conditions"));
    parameter Modelica.SIunits.Temperature TConWatRet_nominal
      "Design condenser water return temperature"
      annotation(Dialog(group="Design conditions"));
    parameter Modelica.SIunits.Temperature TChiWatSup_nominal
      "Design chilled water supply temperature"
      annotation(Dialog(group="Design conditions"));
    parameter Modelica.SIunits.HeatFlowRate plaCap_nominal(displayUnit = "kW")
      "Total design plant capacity"
      annotation(Dialog(group="Design conditions"));
    parameter Modelica.SIunits.TemperatureDifference dTRefMin
      "Minimum LIFT at minimum load"
      annotation(Dialog(group="Design conditions"));
    parameter Boolean use_simCoe = true
      "Indicate if use simplified coefficients, it recommends to use it";
    parameter Modelica.SIunits.Density rho(displayUnit = "kg/m3") = 1000
      "Density of water";
    parameter Modelica.SIunits.SpecificHeatCapacity cp = 4190
      "Specific heat capacity of water";

    Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
      final unit="K",
      final quantity="ThermodynamicTemperature")
      "Measured chilled water supply temperature"
      annotation (Placement(transformation(extent={{-200,80},{-160,120}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
      final unit="K",
      final quantity="ThermodynamicTemperature")
      "Measured chilled water return temperature"
      annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput VEva_flow(
      final unit="m3/s",
      final quantity="VolumeFlowRate")
      "Measured chilled water supply flow rate"
      annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPLR(
      final min=0,
      final max=1,
      final unit = "1")
      "Actual PLR"
      annotation (Placement(transformation(extent={{160,70},{180,90}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealOutput dTRef(
      final unit="K",
      final quantity="TemperatureDifference")
      "Chiller LIFT"
      annotation (Placement(transformation(extent={{160,-10},{180,10}}),
        iconTransformation(extent={{100,50},{120,70}})));

    Buildings.Controls.OBC.CDL.Continuous.Product chiLoa
      "Actual chiller load"
      annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
    Buildings.Controls.OBC.CDL.Continuous.Gain PLR(final k=1/plaCap_nominal)
      "Partial load ratio"
      annotation (Placement(transformation(extent={{-20,70},{0,90}})));
    Buildings.Controls.OBC.CDL.Logical.Switch coeA "Coefficient A"
      annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
    Buildings.Controls.OBC.CDL.Logical.Switch coeB "Coefficient B"
      annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
    Buildings.Controls.OBC.CDL.Continuous.Gain simA(final k=1/0.9)
      "Simplified A cofficient"
      annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
    Buildings.Controls.OBC.CDL.Continuous.Add simB(final k1=-1)
      "Simplified B coefficient"
      annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
    Buildings.Controls.OBC.CDL.Continuous.Gain masFlo(final k=rho)
      "Convert to mass flow rate"
      annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
    Buildings.Controls.OBC.CDL.Continuous.Limiter lim(
      final uMax=dTRef_nominal,
      final uMin=dTRefMin)
      "LIFT shall be limited by minimum and design LIFT"
      annotation (Placement(transformation(extent={{128,-10},{148,10}})));

  protected
    parameter Real a0 = -63;
    parameter Real a1 = 0.0053;
    parameter Real a2 = -0.0087;
    parameter Real a3 = 1.67;
    parameter Real a4 = 0.52;
    parameter Real a5 = -0.029;
    parameter Real b0 = 18;
    parameter Real b1 = -0.0033;
    parameter Real b2 = 0.0053;
    parameter Real b3 = -0.26;
    parameter Real b4 = 0.15;
    parameter Real b5 = -0.014;
    parameter Modelica.SIunits.TemperatureDifference dTRef_nominal=
      TConWatRet_nominal - TChiWatSup_nominal
      "LIFT at design conditions "
      annotation(Dialog(group="Design conditions"));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant regA(
      k=a0 + a1*cooDegDay65 + a2*wetBulCooDegDay55 + a3*((TWetBul_nominal-273.15)*9/5+32)
           + a4*APPROACH_nominal*9/5 + a5*cooTowEff)
      "Regressed A coefficient"
      annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant regB(
      k=b0 + b1*cooDegDay65 + b2*wetBulCooDegDay55 + b3*((TWetBul_nominal-273.15)*9/5+32)
           + b4*APPROACH_nominal*9/5 + b5*cooTowEff)
      "Regressed B coefficient"
      annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
    Buildings.Controls.OBC.CDL.Logical.Sources.Constant simCoe(k=use_simCoe)
      "Simplified cofficients indicator"
      annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minLif(
      final k=dTRefMin*9/5)
      "Minimum LIFT at minimum load"
      annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desLif(
      final k=dTRef_nominal*9/5)
      "LIFT at design conditions"
      annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
    Buildings.Controls.OBC.CDL.Continuous.Add difLif(k1=-1)
      "Design and minimum LIFT difference"
      annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
    Buildings.Controls.OBC.CDL.Continuous.Product pro
      annotation (Placement(transformation(extent={{40,40},{60,60}})));
    Buildings.Controls.OBC.CDL.Continuous.Gain gain(k=cp)
      "Gain factor of specific heat capacity"
      annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
    Buildings.Controls.OBC.CDL.Continuous.Add add1
      annotation (Placement(transformation(extent={{80,34},{100,54}})));
    Buildings.Controls.OBC.CDL.Continuous.Add add2(final k1=-1)
      "Supply and return chilled water temperature difference"
      annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
    Buildings.Controls.OBC.CDL.Continuous.Gain dF2dT(final k=5/9)
      "Convert from Farenheit difference to Kelvin difference"
      annotation (Placement(transformation(extent={{94,-10},{114,10}})));

  equation
    connect(VEva_flow, masFlo.u)
            annotation (Line(points={{-180,20},{-150,20},{-150,40},{-142,40}},
            color={0,0,127}));
    connect(masFlo.y, gain.u)
            annotation (Line(points={{-119,40},{-102,40}}, color={0,0,127}));
    connect(TChiWatSup, add2.u1)
            annotation (Line(points={{-180,100},{-140,100},{-140,96},{-122,96}},
            color={0,0,127}));
    connect(TChiWatRet, add2.u2)
            annotation (Line(points={{-180,60},{-140,60},{-140,84},{-122,84}},
            color={0,0,127}));
    connect(add2.y, chiLoa.u1)
            annotation (Line(points={{-99,90},{-70,90},{-70,86},{-62,86}},
            color={0,0,127}));
    connect(gain.y, chiLoa.u2)
            annotation (Line(points={{-79,40},{-70,40},{-70,74},{-62,74}},
            color={0,0,127}));
    connect(chiLoa.y, PLR.u)
            annotation (Line(points={{-39,80},{-22,80}}, color={0,0,127}));
    connect(difLif.y, simA.u)
            annotation (Line(points={{-79,-10},{-62,-10}}, color={0,0,127}));
    connect(minLif.y, difLif.u1)
            annotation (Line(points={{-119,-10},{-110,-10},{-110,-4},{-102,-4}},
            color={0,0,127}));
    connect(simA.y, simB.u1)
            annotation (Line(points={{-39,-10},{-32,-10},{-32,-34},{-12,-34}},
            color={0,0,127}));
    connect(simA.y, coeA.u1)
            annotation (Line(points={{-39,-10},{-32,-10},{-32,-2},{-12,-2}},
            color={0,0,127}));
    connect(regA.y, coeA.u3)
            annotation (Line(points={{-39,-100},{-20,-100},{-20,-18},{-12,-18}},
            color={0,0,127}));
    connect(simB.y, coeB.u1)
            annotation (Line(points={{11,-40},{20,-40},{20,-32},{38,-32}},
            color={0,0,127}));
    connect(simCoe.y, coeA.u2)
            annotation (Line(points={{-79,-80},{-26,-80},{-26,-10},{-12,-10}},
            color={255,0,255}));
    connect(regB.y, coeB.u3)
            annotation (Line(points={{11,-100},{32,-100},{32,-48},{38,-48}},
            color={0,0,127}));
    connect(simCoe.y, coeB.u2)
            annotation (Line(points={{-79,-80},{26,-80},{26,-40},{38,-40}},
            color={255,0,255}));
    connect(PLR.y, pro.u1)
            annotation (Line(points={{1,80},{20,80},{20,56},{38,56}},
            color={0,0,127}));
    connect(coeA.y, pro.u2)
            annotation (Line(points={{11,-10},{20,-10},{20,44},{38,44}},
            color={0,0,127}));
    connect(coeB.y, add1.u2)
            annotation (Line(points={{61,-40},{70,-40},{70,38},{78,38}},
            color={0,0,127}));
    connect(pro.y, add1.u1)
            annotation (Line(points={{61,50},{78,50}},
            color={0,0,127}));
    connect(PLR.y, yPLR)
            annotation (Line(points={{1,80},{170,80}}, color={0,0,127}));
    connect(desLif.y, difLif.u2)
            annotation (Line(points={{-119,-50},{-108,-50},{-108,-16},{-102,-16}},
            color={0,0,127}));
    connect(lim.y, dTRef)
            annotation (Line(points={{149,0},{170,0}}, color={0,0,127}));
    connect(desLif.y, simB.u2)
            annotation (Line(points={{-119,-50},{-108,-50},{-108,-46},{-12,-46}},
            color={0,0,127}));
    connect(add1.y, dF2dT.u)
            annotation (Line(points={{101,44},{108,44},{108,20},{80,20},{80,0},{92,0}},
            color={0,0,127}));
    connect(dF2dT.y, lim.u)
            annotation (Line(points={{115,0},{126,0}}, color={0,0,127}));

  annotation (
    defaultComponentName = "chillerdTRef",
    Icon(graphics={
          Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Text(
            extent={{-96,72},{-42,50}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="TChiWatSup"),
          Text(
            extent={{-96,12},{-42,-10}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="TChiWatRet"),
          Text(
            extent={{-96,-48},{-42,-70}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="VEva_flow"),
          Text(
            extent={{58,68},{100,52}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="dTRef"),
          Text(
            extent={{58,-52},{100,-68}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yPLR"),
          Text(
            extent={{-120,146},{100,108}},
            lineColor={0,0,255},
            textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-160,-120},{160,120}})),
    Documentation(info="<html>
<p>
Block that output chiller LIFT <code>dTRef</code> and actual partial load ratio 
(<code>yPLR</code>) according to &quot;ASHRAE Fundamentals of Chilled Water 
Plant Design and Control SDL&quot;, Chapter 7, Appendix A, section Condenser 
water temperature control.
</p>
<h4>Actual plant part load ratio <code>yPLR</code></h4>
<p>
<code>yPLR</code> equals to calculated load divided by total chiller design load 
(<code>plaCap_nominal</code>). Following equation is used:
</p>
<pre>
  yPLR = (rho*VEva_flow*cp*(TChiWatRet-TChiWatSup)) / plaCap_nominal
</pre>
<p>
in which, <code>TChiWatSup</code> is measured chilled water supply, 
<code>TChiWatRet</code> is return temperature, <code>VEva_flow</code> is the 
supply flow rate.
</p>
<h4>Chiller dTRef</h4>
<p>
<code>dTRef</code> shall be no smaller than <code>dTRefMin</code> and no larger than 
<code>dTRef_nominal</code>. It can be calculated as:
</p>
<pre>
  dTRef = (A*PLR + B)*5/9
</pre>
<p>
in which, the coefficient A and B can be found out with one of following:
</p>
<ul>
<li>Regressed coefficients (use with care)</li>
</ul>
<pre>
A = -63 + 0.0053*cooDegDay65 - 0.0087*wetBulCooDegDay55 + 1.67*((TWetBul_nominal-273.15)*9/5+32) 
        + 0.52*APPROACH_nominal*9/5 - 0.029*cooTowEff
B = 18 - 0.0033*cooDegDay65 + 0.0053*wetBulCooDegDay55 - 0.26*((TWetBul_nominal-273.15)*9/5+32) 
       + 0.15*APPROACH_nominal*9/5 - 0.014*cooTowEff 
</pre>

<p>
Where <code>cooDegDay65</code> is Cooling degree-days base 65 degF, 
<code>wetBulCooDegDay55</code> is Webbulb cooling degree-days base 55 degF, 
<code>TWetBul_nominal</code> is Design wetbulb temperature,
<code>APPROACH_nominal</code> is Design tower leaving water temperature minus design 
wetbulb temperature, 
<code>cooTowEff</code> is Tower efficiency per ASHRAE standard 90.1
</p>
<ul>
<li>Simplified coefficients (recommended)</li>
</ul>
<pre>
A = (dTRef_nominal - dTRefMin)/0.9
B = dTRef_nominal - A
</pre>

<p>
where <code>dTRef_nominal</code> is dTRef at design conditions 
(<code>TConWatRet_nominal</code> - <code>TChiWatSup_nominal</code>), 
<code>dTRefMin</code> is Minimum dTRef at minimum load.
</p>
</html>",
  revisions="<html>
<ul>
<li>
March 05, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
  end ChillerdTRef;

  block DownProcess
    "Sequences to control equipments when chiller stage down"
    parameter Integer num = 2
      "Total number of chillers, the same number applied to isolation valves, CW pumps, CHW pumps";
    parameter Modelica.SIunits.ElectricCurrent lowChiCur = 0.05
      "Low limit to check if the chiller is running";
    parameter Modelica.SIunits.Time turOffChiWatIsoTim = 300
      "Time to close chilled water isolation valve";
    parameter Modelica.SIunits.Time byPasSetTim = 300
      "Time to change minimum flow setpoint from old one to new one";
    parameter Modelica.SIunits.VolumeFlowRate minFloSet[num] = {0.0089, 0.0177}
      "Minimum flow rate at each chiller stage";

    Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
      "Current chiller stage"
      annotation (Placement(transformation(extent={{-260,360},{-220,400}}),
        iconTransformation(extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,90})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiCur[num](
      final quantity="ElectricCurrent",
      final unit="A") "Chiller demand measured by electric current"
      annotation (Placement(transformation(extent={{-260,250},{-220,290}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[num] "Chiller status"
       annotation (Placement(transformation(extent={{-260,310},{-220,350}}),
         iconTransformation(extent={{-120,50},{-100,70}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatPum[num]
      "Condenser water pump status"
      annotation (Placement(transformation(extent={{-260,-230},{-220,-190}}),
        iconTransformation(extent={{-120,-80},{-100,-60}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatIsoVal[num](
      final unit="1",
      final min=0,
      final max=1) "Condense water isolation valve position"
      annotation (Placement(transformation(extent={{-260,-160},{-220,-120}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[num](
      final unit="1",
      final min=0,
      final max=1) "Chilled water isolation valve position"
      annotation (Placement(transformation(extent={{-260,50},{-220,90}}),
        iconTransformation(extent={{-120,0},{-100,20}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[num](
      final unit="1",
      final min=0,
      final max=1) "Condenser water pump speed"
      annotation (Placement(transformation(extent={{-260,-290},{-220,-250}}),
        iconTransformation(extent={{-120,-100},{-100,-80}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yConWatPum[num]
      "Condenser water pump status"
      annotation (Placement(transformation(extent={{240,-220},{260,-200}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yConWatIsoVal[num]
      "Condenser water isolation valve status"
      annotation (Placement(transformation(extent={{240,-90},{260,-70}}),
        iconTransformation(extent={{100,-30},{120,-10}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoValSet[num](
      final min=0,
      final max=1,
      final unit="1") "Chilled water isolvation valve position setpoint"
      annotation (Placement(transformation(extent={{240,80},{260,100}}),
        iconTransformation(extent={{100,10},{120,30}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinFloSet(
      final unit="m3/s") "Minimum flow setpoint"
      annotation (Placement(transformation(extent={{240,-390},{260,-370}}),
        iconTransformation(extent={{100,-100},{120,-80}})));

    Buildings.Controls.OBC.CDL.Integers.Change cha
      "Check chiller stage change status"
      annotation (Placement(transformation(extent={{-160,370},{-140,390}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[num]
      "Chiller status"
      annotation (Placement(transformation(extent={{240,320},{260,340}}),
        iconTransformation(extent={{100,60},{120,80}})));
    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys[num](
      final uLow=lowChiCur,
      final uHigh=lowChiCur + 0.2)
      "Check if the chiller current becomes zero"
      annotation (Placement(transformation(extent={{-160,260},{-140,280}})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[num]
      "Convert boolean intput to integer"
      annotation (Placement(transformation(extent={{-80,290},{-60,310}})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[num]
      "Convert boolean intput to integer"
      annotation (Placement(transformation(extent={{-80,260},{-60,280}})));
    Buildings.Controls.OBC.CDL.Integers.Equal intEqu[num] "Check equality of integer inputs"
      annotation (Placement(transformation(extent={{-20,290},{0,310}})));
    Buildings.Controls.OBC.CDL.Logical.Timer tim
      annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
    Buildings.Controls.OBC.CDL.Continuous.Line lin1
      "Minimum flow setpoint at current stage"
      annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1[num](
      each final uLow=0.05,
      each final uHigh=0.1)
      "Check if isolation valve is not closed"
      annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
    Buildings.Controls.OBC.CDL.Logical.Switch swi[num] "Logical switch"
      annotation (Placement(transformation(extent={{80,110},{100,130}})));
    Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(final nout=num)
      "Replicate real input"
      annotation (Placement(transformation(extent={{20,170},{40,190}})));
    Buildings.Controls.OBC.CDL.Logical.Switch swi1[num] "Logical switch"
      annotation (Placement(transformation(extent={{80,30},{100,50}})));
    Buildings.Controls.OBC.CDL.Continuous.Add add2[num] "Add inputs"
      annotation (Placement(transformation(extent={{140,80},{160,100}})));
    Buildings.Controls.OBC.CDL.Logical.And and5 "Logical and"
      annotation (Placement(transformation(extent={{100,290},{120,310}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatIsoValSta[num]
      "Condenser water isolation valve status"
      annotation (Placement(transformation(extent={{-260,-100},{-220,-60}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2[num]
      "Convert boolean intput to integer"
      annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3[num]
      "Convert boolean intput to integer"
      annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
    Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[num]
      "Check equality of integer inputs"
      annotation (Placement(transformation(extent={{-20,90},{0,110}})));
    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2[num](
      final uLow=0.05, final uHigh=0.1)
      "Check if isolation valve is not closed"
      annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4[num]
      "Convert boolean intput to integer"
      annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt5[num]
      "Convert boolean intput to integer"
      annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
    Buildings.Controls.OBC.CDL.Integers.Equal intEqu2[num]
      "Check equality of integer inputs"
      annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
    Buildings.Controls.OBC.CDL.Routing.RealExtractor curMinSet(final nin=num)
      "Targeted minimum flow setpoint at current stage"
      annotation (Placement(transformation(extent={{-100,-350},{-80,-330}})));
    Buildings.Controls.OBC.CDL.Routing.RealExtractor oldMinSet(
      final nin=num)
      "Minimum flow setpoint at old stage"
      annotation (Placement(transformation(extent={{-100,-400},{-80,-380}})));
    Buildings.Controls.OBC.CDL.Continuous.Line lin
      "Minimum flow setpoint at current stage"
      annotation (Placement(transformation(extent={{0,-400},{20,-380}})));
    Buildings.Controls.OBC.CDL.Logical.Timer tim1
      "Time after fully closed CW isolation valve"
      annotation (Placement(transformation(extent={{0,-350},{20,-330}})));
    Buildings.Controls.OBC.CDL.Integers.LessThreshold intLesThr(
      final threshold=1)
      "Check if it is zero stage"
      annotation (Placement(transformation(extent={{60,-380},{80,-360}})));
    Buildings.Controls.OBC.CDL.Logical.Switch swi2
      "Switch to current stage setpoint"
      annotation (Placement(transformation(extent={{120,-390},{140,-370}})));
    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4[num](uLow=0.05, uHigh=0.1)
      "Check if isolation valve is not closed"
      annotation (Placement(transformation(extent={{-180,-280},{-160,-260}})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt6[num]
      "Convert boolean intput to integer"
      annotation (Placement(transformation(extent={{-80,-250},{-60,-230}})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt7[num]
      "Convert boolean intput to integer"
      annotation (Placement(transformation(extent={{-80,-280},{-60,-260}})));
    Buildings.Controls.OBC.CDL.Integers.Equal intEqu3[num]
      "Check equality of integer inputs"
      annotation (Placement(transformation(extent={{-20,-270},{0,-250}})));
    Buildings.Controls.OBC.CDL.Integers.Add addInt
      "One stage lower than current one"
      annotation (Placement(transformation(extent={{-140,-420},{-120,-400}})));

  protected
    Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
      final k=1)
      "Constant one"
      annotation (Placement(transformation(extent={{-180,-420},{-160,-400}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=0)
      "Zero constant"
      annotation (Placement(transformation(extent={{-100,210},{-80,230}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(final k=1)
      "Constant 1"
      annotation (Placement(transformation(extent={{-160,210},{-140,230}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
      final k=turOffChiWatIsoTim)
      "Total time to turn off chiller water isolation valve"
      annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
      final k=0) "Consant 0"
      annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4[num](
      final k=0) "Constant zero"
      annotation (Placement(transformation(extent={{20,70},{40,90}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con5[num](
      final k=0) "Constant zero"
      annotation (Placement(transformation(extent={{20,10},{40,30}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con6[num](
      final k=minFloSet)
      "Minimum flow setpoint"
      annotation (Placement(transformation(extent={{-160,-350},{-140,-330}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con7(final k=0)
      "Constant zero"
      annotation (Placement(transformation(extent={{-60,-350},{-40,-330}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con8(
      final k=byPasSetTim)
      "Duration time to change old setpoint to new setpoint"
      annotation (Placement(transformation(extent={{-60,-420},{-40,-400}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con9(final k=0)
      "Zero minimal flow setpoint when it is zero stage"
      annotation (Placement(transformation(extent={{60,-350},{80,-330}})));
    Buildings.Controls.OBC.CDL.Logical.And and3
      "Check if chilled water isolation valve has been disabled"
      annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
    Buildings.Controls.OBC.CDL.Logical.And and4
      "Check if chilled water isolation valve has been disabled"
      annotation (Placement(transformation(extent={{100,-140},{120,-120}})));
    Buildings.Controls.OBC.CDL.Logical.And and6
      "Check if chilled water isolation valve has been disabled"
      annotation (Placement(transformation(extent={{100,-270},{120,-250}})));
    Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(nu=num)
      "Check if the disabled chiller has been really disabled"
      annotation (Placement(transformation(extent={{20,290},{40,310}})));
    Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(final nu=num)
      "Check if the disabled chiller has been really disabled"
      annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
    Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd2(final nu=num)
      "Check if the disabled isolation valve has been really disabled"
      annotation (Placement(transformation(extent={{20,-140},{40,-120}})));
    Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd3(final nu=num)
      "Check if the disabled chiller has been really disabled"
      annotation (Placement(transformation(extent={{20,-270},{40,-250}})));

  equation
    connect(uChiSta, cha.u)
      annotation (Line(points={{-240,380},{-162,380}}, color={255,127,0}));
    connect(uChi, disLat.uDevSta)
      annotation (Line(points={{-240,330},{-142,330}}, color={255,0,255}));
    connect(cha.down, disLat.uDis)
      annotation (Line(points={{-139,374},{-120,374},{-120,360},{-200,360},
        {-200,322},{-142,322}}, color={255,0,255}));
    connect(disLat.yDevSta, yChi)
      annotation (Line(points={{-119,330},{250,330}}, color={255,0,255}));
    connect(uChiCur, hys.u)
      annotation (Line(points={{-240,270},{-162,270}}, color={0,0,127}));
    connect(disLat.yDevSta, booToInt.u)
      annotation (Line(points={{-119,330},{-100,330},{-100,300},{-82,300}},
        color={255,0,255}));
    connect(hys.y, booToInt1.u)
      annotation (Line(points={{-139,270},{-82,270}},  color={255,0,255}));
    connect(booToInt1.y, intEqu.u2)
      annotation (Line(points={{-59,270},{-40,270},{-40,292},{-22,292}},
        color={255,127,0}));
    connect(booToInt.y, intEqu.u1)
      annotation (Line(points={{-59,300},{-22,300}}, color={255,127,0}));
    connect(intEqu.y, mulAnd.u)
      annotation (Line(points={{1,300},{18,300}}, color={255,0,255}));
    connect(con.y, lin1.x1)
      annotation (Line(points={{-79,220},{-60,220},{-60,188},{-42,188}},
        color={0,0,127}));
    connect(con1.y, lin1.f1)
      annotation (Line(points={{-139,220},{-120,220},{-120,184},{-42,184}},
        color={0,0,127}));
    connect(tim.y, lin1.u)
      annotation (Line(points={{-139,180},{-42,180}}, color={0,0,127}));
    connect(con2.y, lin1.x2)
      annotation (Line(points={{-139,140},{-120,140},{-120,176},{-42,176}},
        color={0,0,127}));
    connect(con3.y, lin1.f2)
      annotation (Line(points={{-79,140},{-60,140},{-60,172},{-42,172}},
        color={0,0,127}));
    connect(uChiWatIsoVal, hys1.u)
      annotation (Line(points={{-240,70},{-182,70}}, color={0,0,127}));
    connect(hys1.y, disLat2.uDevSta)
      annotation (Line(points={{-159,70},{-152,70},{-152,100},{-142,100}},
        color={255,0,255}));
    connect(lin1.y, reaRep.u)
      annotation (Line(points={{-19,180},{18,180}}, color={0,0,127}));
    connect(disLat2.yDevSta, swi1.u2)
      annotation (Line(points={{-119,100},{-100,100},{-100,40},{78,40}},
        color={255,0,255}));
    connect(uChiWatIsoVal, swi1.u1)
      annotation (Line(points={{-240,70},{-196,70},{-196,48},{78,48}},
        color={0,0,127}));
    connect(con5.y, swi1.u3)
      annotation (Line(points={{41,20},{60,20},{60,32},{78,32}},
        color={0,0,127}));
    connect(swi1.y, add2.u2)
      annotation (Line(points={{101,40},{120,40},{120,84},{138,84}},
        color={0,0,127}));
    connect(swi.y, add2.u1)
      annotation (Line(points={{101,120},{120,120},{120,96},{138,96}},
        color={0,0,127}));
    connect(add2.y, yChiWatIsoValSet)
      annotation (Line(points={{161,90},{250,90}},   color={0,0,127}));
    connect(cha.down, and5.u1)
      annotation (Line(points={{-139,374},{80,374},{80,300},{98,300}},
        color={255,0,255}));
    connect(mulAnd.y, and5.u2)
      annotation (Line(points={{41.7,300},{60,300},{60,292},{98,292}},
        color={255,0,255}));
    connect(and5.y, tim.u)
      annotation (Line(points={{121,300},{180,300},{180,250},{-180,250},
        {-180,180},{-162,180}},color={255,0,255}));
    connect(and5.y, disLat2.uDis)
      annotation (Line(points={{121,300},{180,300},{180,250},{-180,250},
        {-180,92},{-142,92}}, color={255,0,255}));
    connect(disLat2.yDevSta, booToInt3.u)
      annotation (Line(points={{-119,100},{-82,100}}, color={255,0,255}));
    connect(hys1.y, booToInt2.u)
      annotation (Line(points={{-159,70},{-82,70}}, color={255,0,255}));
    connect(booToInt3.y, intEqu1.u1)
      annotation (Line(points={{-59,100},{-22,100}}, color={255,127,0}));
    connect(booToInt2.y, intEqu1.u2)
      annotation (Line(points={{-59,70},{-40,70},{-40,92},{-22,92}},
        color={255,127,0}));
    connect(intEqu1.y, mulAnd1.u)
      annotation (Line(points={{1,100},{10,100},{10,-20},{18,-20}},
        color={255,0,255}));
    connect(mulAnd1.y, and3.u2)
      annotation (Line(points={{41.7,-20},{60,-20},{60,-28},{98,-28}},
        color={255,0,255}));
    connect(and5.y, and3.u1)
      annotation (Line(points={{121,300},{180,300},{180,0},{80,0},{80,-20},
        {98,-20}},color={255,0,255}));
    connect(uConWatIsoValSta, disLat3.uDevSta)
      annotation (Line(points={{-240,-80},{-142,-80}}, color={255,0,255}));
    connect(and3.y, disLat3.uDis)
      annotation (Line(points={{121,-20},{140,-20},{140,-52},{-160,-52},
        {-160,-88},{-142,-88}}, color={255,0,255}));
    connect(disLat3.yDevSta, yConWatIsoVal)
      annotation (Line(points={{-119,-80},{250,-80}}, color={255,0,255}));
    connect(uConWatIsoVal, hys2.u)
      annotation (Line(points={{-240,-140},{-182,-140}}, color={0,0,127}));
    connect(disLat3.yDevSta, booToInt4.u)
      annotation (Line(points={{-119,-80},{-100,-80},{-100,-110},{-82,-110}},
        color={255,0,255}));
    connect(hys2.y, booToInt5.u)
      annotation (Line(points={{-159,-140},{-82,-140}}, color={255,0,255}));
    connect(booToInt4.y, intEqu2.u1)
      annotation (Line(points={{-59,-110},{-40,-110},{-40,-130},{-22,-130}},
        color={255,127,0}));
    connect(booToInt5.y, intEqu2.u2)
      annotation (Line(points={{-59,-140},{-40,-140},{-40,-138},{-22,-138}},
        color={255,127,0}));
    connect(intEqu2.y, mulAnd2.u)
      annotation (Line(points={{1,-130},{18,-130}}, color={255,0,255}));
    connect(uConWatPum, disLat4.uDevSta)
      annotation (Line(points={{-240,-210},{-142,-210}}, color={255,0,255}));
    connect(and3.y, and4.u1)
      annotation (Line(points={{121,-20},{140,-20},{140,-100},{80,-100},
        {80,-130},{98,-130}}, color={255,0,255}));
    connect(mulAnd2.y, and4.u2)
      annotation (Line(points={{41.7,-130},{60,-130},{60,-138},{98,-138}},
        color={255,0,255}));
    connect(and4.y, disLat4.uDis)
      annotation (Line(points={{121,-130},{140,-130},{140,-160},{-160,-160},
        {-160,-218},{-142,-218}}, color={255,0,255}));
    connect(disLat4.yDevSta, yConWatPum)
      annotation (Line(points={{-119,-210},{250,-210}}, color={255,0,255}));
    connect(con6.y,curMinSet. u)
      annotation (Line(points={{-139,-340},{-102,-340}}, color={0,0,127}));
    connect(conInt.y,addInt. u2)
      annotation (Line(points={{-159,-410},{-150,-410},{-150,-416},{-142,-416}},
        color={255,127,0}));
    connect(con6.y,oldMinSet. u)
      annotation (Line(points={{-139,-340},{-120,-340},{-120,-390},{-102,-390}},
        color={0,0,127}));
    connect(con7.y,lin. x1)
      annotation (Line(points={{-39,-340},{-26,-340},{-26,-382},{-2,-382}},
        color={0,0,127}));
    connect(con8.y,lin. x2)
      annotation (Line(points={{-39,-410},{-20,-410},{-20,-394},{-2,-394}},
        color={0,0,127}));
    connect(tim1.y, lin.u)
      annotation (Line(points={{21,-340},{40,-340},{40,-360},{-20,-360},
        {-20,-390},{-2,-390}}, color={0,0,127}));
    connect(oldMinSet.y,lin. f1)
      annotation (Line(points={{-79,-390},{-26,-390},{-26,-386},{-2,-386}},
        color={0,0,127}));
    connect(addInt.y,oldMinSet. index)
      annotation (Line(points={{-119,-410},{-90,-410},{-90,-402}},
        color={255,127,0}));
    connect(con9.y,swi2. u1)
      annotation (Line(points={{81,-340},{110,-340},{110,-372},{118,-372}},
        color={0,0,127}));
    connect(intLesThr.y,swi2. u2)
      annotation (Line(points={{81,-370},{100,-370},{100,-380},{118,-380}},
        color={255,0,255}));
    connect(lin.y,swi2. u3)
      annotation (Line(points={{21,-390},{100,-390},{100,-388},{118,-388}},
        color={0,0,127}));
    connect(swi2.y,yMinFloSet)
      annotation (Line(points={{141,-380},{250,-380}}, color={0,0,127}));
    connect(curMinSet.y,lin. f2)
      annotation (Line(points={{-79,-340},{-70,-340},{-70,-380},{-32,-380},
        {-32,-398},{-2,-398}}, color={0,0,127}));
    connect(uConWatPumSpe, hys4.u)
      annotation (Line(points={{-240,-270},{-182,-270}}, color={0,0,127}));
    connect(hys4.y, booToInt7.u)
      annotation (Line(points={{-159,-270},{-82,-270}}, color={255,0,255}));
    connect(disLat4.yDevSta, booToInt6.u)
      annotation (Line(points={{-119,-210},{-100,-210},{-100,-240},{-82,-240}},
        color={255,0,255}));
    connect(booToInt6.y, intEqu3.u1)
      annotation (Line(points={{-59,-240},{-40,-240}, {-40,-260},{-22,-260}},
        color={255,127,0}));
    connect(booToInt7.y, intEqu3.u2)
      annotation (Line(points={{-59,-270},{-40,-270},{-40,-268},{-22,-268}},
        color={255,127,0}));
    connect(intEqu3.y, mulAnd3.u)
      annotation (Line(points={{1,-260},{18,-260}}, color={255,0,255}));
    connect(mulAnd3.y, and6.u2)
      annotation (Line(points={{41.7,-260},{60,-260},{60,-268},{98,-268}},
        color={255,0,255}));
    connect(and4.y, and6.u1)
      annotation (Line(points={{121,-130},{140,-130},{140,-160},{80,-160},
        {80,-260},{98,-260}}, color={255,0,255}));
    connect(and6.y, tim1.u)
      annotation (Line(points={{121,-260},{140,-260},{140,-300},{-20,-300},
        {-20,-340},{-2,-340}}, color={255,0,255}));
    connect(uChiSta, addInt.u1)
      annotation (Line(points={{-240,380},{-204,380},{-204,-360},{-152,-360},
        {-152,-404},{-142,-404}}, color={255,127,0}));
    connect(uChiSta, curMinSet.index)
      annotation (Line(points={{-240,380},{-204,380},{-204,-360},{-90,-360},
        {-90,-352}}, color={255,127,0}));
    connect(uChiSta, intLesThr.u)
      annotation (Line(points={{-240,380},{-204,380},{-204,-320},{50,-320},
        {50,-370},{58,-370}}, color={255,127,0}));
    connect(intEqu1.y, swi.u2)
      annotation (Line(points={{1,100},{20,100},{20,120},{78,120}}, color={255,0,255}));
    connect(con4.y, swi.u1)
      annotation (Line(points={{41,80},{52,80},{52,128},{78,128}}, color={0,0,127}));
    connect(reaRep.y, swi.u3)
      annotation (Line(points={{41,180},{60,180},{60,112},{78,112}}, color={0,0,127}));

  annotation (
    defaultComponentName = "staDow",
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-220,-440},{240,440}}), graphics={
                                               Rectangle(
            extent={{-218,-322},{238,-418}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
            Text(
            extent={{84,-322},{232,-360}},
            pattern=LinePattern.None,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            horizontalAlignment=TextAlignment.Right,
            textString="Slowly change minimum 
flow rate setpoint"),                          Rectangle(
            extent={{-218,-202},{238,-298}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
            Text(
            extent={{110,-214},{232,-250}},
            pattern=LinePattern.None,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            horizontalAlignment=TextAlignment.Right,
            textString="Shut off last stage condenser 
water pump"),                                  Rectangle(
            extent={{-218,-62},{238,-178}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
            Text(
            extent={{138,-100},{236,-128}},
            pattern=LinePattern.None,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            horizontalAlignment=TextAlignment.Right,
            textString="Dsiable CW isolation valve"),
                                               Rectangle(
            extent={{-218,238},{238,-38}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
            Text(
            extent={{58,232},{222,186}},
            pattern=LinePattern.None,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            horizontalAlignment=TextAlignment.Right,
            textString="Close isolation valve
of the closed chiller"),                       Rectangle(
            extent={{-218,418},{238,262}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
            Text(
            extent={{110,414},{222,382}},
            pattern=LinePattern.None,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            horizontalAlignment=TextAlignment.Right,
            textString="Shut off last stage chiller")}),
      Icon(graphics={
          Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Text(
            extent={{-120,146},{100,108}},
            lineColor={0,0,255},
            textString="%name"),
          Text(
            extent={{-96,66},{-74,56}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uChi"),
          Text(
            extent={{-96,-82},{-30,-96}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uConWatPumSpe"),
          Text(
            extent={{-96,48},{-66,36}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uChiCur"),
          Text(
            extent={{-96,-12},{-28,-26}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uConWatIsoValSta"),
          Text(
            extent={{-96,18},{-34,8}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uChiWatIsoVal"),
          Text(
            extent={{74,74},{102,64}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yChi"),
          Text(
            extent={{-16,4.5},{16,-4.5}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uChiSta",
            origin={-82,92.5},
            rotation=0),
          Text(
            extent={{44,-52},{96,-66}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yConWatPum"),
          Text(
            extent={{40,-12},{98,-26}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yConWatIsoVal"),
          Text(
            extent={{26,26},{96,12}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yChiWatIsoValSet"),
          Text(
            extent={{56,-84},{98,-96}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yMinFloSet"),
          Text(
            extent={{-96,-62},{-46,-76}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uConWatPum"),
          Text(
            extent={{-96,-32},{-36,-42}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uConWatIsoVal")}),
  Documentation(info="<html>
<p>
Block that generates signals to control devices when there is chiller plant 
stage-down command, according to ASHRAE Fundamentals of Chilled Water Plant 
Design and Control SDL, Chapter 7, Appendix B, 1.01.B.5.
</p>
<p>Whenever there is a stage-down command (<code>uChiSta</code> decrease):</p>
<p>
a. Shut off last stage chiller
</p>

<p>
b. When the controller of the chiller being shut off (<code>uChiCur</code> 
becoms less than <code>lowChiCur</code>) indicates no request for 
chilled water flow, slowly close the chiller's chilled water isolation valve
to avoid sudden change in flow through other operating chiller. For example, 
this could be accomplished by closing the valve in <code>turOffChiWatIsoTim</code>.
</p>

<p>
c. Disable condenser water isolation valve and when it is fully closed, shut
off last stage condenser water pump.
</p>

<p>
d. Change the minimum by pass controller setpoint to that appropriate for the
stage. For example, this could be accomplished by resetting the setpoint 
X GPM/second, where X = (NewSetpoint - OldSetpoint) / <code>byPasSetTim</code>. 
The minimum flow rate are as follows (based on manufactures' minimum flow rate 
plus 10% to ensure control variations
do not cause flow to go below actual minimum):
</p>
<table summary=\"summary\" border=\"1\">
<tr>
<th> Chiller stage </th> 
<th> Minimum flow </th>  
</tr>
<tr>
<td align=\"center\">0</td>
<td align=\"center\">0</td>
</tr>
<tr>
<td align=\"center\">1</td>
<td align=\"center\"><code>minFloSet</code>[1]</td>
</tr>
<tr>
<td align=\"center\">2</td>
<td align=\"center\"><code>minFloSet</code>[2]</td>
</tr>
<tr>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
</tr>
</table>
<br/>

</html>",
  revisions="<html>
<ul>
<li>
August 18, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
  end DownProcess;

  block UpProcess
    "Sequences to control equipments when chiller stage up"
    parameter Integer num = 2
      "Total number of chillers, the same number applied to isolation valves, CW pumps, CHW pumps";
    parameter Modelica.SIunits.Time holChiDemTim = 300
      "Time to hold limited chiller demand";
    parameter Modelica.SIunits.Time byPasSetTim = 300
      "Time to change minimum flow setpoint from old one to new one";
    parameter Modelica.SIunits.VolumeFlowRate minFloSet[num] = {0.0089, 0.0177}
      "Minimum flow rate at each chiller stage";
    parameter Modelica.SIunits.Time turOnChiWatIsoTim = 300
      "Time to open a new chilled water isolation valve";

    Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
      "Current chiller stage"
      annotation (Placement(transformation(extent={{-280,440},{-240,480}}),
        iconTransformation(extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,20})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiCur[num](
      final quantity="ElectricCurrent",
      final unit="A") "Chiller demand measured by electric current"
      annotation (Placement(transformation(extent={{-280,380},{-240,420}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[num]
      "Chiller status"
       annotation (Placement(transformation(extent={{-280,340},{-240,380}}),
         iconTransformation(extent={{-120,80},{-100,100}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatPum[num]
      "Condenser water pump status"
      annotation (Placement(transformation(extent={{-280,100},{-240,140}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatIsoVal[num](
      final unit="1",
      final min=0,
      final max=1) "Condense water isolation valve position"
      annotation (Placement(transformation(extent={{-280,30},{-240,70}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[num](
      final unit="1",
      final min=0,
      final max=1) "Chilled water isolation valve position"
      annotation (Placement(transformation(extent={{-280,-330},{-240,-290}}),
        iconTransformation(extent={{-120,-100},{-100,-80}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiCur[num](
      final quantity="ElectricCurrent",
      final unit="A") "Current setpoint to chillers"
      annotation (Placement(transformation(extent={{220,410},{240,430}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinFloSet(
      final unit="m3/s") "Minimum flow setpoint"
      annotation (Placement(transformation(extent={{220,210},{240,230}}),
        iconTransformation(extent={{100,-100},{120,-80}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yConWatPum[num]
      "Condenser water pump status"
      annotation (Placement(transformation(extent={{220,110},{240,130}}),
        iconTransformation(extent={{100,50},{120,70}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yConWatIsoVal[num]
      "Condenser water isolation valve status"
      annotation (Placement(transformation(extent={{220,40},{240,60}}),
        iconTransformation(extent={{100,10},{120,30}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoValSet[num](
      final min=0,
      final max=1,
      final unit="1") "Chilled water isolvation valve position setpoint"
      annotation (Placement(transformation(extent={{220,-160},{240,-140}}),
        iconTransformation(extent={{100,-30},{120,-10}})));

    Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[num]
      "Triggered sampler to sample current chiller demand"
      annotation (Placement(transformation(extent={{-160,390},{-140,410}})));
    Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(
      final nout=num) "Replicate input "
      annotation (Placement(transformation(extent={{-120,470},{-100,490}})));
    Buildings.Controls.OBC.CDL.Continuous.Gain gai[num](
      each final k=0.5) "Half of current load"
      annotation (Placement(transformation(extent={{-80,390},{-60,410}})));
    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys[num](
      each final uLow=0.54,
      each final uHigh=0.56)
      "Check if actual demand is more than 0.55 of demand at instant when receiving stage change signal"
      annotation (Placement(transformation(extent={{-40,320},{-20,340}})));
    Buildings.Controls.OBC.CDL.Continuous.Division div[num]
      "Output result of first input divided by second input"
      annotation (Placement(transformation(extent={{20,360},{40,380}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[num](
      each final k=0.2)
      "Constant value to avoid zero as the denominator"
      annotation (Placement(transformation(extent={{-160,320},{-140,340}})));
    Buildings.Controls.OBC.CDL.Logical.Switch swi[num]
      "Change zero input to a given constant if the chiller is not enabled"
      annotation (Placement(transformation(extent={{-100,350},{-80,370}})));
    Buildings.Controls.OBC.CDL.Logical.Not not1[num] "Logical not"
      annotation (Placement(transformation(extent={{0,320},{20,340}})));
    Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
      final delayTime=holChiDemTim) "Wait a giving time before proceeding"
      annotation (Placement(transformation(extent={{80,320},{100,340}})));
    Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(final nu=num)
      "Output true when elements of input vector are true"
      annotation (Placement(transformation(extent={{40,320},{60,340}})));
    Buildings.Controls.OBC.CDL.Integers.Change cha
      "Check chiller stage change status"
      annotation (Placement(transformation(extent={{-180,450},{-160,470}})));
    Buildings.Controls.OBC.CDL.Routing.RealExtractor curMinSet(nin=num)
      "Targeted minimum flow setpoint at current stage"
      annotation (Placement(transformation(extent={{-120,250},{-100,270}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1[num](
      final k=minFloSet)
      "Minimum flow setpoint"
      annotation (Placement(transformation(extent={{-180,250},{-160,270}})));
    Buildings.Controls.OBC.CDL.Integers.Add addInt(final k2=-1)
      "One stage lower than current one"
      annotation (Placement(transformation(extent={{-160,180},{-140,200}})));
    Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(final k=1)
      "Constant one"
      annotation (Placement(transformation(extent={{-200,180},{-180,200}})));
    Buildings.Controls.OBC.CDL.Routing.RealExtractor oldMinSet(final nin=num)
      "Minimum flow setpoint at old stage"
      annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
    Buildings.Controls.OBC.CDL.Continuous.Line lin
      "Minimum flow setpoint at current stage"
      annotation (Placement(transformation(extent={{-20,200},{0,220}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(final k=0)
      "Constant zero"
      annotation (Placement(transformation(extent={{-80,250},{-60,270}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
      final k=byPasSetTim)
      "Duration time to change old setpoint to new setpoint"
      annotation (Placement(transformation(extent={{-80,180},{-60,200}})));
    Buildings.Controls.OBC.CDL.Logical.Timer tim
      "Time after suppress chiller demand"
      annotation (Placement(transformation(extent={{-20,250},{0,270}})));
    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
      final uLow=byPasSetTim + 60 - 5,
      final uHigh=byPasSetTim + 60 + 5)
      "Check if it is 1 minute after new setpoint achieved"
      annotation (Placement(transformation(extent={{60,180},{80,200}})));
    Buildings.Controls.OBC.CDL.Integers.LessThreshold intLesThr(
      final threshold=1)
      "Check if it is zero stage"
      annotation (Placement(transformation(extent={{40,220},{60,240}})));
    Buildings.Controls.OBC.CDL.Logical.Switch swi1
      "Switch to current stage setpoint"
      annotation (Placement(transformation(extent={{100,210},{120,230}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(final k=0)
      "Zero minimal flow setpoint when it is zero stage"
      annotation (Placement(transformation(extent={{40,250},{60,270}})));
    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1[num](
      each final uLow=0.095,
      each final uHigh=0.105)
      "Check if the enabled isolation valve is open more than 10%"
      annotation (Placement(transformation(extent={{-200,40},{-180,60}})));
    Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi7[num] "Logical switch"
      annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
    Buildings.Controls.OBC.CDL.Logical.Sources.Constant con16[num](
      each final k=true) "Constant true"
      annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
    Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd3(final nu=num)
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(final delayTime=30)
      "Wait a giving time before proceeding"
      annotation (Placement(transformation(extent={{-20,40},{0,60}})));
    Buildings.Controls.OBC.CDL.Logical.And and2[num]
      "Check change of the chilled water isolation valve vector"
      annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
    Buildings.Controls.OBC.CDL.Logical.Not not2[num] "Logical not"
      annotation (Placement(transformation(extent={{-40,-190},{-20,-170}})));
    Buildings.Controls.OBC.CDL.Logical.And and1[num]
      "Check change of the chilled water isolation valve vector"
      annotation (Placement(transformation(extent={{20,-120},{40,-100}})));
    Buildings.Controls.OBC.CDL.Logical.Timer tim1
      "Time after starting CW pump and enabling CW isolation valve"
      annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
    Buildings.Controls.OBC.CDL.Continuous.Line lin1
      "Chilled water isolation valve setpoint"
      annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con6(final k=0)
      "Constant zero"
      annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con7(
      final k=turOnChiWatIsoTim)
      "Time to turn on chilled water isolation valve"
      annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con8(final k=1)
      "Constant 1"
      annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con9(final k=0)
      "Constant zero"
      annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
    Buildings.Controls.OBC.CDL.Logical.Switch swi3[num]
      "Position setpoint of chilled water isolation valve"
      annotation (Placement(transformation(extent={{80,-220},{100,-200}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con10[num](
      each final k=0) "Constant 0"
      annotation (Placement(transformation(extent={{20,-240},{40,-220}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con11[num](
      each k=1) "Constant 0"
      annotation (Placement(transformation(extent={{20,-200},{40,-180}})));
    Buildings.Controls.OBC.CDL.Logical.Switch swi2[num]
      "Position setpoint of chilled water isolation valve"
      annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con5[num](
      each final k=0) "Constant 0"
      annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
    Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(nout=num)
      "Replicate real input"
      annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
    Buildings.Controls.OBC.CDL.Continuous.Add add2[num]
      "Chilled water isolation valve position setpoint vector"
      annotation (Placement(transformation(extent={{160,-160},{180,-140}})));
    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3[num](
      each final uLow=0.025,
      each final uHigh=0.05)
      "Check if isolation valve is enabled"
      annotation (Placement(transformation(extent={{-180,-320},{-160,-300}})));
    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4[num](
      each final uLow=0.925,
      each final uHigh=0.975)
      "Check if isolation valve is open more than 95%"
      annotation (Placement(transformation(extent={{-180,-380},{-160,-360}})));
    Buildings.Controls.OBC.CDL.Logical.And and3[num] "Logical and"
      annotation (Placement(transformation(extent={{-60,-320},{-40,-300}})));
    Buildings.Controls.OBC.CDL.Logical.Not not3[num] "Logical not"
      annotation (Placement(transformation(extent={{-120,-350},{-100,-330}})));
    Buildings.Controls.OBC.CDL.Logical.Not not4[num] "Logical not"
      annotation (Placement(transformation(extent={{-120,-380},{-100,-360}})));
    Buildings.Controls.OBC.CDL.Logical.And and4[num] "Logical and"
      annotation (Placement(transformation(extent={{-60,-360},{-40,-340}})));
    Buildings.Controls.OBC.CDL.Logical.Or or2[num] "Logicla or"
      annotation (Placement(transformation(extent={{0,-340},{20,-320}})));
    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys5(
      each final uLow=turOnChiWatIsoTim - 5,
      each final uHigh=turOnChiWatIsoTim + 5)
      "Check if it has past the target time of open CHW isolation valve "
      annotation (Placement(transformation(extent={{20,-280},{40,-260}})));
    Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(nu=num)
      annotation (Placement(transformation(extent={{42,-340},{62,-320}})));
    Buildings.Controls.OBC.CDL.Logical.And and5 "Check if the isolation valve has been fully open"
      annotation (Placement(transformation(extent={{102,-320},{122,-300}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[num]
      "Chiller status"
      annotation (Placement(transformation(extent={{220,-450},{240,-430}}),
        iconTransformation(extent={{100,80},{120,100}})));
    Buildings.Controls.OBC.CDL.Logical.Switch swi4[num]
      "Current setpoint to chillers"
      annotation (Placement(transformation(extent={{180,410},{200,430}})));
    Buildings.Controls.OBC.CDL.Logical.Not not5 "Logical not"
      annotation (Placement(transformation(extent={{-60,450},{-40,470}})));
    Buildings.Controls.OBC.CDL.Logical.Or or1
      "Check if it is before stage change or all other changes have been made"
      annotation (Placement(transformation(extent={{80,450},{100,470}})));
    Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep2(final nout=num)
      "Replicate input "
      annotation (Placement(transformation(extent={{120,450},{140,470}})));

  equation
    connect(uChiCur, triSam.u)
      annotation (Line(points={{-260,400},{-162,400}}, color={0,0,127}));
    connect(booRep1.y, triSam.trigger)
      annotation (Line(points={{-99,480},{-80,480},{-80,440},{-180,440},
        {-180,380},{-150,380},{-150,388.2}}, color={255,0,255}));
    connect(triSam.y, gai.u)
      annotation (Line(points={{-139,400},{-82,400}}, color={0,0,127}));
    connect(uChi, swi.u2)
      annotation (Line(points={{-260,360},{-102,360}}, color={255,0,255}));
    connect(con.y, swi.u3)
      annotation (Line(points={{-139,330},{-120,330},{-120,352},{-102,352}},
        color={0,0,127}));
    connect(uChiCur, div.u1)
      annotation (Line(points={{-260,400},{-220,400},{-220,376},{18,376}},
        color={0,0,127}));
    connect(swi.y, div.u2)
      annotation (Line(points={{-79,360},{0,360},{0,364},{18,364}},
        color={0,0,127}));
    connect(hys.y, not1.u)
      annotation (Line(points={{-19,330},{-2,330}}, color={255,0,255}));
    connect(not1.y, mulAnd.u)
      annotation (Line(points={{21,330},{38,330}}, color={255,0,255}));
    connect(mulAnd.y, truDel.u)
      annotation (Line(points={{61.7,330},{78,330}}, color={255,0,255}));
    connect(uChiSta, cha.u)
      annotation (Line(points={{-260,460},{-182,460}}, color={255,127,0}));
    connect(cha.up, booRep1.u)
      annotation (Line(points={{-159,466},{-140,466},{-140,480},{-122,480}},
        color={255,0,255}));
    connect(con1.y,curMinSet. u)
      annotation (Line(points={{-159,260},{-122,260}},color={0,0,127}));
    connect(uChiSta, addInt.u1)
      annotation (Line(points={{-260,460},{-200,460},{-200,240},{-170,240},
        {-170,196},{-162,196}}, color={255,127,0}));
    connect(conInt.y, addInt.u2)
      annotation (Line(points={{-179,190},{-170,190},{-170,184},{-162,184}},
        color={255,127,0}));
    connect(con1.y, oldMinSet.u)
      annotation (Line(points={{-159,260},{-140,260},{-140,210},{-122,210}},
        color={0,0,127}));
    connect(uChiSta,curMinSet. index)
      annotation (Line(points={{-260,460},{-200,460},{-200,240},{-110,240},
        {-110,248}}, color={255,127,0}));
    connect(div.y, hys.u)
      annotation (Line(points={{41,370},{60,370},{60,352},{-60,352},{-60,330},
        {-42,330}}, color={0,0,127}));
    connect(triSam.y, swi.u1)
      annotation (Line(points={{-139,400},{-120,400},{-120,368},{-102,368}},
        color={0,0,127}));
    connect(con2.y, lin.x1)
      annotation (Line(points={{-59,260},{-46,260},{-46,218},{-22,218}},
        color={0,0,127}));
    connect(con3.y, lin.x2)
      annotation (Line(points={{-59,190},{-40,190},{-40,206},{-22,206}},
        color={0,0,127}));
    connect(truDel.y, tim.u)
      annotation (Line(points={{101,330},{120,330},{120,300},{-40,300},{-40,260},
        {-22,260}}, color={255,0,255}));
    connect(tim.y, lin.u)
      annotation (Line(points={{1,260},{20,260},{20,240},{-40,240},{-40,210},
        {-22,210}}, color={0,0,127}));
    connect(oldMinSet.y, lin.f1)
      annotation (Line(points={{-99,210},{-46,210},{-46,214},{-22,214}},
        color={0,0,127}));
    connect(tim.y, hys2.u)
      annotation (Line(points={{1,260},{20,260},{20,190},{58,190}},
        color={0,0,127}));
    connect(addInt.y, oldMinSet.index)
      annotation (Line(points={{-139,190},{-110,190},{-110,198}}, color={255,127,0}));
    connect(uChiSta, intLesThr.u)
      annotation (Line(points={{-260,460},{-200,460},{-200,280},{30,280},
        {30,230},{38,230}}, color={255,127,0}));
    connect(con4.y, swi1.u1)
      annotation (Line(points={{61,260},{90,260},{90,228},{98,228}}, color={0,0,127}));
    connect(intLesThr.y, swi1.u2)
      annotation (Line(points={{61,230},{80,230},{80,220},{98,220}}, color={255,0,255}));
    connect(lin.y, swi1.u3)
      annotation (Line(points={{1,210},{80,210},{80,212},{98,212}}, color={0,0,127}));
    connect(swi1.y, yMinFloSet)
      annotation (Line(points={{121,220},{230,220}}, color={0,0,127}));
    connect(curMinSet.y, lin.f2)
      annotation (Line(points={{-99,260},{-90,260},{-90,220},{-52,220},{-52,202},
        {-22,202}},color={0,0,127}));
    connect(uConWatIsoVal, hys1.u)
      annotation (Line(points={{-260,50},{-202,50}}, color={0,0,127}));
    connect(hys1.y, logSwi7.u1)
      annotation (Line(points={{-179,50},{-160,50},{-160,58},{-122,58}},
        color={255,0,255}));
    connect(con16.y, logSwi7.u3)
      annotation (Line(points={{-179,20},{-140,20},{-140,42},{-122,42}},
        color={255,0,255}));
    connect(logSwi7.y, mulAnd3.u)
      annotation (Line(points={{-99,50},{-62,50}}, color={255,0,255}));
    connect(mulAnd3.y, truDel1.u)
      annotation (Line(points={{-38.3,50},{-22,50}}, color={255,0,255}));
    connect(uConWatPum, enaPum.uDevSta)
      annotation (Line(points={{-260,120},{-102,120}}, color={255,0,255}));
    connect(hys2.y, enaPum.uEnaNex)
      annotation (Line(points={{81,190},{100,190},{100,160},{-120,160},{-120,112},
        {-102,112}}, color={255,0,255}));
    connect(enaPum.yDevSta, yConWatPum)
      annotation (Line(points={{-79,120},{230,120}}, color={255,0,255}));
    connect(enaPum.yDevSta, yConWatIsoVal)
      annotation (Line(points={{-79,120},{160,120},{160,50},{230,50}},
        color={255,0,255}));
    connect(uChi, enaChiWatIso.uDevSta)
      annotation (Line(points={{-260,360},{-220,360},{-220,-150},{-162,-150}},
        color={255,0,255}));
    connect(truDel1.y, enaChiWatIso.uEnaNex)
      annotation (Line(points={{1,50},{40,50},{40,0},{-180,0},{-180,-158},
        {-162,-158}}, color={255,0,255}));
    connect(enaPum.yDevSta, logSwi7.u2)
      annotation (Line(points={{-79,120},{-60,120},{-60,80},{-140,80},{-140,50},
        {-122,50}}, color={255,0,255}));
    connect(uChi, and2.u2)
      annotation (Line(points={{-260,360},{-220,360},{-220,-188},{-82,-188}},
        color={255,0,255}));
    connect(enaChiWatIso.yDevSta, and2.u1)
      annotation (Line(points={{-139,-150},{-100,-150},{-100,-180},{-82,-180}},
        color={255,0,255}));
    connect(and2.y, not2.u)
      annotation (Line(points={{-59,-180},{-42,-180}}, color={255,0,255}));
    connect(enaChiWatIso.yDevSta, and1.u1)
      annotation (Line(points={{-139,-150},{-20,-150},{-20,-110},{18,-110}},
        color={255,0,255}));
    connect(not2.y, and1.u2)
      annotation (Line(points={{-19,-180},{0,-180},{0,-118},{18,-118}},
        color={255,0,255}));
    connect(truDel1.y, tim1.u)
      annotation (Line(points={{1,50},{40,50},{40,0},{-180,0},{-180,-70},
        {-162,-70}}, color={255,0,255}));
    connect(con6.y, lin1.f1)
      annotation (Line(points={{-139,-30},{-100,-30},{-100,-66},{-22,-66}},
        color={0,0,127}));
    connect(con9.y, lin1.x1)
      annotation (Line(points={{-59,-30},{-40,-30},{-40,-62},{-22,-62}},
        color={0,0,127}));
    connect(con7.y, lin1.x2)
      annotation (Line(points={{-139,-110},{-100,-110},{-100,-74},{-22,-74}},
        color={0,0,127}));
    connect(con8.y, lin1.f2)
      annotation (Line(points={{-59,-110},{-40,-110},{-40,-78},{-22,-78}},
        color={0,0,127}));
    connect(tim1.y, lin1.u)
      annotation (Line(points={{-139,-70},{-22,-70}}, color={0,0,127}));
    connect(con10.y, swi3.u3)
      annotation (Line(points={{41,-230},{60,-230},{60,-218},{78,-218}},
        color={0,0,127}));
    connect(con11.y, swi3.u1)
      annotation (Line(points={{41,-190},{60,-190},{60,-202},{78,-202}},
        color={0,0,127}));
    connect(uChi, swi3.u2)
      annotation (Line(points={{-260,360},{-220,360},{-220,-210},{78,-210}},
        color={255,0,255}));
    connect(lin1.y, reaRep.u)
      annotation (Line(points={{1,-70},{18,-70}}, color={0,0,127}));
    connect(reaRep.y, swi2.u1)
      annotation (Line(points={{41,-70},{60,-70},{60,-82},{98,-82}},
        color={0,0,127}));
    connect(and1.y, swi2.u2)
      annotation (Line(points={{41,-110},{60,-110},{60,-90},{98,-90}},
        color={255,0,255}));
    connect(con5.y, swi2.u3)
      annotation (Line(points={{41,-150},{80,-150},{80,-98},{98,-98}},
        color={0,0,127}));
    connect(swi3.y, add2.u2)
      annotation (Line(points={{101,-210},{140,-210},{140,-156},{158,-156}},
        color={0,0,127}));
    connect(swi2.y, add2.u1)
      annotation (Line(points={{121,-90},{140,-90},{140,-144},{158,-144}},
        color={0,0,127}));
    connect(add2.y, yChiWatIsoValSet)
      annotation (Line(points={{181,-150},{230,-150}}, color={0,0,127}));
    connect(uChiWatIsoVal, hys3.u)
      annotation (Line(points={{-260,-310},{-182,-310}}, color={0,0,127}));
    connect(uChiWatIsoVal, hys4.u)
      annotation (Line(points={{-260,-310},{-200,-310},{-200,-370},{-182,-370}},
        color={0,0,127}));
    connect(hys3.y, and3.u1)
      annotation (Line(points={{-159,-310},{-62,-310}}, color={255,0,255}));
    connect(hys4.y, and3.u2)
      annotation (Line(points={{-159,-370},{-140,-370},{-140,-318},{-62,-318}},
        color={255,0,255}));
    connect(hys3.y, not3.u)
      annotation (Line(points={{-159,-310},{-130,-310},{-130,-340},{-122,-340}},
        color={255,0,255}));
    connect(hys4.y, not4.u)
      annotation (Line(points={{-159,-370},{-122,-370}}, color={255,0,255}));
    connect(not3.y, and4.u1)
      annotation (Line(points={{-99,-340},{-80,-340},{-80,-350},{-62,-350}},
        color={255,0,255}));
    connect(not4.y, and4.u2)
      annotation (Line(points={{-99,-370},{-79.5,-370},{-79.5,-358},{-62,-358}},
        color={255,0,255}));
    connect(and3.y, or2.u1)
      annotation (Line(points={{-39,-310},{-20,-310},{-20,-330},{-2,-330}},
        color={255,0,255}));
    connect(and4.y, or2.u2)
      annotation (Line(points={{-39,-350},{-20,-350},{-20,-338},{-2,-338}},
        color={255,0,255}));
    connect(or2.y, mulAnd1.u)
      annotation (Line(points={{21,-330},{40,-330}},  color={255,0,255}));
    connect(hys5.y, and5.u1)
      annotation (Line(points={{41,-270},{80,-270},{80,-310},{100,-310}},
        color={255,0,255}));
    connect(mulAnd1.y, and5.u2)
      annotation (Line(points={{63.7,-330},{80,-330},{80,-318},{100,-318}},
        color={255,0,255}));
    connect(uChi, enaChi.uDevSta)
      annotation (Line(points={{-260,360},{-220,360},{-220,-440},{-102,-440}},
        color={255,0,255}));
    connect(and5.y, enaChi.uEnaNex)
      annotation (Line(points={{123,-310},{140,-310},{140,-400},{-200,-400},
        {-200,-448},{-102,-448}},color={255,0,255}));
    connect(enaChi.yDevSta, yChi)
      annotation (Line(points={{-79,-440},{230,-440}}, color={255,0,255}));
    connect(cha.y, not5.u)
      annotation (Line(points={{-159,460},{-62,460}}, color={255,0,255}));
    connect(swi4.y, yChiCur)
      annotation (Line(points={{201,420},{230,420}}, color={0,0,127}));
    connect(not5.y, or1.u1)
      annotation (Line(points={{-39,460},{78,460}}, color={255,0,255}));
    connect(and5.y, or1.u2)
      annotation (Line(points={{123,-310},{136,-310},{136,440},{60,440},{60,452},
        {78,452}}, color={255,0,255}));
    connect(or1.y, booRep2.u)
      annotation (Line(points={{101,460},{118,460}}, color={255,0,255}));
    connect(booRep2.y, swi4.u2)
      annotation (Line(points={{141,460},{160,460},{160,420},{178,420}},
        color={255,0,255}));
    connect(gai.y, swi4.u3)
      annotation (Line(points={{-59,400},{60,400},{60,412},{178,412}},
        color={0,0,127}));
    connect(uChiCur, swi4.u1)
      annotation (Line(points={{-260,400},{-220,400},{-220,428},{178,428}},
        color={0,0,127}));
    connect(tim1.y, hys5.u)
      annotation (Line(points={{-139,-70},{-120,-70},{-120,-270},{18,-270}},
        color={0,0,127}));

  annotation (
    defaultComponentName = "staUp",
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-240,-480},{220,500}}), graphics={
                                               Rectangle(
            extent={{-238,498},{218,322}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),         Rectangle(
            extent={{-238,278},{218,182}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),         Rectangle(
            extent={{-238,158},{218,82}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),         Rectangle(
            extent={{-238,58},{218,2}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),         Rectangle(
            extent={{-238,-22},{218,-258}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),         Rectangle(
            extent={{-238,-282},{218,-378}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),         Rectangle(
            extent={{-238,-402},{218,-458}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
            Text(
            extent={{38,500},{210,478}},
            pattern=LinePattern.None,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            horizontalAlignment=TextAlignment.Left,
            textString="Check if there is stage change, if it is stage up"),
            Text(
            extent={{66,412},{212,376}},
            pattern=LinePattern.None,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            horizontalAlignment=TextAlignment.Right,
            textString="Limit chiller demand to 0.5 of 
current load"),
            Text(
            extent={{-18,372},{214,334}},
            pattern=LinePattern.None,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            horizontalAlignment=TextAlignment.Right,
            textString="Ensure actual demand has been less than
0.55 by more than 5 minutes"),
            Text(
            extent={{64,278},{212,240}},
            pattern=LinePattern.None,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            horizontalAlignment=TextAlignment.Right,
            textString="Slowly change minimum 
flow rate setpoint"),
            Text(
            extent={{52,218},{210,180}},
            pattern=LinePattern.None,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            horizontalAlignment=TextAlignment.Right,
            textString="After new setpoint is 
achieved, wait 1 minute"),
            Text(
            extent={{140,152},{212,140}},
            pattern=LinePattern.None,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            horizontalAlignment=TextAlignment.Right,
            textString="Start next CW pump"),
            Text(
            extent={{122,52},{212,30}},
            pattern=LinePattern.None,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            horizontalAlignment=TextAlignment.Right,
            textString="Enable CW isolation valve"),
            Text(
            extent={{-90,32},{212,4}},
            pattern=LinePattern.None,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            horizontalAlignment=TextAlignment.Right,
            textString="Check if all the enabled CW isolation valves have
open more than 0.1, then wait 30 seconds"),
            Text(
            extent={{84,-34},{212,-68}},
            pattern=LinePattern.None,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            horizontalAlignment=TextAlignment.Right,
            textString="Slowly open next CHW 
isolation valve"),
            Text(
            extent={{-16,-340},{210,-372}},
            pattern=LinePattern.None,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            horizontalAlignment=TextAlignment.Right,
            textString="Check if all enabled CHW isolation valves 
have been fully open"),
            Text(
            extent={{154,-410},{214,-432}},
            pattern=LinePattern.None,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            horizontalAlignment=TextAlignment.Right,
            textString="Start next chiller")}),
      Icon(graphics={
          Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Text(
            extent={{-120,146},{100,108}},
            lineColor={0,0,255},
            textString="%name"),
          Text(
            extent={{-100,94},{-74,86}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uChi"),
          Text(
            extent={{-96,-12},{-42,-24}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uConWatPum"),
          Text(
            extent={{-96,68},{-66,56}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uChiCur"),
          Text(
            extent={{-96,-46},{-32,-70}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uConWatIsoVal"),
          Text(
            extent={{-96,-82},{-32,-94}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uChiWatIsoVal"),
          Text(
            extent={{74,94},{102,84}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yChi"),
          Text(
            extent={{64,-54},{96,-64}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yChiCur"),
          Text(
            extent={{-16,4.5},{16,-4.5}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uChiSta",
            origin={-82,22.5},
            rotation=0),
          Text(
            extent={{44,68},{96,54}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yConWatPum"),
          Text(
            extent={{40,28},{98,14}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yConWatIsoVal"),
          Text(
            extent={{26,-14},{96,-28}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yChiWatIsoValSet"),
          Text(
            extent={{56,-84},{98,-96}},
            lineColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yMinFloSet")}),
  Documentation(info="<html>
<p>
Block that generates signals to control devices when there is chiller plant 
stage-up command, according to ASHRAE Fundamentals of Chilled Water Plant 
Design and Control SDL, Chapter 7, Appendix B, 1.01.B.4.
</p>
<p>Whenever there is a stage-up command (<code>uChiSta</code> increases):</p>
<p>
a. Command operating chillers (true elements in <code>uChi</code> vector) to 
reduce demand (currents) to 50% of their load (<code>uChiCur</code>). Wait until
actual demand becomes less than 55% up to a maximum of <code>holChiDemTim</code>
(e.g. 5 minutes) before proceeding.
</p>

<p>
b. Slowly change the minimum bypass controller setpoint <code>yMinFloSet</code> 
to that appropriate for the stage as indicated below. For example, this could 
be accomplished by resetting the setpoint X GPM/second, where X = (NewSetpoint 
- OldSetpoint) / <code>byPasSetTim</code>. The minimum flow rate are as follows
(based on manufactures' minimum flow rate plus 10% to ensure control variations
do not cause flow to go below actual minimum):
</p>
<table summary=\"summary\" border=\"1\">
<tr>
<th> Chiller stage </th> 
<th> Minimum flow </th>  
</tr>
<tr>
<td align=\"center\">0</td>
<td align=\"center\">0</td>
</tr>
<tr>
<td align=\"center\">1</td>
<td align=\"center\"><code>minFloSet</code>[1]</td>
</tr>
<tr>
<td align=\"center\">2</td>
<td align=\"center\"><code>minFloSet</code>[2]</td>
</tr>
<tr>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
</tr>
</table>
<br/>
<p>
After new setpoint is achieved wait 1 minute to allow loop to stabilize.
</p>

<p>
c. Start the next CW pump <code>uConWatPum</code> and enable the CW 
isolation/head pressure control valve <code>uConWatIsoVal</code>. Wait 30 seconds.
</p>

<p>
d. Slowly open CHW isolation valve of the chiller that is to be started,
e.g. change the open position setpoint <code>yChiWatIsoValSet</code>
to be nonzero. The purpose of slow-opening is to prevent sudden disruption to 
flow through active chillers. Valve timing <code>turOnChiWatIsoTim</code> to 
be determined in the field as that required to prevent nuisance trips.
</p>

<p>
e. Start the next stage chiller <code>uChi</code> after CHW isolation valve is fully open.
</p>

<p>
f. Release the demand limit <code>yChiCur</code>.
</p>

</html>",
  revisions="<html>
<ul>
<li>
July 28, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
  end UpProcess;

  package Validation "Collection of validation models"
    extends Modelica.Icons.ExamplesPackage;

    model Capacities_uSta
      "Validate water side economizer tuning parameter sequence"

      parameter Integer numSta = 2
      "Highest chiller stage";

      parameter Real minPlrSta0 = 0.1
      "Minimal part load ratio of the first stage";

      parameter Real capSta1 = 3.517*1000*310
      "Capacity of stage 1";

      parameter Real capSta2 = 2*capSta1
      "Capacity of stage 2";

      parameter Real small = 0.001
      "Small number to avoid division with zero";

      Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities staCap0(
        final numSta = 2,
        final min_plr1=minPlrSta0,
        final staNomCap={small,capSta1,capSta2})
        annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

      Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities staCap1(
        final numSta = 2,
        final min_plr1=minPlrSta0,
        final staNomCap={small,capSta1,capSta2})
        annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

      Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities staCap2(
        final numSta = 2,
        final min_plr1=minPlrSta0,
        final staNomCap={small,capSta1,capSta2})
        annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

      Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage0(k=0) "Stage 0"
        annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

      Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(k=1) "Stage 1"
        annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

      Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage2(k=2) "Stage 2"
        annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sta0(k=small)
        "Nominal and minimal capacity at stage 0"
        annotation (Placement(transformation(extent={{0,70},{20,90}})));

      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sta1min(
        final k=minPlrSta0*capSta1)
        "Minimal capacity at stage 1"
        annotation (Placement(transformation(extent={{0,30},{20,50}})));

      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sta1(
        final k=capSta1) "Nominal capacity at stage 1"
        annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sta2(
        final k=capSta2) "Nominal capacity at stage 2"
        annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

      Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta0[2]
        "Delta between the expected and the calculated value"
        annotation (Placement(transformation(extent={{60,70},{80,90}})));

      Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta2[2]
        "Delta between the expected and the calculated value"
        annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

      Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta1[2]
        "Delta between the expected and the calculated value"
        annotation (Placement(transformation(extent={{60,-20},{80,0}})));

    equation

      connect(stage0.y, staCap0.uSta)
        annotation (Line(points={{-59,60},{-42,60}}, color={255,127,0}));
      connect(stage1.y, staCap1.uSta)
        annotation (Line(points={{-59,0},{-42,0}}, color={255,127,0}));
      connect(stage2.y, staCap2.uSta)
        annotation (Line(points={{-59,-50},{-42,-50}}, color={255,127,0}));
      connect(staCap0.yLowSta, absErrorSta0[1].u1) annotation (Line(points={{-19,56},
              {50,56},{50,80},{58,80}},         color={0,0,127}));
      connect(staCap0.ySta, absErrorSta0[2].u1) annotation (Line(points={{-19,64},
              {50,64},{50,80},{58,80}},     color={0,0,127}));
      connect(sta0.y, absErrorSta0[1].u2) annotation (Line(points={{21,80},{30,
              80},{30,48},{70,48},{70,68}},
                                       color={0,0,127}));
      connect(staCap1.yLowSta, absErrorSta1[1].u1) annotation (Line(points={{-19,-4},
              {-10,-4},{-10,-10},{58,-10}}, color={0,0,127}));
      connect(staCap1.ySta, absErrorSta1[2].u1) annotation (Line(points={{-19,4},{-10,
              4},{-10,-10},{58,-10}}, color={0,0,127}));
      connect(sta1min.y, absErrorSta1[1].u2) annotation (Line(points={{21,40},{50,40},
              {50,-30},{70,-30},{70,-22}},
                                  color={0,0,127}));
      connect(sta1.y, absErrorSta1[2].u2) annotation (Line(points={{21,-30},{70,-30},
              {70,-22}},         color={0,0,127}));
      connect(staCap2.yLowSta, absErrorSta2[1].u1) annotation (Line(points={{-19,-54},
              {50,-54},{50,-50},{58,-50}}, color={0,0,127}));
      connect(staCap2.ySta, absErrorSta2[2].u1) annotation (Line(points={{-19,-46},{
              -10,-46},{-10,-50},{58,-50}},
                                          color={0,0,127}));
      connect(sta1.y, absErrorSta2[1].u2) annotation (Line(points={{21,-30},{40,
              -30},{40,-70},{70,-70},{70,-62}},
                                 color={0,0,127}));
      connect(sta2.y, absErrorSta2[2].u2) annotation (Line(points={{21,-70},{70,-70},
              {70,-62}},                   color={0,0,127}));
      connect(sta0.y, absErrorSta0[2].u2) annotation (Line(points={{21,80},{40,
              80},{40,48},{70,48},{70,68}}, color={0,0,127}));
    annotation (
     experiment(StopTime=3600.0, Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Generic/Validation/Capacities_uSta.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities</a>.
</p>
</html>",     revisions="<html>
<ul>
<li>
October 13, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
            Ellipse(lineColor = {75,138,73},
                    fillColor={255,255,255},
                    fillPattern = FillPattern.Solid,
                    extent = {{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end Capacities_uSta;

    model CapacityRequirement
      "Validates the cooling capacity requirement calculation"

      Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.CapacityRequirement
        capReq annotation (Placement(transformation(extent={{20,0},{40,20}})));

    //protected
      parameter Modelica.SIunits.Temperature TChiWatSupSet = 285.15
      "Chilled water supply set temperature";

      parameter Modelica.SIunits.Temperature aveTChiWatRet = 288.15
      "Average measured chilled water return temperature";

      parameter Real aveVChiWat_flow(
        final quantity="VolumeFlowRate",
        final unit="m3/s") = 0.05
        "Average measured chilled water flow rate";

      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(
        final k=TChiWatSupSet)
        "Chilled water supply temperature"
        annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

      Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TChiWatRet(
        final amplitude=2,
        final freqHz=1/300,
        final offset=aveTChiWatRet) "Chiller water return temeprature"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

      Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatFlow(
        final freqHz=1/600,
        final offset=aveVChiWat_flow,
        final amplitude=0.01) "Chilled water flow"
        annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

    equation

      connect(TCWSupSet.y, capReq.TChiWatSupSet) annotation (Line(points={{-59,60},{
              -20,60},{-20,15},{19,15}}, color={0,0,127}));
      connect(TChiWatRet.y, capReq.TChiWatRet) annotation (Line(points={{-59,20},{-30,
              20},{-30,10},{19,10}}, color={0,0,127}));
      connect(chiWatFlow.y, capReq.VChiWat_flow) annotation (Line(points={{-59,-30},
              {-20,-30},{-20,5},{19,5}}, color={0,0,127}));
    annotation (
     experiment(StopTime=3600.0, Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Generic/Validation/CapacityRequirement.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.CapacityRequirement\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.CapacityRequirement</a>.
</p>
</html>",     revisions="<html>
<ul>
<li>
October 13, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
            Ellipse(lineColor = {75,138,73},
                    fillColor={255,255,255},
                    fillPattern = FillPattern.Solid,
                    extent = {{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end CapacityRequirement;

    model ChillerdTRef "Validate model of calculate chiller LIFT"

      Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.ChillerdTRef
        chillerdTRef_Sim(
        APPROACH_nominal=5,
        cooTowEff=21,
        dTRefMin=5,
        TWetBul_nominal=298.15,
        TConWatRet_nominal=303.15,
        TChiWatSup_nominal=280.15,
        plaCap_nominal=2600000)
        "Calculate current chiller lift, with simple algorithm"
        annotation (Placement(transformation(extent={{20,20},{40,40}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatSupTem(
        amplitude=2,
        freqHz=1/1800,
        offset=279.15) "Chilled water supply temperature"
        annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatRetTem(
        amplitude=2,
        freqHz=1/1800,
        offset=286.15) "Chilled water return temperature"
        annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiWatFloRat(
        duration=3600,
        height=0.05,
        offset=0.01) "Chilled water flow rate"
        annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.ChillerdTRef
        chillerdTRef(
        APPROACH_nominal=5,
        cooTowEff=21,
        dTRefMin=5,
        use_simCoe=false,
        TWetBul_nominal=298.15,
        TConWatRet_nominal=303.15,
        TChiWatSup_nominal=280.15,
        plaCap_nominal=2600000) "Calculate current chiller lift"
        annotation (Placement(transformation(extent={{20,-20},{40,0}})));

    equation
      connect(chiWatSupTem.y, chillerdTRef_Sim.TChiWatSup)
              annotation (Line(points={{-39,40},{-10,40},{-10,36},{18,36}}, color={0,0,127}));
      connect(chiWatRetTem.y, chillerdTRef_Sim.TChiWatRet)
              annotation (Line(points={{-39,0},{-10,0},{-10,30},{18,30}},
              color={0,0,127}));
      connect(chiWatFloRat.y, chillerdTRef_Sim.VEva_flow)
              annotation (Line(points={{-39,-40},{0,-40},{0,24},{18,24}},
              color={0,0,127}));
      connect(chiWatSupTem.y, chillerdTRef.TChiWatSup)
              annotation (Line(points={{-39,40},{-20,40},{-20,-4},{18,-4}},
              color={0,0,127}));
      connect(chiWatRetTem.y, chillerdTRef.TChiWatRet)
              annotation (Line(points={{-39,0},{-10,0},{-10,-10},{18,-10}},
              color={0,0,127}));
      connect(chiWatFloRat.y, chillerdTRef.VEva_flow)
              annotation (Line(points={{-39,-40},{0,-40},{0,-16},{18,-16}},
              color={0,0,127}));

    annotation (
     experiment(StopTime=3600.0, Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/ChillerdTRef.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChilledTRef\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChilledTRef</a>.
</p>
</html>",     revisions="<html>
<ul>
<li>
March 14, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
            Ellipse(lineColor = {75,138,73},
                    fillColor={255,255,255},
                    fillPattern = FillPattern.Solid,
                    extent = {{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end ChillerdTRef;
  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains validation models for the classes in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences</a>.
</p>
<p>
Note that most validation models contain simple input data
which may not be realistic, but for which the correct
output can be obtained through an analytic solution.
The examples plot various outputs, which have been verified against these
solutions. These model outputs are stored as reference data and
used for continuous validation whenever models in the library change.
</p>
</html>"));
  end Validation;
annotation (preferredView="info", Documentation(info="<html>
<p>
fixme: add a package description.
</p>
</html>"));
end Generic;
