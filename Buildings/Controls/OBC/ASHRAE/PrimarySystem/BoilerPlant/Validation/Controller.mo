within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Validation;
model Controller "Validation model for boiler plant control sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller controller(primaryOnly=true,
    nBoi=2,
    boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    nSta=3,
    staMat=[1,0; 0,1; 1,1],
    iniSta=0,
    boiDesCap={15000*0.8,15000*0.8},
    boiFirMin={0.2,0.3},
    minFloSet={0.2*0.0003,0.3*0.0003},
    maxFloSet={0.0003,0.0003},
    bypSetRat=0.00001,
    nPumPri=2,
    isHeadered=true,
    TMinSupNonConBoi = 333.2,
    variablePrimary=true,
    nSen_remoteDp=1,
    nPum_nominal=2,
    minPumSpe=0.1,
    maxPumSpe=1,
    VHotWat_flow_nominal=0.0006,
    boiDesFlo={0.0003,0.0003},
    speedControlType_priPum=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP,
    minPriPumSpeSta={0,0,0})
    annotation (Placement(transformation(extent={{0,-20},{42,20}})));
  CDL.Integers.Sources.Constant supResReq(k=4)
    "Number of requests from heating load"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  CDL.Continuous.Sources.Constant TOut(k=290)
    "Measured outdoor air drybulb temperature"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  CDL.Continuous.Sources.Constant TSup(k=340)
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  CDL.Continuous.Sources.Constant TRet(k=340)
    "Measured hot water return temperature"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  CDL.Continuous.Sources.Constant VHotWat_flow[4](k={6e-5,9e-5,20e-5,0.0004})
    "Measured hot water volume flowrate"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  CDL.Continuous.Sources.Constant dPHotWat[1](k={34000})
    "Measured differential pressure between hot water supply and return"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller controller1(
    primaryOnly=true,
    nBoi=2,
    boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},

    nSta=3,
    staMat=[1,0; 0,1; 1,1],
    iniSta=2,
    boiDesCap={15000*0.8,15000*0.8},
    boiFirMin={0.2,0.3},
    minFloSet={0.2*0.0003,0.3*0.0003},
    maxFloSet={0.0003,0.0003},
    bypSetRat=0.00001,
    nPumPri=2,
    isHeadered=true,
    TMinSupNonConBoi=333.2,
    variablePrimary=true,
    nSen_remoteDp=1,
    nPum_nominal=2,
    minPumSpe=0.1,
    maxPumSpe=1,
    VHotWat_flow_nominal=0.0006,
    boiDesFlo={0.0003,0.0003},
    speedControlType_priPum=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP,

    minPriPumSpeSta={0,0,0})
    annotation (Placement(transformation(extent={{120,-20},{162,20}})));
  CDL.Integers.Sources.Constant supResReq1(k=2)
    "Number of requests from heating load"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  CDL.Continuous.Sources.Constant TOut1(k=290)
    "Measured outdoor air drybulb temperature"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  CDL.Continuous.Sources.Constant TSup1(k=340)
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  CDL.Continuous.Sources.Constant TRet1(k=340)
    "Measured hot water return temperature"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  CDL.Continuous.Sources.Constant VHotWat_flow1[4](k={6e-5,9e-5,20e-5,0.0004})
    "Measured hot water volume flowrate"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  CDL.Continuous.Sources.Constant dPHotWat1[1](k={34000})
    "Measured differential pressure between hot water supply and return"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  CDL.Logical.Sources.Constant uBoiAva[2](k={true,true})
    "Boiler availability status vector"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  CDL.Logical.Sources.Constant uBoiAva1[2](k={true,true})
    "Boiler availability status vector"
    annotation (Placement(transformation(extent={{60,-120},{80,-100}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller controller2(
    primaryOnly=true,
    nBoi=2,
    boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},

    nSta=3,
    staMat=[1,0; 0,1; 1,1],
    iniSta=0,
    boiDesCap={15000*0.8,15000*0.8},
    boiFirMin={0.2,0.3},
    minFloSet={0.2*0.0003,0.3*0.0003},
    maxFloSet={0.0003,0.0003},
    bypSetRat=0.00001,
    nPumPri=2,
    isHeadered=true,
    TMinSupNonConBoi=333.2,
    variablePrimary=true,
    nSen_remoteDp=1,
    nPum_nominal=2,
    minPumSpe=0.1,
    maxPumSpe=1,
    VHotWat_flow_nominal=0.0006,
    boiDesFlo={0.0003,0.0003},
    speedControlType_priPum=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP,

    minPriPumSpeSta={0,0,0})
    annotation (Placement(transformation(extent={{0,-240},{42,-200}})));
  CDL.Integers.Sources.Constant supResReq2(k=4)
    "Number of requests from heating load"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  CDL.Continuous.Sources.Constant TOut2(k=290)
    "Measured outdoor air drybulb temperature"
    annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));
  CDL.Continuous.Sources.Constant TSup2(k=340)
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-60,-220},{-40,-200}})));
  CDL.Continuous.Sources.Constant TRet2(k=340)
    "Measured hot water return temperature"
    annotation (Placement(transformation(extent={{-60,-250},{-40,-230}})));
  CDL.Continuous.Sources.Constant VHotWat_flow2[4](k={6e-5,9e-5,20e-5,0.0004})
    "Measured hot water volume flowrate"
    annotation (Placement(transformation(extent={{-60,-280},{-40,-260}})));
  CDL.Continuous.Sources.Constant dPHotWat2[1](k={34000})
    "Measured differential pressure between hot water supply and return"
    annotation (Placement(transformation(extent={{-60,-310},{-40,-290}})));
  CDL.Logical.Sources.Constant uBoiAva2[2](k={false,true})
    "Boiler availability status vector"
    annotation (Placement(transformation(extent={{-60,-340},{-40,-320}})));
equation
  connect(supResReq.y, controller.supResReq) annotation (Line(points={{-38,70},
          {-8,70},{-8,7.27273},{-2,7.27273}}, color={255,127,0}));
  connect(TOut.y, controller.TOut) annotation (Line(points={{-38,40},{-12,40},{
          -12,3.63636},{-2,3.63636}}, color={0,0,127}));
  connect(TSup.y, controller.TSup) annotation (Line(points={{-38,10},{-16,10},{-16,
          1.77636e-15},{-2,1.77636e-15}},
                      color={0,0,127}));
  connect(TRet.y, controller.TRet) annotation (Line(points={{-38,-20},{-32,-20},
          {-32,-3.63636},{-2,-3.63636}},
                             color={0,0,127}));
  connect(dPHotWat.y, controller.dpHotWat_remote) annotation (Line(points={{-38,
          -80},{-20,-80},{-20,-10.9091},{-2,-10.9091}}, color={0,0,127}));
  connect(VHotWat_flow[4].y, controller.VHotWat_flow) annotation (Line(points={
          {-38,-50},{-26,-50},{-26,-7.27273},{-2,-7.27273}}, color={0,0,127}));
  connect(supResReq1.y, controller1.supResReq) annotation (Line(points={{82,70},
          {112,70},{112,7.27273},{118,7.27273}}, color={255,127,0}));
  connect(TOut1.y, controller1.TOut) annotation (Line(points={{82,40},{108,40},
          {108,3.63636},{118,3.63636}}, color={0,0,127}));
  connect(TSup1.y, controller1.TSup) annotation (Line(points={{82,10},{104,10},
          {104,0},{118,0}}, color={0,0,127}));
  connect(TRet1.y, controller1.TRet) annotation (Line(points={{82,-20},{88,-20},
          {88,-3.63636},{118,-3.63636}}, color={0,0,127}));
  connect(dPHotWat1.y, controller1.dpHotWat_remote) annotation (Line(points={{
          82,-80},{100,-80},{100,-10.9091},{118,-10.9091}}, color={0,0,127}));
  connect(uBoiAva.y, controller.uBoiAva) annotation (Line(points={{-38,-110},{
          -8,-110},{-8,-14.5455},{-2,-14.5455}}, color={255,0,255}));
  connect(uBoiAva1.y, controller1.uBoiAva) annotation (Line(points={{82,-110},{
          112,-110},{112,-14.5455},{118,-14.5455}}, color={255,0,255}));
  connect(VHotWat_flow1[1].y, controller1.VHotWat_flow) annotation (Line(points
        ={{82,-50},{94,-50},{94,-7.27273},{118,-7.27273}}, color={0,0,127}));
  connect(supResReq2.y, controller2.supResReq) annotation (Line(points={{-38,
          -150},{-8,-150},{-8,-212.727},{-2,-212.727}}, color={255,127,0}));
  connect(TOut2.y, controller2.TOut) annotation (Line(points={{-38,-180},{-12,
          -180},{-12,-216.364},{-2,-216.364}}, color={0,0,127}));
  connect(TSup2.y, controller2.TSup) annotation (Line(points={{-38,-210},{-16,
          -210},{-16,-220},{-2,-220}}, color={0,0,127}));
  connect(TRet2.y, controller2.TRet) annotation (Line(points={{-38,-240},{-32,
          -240},{-32,-223.636},{-2,-223.636}}, color={0,0,127}));
  connect(dPHotWat2.y, controller2.dpHotWat_remote) annotation (Line(points={{
          -38,-300},{-20,-300},{-20,-230.909},{-2,-230.909}}, color={0,0,127}));
  connect(VHotWat_flow2[4].y, controller2.VHotWat_flow) annotation (Line(points
        ={{-38,-270},{-26,-270},{-26,-227.273},{-2,-227.273}}, color={0,0,127}));
  connect(uBoiAva2.y, controller2.uBoiAva) annotation (Line(points={{-38,-330},
          {-8,-330},{-8,-234.545},{-2,-234.545}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-380},{180,
            100}}),
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
      preserveAspectRatio=false, extent={{-100,-380},{180,100}})),
    experiment(
      StopTime=3600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
      __Dymola_Commands(file="./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Generic/Validation/PlantEnable.mos"
        "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantEnable\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantEnable</a>.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      May 7, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end Controller;
