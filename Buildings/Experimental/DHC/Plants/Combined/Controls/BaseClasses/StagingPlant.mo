within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block StagingPlant
  "Block that computes the command signals for chillers and HRC"

  parameter Integer nChi(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation (Dialog(group="CHW loop and cooling-only chillers"),
      Evaluate=true);
  parameter Modelica.Units.SI.HeatFlowRate QChiWatChi_flow_nominal
    "Cooling design heat flow rate of cooling-only chillers (all units)"
    annotation (Dialog(group="CHW loop and cooling-only chillers"));
  parameter Integer nChiHea(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation (Dialog(group="HW loop and heat recovery chillers"),
      Evaluate=true);
  parameter Real PLRStaTra(final unit="1", final min=0, final max=1) = 0.85
    "Part load ratio triggering stage transition";
  parameter Modelica.Units.SI.HeatFlowRate QChiWatCasCoo_flow_nominal
    "Cooling design heat flow rate of HRC in cascading cooling mode (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.HeatFlowRate QHeaWat_flow_nominal
    "Heating design heat flow rate (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Specific heat capacity of the fluid";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput mChiWatPri_flow(
    final unit="kg/s")
    "Primary CHW mass flow rate"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
                             iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K", displayUnit="degC")
    "CHW supply temperature setpoint" annotation (Placement(transformation(
          extent={{-240,60},{-200,100}}), iconTransformation(extent={{-140,0},{-100,
            40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatPriRet(final unit="K",
      displayUnit="degC") "Primary CHW return temperature" annotation (
      Placement(transformation(extent={{-240,20},{-200,60}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mHeaWatPri_flow(final unit="kg/s")
    "Primary HW mass flow rate" annotation (Placement(transformation(extent={{-240,
            -120},{-200,-80}}),iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K", displayUnit="degC")
    "HW supply temperature setpoint" annotation (Placement(transformation(
          extent={{-240,-160},{-200,-120}}),
                                        iconTransformation(extent={{-140,-70},{-100,
            -30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatPriRet(final unit="K",
      displayUnit="degC") "Primary HW return temperature" annotation (Placement(
        transformation(extent={{-240,-200},{-200,-160}}), iconTransformation(
          extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingAverage movAve(delta=300)
    "Moving average"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply loaChiWat
    "Compute total chiller load"
    annotation (Placement(transformation(extent={{-150,90},{-130,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dTChiWat "Compute deltaT"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply loaHeaWat
    "Compute total chiller load"
    annotation (Placement(transformation(extent={{-150,-130},{-130,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dTHeaWat "Compute deltaT"
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter scaChi(final k=nChi/
        QChiWatChi_flow_nominal/PLRStaTra) "Scale"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Ceiling numChi(final yMin=0, final yMax=nChi)
    "Compute number of chillers required to meet cooling load"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter loaChiWatChi(final k=
        QChiWatChi_flow_nominal/nChi)
    "Compute minimum load covered by chillers"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-120,0})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract loaChiWatChiHea
    "Compute maximum load to be covered by HRC"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter scaChiHea(
    final k=nChiHea/QChiWatCasCoo_flow_nominal/PLRStaTra) "Scale"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Ceiling numCoo(final yMin=0, final yMax=nChiHea)
    "Compute number of HRC required to meet cooling load"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(final nout=
        nChi)
    "Replicate"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold cmdChi[nChi](final
      t={i for i in 1:nChi})
    "Compute chiller On/Off command from number of units to be commanded On"
    annotation (Placement(transformation(extent={{150,90},{170,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo
    "Cooling enable signal"
    annotation (Placement(transformation(extent={{-240,160},{-200,200}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea
    "Heating enable signal"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Chi[nChi]
    "Chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,60})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1CooChiHea[nChiHea]
    "HR chiller cooling mode switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,20}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-40})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter timCp(final k=
        cp_default) "Scale"
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter timCp1(final k=
        cp_default) "Scale"
    annotation (Placement(transformation(extent={{-188,-110},{-168,-90}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold scaChi1(t=nChi)
                                           "Scale"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea "Convert"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-140,30})));
  Buildings.Controls.OBC.CDL.Continuous.MovingAverage movAve1(delta=300)
    "Moving average"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter scaChi3(final k=
        nChiHea/QHeaWat_flow_nominal/PLRStaTra)
                                           "Scale"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Ceiling numHea(final yMin=0, final yMax=nChiHea)
    "Compute number of HRC required to meet heating load"
    annotation (Placement(transformation(extent={{-50,-130},{-30,-110}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep5(final nout=
        nChiHea)
    "Replicate"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold cmdChiHea[nChiHea](
      final t={i for i in 1:nChiHea})
    "Compute chiller On/Off command from number of units to be commanded On"
    annotation (Placement(transformation(extent={{150,-130},{170,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Subtract numChiHeaCoo
    "Number of HRC required in direct HR mode" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,-50})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant numChiHea(final k=
        nChiHea) "Number of HRC"
    annotation (Placement(transformation(extent={{-10,-86},{10,-66}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ChiHea[nChiHea]
    "HRC On/Off command" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,-120}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,0})));
  IntegerArrayHold
              holChi(holdDuration=15*60, nin=1)
    "Hold signal to ensure minimum runtime at given stage"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply numOpeChi
    "Number of chillers both enabled and required to meet cooling load"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply numOpeCoo
    "Number of HRC both enabled and required to meet cooling load"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply numOpeHea
    "Number of HRC both enabled and required to meet heating load"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Add nChiHeaAndCooUnb
    "Number of HRC required to meet heating and cooling load - Unbounded"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-44})));
  Buildings.Controls.OBC.CDL.Integers.Subtract numChiCasCoo
    "Number of HRC required in cascading cooling"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  IntegerArrayHold
              holOpeChiHea(holdDuration=15*60, nin=1)
    "Hold signal to ensure minimum runtime at given stage"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));
  ModeHeatRecoveryChiller modHeaCoo(final nChiHea=nChiHea)
    "Compute the indices of HRC required to be operating in direct HR mode"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaCooChiHea[nChiHea]
    "HR chiller cooling mode switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,-50}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-80})));
  Buildings.Controls.OBC.CDL.Integers.Min nChiHeaHeaAndCoo
    "Number of HRC required to meet heating and cooling load - Bounded by number of HRC"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-70})));
  IntegerArrayHold hol(nin=3, holdDuration=15*60)
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
equation
  connect(dTChiWat.y, loaChiWat.u2) annotation (Line(points={{-158,60},{-156,60},
          {-156,94},{-152,94}},   color={0,0,127}));
  connect(TChiWatSupSet, dTChiWat.u1) annotation (Line(points={{-220,80},{-190,80},
          {-190,66},{-182,66}},        color={0,0,127}));
  connect(TChiWatPriRet, dTChiWat.u2) annotation (Line(points={{-220,40},{-188,
          40},{-188,54},{-182,54}}, color={0,0,127}));
  connect(dTHeaWat.y, loaHeaWat.u2) annotation (Line(points={{-158,-160},{-156,-160},
          {-156,-126},{-152,-126}},
                                  color={0,0,127}));
  connect(THeaWatSupSet, dTHeaWat.u1) annotation (Line(points={{-220,-140},{-190,
          -140},{-190,-154},{-182,-154}},         color={0,0,127}));
  connect(THeaWatPriRet, dTHeaWat.u2) annotation (Line(points={{-220,-180},{-190,
          -180},{-190,-166},{-182,-166}}, color={0,0,127}));
  connect(scaChi.y, numChi.u)
    annotation (Line(points={{-58,100},{-42,100}}, color={0,0,127}));
  connect(movAve.y, loaChiWatChiHea.u1) annotation (Line(points={{-98,100},{-90,
          100},{-90,20},{-110,20},{-110,6},{-102,6}},
                                   color={0,0,127}));
  connect(loaChiWatChi.y, loaChiWatChiHea.u2) annotation (Line(points={{-108,0},
          {-104,0},{-104,-6},{-102,-6}},
                                       color={0,0,127}));
  connect(loaChiWatChiHea.y, scaChiHea.u)
    annotation (Line(points={{-78,0},{-72,0}},   color={0,0,127}));
  connect(scaChiHea.y, numCoo.u)
    annotation (Line(points={{-48,0},{-42,0}},   color={0,0,127}));
  connect(rep.y, cmdChi.u)
    annotation (Line(points={{142,100},{148,100}},
                                                 color={255,127,0}));
  connect(movAve.y, scaChi.u)
    annotation (Line(points={{-98,100},{-82,100}}, color={0,0,127}));
  connect(mChiWatPri_flow, timCp.u)
    annotation (Line(points={{-220,120},{-182,120}}, color={0,0,127}));
  connect(timCp.y, loaChiWat.u1) annotation (Line(points={{-158,120},{-156,120},
          {-156,106},{-152,106}}, color={0,0,127}));
  connect(mHeaWatPri_flow, timCp1.u)
    annotation (Line(points={{-220,-100},{-190,-100}},
                                                     color={0,0,127}));
  connect(timCp1.y, loaHeaWat.u1) annotation (Line(points={{-166,-100},{-160,-100},
          {-160,-114},{-152,-114}},
                                  color={0,0,127}));
  connect(loaChiWat.y, movAve.u)
    annotation (Line(points={{-128,100},{-122,100}}, color={0,0,127}));
  connect(intToRea.y, loaChiWatChi.u)
    annotation (Line(points={{-140,18},{-140,0},{-132,0}},
                                                   color={0,0,127}));
  connect(loaHeaWat.y, movAve1.u)
    annotation (Line(points={{-128,-120},{-122,-120}},
                                                     color={0,0,127}));
  connect(movAve1.y, scaChi3.u)
    annotation (Line(points={{-98,-120},{-82,-120}},
                                                   color={0,0,127}));
  connect(scaChi3.y, numHea.u)
    annotation (Line(points={{-58,-120},{-52,-120}}, color={0,0,127}));
  connect(rep5.y, cmdChiHea.u)
    annotation (Line(points={{142,-120},{148,-120}},
                                                 color={255,127,0}));
  connect(holChi.y[1], rep.u)
    annotation (Line(points={{102,100},{118,100}},color={255,127,0}));
  connect(holChi.y[1], intToRea.u) annotation (Line(points={{102,100},{110,100},{
          110,60},{-140,60},{-140,42}},       color={255,127,0}));
  connect(u1Coo, booToInt.u) annotation (Line(points={{-220,180},{-190,180},{-190,
          140},{-2,140}},       color={255,0,255}));
  connect(numChi.y, numOpeChi.u2) annotation (Line(points={{-18,100},{32,100},{32,
          94},{38,94}}, color={255,127,0}));
  connect(booToInt.y, numOpeChi.u1) annotation (Line(points={{22,140},{32,140},{
          32,106},{38,106}}, color={255,127,0}));
  connect(holChi.y[1], scaChi1.u) annotation (Line(points={{102,100},{110,100},{
          110,60},{-80,60},{-80,40},{-72,40}},
                                           color={255,127,0}));
  connect(scaChi1.y, booToInt1.u)
    annotation (Line(points={{-48,40},{-42,40}}, color={255,0,255}));
  connect(booToInt1.y, numOpeCoo.u1) annotation (Line(points={{-18,40},{-16,40},
          {-16,6},{-12,6}},   color={255,127,0}));
  connect(numCoo.y, numOpeCoo.u2) annotation (Line(points={{-18,0},{-16,0},{-16,
          -6},{-12,-6}}, color={255,127,0}));
  connect(cmdChi.y, y1Chi)
    annotation (Line(points={{172,100},{220,100}}, color={255,0,255}));
  connect(u1Hea, booToInt2.u) annotation (Line(points={{-220,160},{-194,160},{-194,
          -80},{-82,-80}},      color={255,0,255}));
  connect(numHea.y, numOpeHea.u2) annotation (Line(points={{-28,-120},{-20,-120},
          {-20,-126},{-12,-126}}, color={255,127,0}));
  connect(booToInt2.y, numOpeHea.u1) annotation (Line(points={{-58,-80},{-24,-80},
          {-24,-114},{-12,-114}}, color={255,127,0}));
  connect(numOpeHea.y, nChiHeaAndCooUnb.u2) annotation (Line(points={{12,-120},{
          20,-120},{20,-100},{-20,-100},{-20,-50},{-12,-50}}, color={255,127,0}));
  connect(numOpeCoo.y, nChiHeaAndCooUnb.u1) annotation (Line(points={{12,0},{20,
          0},{20,-20},{-20,-20},{-20,-38},{-12,-38}},
                                                   color={255,127,0}));
  connect(numOpeCoo.y, numChiCasCoo.u1) annotation (Line(points={{12,0},{40,0},
          {40,6},{48,6}},   color={255,127,0}));
  connect(cmdChiHea.y, y1ChiHea)
    annotation (Line(points={{172,-120},{220,-120}}, color={255,0,255}));
  connect(modHeaCoo.y1HeaCoo, y1HeaCooChiHea) annotation (Line(points={{162,-26},
          {180,-26},{180,-50},{220,-50}}, color={255,0,255}));
  connect(numChiHea.y, nChiHeaHeaAndCoo.u2)
    annotation (Line(points={{12,-76},{18,-76}}, color={255,127,0}));
  connect(nChiHeaAndCooUnb.y, nChiHeaHeaAndCoo.u1) annotation (Line(points={{12,
          -44},{16,-44},{16,-64},{18,-64}}, color={255,127,0}));
  connect(nChiHeaAndCooUnb.y, numChiHeaCoo.u1)
    annotation (Line(points={{12,-44},{48,-44}}, color={255,127,0}));
  connect(nChiHeaHeaAndCoo.y, numChiHeaCoo.u2) annotation (Line(points={{42,-70},
          {46,-70},{46,-56},{48,-56}}, color={255,127,0}));
  connect(modHeaCoo.y1Coo, y1CooChiHea) annotation (Line(points={{162,-14},{180,
          -14},{180,20},{220,20}}, color={255,0,255}));
  connect(numChiHeaCoo.y, numChiCasCoo.u2) annotation (Line(points={{72,-50},{
          76,-50},{76,-20},{40,-20},{40,-6},{48,-6}},
                                               color={255,127,0}));
  connect(numChiCasCoo.y, hol.u[1]) annotation (Line(points={{72,0},{76,0},{76,
          -20.6667},{78,-20.6667}},
                              color={255,127,0}));
  connect(numChiHeaCoo.y, hol.u[2]) annotation (Line(points={{72,-50},{76,-50},
          {76,-20},{78,-20}},    color={255,127,0}));
  connect(hol.y[1],modHeaCoo. nCasCoo) annotation (Line(points={{102,-20.6667},
          {126,-20.6667},{126,-20},{130,-20},{130,-14},{138,-14}},
                                                           color={255,127,0}));
  connect(hol.y[2],modHeaCoo. nHeaCoo) annotation (Line(points={{102,-20},{130,
          -20},{130,-26},{138,-26}},   color={255,127,0}));
  connect(numOpeChi.y, holChi.u[1])
    annotation (Line(points={{62,100},{78,100}}, color={255,127,0}));
  connect(nChiHeaHeaAndCoo.y, holOpeChiHea.u[1]) annotation (Line(points={{42,
          -70},{46,-70},{46,-120},{78,-120}}, color={255,127,0}));
  connect(numChiHeaCoo.y, hol.u[3]) annotation (Line(points={{72,-50},{76,-50},
          {76,-20},{78,-20},{78,-19.3333}}, color={255,127,0}));
  connect(holOpeChiHea.y[1], rep5.u)
    annotation (Line(points={{102,-120},{118,-120}}, color={255,127,0}));
  annotation (
  defaultComponentName="staPla",
  Documentation(info="<html>
</html>"),
    Diagram(coordinateSystem(extent={{-200,-200},{200,200}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end StagingPlant;
