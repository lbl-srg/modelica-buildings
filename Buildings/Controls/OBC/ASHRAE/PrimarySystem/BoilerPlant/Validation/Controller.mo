within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Validation;
model Controller
    "Validation model for boiler plant control sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller controller(
    final have_priOnl=true,
    final nBoi=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final nSta=3,
    final staMat=[1,0; 0,1; 1,1],
    final nSenPri=1,
    final nPumPri_nominal=2,
    final nPumSec=0,
    final nSenSec=0,
    final nPumSec_nominal=0,
    final VHotWatPri_flow_nominal=0.0006,
    final maxLocDpPri=4100,
    final minLocDpPri=3900,
    final VHotWatSec_flow_nominal=0,
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
    annotation (Placement(transformation(extent={{-140,-30},{-120,14}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller controller1(
    final have_priOnl=false,
    final have_secFloSen=true,
    final have_varSecPum=true,
    final nBoi=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final nSta=3,
    final staMat=[1,0; 0,1; 1,1],
    final nSenPri=1,
    final nPumPri_nominal=2,
    final nPumSec=2,
    final nSenSec=1,
    final nPumSec_nominal=2,
    final VHotWatPri_flow_nominal=0.0006,
    final maxLocDpPri=4100,
    final minLocDpPri=3900,
    final VHotWatSec_flow_nominal=0.0004,
    final maxLocDpSec=4100,
    final minLocDpSec=3900,
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
    final minPriPumSpeSta={0,0,0},
    final speConTypSec=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes.remoteDP)
    "Test scenario for primary-secondary boiler plants with headered variable speed primary pumps"
    annotation (Placement(transformation(extent={{0,-30},{20,14}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller controller2(
    final have_priOnl=false,
    final have_secFloSen=true,
    final have_varSecPum=true,
    final nBoi=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final nSta=3,
    final staMat=[1,0; 0,1; 1,1],
    final nSenPri=1,
    final nPumPri_nominal=2,
    final nPumSec=2,
    final nSenSec=1,
    final nPumSec_nominal=2,
    final VHotWatPri_flow_nominal=0.0006,
    final maxLocDpPri=4100,
    final minLocDpPri=3900,
    final VHotWatSec_flow_nominal=0.0004,
    final maxLocDpSec=4100,
    final minLocDpSec=3900,
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
    final minPriPumSpeSta={0,0,0},
    final speConTypSec=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes.remoteDP)
    "Test scenario for primary-secondary boiler plants with dedicated variable speed primary pumps"
    annotation (Placement(transformation(extent={{160,-30},{180,14}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut(
    final k=290)
    "Measured outdoor air drybulb temperature"
    annotation (Placement(transformation(extent={{-220,20},{-200,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSup(
    final k=340)
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-220,-10},{-200,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TRet(
    final k=335)
    "Measured hot water return temperature"
    annotation (Placement(transformation(extent={{-220,-40},{-200,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VHotWat_flow[4](
    final k={6e-5,9e-5,20e-5,0.0004})
    "Measured hot water volume flowrate in primary loop"
    annotation (Placement(transformation(extent={{-220,-70},{-200,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dPHotWat[1](
    final k={4000})
    "Measured differential pressure between hot water supply and return in primary loop"
    annotation (Placement(transformation(extent={{-220,-100},{-200,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uBoiAva[2](
    final k={true,true})
    "Boiler availability status vector"
    annotation (Placement(transformation(extent={{-220,-130},{-200,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    final amplitude=2,
    final freqHz=1/14400)
    "Sine input"
    annotation (Placement(transformation(extent={{-220,50},{-200,70}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut1(
    final k=290)
    "Measured outdoor air drybulb temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSup1(
    final k=340)
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TRet1(
    final k=335)
    "Measured hot water return temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VHotWat_flow1[4](
    final k={6e-5,9e-5,20e-5,0.00029})
    "Measured hot water volume flowrate in primary loop"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dPHotWat1[1](
    final k={4000})
    "Measured differential pressure between hot water supply and return in secondary loop"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uBoiAva1[2](
    final k={true,true})
    "Boiler availability status vector"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin1(
    final amplitude=2, final freqHz=1/14400)
    "Sine input"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VHotWatSec_flow(
    final k=0.0003)
    "Measured hot water volume flowrate in secondary loop"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut2(
    final k=290)
    "Measured outdoor air drybulb temperature"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSup2(
    final k=340)
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TRet2(
    final k=335)
    "Measured hot water return temperature"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VHotWat_flow2[4](
    final k={6e-5,9e-5,20e-5,0.00029})
    "Measured hot water volume flowrate in primary loop"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dPHotWat2[1](
    final k={4000})
    "Measured differential pressure between hot water supply and return in secondary loop"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uBoiAva2[2](
    final k={true,true})
    "Boiler availability status vector"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin2(
    final amplitude=2,
    final freqHz=1/14400)
    "Sine input"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{120,50},{140,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VHotWatSec_flow1(
    final k=0.0003)
    "Measured hot water volume flowrate in secondary loop"
    annotation (Placement(transformation(extent={{80,-170},{100,-150}})));

equation
  connect(TOut.y, controller.TOut) annotation (Line(points={{-198,30},{-172,30},
          {-172,10},{-142,10}},       color={0,0,127}));

  connect(uBoiAva.y, controller.uBoiAva) annotation (Line(points={{-198,-120},{-168,
          -120},{-168,-8},{-142,-8}},            color={255,0,255}));

  connect(TSup.y, controller.TSupPri) annotation (Line(points={{-198,0},{-190,0},
          {-190,7},{-142,7}},          color={0,0,127}));

  connect(TRet.y, controller.TRetPri) annotation (Line(points={{-198,-30},{-180,
          -30},{-180,4},{-142,4}},     color={0,0,127}));

  connect(dPHotWat.y, controller.dpHotWatPri_rem) annotation (Line(points={{-198,
          -90},{-174,-90},{-174,-5},{-142,-5}}, color={0,0,127}));

  connect(VHotWat_flow[4].y, controller.VHotWatPri_flow) annotation (Line(
        points={{-198,-60},{-178,-60},{-178,1},{-142,1}},   color={0,0,127}));

  connect(sin.y, reaToInt.u)
    annotation (Line(points={{-198,60},{-182,60}},   color={0,0,127}));

  connect(reaToInt.y, controller.supResReq) annotation (Line(points={{-158,60},{
          -150,60},{-150,13},{-142,13}},     color={255,127,0}));

  connect(TOut1.y, controller1.TOut) annotation (Line(points={{-58,30},{-32,30},
          {-32,10},{-2,10}},   color={0,0,127}));

  connect(uBoiAva1.y, controller1.uBoiAva) annotation (Line(points={{-58,-120},{
          -28,-120},{-28,-8},{-2,-8}},
                                  color={255,0,255}));

  connect(TSup1.y, controller1.TSupPri) annotation (Line(points={{-58,0},{-50,0},
          {-50,7},{-2,7}},          color={0,0,127}));

  connect(TRet1.y, controller1.TRetPri) annotation (Line(points={{-58,-30},{-40,
          -30},{-40,4},{-2,4}},     color={0,0,127}));

  connect(VHotWat_flow1[4].y, controller1.VHotWatPri_flow) annotation (Line(
        points={{-58,-60},{-38,-60},{-38,1},{-2,1}},   color={0,0,127}));

  connect(sin1.y, reaToInt1.u)
    annotation (Line(points={{-58,60},{-42,60}},   color={0,0,127}));

  connect(reaToInt1.y, controller1.supResReq) annotation (Line(points={{-18,60},
          {-10,60},{-10,13},{-2,13}}, color={255,127,0}));

  connect(VHotWatSec_flow.y, controller1.VHotWatSec_flow) annotation (Line(
        points={{-58,-160},{-20,-160},{-20,-11},{-2,-11}},
                                                     color={0,0,127}));

  connect(dPHotWat1.y, controller1.dpHotWatSec_rem) annotation (Line(points={{-58,-90},
          {-10,-90},{-10,-23},{-2,-23}},  color={0,0,127}));

  connect(TRet1.y, controller1.TRetSec) annotation (Line(points={{-58,-30},{-40,
          -30},{-40,-2},{-2,-2}},   color={0,0,127}));

  connect(TOut2.y,controller2. TOut) annotation (Line(points={{102,30},{128,30},
          {128,10},{158,10}},  color={0,0,127}));

  connect(uBoiAva2.y,controller2. uBoiAva) annotation (Line(points={{102,-120},{
          132,-120},{132,-8},{158,-8}},
                                  color={255,0,255}));

  connect(TSup2.y,controller2. TSupPri) annotation (Line(points={{102,0},{110,0},
          {110,7},{158,7}},         color={0,0,127}));

  connect(TRet2.y,controller2. TRetPri) annotation (Line(points={{102,-30},{120,
          -30},{120,4},{158,4}},    color={0,0,127}));

  connect(VHotWat_flow2[4].y,controller2. VHotWatPri_flow) annotation (Line(
        points={{102,-60},{122,-60},{122,1},{158,1}},  color={0,0,127}));

  connect(sin2.y,reaToInt2. u)
    annotation (Line(points={{102,60},{118,60}},   color={0,0,127}));

  connect(reaToInt2.y,controller2. supResReq) annotation (Line(points={{142,60},
          {150,60},{150,13},{158,13}},color={255,127,0}));

  connect(VHotWatSec_flow1.y, controller2.VHotWatSec_flow) annotation (Line(
        points={{102,-160},{140,-160},{140,-11},{158,-11}},
                                                          color={0,0,127}));

  connect(dPHotWat2.y,controller2. dpHotWatSec_rem) annotation (Line(points={{102,-90},
          {150,-90},{150,-23},{158,-23}}, color={0,0,127}));

  connect(TRet2.y,controller2. TRetSec) annotation (Line(points={{102,-30},{120,
          -30},{120,-2},{158,-2}},  color={0,0,127}));

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
      preserveAspectRatio=false, extent={{-240,-240},{240,240}})),
    experiment(
      StopTime=7500,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
      __Dymola_Commands(file="./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Validation/Controller.mos"
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
end Controller;
