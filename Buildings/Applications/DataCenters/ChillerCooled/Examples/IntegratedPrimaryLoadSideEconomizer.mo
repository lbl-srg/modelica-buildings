within Buildings.Applications.DataCenters.ChillerCooled.Examples;
model IntegratedPrimaryLoadSideEconomizer
  "Example that demonstrates a chiller plant with integrated primary load side economizer"
  extends Modelica.Icons.Example;
  extends
    Buildings.Applications.DataCenters.ChillerCooled.Examples.BaseClasses.PostProcess(
    freCooSig(
      y=if cooModCon.y == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling)
      then 1 else 0),
    parMecCooSig(
      y=if cooModCon.y == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.PartialMechanical)
      then 1 else 0),
    fulMecCooSig(
      y=if cooModCon.y == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical)
      then 1 else 0),
    PHVAC(y=cooTow[1].PFan + cooTow[2].PFan + pumCW[1].P + pumCW[2].P + sum(
          chiWSE.powChi + chiWSE.powPum) + ahu.PFan + ahu.PHea),
    PIT(y=roo.QSou.Q_flow));
  extends
    Buildings.Applications.DataCenters.ChillerCooled.Examples.BaseClasses.PartialDataCenter(
    redeclare Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimaryLoadSide chiWSE(
      addPowerToMedium=false,
      perPum=perPumPri),
    weaData(filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/DRYCOLD.mos")));

  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumPri(
    each pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
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
    annotation (Placement(transformation(extent={{-214,100},{-194,120}})));
  Modelica.Blocks.Sources.RealExpression towTApp(y=cooTow[1].TApp_nominal)
    "Cooling tower approach temperature"
    annotation (Placement(transformation(extent={{-320,100},{-300,120}})));
  Modelica.Blocks.Sources.RealExpression yVal5(
    y=if cooModCon.y == Integer(
    Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical)
    then 1 else 0)
    "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Modelica.Blocks.Sources.RealExpression yVal6(
    y=if cooModCon.y == Integer(
    Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling)
    then 1 else 0)
    "On/off signal for valve 6"
    annotation (Placement(transformation(extent={{-160,14},{-140,34}})));

  Modelica.Blocks.Sources.RealExpression cooLoaChi(
    y=-chiWSE.port_a2.m_flow*4180*(chiWSE.TCHWSupWSE - TCHWSupSet.y))
    "Cooling load in chillers"
    annotation (Placement(transformation(extent={{-320,130},{-300,150}})));
equation

  connect(pumSpeSig.y, chiWSE.yPum)
    annotation (Line(
      points={{-99,-10},{-60,-10},{-60,25.6},{-1.6,25.6}},
      color={0,0,127}));
  connect(TCHWSup.port_b, ahu.port_a1)
    annotation (Line(
      points={{-36,0},{-40,0},{-40,0},{-40,-114},{0,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(chiWSE.TCHWSupWSE, cooModCon.TCHWSupWSE)
    annotation (Line(
      points={{21,34},{148,34},{148,200},{-226,200},{-226,106},{-216,106}},
      color={0,0,127}));
  connect(cooLoaChi.y, chiStaCon.QTot)
    annotation (Line(
      points={{-299,140},{-172,140}},
      color={0,0,127}));
   for i in 1:numChi loop
    connect(pumCW[i].port_a, TCWSup.port_b)
      annotation (Line(
        points={{-50,110},{-50,140},{-42,140}},
        color={0,127,255},
        thickness=0.5));
   end for;
  connect(TCHWSupSet.y, cooModCon.TCHWSupSet)
    annotation (Line(
      points={{-239,160},{-222,160},{-222,118},{-216,118}},
      color={0,0,127}));
  connect(towTApp.y, cooModCon.TApp)
    annotation (Line(
      points={{-299,110},{-216,110}},
      color={0,0,127}));
  connect(TCHWRet.port_b, chiWSE.port_a2)
    annotation (Line(
      points={{80,0},{40,0},{40,24},{20,24}},
      color={0,127,255},
      thickness=0.5));
  connect(cooModCon.TCHWRetWSE, TCHWRet.T)
    annotation (Line(
      points={{-216,102},{-228,102},{-228,206},{152,206},{152,20},{90,20},{90,
          11}},
    color={0,0,127}));

  connect(cooModCon.y, chiStaCon.cooMod)
    annotation (Line(
      points={{-193,110},{-190,110},{-190,146},{-172,146}},
      color={255,127,0}));
  connect(cooModCon.y,intToBoo.u)
    annotation (Line(
      points={{-193,110},{-172,110}},
      color={255,127,0}));
  connect(TCHWSup.T, chiStaCon.TCHWSup)
    annotation (Line(
      points={{-26,11},{-26,18},{-182,18},{-182,134},{-172,134}},
      color={0,0,127}));
  connect(cooModCon.y, sigCha.u)
    annotation (Line(
      points={{-193,110},{-190,110},{-190,212},{156,212},{156,160},{178,160}},
      color={255,127,0}));
  connect(yVal5.y, chiWSE.yVal5) annotation (Line(points={{-139,40},{-84,40},{
          -84,33},{-1.6,33}}, color={0,0,127}));
  connect(yVal6.y, chiWSE.yVal6) annotation (Line(points={{-139,24},{-84,24},{
          -84,29.8},{-1.6,29.8}}, color={0,0,127}));
  connect(cooModCon.y, cooTowSpeCon.cooMod) annotation (Line(points={{-193,110},
          {-190,110},{-190,182.444},{-172,182.444}}, color={255,127,0}));
  connect(cooModCon.y, CWPumCon.cooMod) annotation (Line(points={{-193,110},{
          -190,110},{-190,75},{-174,75}}, color={255,127,0}));
  connect(weaBus.TWetBul, cooModCon.TWetBul) annotation (Line(
      points={{-328,-20},{-340,-20},{-340,200},{-224,200},{-224,114},{-216,114}},
      color={255,204,51},
      thickness=0.5));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-360,-200},{320,260}})),
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
<p align=\"center\">
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
<a href=\"modelica://Buildings.Applications.BaseClasses.Controls.VariableSpeedPumpStage\">
Buildings.Applications.BaseClasses.Controls.VariableSpeedPumpStage</a>. The speed is
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
<h5>Room temperature control</h5>
<p>
The room temperature is controlled by adjusting the fan speed of the AHU using a PI controller.
</p>
<p>
Note that for simplicity, the temperature and differential pressure reset control
are not implemented in this example.
</p>
</html>", revisions="<html>
<ul>
<li>
November 16, 2022, by Michael Wetter:<br/>
Corrected control to avoid cooling tower pumps to operate when plant is off, because
shut-off valves are off when plant is off.
</li>
<li>
November 1, 2021, by Michael Wetter:<br/>
Corrected weather data bus connection which was structurally incorrect
and did not parse in OpenModelica.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2706\">issue 2706</a>.
</li>
<li>
December 1, 2017, by Yangyang Fu:<br/>
Removed redundant connection <code>connect(dpSet.y, pumSpe.u_s)</code>
</li>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-06),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end IntegratedPrimaryLoadSideEconomizer;
