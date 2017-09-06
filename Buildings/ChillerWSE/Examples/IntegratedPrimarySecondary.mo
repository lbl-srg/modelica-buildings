within Buildings.ChillerWSE.Examples;
model IntegratedPrimarySecondary
  "Example that demonstrates a chiller plant with integrated primary-secondary side economizer"
  extends Modelica.Icons.Example;

  extends Buildings.ChillerWSE.Examples.BaseClasses.DataCenterControl(
    redeclare Buildings.ChillerWSE.IntegratedPrimarySecondary chiWSE(
        addPowerToMedium=false,
        perPum=perPumPri,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        use_controller=false),
    pumCW(each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        each use_inputFilter=true),
    ahu(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        use_inputFilterValve=false),
    chiStaCon(tWai=0),
    CWPumCon(tWai=0));

  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumSec(
    each pressure=
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m1_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
          dp=(dp1_wse_nominal+18000)*{1.5,1.3,1.0,0.6}))
    "Performance data for secondary chilled water pumps";
  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumPri(
    each pressure=
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m1_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
          dp=(dp1_chi_nominal+6000)*{1.5,1.3,1.0,0.6}))
    "Performance data for secondary chilled water pumps";

  Buildings.ChillerWSE.Examples.BaseClasses.Controls.CoolingModeControl
    cooModCon(
    tWai=tWai,
    deaBan1=1.1,
    deaBan2=0.5,
    deaBan3=1.1,
    deaBan4=0.5)
    "Cooling mode controller"
    annotation (Placement(transformation(extent={{-130,100},{-110,120}})));
  Modelica.Blocks.Sources.RealExpression towTApp(
    y=max(cooTow[1:numChi].TAppAct))
    "Cooling tower approach temperature"
    annotation (Placement(transformation(extent={{-190,100},{-170,120}})));

  Modelica.Blocks.Sources.RealExpression yVal5(
    y=if cooModCon.y > 1.5 then 1 else 0)
    "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Blocks.Sources.RealExpression cooLoaChi(
    y=chiWSE.port_a2.m_flow*4180*(chiWSE.TCHWSupWSE - TCHWSupSet.y))
    "Cooling load in chillers"
    annotation (Placement(transformation(extent={{-130,134},{-110,154}})));
  Buildings.ChillerWSE.FlowMachine_y secPum(
    redeclare package Medium = MediumW,
    dpValve_nominal=6000,
    per=perPumSec,
    addPowerToMedium=false,
    m_flow_nominal=m2_flow_chi_nominal,
    tau=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    uLow=1E-04,
    uHigh=2*1E-04)
    "Secondary pumps"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={72,-26})));
  Buildings.ChillerWSE.Examples.BaseClasses.Controls.ConstantSpeedPumpStageControl
  PriPumCon(tWai=0)
    "Chilled water primary pump controller"
    annotation (Placement(transformation(extent={{-92,22},{-72,42}})));
  Modelica.Blocks.Math.Gain gai2[numChi](
    each k=m2_flow_chi_nominal)
    "Gain effect"
    annotation (Placement(transformation(extent={{-50,22},{-30,42}})));
equation
  connect(yVal5.y, chiWSE.yVal5)
    annotation (Line(points={{11,40},{40,40},{40,35},
          {124.4,35}}, color={0,0,127}));
  connect(cooLoaChi.y, chiStaCon.QTot)
    annotation (Line(points={{-109,144},{-52,144}}, color={0,0,127}));
  connect(TCHWSup.port_b, secPum.port_a) annotation (Line(
      points={{84,0},{72,0},{72,-16}},
      color={0,127,255},
      thickness=0.5));
  connect(secPum.port_b, ahu.port_a1)
    annotation (Line(points={{72,-36},{72,-114},{154,-114}},
                                                           color={0,127,255},
      thickness=0.5));
  connect(pumSpeSig.y, secPum.u)
    annotation (Line(points={{12.8,-14},{40,-14},{
          40,0},{68,0},{68,-14}}, color={0,0,127}));
  connect(chiNumOn.y,PriPumCon.numOnChi)
    annotation (Line(points={{-161,74},{
          -102,74},{-102,36},{-94,36}}, color={0,0,127}));
  connect(PriPumCon.y, gai2.u)
    annotation (Line(points={{-71,32},{-52,32}}, color={0,0,127}));
  connect(gai2.y, chiWSE.m_flow_in)
    annotation (Line(points={{-29,32},{30,32},{30,28.5},{124.5,28.5}},
       color={0,0,127}));

  connect(chiWSE.port_b2, TCHWSup.port_a)
    annotation (Line(
      points={{126,26},{112,26},{112,0},{104,0}},
      color={0,127,255},
      thickness=0.5));
  connect(weaData.weaBus, weaBus.TWetBul)
    annotation (Line(
      points={{-200,-68},{-200,-28}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(chiWSE.port_b1, TCWRet.port_a)
    annotation (Line(
      points={{146,38},{160,38},{160,60},{202,60}},
      color={0,127,255},
      thickness=0.5));
   for i in 1:numChi loop
    connect(TCWSup.port_a, cooTow[i].port_b)
      annotation (Line(
        points={{120,140},{132,140},{132,139},{131,139}},
        color={0,127,255},
        thickness=0.5));
    connect(pumCW[i].port_b, chiWSE.port_a1)
      annotation (Line(points={{70,90},{70,58},{110,58},{110,38},{126,38}},
        color={0,127,255},
        thickness=0.5));

    connect(pumCW[i].port_a, TCWSup.port_b)
      annotation (Line(
        points={{70,110},{70,140},{100,140}},
        color={0,127,255},
        thickness=0.5));
   end for;
  connect(towTApp.y, cooModCon.TApp)
    annotation (Line(points={{-169,110},{-170,110},
          {-168,110},{-132,110}}, color={0,0,127}));
  connect(weaBus.TWetBul.TWetBul, cooModCon.TWetBul)
    annotation (Line(
      points={{-200,-28},{-216,-28},{-216,200},{-150,200},{-150,114},{-132,114}},
      color={255,204,51},
      thickness=0.5));
  connect(cooModCon.y, chiStaCon.cooMod)
    annotation (Line(points={{-109,110},
          {-70,110},{-70,148},{-52,148}},   color={0,0,127}));
  connect(cooModCon.y,reaToBoo. u)
    annotation (Line(points={{-109,110},{-94,
          110},{-52,110}}, color={0,0,127}));
  connect(cooModCon.y, CWPumCon.cooMod)
    annotation (Line(points={{-109,110},
          {-70,110},{-70,78},{-54,78}}, color={0,0,127}));
  connect(cooModCon.y, cooTowSpeCon.cooMod)
    annotation (Line(points={{-109,110},{-70,110},{-70,182.444},{-52,182.444}},
                                                      color={0,0,127}));
  connect(TCHWRet.port_b, chiWSE.port_a2)
    annotation (Line(
      points={{220,0},{160,0},{160,26},{146,26}},
      color={0,127,255},
      thickness=0.5));
  connect(cooModCon.TCHWRetWSE, TCHWRet.T)
    annotation (Line(points={{-132,102},{
          -150,102},{-150,200},{260,200},{260,20},{230,20},{230,11}}, color={0,0,
          127}));
  connect(senRelPre.port_a, ahu.port_a1)
    annotation (Line(points={{152,-94},{72,-94},{72,-114},{154,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(senRelPre.port_b, ahu.port_b1)
    annotation (Line(points={{172,-94},{242,-94},{242,-114},{174,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(TAirSup.port_a, ahu.port_b2)
    annotation (Line(
      points={{114,-140},{140,-140},{140,-126},{154,-126}},
      color={0,127,255},
      thickness=0.5));
  connect(ahu.port_a2, roo.airPorts[1])
    annotation (Line(points={{174,-126},{174,-126},{194,-126},{194,-140},{242,-140},
          {242,-176.7},{168.475,-176.7}},  color={0,127,255},
      thickness=0.5));

  connect(TAirSup.port_b, roo.airPorts[2])
    annotation (Line(
      points={{94,-140},{94,-140},{74,-140},{74,-176.7},{164.425,-176.7}},
      color={0,127,255},
      thickness=0.5));

  connect(chiWSE.TCHWSupWSE, cooModCon.TCHWSupWSE)
    annotation (Line(points={{147,
          36},{260,36},{260,200},{-150,200},{-150,106},{-132,106}}, color={0,0,127}));
  connect(TCHWSupSet.y, cooModCon.TCHWSupSet)
    annotation (Line(points={{-169,160},
          {-150,160},{-150,118},{-132,118}}, color={0,0,127}));
  connect(cooModCon.y, PriPumCon.cooMod)
    annotation (Line(points={{-109,
          110},{-102,110},{-102,40},{-94,40}}, color={0,0,127}));
  connect(TCHWSup.T, chiStaCon.TCHWSup)
    annotation (Line(points={{94,11},{94,11},
          {94,36},{40,36},{40,200},{-70,200},{-70,140},{-52,140}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-180},{280,
            200}})),
  __Dymola_Commands(file=
        "modelica://Buildings/Resources/Scripts/Dymola/ChillerWSE/Examples/IntegratedPrimarySecondary.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<h4>System Configuration</h4>
<p>This example demonstrates the implementation of a chiller plant with 
water-side economizer (WSE) to cool a data center. The system schematics is as shown below. </p>
<p>The system is a primary-secondary chiller plant with two chillers and an integrated WSE.</p>
<p>
<img alt=\"image\" 
src=\"modelica://Buildings/Resources/Images/ChillerWSE/Examples/IntegratedPrimarySecondarySystem.png\"/>
</p>
<h4>Control Logic</h4>
<p>This section describes the detailed control logic used in this chilled water plant system.</p>
<h5>Cooling Mode Control</h5>
<p>The chilled water system with integrated waterside economizer can run in three modes: 
free cooling (FC) mode, partially mechanical cooling (PMC) mode and fully mechanical cooling (FMC) mode. 
The detailed control logics about how to switch among these three cooling modes are described in 
<a href=\"modelica://Buildings.ChillerWSE.Examples.BaseClasses.Controls.CoolingModeControl\">
Buildings.ChillerWSE.Examples.BaseClasses.Controls.CoolingModeControl</a>.
Details on how the valves are operated
under different cooling modes are presented in 
<a href=\"modelica://Buildings.ChillerWSE.IntegratedPrimarySecondary\">
Buildings.ChillerWSE.IntegratedPrimarySecondary</a>.
</p>
<h5>Chiller Staging Control </h5>
<p>
The staging sequence of multiple chillers are descibed as below:
</p>
<ul>
<li>
The chillers are all off when cooling mode is FC.
</li>
<li>
One chiller is commanded on when cooling mode is not FC. 
</li>
<li>
Two chillers are commanded on when cooling mode is not FC and the cooling load 
addressed by chillers is larger than
a critical value. 
</li>
</ul>
<p>
The detailed implementation is shown in 
<a href=\"modelica://Buildings.ChillerWSE.Examples.BaseClasses.Controls.ChillerStageControl\">
Buildings.ChillerWSE.Examples.BaseClasses.Controls.ChillerStageControl</a>.
</p>
<h5>Pump Staging Control </h5>
<p>
For constant speed pumps, the number of running pumps equals to the number of running chillers.
</p>
<p>
For variable speed pumps, the number of running pumps is controlled by the speed signal and the mass flow rate. 
Details are shown in 
<a href=\"modelica://Buildings.ChillerWSE.Examples.BaseClasses.Controls.VariableSpeedPumpStageControl\">
Buildings.ChillerWSE.Examples.BaseClasses.Controls.VariableSpeedPumpStageControl</a>. And the speed is 
controlled by maintaining a fixed differential pressure between the outlet and inlet on the waterside
of the Computer Room Air Handler (CRAH).
</p>
<h5>Cooling Tower Speed Control</h5>
<p>
The control logic for cooling tower fan speed is described as:
</p>
<ul>
<li>
When in FMC mode, the cooling tower speed is controlled to maintain 
the condenser water supply temperature (CWST) at its setpoint.
</li>
<li>
When in PMC mode, the fan is enabled to run at 100% speed to make the condenser water as cold as possible
 and maximize the WSE output.
</li>
<li>
When in FC mode, the fan speed is modulated to maintain chilled water supply temperature at its setpoint.
</li>
</ul>
<p>
Detailed implementation of cooling tower speed control can be found in 
<a href=\"modelica://Buildings.ChillerWSE.Examples.BaseClasses.Controls.CoolingTowerSpeedControl\">
Buildings.ChillerWSE.Examples.BaseClasses.Controls.CoolingTowerSpeedControl</a>.
</p>
<p>
Note that for simplicity, the chilled water supply temperature and 
differential pressure reset control are not implemented in this example.
</p>
</html>", revisions="<html>
<ul>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-06));
end IntegratedPrimarySecondary;
