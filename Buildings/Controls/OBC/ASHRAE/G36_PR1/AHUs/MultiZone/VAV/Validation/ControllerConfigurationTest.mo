within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Validation;
model ControllerConfigurationTest
  "Validates multizone controller model for boolean parameter values"

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
    annotation (Placement(transformation(extent={{222,48},{302,152}})));

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
    annotation (Placement(transformation(extent={{462,48},{542,152}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOn(
    final k=273.15 + 24)
    "Cooling on setpoint"
    annotation (Placement(transformation(extent={{-420,280},{-400,300}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOn(
    final k=273.15 + 20)
    "Heating on setpoint"
    annotation (Placement(transformation(extent={{-460,300},{-440,320}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut(
    final k=297.15) "Outdoor temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-420,190},{-400,210}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon[2](
    each final height=6,
    each final offset=273.15 + 17,
    each final duration=3600) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-458,250},{-438,270}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis[2](
    each final height=4,
    each final duration=3600,
    each final offset=273.15 + 18) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-460,160},{-440,180}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    final height=4,
    final duration=3600,
    final offset=273.15 + 14) "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-460,210},{-440,230}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
    final duration=1800,
    final offset=0.02,
    final height=0.0168) "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-460,-18},{-440,2}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo1(
    final height=1.5,
    final offset=1,
    final duration=3600) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-460,-70},{-440,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo2(
    final offset=1,
    final height=0.5,
    final duration=3600) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-420,-100},{-400,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TMixMea(
    final height=4,
    final duration=1,
    final offset=273.15 + 2,
    final startTime=0) "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-360,-100},{-340,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOut(
    final amplitude=5,
    final offset=18 + 273.15,
    final freqHz=1/3600) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-420,230},{-400,250}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine ducStaPre(
    final offset=200,
    final amplitude=150,
    final freqHz=1/3600) "Duct static pressure"
    annotation (Placement(transformation(extent={{-380,-18},{-360,2}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
    final offset=3,
    final amplitude=2,
    final freqHz=1/9600) "Duct static pressure setpoint reset requests"
    annotation (Placement(transformation(extent={{-460,-222},{-440,-202}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine1(
    final amplitude=6,
    final freqHz=1/9600)
    "Maximum supply temperature setpoint reset"
    annotation (Placement(transformation(extent={{-460,-180},{-440,-160}})));

  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-420,-180},{-400,-160}})));

  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-420,-222},{-400,-202}})));

  Buildings.Controls.OBC.CDL.Continuous.Round round1(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-380,-180},{-360,-160}})));

  Buildings.Controls.OBC.CDL.Continuous.Round round2(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-380,-222},{-360,-202}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger ducPreResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-340,-222},{-320,-202}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger maxSupResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-340,-180},{-320,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta[2](
    final k={true,false}) "Window status for each zone"
    annotation (Placement(transformation(extent={{-30,90},{-10,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc1(
    final height=2,
    final duration=3600) "Occupant number in zone 1"
    annotation (Placement(transformation(extent={{-460,80},{-440,100}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger occConv1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-400,80},{-380,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc2(
    final duration=3600,
    final height=3) "Occupant number in zone 2"
    annotation (Placement(transformation(extent={{-460,40},{-440,60}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger occConv2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-400,40},{-380,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut1(final k=258)
    "Low outdoor air temperature to cause freeze protection above stage0"
    annotation (Placement(transformation(extent={{380,140},{400,160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final period=10000,
    final startTime=500) "Logical pulse"
    annotation (Placement(transformation(extent={{360,0},{380,20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger freProSta1(
    final integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage2,
    final integerFalse=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage1)
    "Freeze protection stage changes from stage 1 to stage 2"
    annotation (Placement(transformation(extent={{400,0},{420,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    final duration=3600,
    final height=6) "Ramp signal for generating operation mode"
    annotation (Placement(transformation(extent={{-460,-140},{-440,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.Abs abs2
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-420,-140},{-400,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.Round round3(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-380,-140},{-360,-120}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-340,-140},{-320,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutBelowCutoff(
    final k=45000)
    "Outdoor air enthalpy is slightly below the cutoff"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutCut(final k=65100)
    "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{142,100},{162,120}})));

equation
  connect(TZon.y, conAHU.TZon)
    annotation (Line(points={{-437,260},{-300,260},{-300,141.167},{-262,141.167}},
      color={0,0,127}));
  connect(TOutCut.y, conAHU.TOutCut)
    annotation (Line(points={{-399,200},{-310,200},{-310,123.833},{-262,123.833}},
      color={0,0,127}));
  connect(TSup.y, conAHU.TSup)
    annotation (Line(points={{-439,220},{-430,220},{-430,108.667},{-262,108.667}},
                                    color={0,0,127}));
  connect(VOut_flow.y, conAHU.VOut_flow)
    annotation (Line(points={{-439,-8},{-420,-8},{-420,20},{-314,20},{-314,
          95.6667},{-262,95.6667}},
                           color={0,0,127}));
  connect(ducStaPre.y, conAHU.ducStaPre)
    annotation (Line(points={{-359,-8},{-308,-8},{-308,91.3333},{-262,91.3333}},
      color={0,0,127}));
  connect(vavBoxFlo1.y, conAHU.VDis_flow[1])
    annotation (Line(points={{-439,-60},{-420,-60},{-420,-30},{-302,-30},{-302,84},
          {-282,84},{-282,83.75},{-262,83.75}},color={0,0,127}));
  connect(vavBoxFlo2.y, conAHU.VDis_flow[2])
    annotation (Line(points={{-399,-90},{-380,-90},{-380,-60},{-304,-60},{-304,
          86},{-284,86},{-284,85.9167},{-262,85.9167}},
                                                   color={0,0,127}));
  connect(TMixMea.y, conAHU.TMix)
    annotation (Line(points={{-339,-90},{-300,-90},{-300,80.5},{-262,80.5}},
      color={0,0,127}));
  connect(maxSupResReq.y, conAHU.uZonTemResReq)
    annotation (Line(points={{-319,-170},{-276,-170},{-276,61},{-262,61}},
      color={255,127,0}));
  connect(ducPreResReq.y, conAHU.uZonPreResReq)
    annotation (Line(points={{-319,-212},{-272,-212},{-272,54.5},{-262,54.5}},
      color={255,127,0}));
  connect(TOut.y, conAHU.TOut)
    annotation (Line(points={{-399,240},{-288,240},{-288,145.5},{-262,145.5}},
      color={0,0,127}));
  connect(TDis.y, conAHU.TDis)
    annotation (Line(points={{-439,170},{-420,170},{-420,132.5},{-262,132.5}},
      color={0,0,127}));
  connect(TSetRooHeaOn.y, conAHU.TZonHeaSet)
    annotation (Line(points={{-439,310},{-280,310},{-280,158.5},{-262,158.5}},
      color={0,0,127}));
  connect(TSetRooCooOn.y, conAHU.TZonCooSet) annotation (Line(points={{-399,290},
          {-284,290},{-284,154.167},{-262,154.167}}, color={0,0,127}));
  connect(ram.y, abs2.u)
    annotation (Line(points={{-439,-130},{-422,-130}},color={0,0,127}));
  connect(abs2.y, round3.u)
    annotation (Line(points={{-399,-130},{-382,-130}},color={0,0,127}));
  connect(round3.y, reaToInt2.u)
    annotation (Line(points={{-359,-130},{-342,-130}},color={0,0,127}));
  connect(reaToInt2.y, conAHU.uOpeMod) annotation (Line(points={{-319,-130},{
          -280,-130},{-280,71.8333},{-262,71.8333}},
                                               color={255,127,0}));
  connect(sine1.y, abs.u)
    annotation (Line(points={{-439,-170},{-422,-170}},color={0,0,127}));
  connect(abs.y, round1.u)
    annotation (Line(points={{-399,-170},{-382,-170}},color={0,0,127}));
  connect(round1.y, maxSupResReq.u)
    annotation (Line(points={{-359,-170},{-342,-170}},color={0,0,127}));
  connect(round2.y, ducPreResReq.u)
    annotation (Line(points={{-359,-212},{-354,-212},{-354,-214},{-350,-214},{-350,
          -212},{-342,-212}},color={0,0,127}));
  connect(abs1.y, round2.u)
    annotation (Line(points={{-399,-212},{-394,-212},{-394,-214},{-390,-214},{-390,
          -212},{-382,-212}},color={0,0,127}));
  connect(sine.y, abs1.u)
    annotation (Line(points={{-439,-212},{-434,-212},{-434,-214},{-430,-214},{-430,
          -212},{-422,-212}}, color={0,0,127}));
  connect(numOfOcc2.y, occConv2.u)
    annotation (Line(points={{-439,50},{-402,50}}, color={0,0,127}));
  connect(numOfOcc1.y, occConv1.u)
    annotation (Line(points={{-439,90},{-402,90}}, color={0,0,127}));
  connect(occConv1.y, conAHU.nOcc[1]) annotation (Line(points={{-379,90},{-340,
          90},{-340,98.9167},{-262,98.9167}},
                                          color={255,127,0}));
  connect(occConv2.y, conAHU.nOcc[2]) annotation (Line(points={{-379,50},{-340,
          50},{-340,101.083},{-262,101.083}},
                                          color={255,127,0}));
  connect(TSetRooHeaOn.y, conAHU1.TZonHeaSet) annotation (Line(points={{-439,310},
          {-136,310},{-136,158.5},{-122,158.5}},  color={0,0,127}));
  connect(TSetRooCooOn.y, conAHU1.TZonCooSet) annotation (Line(points={{-399,
          290},{-140,290},{-140,154.167},{-122,154.167}},
                                                     color={0,0,127}));
  connect(TOut.y, conAHU1.TOut) annotation (Line(points={{-399,240},{-144,240},{
          -144,145.5},{-122,145.5}},  color={0,0,127}));
  connect(TZon.y, conAHU1.TZon) annotation (Line(points={{-437,260},{-148,260},
          {-148,141.167},{-122,141.167}},color={0,0,127}));
  connect(TDis.y, conAHU1.TDis) annotation (Line(points={{-439,170},{-420,170},{
          -420,180},{-150,180},{-150,132.5},{-122,132.5}}, color={0,0,127}));
  connect(TOutCut.y, conAHU1.TOutCut) annotation (Line(points={{-399,200},{-152,
          200},{-152,123.833},{-122,123.833}},  color={0,0,127}));
  connect(TSup.y, conAHU1.TSup) annotation (Line(points={{-439,220},{-154,220},
          {-154,108.667},{-122,108.667}},
                                        color={0,0,127}));
  connect(occConv1.y, conAHU1.nOcc[1]) annotation (Line(points={{-379,90},{-332,
          90},{-332,22},{-152,22},{-152,98.9167},{-122,98.9167}}, color={255,127,0}));
  connect(conAHU1.nOcc[2], occConv2.y) annotation (Line(points={{-122,101.083},
          {-154,101.083},{-154,22},{-332,22},{-332,50},{-379,50}},color={255,127,0}));
  connect(VOut_flow.y, conAHU1.VOut_flow) annotation (Line(points={{-439,-8},{
          -420,-8},{-420,20},{-148,20},{-148,95.6667},{-122,95.6667}},
                                                                  color={0,0,127}));
  connect(ducStaPre.y, conAHU1.ducStaPre) annotation (Line(points={{-359,-8},{
          -144,-8},{-144,91.3333},{-122,91.3333}},
                                              color={0,0,127}));
  connect(vavBoxFlo1.y, conAHU1.VDis_flow[1]) annotation (Line(points={{-439,-60},
          {-420,-60},{-420,-30},{-140,-30},{-140,83.75},{-122,83.75}}, color={0,0,127}));
  connect(vavBoxFlo2.y, conAHU1.VDis_flow[2]) annotation (Line(points={{-399,
          -90},{-380,-90},{-380,-60},{-142,-60},{-142,85.9167},{-122,85.9167}},
                                                                           color={0,0,127}));
  connect(TMixMea.y, conAHU1.TMix) annotation (Line(points={{-339,-90},{-138,-90},
          {-138,80.5},{-122,80.5}}, color={0,0,127}));
  connect(ducPreResReq.y, conAHU1.uZonPreResReq) annotation (Line(points={{-319,
          -212},{-126,-212},{-126,54.5},{-122,54.5}}, color={255,127,0}));
  connect(maxSupResReq.y, conAHU1.uZonTemResReq) annotation (Line(points={{-319,
          -170},{-128,-170},{-128,61},{-122,61}}, color={255,127,0}));
  connect(reaToInt2.y, conAHU1.uOpeMod) annotation (Line(points={{-319,-130},{
          -130,-130},{-130,71.8333},{-122,71.8333}},
                                               color={255,127,0}));
  connect(TSetRooHeaOn.y, conAHU2.TZonHeaSet) annotation (Line(points={{-439,310},
          {28,310},{28,158.5},{38,158.5}},  color={0,0,127}));
  connect(TSetRooCooOn.y, conAHU2.TZonCooSet) annotation (Line(points={{-399,
          290},{20,290},{20,154.167},{38,154.167}},
                                               color={0,0,127}));
  connect(TOut.y, conAHU2.TOut) annotation (Line(points={{-399,240},{16,240},{16,
          145.5},{38,145.5}}, color={0,0,127}));
  connect(TZon.y, conAHU2.TZon) annotation (Line(points={{-437,260},{12,260},{
          12,141.167},{38,141.167}},
                                  color={0,0,127}));
  connect(TDis.y, conAHU2.TDis) annotation (Line(points={{-439,170},{-420,170},{
          -420,180},{8,180},{8,132.5},{38,132.5}}, color={0,0,127}));
  connect(TOutCut.y, conAHU2.TOutCut) annotation (Line(points={{-399,200},{4,
          200},{4,123.833},{38,123.833}},
                                    color={0,0,127}));
  connect(TSup.y, conAHU2.TSup) annotation (Line(points={{-439,220},{0,220},{0,
          108.667},{38,108.667}},
                         color={0,0,127}));
  connect(winSta.y, conAHU2.uWin) annotation (Line(points={{-9,100},{0,100},{0,
          104.333},{38,104.333}},
                         color={255,0,255}));
  connect(VOut_flow.y, conAHU2.VOut_flow) annotation (Line(points={{-439,-8},{
          -420,-8},{-420,20},{0,20},{0,95.6667},{38,95.6667}},
                                                          color={0,0,127}));
  connect(ducStaPre.y, conAHU2.ducStaPre) annotation (Line(points={{-359,-8},{2,
          -8},{2,91.3333},{38,91.3333}},  color={0,0,127}));
  connect(TMixMea.y, conAHU2.TMix) annotation (Line(points={{-339,-90},{12,-90},
          {12,80.5},{38,80.5}}, color={0,0,127}));
  connect(VOut_flow.y, conAHU2.VDis_flow[1]) annotation (Line(points={{-439,-8},
          {-420,-8},{-420,20},{10,20},{10,83.75},{38,83.75}},color={0,0,127}));
  connect(vavBoxFlo1.y, conAHU2.VDis_flow[2]) annotation (Line(points={{-439,
          -60},{-420,-60},{-420,-30},{6,-30},{6,85.9167},{38,85.9167}},
                                                                  color={0,0,127}));
  connect(reaToInt2.y, conAHU2.uOpeMod) annotation (Line(points={{-319,-130},{
          18,-130},{18,71.8333},{38,71.8333}},
                                           color={255,127,0}));
  connect(maxSupResReq.y, conAHU2.uZonTemResReq) annotation (Line(points={{-319,
          -170},{24,-170},{24,61},{38,61}}, color={255,127,0}));
  connect(ducPreResReq.y, conAHU2.uZonPreResReq) annotation (Line(points={{-319,
          -212},{30,-212},{30,54.5},{38,54.5}}, color={255,127,0}));
  connect(hOutBelowCutoff.y, conAHU3.hOut) annotation (Line(points={{161,150},{180,
          150},{180,119.5},{220,119.5}},color={0,0,127}));
  connect(hOutCut.y, conAHU3.hOutCut) annotation (Line(points={{163,110},{180,
          110},{180,115.167},{220,115.167}},
                                       color={0,0,127}));
  connect(reaToInt2.y, conAHU3.uOpeMod) annotation (Line(points={{-319,-130},{
          204,-130},{204,71.8333},{220,71.8333}},
                                             color={255,127,0}));
  connect(maxSupResReq.y, conAHU3.uZonTemResReq) annotation (Line(points={{-319,
          -170},{206,-170},{206,61},{220,61}}, color={255,127,0}));
  connect(ducPreResReq.y, conAHU3.uZonPreResReq) annotation (Line(points={{-319,
          -212},{208,-212},{208,54.5},{220,54.5}}, color={255,127,0}));
  connect(TSetRooHeaOn.y, conAHU3.TZonHeaSet) annotation (Line(points={{-439,310},
          {194,310},{194,158.5},{220,158.5}}, color={0,0,127}));
  connect(TSetRooCooOn.y, conAHU3.TZonCooSet) annotation (Line(points={{-399,
          290},{194,290},{194,154.167},{220,154.167}},
                                                  color={0,0,127}));
  connect(TOut.y, conAHU3.TOut) annotation (Line(points={{-399,240},{190,240},{190,
          145.5},{220,145.5}},     color={0,0,127}));
  connect(TZon.y, conAHU3.TZon) annotation (Line(points={{-437,260},{188,260},{
          188,141.167},{220,141.167}}, color={0,0,127}));
  connect(TDis.y, conAHU3.TDis) annotation (Line(points={{-439,170},{-420,170},{
          -420,180},{188,180},{188,132.5},{220,132.5}}, color={0,0,127}));
  connect(TOutCut.y, conAHU3.TOutCut) annotation (Line(points={{-399,200},{186,
          200},{186,123.833},{220,123.833}},
                                       color={0,0,127}));
  connect(TSup.y, conAHU3.TSup) annotation (Line(points={{-439,220},{182,220},{
          182,108.667},{220,108.667}},
                                  color={0,0,127}));
  connect(VOut_flow.y, conAHU3.VOut_flow) annotation (Line(points={{-439,-8},{
          -420,-8},{-420,20},{184,20},{184,95.6667},{220,95.6667}},
                                                               color={0,0,127}));
  connect(ducStaPre.y, conAHU3.ducStaPre) annotation (Line(points={{-359,-8},{
          188,-8},{188,91.3333},{220,91.3333}},
                                            color={0,0,127}));
  connect(vavBoxFlo1.y, conAHU3.VDis_flow[1]) annotation (Line(points={{-439,-60},
          {-420,-60},{-420,-30},{196,-30},{196,83.75},{220,83.75}}, color={0,0,127}));
  connect(vavBoxFlo2.y, conAHU3.VDis_flow[2]) annotation (Line(points={{-399,
          -90},{-380,-90},{-380,-60},{190,-60},{190,85.9167},{220,85.9167}},
                                                                       color={0,0,127}));
  connect(TMixMea.y, conAHU3.TMix) annotation (Line(points={{-339,-90},{200,-90},
          {200,80.5},{220,80.5}}, color={0,0,127}));
  connect(TSetRooHeaOn.y, conAHU4.TZonHeaSet) annotation (Line(points={{-439,310},
          {438,310},{438,158.5},{460,158.5}},color={0,0,127}));
  connect(TSetRooCooOn.y, conAHU4.TZonCooSet) annotation (Line(points={{-399,
          290},{432,290},{432,154.167},{460,154.167}},
                                                  color={0,0,127}));
  connect(TOut1.y, conAHU4.TOut) annotation (Line(points={{401,150},{408,150},{408,
          145.5},{460,145.5}}, color={0,0,127}));
  connect(ducPreResReq.y, conAHU4.uZonPreResReq) annotation (Line(points={{-319,
          -212},{350,-212},{350,54.5},{460,54.5}}, color={255,127,0}));
  connect(maxSupResReq.y, conAHU4.uZonTemResReq) annotation (Line(points={{-319,
          -170},{340,-170},{340,61},{460,61}}, color={255,127,0}));
  connect(reaToInt2.y, conAHU4.uOpeMod) annotation (Line(points={{-319,-130},{
          332,-130},{332,71.8333},{460,71.8333}},
                                              color={255,127,0}));
  connect(conAHU4.TZon, TZon.y) annotation (Line(points={{460,141.167},{418,
          141.167},{418,260},{-437,260}},
                                 color={0,0,127}));
  connect(conAHU4.TDis, TDis.y) annotation (Line(points={{460,132.5},{414,132.5},
          {414,180},{-420,180},{-420,170},{-439,170}}, color={0,0,127}));
  connect(conAHU4.TOutCut, TOutCut.y) annotation (Line(points={{460,123.833},{
          358,123.833},{358,200},{-399,200}},
                                          color={0,0,127}));
  connect(vavBoxFlo1.y, conAHU4.VDis_flow[1]) annotation (Line(points={{-439,-60},
          {-420,-60},{-420,-30},{328,-30},{328,83.75},{460,83.75}}, color={0,0,127}));
  connect(vavBoxFlo2.y, conAHU4.VDis_flow[2]) annotation (Line(points={{-399,
          -90},{-380,-90},{-380,-60},{324,-60},{324,85.9167},{460,85.9167}},
                                                                        color={0, 0,127}));
  connect(VOut_flow.y, conAHU4.VOut_flow) annotation (Line(points={{-439,-8},{
          -420,-8},{-420,20},{316,20},{316,95.6667},{460,95.6667}},
                                                               color={0,0,127}));
  connect(ducStaPre.y, conAHU4.ducStaPre) annotation (Line(points={{-359,-8},{
          320,-8},{320,91.3333},{460,91.3333}},
                                            color={0,0,127}));
  connect(booPul1.y, freProSta1.u)
    annotation (Line(points={{381,10},{398,10}}, color={255,0,255}));
  connect(freProSta1.y, conAHU4.uFreProSta) annotation (Line(points={{421,10},{
          438,10},{438,45.8333},{460,45.8333}},
                                            color={255,127,0}));
  connect(TSup.y, conAHU4.TSup) annotation (Line(points={{-439,220},{354,220},{
          354,108.667},{460,108.667}},
                                   color={0,0,127}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/VAV/Validation/ControllerConfigurationTest.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
It tests the controller for different configurations of the Boolean parameters, such as
for controllers with occupancy sensors, with window status sensors, with single or dual duct boxes etc.
</p>
</html>", revisions="<html>
<ul>
<li>
July 19, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(extent={{-520,-240},{560,340}})),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end ControllerConfigurationTest;
