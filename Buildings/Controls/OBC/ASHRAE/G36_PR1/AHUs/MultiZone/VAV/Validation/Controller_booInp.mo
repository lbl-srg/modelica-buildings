within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Validation;
model Controller_booInp
  "Validation multizone controller model for boolean inputs"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU(
    numZon=2,
    AFlo={50,50},
    have_winSen=false,
    have_perZonRehBox=true,
    controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
    VPriSysMax_flow=0.7*(50*3/3600)*6*2,
    have_occSen=true,
    controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
                      "Multiple zone AHU controller"
    annotation (Placement(transformation(extent={{-260,48},{-180,152}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOn(
    final k=273.15 + 24)
    "Cooling on setpoint"
    annotation (Placement(transformation(extent={{-380,212},{-360,232}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOn(
    final k=273.15 + 20)
    "Heating on setpoint"
    annotation (Placement(transformation(extent={{-460,212},{-440,232}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut(
    final k=297.15) "Outdoor temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-380,122},{-360,142}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon[2](
    each height=6,
    each offset=273.15 + 17,
    each duration=3600) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-380,162},{-360,182}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis[2](
    each height=4,
    each duration=3600,
    each offset=273.15 + 18) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-460,122},{-440,142}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    height=4,
    duration=3600,
    offset=273.15 + 14) "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-460,82},{-440,102}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
    duration=1800,
    offset=0.02,
    height=0.0168)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-460,-18},{-440,2}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo1(
    height=1.5,
    offset=1,
    duration=3600)
    "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-460,-60},{-440,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo2(
    offset=1,
    height=0.5,
    duration=3600)
    "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-410,-58},{-390,-38}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TMixMea(
    height=4,
    duration=1,
    offset=273.15 + 2,
    startTime=0)
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-360,-58},{-340,-38}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOut(
    amplitude=5,
    offset=18 + 273.15,
    freqHz=1/3600) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-460,162},{-440,182}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine ducStaPre(
    offset=200,
    amplitude=150,
    freqHz=1/3600) "Duct static pressure"
    annotation (Placement(transformation(extent={{-380,-18},{-360,2}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
    offset=3,
    amplitude=2,
    freqHz=1/9600) "Duct static pressure setpoint reset requests"
    annotation (Placement(transformation(extent={{-460,-188},{-440,-168}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine1(
    amplitude=6,
    freqHz=1/9600)
    "Maximum supply temperature setpoint reset"
    annotation (Placement(transformation(extent={{-460,-148},{-440,-128}})));

  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-420,-148},{-400,-128}})));

  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-420,-188},{-400,-168}})));

  Buildings.Controls.OBC.CDL.Continuous.Round round1(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-380,-148},{-360,-128}})));

  Buildings.Controls.OBC.CDL.Continuous.Round round2(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-380,-188},{-360,-168}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger ducPreResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-340,-188},{-320,-168}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger maxSupResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-340,-148},{-320,-128}})));

  CDL.Logical.Sources.Constant winSta[2](final k={true,false})
    "Window status for each zone"
    annotation (Placement(transformation(extent={{-30,72},{-10,92}})));
  CDL.Continuous.Sources.Ramp                        numOfOcc1(height=2,
      duration=3600)
    "Occupant number in zone 1"
    annotation (Placement(transformation(extent={{-400,72},{-380,92}})));
  CDL.Conversions.RealToInteger occConv1 "Convert real to integer"
    annotation (Placement(transformation(extent={{-370,72},{-350,92}})));
  CDL.Continuous.Sources.Ramp                        numOfOcc2(duration=3600,
      height=3)
    "Occupant number in zone 2"
    annotation (Placement(transformation(extent={{-400,32},{-380,52}})));
  CDL.Conversions.RealToInteger occConv2 "Convert real to integer"
    annotation (Placement(transformation(extent={{-370,32},{-350,52}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU1(
    numZon=2,
    AFlo={50,50},
    have_winSen=false,
    have_perZonRehBox=false,
    have_duaDucBox=true,
    controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
    VPriSysMax_flow=0.7*(50*3/3600)*6*2,
    have_occSen=true,
    controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
                      "Multiple zone AHU controller"
    annotation (Placement(transformation(extent={{-120,48},{-40,152}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU2(
    numZon=2,
    AFlo={50,50},
    have_winSen=true,
    have_perZonRehBox=true,
    have_duaDucBox=false,
    controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
    VPriSysMax_flow=0.7*(50*3/3600)*6*2,
    have_occSen=false,
    controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
                      "Multiple zone AHU controller"
    annotation (Placement(transformation(extent={{40,48},{120,152}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU3(
    numZon=2,
    AFlo={50,50},
    have_winSen=false,
    have_perZonRehBox=true,
    use_enthalpy=true,
    controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
    VPriSysMax_flow=0.7*(50*3/3600)*6*2,
    have_occSen=false,
    controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
                      "Multiple zone AHU controller"
    annotation (Placement(transformation(extent={{220,48},{300,152}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU4(
    numZon=2,
    AFlo={50,50},
    have_winSen=false,
    have_perZonRehBox=true,
    use_enthalpy=false,
    controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    use_TMix=false,
    use_G36FrePro=true,
    controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
    VPriSysMax_flow=0.7*(50*3/3600)*6*2,
    have_occSen=false,
    controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
                      "Multiple zone AHU controller"
    annotation (Placement(transformation(extent={{460,48},{540,152}})));
  CDL.Continuous.Sources.Constant                    TOut1(k=258)
    "Low outdoor air temperature to cause freeze protection above stage0"
    annotation (Placement(transformation(extent={{320,140},{340,160}})));
  CDL.Logical.Sources.Pulse                        booPul1(period=10000,
      startTime=500)
    annotation (Placement(transformation(extent={{360,0},{380,20}})));
  CDL.Conversions.BooleanToInteger                        freProSta1(
      integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage2,
      integerFalse=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage1)
    "Freese protection stage changes from stage 0 to stage 1"
    annotation (Placement(transformation(extent={{400,0},{420,20}})));
protected
  CDL.Continuous.Sources.Ramp                        ram(duration=3600, height=6)
              "Ramp signal for generating operation mode"
    annotation (Placement(transformation(extent={{-460,-108},{-440,-88}})));
  CDL.Continuous.Abs                        abs2
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-420,-108},{-400,-88}})));
  CDL.Continuous.Round                        round3(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-380,-108},{-360,-88}})));
  CDL.Conversions.RealToInteger                        reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-340,-108},{-320,-88}})));
  CDL.Continuous.Sources.Constant                        hOutBelowCutoff(final k=
        45000)
    "Outdoor air enthalpy is slightly below the cutoff"
    annotation (Placement(transformation(extent={{140,32},{160,52}})));
  CDL.Continuous.Sources.Constant                        hOutCut(final k=65100)
                        "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{140,-8},{160,12}})));
equation
  connect(TZon.y, conAHU.TZon)
    annotation (Line(points={{-359,172},{-330,172},{-330,141.167},{-262,141.167}},
      color={0,0,127}));
  connect(TOutCut.y, conAHU.TOutCut)
    annotation (Line(points={{-359,132},{-330,132},{-330,123.833},{-262,123.833}},
      color={0,0,127}));
  connect(TSup.y, conAHU.TSup)
    annotation (Line(points={{-439,92},{-420,92},{-420,108.667},{-262,108.667}},
                                    color={0,0,127}));
  connect(VOut_flow.y, conAHU.VOut_flow)
    annotation (Line(points={{-439,-8},{-420,-8},{-420,14},{-314,14},{-314,
          95.6667},{-262,95.6667}},
                      color={0,0,127}));
  connect(ducStaPre.y, conAHU.ducStaPre)
    annotation (Line(points={{-359,-8},{-310,-8},{-310,91.3333},{-262,91.3333}},
      color={0,0,127}));
  connect(vavBoxFlo1.y, conAHU.VDis_flow[1])
    annotation (Line(points={{-439,-50},{-420,-50},{-420,-28},{-320,-28},{-320,
          83.75},{-262,83.75}},    color={0,0,127}));
  connect(vavBoxFlo2.y, conAHU.VDis_flow[2])
    annotation (Line(points={{-389,-48},{-380,-48},{-380,-30},{-324,-30},{-324,
          85.9167},{-262,85.9167}},color={0,0,127}));
  connect(TMixMea.y, conAHU.TMix)
    annotation (Line(points={{-339,-48},{-302,-48},{-302,80.5},{-262,80.5}},
      color={0,0,127}));
  connect(maxSupResReq.y, conAHU.uZonTemResReq)
    annotation (Line(points={{-319,-138},{-280,-138},{-280,61},{-262,61}},
      color={255,127,0}));
  connect(ducPreResReq.y, conAHU.uZonPreResReq)
    annotation (Line(points={{-319,-178},{-272,-178},{-272,54.5},{-262,54.5}},
      color={255,127,0}));
  connect(TOut.y, conAHU.TOut)
    annotation (Line(points={{-439,172},{-420,172},{-420,192},{-324,192},{-324,145.5},
          {-262,145.5}},           color={0,0,127}));
  connect(TDis.y, conAHU.TDis)
    annotation (Line(points={{-439,132},{-420,132},{-420,112},{-320,112},{-320,132.5},
          {-262,132.5}},           color={0,0,127}));
  connect(TSetRooHeaOn.y, conAHU.TZonHeaSet)
    annotation (Line(points={{-439,222},{-420,222},{-420,202},{-300,202},{-300,158.5},
          {-262,158.5}},           color={0,0,127}));

  connect(TSetRooCooOn.y, conAHU.TZonCooSet) annotation (Line(points={{-359,222},
          {-320,222},{-320,154.167},{-262,154.167}}, color={0,0,127}));
  connect(ram.y, abs2.u)
    annotation (Line(points={{-439,-98},{-422,-98}}, color={0,0,127}));
  connect(abs2.y, round3.u)
    annotation (Line(points={{-399,-98},{-382,-98}}, color={0,0,127}));
  connect(round3.y, reaToInt2.u)
    annotation (Line(points={{-359,-98},{-342,-98}}, color={0,0,127}));
  connect(reaToInt2.y, conAHU.uOpeMod) annotation (Line(points={{-319,-98},{
          -288,-98},{-288,71.8333},{-262,71.8333}},
                                               color={255,127,0}));
  connect(sine1.y, abs.u)
    annotation (Line(points={{-439,-138},{-422,-138}},
                                                   color={0,0,127}));
  connect(abs.y, round1.u)
    annotation (Line(points={{-399,-138},{-382,-138}},
                                                   color={0,0,127}));
  connect(round1.y, maxSupResReq.u)
    annotation (Line(points={{-359,-138},{-342,-138}},       color={0,0,127}));
  connect(round2.y, ducPreResReq.u)
    annotation (Line(points={{-359,-178},{-342,-178}},
                                                   color={0,0,127}));
  connect(abs1.y, round2.u)
    annotation (Line(points={{-399,-178},{-382,-178}},
                                                   color={0,0,127}));
  connect(sine.y, abs1.u)
    annotation (Line(points={{-439,-178},{-422,-178}},
                                                   color={0,0,127}));
  connect(numOfOcc2.y, occConv2.u)
    annotation (Line(points={{-379,42},{-372,42}},   color={0,0,127}));
  connect(numOfOcc1.y, occConv1.u)
    annotation (Line(points={{-379,82},{-372,82}},   color={0,0,127}));
  connect(occConv1.y, conAHU.nOcc[1]) annotation (Line(points={{-349,82},{-340,
          82},{-340,98.9167},{-262,98.9167}},  color={255,127,0}));
  connect(occConv2.y, conAHU.nOcc[2]) annotation (Line(points={{-349,42},{-340,
          42},{-340,101.083},{-262,101.083}},  color={255,127,0}));
  connect(TSetRooHeaOn.y, conAHU1.TZonHeaSet) annotation (Line(points={{-439,222},
          {-420,222},{-420,202},{-136,202},{-136,158.5},{-122,158.5}}, color={0,
          0,127}));
  connect(TSetRooCooOn.y, conAHU1.TZonCooSet) annotation (Line(points={{-359,
          222},{-140,222},{-140,154.167},{-122,154.167}},
                                                     color={0,0,127}));
  connect(TOut.y, conAHU1.TOut) annotation (Line(points={{-439,172},{-420,172},{
          -420,192},{-144,192},{-144,145.5},{-122,145.5}}, color={0,0,127}));
  connect(TZon.y, conAHU1.TZon) annotation (Line(points={{-359,172},{-148,172},
          {-148,141.167},{-122,141.167}},color={0,0,127}));
  connect(TDis.y, conAHU1.TDis) annotation (Line(points={{-439,132},{-412,132},{
          -412,190},{-150,190},{-150,132.5},{-122,132.5}}, color={0,0,127}));
  connect(TOutCut.y, conAHU1.TOutCut) annotation (Line(points={{-359,132},{-340,
          132},{-340,186},{-152,186},{-152,123.833},{-122,123.833}}, color={0,0,
          127}));
  connect(TSup.y, conAHU1.TSup) annotation (Line(points={{-439,92},{-408,92},{
          -408,196},{-154,196},{-154,108.667},{-122,108.667}},
                                                          color={0,0,127}));
  connect(occConv1.y, conAHU1.nOcc[1]) annotation (Line(points={{-349,82},{-332,
          82},{-332,22},{-140,22},{-140,98.9167},{-122,98.9167}}, color={255,127,
          0}));
  connect(conAHU1.nOcc[2], occConv2.y) annotation (Line(points={{-122,101.083},
          {-140,101.083},{-140,22},{-332,22},{-332,42},{-349,42}},color={255,127,
          0}));
  connect(VOut_flow.y, conAHU1.VOut_flow) annotation (Line(points={{-439,-8},{
          -420,-8},{-420,16},{-138,16},{-138,95.6667},{-122,95.6667}},
                                                                  color={0,0,127}));
  connect(ducStaPre.y, conAHU1.ducStaPre) annotation (Line(points={{-359,-8},{
          -134,-8},{-134,91.3333},{-122,91.3333}},
                                              color={0,0,127}));
  connect(vavBoxFlo1.y, conAHU1.VDis_flow[1]) annotation (Line(points={{-439,
          -50},{-420,-50},{-420,-28},{-132,-28},{-132,83.75},{-122,83.75}},
                                                                       color={0,
          0,127}));
  connect(vavBoxFlo2.y, conAHU1.VDis_flow[2]) annotation (Line(points={{-389,
          -48},{-380,-48},{-380,-30},{-132,-30},{-132,85.9167},{-122,85.9167}},
        color={0,0,127}));
  connect(TMixMea.y, conAHU1.TMix) annotation (Line(points={{-339,-48},{-130,-48},
          {-130,80.5},{-122,80.5}}, color={0,0,127}));
  connect(ducPreResReq.y, conAHU1.uZonPreResReq) annotation (Line(points={{-319,
          -178},{-126,-178},{-126,54},{-122,54},{-122,54.5}}, color={255,127,0}));
  connect(maxSupResReq.y, conAHU1.uZonTemResReq) annotation (Line(points={{-319,
          -138},{-128,-138},{-128,61},{-122,61}}, color={255,127,0}));
  connect(reaToInt2.y, conAHU1.uOpeMod) annotation (Line(points={{-319,-98},{
          -130,-98},{-130,71.8333},{-122,71.8333}},
                                               color={255,127,0}));
  connect(TSetRooHeaOn.y, conAHU2.TZonHeaSet) annotation (Line(points={{-439,222},
          {-420,222},{-420,242},{-2,242},{-2,158.5},{38,158.5}}, color={0,0,127}));
  connect(TSetRooCooOn.y, conAHU2.TZonCooSet) annotation (Line(points={{-359,
          222},{-6,222},{-6,154.167},{38,154.167}},
                                               color={0,0,127}));
  connect(TOut.y, conAHU2.TOut) annotation (Line(points={{-439,172},{-420,172},{
          -420,192},{-10,192},{-10,145.5},{38,145.5}}, color={0,0,127}));
  connect(TZon.y, conAHU2.TZon) annotation (Line(points={{-359,172},{-186,172},
          {-186,178},{-14,178},{-14,141.167},{38,141.167}},color={0,0,127}));
  connect(TDis.y, conAHU2.TDis) annotation (Line(points={{-439,132},{-412,132},{
          -412,190},{-16,190},{-16,132.5},{38,132.5}}, color={0,0,127}));
  connect(TOutCut.y, conAHU2.TOutCut) annotation (Line(points={{-359,132},{-340,
          132},{-340,186},{-18,186},{-18,123.833},{38,123.833}}, color={0,0,127}));
  connect(TSup.y, conAHU2.TSup) annotation (Line(points={{-439,92},{-408,92},{
          -408,194},{-20,194},{-20,108.667},{38,108.667}},
                                                      color={0,0,127}));
  connect(winSta.y, conAHU2.uWin) annotation (Line(points={{-9,82},{0,82},{0,
          104.333},{38,104.333}},
                         color={255,0,255}));
  connect(VOut_flow.y, conAHU2.VOut_flow) annotation (Line(points={{-439,-8},{
          -420,-8},{-420,18},{8,18},{8,95.6667},{38,95.6667}},
                                                          color={0,0,127}));
  connect(ducStaPre.y, conAHU2.ducStaPre) annotation (Line(points={{-359,-8},{
          10,-8},{10,91.3333},{38,91.3333}},
                                          color={0,0,127}));
  connect(TMixMea.y, conAHU2.TMix) annotation (Line(points={{-339,-48},{14,-48},
          {14,80.5},{38,80.5}}, color={0,0,127}));
  connect(VOut_flow.y, conAHU2.VDis_flow[1]) annotation (Line(points={{-439,-8},
          {-420,-8},{-420,16},{4,16},{4,83.75},{38,83.75}}, color={0,0,127}));
  connect(vavBoxFlo1.y, conAHU2.VDis_flow[2]) annotation (Line(points={{-439,
          -50},{-432,-50},{-432,-46},{-420,-46},{-420,-26},{2,-26},{2,85.9167},
          {38,85.9167}},
        color={0,0,127}));
  connect(reaToInt2.y, conAHU2.uOpeMod) annotation (Line(points={{-319,-98},{20,
          -98},{20,71.8333},{38,71.8333}}, color={255,127,0}));
  connect(maxSupResReq.y, conAHU2.uZonTemResReq) annotation (Line(points={{-319,
          -138},{26,-138},{26,61},{38,61}}, color={255,127,0}));
  connect(ducPreResReq.y, conAHU2.uZonPreResReq) annotation (Line(points={{-319,
          -178},{32,-178},{32,54.5},{38,54.5}}, color={255,127,0}));
  connect(hOutBelowCutoff.y, conAHU3.hOut) annotation (Line(points={{161,42},{190,
          42},{190,119.5},{218,119.5}}, color={0,0,127}));
  connect(hOutCut.y, conAHU3.hOutCut) annotation (Line(points={{161,2},{192,2},
          {192,115.167},{218,115.167}},color={0,0,127}));
  connect(reaToInt2.y, conAHU3.uOpeMod) annotation (Line(points={{-319,-98},{
          200,-98},{200,71.8333},{218,71.8333}},
                                             color={255,127,0}));
  connect(maxSupResReq.y, conAHU3.uZonTemResReq) annotation (Line(points={{-319,
          -138},{204,-138},{204,61},{218,61}}, color={255,127,0}));
  connect(ducPreResReq.y, conAHU3.uZonPreResReq) annotation (Line(points={{-319,
          -178},{210,-178},{210,54.5},{218,54.5}}, color={255,127,0}));
  connect(TSetRooHeaOn.y, conAHU3.TZonHeaSet) annotation (Line(points={{-439,222},
          {-430,222},{-430,224},{-420,224},{-420,242},{200,242},{200,158.5},{218,
          158.5}}, color={0,0,127}));
  connect(TSetRooCooOn.y, conAHU3.TZonCooSet) annotation (Line(points={{-359,
          222},{196,222},{196,154.167},{218,154.167}},
                                                  color={0,0,127}));
  connect(TOut.y, conAHU3.TOut) annotation (Line(points={{-439,172},{-420,172},{
          -420,192},{192,192},{192,145.5},{218,145.5}}, color={0,0,127}));
  connect(TZon.y, conAHU3.TZon) annotation (Line(points={{-359,172},{-344,172},
          {-344,184},{190,184},{190,141.167},{218,141.167}},color={0,0,127}));
  connect(TDis.y, conAHU3.TDis) annotation (Line(points={{-439,132},{-412,132},{
          -412,190},{190,190},{190,132.5},{218,132.5}}, color={0,0,127}));
  connect(TOutCut.y, conAHU3.TOutCut) annotation (Line(points={{-359,132},{-348,
          132},{-348,138},{-340,138},{-340,186},{188,186},{188,123.833},{218,
          123.833}},
        color={0,0,127}));
  connect(TSup.y, conAHU3.TSup) annotation (Line(points={{-439,92},{-406,92},{
          -406,198},{184,198},{184,108.667},{218,108.667}},
                                                       color={0,0,127}));
  connect(VOut_flow.y, conAHU3.VOut_flow) annotation (Line(points={{-439,-8},{
          -420,-8},{-420,24},{196,24},{196,95.6667},{218,95.6667}},
                                                               color={0,0,127}));
  connect(ducStaPre.y, conAHU3.ducStaPre) annotation (Line(points={{-359,-8},{
          130,-8},{130,91.3333},{218,91.3333}},
                                            color={0,0,127}));
  connect(vavBoxFlo1.y, conAHU3.VDis_flow[1]) annotation (Line(points={{-439,
          -50},{-422,-50},{-422,-26},{198,-26},{198,83.75},{218,83.75}},
                                                                    color={0,0,127}));
  connect(vavBoxFlo2.y, conAHU3.VDis_flow[2]) annotation (Line(points={{-389,
          -48},{-384,-48},{-384,-46},{-378,-46},{-378,-22},{200,-22},{200,
          85.9167},{218,85.9167}},
                     color={0,0,127}));
  connect(TMixMea.y, conAHU3.TMix) annotation (Line(points={{-339,-48},{204,-48},
          {204,80.5},{218,80.5}}, color={0,0,127}));
  connect(TSetRooHeaOn.y, conAHU4.TZonHeaSet) annotation (Line(points={{-439,
          222},{-430,222},{-430,224},{-420,224},{-420,242},{358,242},{358,158.5},
          {458,158.5}},
                   color={0,0,127}));
  connect(TSetRooCooOn.y, conAHU4.TZonCooSet) annotation (Line(points={{-359,
          222},{356,222},{356,154.167},{458,154.167}},
                                                  color={0,0,127}));
  connect(TOut1.y, conAHU4.TOut) annotation (Line(points={{341,150},{356,150},{
          356,145.5},{458,145.5}}, color={0,0,127}));
  connect(ducPreResReq.y, conAHU4.uZonPreResReq) annotation (Line(points={{-319,
          -178},{330,-178},{330,54.5},{458,54.5}}, color={255,127,0}));
  connect(maxSupResReq.y, conAHU4.uZonTemResReq) annotation (Line(points={{-319,
          -138},{2,-138},{2,-136},{324,-136},{324,61},{458,61}}, color={255,127,
          0}));
  connect(reaToInt2.y, conAHU4.uOpeMod) annotation (Line(points={{-319,-98},{
          318,-98},{318,71.8333},{458,71.8333}}, color={255,127,0}));
  connect(conAHU4.TZon, TZon.y) annotation (Line(points={{458,141.167},{350,
          141.167},{350,212},{-350,212},{-350,172},{-359,172}}, color={0,0,127}));
  connect(conAHU4.TDis, TDis.y) annotation (Line(points={{458,132.5},{346,132.5},
          {346,206},{-416,206},{-416,132},{-439,132}}, color={0,0,127}));
  connect(conAHU4.TOutCut, TOutCut.y) annotation (Line(points={{458,123.833},{
          348,123.833},{348,204},{-344,204},{-344,132},{-359,132}}, color={0,0,
          127}));
  connect(conAHU4.TSup, TOutCut.y) annotation (Line(points={{458,108.667},{362,
          108.667},{362,108},{352,108},{352,196},{-324,196},{-324,132},{-359,
          132}}, color={0,0,127}));
  connect(vavBoxFlo1.y, conAHU4.VDis_flow[1]) annotation (Line(points={{-439,
          -50},{-428,-50},{-428,-46},{-418,-46},{-418,-22},{314,-22},{314,83.75},
          {458,83.75}}, color={0,0,127}));
  connect(vavBoxFlo2.y, conAHU4.VDis_flow[2]) annotation (Line(points={{-389,
          -48},{-374,-48},{-374,-26},{318,-26},{318,85.9167},{458,85.9167}},
        color={0,0,127}));
  connect(VOut_flow.y, conAHU4.VOut_flow) annotation (Line(points={{-439,-8},{
          -424,-8},{-424,24},{310,24},{310,95.6667},{458,95.6667}}, color={0,0,
          127}));
  connect(ducStaPre.y, conAHU4.ducStaPre) annotation (Line(points={{-359,-8},{
          -116,-8},{-116,-10},{130,-10},{130,-34},{314,-34},{314,91.3333},{458,
          91.3333}}, color={0,0,127}));
  connect(booPul1.y, freProSta1.u)
    annotation (Line(points={{381,10},{398,10}}, color={255,0,255}));
  connect(freProSta1.y, conAHU4.uFreProSta) annotation (Line(points={{421,10},{
          440,10},{440,45.8333},{458,45.8333}}, color={255,127,0}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/VAV/Validation/Controller_booInp.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2019, by Michael Wetter:<br/>
Removed wrong use of <code>each</code>.
</li>
<li>
October 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(extent={{-520,-220},{540,300}})),
    Icon(coordinateSystem(extent={{-520,-220},{540,300}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end Controller_booInp;
