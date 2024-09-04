within Buildings.Applications.DataCenters.ChillerCooled.Examples;
model IntegratedPrimarySecondaryEconomizer
  "Example that demonstrates a chiller plant with integrated primary-secondary side economizer"
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
          chiWSE.powChi + chiWSE.powPum) + sum(secPum.P) + ahu.PFan + ahu.PHea),
    PIT(y=roo.QSou.Q_flow));
  extends
    Buildings.Applications.DataCenters.ChillerCooled.Examples.BaseClasses.PartialDataCenter(
    redeclare Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimarySecondary chiWSE(
        addPowerToMedium=false,
        perPum=perPumPri),
    weaData(filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/DRYCOLD.mos")));

  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumSec(
    each pressure=
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m2_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
          dp=(dp2_wse_nominal+dpSetPoi+18000+30000)*{1.5,1.3,1.0,0.6}))
    "Performance data for secondary chilled water pumps";
  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumPri(
    each pressure=
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m2_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
          dp=(dp2_chi_nominal+dp2_wse_nominal+6000)*{1.5,1.3,1.0,0.6}))
    "Performance data for secondary chilled water pumps";

  Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingMode
    cooModCon(
    tWai=tWai,
    deaBan1=1.1,
    deaBan2=0.5,
    deaBan3=1.1,
    deaBan4=0.5)
    "Cooling mode controller"
    annotation (Placement(transformation(extent={{-208,100},{-188,120}})));
  Modelica.Blocks.Sources.RealExpression towTApp(y=cooTow[1].TApp_nominal)
    "Cooling tower approach temperature"
    annotation (Placement(transformation(extent={{-328,100},{-308,120}})));

  Modelica.Blocks.Sources.RealExpression yVal5(
    y=if cooModCon.y == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical)
    then 1 else 0) "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{-60,32},{-40,52}})));
  Modelica.Blocks.Sources.RealExpression cooLoaChi(
    y=-chiWSE.port_a2.m_flow*4180*(chiWSE.TCHWSupWSE - TCHWSupSet.y))
    "Cooling load in chillers"
    annotation (Placement(transformation(extent={{-260,122},{-240,142}})));
  Buildings.Applications.BaseClasses.Equipment.FlowMachine_y secPum(
    redeclare package Medium = MediumW,
    dpValve_nominal=6000,
    per=perPumSec,
    addPowerToMedium=false,
    m_flow_nominal=m2_flow_chi_nominal,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Secondary pumps"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-46,-34})));
  Buildings.Applications.DataCenters.ChillerCooled.Controls.ConstantSpeedPumpStage
    PriPumCon(tWai=0)
    "Chilled water primary pump controller"
    annotation (Placement(transformation(extent={{-172,22},{-152,42}})));
  Modelica.Blocks.Math.Product priPumSpe[numChi] "Primary pump speed signal"
    annotation (Placement(transformation(extent={{-104,22},{-84,42}})));
  Modelica.Blocks.Sources.RealExpression notFreCoo(y=if cooModCon.y == Integer(
        Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling)
         then 0 else 1) "Not free cooling mode"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
equation
  connect(yVal5.y, chiWSE.yVal5)
    annotation (Line(points={{-39,42},{-20,42},{-20,33},{-1.6,33}},
                       color={0,0,127}));
  connect(cooLoaChi.y, chiStaCon.QTot)
    annotation (Line(
      points={{-239,132},{-184,132},{-184,140},{-172,140}},
      color={0,0,127}));
  connect(TCHWSup.port_b, secPum.port_a)
    annotation (Line(
      points={{-36,0},{-36,0},{-44,0},{-44,0},{-46,0},{-46,-24},{-46,-24}},
      color={0,127,255},
      thickness=0.5));
  connect(secPum.port_b, ahu.port_a1)
    annotation (Line(
      points={{-46,-44},{-46,-114},{0,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(pumSpeSig.y, secPum.u)
    annotation (Line(
      points={{-99,-10},{-78,-10},{-78,-10},{-50,-10},{-50,-22}},
      color={0,0,127}));

   for i in 1:numChi loop
    connect(pumCW[i].port_a, TCWSup.port_b)
      annotation (Line(
        points={{-50,110},{-50,140},{-42,140}},
        color={0,127,255},
        thickness=0.5));
   end for;
  connect(towTApp.y, cooModCon.TApp)
    annotation (Line(
      points={{-307,110},{-210,110}},
      color={0,0,127}));
  connect(TCHWRet.port_b, chiWSE.port_a2)
    annotation (Line(
      points={{80,0},{76,0},{76,24},{20,24}},
      color={0,127,255},
      thickness=0.5));
  connect(cooModCon.TCHWRetWSE, TCHWRet.T)
    annotation (Line(
      points={{-210,102},{-226,102},{-226,204},{148,204},{148,20},{90,20},{90,
          11}},
      color={0,0,127}));

  connect(chiWSE.TCHWSupWSE, cooModCon.TCHWSupWSE)
    annotation (Line(
      points={{21,34},{146,34},{146,202},{-222,202},{-222,106},{-210,106}},
      color={0,0,127}));
  connect(TCHWSupSet.y, cooModCon.TCHWSupSet)
    annotation (Line(
      points={{-239,160},{-214,160},{-214,118},{-210,118}},
      color={0,0,127}));
  connect(TCHWSup.T, chiStaCon.TCHWSup)
    annotation (Line(
      points={{-26,11},{-26,18},{-60,18},{-60,18},{-180,18},{-180,134},{-172,
          134}},
      color={0,0,127}));
  connect(PriPumCon.numOnChi, chiNumOn.y)
    annotation (Line(
      points={{-174,26},{-182,26},{-182,65},{-236.9,65}},
      color={255,127,0}));
  connect(PriPumCon.cooMod, cooModCon.y)
    annotation (Line(
      points={{-174,38},{-182,38},{-182,110},{-187,110}},
      color={255,127,0}));
  connect(cooTowSpeCon.cooMod, cooModCon.y)
    annotation (Line(
      points={{-172,182.444},{-182,182.444},{-182,110},{-187,110}},
      color={255,127,0}));
  connect(intToBoo.u, cooModCon.y)
    annotation (Line(
      points={{-172,110},{-187,110}},
      color={255,127,0}));
  connect(CWPumCon.cooMod, cooModCon.y)
    annotation (Line(
      points={{-174,76},{-182,76},{-182,110},{-187,110}},
      color={255,127,0}));
  connect(cooModCon.y, sigCha.u)
    annotation (Line(
      points={{-187,110},{-182,110},{-182,206},{150,206},{150,160},{178,160}},
      color={255,127,0}));
  connect(cooModCon.y, chiStaCon.cooMod) annotation (Line(points={{-187,110},{
          -182,110},{-182,146},{-172,146}}, color={255,127,0}));
  connect(notFreCoo.y, priPumSpe[1].u1) annotation (Line(points={{-119,40},{
          -114,40},{-114,38},{-106,38}}, color={0,0,127}));
  connect(notFreCoo.y, priPumSpe[2].u1) annotation (Line(points={{-119,40},{
          -114,40},{-114,38},{-106,38}}, color={0,0,127}));
  connect(PriPumCon.y, priPumSpe.u2) annotation (Line(points={{-151,32},{-114,
          32},{-114,26},{-106,26}}, color={0,0,127}));
  connect(priPumSpe.y, chiWSE.yPum) annotation (Line(points={{-83,32},{-20,32},
          {-20,26.5},{-1.5,26.5}}, color={0,0,127}));
  connect(weaBus.TWetBul, cooModCon.TWetBul) annotation (Line(
      points={{-327.95,-19.95},{-340,-19.95},{-340,200},{-218,200},{-218,114},{
          -210,114}},
      color={255,204,51},
      thickness=0.5));

  connect(plaOn.y, PriPumCon.on) annotation (Line(points={{-138,240},{-136,240},
          {-136,210},{-190,210},{-190,32},{-174,32}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-360,-200},{320,260}})),
  __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Examples/IntegratedPrimarySecondaryEconomizer.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<h4>System Configuration</h4>
<p>This example demonstrates the implementation of a chiller plant with
water-side economizer (WSE) to cool a data center. The system schematics is as shown below. </p>
<p>The system is a primary-secondary chiller plant with two chillers and an integrated WSE.</p>
<p align=\"center\">
<img alt=\"image\"
src=\"modelica://Buildings/Resources/Images/Applications/DataCenters/ChillerCooled/Examples/IntegratedPrimarySecondaryEconomizerSystem.png\"/>
</p>
<h4>Control Logic</h4>
<p>This section describes the detailed control logic used in this chilled water plant system.</p>
<h5>Cooling Mode Control</h5>
<p>The chilled water system with integrated waterside economizer can run in three modes:
free cooling (FC) mode, partially mechanical cooling (PMC) mode and fully mechanical cooling (FMC) mode.
The detailed control logics about how to switch among these three cooling modes are described in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingMode\">
Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingMode</a>.
Details on how the valves are operated
under different cooling modes are presented in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimarySecondary\">
Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimarySecondary</a>.
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
Buildings.Applications.BaseClasses.Controls.VariableSpeedPumpStage</a>. And the speed is
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
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingTowerSpeed\">
Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingTowerSpeed</a>.
</p>
<h5>Room temperature control</h5>
<p>
The room temperature is controlled by adjusting the fan speed of the AHU using a PI controller.
</p>
<p>
Note that for simplicity, the chilled water supply temperature and
differential pressure reset control are not implemented in this example.
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
November 29, 2017, by Michael Wetter:<br/>
Corrected conversion of enumeration.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1083\">issue 1083</a>.
</li>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StopTime=86400,
      Tolerance=1e-06),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end IntegratedPrimarySecondaryEconomizer;
