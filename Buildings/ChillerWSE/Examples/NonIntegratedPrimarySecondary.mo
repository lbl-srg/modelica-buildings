within Buildings.ChillerWSE.Examples;
model NonIntegratedPrimarySecondary
  "Example that show how to use Buildings.ChillerWSE.IntegratedPrimaryLoadSide"
  extends Buildings.ChillerWSE.Examples.BaseClasses.DataCenterControl(
    redeclare Buildings.ChillerWSE.NonIntegrated chiWSE(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=60,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      use_Controller=false),
    ahu(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    pumCW(each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));

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

  Buildings.ChillerWSE.Examples.BaseClasses.Controls.CoolingModeControlNonIntegrated cooModCon(
    tWai=tWai,
    deaBan=1,
    wseTra=273.15 + 5)
    "Cooling mode controller"
    annotation (Placement(transformation(extent={{-130,100},{-110,120}})));

  Buildings.ChillerWSE.FlowMachine_y secPum(
    redeclare package Medium = MediumW,
    dpValve_nominal=6000,
    per=perPumSec,
    addPowerToMedium=false,
    m_flow_nominal=m2_flow_chi_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=1,
    use_inputFilter=true)
    "Secondary pumps"
    annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={72,-52})));
  Buildings.ChillerWSE.FlowMachine_m priPum(
    redeclare package Medium = MediumW,
    dpValve_nominal=6000,
    per=perPumPri,
    m_flow_nominal=m2_flow_chi_nominal,
    addPowerToMedium=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=1,
    use_inputFilter=true)
    "Constant speed pumps"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={180,0})));
  Buildings.ChillerWSE.Examples.BaseClasses.Controls.ConstantSpeedPumpStageControl
    priPumCon(tWai=0)
    "Chilled water primary pump controller"
    annotation (Placement(transformation(extent={{-92,22},{-72,42}})));
  Modelica.Blocks.Math.Gain gai2[numChi](
    each k=m2_flow_chi_nominal)
    "Gain effect"
    annotation (Placement(transformation(extent={{-50,22},{-30,42}})));
  Modelica.Blocks.Sources.RealExpression cooLoaChi(
    y=ahu.port_a1.m_flow*4180*(CHWRT.T - CHWSTSet.y))
    "Cooling load in chillers"
    annotation (Placement(transformation(extent={{-130,134},{-110,154}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-200,-160},{-180,-140}})));
equation
  connect(chiWSE.port_b2, CHWST.port_a)
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
  connect(chiWSE.port_b1, CWRT.port_a)
    annotation (Line(
      points={{146,38},{160,38},{160,60},{202,60}},
      color={0,127,255},
      thickness=0.5));
  connect(CWRT.port_b, expVesCW.port_a)
    annotation (Line(
      points={{222,60},{240,60},{240,125}},
      color={0,127,255},
      thickness=0.5));
  for i in 1:numChi loop
    connect(CWST.port_a, cooTow[i].port_b)
      annotation (Line(points={{120,140},{132,140},{132,139},{131,139}},
        color={0,127,255},
        thickness=0.5));
    connect(pumCW[i].port_b, chiWSE.port_a1)
      annotation (Line(
        points={{70,90},{70,58},{110,58},{110,38},{126,38}},
        color={0,127,255},
        thickness=0.5));

    connect(pumCW[i].port_a, CWST.port_b)
      annotation (Line(points={{70,110},{70,140},{100,140}},
        color={0,127,255},
        thickness=0.5));
    connect(chiOn[i].y, chiWSE.on[i])
      annotation (Line(points={{11,140},{40,140},{40,39.6},{124.4,39.6}},
        color={255,0,255}));
   connect(cooTowSpeCon.y, cooTowSpe[i].u1)
     annotation (Line(points={{-29,178.889},{36,178.889},{36,178.8},{58.4,178.8}},
                                color={0,0,127}));
  end for;
  connect(CHWSTSet.y, cooModCon.CHWSTSet)
    annotation (Line(points={{-169,160},{-150,
          160},{-150,116},{-132,116}}, color={0,0,127}));
  connect(weaBus.TWetBul.TWetBul, cooModCon.TWetBul)
    annotation (Line(
      points={{-200,-28},{-216,-28},{-216,200},{-150,200},{-150,112},{-132,112}},
      color={255,204,51},
      thickness=0.5));
  connect(cooModCon.cooMod, chiStaCon.cooMod)
    annotation (Line(points={{-109,110},
          {-70,110},{-70,148},{-52,148}},   color={0,0,127}));
  connect(chiStaCon.y, chiOn.u)
    annotation (Line(points={{-29,140},{-20.5,140},{
          -12,140}},  color={0,0,127}));
  connect(cooModCon.cooMod,reaToBoo. u)
    annotation (Line(points={{-109,110},{-94,
          110},{-52,110}}, color={0,0,127}));
  connect(reaToBoo.y, wseOn.u)
    annotation (Line(points={{-29,110},{-20.5,110},{-12,
          110}},     color={255,0,255}));
  connect(wseOn.y, chiWSE.on[numChi + 1])
    annotation (Line(points={{11,110},{40,110},
          {40,39.6},{124.4,39.6}}, color={255,0,255}));
  connect(cooModCon.cooMod, CWPumCon.cooMod)
    annotation (Line(points={{-109,110},
          {-70,110},{-70,78},{-54,78}}, color={0,0,127}));
  connect(chiNumOn.y, CWPumCon.chiNumOn)
    annotation (Line(points={{-161,74},{-161,74},{-54,74}},
      color={0,0,127}));
  connect(CWPumCon.y, gai.u)
    annotation (Line(points={{-31,70},{-12,70}},color={0,0,127}));
  connect(gai.y, pumCW.m_flow_in)
    annotation (Line(points={{11,70},{40,70},{40,100},
          {58,100}}, color={0,0,127}));
  connect(CWSTSet.y, cooTowSpeCon.CWSTSet) annotation (Line(points={{-109,180},
          {-70,180},{-70,186},{-52,186}}, color={0,0,127}));
  connect(cooModCon.cooMod, cooTowSpeCon.cooMod)
    annotation (Line(points={{-109,110},{-70,110},{-70,182.444},{-52,182.444}},
                                                      color={0,0,127}));
  connect(CHWSTSet.y, cooTowSpeCon.CHWSTSet) annotation (Line(points={{-169,160},
          {-150,160},{-150,200},{-70,200},{-70,178.889},{-52,178.889}}, color={
          0,0,127}));
  connect(CWST.T, cooTowSpeCon.CWST)
    annotation (Line(points={{110,151},{110,160},{122,160},{122,200},{-70,200},
          {-70,175.333},{-52,175.333}},
          color={0,0,127}));
  connect(CHWST.T, cooTowSpeCon.CHWST)
    annotation (Line(points={{94,11},{94,36},{40,36},{40,200},{-70,200},{-70,
          171.778},{-52,171.778}},                                color={0,0,127}));
  connect(chiWSE.TSet, CHWSTSet.y)
    annotation (Line(points={{124.4,42.8},{40,42.8},
          {40,200},{-150,200},{-150,160},{-169,160}}, color={0,0,127}));
  connect(SAXSet.y, ahu.XSet_w)
    annotation (Line(points={{9,-126},{60,-126},{60,
          -119},{153,-119}},
          color={0,0,127}));
  connect(uFan.y, ahu.uFan)
    annotation (Line(points={{9,-166},{60,-166},{60,-124},
          {153,-124}},color={0,0,127}));
  connect(expVesChi.port_a, ahu.port_b1)
    annotation (Line(
      points={{270,-59},{270,-59},{270,-114},{174,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(mPum_flow.y, varSpeCon.masFloPum)
    annotation (Line(points={{-105,4},{-50,4}},color={0,0,127}));
  connect(senRelPre.port_a, ahu.port_a1)
    annotation (Line(points={{150,-96},{72,-96},{72,-114},{154,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(pumSpe.y, varSpeCon.speSig)
    annotation (Line(points={{-105,-20},{-76,-20},
          {-76,0},{-50,0}}, color={0,0,127}));
  connect(senRelPre.p_rel, pumSpe.u_m)
    annotation (Line(points={{160,-87},{162,-87},
          {162,-66},{-116,-66},{-116,-32}},color={0,0,127}));
  connect(dpSet.y, pumSpe.u_s)
    annotation (Line(points={{-155,-20},{-128,-20}}, color={0,0,127}));
  connect(pumSpe.y, pumSpeSig[1].u2)
    annotation (Line(points={{-105,-20},{-76,-20},
          {-76,-34},{-16,-34},{-16,-18.8},{-5.6,-18.8}},   color={0,0,127}));
  connect(pumSpe.y, pumSpeSig[2].u2)
    annotation (Line(points={{-105,-20},{-105,-20},
          {-76,-20},{-76,-34},{-16,-34},{-16,-18.8},{-5.6,-18.8}},   color={0,0,
          127}));
  connect(varSpeCon.y, pumSpeSig.u1)
    annotation (Line(points={{-27,-4},{-27,-4},
          {-16,-4},{-16,-9.2},{-5.6,-9.2}},    color={0,0,127}));
  connect(SATSet.y, ahuValSig.u_s)
    annotation (Line(points={{-59,-88},{-48,-88},{-14,-88}}, color={0,0,127}));
  connect(SAT.port_a, ahu.port_b2)
    annotation (Line(points={{114,-140},{140,-140},
          {140,-126},{154,-126}},
      color={0,127,255},
      thickness=0.5));
  connect(SAT.T, ahuValSig.u_m)
    annotation (Line(points={{104,-129},{104,-129},{
          104,-122},{60,-122},{60,-106},{-2,-106},{-2,-100}},
          color={0,0,127}));
  connect(ahu.port_a2, roo.airPorts[1])
    annotation (Line(points={{174,-126},{174,-126},{194,-126},
      {194,-140},{242,-140},{242,-158},{167.85,-158}},
      color={0,127,255},
      thickness=0.5));
  connect(SAT.port_b, roo.airPorts[2])
    annotation (Line(points={{94,-140},{94,-140},
          {74,-140},{74,-158},{164.15,-158}},
          color={0,127,255},
          thickness=0.5));
  connect(ahuValSig.y, ahu.uWatVal)
    annotation (Line(points={{9,-88},{60,-88},{60,-116},{60,-116},{154,-116},{154,
          -116},{153,-116}},                              color={0,0,127}));
  connect(SATSet.y, ahu.TSet)
    annotation (Line(points={{-59,-88},{-40,-88},{-40,
          -66},{60,-66},{60,-121},{153,-121}},
          color={0,0,127}));
  connect(secPum.port_b, ahu.port_a1)
    annotation (Line(points={{72,-62},{72,-62},
          {72,-114},{154,-114}}, color={0,127,255},
      thickness=0.5));
  connect(CHWST.port_b, secPum.port_a)
    annotation (Line(points={{84,0},{72,0},{72,-42}}, color={0,127,255},
      thickness=0.5));
  connect(pumSpeSig.y, secPum.u)
    annotation (Line(points={{12.8,-14},{34,-14},{
          68,-14},{68,-40}},
          color={0,0,127}));
  connect(chiNumOn.y,priPumCon. chiNumOn)
    annotation (Line(points={{-161,74},{-102,
          74},{-102,76},{-102,36},{-94,36}}, color={0,0,127}));
  connect(cooModCon.cooMod,priPumCon. cooMod)
    annotation (Line(points={{-109,110},
          {-102,110},{-102,40},{-94,40}}, color={0,0,127}));
  connect(priPumCon.y, gai2.u)
    annotation (Line(points={{-71,32},{-62,32},{-52,32}}, color={0,0,127}));
  connect(gai2.y, priPum.u)
    annotation (Line(points={{-29,32},{-2,32},{40,32},{
          40,200},{260,200},{260,32},{200,32},{200,4},{192,4}},
          color={0,0,127}));
  connect(cooLoaChi.y, chiStaCon.QTot)
    annotation (Line(points={{-109,144},{-80.5,
          144},{-52,144}}, color={0,0,127}));
  connect(chiNumOn.y, cooModCon.numOnChi)
    annotation (Line(points={{-161,74},{-150,
          74},{-150,104},{-132,104}}, color={0,0,127}));
  connect(CHWST.T, cooModCon.CHWST)
    annotation (Line(points={{94,11},{94,36},{40,
          36},{40,200},{-150,200},{-150,108},{-132,108}}, color={0,0,127}));
  connect(CWPumCon.y, val.y)
    annotation (Line(points={{-31,70},{-22,70},{-22,94},
          {40,94},{40,200},{180,200},{180,152}}, color={0,0,127}));
  connect(CWPumCon.y, cooTowSpe.u2)
    annotation (Line(points={{-31,70},{-22,70},{-22,94},{40,94},
      {40,169.2},{58.4,169.2}}, color={0,0,127}));
  connect(cooTowSpe.y, cooTow.y)
    annotation (Line(points={{76.8,174},{100,174},{
          100,200},{160,200},{160,147},{153,147}}, color={0,0,127}));
  connect(priPum.port_a, CHWST.port_a)
    annotation (Line(points={{190,-1.33227e-15},{198,-1.33227e-15},
      {198,-24},{112,-24},{112,0},{104,0}},
      color={0,127,255},
      thickness=0.5));
  connect(priPum.port_a, CHWRT.port_b)
    annotation (Line(
      points={{190,-1.33227e-15},{220,-1.33227e-15},{220,0}},
      color={0,127,255},
      thickness=0.5));
  connect(CHWRT.port_a, ahu.port_b1)
    annotation (Line(
      points={{240,0},{250,0},{250,-62},{250,-114},{174,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(chiWSE.port_a2, priPum.port_b)
    annotation (Line(
      points={{146,26},{160,26},{160,0},{170,0}},
      color={0,127,255},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-180},{280,
            200}})),
    __Dymola_Commands(file="Resources/Scripts/Dymola/ChillerWSE/Examples/NonIntegratedPrimarySecondary.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<h4>System Configuration</h4>
<p>This example demonstrates the implementation of a chiller plant 
with water-side economizer (WSE) to cool a data center. The system schematics is as shown below. </p>
<p>The system is a primary-secondary chiller plant with two chillers and a non-integrated WSE.</p>
<p>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/ChillerWSE/Examples/NonIntegratedPrimarySecondary.png\"/>
</p>
<h4>Control Logic</h4>
<p>This section describes the detailed control logic used in this chilled water plant system.</p>
<h5>Cooling Mode Control</h5>
<p>The chilled water system with non-integrated waterside economizer can run among two modes: 
free cooling (FC) mode, and fully mechanical cooling (FMC) mode. 
The detailed control logics about how to switch between these two cooling modes are described in 
<a href=\"modelica://Buildings.ChillerWSE.Examples.BaseClasses.Controls.CoolingModeControlNonIntegrated\">
Buildings.ChillerWSE.Examples.BaseClasses.Controls.CoolingModeControlNonIntegrated</a>.
Details on how the valves are operated under different cooling modes are presented in 
<a href=\"modelica://Buildings.ChillerWSE.NonIntegrated\">
Buildings.ChillerWSE.NonIntegrated</a>.
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
Two chillers are commanded on when cooling mode is not FC and the cooling load addressed by chillers is larger than
a critical point, for example, <code>0.8QEva_nominal</code>, where <code>QEva_nominal</code> represents the 
chiller's nominal cooling capaciy. 
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
For variable speed pumps, the number of runing pumps is controlled by the speed signal and the mass flowrate. 
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
When in FC mode, the fan speed is modulated to maintain chilled water supply temperature at its setpoint.
</li>
</ul>
<p>
Detailed implementation of cooling tower speed control can be found in 
<a href=\"modelica://Buildings.ChillerWSE.Examples.BaseClasses.Controls.CoolingTowerSpeedControl\">
Buildings.ChillerWSE.Examples.BaseClasses.Controls.CoolingTowerSpeedControl</a>.
</p>
<p>
Note that for simplicity, the temperature and differential pressure reset control are not implemented in this example.
</p>
</html>", revisions="<html>
<ul>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end NonIntegratedPrimarySecondary;
