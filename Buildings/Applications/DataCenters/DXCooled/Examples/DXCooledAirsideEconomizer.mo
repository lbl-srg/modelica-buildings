within Buildings.Applications.DataCenters.DXCooled.Examples;
model DXCooledAirsideEconomizer
  "Example that illustrates the use of Buildings.Fluid.HeatExchanger.DXCoil in a data center room"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Air;

  // Air temperatures at design conditions
  parameter Modelica.SIunits.Temperature TASup_nominal = 286.15
    "Nominal air temperature supplied to room";
  parameter Modelica.SIunits.Temperature TRooSet = 297.15
    "Nominal room air temperature";
  parameter Modelica.SIunits.Temperature TAirSupSet = 291.13
    "Nominal room air temperature";
 /////////////////////////////////////////////////////////
  // Cooling loads
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow=
     50000 "Internal heat gains of the room";
  parameter Modelica.SIunits.HeatFlowRate QRooC_flow_nominal=
    -2*QRooInt_flow;
 ////////////////////////////////////////////////////////////
 // DX Coil
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal=
    QRooC_flow_nominal/1006/(TASup_nominal-TRooSet)
    "Nominal air mass flow rate";
  parameter Modelica.SIunits.HeatFlowRate QCoiC_flow_nominal=
    QRooC_flow_nominal
    "Cooling load of coil";
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
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed varSpeDX(
    redeclare package Medium = Medium,
    dp_nominal=400,
    datCoi=datCoi,
    minSpeRat=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
    T_start=303.15)
    "Variable speed DX coil"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data reader"
    annotation (Placement(transformation(extent={{-220,60},{-200,80}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-190,60},{-170,80}}),
        iconTransformation(extent={{-190,60},{-170,80}})));
  Buildings.Fluid.Movers.SpeedControlled_y fan(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    addPowerToMedium=false,
    per(pressure(V_flow=mA_flow_nominal*{0,1,2}/1.2, dp=500*{2,1,0})))
    "Supply air fan"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={180,-92})));
  Modelica.Blocks.Sources.Constant TRooAirSet(k=TRooSet)
    "Room air temperature setpoint"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.Continuous.LimPID dxSpe(
    Td=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.5,
    Ti=240,
    reverseAction=true)
    "Controller for variable speed DX coil"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(
   redeclare package Medium = Medium,
   m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Sources.Constant SATSetPoi(k=TAirSupSet)
    "Supply air temperature set point"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
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
          TEvaIn_nominal=TRooSet,
          m_flow_nominal=mA_flow_nominal),
        perCur=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_I()),
     Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
        spe=1200/60,
        nomVal=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal*(1/2),
          COP_nominal=3,
          SHR_nominal=0.8,
          TEvaIn_nominal=TRooSet,
          m_flow_nominal=mA_flow_nominal),
        perCur=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_I()),
     Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal*(3/4),
          COP_nominal=3,
          SHR_nominal=0.8,
          TEvaIn_nominal=TRooSet,
          m_flow_nominal=mA_flow_nominal),
        perCur=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_II()),
     Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal,
          COP_nominal=3,
          SHR_nominal=0.8,
          TEvaIn_nominal=TRooSet,
          m_flow_nominal=mA_flow_nominal),
        perCur=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_III())})
        "Coil data"
    annotation (Placement(transformation(extent={{160,80},{180,100}})));
  Buildings.Fluid.Actuators.Dampers.MixingBox eco(
    redeclare package Medium = Medium,
    mOut_flow_nominal=mA_flow_nominal,
    dpOut_nominal=20,
    mRec_flow_nominal=mA_flow_nominal,
    dpRec_nominal=20,
    mExh_flow_nominal=mA_flow_nominal,
    dpExh_nominal=20)
    "Airside economizer"
    annotation (Placement(transformation(extent={{-100,-4},{-80,16}})));
  Buildings.Fluid.Sources.Outside out(
    redeclare package Medium = Medium,
    nPorts=2)
    "Boundary conditions for outside air"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Controls.CoolingMode
    cooModCon(dT=1, tWai=120)
    "Cooling mode controller"
    annotation (Placement(transformation(extent={{-110,60},{-90,80}})));
  Buildings.Fluid.Actuators.Dampers.Exponential dam1(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal)
    "Open only when free cooling mode is activated"
    annotation (Placement(transformation(extent={{40,2},{60,22}})));
  Buildings.Fluid.Actuators.Dampers.Exponential dam2(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal,
    y_start=0)
    "open when mechanical cooling is activated"
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemMixAir(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for mixed air"
    annotation (Placement(transformation(extent={{-70,2},{-50,22}})));
  Controls.AirsideEconomizer
    ecoCon(
    minOAFra=0.05,
    Ti=240,
    gai=0.5)
    "Economzier controller"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Sources.RealExpression freCoo(y=if cooModCon.y == Integer(
        Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling)
         then 1 else 0)
      "Set true if free cooling mode is on"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Modelica.Blocks.Math.Feedback feedback1
    "Feedback signal"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    "Constant output with value 1"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  Buildings.Controls.Continuous.LimPID fanSpe(
    Td=1,
    yMin=minSpeFan,
    Ti=240,
    k=0.5,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    reverseAction=true)
    "Fan speed controller"
    annotation (Placement(transformation(extent={{140,-42},{160,-22}})));
equation
  connect(weaDat.weaBus, weaBus)
    annotation (Line(
      points={{-200,70},{-200,70},{-180,70}},
      color={255,204,51},
      thickness=0.5));
  connect(fan.port_a, senTemSupAir.port_b)
    annotation (Line(points={{180,-82},{180,-60},{110,-60}},
                                                          color={0,127,255}));
  connect(senTemSupAir.port_a, varSpeDX.port_b)
    annotation (Line(points={{90,-60},{90,-60},{60,-60}},
                  color={0,127,255}));
  connect(weaBus, out.weaBus)
    annotation (Line(
      points={{-180,70},{-180,70},{-180,10},{-170,10},{-170,10.2},{-160,10.2}},
      color={255,204,51},
      thickness=0.5));
  connect(dam2.port_b, varSpeDX.port_a)
    annotation (Line(points={{-10,-60},{-10,-60},{40,-60}},
                                                          color={0,127,255}));
  connect(dam1.port_b, senTemSupAir.port_a)
    annotation (Line(points={{60,12},{60,12},{80,12},{80,-60},{90,-60}},
                                   color={0,127,255}));
  connect(SATSetPoi.y, cooModCon.TSupSet)
    annotation (Line(points={{-159,100},{-120,
          100},{-120,75},{-112,75}},     color={0,0,127}));
  connect(eco.port_Sup, senTemMixAir.port_a)
    annotation (Line(points={{-80,12},{-80,12},{-70,12}},
                                               color={0,127,255}));
  connect(senTemMixAir.port_b, dam1.port_a)
    annotation (Line(points={{-50,12},{-50,12},{40,12}},
      color={0,127,255}));
  connect(senTemMixAir.port_b, dam2.port_a)
    annotation (Line(points={{-50,12},{-40,12},{-40,-60},{-30,-60}},
                                           color={0,127,255}));
  connect(SATSetPoi.y, ecoCon.TMixAirSet)
    annotation (Line(points={{-159,100},{-128,
          100},{-74,100},{-74,86},{-62,86}},      color={0,0,127}));
  connect(senTemMixAir.T, ecoCon.TMixAirMea)
    annotation (Line(points={{-60,23},{
          -60,54},{-74,54},{-74,80},{-62,80}},  color={0,0,127}));
  connect(ecoCon.y, eco.y)
    annotation (Line(points={{-39,80},{-32,80},{-32,40},{-90,40},{-90,18}},
                                                          color={0,0,127}));
  connect(SATSetPoi.y, dxSpe.u_s)
    annotation (Line(points={{-159,100},{-10,100},{-10,-20},{-2,-20}},
                                  color={0,0,127}));
  connect(senTemSupAir.T, dxSpe.u_m)
    annotation (Line(points={{100,-49},{100,-49},{100,-40},{10,-40},{10,-32}},
                                         color={0,0,127}));
  connect(dxSpe.y, varSpeDX.speRat)
    annotation (Line(points={{21,-20},{32,-20},{32,-52},{39,-52}},
                              color={0,0,127}));
  connect(feedback1.y, dam2.y)
    annotation (Line(points={{39,130},{58,130},{60,130},{60,40},{-20,40},{-20,-48}},
                            color={0,0,127}));
  connect(freCoo.y, dam1.y)
    annotation (Line(points={{21,110},{21,110},{50,110},{50,24}},
                        color={0,0,127}));
  connect(freCoo.y, feedback1.u2)
    annotation (Line(points={{21,110},{30,110},{30,122}},
                                color={0,0,127}));
  connect(out.ports[1], eco.port_Out)
    annotation (Line(points={{-140,12},{-100,12}},color={0,127,255}));
  connect(eco.port_Exh, out.ports[2])
    annotation (Line(points={{-100,0},{-112,0},
          {-112,8},{-140,8}},color={0,127,255}));
  connect(weaBus.TDryBul, cooModCon.TOutDryBul)
    annotation (Line(
      points={{-180,70},{-160,70},{-160,72},{-160,70},{-112,70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(fan.port_b, roo.airPorts[1])
    annotation (Line(points={{180,-102},{180,
          -102},{180,-132},{112.475,-132},{112.475,-118.7}},color={0,127,255}));
  connect(eco.port_Ret, roo.airPorts[2])
    annotation (Line(points={{-80,0},{-80,0},
          {-70,0},{-70,-132},{108.425,-132},{108.425,-118.7}},    color={0,127,
          255}));
  connect(const.y, feedback1.u1)
    annotation (Line(points={{1,130},{22,130}},  color={0,0,127}));
  connect(cooModCon.y, ecoCon.cooMod)
    annotation (Line(points={{-89,70},{-82,70},
          {-82,74},{-62,74}}, color={255,127,0}));
  connect(TRooAirSet.y, fanSpe.u_s)
    annotation (Line(points={{121,0},{128,0},{128,
          -32},{138,-32}}, color={0,0,127}));
  connect(roo.TRooAir, fanSpe.u_m)
    annotation (Line(points={{121,-110},{150,-110},
          {150,-82},{150,-44}}, color={0,0,127}));
  connect(fanSpe.y, fan.y)
    annotation (Line(points={{161,-32},{210,-32},{210,-92},
          {192,-92}}, color={0,0,127}));
  connect(roo.TRooAir, cooModCon.TRet)
    annotation (Line(points={{121,-110},{150,
          -110},{150,-88},{-120,-88},{-120,65},{-112,65}}, color={0,0,127}));
  connect(weaBus.TDryBul, varSpeDX.TConIn)
    annotation (Line(
      points={{-180,70},{-180,70},{-180,-20},{-180,-56},{-180,-56},{-180,-57},{39,
          -57}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
            Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,
            -160},{220,180}})),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DataCenters/DXCooled/Examples/DXCooledAirsideEconomizer.mos"
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
<a href=\"modelica://Buildings.Applications.DataCenters.Examples.BaseClasses.CoolingMode\">
Buildings.Applications.DataCenters.Examples.BaseClasses.CoolingMode</a>.
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
August 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StartTime=11880000,
      StopTime=12600000,
      Tolerance=1e-06));
end DXCooledAirsideEconomizer;
