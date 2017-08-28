within Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples;
model DXCooledDataCenter
  "Example that illustrates the use of Buildings.Fluid.HeatExchanger.DXCoil in a data center room"
  extends Modelica.Icons.Example;
  replaceable package Medium =
      Buildings.Media.Air;

  // Air temperatures at design conditions
  parameter Modelica.SIunits.Temperature TASup_nominal = 291.15
    "Nominal air temperature supplied to room";
  parameter Modelica.SIunits.Temperature TRooSet = 297.15
    "Nominal room air temperature";
  parameter Modelica.SIunits.Temperature SATSet = 290.93
    "Nominal room air temperature";
 /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow=
     1000 "Internal heat gains of the room";
  parameter Modelica.SIunits.HeatFlowRate QRooC_flow_nominal=
    -2*QRooInt_flow;
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal=
    1.3*QRooC_flow_nominal/1006/(TASup_nominal-TRooSet)
    "Nominal air mass flow rate, increased by factor 1.3";
  parameter Modelica.SIunits.TemperatureDifference dTFan = 2
    "Estimated temperature raise across fan that needs to be made up by the cooling coil";
  parameter Modelica.SIunits.HeatFlowRate QCoiC_flow_nominal=
    QRooC_flow_nominal
    "Cooling load of coil";

  Buildings.Examples.ChillerPlant.BaseClasses.SimplifiedRoom datCenRoo(
    nPorts=2,
    redeclare package Medium = Medium,
    rooLen=50,
    rooHei=3,
    rooWid=40,
    QRoo_flow=QRooInt_flow,
    m_flow_nominal=mA_flow_nominal)
    "Simplified data center room"
    annotation (Placement(transformation(extent={{38,32},{58,12}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed varSpeDX(
    redeclare package Medium = Medium,
    dp_nominal=400,
    datCoi=datCoi,
    minSpeRat=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=303.15)
    "Variable speed DX coil"
    annotation (Placement(transformation(extent={{26,-76},{46,-56}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data reader"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}}),
        iconTransformation(extent={{-140,40},{-120,60}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    addPowerToMedium=true)
    "Supply air fan"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={78,-18})));
  Modelica.Blocks.Sources.Constant mAir_flow(k=mA_flow_nominal)
    "Fan air flow rate"
    annotation (Placement(transformation(extent={{118,-28},{98,-8}})));
  Buildings.Controls.Continuous.LimPID dxSpe(
    Td=1,
    reverseAction=true,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=60,
    k=1)
    "Controller for variable speed DX coil"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(
   redeclare package Medium = Medium,
   m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{60,-60},{72,-72}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemRetAir(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal,
    T_start=303.15)
    "Temperature sensor for return air"
    annotation (Placement(transformation(extent={{-2,6},{-14,18}})));
  Modelica.Blocks.Sources.Constant SATSetPoi(k=SATSet)
    "Supply air temperature set point"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datCoi(
    nSta=4,
    sta={
    Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
        spe=900/60,
        nomVal=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal*(3/8),
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=mA_flow_nominal*(3/8)),
        perCur=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_I()),
     Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
        spe=1200/60,
        nomVal=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal*(1/2),
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=mA_flow_nominal*(1/2)),
        perCur=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_I()),
     Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal*(3/4),
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=mA_flow_nominal*(3/4)),
        perCur=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_II()),
     Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=mA_flow_nominal),
        perCur=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_III())})
        "Coil data"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Fluid.Actuators.Dampers.MixingBox eco(
    redeclare package Medium = Medium,
    mOut_flow_nominal=mA_flow_nominal,
    dpOut_nominal=20,
    mRec_flow_nominal=mA_flow_nominal,
    dpRec_nominal=20,
    mExh_flow_nominal=mA_flow_nominal,
    dpExh_nominal=20)
    "Airside economizer"
    annotation (Placement(transformation(extent={{-62,16},{-42,-4}})));
  Buildings.Fluid.Sources.Outside out(
    nPorts=2, redeclare package Medium = Medium)
    "Boundary conditions for outside air"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.BaseClasses.CoolingModeController
   cooModCon(tWai=1200)
    "Cooling mode controller"
    annotation (Placement(transformation(extent={{-90,82},{-70,102}})));
  Buildings.Fluid.Actuators.Dampers.Exponential dam1(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal)
    "Open only when free cooling mode is activated"
    annotation (Placement(transformation(extent={{26,-36},{46,-16}})));
  Buildings.Fluid.Actuators.Dampers.Exponential dam2(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal)
    "open when mechanical cooling is activated"
    annotation (Placement(transformation(extent={{-8,-76},{12,-56}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemMixAir(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal,
    T_start=303.15)
    "Temperature sensor for mixed air"
    annotation (Placement(transformation(extent={{-36,-6},{-24,6}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.BaseClasses.AirsideEconomizerController
  ecoCon(
    Ti=60,
    minOAFra=0.15,
    gai=1)
    "Economzier controller"
    annotation (Placement(transformation(extent={{-20,82},{-40,102}})));
  Modelica.Blocks.Sources.RealExpression freCoo(
    y = if cooModCon.cooMod < 0.5 then 1 else 0)
    "Set true if free cooling mode is on"
    annotation (Placement(transformation(extent={{100,66},{80,86}})));
  Modelica.Blocks.Math.Feedback feedback1
    "Feedback signal"
    annotation (Placement(transformation(extent={{60,90},{40,110}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    "Constant output with value 1"
    annotation (Placement(transformation(extent={{100,90},{80,110}})));
equation
  connect(weaDat.weaBus, weaBus)
    annotation (Line(
      points={{-140,50},{-140,50},{-130,50}},
      color={255,204,51},
      thickness=0.5));
  connect(varSpeDX.TConIn, weaBus.TWetBul)
    annotation (Line(points={{25,-63},{
          20,-63},{20,50},{-130,50}},color={0,0,127}));
  connect(datCenRoo.airPorts[1], fan.port_b)
    annotation (Line(points={{49.85,12},
          {49.85,12},{78,12},{78,-8}}, color={0,127,255}));
  connect(mAir_flow.y, fan.m_flow_in)
    annotation (Line(points={{97,-18},{94,-18},
          {90,-18}}, color={0,0,127}));
  connect(fan.port_a, senTemSupAir.port_b)
    annotation (Line(points={{78,-28},{78,-66},{72,-66}}, color={0,127,255}));
  connect(senTemSupAir.port_a, varSpeDX.port_b)
    annotation (Line(points={{60,-66},{60,-66},{46,-66}},
                  color={0,127,255}));
  connect(datCenRoo.airPorts[2], senTemRetAir.port_a)
    annotation (Line(points={{46.15,12},{14,12},{-2,12}},
                  color={0,127,255}));
  connect(senTemRetAir.port_b, eco.port_Ret)
    annotation (Line(points={{-14,12},{-28,12},{-42,12}},
                        color={0,127,255}));
  connect(weaBus, out.weaBus)
    annotation (Line(
      points={{-130,50},{-130,42},{-130,10.2},{-100,10.2}},
      color={255,204,51},
      thickness=0.5));
  connect(out.ports[1], eco.port_Exh)
    annotation (Line(points={{-80,12},{-72,12},{-62,12}},
                  color={0,127,255}));
  connect(out.ports[2], eco.port_Out)
    annotation (Line(points={{-80,8},{-74,8},{-74,0},{-62,0}},
            color={0,127,255}));
  connect(dam2.port_b, varSpeDX.port_a)
    annotation (Line(points={{12,-66},{12,-66},{26,-66}}, color={0,127,255}));
  connect(dam1.port_b, senTemSupAir.port_a)
    annotation (Line(points={{46,-26},{46,
          -26},{60,-26},{60,-66}}, color={0,127,255}));
  connect(SATSetPoi.y, cooModCon.SATSet)
    annotation (Line(points={{-119,100},{-92,100}}, color={0,0,127}));
  connect(cooModCon.OAT, weaBus.TDryBul)
    annotation (Line(points={{-92,95},{-108,95},{-108,50},{-130,50}},
                  color={0,0,127}));
  connect(cooModCon.OATDewPoi, weaBus.TDewPoi)
    annotation (Line(points={{-92,89},
          {-106,89},{-106,50},{-130,50}}, color={0,0,127}));
  connect(senTemRetAir.T, cooModCon.RAT)
    annotation (Line(points={{-8,18.6},{-8,
          50},{-104,50},{-104,84},{-92,84}}, color={0,0,127}));
  connect(eco.port_Sup, senTemMixAir.port_a)
    annotation (Line(points={{-42,0},{-36,0}}, color={0,127,255}));
  connect(senTemMixAir.port_b, dam1.port_a)
    annotation (Line(points={{-24,0},{0,0},{0,-26},{26,-26}},
      color={0,127,255}));
  connect(senTemMixAir.port_b, dam2.port_a)
    annotation (Line(points={{-24,0},{-20,
          0},{-20,-2},{-20,-66},{-8,-66}}, color={0,127,255}));
  connect(SATSetPoi.y, ecoCon.MATSet)
    annotation (Line(points={{-119,100},{-108,100},{-108,114},
      {0,114},{0,100},{-18,100}}, color={0,0,127}));
  connect(cooModCon.cooMod, ecoCon.cooMod)
    annotation (Line(points={{-69,92},{-60,
          92},{-60,114},{0,114},{0,92},{-18,92}}, color={0,0,127}));
  connect(senTemMixAir.T, ecoCon.MAT)
    annotation (Line(points={{-30,6.6},{-30,
          6.6},{-30,72},{0,72},{0,96},{-18,96}}, color={0,0,127}));
  connect(ecoCon.y, eco.y)
    annotation (Line(points={{-41,92},{-52,92},{-52,-6}}, color={0,0,127}));
  connect(SATSetPoi.y, dxSpe.u_s)
    annotation (Line(points={{-119,100},{-108,100},
          {-108,-30},{-102,-30}}, color={0,0,127}));
  connect(senTemSupAir.T, dxSpe.u_m)
    annotation (Line(points={{66,-72.6},{66,-72.6},
          {66,-90},{-90,-90},{-90,-42}}, color={0,0,127}));
  connect(dxSpe.y, varSpeDX.speRat)
    annotation (Line(points={{-79,-30},{20,-30},
          {20,-58},{25,-58}}, color={0,0,127}));
  connect(feedback1.y, dam2.y)
    annotation (Line(points={{41,100},{8,100},{8,-40},
          {2,-40},{2,-54}}, color={0,0,127}));
  connect(freCoo.y, dam1.y)
    annotation (Line(points={{79,76},{30,76},{30,0},{36,
          0},{36,-14}}, color={0,0,127}));
  connect(const.y, feedback1.u1)
    annotation (Line(points={{79,100},{58,100},{58,100}}, color={0,0,127}));
  connect(freCoo.y, feedback1.u2)
    annotation (Line(points={{79,76},{80,76},{80,
          76},{50,76},{50,92}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
            Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},
            {120,120}})),
    __Dymola_Commands(file="modelica://Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/AirCooled/Examples/DXCooledDataCenter.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example illustrates how to use <a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed</a> in a cooling system for data center rooms.  
</p>
<h4>System description</h4>
<p>
A air-cooled direct expansion (DX) cooling system with an airside economizer is used for a data center room. 
For simplicity, the data center room has a constant cooling load. The DX cooling system includes a variable-speed 
compressor, a cooling coil and a constant speed fun. The airside economizer is located before DX package to pre-cool
the mixed air.
</p>
<h4>Control logic</h4>
<h5>Cooling mode control</h5>
<p>
This system can run in three cooling modes: free cooling (FC) mode, partially mechanical cooling (PMC) mode and 
fully mechanical cooling (FMC) mode.In FC mode, only the airside economizer is commanded to run. The supply air
temperature is maintained by adjusting the outdoor air damper.In PMC mode, the airside economizer and the DX 
cooling coil are commanded to run together. And in FMC mode, only the DX cooling coil is commanded to run.
</p>
<p>
A demonstration on how to switch among these three cooling modes is shown in 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.BaseClasses.CoolingModeController\">
Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.BaseClasses.CoolingModeController</a>.
</p>
<h5>Supply air temperature control</h5>
<p>
In FC mode, the supply air temperature is controlled by adjusting outdoor air damper. In PMC mode, the outdoor air
damper is fully open, and the speed of compressor in the DX unit can be adjusted to maintain the supply air temperature.
In FMC mode, the outdoor air damper is fully closed and the supply air temperature is maintained by manipulating the 
compressor speed.
</p>
</html>", revisions="<html>
<ul>
<li>
August 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DXCooledDataCenter;
