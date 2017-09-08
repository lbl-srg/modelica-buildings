within Buildings.Applications.DataCenters.ChillerCooled.Examples;
model NonIntegratedPrimarySecondaryEconomizer
  "Example that demonstrates a chiller plant with non-integrated primary-secondary side economizer"
  extends Modelica.Icons.Example;

  extends
    Buildings.Applications.DataCenters.ChillerCooled.Examples.BaseClasses.PartialDataCenter(
    redeclare Buildings.Applications.DataCenters.ChillerCooled.Equipment.NonIntegrated chiWSE(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=60,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      use_controller=false),
    ahu(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial, dp1_nominal=
          60000),
    pumCW(each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    dpSet(k=80000),
    pumSpe(k=1),
    roo(QRoo_flow=800000),
    chiStaCon(dT=0.5, criPoiTem=553.86));

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

  Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingModeNonIntegrated cooModCon(
    tWai=tWai,
    deaBan=1,
    TSwi=273.15 + 6.3)
    "Cooling mode controller"
    annotation (Placement(transformation(extent={{-130,100},{-110,120}})));

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.FlowMachine_y secPum(
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
        origin={72,-40})));
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.FlowMachine_m priPum(
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
  Buildings.Applications.DataCenters.ChillerCooled.Controls.ConstantSpeedPumpStage
    priPumCon(tWai=0)
    "Chilled water primary pump controller"
    annotation (Placement(transformation(extent={{-92,22},{-72,42}})));
  Modelica.Blocks.Sources.RealExpression cooLoaChi(
    y=ahu.port_a1.m_flow*4180*(TCHWRet.T - TCHWSupSet.y)) "Cooling load in chillers"
    annotation (Placement(transformation(extent={{-130,134},{-110,154}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-200,-160},{-180,-140}})));
  Buildings.Fluid.Sensors.MassFlowRate bypFlo(redeclare package Medium = MediumW)
    "Sensor for bypass flowrate"
    annotation (Placement(transformation(extent={{160,-34},{140,-14}})));
equation
  connect(chiWSE.port_b2, TCHWSup.port_a)
    annotation (Line(
      points={{120,24},{112,24},{112,0},{104,0}},
      color={0,127,255},
      thickness=0.5));
  connect(chiWSE.port_b1, TCWRet.port_a)
    annotation (Line(
      points={{140,36},{160,36},{160,60},{202,60}},
      color={0,127,255},
      thickness=0.5));
  for i in 1:numChi loop
    connect(TCWSup.port_a, cooTow[i].port_b)
      annotation (Line(
        points={{98,140},{132,140},{132,140},{120,140}},
        color={0,127,255},
        thickness=0.5));
    connect(pumCW[i].port_b, chiWSE.port_a1)
      annotation (Line(
        points={{70,90},{70,58},{110,58},{110,36},{120,36}},
        color={0,127,255},
        thickness=0.5));

    connect(pumCW[i].port_a, TCWSup.port_b)
      annotation (Line(
        points={{70,110},{70,140},{78,140}},
        color={0,127,255},
        thickness=0.5));
    connect(chiOn[i].y, chiWSE.on[i])
      annotation (Line(points={{11,140},{40,140},{40,37.6},{118.4,37.6}},
        color={255,0,255}));
   connect(cooTowSpeCon.y, cooTowSpe[i].u1)
     annotation (Line(points={{-29,178.889},{36,178.889},{36,178.8},{58.4,178.8}},
                                color={0,0,127}));
  end for;
  connect(TCHWSupSet.y, cooModCon.TCHWSupSet)
    annotation (Line(points={{-169,160},{-150,160},{-150,118},{-132,118}},
          color={0,0,127}));
  connect(weaBus.TWetBul.TWetBul, cooModCon.TWetBul)
    annotation (Line(
      points={{-200,-28},{-216,-28},{-216,200},{-150,200},{-150,114},{-132,114}},
      color={255,204,51},
      thickness=0.5));
  connect(chiStaCon.y, chiOn.u)
    annotation (Line(points={{-29,140},{-20.5,140},{
          -12,140}},  color={0,0,127}));
  connect(reaToBoo.y, wseOn.u)
    annotation (Line(points={{-29,110},{-20.5,110},{-12,
          110}},     color={255,0,255}));
  connect(wseOn.y, chiWSE.on[numChi + 1])
    annotation (Line(points={{11,110},{40,110},{40,37.6},{118.4,37.6}},
                                   color={255,0,255}));
  connect(CWPumCon.y, gai.u)
    annotation (Line(points={{-31,70},{-12,70}},color={0,0,127}));
  connect(gai.y, pumCW.m_flow_in)
    annotation (Line(points={{11,70},{40,70},{40,100},
          {58,100}}, color={0,0,127}));
  connect(TCWSupSet.y, cooTowSpeCon.TCWSupSet)
    annotation (Line(points={{-109,180},
          {-70,180},{-70,186},{-52,186}}, color={0,0,127}));
  connect(TCHWSupSet.y, cooTowSpeCon.TCHWSupSet)
    annotation (Line(points={{-169,160},{-150,160},{-150,200},{-70,200},{-70,
          178.889},{-52,178.889}},
        color={0,0,127}));
  connect(TCWSup.T, cooTowSpeCon.TCWSup)
    annotation (Line(points={{88,151},{88,160},{122,160},{122,200},{-70,200},{
          -70,175.333},{-52,175.333}},
        color={0,0,127}));
  connect(TCHWSup.T, cooTowSpeCon.TCHWSup)
    annotation (Line(points={{94,11},{94,36},{40,36},{40,200},{-70,200},{-70,
          171.778},{-52,171.778}},                                     color={0,
          0,127}));
  connect(chiWSE.TSet, TCHWSupSet.y)
    annotation (Line(points={{118.4,40.8},{40,40.8},{40,200},{-150,200},{-150,
          160},{-169,160}},                           color={0,0,127}));
  connect(XAirSupSet.y, ahu.XSet_w)
    annotation (Line(points={{-59,-120},{60,-120},{60,-121},{119,-121}},
                                 color={0,0,127}));
  connect(uFan.y, ahu.uFan)
    annotation (Line(points={{-59,-150},{60,-150},{60,-126},{119,-126}},
                      color={0,0,127}));
  connect(mPum_flow.y, varSpeCon.masFloPum)
    annotation (Line(points={{-105,4},{-50,4}},color={0,0,127}));
  connect(pumSpe.y, varSpeCon.speSig)
    annotation (Line(points={{-105,-20},{-76,-20},
          {-76,0},{-50,0}}, color={0,0,127}));
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
  connect(TAirSupSet.y, ahuValSig.u_s)
    annotation (Line(points={{-59,-90},{-48,-90},{-12,-90}}, color={0,0,127}));
  connect(TAirSup.port_a, ahu.port_b2)
    annotation (Line(
      points={{80,-180},{140,-180},{140,-128},{120,-128}},
      color={0,127,255},
      thickness=0.5));
  connect(ahu.port_a2, roo.airPorts[1])
    annotation (Line(points={{140,-128},{140,-128},{194,-128},{194,-140},{242,
          -140},{242,-168.7},{132.475,-168.7}},
      color={0,127,255},
      thickness=0.5));
  connect(TAirSup.port_b, roo.airPorts[2])
    annotation (Line(
      points={{100,-180},{100,-180},{100,-140},{100,-168.7},{128.425,-168.7}},
      color={0,127,255},
      thickness=0.5));
  connect(secPum.port_b, ahu.port_a1)
    annotation (Line(points={{72,-50},{72,-50},{72,-116},{120,-116}},
                                 color={0,127,255},
      thickness=0.5));
  connect(TCHWSup.port_b, secPum.port_a)
    annotation (Line(
      points={{84,0},{72,0},{72,-30}},
      color={0,127,255},
      thickness=0.5));
  connect(pumSpeSig.y, secPum.u)
    annotation (Line(points={{12.8,-14},{34,-14},{68,-14},{68,-28}},
          color={0,0,127}));
  connect(cooLoaChi.y, chiStaCon.QTot)
    annotation (Line(points={{-109,144},{-52,144},{-52,140}},
                           color={0,0,127}));
  connect(TCHWSup.T, cooModCon.TCHWSup)
    annotation (Line(points={{94,11},{94,36},{40,36},{40,200},{-150,200},{-150,
          106.2},{-132,106.2}},                               color={0,0,127}));
  connect(CWPumCon.y, val.y)
    annotation (Line(points={{-31,70},{-22,70},{-22,94},
          {40,94},{40,200},{180,200},{180,152}}, color={0,0,127}));
  connect(CWPumCon.y, cooTowSpe.u2)
    annotation (Line(points={{-31,70},{-22,70},{-22,94},{40,94},
      {40,169.2},{58.4,169.2}}, color={0,0,127}));
  connect(cooTowSpe.y, cooTow.y)
    annotation (Line(points={{76.8,174},{100,174},{100,200},{160,200},{160,148},
          {142,148}},                              color={0,0,127}));
  connect(priPum.port_a, TCHWRet.port_b)
    annotation (Line(
      points={{190,-1.33227e-15},{220,-1.33227e-15},{220,0}},
      color={0,127,255},
      thickness=0.5));
  connect(TCHWRet.port_a, ahu.port_b1)
    annotation (Line(
      points={{240,0},{250,0},{250,-62},{250,-116},{140,-116}},
      color={0,127,255},
      thickness=0.5));
  connect(chiWSE.port_a2, priPum.port_b)
    annotation (Line(
      points={{140,24},{160,24},{160,0},{170,0}},
      color={0,127,255},
      thickness=0.5));
  connect(priPum.port_a, bypFlo.port_a)
    annotation (Line(points={{190,
          -1.33227e-15},{198,-1.33227e-15},{198,-24},{160,-24}}, color={0,127,
          255}));
  connect(bypFlo.port_b, TCHWSup.port_a)
    annotation (Line(points={{140,-24},{
          112,-24},{112,0},{104,0}}, color={0,127,255}));
  connect(TCHWSup.T, chiStaCon.TCHWSup)
    annotation (Line(points={{94,11},{94,11},{94,36},{94,36},{40,36},{40,200},{
          -70,200},{-70,134},{-52,134}},
        color={0,0,127}));
  connect(priPumCon.y, priPum.u) annotation (Line(points={{-71,32},{40,32},{40,
          14},{200,14},{200,4},{192,4}}, color={0,0,127}));
  connect(cooModCon.numOnChi, chiNumOn.y) annotation (Line(points={{-132,102},{
          -140,102},{-140,65},{-156.9,65}}, color={255,127,0}));
  connect(priPumCon.cooMod, cooModCon.y) annotation (Line(points={{-94,37},{
          -100,37},{-100,36},{-100,36},{-100,110},{-109,110}}, color={255,127,0}));
  connect(cooTowSpeCon.cooMod, cooModCon.y) annotation (Line(points={{-52,
          182.444},{-100,182.444},{-100,110},{-109,110}}, color={255,127,0}));
  connect(cooModCon.y, CWPumCon.cooMod) annotation (Line(points={{-109,110},{
          -100,110},{-100,75},{-54,75}}, color={255,127,0}));
  connect(reaToBoo.u, cooModCon.y) annotation (Line(points={{-52,110},{-109,110},
          {-109,110}}, color={255,127,0}));
  connect(chiStaCon.cooMod, cooModCon.y) annotation (Line(points={{-52,146},{
          -100,146},{-100,110},{-109,110}}, color={255,127,0}));
  connect(priPumCon.numOnChi, chiNumOn.y) annotation (Line(points={{-94,27},{
          -140,27},{-140,65},{-156.9,65}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-200},
            {300,220}})),
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Examples/NonIntegratedPrimarySecondaryEconomizer.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<h4>System Configuration</h4>
<p>This example demonstrates the implementation of a chiller plant
with water-side economizer (WSE) to cool a data center. The system schematics is as shown below. </p>
<p>The system is a primary-secondary chiller plant with two chillers and a non-integrated WSE.</p>
<p>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Applications/DataCenters/ChillerCooled/Examples/NonIntegratedPrimarySecondaryEconomizer.png\"/>
</p>
<h4>Control Logic</h4>
<p>This section describes the detailed control logic used in this chilled water plant system.</p>
<h5>Cooling Mode Control</h5>
<p>The chilled water system with non-integrated waterside economizer can run in two modes:
free cooling (FC) mode, and fully mechanical cooling (FMC) mode.
The detailed control logics about how to switch between these two cooling modes are described in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingModeNonIntegrated\">
Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingModeNonIntegrated</a>.
Details on how the valves are operated under different cooling modes are presented in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Equipment.NonIntegrated\">
Buildings.Applications.DataCenters.ChillerCooled.Equipment.NonIntegrated</a>.
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
a critical value.
</li>
</ul>
<p>
The detailed implementation is shown in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.ChillerStage\">
Buildings.Applications.DataCenters.ChillerCooled.Controls.ChillerStage</a>.
</p>
<h5>Pump Staging Control </h5>
<p>
For constant speed pumps, the number of running pumps equals to the number of running chillers.
</p>
<p>
For variable speed pumps, the number of runing pumps is controlled by the speed signal and the mass flowrate.
Details are shown in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.VariableSpeedPumpStage\">
Buildings.Applications.DataCenters.ChillerCooled.Controls.VariableSpeedPumpStage</a>. And the speed is
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
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingTowerSpeed\">
Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingTowerSpeed</a>.
</p>
<p>
Note that for simplicity, the temperature and differential pressure reset control
are not implemented in this example.
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
end NonIntegratedPrimarySecondaryEconomizer;
