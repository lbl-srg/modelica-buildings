within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Validation;
model PrimaryController
  "Validation model for boiler plant primary control sequence"

  parameter Integer nSchRow(
    final min=1) = 4
    "Number of rows to be created for plant schedule table";

  parameter Real schTab[nSchRow,2] = [0,1; 6,1; 18,1; 24,1]
    "Table defining schedule for enabling plant";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.PrimaryController
                                                                     controller(
    final have_priOnl=true,
    final nBoi=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final nSta=3,
    final staMat=[1,0; 0,1; 1,1],
    final nSenPri=1,
    final nPumPri_nominal=2,
    final VHotWatPri_flow_nominal=0.0006,
    final maxLocDpPri=4100,
    final minLocDpPri=3900,
    final speConTypPri=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP,
    final boiDesCap={15000*0.8,15000*0.8},
    final boiFirMin={0.2,0.3},
    final minFloSet={0.2*0.0003,0.3*0.0003},
    final maxFloSet={0.0003,0.0003},
    final bypSetRat=0.00001,
    final nPumPri=2,
    final have_heaPriPum=true,
    final TMinSupNonConBoi = 333.2,
    final have_varPriPum=true,
    final boiDesFlo={0.0003,0.0003},
    final minPriPumSpeSta={0,0,0})
    "Test scenario for primary-only boiler plants with headered variable speed primary pumps"
    annotation (Placement(transformation(extent={{-260,12},{-240,96}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.PrimaryController
                                                                     controller1(
    final have_priOnl=false,
    final have_secFloSen=true,
    final nBoi=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final nSta=3,
    final staMat=[1,0; 0,1; 1,1],
    final nSenPri=1,
    final nPumPri_nominal=2,
    final VHotWatPri_flow_nominal=0.0006,
    final maxLocDpPri=4100,
    final minLocDpPri=3900,
    final speConTypPri=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.flowrate,
    final boiDesCap={15000*0.8,15000*0.8},
    final boiFirMin={0.2,0.3},
    final minFloSet={0.2*0.0003,0.3*0.0003},
    final maxFloSet={0.0003,0.0003},
    final bypSetRat=0.00001,
    final nPumPri=2,
    final have_heaPriPum=true,
    final TMinSupNonConBoi=333.2,
    final have_varPriPum=true,
    final boiDesFlo={0.0003,0.0003},
    final minPriPumSpeSta={0,0,0})
    "Test scenario for primary-secondary boiler plants with headered variable speed primary pumps"
    annotation (Placement(transformation(extent={{0,12},{20,96}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.PrimaryController
                                                                     controller2(
    final have_priOnl=false,
    final have_secFloSen=true,
    final nBoi=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final nSta=3,
    final staMat=[1,0; 0,1; 1,1],
    final nSenPri=1,
    final nPumPri_nominal=2,
    final VHotWatPri_flow_nominal=0.0006,
    final maxLocDpPri=4100,
    final minLocDpPri=3900,
    final speConTypPri=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.flowrate,
    final boiDesCap={15000*0.8,15000*0.8},
    final boiFirMin={0.2,0.3},
    final minFloSet={0.2*0.0003,0.3*0.0003},
    final maxFloSet={0.0003,0.0003},
    final bypSetRat=0.00001,
    final nPumPri=2,
    final have_heaPriPum=false,
    final TMinSupNonConBoi=333.2,
    final have_varPriPum=true,
    final boiDesFlo={0.0003,0.0003},
    final minPriPumSpeSta={0,0,0})
    "Test scenario for primary-secondary boiler plants with dedicated variable speed primary pumps"
    annotation (Placement(transformation(extent={{220,12},{240,96}})));

protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel[2](
    final delayTime=fill(10, 2))
    "True delay for simulating boiler proven on process"
    annotation (Placement(transformation(extent={{-220,130},{-200,150}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1[2](
    final delayTime=fill(20, 2))
    "True delay for simulating pump proven on process"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(
    final samplePeriod=1)
    "Unit delay to simulate change of bypass valve position"
    annotation (Placement(transformation(extent={{-220,70},{-200,90}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel1[2](
    final samplePeriod=fill(1, 2))
    "Unit delay to simulate change of isolation valve position"
    annotation (Placement(transformation(extent={{-220,100},{-200,120}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2[2](
    final delayTime=fill(15, 2))
    "True delay for simulating boiler proven on process"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel2[2](
    final samplePeriod=fill(1, 2))
    "Unit delay to simulate change of isolation valve position"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3[2](
    final delayTime=fill(20, 2))
    "True delay for simulating pump proven on process"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel4[2](
    final samplePeriod=fill(1, 2))
    "Unit delay to simulate change of pump speed"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=2)
    "Replicate pump speed to all pumps in system"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel5[2](
    final delayTime=fill(20, 2))
    "True delay for simulating boiler proven on process"
    annotation (Placement(transformation(extent={{260,120},{280,140}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel6[2](
    final delayTime=fill(20, 2))
    "True delay for simulating pump proven on process"
    annotation (Placement(transformation(extent={{260,90},{280,110}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel3[2](
    final samplePeriod=fill(1, 2))
    "Unit delay to simulate change of pump speed"
    annotation (Placement(transformation(extent={{290,60},{310,80}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep1(
    final nout=2)
    "Replicate pump speed to all pumps in system"
    annotation (Placement(transformation(extent={{260,60},{280,80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=0)
    "Number of temperature reset requests"
    annotation (Placement(transformation(extent={{-340,150},{-320,170}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[2]
    "Logical pre block"
    annotation (Placement(transformation(extent={{-190,130},{-170,150}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2[2]
    "Logical pre block"
    annotation (Placement(transformation(extent={{-190,40},{-170,60}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre3[2]
    "Logical pre block"
    annotation (Placement(transformation(extent={{70,130},{90,150}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre4[2]
    "Logical pre block"
    annotation (Placement(transformation(extent={{70,60},{90,80}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre6[2]
    "Logical pre block"
    annotation (Placement(transformation(extent={{290,120},{310,140}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre7[2]
    "Logical pre block"
    annotation (Placement(transformation(extent={{290,90},{310,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut(
    final k=290)
    "Measured outdoor air drybulb temperature"
    annotation (Placement(transformation(extent={{-340,90},{-320,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSup(
    final k=340)
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-340,60},{-320,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRet(
    final k=335)
    "Measured hot water return temperature"
    annotation (Placement(transformation(extent={{-340,30},{-320,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VHotWat_flow[4](
    final k={6e-5,9e-5,20e-5,0.0004})
    "Measured hot water volume flowrate in primary loop"
    annotation (Placement(transformation(extent={{-340,0},{-320,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dPHotWat[1](
    final k={4000})
    "Measured differential pressure between hot water supply and return in primary loop"
    annotation (Placement(transformation(extent={{-340,-30},{-320,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uBoiAva[2](
    final k={true,true})
    "Boiler availability status vector"
    annotation (Placement(transformation(extent={{-340,-60},{-320,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(
    final amplitude=2,
    final freqHz=1/14400)
    "Sine input"
    annotation (Placement(transformation(extent={{-340,120},{-320,140}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-300,120},{-280,140}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut1(
    final k=290)
    "Measured outdoor air drybulb temperature"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSup1(
    final k=340)
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRet1(
    final k=335)
    "Measured hot water return temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VHotWat_flow1[4](
    final k={6e-5,9e-5,20e-5,0.00029})
    "Measured hot water volume flowrate in primary loop"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dPHotWat1[1](
    final k={4000})
    "Measured differential pressure between hot water supply and return in secondary loop"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uBoiAva1[2](
    final k={true,true})
    "Boiler availability status vector"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin1(
    final amplitude=2, final freqHz=1/14400)
    "Sine input"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VHotWatSec_flow(
    final k=0.0003)
    "Measured hot water volume flowrate in secondary loop"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut2(
    final k=290)
    "Measured outdoor air drybulb temperature"
    annotation (Placement(transformation(extent={{140,90},{160,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSup2(
    final k=340)
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{140,60},{160,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRet2(
    final k=335)
    "Measured hot water return temperature"
    annotation (Placement(transformation(extent={{140,30},{160,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VHotWat_flow2[4](
    final k={6e-5,9e-5,20e-5,0.00029})
    "Measured hot water volume flowrate in primary loop"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dPHotWat2[1](
    final k={4000})
    "Measured differential pressure between hot water supply and return in secondary loop"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uBoiAva2[2](
    final k={true,true})
    "Boiler availability status vector"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin2(
    final amplitude=2,
    final freqHz=1/14400)
    "Sine input"
    annotation (Placement(transformation(extent={{140,120},{160,140}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{180,120},{200,140}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VHotWatSec_flow1(
    final k=0.0003)
    "Measured hot water volume flowrate in secondary loop"
    annotation (Placement(transformation(extent={{140,-100},{160,-80}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=0.5)
    "Check if schedule lets the controller enable the plant or not"
    annotation (Placement(transformation(extent={{-300,190},{-280,210}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable enaSch(
    final table=schTab,
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final timeScale=3600)
    "Table defining when plant can be enabled"
    annotation (Placement(transformation(extent={{-340,190},{-320,210}})));

equation
  connect(TOut.y, controller.TOut) annotation (Line(points={{-318,100},{-290,
          100},{-290,82},{-262,82}},  color={0,0,127}));

  connect(uBoiAva.y, controller.uBoiAva) annotation (Line(points={{-318,-50},{
          -288,-50},{-288,54},{-262,54}},        color={255,0,255}));

  connect(TSup.y, controller.TSupPri) annotation (Line(points={{-318,70},{-310,
          70},{-310,74},{-262,74}},    color={0,0,127}));

  connect(TRet.y, controller.TRetPri) annotation (Line(points={{-318,40},{-300,
          40},{-300,70},{-262,70}},    color={0,0,127}));

  connect(dPHotWat.y, controller.dpHotWatPri_rem) annotation (Line(points={{-318,
          -20},{-294,-20},{-294,58},{-262,58}}, color={0,0,127}));

  connect(VHotWat_flow[4].y, controller.VHotWatPri_flow) annotation (Line(
        points={{-318,10},{-298,10},{-298,66},{-262,66}},   color={0,0,127}));

  connect(sin.y, reaToInt.u)
    annotation (Line(points={{-318,130},{-302,130}}, color={0,0,127}));

  connect(TOut1.y, controller1.TOut) annotation (Line(points={{-58,100},{-26,
          100},{-26,82},{-2,82}},
                               color={0,0,127}));

  connect(uBoiAva1.y, controller1.uBoiAva) annotation (Line(points={{-58,-50},{
          -34,-50},{-34,54},{-2,54}},
                                  color={255,0,255}));

  connect(TSup1.y, controller1.TSupPri) annotation (Line(points={{-58,70},{-50,
          70},{-50,74},{-2,74}},    color={0,0,127}));

  connect(TRet1.y, controller1.TRetPri) annotation (Line(points={{-58,40},{-40,
          40},{-40,70},{-2,70}},    color={0,0,127}));

  connect(VHotWat_flow1[4].y, controller1.VHotWatPri_flow) annotation (Line(
        points={{-58,10},{-38,10},{-38,66},{-2,66}},   color={0,0,127}));

  connect(sin1.y, reaToInt1.u)
    annotation (Line(points={{-58,130},{-42,130}}, color={0,0,127}));

  connect(VHotWatSec_flow.y, controller1.VHotWatSec_flow) annotation (Line(
        points={{-58,-90},{-30,-90},{-30,50},{-2,50}},
                                                     color={0,0,127}));

  connect(TRet1.y, controller1.TRetSec) annotation (Line(points={{-58,40},{-40,
          40},{-40,62},{-2,62}},    color={0,0,127}));

  connect(TOut2.y,controller2. TOut) annotation (Line(points={{162,100},{190,
          100},{190,82},{218,82}},
                               color={0,0,127}));

  connect(uBoiAva2.y,controller2. uBoiAva) annotation (Line(points={{162,-50},{
          192,-50},{192,54},{218,54}},
                                  color={255,0,255}));

  connect(TSup2.y,controller2. TSupPri) annotation (Line(points={{162,70},{170,
          70},{170,74},{218,74}},   color={0,0,127}));

  connect(TRet2.y,controller2. TRetPri) annotation (Line(points={{162,40},{180,
          40},{180,70},{218,70}},   color={0,0,127}));

  connect(VHotWat_flow2[4].y,controller2. VHotWatPri_flow) annotation (Line(
        points={{162,10},{182,10},{182,66},{218,66}},  color={0,0,127}));

  connect(sin2.y,reaToInt2. u)
    annotation (Line(points={{162,130},{178,130}}, color={0,0,127}));

  connect(VHotWatSec_flow1.y, controller2.VHotWatSec_flow) annotation (Line(
        points={{162,-90},{196,-90},{196,50},{218,50}},   color={0,0,127}));

  connect(TRet2.y,controller2. TRetSec) annotation (Line(points={{162,40},{180,
          40},{180,62},{218,62}},   color={0,0,127}));

  connect(controller.yBoi, truDel.u) annotation (Line(points={{-238,72},{-230,
          72},{-230,140},{-222,140}},
                                  color={255,0,255}));
  connect(controller.yPriPum, truDel1.u) annotation (Line(points={{-238,44},{
          -230,44},{-230,50},{-222,50}},
                                    color={255,0,255}));
  connect(controller.yBypValPos, uniDel.u) annotation (Line(points={{-238,52},{
          -224,52},{-224,80},{-222,80}},
                                    color={0,0,127}));
  connect(uniDel.y, controller.uBypValPos) annotation (Line(points={{-198,80},{
          -150,80},{-150,0},{-272,0},{-272,18},{-262,18}},
                                                        color={0,0,127}));
  connect(controller.yHotWatIsoVal, uniDel1.u) annotation (Line(points={{-238,64},
          {-226,64},{-226,110},{-222,110}}, color={0,0,127}));
  connect(uniDel1.y, controller.uHotWatIsoVal) annotation (Line(points={{-198,
          110},{-144,110},{-144,-16},{-278,-16},{-278,22},{-262,22}},
                                                                 color={0,0,127}));
  connect(controller1.yBoi, truDel2.u) annotation (Line(points={{22,72},{26,72},
          {26,140},{38,140}}, color={255,0,255}));
  connect(controller1.yHotWatIsoVal, uniDel2.u) annotation (Line(points={{22,64},
          {28,64},{28,110},{38,110}}, color={0,0,127}));
  connect(controller1.yPriPum, truDel3.u) annotation (Line(points={{22,44},{34,
          44},{34,70},{38,70}},
                            color={255,0,255}));
  connect(uniDel2.y, controller1.uHotWatIsoVal) annotation (Line(points={{62,110},
          {106,110},{106,-16},{-18,-16},{-18,22},{-2,22}}, color={0,0,127}));
  connect(reaRep.y, uniDel4.u)
    annotation (Line(points={{62,40},{68,40}}, color={0,0,127}));
  connect(controller1.yPriPumSpe, reaRep.u) annotation (Line(points={{22,40},{
          32,40},{32,40},{38,40}},
                                color={0,0,127}));
  connect(uniDel4.y, controller1.uPriPumSpe) annotation (Line(points={{92,40},{
          96,40},{96,-10},{-8,-10},{-8,14},{-2,14}},
                                                  color={0,0,127}));
  connect(controller2.yBoi, truDel5.u) annotation (Line(points={{242,72},{250,
          72},{250,130},{258,130}},
                                color={255,0,255}));
  connect(truDel6.u, controller2.yPriPum) annotation (Line(points={{258,100},{
          254,100},{254,44},{242,44}},
                                   color={255,0,255}));
  connect(reaRep1.y, uniDel3.u)
    annotation (Line(points={{282,70},{288,70}}, color={0,0,127}));
  connect(controller2.yPriPumSpe, reaRep1.u) annotation (Line(points={{242,40},
          {254,40},{254,70},{258,70}},color={0,0,127}));
  connect(uniDel3.y, controller2.uPriPumSpe) annotation (Line(points={{312,70},
          {320,70},{320,10},{216,10},{216,14},{218,14}},color={0,0,127}));
  connect(conInt.y, controller.TSupResReq) annotation (Line(points={{-318,160},
          {-266,160},{-266,90},{-262,90}},  color={255,127,0}));
  connect(conInt.y, controller1.TSupResReq) annotation (Line(points={{-318,160},
          {-6,160},{-6,90},{-2,90}},   color={255,127,0}));
  connect(conInt.y, controller2.TSupResReq) annotation (Line(points={{-318,160},
          {212,160},{212,90},{218,90}},   color={255,127,0}));
  connect(truDel.y, pre1.u)
    annotation (Line(points={{-198,140},{-192,140}}, color={255,0,255}));
  connect(pre1.y, controller.uBoi) annotation (Line(points={{-168,140},{-130,
          140},{-130,-30},{-284,-30},{-284,30},{-262,30}},
                                                      color={255,0,255}));
  connect(pre2.u, truDel1.y)
    annotation (Line(points={{-192,50},{-198,50}}, color={255,0,255}));
  connect(pre2.y, controller.uPriPum) annotation (Line(points={{-168,50},{-154,
          50},{-154,8},{-274,8},{-274,26},{-262,26}},
                                                  color={255,0,255}));
  connect(truDel2.y, pre3.u)
    annotation (Line(points={{62,140},{68,140}}, color={255,0,255}));
  connect(truDel3.y, pre4.u)
    annotation (Line(points={{62,70},{68,70}}, color={255,0,255}));
  connect(pre4.y, controller1.uPriPum) annotation (Line(points={{92,70},{108,70},
          {108,-20},{-10,-20},{-10,26},{-2,26}}, color={255,0,255}));
  connect(pre3.y, controller1.uBoi) annotation (Line(points={{92,140},{110,140},
          {110,-22},{-20,-22},{-20,30},{-2,30}}, color={255,0,255}));
  connect(pre6.u, truDel5.y)
    annotation (Line(points={{288,130},{282,130}}, color={255,0,255}));
  connect(pre6.y, controller2.uBoi) annotation (Line(points={{312,130},{340,130},
          {340,0},{202,0},{202,30},{218,30}}, color={255,0,255}));
  connect(pre7.u, truDel6.y)
    annotation (Line(points={{288,100},{282,100}}, color={255,0,255}));
  connect(pre7.y, controller2.uPriPum) annotation (Line(points={{312,100},{338,
          100},{338,2},{204,2},{204,26},{218,26}},
                                              color={255,0,255}));
  connect(reaToInt.y, controller.plaReq) annotation (Line(points={{-278,130},{
          -272,130},{-272,86},{-262,86}},   color={255,127,0}));
  connect(reaToInt1.y, controller1.plaReq) annotation (Line(points={{-18,130},{
          -12,130},{-12,86},{-2,86}},   color={255,127,0}));
  connect(reaToInt2.y, controller2.plaReq) annotation (Line(points={{202,130},{
          208,130},{208,86},{218,86}},   color={255,127,0}));
  connect(enaSch.y[1], greThr.u)
    annotation (Line(points={{-318,200},{-302,200}}, color={0,0,127}));
  connect(greThr.y, controller.uSchEna) annotation (Line(points={{-278,200},{
          -264,200},{-264,94},{-262,94}},      color={255,0,255}));
  connect(greThr.y, controller1.uSchEna) annotation (Line(points={{-278,200},{
          -4,200},{-4,108},{-2,108},{-2,94}},   color={255,0,255}));
  connect(greThr.y, controller2.uSchEna) annotation (Line(points={{-278,200},{
          216,200},{216,94},{218,94}},       color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={Ellipse(
                  lineColor = {75,138,73},
                  fillColor={255,255,255},
                  fillPattern = FillPattern.Solid,
                  extent={{-100,-100},{100,100}}),
                Polygon(
                  lineColor = {0,0,255},
                  fillColor = {75,138,73},
                  pattern = LinePattern.None,
                  fillPattern = FillPattern.Solid,
                  points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(
      preserveAspectRatio=false, extent={{-360,-140},{360,240}})),
    experiment(
      StopTime=7500,
      Tolerance=1e-06),
      __Dymola_Commands(file="./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Validation/PrimaryController.mos"
        "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller</a>.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      November 4, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end PrimaryController;
