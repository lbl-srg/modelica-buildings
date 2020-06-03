within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.Subsystems;
package Validation "Collection of validation models"
  extends Modelica.Icons.ExamplesPackage;
  model Chiller
    "Validation of the base subsystem model with heat recovery chiller"
    extends Modelica.Icons.Example;

    package Medium = Buildings.Media.Water "Medium model";
    parameter Fluid.Chillers.Data.ElectricEIR.Generic datChi(
      QEva_flow_nominal=-1E6,
      COP_nominal=3,
      PLRMax=1,
      PLRMinUnl=0.3,
      PLRMin=0.3,
      etaMotor=1,
      mEva_flow_nominal=30,
      mCon_flow_nominal=30,
      TEvaLvg_nominal=280.15,
      capFunT={1,0,0,0,0,0},
      EIRFunT={1,0,0,0,0,0},
      EIRFunPLR={1,0,0},
      TEvaLvgMin=276.15,
      TEvaLvgMax=288.15,
      TConEnt_nominal=313.15,
      TConEntMin=303.15,
      TConEntMax=333.15) "Chiller performance data"
      annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
    Subsystems.Chiller chi(
      redeclare final package Medium = Medium,
      final dat=datChi,
      dpCon_nominal=15E3,
      dpEva_nominal=15E3) "Subsystem with heat recovery chiller"
      annotation (Placement(transformation(extent={{-10,-72},{10,-52}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(
      k=45 + 273.15,
      y(final unit="K", displayUnit="degC"))
      "Heating water supply temperature set-point"
      annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
    Fluid.Sources.Boundary_pT evaWat(
      redeclare package Medium = Medium,
      use_T_in=true,
      nPorts=2) "Evaporator water boundary conditions" annotation (Placement(
          transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={110,-62})));
    Fluid.Sources.Boundary_pT conWat(
      redeclare package Medium = Medium,
      use_T_in=true,
      nPorts=2) "Condenser water boundary conditions" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,-62})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(
      k=7 + 273.15,
      y(final unit="K", displayUnit="degC"))
      "Chilled water supply temperature set-point"
      annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TChiWatRet(
      offset=9 + 273.15,
      y(final unit="K", displayUnit="degC"),
      height=5,
      duration=1000,
      startTime=1000) "Chilled water return temperature"
      annotation (Placement(transformation(extent={{190,-90},{170,-70}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp THeaWatRet(
      offset=44 + 273.15,
      y(final unit="K", displayUnit="degC"),
      height=-10,
      duration=1000,
      startTime=2000) "Heating water return temperature"
      annotation (Placement(transformation(extent={{-190,-90},{-170,-70}})));
    Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(redeclare final package
        Medium =
          Medium, m_flow_nominal=datChi.mCon_flow_nominal)
      "Heating water supply temperature" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={-80,-40})));
    Fluid.Sensors.TemperatureTwoPort senTChiWatSup(redeclare final package
        Medium =
          Medium, m_flow_nominal=datChi.mEva_flow_nominal)
      "Chilled water supply temperature" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={70,-40})));
    Fluid.Sensors.TemperatureTwoPort senTHeaWatRet(redeclare final package
        Medium =
          Medium, m_flow_nominal=datChi.mCon_flow_nominal)
      "Heating water return temperature" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-80,-80})));
    Fluid.Sensors.TemperatureTwoPort senTChiWatRet(redeclare final package
        Medium =
          Medium, m_flow_nominal=datChi.mEva_flow_nominal)
      "Chilled water return temperature" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={70,-80})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dTChiWatRet(
      offset=0,
      y(final unit="K", displayUnit="degC"),
      height=-3,
      duration=1000,
      startTime=3000) "Chilled water return additional deltaT"
      annotation (Placement(transformation(extent={{190,-50},{170,-30}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=2)
      "Sum T and deltaT"
      annotation (Placement(transformation(extent={{150,-70},{130,-50}})));
    Modelica.Blocks.Sources.BooleanExpression uHea(y=time < 4000)
      "Heating enabled signal"
      annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=2)
      "Sum T and deltaT"
      annotation (Placement(transformation(extent={{-152,-70},{-132,-50}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dTHeaWatRet(
      y(final unit="K", displayUnit="degC"),
      height=-20,
      duration=500,
      startTime=4500) "Heating water return additional deltaT"
      annotation (Placement(transformation(extent={{-190,-50},{-170,-30}})));
    Modelica.Blocks.Sources.BooleanExpression uCoo(y=time >= 1000)
      "Cooling enabled signal"
      annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  equation
    connect(TChiWatSupSet.y, chi.TChiWatSupPreSet) annotation (Line(points={{-98,
            0},{-32,0},{-32,-65},{-12,-65}}, color={0,0,127}));
    connect(THeaWatSupSet.y, chi.THeaWatSupSet) annotation (Line(points={{-98,40},
            {-28,40},{-28,-63},{-12,-63}}, color={0,0,127}));
    connect(chi.port_bHeaWat, senTHeaWatSup.port_a) annotation (Line(points={{-10,-56},
            {-40,-56},{-40,-40},{-70,-40}},      color={0,127,255}));
    connect(senTHeaWatSup.port_b, conWat.ports[1]) annotation (Line(points={{-90,-40},
            {-100,-40},{-100,-60}},      color={0,127,255}));
    connect(evaWat.ports[1], senTChiWatSup.port_b) annotation (Line(points={{100,
            -60},{100,-40},{80,-40}}, color={0,127,255}));
    connect(senTChiWatSup.port_a, chi.port_bChiWat) annotation (Line(points={{60,-40},
            {40,-40},{40,-56},{10,-56}},     color={0,127,255}));
    connect(conWat.ports[2], senTHeaWatRet.port_a) annotation (Line(points={{-100,
            -64},{-100,-80},{-90,-80}}, color={0,127,255}));
    connect(senTHeaWatRet.port_b, chi.port_aHeaWat) annotation (Line(points={{-70,-80},
            {-40,-80},{-40,-68},{-10,-68}},      color={0,127,255}));
    connect(chi.port_aChiWat, senTChiWatRet.port_b) annotation (Line(points={{10,-68},
            {40,-68},{40,-80},{60,-80}},      color={0,127,255}));
    connect(senTChiWatRet.port_a, evaWat.ports[2]) annotation (Line(points={{80,
            -80},{100,-80},{100,-64}}, color={0,127,255}));
    connect(mulSum.y, evaWat.T_in) annotation (Line(points={{128,-60},{126,-60},{
            126,-58},{122,-58}}, color={0,0,127}));
    connect(dTChiWatRet.y, mulSum.u[1]) annotation (Line(points={{168,-40},{160,
            -40},{160,-60},{156,-60},{156,-59},{152,-59}},
                                       color={0,0,127}));
    connect(TChiWatRet.y, mulSum.u[2]) annotation (Line(points={{168,-80},{160,
            -80},{160,-61},{152,-61}}, color={0,0,127}));
    connect(THeaWatRet.y, mulSum1.u[1]) annotation (Line(points={{-168,-80},{-160,
            -80},{-160,-59},{-154,-59}},
                              color={0,0,127}));
    connect(mulSum1.y, conWat.T_in) annotation (Line(points={{-130,-60},{-128,-60},
            {-128,-58},{-122,-58}}, color={0,0,127}));
    connect(dTHeaWatRet.y, mulSum1.u[2]) annotation (Line(points={{-168,-40},{
            -160,-40},{-160,-61},{-154,-61}}, color={0,0,127}));
    connect(uCoo.y, chi.uCoo) annotation (Line(points={{-99,80},{-24,80},{-24,-61},
            {-12,-61}}, color={255,0,255}));
    connect(uHea.y, chi.uHea) annotation (Line(points={{-99,100},{-20,100},{-20,-59},
            {-12,-59}},      color={255,0,255}));
    annotation (
    Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-200,-140},{200,140}})),
    __Dymola_Commands(file=
      "Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/FifthGeneration/BaseClasses/Validation/Chiller.mos"
      "Simulate and plot"));
  end Chiller;

  model HeatExchanger
    "Validation of the base subsystem model with district heat exchanger"
    extends Modelica.Icons.Example;

    package Medium = Buildings.Media.Water "Medium model";
    Fluid.Sources.Boundary_pT bou1(
      redeclare package Medium = Medium,
      use_T_in=true,
      nPorts=2) "Primary boundary conditions" annotation (Placement(
          transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={110,-62})));
    Fluid.Sources.Boundary_pT bou2(
      redeclare package Medium = Medium,
      use_T_in=true,
      nPorts=2) "Secondary boundary conditions" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,-62})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp T1(
      offset=8 + 273.15,
      y(final unit="K", displayUnit="degC"),
      height=5,
      duration=1000,
      startTime=1000) "Primary temperature"
      annotation (Placement(transformation(extent={{210,-90},{190,-70}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp T2Col(
      offset=6 + 273.15,
      y(final unit="K", displayUnit="degC"),
      height=10,
      duration=1000,
      startTime=2000) "Secondary temperature"
      annotation (Placement(transformation(extent={{-230,-12},{-210,8}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dT1(
      offset=0,
      y(final unit="K", displayUnit="degC"),
      height=10,
      duration=1000,
      startTime=3000) "Primary additional deltaT"
      annotation (Placement(transformation(extent={{210,-50},{190,-30}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=2)
      "Sum T and deltaT"
      annotation (Placement(transformation(extent={{170,-70},{150,-50}})));
    Modelica.Blocks.Sources.BooleanExpression uHeaRej(y=time >= 3000)
      "Full heat rejection enabled signal"
      annotation (Placement(transformation(extent={{-230,110},{-210,130}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=2)
      "Sum T and deltaT"
      annotation (Placement(transformation(extent={{-192,8},{-172,28}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dT2Col(
      y(final unit="K", displayUnit="degC"),
      height=-10,
      duration=500,
      startTime=4500) "Secondary additional deltaT"
      annotation (Placement(transformation(extent={{-230,28},{-210,48}})));
    Modelica.Blocks.Sources.BooleanExpression uColRej(y=time >= 1000 and time <
          2000)
      "Full cold rejection enabled signal"
      annotation (Placement(transformation(extent={{-230,90},{-210,110}})));
    Subsystems.HeatExchanger hexPum(
      redeclare final package Medium1 = Medium,
      redeclare final package Medium2 = Medium,
      show_T=true,
      have_val1Hex=false,
      dp1Hex_nominal=20E3,
      dp2Hex_nominal=20E3,
      QHex_flow_nominal=1E6,
      T_a1Hex_nominal=281.15,
      T_b1Hex_nominal=277.15,
      T_a2Hex_nominal=275.15,
      T_b2Hex_nominal=279.15) "Heat exchanger with primary pump"
      annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
    Buildings.Controls.OBC.CDL.Logical.Switch swi
      annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp T2Hea(
      offset=45 + 273.15,
      y(final unit="K", displayUnit="degC"),
      height=10,
      duration=1000,
      startTime=2000) "Secondary temperature"
      annotation (Placement(transformation(extent={{-230,-130},{-210,-110}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(nin=2)
      "Sum T and deltaT"
      annotation (Placement(transformation(extent={{-192,-110},{-172,-90}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dT2Hea(
      y(final unit="K", displayUnit="degC"),
      height=-30,
      duration=500,
      startTime=4500) "Secondary additional deltaT"
      annotation (Placement(transformation(extent={{-230,-90},{-210,-70}})));
    Fluid.Sensors.TemperatureTwoPort senT1OutPum(
      redeclare final package Medium = Medium,
      m_flow_nominal=hexPum.m1_flow_nominal) "Primary outlet temperature"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={70,-80})));
    Fluid.Sensors.TemperatureTwoPort senT1InlPum(redeclare final package Medium
        = Medium, m_flow_nominal=hexPum.m1_flow_nominal)
      "Primary inlet temperature" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={70,-40})));
    Fluid.Sensors.TemperatureTwoPort senT2OutPum(redeclare final package Medium
        = Medium, m_flow_nominal=hexPum.m1_flow_nominal)
      "Secondary outlet temperature" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={-70,-40})));
    Fluid.Sensors.TemperatureTwoPort senT2InlPum(redeclare final package Medium
        = Medium, m_flow_nominal=hexPum.m1_flow_nominal)
      "Secondary inlet temperature" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-70,-80})));
    Fluid.Sources.Boundary_pT bou2Val(
      redeclare package Medium = Medium,
      use_T_in=true,
      nPorts=2) "Secondary boundary conditions" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,20})));
    Subsystems.HeatExchanger hexVal(
      redeclare final package Medium1 = Medium,
      redeclare final package Medium2 = Medium,
      show_T=true,
      have_val1Hex=true,
      dp1Hex_nominal=20E3,
      dp2Hex_nominal=20E3,
      QHex_flow_nominal=1E6,
      T_a1Hex_nominal=281.15,
      T_b1Hex_nominal=277.15,
      T_a2Hex_nominal=275.15,
      T_b2Hex_nominal=279.15) "Heat exchanger with primary control valve"
      annotation (Placement(transformation(extent={{-10,10},{10,30}})));
    Fluid.Sources.Boundary_pT bou1Val(
      redeclare package Medium = Medium,
      p=Medium.p_default + 10E3,
      use_T_in=true,
      nPorts=1) "Primary boundary conditions" annotation (Placement(
          transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={112,40})));
    Fluid.Sources.Boundary_pT bou1Val1(redeclare package Medium = Medium, nPorts=1)
      "Primary boundary conditions" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={110,0})));
    Fluid.Sensors.TemperatureTwoPort senT1InlVal(redeclare final package Medium
        = Medium, m_flow_nominal=hexVal.m1_flow_nominal)
      "Primary inlet temperature" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={70,40})));
    Fluid.Sensors.TemperatureTwoPort senT1OutVal(redeclare final package Medium
        = Medium, m_flow_nominal=hexVal.m1_flow_nominal)
      "Primary outlet temperature" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={70,0})));
    Fluid.Sensors.TemperatureTwoPort senT2OutVal(redeclare final package Medium
        = Medium, m_flow_nominal=hexVal.m1_flow_nominal)
      "Secondary outlet temperature" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={-70,40})));
    Fluid.Sensors.TemperatureTwoPort senT2InlVal(redeclare final package Medium
        = Medium, m_flow_nominal=hexVal.m1_flow_nominal)
      "Secondary inlet temperature" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-70,0})));
    Fluid.Sensors.RelativePressure senRelPre(redeclare final package Medium =
          Medium) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={50,20})));
    Buildings.Controls.OBC.CDL.Logical.Or or2
      annotation (Placement(transformation(extent={{-170,90},{-150,110}})));
    Modelica.Blocks.Sources.RealExpression yValIsoCon(y=if time >= 2500 then 1
           else 0) "Condenser loop isolation valve opening"
      annotation (Placement(transformation(extent={{-230,70},{-210,90}})));
    Modelica.Blocks.Sources.RealExpression yValIsoEva(y=if time >= 500 then 1
           else 0) "Evaporator loop isolation valve opening"
      annotation (Placement(transformation(extent={{-230,50},{-210,70}})));
  equation
    connect(mulSum.y, bou1.T_in) annotation (Line(points={{148,-60},{132,-60},{132,
            -58},{122,-58}}, color={0,0,127}));
    connect(dT1.y, mulSum.u[1]) annotation (Line(points={{188,-40},{180,-40},{180,
            -60},{176,-60},{176,-59},{172,-59}}, color={0,0,127}));
    connect(T1.y, mulSum.u[2]) annotation (Line(points={{188,-80},{180,-80},{180,-61},
            {172,-61}}, color={0,0,127}));
    connect(T2Col.y, mulSum1.u[1]) annotation (Line(points={{-208,-2},{-200,-2},{
            -200,19},{-194,19}}, color={0,0,127}));
    connect(dT2Col.y, mulSum1.u[2]) annotation (Line(points={{-208,38},{-200,38},
            {-200,17},{-194,17}}, color={0,0,127}));
    connect(swi.y, bou2.T_in) annotation (Line(points={{-138,-60},{-130,-60},{
            -130,-58},{-122,-58}}, color={0,0,127}));
    connect(uColRej.y, swi.u2) annotation (Line(points={{-209,100},{-180,100},{
            -180,60},{-160,60},{-160,-40},{-170,-40},{-170,-60},{-162,-60}},
                                                    color={255,0,255}));
    connect(mulSum1.y, swi.u1) annotation (Line(points={{-170,18},{-166,18},{-166,
            -52},{-162,-52}}, color={0,0,127}));
    connect(T2Hea.y, mulSum2.u[1]) annotation (Line(points={{-208,-120},{-200,
            -120},{-200,-99},{-194,-99}}, color={0,0,127}));
    connect(dT2Hea.y, mulSum2.u[2]) annotation (Line(points={{-208,-80},{-200,-80},
            {-200,-101},{-194,-101}}, color={0,0,127}));
    connect(mulSum2.y, swi.u3) annotation (Line(points={{-170,-100},{-166,-100},{
            -166,-68},{-162,-68}}, color={0,0,127}));
    connect(hexPum.port_b1, senT1OutPum.port_a) annotation (Line(points={{10,-54},
            {40,-54},{40,-80},{60,-80}}, color={0,127,255}));
    connect(senT1OutPum.port_b, bou1.ports[1]) annotation (Line(points={{80,-80},{
            100,-80},{100,-60}}, color={0,127,255}));
    connect(hexPum.port_a1, senT1InlPum.port_b) annotation (Line(points={{-10,-54},
            {-20,-54},{-20,-40},{60,-40}}, color={0,127,255}));
    connect(senT1InlPum.port_a, bou1.ports[2]) annotation (Line(points={{80,-40},{
            100,-40},{100,-64}}, color={0,127,255}));
    connect(hexPum.port_b2, senT2OutPum.port_a) annotation (Line(points={{-10,-66},
            {-40,-66},{-40,-40},{-60,-40}}, color={0,127,255}));
    connect(senT2OutPum.port_b, bou2.ports[1]) annotation (Line(points={{-80,-40},
            {-100,-40},{-100,-60}}, color={0,127,255}));
    connect(bou2.ports[2], senT2InlPum.port_a) annotation (Line(points={{-100,-64},
            {-100,-80},{-80,-80}}, color={0,127,255}));
    connect(senT2InlPum.port_b, hexPum.port_a2) annotation (Line(points={{-60,-80},
            {20,-80},{20,-66},{10,-66}}, color={0,127,255}));
    connect(swi.y, bou2Val.T_in) annotation (Line(points={{-138,-60},{-130,-60},{-130,
            24},{-122,24}}, color={0,0,127}));
    connect(mulSum.y, bou1Val.T_in) annotation (Line(points={{148,-60},{140,-60},{
            140,44},{124,44}}, color={0,0,127}));
    connect(hexVal.port_a1, senT1InlVal.port_b) annotation (Line(points={{-10,26},
            {-20,26},{-20,40},{60,40}}, color={0,127,255}));
    connect(senT1InlVal.port_a, bou1Val.ports[1])
      annotation (Line(points={{80,40},{102,40}}, color={0,127,255}));
    connect(bou1Val1.ports[1], senT1OutVal.port_b)
      annotation (Line(points={{100,0},{80,0}}, color={0,127,255}));
    connect(senT1OutVal.port_a, hexVal.port_b1) annotation (Line(points={{60,0},{30,
            0},{30,26},{10,26}}, color={0,127,255}));
    connect(hexVal.port_a2, senT2InlVal.port_b) annotation (Line(points={{10,14},{
            20,14},{20,0},{-60,0}}, color={0,127,255}));
    connect(senT2InlVal.port_a, bou2Val.ports[1])
      annotation (Line(points={{-80,0},{-100,0},{-100,22}}, color={0,127,255}));
    connect(bou2Val.ports[2], senT2OutVal.port_b) annotation (Line(points={{-100,18},
            {-100,40},{-80,40}}, color={0,127,255}));
    connect(senT2OutVal.port_a, hexVal.port_b2) annotation (Line(points={{-60,40},
            {-40,40},{-40,14},{-10,14}}, color={0,127,255}));
    connect(hexVal.port_a1, senRelPre.port_a) annotation (Line(points={{-10,26},{-20,
            26},{-20,40},{50,40},{50,30}}, color={0,127,255}));
    connect(senRelPre.port_b, senT1OutVal.port_a)
      annotation (Line(points={{50,10},{50,0},{60,0}}, color={0,127,255}));
    connect(uColRej.y, or2.u2) annotation (Line(points={{-209,100},{-180,100},{
            -180,92},{-172,92}},
                           color={255,0,255}));
    connect(uHeaRej.y, or2.u1) annotation (Line(points={{-209,120},{-176,120},{
            -176,100},{-172,100}},
                             color={255,0,255}));
    connect(or2.y, hexVal.uEnaHex) annotation (Line(points={{-148,100},{-24,100},
            {-24,29},{-12,29}},color={255,0,255}));
    connect(or2.y, hexPum.uEnaHex) annotation (Line(points={{-148,100},{-24.0625,
            100},{-24.0625,23},{-24,23},{-24,-51},{-12,-51}}, color={255,0,255}));
    connect(yValIsoCon.y, hexVal.yValIso[1]) annotation (Line(points={{-209,80},{
            -32,80},{-32,22},{-12,22}}, color={0,0,127}));
    connect(yValIsoCon.y, hexPum.yValIso[1]) annotation (Line(points={{-209,80},{
            -32,80},{-32,-58},{-12,-58}}, color={0,0,127}));
    connect(yValIsoEva.y, hexVal.yValIso[2]) annotation (Line(points={{-209,60},{
            -36,60},{-36,24},{-12,24}}, color={0,0,127}));
    connect(yValIsoEva.y, hexPum.yValIso[2]) annotation (Line(points={{-209,60},{
            -36,60},{-36,-56},{-12,-56}}, color={0,0,127}));
    annotation (
    Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-240,-140},{240,140}})),
    __Dymola_Commands(file=
            "Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/FifthGeneration/BaseClasses/Validation/HeatExchanger.mos"
          "Simulate and plot"));
  end HeatExchanger;
end Validation;
