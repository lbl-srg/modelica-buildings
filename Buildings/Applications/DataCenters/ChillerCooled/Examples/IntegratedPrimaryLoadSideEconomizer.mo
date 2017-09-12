within Buildings.Applications.DataCenters.ChillerCooled.Examples;
model IntegratedPrimaryLoadSideEconomizer
  "Example that demonstrates a chiller plant with integrated primary load side economizer"
  extends Modelica.Icons.Example;
  extends Buildings.Applications.DataCenters.ChillerCooled.Examples.BaseClasses.PartialDataCenter(
    redeclare Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimaryLoadSide chiWSE(
      addPowerToMedium=false,
      perPum=perPumPri,
      tauPump=1,
      use_controller=false,
      use_inputFilter=true,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
      pumCW(each use_inputFilter=false,
            each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
      ahu(tauFan=1,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      use_inputFilterValve=true,
      use_inputFilterFan=true),
    weaData(filNam="modelica://Buildings/Resources/weatherdata/DRYCOLD.mos"),
    cooTowSpeCon(k=1, Ti=120));

  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumPri(
    each pressure=
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m2_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
          dp=(dp2_chi_nominal+dp2_wse_nominal+18000)*{1.5,1.3,1.0,0.6}))
    "Performance data for primary pumps";

  Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingMode
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
    y=if cooModCon.y == 3 then 1  else 0)
    "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Blocks.Sources.RealExpression yVal6(
    y=if cooModCon.y == 1 then 1 else 0)
    "On/off signal for valve 6"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  Modelica.Blocks.Sources.RealExpression cooLoaChi(
    y=chiWSE.port_a2.m_flow*4180*(chiWSE.TCHWSupWSE - TCHWSupSet.y))
    "Cooling load in chillers"
    annotation (Placement(transformation(extent={{-130,134},{-110,154}})));
equation

  connect(yVal5.y, chiWSE.yVal5)
    annotation (Line(points={{11,40},{40,40},{40,33},{118.4,33}},
                       color={0,0,127}));
  connect(yVal6.y, chiWSE.yVal6)
    annotation (Line(points={{11,20},{11,20},{40,20},{40,29.8},{118.4,29.8}},
                                   color={0,0,127}));
  connect(pumSpeSig.y, chiWSE.yPum)
    annotation (Line(points={{12.8,-14},{40,-14},{40,25.6},{118.4,25.6}},
                                   color={0,0,127}));
  connect(TCHWSup.port_b, ahu.port_a1)
    annotation (Line(
      points={{84,0},{70,0},{70,-4},{70,-116},{120,-116}},
      color={0,127,255},
      thickness=0.5));
  connect(chiWSE.TCHWSupWSE, cooModCon.TCHWSupWSE)
    annotation (Line(points={{141,34},{260,34},{260,200},{-150,200},{-150,106},
          {-132,106}},                                              color={0,0,127}));
  connect(cooLoaChi.y, chiStaCon.QTot)
    annotation (Line(points={{-109,144},{-80,144},{-80,140},{-52,140}},
                                                    color={0,0,127}));
   for i in 1:numChi loop
    connect(pumCW[i].port_a, TCWSup.port_b)
      annotation (Line(
        points={{70,110},{70,140},{78,140}},
        color={0,127,255},
        thickness=0.5));
   end for;
  connect(TCHWSupSet.y, cooModCon.TCHWSupSet)
    annotation (Line(points={{-169,160},
          {-150,160},{-150,118},{-132,118}}, color={0,0,127}));
  connect(towTApp.y, cooModCon.TApp)
    annotation (Line(points={{-169,110},{-170,110},
          {-168,110},{-132,110}}, color={0,0,127}));
  connect(weaBus.TWetBul.TWetBul, cooModCon.TWetBul)
    annotation (Line(points={{-200,-28},{-216,-28},{-216,200},{-150,200},
      {-150,114},{-132,114}},color={255,204,51},thickness=0.5));
  connect(TCHWRet.port_b, chiWSE.port_a2)
    annotation (Line(
      points={{220,0},{160,0},{160,24},{140,24}},
      color={0,127,255},
      thickness=0.5));
  connect(cooModCon.TCHWRetWSE, TCHWRet.T)
    annotation (Line(points={{-132,102},{
          -150,102},{-150,200},{260,200},{260,20},{230,20},{230,11}}, color={0,0,
          127}));
  connect(dpSet.y, pumSpe.u_s)
    annotation (Line(points={{-155,-20},{-128,-20}},
      color={0,0,127}));

  connect(cooModCon.y, cooTowSpeCon.cooMod)
    annotation (Line(points={{-109,110},{-109,110},{-100,110},{-100,182.444},{
          -52,182.444}},                                     color={255,127,0}));
  connect(cooModCon.y, chiStaCon.cooMod)
    annotation (Line(points={{-109,110},{-100,110},{-100,146},{-52,146}},
                                     color={255,127,0}));
  connect(cooModCon.y, reaToBoo.u)
    annotation (Line(points={{-109,110},{-80.5,110},
          {-52,110}}, color={255,127,0}));
  connect(TCHWSup.T, chiStaCon.TCHWSup)
    annotation (Line(points={{94,11},{94,11},{94,36},{40,36},{40,200},{-70,200},
          {-70,134},{-52,134}},                                    color={0,0,127}));
  connect(CWPumCon.cooMod, cooModCon.y) annotation (Line(points={{-54,75},{-100,
          75},{-100,110},{-109,110}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-240,-200},{300,
            220}})),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Examples/IntegratedPrimaryLoadSideEconomizer.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<h4>System Configuration</h4>
<p>This example demonstrates the implementation of a chiller plant
with water-side economizer (WSE) to cool a data center.
The system is a primary-only chiller plant with two chillers and
an integrated WSE located on the load side.
The system schematics is as shown below.
</p>
<p>
<img alt=\"image\"
src=\"modelica://Buildings/Resources/Images/Applications/DataCenters/ChillerCooled/Examples/IntegratedPrimaryLoadSideEconomizerSystem.png\"/>
</p>
<h4>Control Logic</h4>
<p>This section describes the detailed control logic used in this chilled water plant system.
</p>
<h5>Cooling Mode Control</h5>
<p>
The chilled water system with integrated waterside economizer can run in three modes:
free cooling (FC) mode, partially mechanical cooling (PMC) mode and fully mechanical cooling (FMC) mode.
The detailed control logics about how to switch among these three cooling modes are described in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingMode\">
Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingMode</a>. Details on how the valves are operated
under different cooling modes are presented in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimaryLoadSide\">
Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimaryLoadSide</a>.
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
Two chillers are commanded on when cooling mode is not FC and the cooling load served
by the chillers is larger than
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
For variable speed pumps, the number of running pumps is controlled by the speed signal and the mass flow rate.
Details are shown in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.VariableSpeedPumpStage\">
Buildings.Applications.DataCenters.ChillerCooled.Controls.VariableSpeedPumpStage</a>. The speed is
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
When in PMC mode, the fan is set to run at 100% speed to make the condenser water as cold as possible
and maximize the WSE output.
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
end IntegratedPrimaryLoadSideEconomizer;
