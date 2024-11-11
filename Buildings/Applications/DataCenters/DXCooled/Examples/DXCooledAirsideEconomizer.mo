within Buildings.Applications.DataCenters.DXCooled.Examples;
model DXCooledAirsideEconomizer
  "Example that illustrates the use of Buildings.Fluid.HeatExchanger.DXCoil in a data center room"
  extends Modelica.Icons.Example;
  extends
    Buildings.Applications.DataCenters.ChillerCooled.Examples.BaseClasses.PostProcess(
    fulMecCooSig(
      y=if cooModCon.y == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical)
      then 1 else 0),
    parMecCooSig(
      y=if cooModCon.y == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.PartialMechanical)
      then 1 else 0),
    PHVAC(y=varSpeDX.P + fan.P),
    PIT(y=roo.QRoo_flow),
    freCooSig(
      y=if cooModCon.y == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling)
      then 1 else 0));

  replaceable package Medium = Buildings.Media.Air "Medium model";

  // Air temperatures at design conditions
  parameter Modelica.Units.SI.Temperature TASup_nominal=286.15
    "Nominal air temperature supplied to room";
  parameter Modelica.Units.SI.Temperature TRooSet=298.15
    "Nominal room air temperature";
  parameter Modelica.Units.SI.Temperature TAirSupSet=291.13
    "Nominal room air temperature";
 /////////////////////////////////////////////////////////
  // Cooling loads
  parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=500000
    "Internal heat gains of the room";
  parameter Modelica.Units.SI.HeatFlowRate QRooC_flow_nominal=-2*QRooInt_flow;
 ////////////////////////////////////////////////////////////
 // DX Coil
  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=QRooC_flow_nominal/
      1006/(TASup_nominal - TRooSet) "Nominal air mass flow rate";
  parameter Modelica.Units.SI.HeatFlowRate QCoiC_flow_nominal=
      QRooC_flow_nominal "Cooling load of coil";
  parameter Real minSpeFan = 0.2
    "Minimum fan speed ratio required by variable speed fans";

  Buildings.Examples.ChillerPlant.BaseClasses.SimplifiedRoom roo(
    redeclare package Medium = Medium,
    rooLen=50,
    rooHei=3,
    rooWid=40,
    QRoo_flow=QRooInt_flow,
    m_flow_nominal=mA_flow_nominal,
    nPorts=2) "Simplified data center room"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed varSpeDX(
    redeclare package Medium = Medium,
    dp_nominal=400,
    datCoi=datCoi,
    minSpeRat=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
    T_start=303.15)
    "Variable speed DX coil"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-280,60},{-260,80}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-250,60},{-230,80}}),
        iconTransformation(extent={{-250,60},{-230,80}})));
  Buildings.Fluid.Movers.SpeedControlled_y fan(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    addPowerToMedium=false,
    per(pressure(V_flow=mA_flow_nominal*{0,2}/1.2, dp=500*{2,0})),
    use_riseTime=true) "Supply air fan" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={120,-94})));
  Modelica.Blocks.Sources.Constant TRooAirSet(k=TRooSet)
    "Room air temperature setpoint"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(
   redeclare package Medium = Medium,
   m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Modelica.Blocks.Sources.Constant SATSetPoi(k=TAirSupSet)
    "Supply air temperature set point"
    annotation (Placement(transformation(extent={{-240,90},{-220,110}})));
  parameter Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil datCoi(
    nSta=4,
    sta={
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=900/60,
        nomVal=
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal*(3/8),
          COP_nominal=3,
          SHR_nominal=0.8,
          TEvaIn_nominal=TRooSet,
          m_flow_nominal=mA_flow_nominal),
        perCur=
        Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_I()),
     Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1200/60,
        nomVal=
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal*(1/2),
          COP_nominal=3,
          SHR_nominal=0.8,
          TEvaIn_nominal=TRooSet,
          m_flow_nominal=mA_flow_nominal),
        perCur=
        Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_I()),
     Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal*(3/4),
          COP_nominal=3,
          SHR_nominal=0.8,
          TEvaIn_nominal=TRooSet,
          m_flow_nominal=mA_flow_nominal),
        perCur=
        Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_II()),
     Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal,
          COP_nominal=3,
          SHR_nominal=0.8,
          TEvaIn_nominal=TRooSet,
          m_flow_nominal=mA_flow_nominal),
        perCur=
        Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_III())})
        "Coil data"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Fluid.Actuators.Dampers.MixingBox eco(
    redeclare package Medium = Medium,
    mOut_flow_nominal=mA_flow_nominal,
    mRec_flow_nominal=mA_flow_nominal,
    mExh_flow_nominal=mA_flow_nominal,
    use_strokeTime=false,
    dpDamExh_nominal=0.27,
    dpDamOut_nominal=0.27,
    dpDamRec_nominal=0.27,
    dpFixExh_nominal=20,
    dpFixOut_nominal=20,
    dpFixRec_nominal=20) "Airside economizer"
    annotation (Placement(transformation(extent={{-160,-4},{-140,16}})));
  Buildings.Fluid.Sources.Outside out(
    redeclare package Medium = Medium,
    nPorts=2)
    "Boundary conditions for outside air"
    annotation (Placement(transformation(extent={{-220,0},{-200,20}})));
  Buildings.Applications.DataCenters.DXCooled.Controls.CoolingMode cooModCon(
    dT=1,
    tWai=120)
    "Cooling mode controller"
    annotation (Placement(transformation(extent={{-170,60},{-150,80}})));
  Buildings.Fluid.Actuators.Dampers.Exponential dam1(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal,
    dpDamper_nominal=0.27)
    "Open only when free cooling mode is activated"
    annotation (Placement(transformation(extent={{-20,2},{0,22}})));
  Buildings.Fluid.Actuators.Dampers.Exponential dam2(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal,
    y_start=0,
    dpDamper_nominal=0.27) "Open when mechanical cooling is activated"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemMixAir(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for mixed air"
    annotation (Placement(transformation(extent={{-130,2},{-110,22}})));
  Buildings.Applications.DataCenters.DXCooled.Controls.AirsideEconomizer ecoCon(
    minOAFra=0.05,
    Ti=240,
    gai=0.5)
    "Economzier controller"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Sources.RealExpression freCoo(
    y=if cooModCon.y == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling)
    then 1 else 0)
    "Set true if free cooling mode is on"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Modelica.Blocks.Math.Feedback feedback1
    "Feedback signal"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    "Constant output with value 1"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Buildings.Controls.Continuous.LimPID fanSpe(
    Td=1,
    yMin=minSpeFan,
    Ti=240,
    k=0.5,
    reverseActing=false)
    "Fan speed controller"
    annotation (Placement(transformation(extent={{80,-42},{100,-22}})));
  Buildings.Applications.DataCenters.DXCooled.Controls.Compressor speCon(
     k=1,
     Ti=120)
    "Speed controller for DX units"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(weaDat.weaBus, weaBus)
    annotation (Line(
      points={{-260,70},{-240,70}},
      color={255,204,51},
      thickness=0.5));
  connect(fan.port_a, senTemSupAir.port_b)
    annotation (Line(points={{120,-84},{120,-60},{50,-60}},
                                                          color={0,127,255}));
  connect(senTemSupAir.port_a, varSpeDX.port_b)
    annotation (Line(points={{30,-60},{0,-60}},
                  color={0,127,255}));
  connect(weaBus, out.weaBus)
    annotation (Line(
      points={{-240,70},{-240,10},{-230,10},{-230,10.2},{-220,10.2}},
      color={255,204,51},
      thickness=0.5));
  connect(dam2.port_b, varSpeDX.port_a)
    annotation (Line(points={{-70,-60},{-20,-60}},        color={0,127,255}));
  connect(dam1.port_b, senTemSupAir.port_a)
    annotation (Line(points={{0,12},{20,12},{20,-60},{30,-60}},
                                   color={0,127,255}));
  connect(SATSetPoi.y, cooModCon.TSupSet)
    annotation (Line(points={{-219,100},{-180,100},{-180,75},{-172,75}},
                                         color={0,0,127}));
  connect(eco.port_Sup, senTemMixAir.port_a)
    annotation (Line(points={{-140,12},{-130,12}},
                                               color={0,127,255}));
  connect(senTemMixAir.port_b, dam1.port_a)
    annotation (Line(points={{-110,12},{-20,12}},
      color={0,127,255}));
  connect(senTemMixAir.port_b, dam2.port_a)
    annotation (Line(points={{-110,12},{-100,12},{-100,-60},{-90,-60}},
                                           color={0,127,255}));
  connect(SATSetPoi.y, ecoCon.TMixAirSet)
    annotation (Line(points={{-219,100},{-134,100},{-134,86},{-122,86}},
                                                  color={0,0,127}));
  connect(senTemMixAir.T, ecoCon.TMixAirMea)
    annotation (Line(points={{-120,23},{-120,54},{-134,54},{-134,80},{-122,80}},
                                                color={0,0,127}));
  connect(ecoCon.y, eco.y)
    annotation (Line(points={{-99,80},{-92,80},{-92,40},{-150,40},{-150,18}},
                                                          color={0,0,127}));
  connect(feedback1.y, dam2.y)
    annotation (Line(points={{-21,130},{0,130},{0,40},{-80,40},{-80,-48}},
                            color={0,0,127}));
  connect(out.ports[1], eco.port_Out)
    annotation (Line(points={{-200,12},{-160,12}},color={0,127,255}));
  connect(eco.port_Exh, out.ports[2])
    annotation (Line(points={{-160,0},{-172,0},{-172,8},{-200,8}},
                             color={0,127,255}));
  connect(weaBus.TDryBul, cooModCon.TOutDryBul)
    annotation (Line(
      points={{-240,70},{-172,70}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(fan.port_b, roo.airPorts[1])
    annotation (Line(points={{120,-104},{120,-132},{52.475,-132},{52.475,-118.7}},
                                                            color={0,127,255}));
  connect(eco.port_Ret, roo.airPorts[2])
    annotation (Line(points={{-140,0},{-130,0},{-130,-132},{48.425,-132},{
          48.425,-118.7}},                                        color={0,127,
          255}));
  connect(const.y, feedback1.u1)
    annotation (Line(points={{-59,130},{-38,130}},
                                                 color={0,0,127}));
  connect(cooModCon.y, ecoCon.cooMod)
    annotation (Line(points={{-149,70},{-142,70},{-142,74},{-122,74}},
                              color={255,127,0}));
  connect(TRooAirSet.y, fanSpe.u_s)
    annotation (Line(points={{61,0},{68,0},{68,-32},{78,-32}},
                           color={0,0,127}));
  connect(roo.TRooAir, fanSpe.u_m)
    annotation (Line(points={{61,-110},{90,-110},{90,-44}},
                                color={0,0,127}));
  connect(fanSpe.y, fan.y)
    annotation (Line(points={{101,-32},{150,-32},{150,-94},{132,-94}},
                      color={0,0,127}));
  connect(roo.TRooAir, cooModCon.TRet)
    annotation (Line(points={{61,-110},{90,-110},{90,-88},{-180,-88},{-180,65},
          {-172,65}},                                      color={0,0,127}));
  connect(cooModCon.y, sigCha.u)
    annotation (Line(
      points={{-149,70},{-142,70},{-142,160},{178,160}},
      color={255,127,0}));
  connect(freCoo.y, dam1.y)
    annotation (Line(
      points={{-39,110},{-10,110},{-10,24}},
      color={0,0,127}));
  connect(freCoo.y, feedback1.u2)
    annotation (Line(
      points={{-39,110},{-30,110},{-30,122}},
      color={0,0,127}));
  connect(SATSetPoi.y, speCon.TMixAirSet)
    annotation (Line(
      points={{-219,100},{-72,100},{-72,-4},{-62,-4}},
      color={0,0,127}));
  connect(senTemSupAir.T, speCon.TMixAirMea)
    annotation (Line(
      points={{40,-49},{40,-28},{-72,-28},{-72,-10},{-62,-10}},
      color={0,0,127}));
  connect(cooModCon.y, speCon.cooMod)
    annotation (Line(
      points={{-149,70},{-142,70},{-142,60},{-76,60},{-76,-17},{-62,-17}},
      color={255,127,0}));
  connect(speCon.y, varSpeDX.speRat)
    annotation (Line(
      points={{-39,-10},{-28,-10},{-28,-52},{-21,-52}},
      color={0,0,127}));
  connect(weaBus.TDryBul, varSpeDX.TOut) annotation (Line(
      points={{-240,70},{-240,-40},{-40,-40},{-40,-57},{-21,-57}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-280,-200},{320,220}})),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/DXCooled/Examples/DXCooledAirsideEconomizer.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example illustrates how to use <a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed\">
Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed</a> in a cooling system for data center rooms.
</p>
<h4>System description</h4>
<p>
A air-cooled direct expansion (DX) cooling system with an airside economizer is used for a data center room.
For simplicity, the data center room has a constant cooling load. The DX cooling system includes a variable-speed
compressor, a cooling coil and a variable speed fun. The airside economizer is located before DX package to pre-cool
the mixed air.
</p>
<h4>Control logic</h4>
<h5>Cooling mode control</h5>
<p>
This system can run in three cooling modes: free cooling (FC) mode, partially mechanical cooling (PMC) mode and
fully mechanical cooling (FMC) mode.In FC mode, only the airside economizer is commanded to run. The supply air
temperature is maintained by adjusting the outdoor air damper. In PMC mode, the airside economizer and the DX
cooling coil are commanded to run together. And in FMC mode, only the DX cooling coil is commanded to run.
To avoid frequent switching,
a deadband of 1 Kelvin and a waiting time of 120 s are used.
</p>
<p>
A demonstration on how to switch among these three cooling modes is shown in
<a href=\"modelica://Buildings.Applications.DataCenters.DXCooled.Controls.Validation.CoolingMode\">
Buildings.Applications.DataCenters.DXCooled.Controls.Validation.CoolingMode</a>.
</p>
<h5>Supply air temperature control</h5>
<p>
In FC mode, the supply air temperature is controlled by adjusting outdoor air damper. In PMC mode, the outdoor air
damper is fully open, and the speed of compressor in the DX unit can be adjusted to maintain the supply air temperature.
In FMC mode, the outdoor air damper is fully closed and the supply air temperature is maintained by manipulating the
compressor speed. In this case, the supply air temperature setpoint is set as 18 &deg;C.
</p>
<h5>Room temperature control </h5>
<p>
The room temperature is maintained at 24&deg;C by adjusting the speed of the supply air fan.
</p>
</html>", revisions="<html>
<ul>
<li>
April 4, 2023, by Karthik Devaprasad:<br/>
Updated classes used in the coil data record <code>datCoi</code> as per the changed
class names.<br/>
Updated class used for variable speed DX cooling coil <code>varSpeDX</code>.
</li>
<li>
August 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StartTime=11880000,
      StopTime=12600000,
      Tolerance=1e-06),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end DXCooledAirsideEconomizer;
