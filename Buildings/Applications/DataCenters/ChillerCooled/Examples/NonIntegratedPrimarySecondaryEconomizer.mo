within Buildings.Applications.DataCenters.ChillerCooled.Examples;
model NonIntegratedPrimarySecondaryEconomizer
  "Example that demonstrates a chiller plant with non-integrated primary-secondary side economizer"
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
          chiWSE.powChi) + sum(priPum.P) + sum(secPum.P) + ahu.PFan + ahu.PHea),
    PIT(y=roo.QSou.Q_flow));
  extends
    Buildings.Applications.DataCenters.ChillerCooled.Examples.BaseClasses.PartialDataCenter(
    redeclare Buildings.Applications.DataCenters.ChillerCooled.Equipment.NonIntegrated chiWSE(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=60),
    weaData(filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/DRYCOLD.mos")),
    CWPumCon(tWai=60),
    chiStaCon(tWai=60));

  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumSec(
    each pressure=
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m2_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
          dp=(dp2_wse_nominal+dpSetPoi+18000+30000)*{1.5,1.3,1.0,0.6}))
    "Performance data for secondary chilled water pumps";
  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumPri(
    each pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m2_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
          dp=(dp2_chi_nominal+6000)*{1.5,1.3,1.0,0.6}))
    "Performance data for secondary chilled water pumps";

  Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingModeNonIntegrated cooModCon(
    tWai=tWai,
    deaBan=1,
    TSwi=TCHWSet - 5)
    "Cooling mode controller"
    annotation (Placement(transformation(extent={{-212,100},{-192,120}})));

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
        origin={-40,-38})));
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
        origin={50,0})));
  Buildings.Applications.DataCenters.ChillerCooled.Controls.ConstantSpeedPumpStage
    priPumCon(tWai=0)
    "Chilled water primary pump controller"
    annotation (Placement(transformation(extent={{-172,20},{-152,40}})));
  Modelica.Blocks.Sources.RealExpression cooLoaChi(
    y=-ahu.port_a1.m_flow*4180*(TCHWRet.T - TCHWSupSet.y))
    "Cooling load in chillers"
    annotation (Placement(transformation(extent={{-212,130},{-192,150}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-200,-160},{-180,-140}})));
  Buildings.Fluid.Sensors.MassFlowRate bypFlo(
    redeclare package Medium = MediumW)
    "Sensor for bypass flowrate"
    annotation (Placement(transformation(extent={{66,-38},{46,-18}})));
equation
  for i in 1:numChi loop

    connect(chiOn[i].y, chiWSE.on[i])
      annotation (Line(
        points={{-109,140},{-80,140},{-80,37.6},{-1.6,37.6}},
        color={255,0,255}));
  end for;
  connect(TCHWSupSet.y, cooModCon.TCHWSupSet)
    annotation (Line(
      points={{-239,160},{-220,160},{-220,118},{-214,118}},
      color={0,0,127}));
  connect(weaBus.TWetBul.TWetBul, cooModCon.TWetBul)
    annotation (Line(
      points={{-328,-20},{-340,-20},{-340,200},{-226,200},{-226,114},{-214,114}},
      color={255,204,51},
      thickness=0.5));
  connect(chiStaCon.y, chiOn.u)
    annotation (Line(
      points={{-149,140},{-149,140},{-132,140}},
      color={0,0,127}));
  connect(intToBoo.y, wseOn.u)
    annotation (Line(
      points={{-149,110},{-149,110},{-132,110}},
      color={255,0,255}));
  connect(wseOn.y, chiWSE.on[numChi + 1])
    annotation (Line(
      points={{-109,110},{-80,110},{-80,37.6},{-1.6,37.6}},
      color={255,0,255}));
  connect(CWPumCon.y, gai.u)
    annotation (Line(
      points={{-151,70},{-132,70}},
      color={0,0,127}));
  connect(secPum.port_b, ahu.port_a1)
    annotation (Line(
      points={{-40,-48},{-40,-48},{-40,-114},{0,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(TCHWSup.port_b, secPum.port_a)
    annotation (Line(
      points={{-36,0},{-36,0},{-40,0},{-40,0},{-40,0},{-40,-28},{-40,-28}},
      color={0,127,255},
      thickness=0.5));
  connect(pumSpeSig.y, secPum.u)
    annotation (Line(
      points={{-99,-10},{-44,-10},{-44,-26}},
      color={0,0,127}));
  connect(cooLoaChi.y, chiStaCon.QTot)
    annotation (Line(
      points={{-191,140},{-172,140}},
      color={0,0,127}));
  connect(TCHWSup.T, cooModCon.TCHWSup)
    annotation (Line(
      points={{-26,11},{-26,18},{-226,18},{-226,106.2},{-214,106.2}},
      color={0,0,127}));
  connect(priPum.port_a, TCHWRet.port_b)
    annotation (Line(
      points={{60,-1.33227e-15},{80,-1.33227e-15},{80,0}},
      color={0,127,255},
      thickness=0.5));
  connect(chiWSE.port_a2, priPum.port_b)
    annotation (Line(
      points={{20,24},{32,24},{32,0},{32,0},{32,0},{32,0},{32,0},{32,0},{32,0},
          {32,0},{40,0},{40,0},{40,0},{40,1.33227e-15}},
      color={0,127,255},
      thickness=0.5));
  connect(priPum.port_a, bypFlo.port_a)
    annotation (Line(
      points={{60,-1.33227e-15},{74,-1.33227e-15},{74,-28},{66,-28}},
      color={0,127,255},
      thickness=0.5));
  connect(bypFlo.port_b, TCHWSup.port_a)
    annotation (Line(
      points={{46,-28},{-8,-28},{-8,0},{-8,0},{-8,0},{-16,0},{-16,0}},
      color={0,127,255},
      thickness=0.5));
  connect(TCHWSup.T, chiStaCon.TCHWSup)
    annotation (Line(
      points={{-26,11},{-26,12},{-26,12},{-26,18},{-180,18},{-180,134},{-172,
          134}},
      color={0,0,127}));
  connect(priPumCon.y, priPum.u)
    annotation (Line(
      points={{-151,30},{-20,30},{-20,12},{74,12},{74,4},{62,4}},
      color={0,0,127}));
  connect(cooModCon.numOnChi, chiNumOn.y)
    annotation (Line(
      points={{-214,102},{-220,102},{-220,65},{-236.9,65}},
      color={255,127,0}));
  connect(priPumCon.cooMod, cooModCon.y)
    annotation (Line(
      points={{-174,35},{-186,35},{-186,110},{-191,110}},
      color={255,127,0}));
  connect(cooModCon.y, CWPumCon.cooMod)
    annotation (Line(
      points={{-191,110},{-186,110},{-186,75},{-174,75}},
      color={255,127,0}));
  connect(chiStaCon.cooMod, cooModCon.y)
    annotation (Line(
      points={{-172,146},{-184,146},{-184,110},{-191,110}},
      color={255,127,0}));
  connect(cooModCon.y, intToBoo.u)
    annotation (Line(
      points={{-191,110},{-172,110}},
      color={255,127,0}));
  connect(cooModCon.y, sigCha.u)
    annotation (Line(
      points={{-191,110},{-186,110},{-186,202},{164,202},{164,160},{178,160}},
      color={255,127,0}));
  connect(chiNumOn.y, priPumCon.numOnChi) annotation (Line(points={{-236.9,65},
          {-188,65},{-188,25},{-174,25}}, color={255,127,0}));
  connect(cooModCon.y, cooTowSpeCon.cooMod) annotation (Line(points={{-191,110},
          {-186,110},{-186,182.444},{-172,182.444}}, color={255,127,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-360,-200},{300,220}})),
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Examples/NonIntegratedPrimarySecondaryEconomizer.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<h4>System Configuration</h4>
<p>This example demonstrates the implementation of a chiller plant
with water-side economizer (WSE) to cool a data center. The system schematics is as shown below. </p>
<p>The system is a primary-secondary chiller plant with two chillers and a non-integrated WSE.</p>
<p align=\"center\">
<img alt=\"image\"
src=\"modelica://Buildings/Resources/Images/Applications/DataCenters/ChillerCooled/Examples/NonIntegratedPrimarySecondaryEconomizerSystem.png\"/>
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
December 1, 2017, by Yangyang Fu:<br/>
Removed redundant connection <code>connect(dpSet.y, pumSpe.u_s)</code>
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
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-06));
end NonIntegratedPrimarySecondaryEconomizer;
