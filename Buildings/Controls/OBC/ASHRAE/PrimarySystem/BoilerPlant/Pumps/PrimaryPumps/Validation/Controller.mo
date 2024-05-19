within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Validation;
model Controller
    "Validate boiler water pump control sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller
    priPumCon(
    final have_heaPriPum=true,
    final have_priOnl=true,
    final have_varPriPum=true,
    final nPum=2,
    final nBoi=2,
    final nSen=2,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final boiDesFlo={0.5,0.5},
    final maxLocDp=5*6894.75,
    final minLocDp=5*6894.75,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final k=1,
    final Ti=10,
    final Td=0.1,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP)
    "Testing pump configuration 1"
    annotation (Placement(transformation(extent={{-170,372},{-150,428}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller
    priPumCon1(
    final have_heaPriPum=true,
    final have_priOnl=true,
    final have_varPriPum=true,
    final nPum=2,
    final nBoi=2,
    final nSen=2,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final boiDesFlo={0.5,0.5},
    final maxLocDp=10,
    final minLocDp=5,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final k=1,
    final Ti=0.5,
    final Td=0.1,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.localDP)
    "Testing pump configuration 2"
    annotation (Placement(transformation(extent={{190,362},{210,418}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller
    priPumCon2(
    final have_heaPriPum=true,
    final have_priOnl=false,
    final have_varPriPum=true,
    final nPum=2,
    final nBoi=2,
    final nSen=2,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final boiDesFlo={0.5,0.5},
    final maxLocDp=10,
    final minLocDp=5,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final k=1,
    final Ti=0.5,
    final Td=0.1,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.flowrate)
    "Testing pump configuration 3"
    annotation (Placement(transformation(extent={{-170,222},{-150,278}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller
    priPumCon3(
    final have_heaPriPum=true,
    final have_priOnl=false,
    final have_varPriPum=true,
    final have_secFloSen=false,
    final nPum=2,
    final nBoi=2,
    final nSen=2,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final boiDesFlo={0.5,0.5},
    final maxLocDp=10,
    final minLocDp=5,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final k=1,
    final Ti=0.5,
    final Td=0.1,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.flowrate)
    "Testing pump configuration 4"
    annotation (Placement(transformation(extent={{190,202},{210,258}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller
    priPumCon4(
    final have_heaPriPum=true,
    final have_priOnl=false,
    final have_varPriPum=true,
    final have_priSecTemSen=true,
    final nPum=2,
    final nBoi=2,
    final nSen=2,
    final numIgnReq=0,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final boiDesFlo={0.5,0.5},
    final maxLocDp=10,
    final minLocDp=5,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final delTim=900,
    final samPer=120,
    final triAmo=-0.02,
    final resAmo=0.03,
    final maxRes=0.06,
    final twoReqLimLow=1.2,
    final twoReqLimHig=2,
    final oneReqLimLow=0.2,
    final oneReqLimHig=1,
    final k=1,
    final Ti=0.5,
    final Td=0.1,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature)
    "Testing pump configuration 5"
    annotation (Placement(transformation(extent={{-170,62},{-150,118}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller
    priPumCon5(
    final have_heaPriPum=true,
    final have_priOnl=false,
    final have_varPriPum=true,
    final have_priSecTemSen=false,
    final nPum=2,
    final nBoi=2,
    final nSen=2,
    final numIgnReq=0,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final boiDesFlo={0.5,0.5},
    final maxLocDp=10,
    final minLocDp=5,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final delTim=900,
    final samPer=120,
    final triAmo=-0.02,
    final resAmo=0.03,
    final maxRes=0.06,
    final twoReqLimLow=1.2,
    final twoReqLimHig=2,
    final oneReqLimLow=0.2,
    final oneReqLimHig=1,
    final k=1,
    final Ti=0.5,
    final Td=0.1,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature)
    "Testing pump configuration 6"
    annotation (Placement(transformation(extent={{190,42},{210,98}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller
    priPumCon6(
    final have_heaPriPum=true,
    final have_priOnl=false,
    final have_varPriPum=false,
    final have_priSecTemSen=false,
    final nPum=2,
    final nBoi=2,
    final nSen=2,
    final numIgnReq=0,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final boiDesFlo={0.5,0.5},
    final maxLocDp=10,
    final minLocDp=5,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final delTim=900,
    final samPer=120,
    final triAmo=-0.02,
    final resAmo=0.03,
    final maxRes=0.06,
    final twoReqLimLow=1.2,
    final twoReqLimHig=2,
    final oneReqLimLow=0.2,
    final oneReqLimHig=1,
    final k=1,
    final Ti=0.5,
    final Td=0.1,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature)
    "Testing pump configuration 7"
    annotation (Placement(transformation(extent={{-180,-118},{-160,-62}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller
    priPumCon7(
    final have_heaPriPum=false,
    final have_priOnl=false,
    final have_varPriPum=true,
    final nPum=2,
    final nBoi=2,
    final nSen=2,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final boiDesFlo={0.5,0.5},
    final maxLocDp=10,
    final minLocDp=5,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final k=1,
    final Ti=0.5,
    final Td=0.1,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.flowrate)
    "Testing pump configuration 8"
    annotation (Placement(transformation(extent={{210,-138},{230,-82}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller
    priPumCon8(
    final have_heaPriPum=false,
    final have_priOnl=false,
    final have_varPriPum=true,
    final have_secFloSen=false,
    final nPum=2,
    final nBoi=2,
    final nSen=2,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final boiDesFlo={0.5,0.5},
    final maxLocDp=10,
    final minLocDp=5,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final k=1,
    final Ti=0.5,
    final Td=0.1,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.flowrate)
    "Testing pump configuration 9"
    annotation (Placement(transformation(extent={{-180,-298},{-160,-242}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller
    priPumCon9(
    final have_heaPriPum=false,
    final have_priOnl=false,
    final have_varPriPum=true,
    final have_priSecTemSen=true,
    final nPum=2,
    final nBoi=2,
    final nSen=2,
    final numIgnReq=0,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final boiDesFlo={0.5,0.5},
    final maxLocDp=10,
    final minLocDp=5,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final delTim=900,
    final samPer=120,
    final triAmo=-0.02,
    final resAmo=0.03,
    final maxRes=0.06,
    final twoReqLimLow=1.2,
    final twoReqLimHig=2,
    final oneReqLimLow=0.2,
    final oneReqLimHig=1,
    final k=1,
    final Ti=0.5,
    final Td=0.1,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature)
    "Testing pump configuration 10"
    annotation (Placement(transformation(extent={{210,-308},{230,-252}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller
    priPumCon10(
    final have_heaPriPum=false,
    final have_priOnl=false,
    final have_varPriPum=true,
    final have_priSecTemSen=false,
    final nPum=2,
    final nBoi=2,
    final nSen=2,
    final numIgnReq=0,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final boiDesFlo={0.5,0.5},
    final maxLocDp=10,
    final minLocDp=5,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final delTim=900,
    final samPer=120,
    final triAmo=-0.02,
    final resAmo=0.03,
    final maxRes=0.06,
    final twoReqLimLow=1.2,
    final twoReqLimHig=2,
    final oneReqLimLow=0.2,
    final oneReqLimHig=1,
    final k=1,
    final Ti=0.5,
    final Td=0.1,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature)
    "Testing pump configuration 11"
    annotation (Placement(transformation(extent={{-170,-458},{-150,-402}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller
    priPumCon11(
    final have_heaPriPum=false,
    final have_priOnl=false,
    final have_varPriPum=false,
    final have_priSecTemSen=false,
    final nPum=2,
    final nBoi=2,
    final nSen=2,
    final numIgnReq=0,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final boiDesFlo={0.5,0.5},
    final maxLocDp=10,
    final minLocDp=5,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final delTim=900,
    final samPer=120,
    final triAmo=-0.02,
    final resAmo=0.03,
    final maxRes=0.06,
    final twoReqLimLow=1.2,
    final twoReqLimHig=2,
    final oneReqLimLow=0.2,
    final oneReqLimHig=1,
    final k=1,
    final Ti=0.5,
    final Td=0.1,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature)
    "Testing pump configuration 12"
    annotation (Placement(transformation(extent={{190,-488},{210,-432}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "True-hold for signal visualization"
    annotation (Placement(transformation(extent={{-50,210},{-30,230}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "True-hold for signal visualization"
    annotation (Placement(transformation(extent={{280,190},{300,210}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol2(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "True-hold for signal visualization"
    annotation (Placement(transformation(extent={{-38,80},{-18,100}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol3(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "True-hold for signal visualization"
    annotation (Placement(transformation(extent={{300,60},{320,80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol4(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "True-hold for signal visualization"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol5(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "True-hold for signal visualization"
    annotation (Placement(transformation(extent={{320,-110},{340,-90}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol6(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "True-hold for signal visualization"
    annotation (Placement(transformation(extent={{-60,-280},{-40,-260}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol7(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "True-hold for signal visualization"
    annotation (Placement(transformation(extent={{322,-290},{342,-270}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol8(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "True-hold for signal visualization"
    annotation (Placement(transformation(extent={{-60,-440},{-40,-420}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol9(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "True-hold for signal visualization"
    annotation (Placement(transformation(extent={{308,-450},{328,-430}})));

protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel6[2](
    final delayTime=fill(30, 2))
    "True delay to simulate pump proven on process"
    annotation (Placement(transformation(extent={{224,220},{244,240}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel7[2](
    final delayTime=fill(30, 2))
    "True delay to simulate pump proven on process"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel8[2](
    final delayTime=fill(30, 2))
    "True delay to simulate pump proven on process"
    annotation (Placement(transformation(extent={{216,64},{236,84}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel9[2](
    final delayTime=fill(30, 2))
    "True delay to simulate pump proven on process"
    annotation (Placement(transformation(extent={{-152,-100},{-132,-80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel10[2](
    final delayTime=fill(5, 2))
    "True delay to simulate pump proven on process"
    annotation (Placement(transformation(extent={{236,-116},{256,-96}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel11[2](
    delayTime=fill(5, 2))
    "True delay to simulate pump proven on process"
    annotation (Placement(transformation(extent={{-152,-278},{-132,-258}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel12[2](
    final delayTime=fill(5, 2))
    "True delay to simulate pump proven on process"
    annotation (Placement(transformation(extent={{236,-286},{256,-266}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel13[2](
    final delayTime=fill(5, 2))
    "True delay to simulate pump proven on process"
    annotation (Placement(transformation(extent={{-144,-434},{-124,-414}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel14[2](
    final delayTime=fill(5, 2))
    "True delay to simulate pump proven on process"
    annotation (Placement(transformation(extent={{218,-466},{238,-446}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol10(
    final trueHoldDuration=3300,
    final falseHoldDuration=0)
    "Hold boiler on signal"
    annotation (Placement(transformation(extent={{130,-110},{150,-90}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol11(
    final trueHoldDuration=3300,
    final falseHoldDuration=0)
    "Hold boiler on signal"
    annotation (Placement(transformation(extent={{-260,-270},{-240,-250}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha[2]
    "Detect changes in pump status"
    annotation (Placement(transformation(extent={{-110,210},{-90,230}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=2)
    "Multi Or"
    annotation (Placement(transformation(extent={{-78,210},{-58,230}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha6[2]
    "Detect changes in pump status"
    annotation (Placement(transformation(extent={{220,190},{240,210}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=2)
    "Multi Or"
    annotation (Placement(transformation(extent={{250,190},{270,210}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha7[2]
    "Detect changes in pump status"
    annotation (Placement(transformation(extent={{-98,60},{-78,80}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr2(
    final nin=2)
    "Multi Or"
    annotation (Placement(transformation(extent={{-68,60},{-48,80}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha8[2]
    "Detect changes in pump status"
    annotation (Placement(transformation(extent={{240,60},{260,80}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr3(
    final nin=2)
    "Multi Or"
    annotation (Placement(transformation(extent={{270,60},{290,80}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha9[2]
    "Detect changes in pump status"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr4(
    final nin=2)
    "Multi Or"
    annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha10[2]
    "Detect changes in pump status"
    annotation (Placement(transformation(extent={{260,-110},{280,-90}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr5(
    final nin=2)
    "Multi Or"
    annotation (Placement(transformation(extent={{290,-110},{310,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha11[2]
    "Detect changes in pump status"
    annotation (Placement(transformation(extent={{-120,-280},{-100,-260}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr6(
    final nin=2)
    "Multi Or"
    annotation (Placement(transformation(extent={{-90,-280},{-70,-260}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha22[2]
    "Detect changes in pump status"
    annotation (Placement(transformation(extent={{262,-290},{282,-270}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr7(
    final nin=2)
    "Multi Or"
    annotation (Placement(transformation(extent={{292,-290},{312,-270}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha23[2]
    "Detect changes in pump status"
    annotation (Placement(transformation(extent={{-120,-440},{-100,-420}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr8(
    final nin=2)
    "Multi Or"
    annotation (Placement(transformation(extent={{-90,-440},{-70,-420}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha24[2]
    "Detect changes in pump status"
    annotation (Placement(transformation(extent={{248,-450},{268,-430}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr9(
    final nin=2)
    "Multi Or"
    annotation (Placement(transformation(extent={{278,-450},{298,-430}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel5[2](
    final delayTime=fill(1, 2))
    "True delay to represent pump turning on"
    annotation (Placement(transformation(extent={{-140,240},{-120,260}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Integer switch"
    annotation (Placement(transformation(extent={{280,-186},{300,-166}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Integer switch"
    annotation (Placement(transformation(extent={{-120,-340},{-100,-320}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi2
    "Integer switch"
    annotation (Placement(transformation(extent={{280,-350},{300,-330}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi3
    "Integer switch"
    annotation (Placement(transformation(extent={{-100,-500},{-80,-480}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi4
    "Integer switch"
    annotation (Placement(transformation(extent={{260,-530},{280,-510}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=10)
    "Signal delay for boiler-2 enable"
    annotation (Placement(transformation(extent={{130,-150},{150,-130}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[2](
    final k={2,1})
    "Pump rotation"
    annotation (Placement(transformation(extent={{-220,440},{-200,460}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{-130,390},{-110,410}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin[2](
    final amplitude=fill(0.5, 2),
    final freqHz=fill(1/900, 2),
    final phase=fill(0, 2),
    final offset=fill(1, 2),
    final startTime=fill(0, 2))
    "Sine signal"
    annotation (Placement(transformation(extent={{-220,360},{-200,380}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin1(
    final amplitude=0.1,
    final freqHz=1/3600,
    final offset=0.25)
    "Sine signal"
    annotation (Placement(transformation(extent={{-270,390},{-250,410}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1[2](
    final k={2,1})
    "Pump rotation"
    annotation (Placement(transformation(extent={{140,430},{160,450}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{230,380},{250,400}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin2[2](
    final amplitude=fill(0.5, 2),
    final freqHz=fill(1/900, 2),
    final phase=fill(0, 2),
    final offset=fill(1, 2),
    final startTime=fill(0, 2))
    "Sine signal"
    annotation (Placement(transformation(extent={{146,348},{166,368}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin3(
    final amplitude=0.1,
    final freqHz=1/3600,
    final offset=0.25)
    "Sine signal"
    annotation (Placement(transformation(extent={{80,350},{100,370}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin4(
    final amplitude=5,
    final freqHz=1/450,
    final offset=7.5)
    "Sine signal"
    annotation (Placement(transformation(extent={{150,310},{170,330}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2[2](
    final k={2,1})
    "Pump rotation"
    annotation (Placement(transformation(extent={{-220,290},{-200,310}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre3[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{-110,240},{-90,260}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con8(
    final k=0.25)
    "Constant Real source"
    annotation (Placement(transformation(extent={{-310,190},{-290,210}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin5(
    final amplitude=0.1,
    final freqHz=1/900,
    final offset=0.25)
    "Sine signal"
    annotation (Placement(transformation(extent={{-214,208},{-194,228}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin6(
    final amplitude=0.1,
    final freqHz=1/3600,
    final offset=0.25)
    "Sine signal"
    annotation (Placement(transformation(extent={{-280,210},{-260,230}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final period=1800,
    final shift=15)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-280,170},{-260,190}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con9(
    final k=true)
    "Boolean true source"
    annotation (Placement(transformation(extent={{-250,210},{-230,230}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3[2](
    final k={2,1})
    "Pump rotation"
    annotation (Placement(transformation(extent={{140,270},{160,290}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre4[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{260,220},{280,240}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con12(
    final k=0.25)
    "Constant Real source"
    annotation (Placement(transformation(extent={{50,170},{70,190}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin7(
    final amplitude=0.1,
    final freqHz=1/900,
    final offset=0)
    "Sine signal"
    annotation (Placement(transformation(extent={{140,188},{160,208}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin8(
    final amplitude=0.1,
    final freqHz=1/3600,
    final offset=0)
    "Sine signal"
    annotation (Placement(transformation(extent={{80,190},{100,210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    final period=1800,
    final shift=60)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con13(
    final k=true)
    "Boolean true source"
    annotation (Placement(transformation(extent={{110,190},{130,210}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4[2](
    final k={2,1})
    "Pump rotation"
    annotation (Placement(transformation(extent={{-220,130},{-200,150}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre5[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{-98,100},{-78,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con16(
    final k=0.25)
    "Constant Real source"
    annotation (Placement(transformation(extent={{-310,30},{-290,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin9(
    final amplitude=1.5,
    final freqHz=1/3600,
    final phase=3.1415926535898,
    final offset=1)
    "Sine signal"
    annotation (Placement(transformation(extent={{-214,48},{-194,68}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin10(
    final amplitude=0.1,
    final freqHz=1/3600,
    final offset=0.25)
    "Sine signal"
    annotation (Placement(transformation(extent={{-280,50},{-260,70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul5(
    final period=1800,
    final shift=60)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-280,10},{-260,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con17(
    final k=true)
    "Boolean true source"
    annotation (Placement(transformation(extent={{-250,50},{-230,70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con18(
    final k=1)
    "Constant Real source"
    annotation (Placement(transformation(extent={{-310,-10},{-290,10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5[2](
    final k={2,1})
    "Pump rotation"
    annotation (Placement(transformation(extent={{140,110},{160,130}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre6[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{240,90},{260,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con21(
    final k=0.25)
    "Constant Real source"
    annotation (Placement(transformation(extent={{50,10},{70,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin11[2](
    final amplitude=fill(1.5, 2),
    final freqHz=fill(1/3600, 2),
    final phase=fill(3.14, 2),
    final offset=fill(1, 2),
    final startTime=fill(0, 2))
    "Sine signal"
    annotation (Placement(transformation(extent={{150,30},{170,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin12(
    final amplitude=0.1,
    final freqHz=1/3600,
    final offset=0.25)
    "Sine signal"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul7(
    final period=1800,
    final shift=60)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con22(
    final k=true)
    "Boolean true source"
    annotation (Placement(transformation(extent={{110,30},{130,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con23(
    final k=1)
    "Constant Real source"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6[2](
    final k={2,1})
    "Pump rotation"
    annotation (Placement(transformation(extent={{-230,-50},{-210,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre7[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin14(
    final amplitude=0.1,
    final freqHz=1/3600,
    final offset=0.25)
    "Sine signal"
    annotation (Placement(transformation(extent={{-290,-130},{-270,-110}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul9(
    final period=1800,
    final shift=60)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-290,-170},{-270,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con27(
    final k=true)
    "Boolean true source"
    annotation (Placement(transformation(extent={{-260,-130},{-240,-110}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=2)
    "Pump rotation index"
    annotation (Placement(transformation(extent={{240,-170},{260,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre8[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{260,-80},{280,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con29(
    final k=0.25)
    "Constant Real source"
    annotation (Placement(transformation(extent={{70,-170},{90,-150}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin13(
    final amplitude=0.5,
    final freqHz=1/900,
    final offset=0.25)
    "Sine signal"
    annotation (Placement(transformation(extent={{166,-152},{186,-132}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin15(
    final amplitude=0.1,
    final freqHz=1/3600,
    final offset=0.25)
    "Sine signal"
    annotation (Placement(transformation(extent={{100,-150},{120,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul11(
    final period=1800,
    final shift=10)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{100,-190},{120,-170}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt8(
    final k=2)
    "Pump rotation index"
    annotation (Placement(transformation(extent={{-160,-328},{-140,-308}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre9[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{-120,-250},{-100,-230}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con32(
    final k=0.25)
    "Constant Real source"
    annotation (Placement(transformation(extent={{-320,-330},{-300,-310}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin16(
    final amplitude=0.5,
    final freqHz=1/900,
    final offset=0)
    "Sine signal"
    annotation (Placement(transformation(extent={{-230,-312},{-210,-292}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin17(
    final amplitude=0.1,
    final freqHz=1/3600,
    final offset=0.25)
    "Sine signal"
    annotation (Placement(transformation(extent={{-290,-310},{-270,-290}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul13(
    final period=1800,
    final shift=10)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-290,-350},{-270,-330}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt9(
    final k=2)
    "Pump rotation index"
    annotation (Placement(transformation(extent={{240,-338},{260,-318}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre10[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{254,-250},{274,-230}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con35(
    final k=0.25)
    "Constant Real source"
    annotation (Placement(transformation(extent={{70,-340},{90,-320}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin18(
    final amplitude=1.5,
    final freqHz=1/3600,
    final phase(displayUnit="deg") = 3.1415926535898,
    final offset=0.25)
    "Sine signal"
    annotation (Placement(transformation(extent={{166,-322},{186,-302}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin19(
    final amplitude=0.1,
    final freqHz=1/3600,
    final offset=0.25)
    "Sine signal"
    annotation (Placement(transformation(extent={{100,-320},{120,-300}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul15(
    final period=1800,
    final shift=10)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{100,-360},{120,-340}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con37(
    final k=0.25)
    "Constant Real source"
    annotation (Placement(transformation(extent={{70,-380},{90,-360}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt10(
    final k=2)
    "Pump rotation index"
    annotation (Placement(transformation(extent={{-140,-488},{-120,-468}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre11[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{-120,-410},{-100,-390}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con39(
    final k=0.25)
    "Constant Real source"
    annotation (Placement(transformation(extent={{-310,-490},{-290,-470}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin20[2](
    final amplitude=fill(1.5, 2),
    final freqHz=fill(1/3600, 2),
    final phase=fill(3.14, 2),
    final offset=fill(1, 2),
    final startTime=fill(0, 2))
    "Sine signal"
    annotation (Placement(transformation(extent={{-214,-472},{-194,-452}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin21(
    final amplitude=0.1,
    final freqHz=1/3600,
    final offset=0.25)
    "Sine signal"
    annotation (Placement(transformation(extent={{-280,-470},{-260,-450}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul17(
    final period=1800,
    final shift=10)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-280,-510},{-260,-490}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con41(
    final k=1)
    "Constant Real source"
    annotation (Placement(transformation(extent={{-310,-530},{-290,-510}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt11(
    final k=2)
    "Pump rotation index"
    annotation (Placement(transformation(extent={{220,-518},{240,-498}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre12[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{248,-420},{268,-400}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin22(
    final amplitude=0.1,
    final freqHz=1/3600,
    final offset=0.25)
    "Sine signal"
    annotation (Placement(transformation(extent={{80,-500},{100,-480}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul19(
    final period=1800,
    final shift=10)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{80,-540},{100,-520}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha12
    "Change detector"
    annotation (Placement(transformation(extent={{-220,170},{-200,190}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha13
    "Change detector"
    annotation (Placement(transformation(extent={{140,150},{160,170}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha14
    "Change detector"
    annotation (Placement(transformation(extent={{-220,10},{-200,30}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha15
    "Change detector"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha16
    "Change detector"
    annotation (Placement(transformation(extent={{-230,-170},{-210,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha17
    "Change detector"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha18
    "Change detector"
    annotation (Placement(transformation(extent={{-260,-240},{-240,-220}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha19
    "Change detector"
    annotation (Placement(transformation(extent={{130,-220},{150,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha20
    "Change detector"
    annotation (Placement(transformation(extent={{-250,-380},{-230,-360}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha21
    "Change detector"
    annotation (Placement(transformation(extent={{110,-400},{130,-380}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Edge detector"
    annotation (Placement(transformation(extent={{180,-360},{200,-340}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg2
    "Edge detector"
    annotation (Placement(transformation(extent={{-210,-350},{-190,-330}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg3
    "Edge detector"
    annotation (Placement(transformation(extent={{-210,-510},{-190,-490}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg4
    "Edge detector"
    annotation (Placement(transformation(extent={{160,-540},{180,-520}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul[2](
    final amplitude=fill(1, 2),
    final width=fill(0.95, 2),
    final period=fill(3600, 2),
    final shift=fill(10, 2))
    "Real pulse signal"
    annotation (Placement(transformation(extent={{-336,408},{-316,428}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    final k=1)
    "Constant Real source"
    annotation (Placement(transformation(extent={{-270,360},{-250,380}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul1[2](
    final amplitude=fill(1, 2),
    final width=fill(0.95, 2),
    final period=fill(3600, 2),
    final shift=fill(10, 2))
    "Real pulse signal"
    annotation (Placement(transformation(extent={{0,400},{20,420}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(
    final k=1)
    "Constant Real source"
    annotation (Placement(transformation(extent={{80,380},{100,400}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul2[2](
    final amplitude=fill(1, 2),
    final width=fill(0.95, 2),
    final period=fill(3600, 2),
    final shift=fill(10, 2))
    "Real pulse signal"
    annotation (Placement(transformation(extent={{-330,260},{-310,280}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul3[2](
    final amplitude=fill(1, 2),
    final width=fill(0.95, 2),
    final period=fill(3600, 2),
    final shift=fill(10, 2))
    "Real pulse signal"
    annotation (Placement(transformation(extent={{10,240},{30,260}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul4[2](
    final amplitude=fill(1, 2),
    final width=fill(0.95, 2),
    final period=fill(3600, 2),
    final shift=fill(10, 2))
    "Real pulse signal"
    annotation (Placement(transformation(extent={{-330,100},{-310,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul5[2](
    final amplitude=fill(1, 2),
    final width=fill(0.95, 2),
    final period=fill(3600, 2),
    final shift=fill(10, 2))
    "Real pulse signal"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul6[2](
    final amplitude=fill(1, 2),
    final width=fill(0.95, 2),
    final period=fill(3600, 2),
    final shift=fill(10, 2))
    "Real pulse signal"
    annotation (Placement(transformation(extent={{-328,-80},{-308,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Logical Or"
    annotation (Placement(transformation(extent={{170,-80},{190,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Logical Or"
    annotation (Placement(transformation(extent={{-230,-220},{-210,-200}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol12(
    final trueHoldDuration=3300,
    final falseHoldDuration=0)
    "Hold boiler on signal"
    annotation (Placement(transformation(extent={{130,-280},{150,-260}})));

  Buildings.Controls.OBC.CDL.Logical.Or or3
    "Logical Or"
    annotation (Placement(transformation(extent={{170,-250},{190,-230}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol13(
    final trueHoldDuration=3300,
    final falseHoldDuration=0)
    "Hold boiler on signal"
    annotation (Placement(transformation(extent={{-250,-430},{-230,-410}})));

  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Logical Or"
    annotation (Placement(transformation(extent={{-210,-400},{-190,-380}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol14(
    final trueHoldDuration=3300,
    final falseHoldDuration=0)
    "Hold boiler on signal"
    annotation (Placement(transformation(extent={{110,-460},{130,-440}})));

  Buildings.Controls.OBC.CDL.Logical.Or or5
    "Logical Or"
    annotation (Placement(transformation(extent={{150,-430},{170,-410}})));

  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(
    final nin=2)
    "Sum of isolation valve positions"
    annotation (Placement(transformation(extent={{-300,440},{-280,460}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold lesThr(
    final t=0.05)
    "Check if isolation valves are closed"
    annotation (Placement(transformation(extent={{-260,440},{-240,460}})));

  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum1(
    final nin=2)
    "Sum of isolation valve positions"
    annotation (Placement(transformation(extent={{30,440},{50,460}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold lesThr1(
    final t=0.05)
    "Check if isolation valves are closed"
    annotation (Placement(transformation(extent={{70,440},{90,460}})));

  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum2(
    final nin=2)
    "Sum of isolation valve positions"
    annotation (Placement(transformation(extent={{-300,300},{-280,320}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold lesThr2(
    final t=0.05)
    "Check if isolation valves are closed"
    annotation (Placement(transformation(extent={{-270,300},{-250,320}})));

  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum3(
    final nin=2)
    "Sum of isolation valve positions"
    annotation (Placement(transformation(extent={{50,280},{70,300}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold lesThr3(
    final t=0.05)
    "Check if isolation valves are closed"
    annotation (Placement(transformation(extent={{80,280},{100,300}})));

  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum4(
    final nin=2)
    "Sum of isolation valve positions"
    annotation (Placement(transformation(extent={{-300,140},{-280,160}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold lesThr4(
    final t=0.05)
    "Check if isolation valves are closed"
    annotation (Placement(transformation(extent={{-270,140},{-250,160}})));

  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum5(
    final nin=2)
    "Sum of isolation valve positions"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold lesThr5(
    final t=0.05)
    "Check if isolation valves are closed"
    annotation (Placement(transformation(extent={{90,120},{110,140}})));

  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum6(
    final nin=2)
    "Sum of isolation valve positions"
    annotation (Placement(transformation(extent={{-300,-40},{-280,-20}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold lesThr6(
    final t=0.05)
    "Check if isolation valves are closed"
    annotation (Placement(transformation(extent={{-270,-40},{-250,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt12(
    final k=1)
    "Pump rotation index"
    annotation (Placement(transformation(extent={{240,-200},{260,-180}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt13(
    final k=1)
    "Pump rotation index"
    annotation (Placement(transformation(extent={{-160,-360},{-140,-340}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt14(
    final k=1)
    "Pump rotation index"
    annotation (Placement(transformation(extent={{240,-370},{260,-350}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt15(
    final k=1)
    "Pump rotation index"
    annotation (Placement(transformation(extent={{-140,-520},{-120,-500}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt16(
    final k=1)
    "Pump rotation index"
    annotation (Placement(transformation(extent={{220,-550},{240,-530}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha1
    "Change detector"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=10)
    "Signal delay for boiler-2 enable"
    annotation (Placement(transformation(extent={{-258,-314},{-238,-294}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha2
    "Change detector"
    annotation (Placement(transformation(extent={{-260,-210},{-240,-190}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=10)
    "Signal delay for boiler-2 enable"
    annotation (Placement(transformation(extent={{130,-320},{150,-300}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha3
    "Change detector"
    annotation (Placement(transformation(extent={{130,-254},{150,-234}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    final delayTime=10)
    "Signal delay for boiler-2 enable"
    annotation (Placement(transformation(extent={{-250,-470},{-230,-450}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha4
    "Change detector"
    annotation (Placement(transformation(extent={{-250,-404},{-230,-384}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel4(
    final delayTime=10)
    "Signal delay for boiler-2 enable"
    annotation (Placement(transformation(extent={{120,-540},{140,-520}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha5
    "Change detector"
    annotation (Placement(transformation(extent={{110,-430},{130,-410}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre13 "Logical pre block"
    annotation (Placement(transformation(extent={{112,150},{132,170}})));

equation
  connect(conInt.y, priPumCon.uPumLeaLag) annotation (Line(points={{-198,450},{
          -180,450},{-180,427.067},{-172,427.067}},
                                       color={255,127,0}));

  connect(priPumCon.yHotWatPum, pre1.u)
    annotation (Line(points={{-148,403.733},{-140,403.733},{-140,400},{-132,400}},
                                                     color={255,0,255}));

  connect(sin1.y, priPumCon.VHotWat_flow) annotation (Line(points={{-248,400},{
          -194,400},{-194,415.867},{-172,415.867}},          color={0,0,127}));

  connect(sin.y, priPumCon.dpHotWat_remote) annotation (Line(points={{-198,370},
          {-186,370},{-186,392.533},{-172,392.533}},
                                             color={0,0,127}));

  connect(conInt1.y, priPumCon1.uPumLeaLag) annotation (Line(points={{162,440},
          {180,440},{180,417.067},{188,417.067}},
                                         color={255,127,0}));

  connect(priPumCon1.yHotWatPum, pre2.u)
    annotation (Line(points={{212,393.733},{220,393.733},{220,390},{228,390}},
                                                   color={255,0,255}));

  connect(sin3.y, priPumCon1.VHotWat_flow) annotation (Line(points={{102,360},{
          142,360},{142,394},{166,394},{166,405.867},{188,405.867}},
                                                         color={0,0,127}));

  connect(sin2.y, priPumCon1.dpHotWat_remote) annotation (Line(points={{168,358},
          {174,358},{174,382.533},{188,382.533}},
                                          color={0,0,127}));

  connect(sin4.y, priPumCon1.dpHotWat_local) annotation (Line(points={{172,320},
          {184,320},{184,385.333},{188,385.333}},
                                          color={0,0,127}));

  connect(conInt2.y,priPumCon2. uPumLeaLag) annotation (Line(points={{-198,300},
          {-180,300},{-180,277.067},{-172,277.067}},
                                         color={255,127,0}));

  connect(con8.y,priPumCon2. uMinPriPumSpeCon) annotation (Line(points={{-288,
          200},{-180,200},{-180,236.933},{-172,236.933}},
                                          color={0,0,127}));

  connect(sin6.y,priPumCon2. VHotWat_flow) annotation (Line(points={{-258,220},
          {-256,220},{-256,238},{-218,238},{-218,254},{-194,254},{-194,265.867},
          {-172,265.867}},                               color={0,0,127}));

  connect(sin5.y, priPumCon2.VHotWatSec_flow) annotation (Line(points={{-192,
          218},{-184,218},{-184,234.133},{-172,234.133}},
                                             color={0,0,127}));

  connect(booPul1.y, priPumCon2.uStaUp) annotation (Line(points={{-258,180},{
          -254,180},{-254,248},{-180,248},{-180,260.267},{-172,260.267}},
                                                             color={255,0,255}));

  connect(booPul1.y, priPumCon2.uOnOff) annotation (Line(points={{-258,180},{
          -254,180},{-254,248},{-180,248},{-180,257.467},{-172,257.467}},
                                                             color={255,0,255}));

  connect(booPul1.y, priPumCon2.uBoiSta[2]) annotation (Line(points={{-258,180},
          {-254,180},{-254,248},{-180,248},{-180,264},{-172,264}}, color={255,0,
          255}));

  connect(con9.y, priPumCon2.uBoiSta[1]) annotation (Line(points={{-228,220},{
          -226,220},{-226,244},{-188,244},{-188,262.133},{-172,262.133}},
                                                             color={255,0,255}));

  connect(conInt3.y,priPumCon3. uPumLeaLag) annotation (Line(points={{162,280},
          {180,280},{180,257.067},{188,257.067}},
                                         color={255,127,0}));

  connect(con12.y, priPumCon3.uMinPriPumSpeCon) annotation (Line(points={{72,180},
          {180,180},{180,216.933},{188,216.933}},
                                          color={0,0,127}));

  connect(sin8.y,priPumCon3. VHotWat_flow) annotation (Line(points={{102,200},{
          104,200},{104,218},{142,218},{142,234},{166,234},{166,245.867},{188,
          245.867}},                                     color={0,0,127}));

  connect(booPul3.y, priPumCon3.uStaUp) annotation (Line(points={{102,160},{106,
          160},{106,228},{180,228},{180,240.267},{188,240.267}},
                                                         color={255,0,255}));

  connect(booPul3.y, priPumCon3.uOnOff) annotation (Line(points={{102,160},{106,
          160},{106,228},{180,228},{180,237.467},{188,237.467}},
                                                         color={255,0,255}));

  connect(booPul3.y, priPumCon3.uBoiSta[2]) annotation (Line(points={{102,160},{
          106,160},{106,228},{180,228},{180,244},{188,244}}, color={255,0,255}));

  connect(con13.y, priPumCon3.uBoiSta[1]) annotation (Line(points={{132,200},{
          134,200},{134,224},{172,224},{172,242.133},{188,242.133}},
                                                         color={255,0,255}));

  connect(sin7.y, priPumCon3.VHotWatDec_flow) annotation (Line(points={{162,198},
          {176,198},{176,211.333},{188,211.333}},
                                          color={0,0,127}));

  connect(conInt4.y,priPumCon4. uPumLeaLag) annotation (Line(points={{-198,140},
          {-180,140},{-180,117.067},{-172,117.067}},
                                         color={255,127,0}));

  connect(con16.y, priPumCon4.uMinPriPumSpeCon) annotation (Line(points={{-288,40},
          {-180,40},{-180,76.9333},{-172,76.9333}},
                                          color={0,0,127}));

  connect(sin10.y, priPumCon4.VHotWat_flow) annotation (Line(points={{-258,60},
          {-256,60},{-256,78},{-218,78},{-218,94},{-194,94},{-194,105.867},{
          -172,105.867}},
        color={0,0,127}));

  connect(booPul5.y, priPumCon4.uStaUp) annotation (Line(points={{-258,20},{
          -254,20},{-254,88},{-180,88},{-180,100.267},{-172,100.267}},
                                                        color={255,0,255}));

  connect(booPul5.y, priPumCon4.uOnOff) annotation (Line(points={{-258,20},{
          -254,20},{-254,88},{-180,88},{-180,97.4667},{-172,97.4667}},
                                                        color={255,0,255}));

  connect(booPul5.y, priPumCon4.uBoiSta[2]) annotation (Line(points={{-258,20},{
          -254,20},{-254,88},{-180,88},{-180,104},{-172,104}}, color={255,0,255}));

  connect(con17.y, priPumCon4.uBoiSta[1]) annotation (Line(points={{-228,60},{
          -226,60},{-226,84},{-188,84},{-188,102.133},{-172,102.133}},
                                                          color={255,0,255}));

  connect(sin9.y, priPumCon4.THotWatPri) annotation (Line(points={{-192,58},{
          -182,58},{-182,68.5333},{-172,68.5333}},
                                    color={0,0,127}));

  connect(con18.y, priPumCon4.THotWatSec) annotation (Line(points={{-288,0},{
          -224,0},{-224,38},{-176,38},{-176,65.7333},{-172,65.7333}},
                                   color={0,0,127}));

  connect(conInt5.y,priPumCon5. uPumLeaLag) annotation (Line(points={{162,120},
          {180,120},{180,97.0667},{188,97.0667}},
                                         color={255,127,0}));

  connect(con21.y, priPumCon5.uMinPriPumSpeCon) annotation (Line(points={{72,20},
          {180,20},{180,56.9333},{188,56.9333}},
                                       color={0,0,127}));

  connect(sin12.y, priPumCon5.VHotWat_flow) annotation (Line(points={{102,40},{
          104,40},{104,58},{142,58},{142,74},{166,74},{166,85.8667},{188,
          85.8667}},                                                  color={0,0,
          127}));

  connect(booPul7.y, priPumCon5.uStaUp) annotation (Line(points={{102,0},{106,0},
          {106,68},{180,68},{180,80.2667},{188,80.2667}},
                                                color={255,0,255}));

  connect(booPul7.y, priPumCon5.uOnOff) annotation (Line(points={{102,0},{106,0},
          {106,68},{180,68},{180,77.4667},{188,77.4667}},
                                                color={255,0,255}));

  connect(booPul7.y, priPumCon5.uBoiSta[2]) annotation (Line(points={{102,0},{106,
          0},{106,68},{180,68},{180,84},{188,84}}, color={255,0,255}));

  connect(con22.y, priPumCon5.uBoiSta[1]) annotation (Line(points={{132,40},{
          134,40},{134,64},{172,64},{172,82.1333},{188,82.1333}},
                                                    color={255,0,255}));

  connect(sin11.y, priPumCon5.THotWatBoiSup) annotation (Line(points={{172,40},
          {178,40},{178,42.9333},{188,42.9333}},
                                      color={0,0,127}));

  connect(con23.y, priPumCon5.THotWatSec) annotation (Line(points={{72,-20},{
          136,-20},{136,18},{184,18},{184,45.7333},{188,45.7333}},
                                   color={0,0,127}));

  connect(conInt6.y,priPumCon6. uPumLeaLag) annotation (Line(points={{-208,-40},
          {-190,-40},{-190,-62.9333},{-182,-62.9333}},
                                         color={255,127,0}));

  connect(sin14.y, priPumCon6.VHotWat_flow) annotation (Line(points={{-268,-120},
          {-266,-120},{-266,-102},{-228,-102},{-228,-86},{-204,-86},{-204,
          -74.1333},{-182,-74.1333}},
                      color={0,0,127}));

  connect(booPul9.y, priPumCon6.uStaUp) annotation (Line(points={{-268,-160},{
          -264,-160},{-264,-92},{-190,-92},{-190,-79.7333},{-182,-79.7333}},
                                                              color={255,0,255}));

  connect(booPul9.y, priPumCon6.uOnOff) annotation (Line(points={{-268,-160},{
          -264,-160},{-264,-92},{-190,-92},{-190,-82.5333},{-182,-82.5333}},
                                                              color={255,0,255}));

  connect(booPul9.y, priPumCon6.uBoiSta[2]) annotation (Line(points={{-268,-160},
          {-264,-160},{-264,-92},{-190,-92},{-190,-76},{-182,-76}}, color={255,0,
          255}));

  connect(con27.y, priPumCon6.uBoiSta[1]) annotation (Line(points={{-238,-120},
          {-236,-120},{-236,-96},{-198,-96},{-198,-77.8667},{-182,-77.8667}},
                                                                   color={255,0,
          255}));

  connect(con29.y, priPumCon7.uMinPriPumSpeCon) annotation (Line(points={{92,-160},
          {200,-160},{200,-123.067},{208,-123.067}},
                                             color={0,0,127}));

  connect(sin15.y, priPumCon7.VHotWat_flow) annotation (Line(points={{122,-140},
          {124,-140},{124,-122},{160,-122},{160,-106},{186,-106},{186,-94.1333},
          {208,-94.1333}},
                 color={0,0,127}));

  connect(sin13.y, priPumCon7.VHotWatSec_flow) annotation (Line(points={{188,
          -142},{198,-142},{198,-125.867},{208,-125.867}},
                                             color={0,0,127}));

  connect(con32.y, priPumCon8.uMinPriPumSpeCon) annotation (Line(points={{-298,
          -320},{-190,-320},{-190,-283.067},{-182,-283.067}},
                                                color={0,0,127}));

  connect(sin17.y, priPumCon8.VHotWat_flow) annotation (Line(points={{-268,-300},
          {-266,-300},{-266,-282},{-228,-282},{-228,-266},{-204,-266},{-204,
          -254.133},{-182,-254.133}},
                        color={0,0,127}));

  connect(sin16.y, priPumCon8.VHotWatDec_flow) annotation (Line(points={{-208,
          -302},{-194,-302},{-194,-288.667},{-182,-288.667}},
                                                color={0,0,127}));

  connect(con35.y, priPumCon9.uMinPriPumSpeCon) annotation (Line(points={{92,-330},
          {200,-330},{200,-293.067},{208,-293.067}},
                                             color={0,0,127}));

  connect(sin19.y, priPumCon9.VHotWat_flow) annotation (Line(points={{122,-310},
          {124,-310},{124,-292},{162,-292},{162,-276},{186,-276},{186,-264.133},
          {208,-264.133}},
                  color={0,0,127}));

  connect(sin18.y, priPumCon9.THotWatPri) annotation (Line(points={{188,-312},{
          198,-312},{198,-301.467},{208,-301.467}},
                                        color={0,0,127}));

  connect(con37.y, priPumCon9.THotWatSec) annotation (Line(points={{92,-370},{
          156,-370},{156,-332},{204,-332},{204,-304.267},{208,-304.267}},
                                        color={0,0,127}));

  connect(con39.y, priPumCon10.uMinPriPumSpeCon) annotation (Line(points={{-288,
          -480},{-180,-480},{-180,-443.067},{-172,-443.067}},
                                                      color={0,0,127}));

  connect(sin21.y, priPumCon10.VHotWat_flow) annotation (Line(points={{-258,
          -460},{-256,-460},{-256,-442},{-218,-442},{-218,-426},{-194,-426},{
          -194,-414.133},{-172,-414.133}},
                        color={0,0,127}));

  connect(sin20.y, priPumCon10.THotWatBoiSup) annotation (Line(points={{-192,
          -462},{-182,-462},{-182,-457.067},{-172,-457.067}},
                                                color={0,0,127}));

  connect(con41.y, priPumCon10.THotWatSec) annotation (Line(points={{-288,-520},
          {-224,-520},{-224,-482},{-174,-482},{-174,-454.267},{-172,-454.267}},
                                                color={0,0,127}));

  connect(sin22.y, priPumCon11.VHotWat_flow) annotation (Line(points={{102,-490},
          {104,-490},{104,-472},{142,-472},{142,-456},{166,-456},{166,-444.133},
          {188,-444.133}},
                  color={0,0,127}));

  connect(cha12.y, priPumCon2.uPumChaPro) annotation (Line(points={{-198,180},{
          -176,180},{-176,254.667},{-172,254.667}},
                                            color={255,0,255}));

  connect(cha13.y, priPumCon3.uPumChaPro) annotation (Line(points={{162,160},{
          184,160},{184,234.667},{188,234.667}},
                                         color={255,0,255}));

  connect(cha14.y, priPumCon4.uPumChaPro) annotation (Line(points={{-198,20},{
          -178,20},{-178,94.6667},{-172,94.6667}},
                                         color={255,0,255}));

  connect(cha15.y, priPumCon5.uPumChaPro) annotation (Line(points={{162,0},{182,
          0},{182,74.6667},{188,74.6667}},
                                 color={255,0,255}));

  connect(cha16.y, priPumCon6.uPumChaPro) annotation (Line(points={{-208,-160},
          {-186,-160},{-186,-85.3333},{-182,-85.3333}},
                                              color={255,0,255}));

  connect(booPul1.y, cha12.u)
    annotation (Line(points={{-258,180},{-222,180}}, color={255,0,255}));

  connect(booPul5.y, cha14.u)
    annotation (Line(points={{-258,20},{-222,20}}, color={255,0,255}));

  connect(booPul7.y, cha15.u)
    annotation (Line(points={{102,0},{138,0}}, color={255,0,255}));

  connect(booPul9.y, cha16.u)
    annotation (Line(points={{-268,-160},{-232,-160}}, color={255,0,255}));

  connect(booPul13.y, cha18.u)
    annotation (Line(points={{-268,-340},{-264,-340},{-264,-230},{-262,-230}},
                                                       color={255,0,255}));

  connect(booPul15.y, cha19.u)
    annotation (Line(points={{122,-350},{126,-350},{126,-210},{128,-210}},
                                                     color={255,0,255}));

  connect(booPul17.y, cha20.u)
    annotation (Line(points={{-258,-500},{-254,-500},{-254,-370},{-252,-370}},
                                                       color={255,0,255}));

  connect(booPul19.y, cha21.u)
    annotation (Line(points={{102,-530},{106,-530},{106,-390},{108,-390}},
                                                     color={255,0,255}));

  connect(booPul15.y, edg.u) annotation (Line(points={{122,-350},{126,-350},{
          126,-366},{170,-366},{170,-350},{178,-350}}, color={255,0,255}));

  connect(edg.y, priPumCon9.uStaUp) annotation (Line(points={{202,-350},{202,
          -269.733},{208,-269.733}},
                             color={255,0,255}));

  connect(edg.y, priPumCon9.uOnOff) annotation (Line(points={{202,-350},{202,
          -272.533},{208,-272.533}},
                             color={255,0,255}));

  connect(booPul13.y, edg2.u) annotation (Line(points={{-268,-340},{-264,-340},
          {-264,-354},{-214,-354},{-214,-340},{-212,-340}}, color={255,0,255}));

  connect(edg2.y, priPumCon8.uStaUp) annotation (Line(points={{-188,-340},{-186,
          -340},{-186,-259.733},{-182,-259.733}},
                                          color={255,0,255}));

  connect(edg2.y, priPumCon8.uOnOff) annotation (Line(points={{-188,-340},{-186,
          -340},{-186,-262.533},{-182,-262.533}},
                                          color={255,0,255}));

  connect(booPul17.y, edg3.u) annotation (Line(points={{-258,-500},{-254,-500},
          {-254,-514},{-214,-514},{-214,-500},{-212,-500}}, color={255,0,255}));

  connect(edg3.y, priPumCon10.uStaUp) annotation (Line(points={{-188,-500},{
          -178,-500},{-178,-419.733},{-172,-419.733}},
                                               color={255,0,255}));

  connect(edg3.y, priPumCon10.uOnOff) annotation (Line(points={{-188,-500},{
          -178,-500},{-178,-422.533},{-172,-422.533}},
                                               color={255,0,255}));

  connect(booPul19.y, edg4.u) annotation (Line(points={{102,-530},{106,-530},{
          106,-550},{150,-550},{150,-530},{158,-530}}, color={255,0,255}));

  connect(edg4.y, priPumCon11.uStaUp) annotation (Line(points={{182,-530},{186,
          -530},{186,-449.733},{188,-449.733}},
                                        color={255,0,255}));

  connect(edg4.y, priPumCon11.uOnOff) annotation (Line(points={{182,-530},{186,
          -530},{186,-452.533},{188,-452.533}},
                                        color={255,0,255}));

  connect(pul.y, priPumCon.uHotIsoVal) annotation (Line(points={{-314,418},{
          -244,418},{-244,418.667},{-172,418.667}},
                                            color={0,0,127}));

  connect(con1.y, priPumCon.dpHotWatSet) annotation (Line(points={{-248,370},{
          -234,370},{-234,389.733},{-172,389.733}},
                                            color={0,0,127}));

  connect(pre1.y, priPumCon.uHotWatPum) annotation (Line(points={{-108,400},{
          -100,400},{-100,440},{-190,440},{-190,424.267},{-172,424.267}},
                                                                  color={255,0,
          255}));

  connect(pre2.y, priPumCon1.uHotWatPum) annotation (Line(points={{252,390},{
          272,390},{272,460},{110,460},{110,414.267},{188,414.267}},
                                                             color={255,0,255}));

  connect(pul1.y, priPumCon1.uHotIsoVal) annotation (Line(points={{22,410},{116,
          410},{116,408.667},{188,408.667}},
                                     color={0,0,127}));

  connect(con3.y, priPumCon1.dpHotWatSet) annotation (Line(points={{102,390},{
          160,390},{160,379.733},{188,379.733}},
                                         color={0,0,127}));

  connect(pul2.y, priPumCon2.uHotIsoVal) annotation (Line(points={{-308,270},{
          -224,270},{-224,268.667},{-172,268.667}},
                                            color={0,0,127}));

  connect(pre3.y, priPumCon2.uHotWatPum) annotation (Line(points={{-88,250},{
          -86,250},{-86,320},{-240,320},{-240,274.267},{-172,274.267}},
                                                                color={255,0,
          255}));

  connect(pul3.y, priPumCon3.uHotIsoVal) annotation (Line(points={{32,250},{136,
          250},{136,248.667},{188,248.667}},
                                     color={0,0,127}));

  connect(pre4.y, priPumCon3.uHotWatPum) annotation (Line(points={{282,230},{
          290,230},{290,300},{130,300},{130,254.267},{188,254.267}},
                                                             color={255,0,255}));

  connect(pul4.y, priPumCon4.uHotIsoVal) annotation (Line(points={{-308,110},{
          -224,110},{-224,108.667},{-172,108.667}},
                                            color={0,0,127}));

  connect(pre5.y, priPumCon4.uHotWatPum) annotation (Line(points={{-76,110},{
          -70,110},{-70,160},{-230,160},{-230,114.267},{-172,114.267}},
                                                                 color={255,0,
          255}));

  connect(pre6.y, priPumCon5.uHotWatPum) annotation (Line(points={{262,100},{
          270,100},{270,140},{130,140},{130,94.2667},{188,94.2667}},
                                                      color={255,0,255}));

  connect(pul5.y, priPumCon5.uHotIsoVal) annotation (Line(points={{42,90},{136,
          90},{136,88.6667},{188,88.6667}},
                                  color={0,0,127}));

  connect(pre7.y, priPumCon6.uHotWatPum) annotation (Line(points={{-98,-60},{
          -90,-60},{-90,-20},{-240,-20},{-240,-65.7333},{-182,-65.7333}},
                                                                  color={255,0,
          255}));

  connect(pul6.y, priPumCon6.uHotIsoVal) annotation (Line(points={{-306,-70},{
          -220,-70},{-220,-71.3333},{-182,-71.3333}},
                                            color={0,0,127}));

  connect(pre8.y, priPumCon7.uHotWatPum) annotation (Line(points={{282,-70},{
          300,-70},{300,-32},{164,-32},{164,-86},{186,-86},{186,-85.7333},{208,
          -85.7333}},                                         color={255,0,255}));

  connect(pre9.y, priPumCon8.uHotWatPum) annotation (Line(points={{-98,-240},{
          -88,-240},{-88,-210},{-190,-210},{-190,-245.733},{-182,-245.733}},
                                                                       color={
          255,0,255}));

  connect(pre10.y, priPumCon9.uHotWatPum) annotation (Line(points={{276,-240},{
          280,-240},{280,-220},{200,-220},{200,-255.733},{208,-255.733}},
                                                                  color={255,0,
          255}));

  connect(pre11.y, priPumCon10.uHotWatPum) annotation (Line(points={{-98,-400},
          {-80,-400},{-80,-370},{-220,-370},{-220,-406},{-196,-406},{-196,
          -405.733},{-172,-405.733}},                                   color={
          255,0,255}));

  connect(pre12.y, priPumCon11.uHotWatPum) annotation (Line(points={{270,-410},
          {280,-410},{280,-392},{180,-392},{180,-436},{184,-436},{184,-435.733},
          {188,-435.733}},                                         color={255,0,
          255}));

  connect(conInt7.y, priPumCon7.uLasDisBoi) annotation (Line(points={{262,-160},
          {270,-160},{270,-140},{202,-140},{202,-111.867},{208,-111.867}},
                                            color={255,127,0}));

  connect(conInt8.y, priPumCon8.uLasDisBoi) annotation (Line(points={{-138,-318},
          {-130,-318},{-130,-300},{-188,-300},{-188,-271.867},{-182,-271.867}},
                                                color={255,127,0}));

  connect(conInt9.y, priPumCon9.uLasDisBoi) annotation (Line(points={{262,-328},
          {270,-328},{270,-314},{196,-314},{196,-281.867},{208,-281.867}},
                                             color={255,127,0}));

  connect(conInt10.y, priPumCon10.uLasDisBoi) annotation (Line(points={{-118,
          -478},{-110,-478},{-110,-460},{-176,-460},{-176,-431.867},{-172,
          -431.867}},                                 color={255,127,0}));

  connect(booPul11.y, truFalHol10.u) annotation (Line(points={{122,-180},{126,-180},
          {126,-100},{128,-100}}, color={255,0,255}));

  connect(truFalHol10.y, priPumCon7.uBoiSta[1]) annotation (Line(points={{152,
          -100},{192,-100},{192,-97.8667},{208,-97.8667}},
                                           color={255,0,255}));

  connect(booPul13.y, truFalHol11.u) annotation (Line(points={{-268,-340},{-264,
          -340},{-264,-260},{-262,-260}}, color={255,0,255}));

  connect(truFalHol11.y, priPumCon8.uBoiSta[1]) annotation (Line(points={{-238,
          -260},{-236,-260},{-236,-257.867},{-182,-257.867}},
                                                color={255,0,255}));

  connect(booPul15.y, truFalHol12.u) annotation (Line(points={{122,-350},{126,-350},
          {126,-270},{128,-270}}, color={255,0,255}));

  connect(truFalHol12.y, priPumCon9.uBoiSta[1]) annotation (Line(points={{152,
          -270},{160,-270},{160,-267.867},{208,-267.867}},
                                             color={255,0,255}));

  connect(booPul17.y, truFalHol13.u) annotation (Line(points={{-258,-500},{-254,
          -500},{-254,-420},{-252,-420}}, color={255,0,255}));

  connect(truFalHol13.y, priPumCon10.uBoiSta[1]) annotation (Line(points={{-228,
          -420},{-220,-420},{-220,-417.867},{-172,-417.867}},
                                                      color={255,0,255}));

  connect(booPul19.y, truFalHol14.u) annotation (Line(points={{102,-530},{106,-530},
          {106,-450},{108,-450}}, color={255,0,255}));

  connect(truFalHol14.y, priPumCon11.uBoiSta[1]) annotation (Line(points={{132,
          -450},{140,-450},{140,-447.867},{188,-447.867}},
                                             color={255,0,255}));

  connect(pul.y, mulSum.u[1:2]) annotation (Line(points={{-314,418},{-308,418},{
          -308,449},{-302,449}}, color={0,0,127}));

  connect(mulSum.y, lesThr.u)
    annotation (Line(points={{-278,450},{-262,450}}, color={0,0,127}));

  connect(lesThr.y, priPumCon.uPlaEna) annotation (Line(points={{-238,450},{
          -230,450},{-230,421.467},{-172,421.467}},
                                       color={255,0,255}));

  connect(mulSum1.y, lesThr1.u)
    annotation (Line(points={{52,450},{68,450}}, color={0,0,127}));

  connect(pul1.y, mulSum1.u[1:2]) annotation (Line(points={{22,410},{26,410},{26,
          449},{28,449}}, color={0,0,127}));

  connect(lesThr1.y, priPumCon1.uPlaEna) annotation (Line(points={{92,450},{100,
          450},{100,411.467},{188,411.467}},
                                     color={255,0,255}));

  connect(mulSum2.y, lesThr2.u)
    annotation (Line(points={{-278,310},{-272,310}}, color={0,0,127}));

  connect(pul2.y, mulSum2.u[1:2]) annotation (Line(points={{-308,270},{-304,270},
          {-304,309},{-302,309}}, color={0,0,127}));

  connect(lesThr2.y, priPumCon2.uPlaEna) annotation (Line(points={{-248,310},{
          -242,310},{-242,271.467},{-172,271.467}},
                                       color={255,0,255}));

  connect(mulSum3.y, lesThr3.u)
    annotation (Line(points={{72,290},{78,290}}, color={0,0,127}));

  connect(pul3.y, mulSum3.u[1:2]) annotation (Line(points={{32,250},{40,250},{40,
          289},{48,289}}, color={0,0,127}));

  connect(lesThr3.y, priPumCon3.uPlaEna) annotation (Line(points={{102,290},{
          120,290},{120,251.467},{188,251.467}},
                                     color={255,0,255}));

  connect(mulSum4.y, lesThr4.u)
    annotation (Line(points={{-278,150},{-272,150}}, color={0,0,127}));

  connect(pul4.y, mulSum4.u[1:2]) annotation (Line(points={{-308,110},{-304,110},
          {-304,149},{-302,149}}, color={0,0,127}));

  connect(lesThr4.y, priPumCon4.uPlaEna) annotation (Line(points={{-248,150},{
          -240,150},{-240,111.467},{-172,111.467}},
                                       color={255,0,255}));

  connect(mulSum5.y, lesThr5.u)
    annotation (Line(points={{82,130},{88,130}}, color={0,0,127}));

  connect(pul5.y, mulSum5.u[1:2]) annotation (Line(points={{42,90},{50,90},{50,129},
          {58,129}}, color={0,0,127}));

  connect(lesThr5.y, priPumCon5.uPlaEna) annotation (Line(points={{112,130},{
          120,130},{120,91.4667},{188,91.4667}},
                                   color={255,0,255}));

  connect(mulSum6.y, lesThr6.u)
    annotation (Line(points={{-278,-30},{-272,-30}}, color={0,0,127}));

  connect(pul6.y, mulSum6.u[1:2]) annotation (Line(points={{-306,-70},{-304,-70},
          {-304,-31},{-302,-31}}, color={0,0,127}));

  connect(lesThr6.y, priPumCon6.uPlaEna) annotation (Line(points={{-248,-30},{
          -244,-30},{-244,-68.5333},{-182,-68.5333}},
                                       color={255,0,255}));

  connect(conInt7.y, intSwi.u1) annotation (Line(points={{262,-160},{270,-160},
          {270,-168},{278,-168}},color={255,127,0}));

  connect(conInt12.y, intSwi.u3) annotation (Line(points={{262,-190},{270,-190},
          {270,-184},{278,-184}}, color={255,127,0}));

  connect(intSwi.y, priPumCon7.uNexEnaBoi) annotation (Line(points={{302,-176},
          {310,-176},{310,-144},{194,-144},{194,-108.133},{208,-108.133}},color=
         {255,127,0}));

  connect(conInt13.y, intSwi1.u3) annotation (Line(points={{-138,-350},{-130,-350},
          {-130,-338},{-122,-338}}, color={255,127,0}));

  connect(conInt14.y, intSwi2.u3) annotation (Line(points={{262,-360},{264,-360},
          {264,-348},{278,-348}}, color={255,127,0}));

  connect(conInt15.y, intSwi3.u3) annotation (Line(points={{-118,-510},{-110,-510},
          {-110,-498},{-102,-498}}, color={255,127,0}));

  connect(conInt16.y, intSwi4.u3) annotation (Line(points={{242,-540},{250,-540},
          {250,-528},{258,-528}}, color={255,127,0}));

  connect(conInt8.y, intSwi1.u1) annotation (Line(points={{-138,-318},{-130,
          -318},{-130,-322},{-122,-322}},
                                    color={255,127,0}));

  connect(intSwi1.y, priPumCon8.uNexEnaBoi) annotation (Line(points={{-98,-330},
          {-90,-330},{-90,-302},{-192,-302},{-192,-268.133},{-182,-268.133}},
        color={255,127,0}));

  connect(intSwi2.u1, conInt9.y) annotation (Line(points={{278,-332},{270,-332},
          {270,-328},{262,-328}}, color={255,127,0}));

  connect(intSwi2.y, priPumCon9.uNexEnaBoi) annotation (Line(points={{302,-340},
          {308,-340},{308,-310},{192,-310},{192,-278.133},{208,-278.133}},
        color={255,127,0}));

  connect(conInt10.y, intSwi3.u1) annotation (Line(points={{-118,-478},{-110,
          -478},{-110,-482},{-102,-482}},
                                    color={255,127,0}));

  connect(intSwi3.y, priPumCon10.uNexEnaBoi) annotation (Line(points={{-78,-490},
          {-70,-490},{-70,-464},{-184,-464},{-184,-428.133},{-172,-428.133}},
        color={255,127,0}));

  connect(conInt11.y, intSwi4.u1) annotation (Line(points={{242,-508},{250,-508},
          {250,-512},{258,-512}}, color={255,127,0}));

  connect(intSwi4.y, priPumCon11.uNexEnaBoi) annotation (Line(points={{282,-520},
          {292,-520},{292,-492},{176,-492},{176,-458.133},{188,-458.133}},
        color={255,127,0}));

  connect(conInt11.y, priPumCon11.uLasDisBoi) annotation (Line(points={{242,
          -508},{250,-508},{250,-494},{182,-494},{182,-461.867},{188,-461.867}},
        color={255,127,0}));

  connect(booPul11.y, truDel.u) annotation (Line(points={{122,-180},{126,-180},{
          126,-140},{128,-140}}, color={255,0,255}));

  connect(truDel.y, priPumCon7.uBoiSta[2]) annotation (Line(points={{152,-140},{
          156,-140},{156,-96},{208,-96}},  color={255,0,255}));

  connect(truFalHol10.y, priPumCon7.uPlaEna) annotation (Line(points={{152,-100},
          {180,-100},{180,-88.5333},{208,-88.5333}}, color={255,0,255}));

  connect(truDel.y, intSwi.u2) annotation (Line(points={{152,-140},{156,-140},{
          156,-164},{234,-164},{234,-176},{278,-176}}, color={255,0,255}));

  connect(booPul11.y, cha1.u) annotation (Line(points={{122,-180},{126,-180},{
          126,-86},{108,-86},{108,-70},{118,-70}}, color={255,0,255}));

  connect(truDel.y, cha17.u) annotation (Line(points={{152,-140},{156,-140},{
          156,-82},{112,-82},{112,-40},{118,-40}}, color={255,0,255}));

  connect(cha1.y, or2.u1)
    annotation (Line(points={{142,-70},{168,-70}}, color={255,0,255}));

  connect(cha17.y, or2.u2) annotation (Line(points={{142,-40},{160,-40},{160,
          -78},{168,-78}}, color={255,0,255}));

  connect(or2.y, priPumCon7.uPumChaPro) annotation (Line(points={{192,-70},{198,
          -70},{198,-105.333},{208,-105.333}}, color={255,0,255}));

  connect(truFalHol11.y, priPumCon8.uPlaEna) annotation (Line(points={{-238,
          -260},{-236,-260},{-236,-248.533},{-182,-248.533}}, color={255,0,255}));

  connect(booPul13.y, truDel1.u) annotation (Line(points={{-268,-340},{-264,
          -340},{-264,-304},{-260,-304}}, color={255,0,255}));

  connect(cha2.y, or1.u1) annotation (Line(points={{-238,-200},{-236,-200},{
          -236,-210},{-232,-210}}, color={255,0,255}));

  connect(cha18.y, or1.u2) annotation (Line(points={{-238,-230},{-236,-230},{
          -236,-218},{-232,-218}}, color={255,0,255}));

  connect(truDel1.y, cha2.u) annotation (Line(points={{-236,-304},{-234,-304},{
          -234,-280},{-270,-280},{-270,-200},{-262,-200}}, color={255,0,255}));

  connect(or1.y, priPumCon8.uPumChaPro) annotation (Line(points={{-208,-210},{
          -200,-210},{-200,-265.333},{-182,-265.333}}, color={255,0,255}));

  connect(truDel1.y, intSwi1.u2) annotation (Line(points={{-236,-304},{-234,
          -304},{-234,-324},{-166,-324},{-166,-330},{-122,-330}}, color={255,0,
          255}));
  connect(truDel1.y, priPumCon8.uBoiSta[2]) annotation (Line(points={{-236,-304},
          {-234,-304},{-234,-270},{-194,-270},{-194,-256},{-182,-256}}, color={
          255,0,255}));
  connect(booPul15.y, truDel2.u) annotation (Line(points={{122,-350},{126,-350},
          {126,-310},{128,-310}}, color={255,0,255}));

  connect(truFalHol12.y, priPumCon9.uPlaEna) annotation (Line(points={{152,-270},
          {160,-270},{160,-258.533},{208,-258.533}}, color={255,0,255}));

  connect(or3.y, priPumCon9.uPumChaPro) annotation (Line(points={{192,-240},{
          196,-240},{196,-275.333},{208,-275.333}}, color={255,0,255}));

  connect(cha19.y, or3.u1) annotation (Line(points={{152,-210},{160,-210},{160,
          -240},{168,-240}}, color={255,0,255}));

  connect(truDel2.y, priPumCon9.uBoiSta[2]) annotation (Line(points={{152,-310},
          {158,-310},{158,-266},{208,-266}}, color={255,0,255}));

  connect(truDel2.y, cha3.u) annotation (Line(points={{152,-310},{158,-310},{
          158,-286},{120,-286},{120,-244},{128,-244}}, color={255,0,255}));

  connect(cha3.y, or3.u2) annotation (Line(points={{152,-244},{160,-244},{160,
          -248},{168,-248}}, color={255,0,255}));

  connect(booPul17.y, truDel3.u) annotation (Line(points={{-258,-500},{-254,
          -500},{-254,-460},{-252,-460}}, color={255,0,255}));

  connect(cha20.y, or4.u1) annotation (Line(points={{-228,-370},{-224,-370},{
          -224,-390},{-212,-390}}, color={255,0,255}));

  connect(cha4.y, or4.u2) annotation (Line(points={{-228,-394},{-220,-394},{
          -220,-398},{-212,-398}}, color={255,0,255}));

  connect(truDel3.y, priPumCon10.uBoiSta[2]) annotation (Line(points={{-228,-460},
          {-222,-460},{-222,-416},{-172,-416}},       color={255,0,255}));

  connect(truDel3.y, cha4.u) annotation (Line(points={{-228,-460},{-222,-460},{
          -222,-406},{-260,-406},{-260,-394},{-252,-394}}, color={255,0,255}));

  connect(or4.y, priPumCon10.uPumChaPro) annotation (Line(points={{-188,-390},{
          -180,-390},{-180,-425.333},{-172,-425.333}}, color={255,0,255}));

  connect(truFalHol13.y, priPumCon10.uPlaEna) annotation (Line(points={{-228,
          -420},{-220,-420},{-220,-408.533},{-172,-408.533}}, color={255,0,255}));

  connect(truDel2.y, intSwi2.u2) annotation (Line(points={{152,-310},{158,-310},
          {158,-334},{238,-334},{238,-340},{278,-340}}, color={255,0,255}));

  connect(truDel3.y, intSwi3.u2) annotation (Line(points={{-228,-460},{-222,
          -460},{-222,-484},{-144,-484},{-144,-490},{-102,-490}}, color={255,0,
          255}));
  connect(truFalHol14.y, priPumCon11.uPlaEna) annotation (Line(points={{132,
          -450},{140,-450},{140,-438.533},{188,-438.533}}, color={255,0,255}));

  connect(booPul19.y, truDel4.u)
    annotation (Line(points={{102,-530},{118,-530}}, color={255,0,255}));

  connect(or5.y, priPumCon11.uPumChaPro) annotation (Line(points={{172,-420},{
          176,-420},{176,-455.333},{188,-455.333}}, color={255,0,255}));

  connect(truDel4.y, priPumCon11.uBoiSta[2]) annotation (Line(points={{142,-530},
          {146,-530},{146,-446},{188,-446}}, color={255,0,255}));

  connect(truDel4.y, intSwi4.u2) annotation (Line(points={{142,-530},{146,-530},
          {146,-500},{200,-500},{200,-520},{258,-520}}, color={255,0,255}));

  connect(cha21.y, or5.u1) annotation (Line(points={{132,-390},{140,-390},{140,
          -420},{148,-420}}, color={255,0,255}));

  connect(cha5.y, or5.u2) annotation (Line(points={{132,-420},{138,-420},{138,
          -428},{148,-428}}, color={255,0,255}));

  connect(truDel4.y, cha5.u) annotation (Line(points={{142,-530},{146,-530},{
          146,-432},{100,-432},{100,-420},{108,-420}}, color={255,0,255}));

  connect(cha.y, mulOr.u[1:2]) annotation (Line(points={{-88,220},{-84,220},{
          -84,216.5},{-80,216.5}},
                               color={255,0,255}));
  connect(mulOr.y, truFalHol.u)
    annotation (Line(points={{-56,220},{-52,220}}, color={255,0,255}));
  connect(cha6.y, mulOr1.u[1:2]) annotation (Line(points={{242,200},{244,200},{244,
          196.5},{248,196.5}}, color={255,0,255}));
  connect(mulOr1.y, truFalHol1.u)
    annotation (Line(points={{272,200},{278,200}}, color={255,0,255}));
  connect(cha8.y, mulOr3.u[1:2]) annotation (Line(points={{262,70},{264,70},{
          264,66.5},{268,66.5}}, color={255,0,255}));
  connect(cha9.y, mulOr4.u[1:2]) annotation (Line(points={{-98,-90},{-96,-90},{
          -96,-93.5},{-92,-93.5}},    color={255,0,255}));
  connect(cha10.y, mulOr5.u[1:2]) annotation (Line(points={{282,-100},{284,-100},
          {284,-103.5},{288,-103.5}}, color={255,0,255}));
  connect(cha11.y, mulOr6.u[1:2]) annotation (Line(points={{-98,-270},{-94,-270},
          {-94,-273.5},{-92,-273.5}},         color={255,0,255}));
  connect(cha22.y, mulOr7.u[1:2]) annotation (Line(points={{284,-280},{278,-280},
          {278,-283.5},{290,-283.5}}, color={255,0,255}));
  connect(cha23.y, mulOr8.u[1:2]) annotation (Line(points={{-98,-430},{-96,-430},
          {-96,-433.5},{-92,-433.5}},         color={255,0,255}));
  connect(cha24.y, mulOr9.u[1:2]) annotation (Line(points={{270,-440},{272,-440},
          {272,-443.5},{276,-443.5}}, color={255,0,255}));
  connect(mulOr2.y, truFalHol2.u)
    annotation (Line(points={{-46,70},{-44,70},{-44,90},{-40,90}},
                                                 color={255,0,255}));
  connect(mulOr3.y, truFalHol3.u)
    annotation (Line(points={{292,70},{298,70}}, color={255,0,255}));
  connect(mulOr4.y, truFalHol4.u)
    annotation (Line(points={{-68,-90},{-62,-90}}, color={255,0,255}));
  connect(mulOr5.y, truFalHol5.u)
    annotation (Line(points={{312,-100},{318,-100}}, color={255,0,255}));
  connect(mulOr6.y, truFalHol6.u)
    annotation (Line(points={{-68,-270},{-62,-270}}, color={255,0,255}));
  connect(mulOr7.y, truFalHol7.u)
    annotation (Line(points={{314,-280},{320,-280}}, color={255,0,255}));
  connect(mulOr8.y, truFalHol8.u)
    annotation (Line(points={{-68,-430},{-62,-430}}, color={255,0,255}));
  connect(mulOr9.y, truFalHol9.u)
    annotation (Line(points={{300,-440},{306,-440}}, color={255,0,255}));
  connect(priPumCon2.yHotWatPum, truDel5.u) annotation (Line(points={{-148,
          253.733},{-146,253.733},{-146,250},{-142,250}},
                                               color={255,0,255}));
  connect(truDel5.y, pre3.u)
    annotation (Line(points={{-118,250},{-112,250}}, color={255,0,255}));
  connect(truDel5.y, cha.u) annotation (Line(points={{-118,250},{-116,250},{
          -116,220},{-112,220}}, color={255,0,255}));
  connect(cha7.y, mulOr2.u[1:2]) annotation (Line(points={{-76,70},{-74,70},{
          -74,66.5},{-70,66.5}}, color={255,0,255}));
  connect(cha13.u, pre13.y)
    annotation (Line(points={{138,160},{134,160}}, color={255,0,255}));
  connect(booPul3.y, pre13.u)
    annotation (Line(points={{102,160},{110,160}}, color={255,0,255}));
  connect(truDel6.u, priPumCon3.yHotWatPum) annotation (Line(points={{222,230},
          {218,230},{218,233.733},{212,233.733}}, color={255,0,255}));
  connect(truDel6.y, pre4.u)
    annotation (Line(points={{246,230},{258,230}}, color={255,0,255}));
  connect(truDel6.y, cha6.u) annotation (Line(points={{246,230},{252,230},{252,
          214},{214,214},{214,200},{218,200}}, color={255,0,255}));
  connect(priPumCon4.yHotWatPum, truDel7.u) annotation (Line(points={{-148,
          93.7333},{-147,93.7333},{-147,90},{-142,90}}, color={255,0,255}));
  connect(truDel7.y, pre5.u) annotation (Line(points={{-118,90},{-108,90},{-108,
          110},{-100,110}}, color={255,0,255}));
  connect(truDel7.y, cha7.u) annotation (Line(points={{-118,90},{-108,90},{-108,
          70},{-100,70}}, color={255,0,255}));
  connect(priPumCon5.yHotWatPum, truDel8.u) annotation (Line(points={{212,
          73.7333},{214,73.7333},{214,74}}, color={255,0,255}));
  connect(truDel8.y, pre6.u)
    annotation (Line(points={{238,74},{238,100}}, color={255,0,255}));
  connect(truDel8.y, cha8.u)
    annotation (Line(points={{238,74},{238,70}}, color={255,0,255}));
  connect(priPumCon6.yHotWatPum, truDel9.u) annotation (Line(points={{-158,
          -86.2667},{-156,-86.2667},{-156,-90},{-154,-90}}, color={255,0,255}));
  connect(truDel9.y, cha9.u) annotation (Line(points={{-130,-90},{-122,-90},{
          -122,-90}}, color={255,0,255}));
  connect(truDel9.y, pre7.u) annotation (Line(points={{-130,-90},{-128,-90},{
          -128,-60},{-122,-60}}, color={255,0,255}));
  connect(booPul11.y, priPumCon7.uStaUp) annotation (Line(points={{122,-180},{
          204,-180},{204,-99.7333},{208,-99.7333}}, color={255,0,255}));
  connect(booPul11.y, priPumCon7.uOnOff) annotation (Line(points={{122,-180},{
          204,-180},{204,-102.533},{208,-102.533}}, color={255,0,255}));
  connect(priPumCon7.yHotWatPum, truDel10.u) annotation (Line(points={{232,
          -106.267},{234,-106.267},{234,-106}}, color={255,0,255}));
  connect(truDel10.y, pre8.u)
    annotation (Line(points={{258,-106},{258,-70}}, color={255,0,255}));
  connect(truDel10.y, cha10.u)
    annotation (Line(points={{258,-106},{258,-100}}, color={255,0,255}));
  connect(priPumCon8.yHotWatPum, truDel11.u) annotation (Line(points={{-158,
          -266.267},{-156,-266.267},{-156,-268},{-154,-268}}, color={255,0,255}));
  connect(truDel11.y, cha11.u) annotation (Line(points={{-130,-268},{-128,-268},
          {-128,-272},{-122,-272},{-122,-270}}, color={255,0,255}));
  connect(truDel11.y, pre9.u) annotation (Line(points={{-130,-268},{-126,-268},
          {-126,-240},{-122,-240}}, color={255,0,255}));
  connect(priPumCon9.yHotWatPum, truDel12.u) annotation (Line(points={{232,
          -276.267},{234,-276.267},{234,-276}}, color={255,0,255}));
  connect(truDel12.y, cha22.u) annotation (Line(points={{258,-276},{260,-276},{
          260,-280},{260,-280}}, color={255,0,255}));
  connect(truDel12.y, pre10.u) annotation (Line(points={{258,-276},{256,-276},{
          256,-240},{252,-240}}, color={255,0,255}));
  connect(priPumCon10.yHotWatPum, truDel13.u) annotation (Line(points={{-148,
          -426.267},{-148,-425.133},{-146,-425.133},{-146,-424}}, color={255,0,
          255}));
  connect(truDel13.y, cha23.u) annotation (Line(points={{-122,-424},{-122,-430},
          {-122,-430}}, color={255,0,255}));
  connect(truDel13.y, pre11.u) annotation (Line(points={{-122,-424},{-122,-400},
          {-122,-400}}, color={255,0,255}));
  connect(priPumCon11.yHotWatPum, truDel14.u) annotation (Line(points={{212,
          -456.267},{214,-456.267},{214,-456},{216,-456}}, color={255,0,255}));
  connect(truDel14.y, pre12.u) annotation (Line(points={{240,-456},{244,-456},{
          244,-410},{246,-410}}, color={255,0,255}));
  connect(truDel14.y, cha24.u) annotation (Line(points={{240,-456},{244,-456},{
          244,-440},{246,-440}}, color={255,0,255}));
annotation (
  experiment(
      StopTime=3600,
      Interval=0.5,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Pumps/PrimaryPumps/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 21, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-340,-560},{340,480}})));
end Controller;
